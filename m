Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab0GEQkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 12:40:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0GEQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 12:40:39 -0400
Date: Mon, 5 Jul 2010 12:40:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending() (was: Linux 2.6.35-rc4)
Message-ID: <20100705164022.GA26995@infradead.org>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
 <20100705085550.GA26775@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705085550.GA26775@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had a thread about it a few days ago.  The following commit from
Jens' 2.6.36 tree needs to go into 2.6.35 to sort the issues with the
fragile wakeup mechanism which only got worse by the patches out:
	
	http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=79338d2a78ab78efdc1698f1309766a039addf9d
