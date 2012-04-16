Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2DPPCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:02:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab2DPPCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:02:34 -0400
Date: Mon, 16 Apr 2012 16:02:31 +0100
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-S390 <linux-s390@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] s390: mm: rmap: Transfer storage key to struct page
 under the page lock
Message-ID: <20120416150231.GE2359@suse.de>
References: <20120416141423.GD2359@suse.de>
 <4F8C3253.9030208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4F8C3253.9030208@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:53:07AM -0400, Rik van Riel wrote:
> On 04/16/2012 10:14 AM, Mel Gorman wrote:
> >This patch is horribly ugly and there has to be a better way of doing
> >it. I'm looking for suggestions on what s390 can do here that is not
> >painful or broken.
> 
> I'm hoping the S390 arch maintainers have an idea.
> 
> Ugly or not, we'll need something to fix the bug.
> 

Indeed.

> >+ * When the late PTE has gone, s390 must transfer the dirty flag from the
> >+ * storage key to struct page. We can usually skip this if the page is anon,
> >+ * so about to be freed; but perhaps not if it's in swapcache - there might
> >+ * be another pte slot containing the swap entry, but page not yet written to
> >+ * swap.
> >   *
> >- * The caller needs to hold the pte lock.
> >+ * set_page_dirty() is called while the page_mapcount is still postive and
> >+ * under the page lock to avoid races with the mapping being invalidated.
> >   */
> >-void page_remove_rmap(struct page *page)
> >+static void propogate_storage_key(struct page *page, bool lock_required)
> 
> Do you mean "propAgate" ?
> 

Yes.

-- 
Mel Gorman
SUSE Labs
