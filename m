Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab1CKVIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:08:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36062 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab1CKVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:07:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=w1gXa5tDrauQ7EHTV1fpsuQnCj9MU6pRwjlo04sWkYx7MT68um52O5W3w/7UaMaOEo
         sTM5xhbZ1OAu5Ni/a93naneh1PWWy0y+nt2g9lrbmzfmNPrx7ON/NUq6ExcTRk84wIvU
         bCONrrfZiyLxWffuxjMHEkY3NUMIfEvwdxQos=
Message-ID: <4D7A8F28.4080908@linaro.org>
Date: Fri, 11 Mar 2011 21:07:52 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <Pine.LNX.4.44L0.1103111406270.1975-100000@iolanthe.rowland.org> <4D7A80A4.6040008@linaro.org> <20110311202135.GA10795@kroah.com>
In-Reply-To: <20110311202135.GA10795@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 08:21 PM, Somebody in the thread at some point said:

>> Is a gadget driver a class driver?
>
> Some are, but you are now on the "other side" of the USB bus.

The goal of this is to allow board-specific data to define platform_data 
in any bus members.

>> Because I can set the MAC address for my g_ether from the kernel
>> commandline which is most definitely an "information source outside
>> the USB protocol".  That is exactly the kind of thing I am talking
>> about enabling also to be taken from usb_device->dev.platform_data.
>
> You don't have a usb_device for a gadget device.  USB Gadgets are a
> totally different world here, don't confuse them please.

Okay; but all that matters for this is that usb_gadget has a struct 
device composed in it, which in turn has a platform_data.  Gadget 
drivers can also benefit from the mapping scheme the same way.

I wrote up this RFC after a quick check struct device exists in the usb 
objects and grepping that nothing uses platform_data already.  If it 
isn't killed dead during this I will make workable patches for comment.

>> Using a .name defined to be the first member to match to specific
>> bus member devpath prepended with bus class:
>
> You can't rely on USB bus numbers to be the same EVER.  These are
> assigned by the host computer.

Alright: is there a better invariant nomenclature to talk about "the 
gadget / host that is running on a particular pair of pins"?  That's the 
ultimate definition of what's wired to what.

It's okay if the nomenclature differs for gadget or host because we can 
prepend a namepace token that is checked for before looking for a match 
in each case.

>> Well, it's an RFC so if you have a better plan I am all ears.
>
> I am totally confused, and as you are messing with bus id numbers, and
> confusing usb gadgets and drivers, I think you are as well.
>
> So, are you talking about USB gadgets, or USB drivers here?  They are
> different and have different requirements and responsibilities.

Both can make use of platform_data.  At the moment both gadget and host 
USB devices have NULL platform data members sitting there.  What this 
proposal is about is being able to teleport structs into those pointers 
from the board file, when gadget or host are instantiated that match. 
After that, drivers that are interested to take direction about anything 
can tell what they're willing to look at in their platform_data struct 
definition.

-Andy
