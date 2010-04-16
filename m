Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab0DPGzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 02:55:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:42797 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab0DPGzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 02:55:03 -0400
Subject: Re: [PATCH 01/13] powerpc: Add rcu_read_lock() to gup_fast()
 implementation
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
Date: Fri, 16 Apr 2010 16:51:34 +1000
Message-ID: <1271400694.13059.183.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 20:43 -0700, Paul E. McKenney wrote:
> > So we might have to support the interrupt assumption, at least in
> some
> > form, with those guys...
> 
> One way to make the interrupt assumption official is to use
> synchronize_sched() rather than synchronize_rcu().

Ok, so I'm a bit of a RCU newbie as you may know :-) Right now, we use
neither, we use call_rcu and we free the pages from the callback.

Ben.


