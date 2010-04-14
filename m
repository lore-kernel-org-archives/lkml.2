Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab0DOH3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:29:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab0DOH3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:45 -0400
Subject: Re: [PATCH 01/13] powerpc: Add rcu_read_lock() to gup_fast()
 implementation
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100413034311.GB2772@linux.vnet.ibm.com>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.643778654@chello.nl> <1271120731.13059.6.camel@pasglop>
	 <20100413034311.GB2772@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 15:51:50 +0200
Message-ID: <1271253110.32749.47.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 20:43 -0700, Paul E. McKenney wrote:
> > So we might have to support the interrupt assumption, at least in some
> > form, with those guys...
> 
> One way to make the interrupt assumption official is to use
> synchronize_sched() rather than synchronize_rcu().

Well, call_rcu_sched() then, because the current usage is to use
call_rcu() to free the page directories.

Paul, here is a call_rcu_sched() available in kernel/rcutree.c, but am I
right in reading that code that that would not be available for
preemptible RCU?


