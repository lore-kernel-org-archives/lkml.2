Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0GESUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:20:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab0GESUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:20:14 -0400
Date: Mon, 5 Jul 2010 14:20:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending() (was: Linux 2.6.35-rc4)
Message-ID: <20100705182003.GA12332@infradead.org>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
 <20100705085550.GA26775@elte.hu>
 <20100705164022.GA26995@infradead.org>
 <20100705171125.GB26202@elte.hu>
 <20100705171420.GA29697@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705171420.GA29697@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 07:14:20PM +0200, Ingo Molnar wrote:
> Nor does it apply to v2.6.35-rc4:

It's indeed missing the two previous patches to the writeback code that
I thought Jens sent to Linus aswell [1].  The race was initially found using
a distro kernel with the patches backported, and in the meantime we've
done a lot of testing with this patch (and the two previous that also
were backported).  I'd prefer to get this full stack that's been in
-next for a while and got large machine testing, but if Jens prefers it
I can aim for a smaller variant.  Jens, what version do you prefer?

[1] thee patches are:

 "writeback: remove writeback_inodes_wbc"	a73dd720f081cd160e3843d531eff2195036e442
 "writeback: split writeback_inodes_wb"		9f98c0faa41ae334d894762f556195c8a7fb352f
