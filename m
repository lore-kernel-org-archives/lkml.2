Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1DEKOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 06:14:23 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:54578 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1DEKOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 06:14:22 -0400
Message-ID: <4D9AEB76.2060509@ahsoftware.de>
Date: Tue, 05 Apr 2011 12:14:14 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-omap@vger.kernel.org
Subject: Re: rtc-twl: catch22 in 2.6.37 and 2.6.38 when clock was never set
References: <4D99D5B0.6010503@ahsoftware.de>
In-Reply-To: <4D99D5B0.6010503@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 04.04.2011 16:29, schrieb Alexander Holler:

> it just happened here that the rechargeable backup battery for the RTC
> on a TPS65950 run out off power, because of some days while the device
> wasn't powered.
>
> Afterwards I couldn't read or set the clock with hwclock using a kernel
> 2.6.37.n or 2.6.38.n.
>
> I don't have a fix, but I think I've analyzed the problem and can offer
> a (bad) workaround.
>
> What happens is the following:
>
> When trying to read or set the clock with hwclock, the driver (rtc-twl)
> starts an alarm, but the irq for the alarm will never get called. The
> result is that a select in hwclock times out (for both operations, read
> or set).
>
> Because I had this clock running before, I've got the idea to try one of
> those old OMAP-kernels (2.6.32-angstrom) using the same userland.
> And with that kernel I could set the clock.
> Using 2.6.37 or 2.6.38 afterwards, hwclock did function again, both read
> an set are working.
>
> So it looks like there is a catch22 in kernels >=2.6.37 (I haven't
> tested .33-.36):
>
> When the clock was never set, the alarm(-irq) doesn't work, so hwclock
> doesn't work, so one can't set the clock.

It turns out that the missing/wrong initialization of the msecure line 
is the problem which disabled setting the clock. After doing that 
through a quick hack, I could set the clock.

I'm using a BeagleBoard C4, but I can't find any msecure initialization 
for other boards too.

What happened with those patches? E.g. those:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg16125.html

Regards,

Alexander
