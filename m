Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab1AXOYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:24:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1AXOYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:24:07 -0500
Subject: Re: [PATCH 00/21] mm: Preemptibility -v6
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Nick Piggin <npiggin@kernel.dk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <1295873131.28776.431.camel@laptop>
References: <20101126143843.801484792@chello.nl>
	 <alpine.LSU.2.00.1101172301340.2899@sister.anvils>
	 <1295457039.28776.137.camel@laptop>
	 <alpine.LSU.2.00.1101201052060.1603@sister.anvils>
	 <1295873131.28776.431.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Jan 2011 15:24:44 +0100
Message-ID: <1295879084.28776.432.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 13:45 +0100, Peter Zijlstra wrote:
> The only significant loser, I think,
> > would be page reclaim (when concurrent with truncation): could spin for a
> > long time waiting for the i_mmap_mutex it expects would soon be dropped? 

Well it won't spin (much) but mostly go to sleep if it really takes very
long, but then, could it really take much longer than say a lock_page()
when reclaim hits a page under IO?


