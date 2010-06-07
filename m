Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0FGQjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:39:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58603 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0FGQji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 12:39:38 -0400
Subject: Re: [PATCH 00/28] mm: preemptibility -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@firstfloor.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <87hble6brb.fsf@basil.nowhere.org>
References: <20100607110654.606530953@chello.nl>
	 <87hble6brb.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 18:39:31 +0200
Message-ID: <1275928771.1645.572.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 18:36 +0200, Andi Kleen wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> > This patch-set makes part of the mm a lot more preemptible. It converts
> > i_mmap_lock and anon_vma->lock to mutexes and makes mmu_gather fully
> > preemptible.
> 
> How about performance measurements?   mutexes still behave quite
> differently from spinlocks, especially under contention.

What's your favourite benchmark to stress i_mmap_mutex/anon_vma->lock?

a cache-hot kernel build didn't really show a difference..

