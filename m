Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2LSR72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:59:28 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36696 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671Ab2LSR7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:59:10 -0500
Date: Wed, 19 Dec 2012 12:58:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Satoru Moriya <satoru.moriya@hds.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] mm: reduce rmap overhead for ex-KSM page copies
 created on swap faults
Message-ID: <20121219175811.GD7147@cmpxchg.org>
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org>
 <1355767957-4913-8-git-send-email-hannes@cmpxchg.org>
 <1355900479.1381.1.camel@kernel-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355900479.1381.1.camel@kernel-VirtualBox>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 02:01:19AM -0500, Simon Jeons wrote:
> On Mon, 2012-12-17 at 13:12 -0500, Johannes Weiner wrote:
> > When ex-KSM pages are faulted from swap cache, the fault handler is
> > not capable of re-establishing anon_vma-spanning KSM pages.  In this
> > case, a copy of the page is created instead, just like during a COW
> > break.
> > 
> > These freshly made copies are known to be exclusive to the faulting
> > VMA and there is no reason to go look for this page in parent and
> > sibling processes during rmap operations.
> > 
> > Use page_add_new_anon_rmap() for these copies.  This also puts them on
> > the proper LRU lists and marks them SwapBacked, so we can get rid of
> > doing this ad-hoc in the KSM copy code.
> 
> Is it just a code cleanup instead of reduce rmap overhead?

Both.
