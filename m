Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1DSUIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:08:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890Ab1DSUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:08:36 -0400
Date: Tue, 19 Apr 2011 13:07:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 14/20] mm: Remove i_mmap_lock lockbreak
Message-Id: <20110419130719.86093a27.akpm@linux-foundation.org>
In-Reply-To: <20110401121725.991633993@chello.nl>
References: <20110401121258.211963744@chello.nl>
	<20110401121725.991633993@chello.nl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Apr 2011 14:13:12 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Hugh says:
>  "The only significant loser, I think, would be page reclaim (when
>   concurrent with truncation): could spin for a long time waiting for
>   the i_mmap_mutex it expects would soon be dropped? "
> 
> Counter points:
>  - cpu contention makes the spin stop (need_resched())
>  - zap pages should be freeing pages at a higher rate than reclaim
>    ever can
> 
> I think the simplification of the truncate code is definately worth it.

Well, we don't need to guess.  These things are testable!
