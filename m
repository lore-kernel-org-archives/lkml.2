Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0H1P2H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:28:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:55113 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab0H1P2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:28:05 -0400
Subject: Re: [PATCH 00/20] mm: Preemptibility -v4
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@suse.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <AANLkTikhV6PLb_pRmBmjynft4pe4paKogFP-JR7aXXyv@mail.gmail.com>
References: <20100828141637.421594670@chello.nl>
	 <AANLkTikhV6PLb_pRmBmjynft4pe4paKogFP-JR7aXXyv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 28 Aug 2010 17:27:02 +0200
Message-ID: <1283009222.1975.3622.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-28 at 18:19 +0300, Pekka Enberg wrote:
> Hi Peter,
> 
> On Sat, Aug 28, 2010 at 5:16 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Yanmin ran the last posting through the comprehensive Intel test farm
> > and didn't find any regressions.
> 
> Is there data somewhere that shows where this helps and how much?

Yanmin didn't publish any data, but the main point of the series is to
not take hundreds of nested spinlocks. Not regressing is a fine state.

In theory the preemptible mmu could end up doing less TLB invalidates
for large unmaps and thus gain some performance there.

