Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab0ELVI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab0ELVI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:08:27 -0400
Message-ID: <4BEB18BB.5010803@redhat.com>
Date: Wed, 12 May 2010 17:08:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/5] always lock the root (oldest) anon_vma
References: <20100512133815.0d048a86@annuminas.surriel.com> <20100512134029.36c286c4@annuminas.surriel.com> <20100512210216.GP24989@csn.ul.ie>
In-Reply-To: <20100512210216.GP24989@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 05:02 PM, Mel Gorman wrote:

> This last comment is a bit light. It's actually restoring the lock that
> was taken in 2.6.33 to some extent except we are always taking it now.
> In 2.6.33, it was resricted to
>
>         if (vma->anon_vma&&  (insert || importer || start != vma->vm_start))
>                  anon_vma = vma->anon_vma;
>
> but now it's always. Has it been determined that the locking in 2.6.33
> was insufficient or are we playing it safe now?

Playing it safe, mostly.

Another aspect is that, if you look at the if condition above,
the number of cases where we have an anon_vma and do not take
the lock is pretty small.

Basically only the case where we expand a VMA upward or merge
VMAs in an mprotect.  I believe in pretty much all other cases
we end up needing to take the lock.

I am not entirely convinced the old code took the lock in all
of the required cases.

-- 
All rights reversed
