Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1LNJsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 04:48:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53952 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1LNJsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 04:48:39 -0500
Date: Wed, 14 Dec 2011 10:46:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: printk() vs tty_io
Message-ID: <20111214094643.GA8115@elte.hu>
References: <1323804803.9082.40.camel@twins>
 <20111214065910.GA25775@elte.hu>
 <1323855797.28489.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323855797.28489.22.camel@twins>
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

> On Wed, 2011-12-14 at 07:59 +0100, Ingo Molnar wrote:
> 
> > btw., would be nice to also somehow realeasify those debug 
> > hacks to preserve them for eternity - doing all lockdep 
> > output as earlyprintk while keeping printks working is a 
> > great way to debug printk() itself.
> > 
> > Those printk lockups also took a *lot* of time for me to 
> > bisect.
> 
> Yeah, they're horrible.. took me long enough to reproduce, and 
> even now I know how its not easy.
> 
> Anyway, I just posted the two patches that make lockdep do 
> early_printk(), they're not too horrid. [...]

Given how crutial lockdep is to analyzing lockups, i think this 
decoupling from printk() innards is a good idea in general.

[ It also rhymes well with the general principles of lockdep, to 
  create all of its infrastructure from scratch, to be able to 
  use it everywhere. ]

The small lprintk() ugliness we can live with i think.

Thanks,

	Ingo
