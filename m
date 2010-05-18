Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab0ERMym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:54:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:29586 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab0ERMyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p6nx3WeYwILBODkX88aYiM3YjouLxlwFzgTdDOIFoBezTVboa81lmHuQgiCTd6Fz64
         7CBzj2PmDuH3Pgdeg7UwKopTuiEGL4hHmwTG1vaAm5ZnAtCxjflVNxu1SJevE324p//A
         NZQXSsccSv2sHnQmeRcgZITyr0xfwtyJr28ag=
MIME-Version: 1.0
In-Reply-To: <AANLkTiltKYV6_usOnIhjg699vsnXVJ3vJlt63RfIfBJY@mail.gmail.com>
References: <AANLkTil73ArhX2w6b_v1bmWjP1FA5zUTfPzK2N4waOu1@mail.gmail.com>
	 <87tyq63eux.fsf@basil.nowhere.org>
	 <AANLkTiktV26Xu_qXFPdTRMLe5UwWnjpqvEKitjRElF6R@mail.gmail.com>
	 <1274102511.4418.18.camel@mulgrave.site>
	 <AANLkTil9lmdG5LY2SFk3cMsPOK-gUm2diMFL_o5bT08u@mail.gmail.com>
	 <1274106526.4418.40.camel@mulgrave.site>
	 <alpine.DEB.2.01.1005172258360.27232@asgard.lang.hm>
	 <AANLkTiltKYV6_usOnIhjg699vsnXVJ3vJlt63RfIfBJY@mail.gmail.com>
Date: Tue, 18 May 2010 14:54:36 +0200
Message-ID: <AANLkTimmIonDEg91eR4dgw6aLAOd6GsGJWs0e2Ocunwt@mail.gmail.com>
Subject: Re: [ANNOUNCE] GSoC project: Improving kconfig using a SAT solver
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: david@lang.hm, James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Bart Massey <bart@cs.pdx.edu>,
       Michal Marek <mmarek@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 May 2010 14:26, Jon Smirl <jonsmirl@gmail.com> wrote:
> On Tue, May 18, 2010 at 2:03 AM,  <david@lang.hm> wrote:
>> There are two modes people can be in when configuring a kernel.
>>
>> 1. I want to configure a kernel to support my hardware, enable anything else
>> needed to make it work.
>>
>> 2. I really care about having a small kernel, don't enable anything I have
>> disabled (but help me figure out why something I want isn't available)
>>
>> I don't think that hiding hardware from the user is ever the best thing to
>> do. for approach #1 you obviously don't want to hide anything, but even for
>> approach #2, someone may not realize that by disabling one option they are
>> making it impossible to support something, and as someone who spent a bunch
>> of time hunting through config to find options that I ended up finding were
>> not available without enabling something else, I much prefer to see the
>> option, but see it disabled rather than not being sure if it should be
>> there, or somewhere else in the config.
>
> I have to agree with this. An example is audio drivers that disappear
> because something like SPI is turned off. Sometimes I have to read the
> Kconfig files to figure out what subsystems I need enabled in order to
> make the driver appear as a choice.
>
> Another way this could work...
> Enable the platform
> this causes all subsystems on the platform (usb, spi, pci, etc) to be
> soft enabled
> user selects device drivers or hard enables the subsystem
> on save, if the subsystem wasn't hard enabled for some reason or
> dependency, disable it.
>
> ---------------
>
> I'd also find it useful if Kconfig had an option that analyzed the
> system it is running on and then generated the minimal set of drivers
> needed to support it. Assume that the system is running something like
> the Ubuntu kernel with every driver enabled. Then figure out the
> minimal build footprint for a custom kernel to support the same
> hardware.  I do this by hand, but a button for doing it would be a lot
> easier.

Consider this a response to both of the above e-mails. Just to clear
any confusion, a consequence of using SAT for kconfig is that you can
now say for example only the following: "I want drivers A, B, and C. I
don't care if that means I can't use FOO and I don't care if that
means that I have to use BAR, just give me A, B, and C."

I suppose another way to see it is that configuring the kernel using
the current menuconfig is a top-down process, since you have to select
USB before you can select any driver that depends on USB. Using SAT
for kconfig puts this on its head, and the configuration process
becomes bottom-up; you say only what you want to have (or not have),
and the system figures out the rest. If you choose a driver that
requires USB (and you haven't said that you also don't want USB
support, which would be impossible), then USB _will_ be enabled
automatically.

For the record, I think that there are already scripts that take a
running system and builds a config for that.


Vegard
