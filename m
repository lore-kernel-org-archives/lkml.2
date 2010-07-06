Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0GFQCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:02:39 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:42061 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab0GFQCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:02:38 -0400
Date: Tue, 6 Jul 2010 11:02:04 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] hugetlb: hugepage migration core
In-Reply-To: <20100706033342.GA10626@spritzera.linux.bs1.fc.nec.co.jp>
Message-ID: <alpine.DEB.2.00.1007061100530.4938@router.home>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1278049646-29769-7-git-send-email-n-horiguchi@ah.jp.nec.com> <20100705095927.GC8510@basil.fritz.box> <20100706033342.GA10626@spritzera.linux.bs1.fc.nec.co.jp>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jul 2010, Naoya Horiguchi wrote:

> Hmm, this chunk need to be fixed because I had too specific assumption.
> The list passed to migrate_pages() has only one page or one hugepage in
> page migration kicked by soft offline, but it's not the case in general case.
> Since hugepage is not linked to LRU list, we had better simply skip
> putback_lru_pages().

Maybe write a migrate_huge_page() function instead? The functionality is
materially different since we are not juggling things with the lru.

