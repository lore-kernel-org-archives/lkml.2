Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2GZUdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:33:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54218 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab2GZUdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:33:41 -0400
Message-ID: <1343334805.32120.13.camel@twins>
Subject: Re: thp and memory barrier assumptions
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        paulmck <paulmck@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Date: Thu, 26 Jul 2012 22:33:25 +0200
In-Reply-To: <1343334698.32120.11.camel@twins>
References: <1343334698.32120.11.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 22:31 +0200, Peter Zijlstra wrote:
> __do_huge_pmd_anonymous_page() contains:
> 
>                 /*
>                  * The spinlocking to take the lru_lock inside
>                  * page_add_new_anon_rmap() acts as a full memory
>                  * barrier to be sure clear_huge_page writes become
>                  * visible after the set_pmd_at() write.
>                  */
>                 page_add_new_anon_rmap(page, vma, haddr);
> 
> 
> page_add_new_anon_rmap() doesn't look to actually do a LOCK+UNLOCK
> except for unevictable pages.
> 
> But even if it did do an unconditional LOCK+UNLOCK that doesn't make a
> full memory barrier, see Documentation/memory-barriers.txt.
> 
> In particular:
> 
>         *A = a;
>         LOCK
>         UNLOCK
>         *B = b;
> 
> may occur as:
> 
>         LOCK, STORE *B, STORE *A, UNLOCK
> 


Also, what is that barrier() in handle_mm_fault() doing? And why doesn't
it have a comment explaining that?
