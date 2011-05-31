Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1EaK2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:28:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20049 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752827Ab1EaK23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:28:29 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX194++CJRlTx9kSZxFIONrev
Date: Tue, 31 May 2011 03:28:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: rtc-twl: catch22 in 2.6.37 and 2.6.38 when clock was never set
Message-ID: <20110531102827.GT11352@atomide.com>
References: <4D99D5B0.6010503@ahsoftware.de>
 <4D9AEB76.2060509@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9AEB76.2060509@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Holler <holler@ahsoftware.de> [110405 03:11]:
> Hello,
> 
> Am 04.04.2011 16:29, schrieb Alexander Holler:
> 
> >it just happened here that the rechargeable backup battery for the RTC
> >on a TPS65950 run out off power, because of some days while the device
> >wasn't powered.
> >
> >Afterwards I couldn't read or set the clock with hwclock using a kernel
> >2.6.37.n or 2.6.38.n.
> >
> >I don't have a fix, but I think I've analyzed the problem and can offer
> >a (bad) workaround.
> >
> >What happens is the following:
> >
> >When trying to read or set the clock with hwclock, the driver (rtc-twl)
> >starts an alarm, but the irq for the alarm will never get called. The
> >result is that a select in hwclock times out (for both operations, read
> >or set).
> >
> >Because I had this clock running before, I've got the idea to try one of
> >those old OMAP-kernels (2.6.32-angstrom) using the same userland.
> >And with that kernel I could set the clock.
> >Using 2.6.37 or 2.6.38 afterwards, hwclock did function again, both read
> >an set are working.
> >
> >So it looks like there is a catch22 in kernels >=2.6.37 (I haven't
> >tested .33-.36):
> >
> >When the clock was never set, the alarm(-irq) doesn't work, so hwclock
> >doesn't work, so one can't set the clock.
> 
> It turns out that the missing/wrong initialization of the msecure
> line is the problem which disabled setting the clock. After doing
> that through a quick hack, I could set the clock.
> 
> I'm using a BeagleBoard C4, but I can't find any msecure
> initialization for other boards too.
> 
> What happened with those patches? E.g. those:
> 
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg16125.html

Looks like these need reposting. Maybe worth doing generic omap
RTC init code though?

Tony
