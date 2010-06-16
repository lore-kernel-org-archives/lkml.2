Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab0FPVRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:17:12 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:26678 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753534Ab0FPVRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:17:10 -0400
Date: Wed, 16 Jun 2010 22:16:45 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: Lothar Wa?mann <LW@KARO-electronics.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Kerr <jeremy.kerr@canonical.com>,
       Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100616211645.GC30005@fluff.org.uk>
References: <19473.61547.684572.647641@ipc1.ka-ro>
 <201006111718.47426.jeremy.kerr@canonical.com>
 <19474.172.742782.972629@ipc1.ka-ro>
 <20100611095839.GC10894@pengutronix.de>
 <19474.2817.333749.485028@ipc1.ka-ro>
 <1276319643.1962.181.camel@pasglop>
 <19477.52889.982995.407051@ipc1.ka-ro>
 <1276507378.2552.39.camel@pasglop>
 <19477.63136.664249.167207@ipc1.ka-ro>
 <20100614094310.GE12159@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614094310.GE12159@pengutronix.de>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:43:10AM +0200, Uwe Kleine-K?nig wrote:
> On Mon, Jun 14, 2010 at 11:30:08AM +0200, Lothar Wa?mann wrote:
> > Benjamin Herrenschmidt writes:
> > > On Mon, 2010-06-14 at 08:39 +0200, Lothar Wa?mann wrote:
> > > > All implementations so far use spin_lock_irq_save()!
> > > 
> > > Nothing prevents your implementation to be a tad smarter.
> > > 
> > I vote for consistency, so that device drivers can be kept arch
> > independent instead of having to care about implentation details of
> > each arch.
> Back when I implemented clock support for ns9xxx (unfortunately not in
> mainline) I tried with a spinlock first and later switched to a mutex.
> IIRC the reason was that on ns9215 enabling the rtc clock took long
> (don't remember a number) and successfull enabling was signaled by an
> irq.  So I would have had to implement irq polling in the clock code.

Ok, you could have implemented a lock ot update the state, then had
some form of wake-queue to wake up the task once it did.

> I think you can find different examples that make both possiblities bad.
> All in all I think that a sleeping clock implementation is preferable as
> it improves (general) latencies.

It may be that we need to do a bit of work on some of the drivers to
ensure that they don't fully re-set their clocks until they are able
to sleep.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
