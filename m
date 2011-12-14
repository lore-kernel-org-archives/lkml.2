Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1LNHBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:01:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47015 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1LNHBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:01:05 -0500
Date: Wed, 14 Dec 2011 07:59:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: printk() vs tty_io
Message-ID: <20111214065910.GA25775@elte.hu>
References: <1323804803.9082.40.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323804803.9082.40.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> wrote:

> Hi tty folks,
> 
> I've been poking at reducing the constraints on printk(), like make it
> work under rq->lock etc..
> 
> Aside from a fwd port of the patch that abuses the 
> console_sem.lock: https://lkml.org/lkml/2011/6/9/298 and a few 
> other not so very pretty patches, I ran into the following 
> lockdep splat (using a not so very pretty lockdep 
> early_printk() patch):

btw., would be nice to also somehow realeasify those debug hacks 
to preserve them for eternity - doing all lockdep output as 
earlyprintk while keeping printks working is a great way to 
debug printk() itself.

Those printk lockups also took a *lot* of time for me to bisect.

Thanks,

	Ingo
