Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0FXH1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:27:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49576 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab0FXH1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:27:42 -0400
Date: Thu, 24 Jun 2010 09:27:32 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: John Ogness <john.ogness@linutronix.de>
Cc: Ivo Clarysse <ivo.clarysse@gmail.com>,
       Sascha Hauer <kernel@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 4/5] mtd: mxc_nand fixups
Message-ID: <20100624072732.GQ12115@pengutronix.de>
References: <20100618205401.GA12115@pengutronix.de> <80sk4ivkga.fsf@merkur.tec.linutronix.de> <AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com> <80tyoyhxey.fsf_-_@merkur.tec.linutronix.de> <AANLkTikRj_dMkKLyFhW78yld9jIYAIFncfPaPAF8WqUY@mail.gmail.com> <80iq5bqd07.fsf_-_@merkur.tec.linutronix.de> <AANLkTimJKNEwOoKldq4a4_ufxNY6IY7r6tAfAM055hlW@mail.gmail.com> <80vd9ab0d2.fsf@merkur.tec.linutronix.de> <AANLkTinVaXjCneg-XpxB7YNlmGOwQFTnm5RUcetPdToI@mail.gmail.com> <80lja6awlb.fsf@merkur.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80lja6awlb.fsf@merkur.tec.linutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:19:15 up 16 days, 23:47, 44 users,  load average: 0.24, 1.52,
	1.28
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 12:10:08PM +0200, John Ogness wrote:
> On 2010-06-23, Ivo Clarysse <ivo.clarysse@gmail.com> wrote:
> > But is it OK to use a regular (non-volatile) variable to communicate
> > between interrupt context and the non-interrupt context ?
> 
> In this case, yes.
> 
> > My original patch for i.MX21 used completions instead:
> >
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2010-April/012694.html
> 
> Ah. It seems you've been through all this before. I wish I had noticed
> that thread before. I will need to check more carefully in the future.
> 
> Yes, your original patch achieves the exact same thing. Whether we use
> wait_event() with a flag or wait_completion() really is the same
> thing. So I guess Sascha can decide what we should do there.
> 
> What I like about your original patch is that only the i.MX21 has the
> cost of constantly enabling/disabling the irq line. It adds 5
> cpu_is_mx21() blocks to the code, but will lead to less work for the CPU
> on non-i.MX21 boards.

Ok, if it's the only way out to have 5 cpu_is_* blocks, then lets go for
it.

BTW I observed that at least on i.MX27 the latencies introduced by
waiting for an interrupt cause a significant performance drop. The
driver gets much faster when we just poll all the time. I don't know how
this affects system performance otherwise, but it may be a possibility
to drop interrupt support at least for i.MX21. I have no idea how long
the longest possible time we'd have to poll is though.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
