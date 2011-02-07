Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab1BGNyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:54:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1BGNyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:54:11 -0500
Subject: Re: [PATCH 01/25] tile: Fix __pte_free_tlb
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Metcalf <cmetcalf@tilera.com>
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
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
In-Reply-To: <4D4C63ED.6060104@tilera.com>
References: <20110125173111.720927511@chello.nl>
	 <20110125174907.220115681@chello.nl>  <4D4C63ED.6060104@tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 14:55:11 +0100
Message-ID: <1297086911.13327.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 15:39 -0500, Chris Metcalf wrote:
> On 1/25/2011 12:31 PM, Peter Zijlstra wrote:
> > Tile's __pte_free_tlb() implementation makes assumptions about the
> > generic mmu_gather implementation, cure this ;-)
> 
> I assume you will take this patch into your tree?  If so:
> 
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Feel free to take it yourself, this series might take a while to land..

> > [ Chris, from a quick look L2_USER_PGTABLE_PAGES is something like:
> >   1 << (24 - 16 + 3), which looks awefully large for an on-stack
> >   array. ]
> 
> Yes, the pte_pages[] array in this routine is 2KB currently.  Currently we
> ship with 64KB pagesize, so the kernel stack has plenty of room.  I do like
> that your patch removes this buffer, however, since we're currently looking
> into (re-)supporting 4KB pages, which would totally blow the kernel stack
> in this routine.

Ah, ok.

