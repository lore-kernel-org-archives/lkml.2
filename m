Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab1CRRwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:52:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53927 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1CRRwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=O7F+ZQhNoEh+oIrSZziHu99nj4ASZowxoPgZketcl68KCxd5W5tZssAz83aMMZeBWu
         mVZmZJkK+VIYBw/AudSC88hTJ+W4ddL2YsoEtcuknrm3uylyV2/COUaJ6a33MKA2KDeE
         QZZKhgkNFhB0VP7KcdxOcW0rpxBTXraKml6gU=
Message-ID: <4D839BCD.6030202@linaro.org>
Date: Fri, 18 Mar 2011 17:52:13 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311165642.GA9996@kroah.com> <201103172333.01474.arnd@arndb.de> <4D82979B.2050003@linaro.org> <201103181600.09877.arnd@arndb.de>
In-Reply-To: <201103181600.09877.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 03:00 PM, Somebody in the thread at some point said:

Hi -

>> You changed your first opinion about tagging "dynamically probed
>> devices" with what is effectively platform_data, cool.
>
> I still don't like the idea of attaching platform_data to more
> devices, when we try to move people away from that in other
> parts of the kernel, because of the known deficiencies.

Whatever way you look at it, data delivered into the driver by Device 
Tree is fundamentally the same action as delivering data into the driver 
by platform_data.  Yes, you query by named element with device context, 
but you end up with the same answer as if you dereference a 
platform_data member.  There are no "known deficiencies" to 
platform_data for this action either, at least, not known to me, I don't 
think lack of typechecking on the pointer itself is an issue given the 
accuracy it can be targeted to a soldered-on-the-board device.

> Passing a MAC address in a device tree property is a
> well-established method that is used on many drivers, and
> is portable across operating systems and architectures.

If you're talking about Device Tree, that itself is not at all "well 
established" let alone servicing drivers from it.  Like I say I don't 
want to seem like I am down on it, but it is very new indeed let's face 
it and few drivers are using it for functional configuration information 
compared to vast numbers using platform_data.

=====> If Device Tree APIs is mandated to implement functionality fixes 
to drivers and platform_data is blocked for this, then we end up with 
different, rotting functionality for platform_data basis and drivers 
that remain broken on the many, many, platforms that don't have and will 
never have Device Tree.  That does NOT sound like the right approach.

I guess the grand plan is to eliminate platform_data by overwhelming it 
with Device Tree refactoring.  But each driver has to be tested and each 
board definition file changed... that is a huge, huge undertaking that 
will not happen in any kind of medium and perhaps not long term either.

So they will have to coexist for a very long while.  A policy of denying 
fixes to platform_data users by enforcing introduction of Device Tree 
APIs and making platform_data users out as troglodytes does not sound 
workable.

> We don't need to implement the entire binding. My point was that
> if we implement a way to attach a device_node to a usb_device, we
> should do it in a way that is compatible with that binding, rather
> than coming up with a new way.

That document is of no interest outside open firmware / Device Tree 
implementation since it is specific to it, and there is no value to 
reference it for a platform_data based solution.

> My impression so far is that attaching a struct device_node to
> static USB devices can be useful in general, but I wouldn't
> go so far to suggest using this for dynamically probed devices.

At least we agree there's no point to target pluggable devices with 
either solution, in which case platform_data and Device Tree provide the 
same end result, plus or minus extra query API.

By the way I intend shortly to extend my patchset to cover Panda WLAN 
case via probed MMC / SDIO device in the same way as USB.  So there will 
then be a second use case for my async platform_data patchset via a 
different subsystem.  Of course, maybe it just doubles the number of 
beatings ^^

-Andy
