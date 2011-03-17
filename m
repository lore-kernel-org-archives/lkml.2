Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1CQXWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:22:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64003 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab1CQXWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:22:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=TeZ5baOqX/LuL5kfqdaR8vXWee3iybAskPCJfV4fjK2qtmHID+4u/CdYIl9DNe82rp
         Msn2zkZZECtDErx5lOdUkmlsKQvTJpT6gwsD4zHTVAKm2sQVUPJSQBqPHwPFEe3S1Cr8
         3tLEzin+Hu67puBFyH/HdALmMWK/9qnkYYQys=
Message-ID: <4D82979B.2050003@linaro.org>
Date: Thu, 17 Mar 2011 23:22:03 +0000
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
References: <20110311165642.GA9996@kroah.com> <20110317214042.GQ31411@opensource.wolfsonmicro.com> <20110317214736.GA29014@kroah.com> <201103172333.01474.arnd@arndb.de>
In-Reply-To: <201103172333.01474.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 10:33 PM, Somebody in the thread at some point said:
> On Thursday 17 March 2011 22:47:36 Greg KH wrote:
>>>> Patches to fix this, for this specific PandaBoard controller are gladly
>>>> accepted.  What's odd is this is explicitly a Linux development board,
>>>> so you would think that this could have been caught, and fixed, in the
>>>> hardware a long time ago, right?
>>>
>>> The way everyone resolves this stuff is by patching their kernel
>>> locally.
>>
>> Well, that means that the device tree work is going to be useful here,
>> right?  :)
>
> I like the idea. Let's make this the first use case where a lot of

You changed your first opinion about tagging "dynamically probed 
devices" with what is effectively platform_data, cool.

> people will want to have the device tree on ARM. The patch to the
> driver to check for a mac-address property is trivial, and we
> can probably come up with a decent way of parsing the device
> tree for USB devices, after all there is an existing spec for
> it (http://playground.sun.com/1275/bindings/usb/usb-1_0.ps).

It doesn't do it already then.

That spec you pointed to from 1998 is obviously going to be a whole 
subproject doing the binding, it seems to fingerprint devices by VID/PID 
if I understood it.

What's the plan for leveraging that level of generality on "dynamically 
probed devices"?  I mean I know what I want to use this for and the 
platform_data scheme covers all the soldered-on-the-board cases fine.

Is there actually a need for sort of not platform_data but universal 
vid_pid_specific_usb_device_option_data coming from the board definition 
file or bootloader for *pluggable* usb devices?  udev seems to be well 
established doing that already in a generic, not-platform-specific way 
that can go in all distros and so on nicely.  Maybe this is just my 
impoverished imagination and people do want, say, some kinds of USB mice 
to operate at higher DPI or whatever when plugged in a specific board 
because it is that board.

BTW the whole RFC patchset I sent was tested on real Panda, including 
the platform end which actually exists.

-Andy
