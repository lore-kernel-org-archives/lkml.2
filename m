Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0KWHt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:49:56 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36984 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab0KWHtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:49:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] mlock: release mmap_sem every 256 faulted pages
Cc: kosaki.motohiro@jp.fujitsu.com, Michel Lespinasse <walken@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>,
        Michael Rubin <mrubin@google.com>
In-Reply-To: <20101122215746.e847742d.akpm@linux-foundation.org>
References: <20101123050052.GA24039@google.com> <20101122215746.e847742d.akpm@linux-foundation.org>
Message-Id: <20101123164107.7BBC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:49:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 22 Nov 2010 21:00:52 -0800 Michel Lespinasse <walken@google.com> wrote:
> 
> > Hi,
> > 
> > I'd like to sollicit comments on this proposal:
> > 
> > Currently mlock() holds mmap_sem in exclusive mode while the pages get
> > faulted in. In the case of a large mlock, this can potentially take a
> > very long time.
> 
> A more compelling description of why this problem needs addressing
> would help things along.

Michel, as far as I know, now Michael Rubin (now I'm ccing him) are trying
to make automatic MM test suit. So if possible, can you please make
test case which reproduce your workload?

http://code.google.com/p/samplergrapher/


I hope to join to solve your issue. and I also hope you help to understand
and reproduce your issue. 

Thanks.

> 
> > +		/*
> > +		 * Limit batch size to 256 pages in order to reduce
> > +		 * mmap_sem hold time.
> > +		 */
> > +		nfault = nstart + 256 * PAGE_SIZE;
> 
> It would be nicer if there was an rwsem API to ask if anyone is
> currently blocked in down_read() or down_write().  That wouldn't be too
> hard to do.  It wouldn't detect people polling down_read_trylock() or
> down_write_trylock() though.

Andrew, yes it is certinally optimal. But I doubt it improve mlock
performance a lot. because mlock is _very_ slooooooow syscall.
lock regrabing may be cheap than it. So, _IF_ you can allow, I hope
we take a simple method at first. personally I think Michel move 
forwarding right way. then I don't hope to make a hardest hurdle.

Thanks.


