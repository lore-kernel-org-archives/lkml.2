Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab0DHCh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 22:37:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913Ab0DHCh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 22:37:27 -0400
Date: Wed, 7 Apr 2010 19:33:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Rik van Riel <riel@redhat.com>, Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <20100408101925.FB9F.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org> <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org> <20100408101925.FB9F.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Apr 2010, KOSAKI Motohiro wrote:
> 
> Now pagefault don't insert anon_vma anymore, right? if so, SIGBUS is better.
> Now SIGBUS and VM_FAULT_OOM make different result.
> 
> SIGBUS       -> kill current task
> VM_FAULT_OOM -> invoke oom-killer (see pagefault_out_of_memory())

Yeah, maybe VM_FAULT_SIGBUS works ok instead of VM_FAULT_OOM. But the 
cause of it is the system having been oom when themappign was created, so 
I think either is fine.

> If current task can't recover proper anon_vma. we should just kill current
> instead random highest badness process. otherwise !anon_vma process continue
> to randomly invoke oom-killer.

Yes, that is a good point.

Anyway, I think it might be interesting to test my anon_vma_prepare() 
locking change patch together with Rik's _first_ version of his "fix 
anon_vma_prepare" thing (the one without the spinlock). They should apply 
independently of each other, and maybe it all even works together.

		Linus
