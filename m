Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1BXMk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:40:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab1BXMkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:40:25 -0500
Subject: Re: [PATCH] mm: don't return 0 too early from find_get_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hughd@google.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Salman Qazi <sqazi@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.LSU.2.00.1102232132080.2239@sister.anvils>
References: <alpine.LSU.2.00.1102232132080.2239@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Feb 2011 13:40:13 +0100
Message-ID: <1298551213.2428.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 21:35 -0800, Hugh Dickins wrote:
> Callers of find_get_pages(), or its wrapper pagevec_lookup() - notably
> truncate_inode_pages_range() - stop looking further when it returns 0.
> 
> But if an interrupt comes just after its radix_tree_gang_lookup_slot(),
> especially if we have preemptible RCU enabled, isn't it conceivable
> that all 14 pages returned could be removed from the page cache by
> shrink_page_list(), before find_get_pages() gets to process them?  So
> causing it to return 0 although there may be plenty more pages beyond.
> 
> Make find_get_pages() and find_get_pages_tag() check for this unlikely
> case, and restart should it occur; but callers of find_get_pages_contig()
> have no such expectation, it's okay for that to return 0 early.
> 
> I have not seen this in practice, just worried by the possibility.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
