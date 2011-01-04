Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab1ADWut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:50:49 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:52567 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1ADWus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:50:48 -0500
Message-ID: <4D23A445.5050405@msgid.tls.msk.ru>
Date: Wed, 05 Jan 2011 01:50:45 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: VERY slow scrolling on radeon graphics card: debugging a	timing
 issue?
References: <4D0FC36D.9010304@msgid.tls.msk.ru> <20110102090001.GB32469@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20110102090001.GB32469@atrey.karlin.mff.cuni.cz>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.01.2011 12:00, Pavel Machek wrote:
> Hi!
> 
>> The thing is: that same scrolling becomes much faster
>> when I "do something" else while it scrolls up.  First
>> I noticed this when I wanted to switch to another vt
>> while it were scrolling -- I held down Ctrl key on my
>> keyboard, and out of the sudden the scroll speed up
>> dramatically.
>>
>> It turned out I can speed the thing to about 10 times
>> by generating some load: hit and hold a key on the
>> keyboard (generates interrupts?), run kernel compile
>> in the background (generates disk interrupts?), move
>> mouse...
> 
> Try "irqpoll"?

It turned out to be a bit less easy than I thought.

The thing is, it appears the issue is not triggered
on fresh boot - scrolling is reasonable fast there.
But slowness returns back after suspend-to-RAM cycle
(not suspend-to-disk).  I'm still trying ;)

> Will cpu load speed it up, too? (Like yes > /dev/null)?

Yes, CPU load fixes the issue immediately.  But switching
from ondemand to performance CPU governor does not fix it.

>> Any hints on where to go from there are apprecated.
>>
>> The hardware is an AMD780g-based motherboard with
>> and Athlon CPU, I've seen the same behavour from
>> many other similar boards.  Kernels - all up to
>> the current 2.6.36.2, sine the old days when kms
>> for radeon first appeared in staging.
> 
> Watch /proc/interrupts to see if radeon uses them and if they appear
> to work?

I don't see any change in radeon interrupt numbers during the
scrolling, so it's difficult to say.  The IRQ is shared between
several devices:

$ grep radeon /proc/interrupts
  18:  510439  370  IO-APIC-fasteoi ohci_hcd:usb3, ohci_hcd:usb4, ohci_hcd:usb5, radeon

The counter changes but very slowly (and not during the scroll
test when I don't touch anything), I see on correlation between
it any my actions.

Thanks!

/mjt
