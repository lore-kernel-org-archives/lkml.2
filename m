Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828Ab0FPXea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 19:34:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:60590 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759576Ab0FPXe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 19:34:29 -0400
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
       Lothar Wa?mann <LW@KARO-electronics.de>,
       Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100616211645.GC30005@fluff.org.uk>
References: <19473.61547.684572.647641@ipc1.ka-ro>
	 <201006111718.47426.jeremy.kerr@canonical.com>
	 <19474.172.742782.972629@ipc1.ka-ro>
	 <20100611095839.GC10894@pengutronix.de>
	 <19474.2817.333749.485028@ipc1.ka-ro> <1276319643.1962.181.camel@pasglop>
	 <19477.52889.982995.407051@ipc1.ka-ro> <1276507378.2552.39.camel@pasglop>
	 <19477.63136.664249.167207@ipc1.ka-ro>
	 <20100614094310.GE12159@pengutronix.de>
	 <20100616211645.GC30005@fluff.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 09:33:51 +1000
Message-ID: <1276731231.2552.645.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 22:16 +0100, Ben Dooks wrote:
> > I think you can find different examples that make both possiblities
> bad.
> > All in all I think that a sleeping clock implementation is
> preferable as
> > it improves (general) latencies.
> 
> It may be that we need to do a bit of work on some of the drivers to
> ensure that they don't fully re-set their clocks until they are able
> to sleep. 

With the move of the interrupt disable we did upstream not long ago,
most drivers now can sleep at any stage of resume. sysdev's can't so
those are the main issue, but then, I don't like sysdevs :-)

I must say that on powermac I avoid some of these problems by, in
addition to the normal suspend/resume process, having some platform code
that (almost) blindly saves & restores a bunch of ASIC regs on late
suspend/early resume. It ends up being faster and simpler than going
through convolutions of suspend/resume callbacks left and right that
need to happen in the right order.

Cheers,
Ben.


