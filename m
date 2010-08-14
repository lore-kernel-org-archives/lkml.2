Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0HNB17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 21:27:59 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42151 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0HNB16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 21:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ejcn1ITQxC6NASSAVSmdeeBnPSavMh3iA9uV1x/Gv3XKJapZTEmCZZSE2BSjSHWaFS
         Q3g/fS8qh2ut7wdhbWULEILWxqWYSw3L7tQmrVcmjItC7DTZxNc4cxhfPcV83/6Bug4L
         nar55gvx9rXg98I30ht4br4BfAn6owMQ6S8aU=
MIME-Version: 1.0
In-Reply-To: <87sk2i45es.fsf@erwin.mina86.com>
References: <1281691874-8154-1-git-send-email-dries.vanpuymbroeck@dekimo.com>
	<AANLkTikk7T6v8zwzEQuZ7yDgf6AcdEfNJr7BG+z1O02n@mail.gmail.com>
	<87sk2i45es.fsf@erwin.mina86.com>
Date: Sat, 14 Aug 2010 09:27:57 +0800
Message-ID: <AANLkTin_o36qmavka+aJaDOBpNRGc=xxKdPdtWWUcVG8@mail.gmail.com>
Subject: Re: [PATCH] USB: Gadget: g_multi: added INF file for gadget with
 multiple configurations
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Dries Van Puymbroeck <dries.van.puymbroeck@gmail.com>,
        linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        =?ISO-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
        Dries Van Puymbroeck <dries.vanpuymbroeck@dekimo.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 4:35 AM, Michal Nazarewicz <mina86@mina86.com> wrote:
> Xiaofan Chen <xiaofanc@gmail.com> writes:
>
>> On Fri, Aug 13, 2010 at 5:31 PM, Dries Van Puymbroeck
>> <dries.van.puymbroeck@gmail.com> wrote:
>>> When a mutlifunction gadget has more than 1 configuration, Windows does not
>>> use its generic driver for multifunctional USB devices.
>>
>> Sorry but what do you mean by the above?
>> As per the previous discussions, it seems that a registry entry hack
>> (for Vista and Windows 7) is needed.
>> http://msdn.microsoft.com/en-us/library/ff538059%28VS.85%29.aspx
>>
>>> This commit adds an INF file that will load the required Windows driver
>>> as well as a short description in gadget_multi.txt
>>
>> It seems to me your inf file forces the USB Generic
>> Parent Driver (for USB Composite Device) to load. But for which
>> configuration? I do not have any device to test myself. But
>> I tend to guess it will still be the first configuration (either
>> RNDIS or CDC ECM).
>
> 2-configuration g_multi has configuration with RNDIS as the first one so
> that's pretty perfect for us.

I guess so. But I am wondering if the inf file really needed or not
in this case.

Basically I am just wondering if the following statement is true or not.
>>> When a mutlifunction gadget has more than 1 configuration, Windows does not
>>> use its generic driver for multifunction USB devices.

I am thinking the inf file is not necessary.
"When the system detects that a USB device is composite, it loads the
USB common class generic parent driver (usbccgp.sys)."
http://msdn.microsoft.com/en-us/library/ff538059%28VS.85%29.aspx

And since 1st configuration RNDIS is what desired, nothing needs to be done.

Obviously you have the device to test, I would be interested to know your
test results under XP, Vista and Win7.

-- 
Xiaofan
