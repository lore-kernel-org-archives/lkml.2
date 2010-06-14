Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0FNJnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:43:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33343 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab0FNJnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:43:20 -0400
Date: Mon, 14 Jun 2010 11:43:10 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Kerr <jeremy.kerr@canonical.com>,
       Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100614094310.GE12159@pengutronix.de>
References: <201006111557.12249.jeremy.kerr@canonical.com> <19473.61547.684572.647641@ipc1.ka-ro> <201006111718.47426.jeremy.kerr@canonical.com> <19474.172.742782.972629@ipc1.ka-ro> <20100611095839.GC10894@pengutronix.de> <19474.2817.333749.485028@ipc1.ka-ro> <1276319643.1962.181.camel@pasglop> <19477.52889.982995.407051@ipc1.ka-ro> <1276507378.2552.39.camel@pasglop> <19477.63136.664249.167207@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19477.63136.664249.167207@ipc1.ka-ro>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:30:08AM +0200, Lothar Waßmann wrote:
> Benjamin Herrenschmidt writes:
> > On Mon, 2010-06-14 at 08:39 +0200, Lothar Waßmann wrote:
> > > All implementations so far use spin_lock_irq_save()!
> > 
> > Nothing prevents your implementation to be a tad smarter.
> > 
> I vote for consistency, so that device drivers can be kept arch
> independent instead of having to care about implentation details of
> each arch.
Back when I implemented clock support for ns9xxx (unfortunately not in
mainline) I tried with a spinlock first and later switched to a mutex.
IIRC the reason was that on ns9215 enabling the rtc clock took long
(don't remember a number) and successfull enabling was signaled by an
irq.  So I would have had to implement irq polling in the clock code.

I think you can find different examples that make both possiblities bad.
All in all I think that a sleeping clock implementation is preferable as
it improves (general) latencies.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
