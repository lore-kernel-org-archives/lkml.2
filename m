Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1F0HHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:07:45 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:51451 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab1F0HFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:05:49 -0400
Date: Mon, 27 Jun 2011 09:05:41 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Jerry James <jamesjer@betterlinux.com>,
        Marcus Sorensen <marcus@bluehost.com>, Matt Heaton <matt@bluehost.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@mit.edu>, Shaohua Li <shaohua.li@intel.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] mm: introduce __invalidate_mapping_pages()
Message-ID: <20110627070541.GB1247@thinkpad>
References: <1308923350-7932-1-git-send-email-andrea@betterlinux.com>
 <1308923350-7932-2-git-send-email-andrea@betterlinux.com>
 <4E07B6D6.8070203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E07B6D6.8070203@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 06:46:46PM -0400, Rik van Riel wrote:
> On 06/24/2011 09:49 AM, Andrea Righi wrote:
> 
> >diff --git a/mm/truncate.c b/mm/truncate.c
> >index 3a29a61..90f3a97 100644
> >--- a/mm/truncate.c
> >+++ b/mm/truncate.c
> >@@ -312,20 +312,27 @@ void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
> >  EXPORT_SYMBOL(truncate_inode_pages);
> >
> >  /**
> >- * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
> >+ * __invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
> >   * @mapping: the address_space which holds the pages to invalidate
> >   * @start: the offset 'from' which to invalidate
> >   * @end: the offset 'to' which to invalidate (inclusive)
> >+ * @force: always drop pages when true (otherwise, reduce cache eligibility)
> 
> I don't like the parameter name "force".

Agreed.

> 
> The parameter determines whether or not pages actually get
> invalidated, so I'm guessing the parameter name should
> reflect the function...
> 
> Maybe something like "invalidate"?

Sounds better.

-Andrea
