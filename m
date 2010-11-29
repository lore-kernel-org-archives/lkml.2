Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0K2Uus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:50:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:58277 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab0K2Uuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:50:46 -0500
Subject: Re: [PATCH 19/21] mm: Convert i_mmap_lock and anon_vma->lock to
 mutexes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20101129120530.67013aeb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101126143843.801484792@chello.nl>
	 <20101126145411.331356698@chello.nl>
	 <20101129120530.67013aeb.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 21:50:42 +0100
Message-ID: <1291063842.32004.386.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 12:05 +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 26 Nov 2010 15:39:02 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Straight fwd conversion of i_mmap_lock and anon_vma->lock to mutexes.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> No performance influence ?

I couldn't find any, if there was anything the error and per-boot
deviation was larger.

Yanmin also ran this though the intel test/performance farm and didn't
find anything significant.
