Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0HBHyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:54:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54097 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab0HBHyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:54:37 -0400
Date: Mon, 2 Aug 2010 09:54:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 11/19] perf record: Release resources at exit
Message-ID: <20100802075422.GA24085@elte.hu>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
 <1280711334-30000-12-git-send-email-acme@infradead.org>
 <20100802073009.GB7841@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802073009.GB7841@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3252]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> On Sun, Aug 01, 2010 at 10:08:46PM -0300, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > So that we can reduce the noise on valgrind when looking for memory
> > leaks.
> 
> Really? That's rather crappy of valgrind. exit is well defined to release 
> resources and that's often a more efficient way to do it It finds and 
> batches things a lot better, eg. it can avoid all TLB flushing of freeing 
> memory that munmap requires.

That's certainly true but there's no valgrind crappiness here: valgrind simply 
can do a better job of finding leaks if there's a well defined "all resources 
the app still knows about are freed now" point.

The _kernel_ obviously can release all resources. The distinction is between 
'resources known to the app' and 'all resources'. That set contains the 
leaking resources.

Thanks,

	Ingo
