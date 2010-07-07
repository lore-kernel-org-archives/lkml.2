Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0GGBrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:47:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59497 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0GGBru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:47:50 -0400
Date: Tue, 6 Jul 2010 21:47:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Jens Axboe <axboe@kernel.dk>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending()
Message-ID: <20100707014734.GA2950@infradead.org>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
 <20100705085550.GA26775@elte.hu>
 <20100705164022.GA26995@infradead.org>
 <20100705171125.GB26202@elte.hu>
 <20100705171420.GA29697@elte.hu>
 <20100705182003.GA12332@infradead.org>
 <4C323177.3070606@kernel.dk>
 <4C324C78.5090805@tmr.com>
 <AANLkTinLrbQNv9uKYZCAKS-kFPSdle3fvAMzjI77BCu2@mail.gmail.com>
 <20100706064733.GA12382@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100706064733.GA12382@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 08:47:33AM +0200, Ingo Molnar wrote:
> Yeah, i agree - especially since the smaller patch is still pretty large (not 
> a oneliner), plus it does not appear that the precise failure mode is fully 
> understood either.

The two failure modes we saw are very precicely understood:

 - access to ->state after it's been freed
 - access to ->state after the caller which has the bdi_work struct on
   stack has been woken up.

But I seriously fear that there are even more dragons hidden in this
maze of bit wakeups and rcu, so replacing it with a proper completion
seems by far safer to me.

