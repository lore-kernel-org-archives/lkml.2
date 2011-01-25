Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1AYUau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:30:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:42949 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1AYUat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:30:49 -0500
Subject: Re: [PATCH 20/25] mm: Simplify anon_vma refcounts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <AANLkTikchW7Z6mSgcbt7wn9DWTeEGrKwfMwj1_WjMB5c@mail.gmail.com>
References: <20110125173111.720927511@chello.nl>
	 <20110125174908.262260777@chello.nl>
	 <AANLkTikchW7Z6mSgcbt7wn9DWTeEGrKwfMwj1_WjMB5c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 21:31:01 +0100
Message-ID: <1295987461.28776.1110.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 06:16 +1000, Linus Torvalds wrote:
> On Wed, Jan 26, 2011 at 3:31 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > This patch changes the anon_vma refcount to be 0 when the object is
> > free. It does this by adding 1 ref to being in use in the anon_vma
> > structure (iow. the anon_vma->head list is not empty).
> 
> Why is this patch part of this series, rather than being an
> independent patch before the whole series?
> 
> I think this part of the series is the only total no-brainer, ie we
> should have done this from the beginning. The preemptability stuff I'm
> more nervous about (performance issues? semantic differences?)

It relies on patch 19, which moves the anon_vma refcount out from under
CONFIG_goo.

If however you like it, I can move 19 and this patch up to the start and
have that go your way soon.
