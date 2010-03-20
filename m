Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab0CTPGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 11:06:50 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:56754 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab0CTPGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 11:06:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19364.58488.817538.692599@pilspetsen.it.uu.se>
Date: Sat, 20 Mar 2010 16:06:32 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paulius Zaleckas <paulius.zaleckas@gmail.com>, nico@cam.org,
       rth@twiddle.net, nico@fluxnic.net, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, u.kleine-koenig@pengutronix.de,
       simon.kagstrom@netinsight.net, akpm@linux-foundation.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MTD: Fix Orion NAND driver compilation with ARM OABI
In-Reply-To: <1269086286.4028.6039.camel@macbook.infradead.org>
References: <20100320085507.4038.96426.stgit@pauliusz>
	<1269078083.4028.5586.camel@macbook.infradead.org>
	<badfd5ba1003200420xc0680c1h8b4cccd02a8fdaba@mail.gmail.com>
	<1269086286.4028.6039.camel@macbook.infradead.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse writes:
 > On Sat, 2010-03-20 at 13:20 +0200, Paulius Zaleckas wrote:
 > > On Sat, Mar 20, 2010 at 11:41 AM, David Woodhouse <dwmw2@infradead.org> wrote:
 > > > On Sat, 2010-03-20 at 10:55 +0200, Paulius Zaleckas wrote:
 > > >> -             uint64_t x;
 > > >> +             /*
 > > >> +              * force x variable to r2/r3 registers since ldrd instruction
 > > >> +              * requires first register to be even.
 > > >> +              */
 > > >> +             register uint64_t x asm ("r2");
 > > >> +
 > > >>               asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));
 > > >
 > > > Hm, isn't there an asm constraint which will force it into an
 > > > appropriate register pair?
 > > 
 > > Not that I know of...
 > > 
 > > > Failing that, "=&r2,r4,r6,r8" ought to work.
 > > 
 > > No, fails with error: matching constraint not valid in output operand
 > 
 > Hm, crap -- GCC on ARM doesn't let you give specific registers, so that
 > trick doesn't work.

I missed the start of this thread, but looking at orion_nand.c I fail to
see why you'd need to mess with inline asm for reading a sequence of u64
values from an I/O location to an array.

Rewriting that to proper C generates a nice ldrd;strd loop with my gcc-4.4.3.
