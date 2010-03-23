Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0CWSAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:00:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37050 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab0CWSAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:00:22 -0400
Date: Tue, 23 Mar 2010 19:00:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org, ant.starikov@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge
 regression in performance
Message-ID: <20100323180002.GA2965@elte.hu>
References: <bug-15618-10286@https.bugzilla.kernel.org/>
 <20100323102208.512c16cc.akpm@linux-foundation.org>
 <20100323173409.GA24845@elte.hu>
 <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 23 Mar 2010, Ingo Molnar wrote:
> > 
> > It shows a very brutal amount of page fault invoked mmap_sem spinning 
> > overhead.
> 
> Isn't this already fixed? It's the same old "x86-64 rwsemaphores are using 
> the shit-for-brains generic version" thing, and it's fixed by
> 
> 	1838ef1 x86-64, rwsem: 64-bit xadd rwsem implementation
> 	5d0b723 x86: clean up rwsem type system
> 	59c33fa x86-32: clean up rwsem inline asm statements

Ah, indeed!

> NOTE! None of those are in 2.6.33 - they were merged afterwards. But they 
> are in 2.6.34-rc1 (and obviously current -git). So Anton would have to 
> compile his own kernel to test his load.

another option is to run the rawhide kernel via something like:

	yum update --enablerepo=development kernel

this will give kernel-2.6.34-0.13.rc1.git1.fc14.x86_64, which has those 
changes included.

OTOH that kernel has debugging [lockdep] enabled so it might not be 
comparable.

> We could mark them as stable material if the load in question is a real load 
> rather than just a test-case. On one of the random page-fault benchmarks the 
> rwsem fix was something like a 400% performance improvement, and it was 
> apparently visible in real life on some crazy SGI "initialize huge heap 
> concurrently on lots of threads" load.
> 
> Side note: the reason the spinlock sucks is because of the fair ticket 
> locks, it really does all the wrong things for the rwsem code. That's why 
> old kernels don't show it - the old unfair locks didn't show the same kind 
> of behavior.

Yeah.

	Ingo
