Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab1DHOgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:36:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51889 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab1DHOgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=podHDk1HnSiVkGafvaG+48uE9rAle8plXDjKM1NybXXqE8GXIKOKJDsAITjqTTwf1A
         wXl0IIisgOUB9RBmg8XpGyXKOL6HrRO0zY9pgxMkWZYr4CRbZWBhDI7J3TinHsWW1oXx
         dbZczFDdvM1rUOX2RxPfBqT3VtgHsHD1jiXYE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1104081017340.1992-100000@iolanthe.rowland.org>
References: <BANLkTikd606C54jgaynZ5pppKALfHiDc8Q@mail.gmail.com>
	<Pine.LNX.4.44L0.1104081017340.1992-100000@iolanthe.rowland.org>
Date: Fri, 8 Apr 2011 16:36:18 +0200
Message-ID: <BANLkTikj+=J3m7+1cOVHHcDqSCY7XeoCrw@mail.gmail.com>
Subject: Re: Endless loop with "detected XactErr"
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/8 Alan Stern <stern@rowland.harvard.edu>:
> On Thu, 7 Apr 2011, Zdenek Kabelac wrote:
>
>> Hi
>>
>> I've been trying to track some resume error with Intel GPU - and
>> notice a couple problems related to resume of my Lenovo T61.
>> Laptop has been docked - and suspend/resume has been performed without
>> 'undocking' laptop.
>>
>> After several iterations of suspend/resume - I've got this endless
>> printing loop with this line on console display:
>>
>> ehci_hcd 0000:00:1a.7: detected XactErr len 0/4 retry 1
>>
>> Just with changing last number - I've got only one such line on serial console.
>> By looking into  "drivers/usb/host/ehci-q.c"  - there seems to be
>> endless goto loop.
>
> It isn't endless.  You didn't notice the test against QH_XACTERR_MAX.
>

Maybe I've not been patient enough - but I'd been waiting for quite some time
and the console was just scrolling this line on display - so I need to
turn-off the machine.
(After like a minute of this looping)

>> From the log it looks like my USB mouse connected to docking station
>> was the source of problem.
>> (Maybe a movement ??)
>
> This particular error message indicates a hardware problem in the USB
> signals.  A bad contact, a bad cable, a device failure -- something
> like that.

Well it's been connected to Lenovo docking station - so unsure what
bad cable you mean here.
(and AFAICT it seems to work quite well all the time).

>
>> Here is the trace from last resume:
>
>> [  473.873802] ACPI: \_SB_.GDCK - undocking
>> [  473.897678] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0010
>> [  473.904809] ehci_hcd 0000:00:1a.7: detected XactErr len 0/4 retry 1
>
> And presumably additional lines containing similar messages.
>
> There's no real reason for them ever to stop, since they are only
> debugging messages.  If you turn off CONFIG_USB_DEBUG you'll never see
> tham.


You mean it's normal I get machine stuck in endless loop when I turn
on debugging ?
I though debug is there to debug the problem - not to add a new one ??
As this happened during suspend - I had no other option than to simply
turn off the machine.

Zdenek
