Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab1CVTgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:36:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64298 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1CVTgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=LPVdHFGj0QarFmvuQ8HHAlthrZnR6MSdj8P+ERK/5/ZRK5qkL00bHT2N0HaVlpXyVD
         2HNY+zY2UY/o2zNQ6+264bQBQIeFKccg7GWkqFVFNKe5Bh8kEuAtF2Ed/lavuh1NMQb9
         yRe7G5SsiVB04XKkHliqbQOv2BmQCtpETyYAo=
Message-ID: <4D88FA1C.4090804@linaro.org>
Date: Tue, 22 Mar 2011 19:35:56 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jaswinder Singh <jaswinder.singh@linaro.org>
CC: Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, benh@kernel.crashing.org, grant.likely@secretlab.ca,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org>	<AANLkTikEtneWEu4iQgfKw-zkAT3Z=e7ohXgDq7oJAQvv@mail.gmail.com>	<4D88C884.4020600@linaro.org>	<AANLkTikArWRWcJJRu-3rbJYanHxa4jKu2oovtLztUsk9@mail.gmail.com>	<4D88EC5C.9030809@linaro.org> <AANLkTimrH31ZE_ra6giWBun+Vp61V+3csghG5sOWk58h@mail.gmail.com>
In-Reply-To: <AANLkTimrH31ZE_ra6giWBun+Vp61V+3csghG5sOWk58h@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 06:59 PM, Somebody in the thread at some point said:
> On 23 March 2011 00:07, Andy Green<andy@warmcat.com>  wrote:
>> On 03/22/2011 06:19 PM, Somebody in the thread at some point said:
>
>>> If yes, isn't that possible by specifying a _Panda_ specific udev rule
>>> to find and rename a network interface based only on its type and
>>> devpath without needing its MAC address?  Greg ?
>>> The udev rule could be a part of some hwpack.
>>
>> We are in a privileged position to suggest to stick all kinds in our distro
>> support that's specific to the target, and maintain it.  However just doing
>> that relies on the current situation that people are cooking rootfs-es that
>> only work on one target.  With the move to multi-target single kernel
>> images, and the corresponding multi-target bootloader support along the same
>> lines that's coming, it'll eventually be possible to provide single SD
>> images that run on many targets with common rootfs.  Adding more static
>> hacks into hwpacks on the assumption it is "a panda rootfs" goes in the
>> wrong direction for that.
> Yes I know it's not a very elegant solution.
> But we must remember, we are catering to users that lose sleep over
> not having to call 'fixed RJ-45 port over USB' as eth0 :)

The characteristics of a kernel and userland solution are not the same 
though.

If we fix it via the kernel's definitive understanding of what board it 
is on, then I can put an, eg, fedora rootfs on it which doesn't have 
hwpack concept, and I get the same result.  The usb / eth thing is 
indeed cosmetic and trivial in one sense but in another it is a valid 
example IMO where it's the kernel's job to abstract the details of the 
actual board out properly so userland does not ever have to know.

> I was not just talking about mmc ->  sdio change. Rather the bus/port numbering.
> Say, mmc1:0001:2 becomes mmc7:0201:1 by some new addressing scheme.
> I agree the fix is as easy as it is to break old devpath assumption in
> this case.

OK so you and I at least agree that there is no reasonable "future 
proofing" issue here.

> And yes, bus numbering also depends on things like modprobe order, which may not
> be fixed for all platforms. Any change there too can break the devpath
> association.

Well it has been a big thread, but I made it clear already this async 
platform data stuff is only usable where the bus drivers and bus host 
instantiation are built-ins done in the machine definition file. 
They're the prerequisites for the determinism that is required, and it's 
the common SoC case that it is already so.

The actual device drivers themselves, like wl12xx, can be in modules 
though just fine, what is targeted is its path on a specified bus and 
that is set by the bus driver.  Whenever that logical device matching 
that path does get instantiated, it gets tagged and that is working for 
wl12xx case with the actual device driver in modules.

-Andy
