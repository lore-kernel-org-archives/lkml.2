Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1C0W3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 18:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab1C0W3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 18:29:16 -0400
Message-ID: <4D8FBA31.7080707@redhat.com>
Date: Sun, 27 Mar 2011 18:29:05 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH]: SMBIOS: Add initial code and export version via sysfs
References: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com>	<20110317193023.GA16790@kroah.com>	<4D826718.3030001@redhat.com>	<20110317200701.GB17827@kroah.com>	<4D8772B6.80302@redhat.com> <20110321160608.42dc371b@lxorguk.ukuu.org.uk>
In-Reply-To: <20110321160608.42dc371b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/21/2011 12:06 PM, Alan Cox wrote:
>> In this way we would limit the amount of change to external packages
>> (ie, initscripts, network init, etc.) to hopefully only filename changes.
>>     
> Why change them at all. SMBIOS provides everything DMI BIOS interfaces
> did, so we should just continue to provide them to userspace exactly as
> before, but possibly sourced from other locations. There simply isn't a
> need to break anything user side. Maybe in five or ten years time someone
> will delete the old stuff as nobody uses it any more but it's not an item
> that needs hurrying.
>   

I'm sorry Alan -- I meant to say that the change would be minimal -- it
is likely with a new sysfs mapping that
/sys/devices/virtual/id/dmi would stay the same, but I'm not willing to
guarantee it.

It *might* turn out to be /sys/devices/virtual/id/smbios/dmi .

I'm really not sure which I prefer.

> Also distinguish between DMI and the DMI BIOS interfaces, the two are
> rather different beasts.
>
>   
>> drivers & subsystems to link back to the files.  Of course, the SMBIOS code
>> would provide lookup functions similar to the ones provided by the existing
>> DMI code to aid drivers in their lookups.
>>     
> I'm wondering why put all the SMBIOS complexity into the kernel, but then
> I wonder likewise about some of the DMI stuff still 8)
>
>   

Well, like I said before, there are several drivers that are each doing
their own thing.  Given the past history of the kernel this should be
centralized to one location.  Having drivers each "dig" through mem is
not the best thing IMO.

>> 3.  Modify drivers to use the new SMBIOS table lookups, etc, instead of
>> DMI table lookups.  This is relatively easy, IMO.  I will try to keep
>> dmi* functions identical to the new smbios* lookup functions.  That code
>> works
>> well, and isn't in need of change.
>>     
> I'd actually suggest one change. In using dmi_ naming and DMI alone the
> original code made the assumption it was a PC specific tool for doing
> fixups and the like. If we are going to tweak it then we should probably
> recognize that want the kernel needs to provide to drivers isn't (for the
> most case) SMBIOS lookup it's generic "Platform name" etc and these could
> have been populated from things other than SMBIOS (OpenFirmware,
> DeviceTree, whatever).
>
>   

Good idea :)  Thanks -- I'll incorporate that into my next proposal. 
IMO that's much better ... and it lends its hand to other arches if they
wish to do it.

> It doesn't really change the interface but if you are going to be
> renaming things maybe a better naming would be worth it ?
>
>   

IMO yes.  The more general the better IMO.  Why have several different
Platform Firmware implementations.

So .. maybe /sys/devices/virtual/platform ?  I dunno ... maybe someone
reading can come up with a better idea.


>> 5.  After a release (or some other set period of time defined in
>> feature-removal-schedule.txt), remove the old DMI code.
>>     
> This is a user API so really it wants to hang around for a long time, and
> given SMBIOS can just provide the same names as well trivially it might
> as well just stay there until no distro is using it, then get a _LEGACY
> config, then vanish. Think multiples of years.
>
>   

Okay.  Will do.

P.
> Alan
>   
