Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab0I0IgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:36:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:46433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932793Ab0I0IgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:36:13 -0400
Message-Id: <8u3s8d$jmp9g4@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,242,1283756400"; 
   d="scan'208";a="661431812"
Date: Mon, 27 Sep 2010 09:36:09 +0100
To: Hugh Dickins <hughd@google.com>
Subject: Re: How best to pin pages in physical memory?
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>
References: <8u3s8d$jmkug0@orsmga001.jf.intel.com> <alpine.LSU.2.00.1009261559540.11745@sister.anvils>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <alpine.LSU.2.00.1009261559540.11745@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Sep 2010 16:29:23 -0700 (PDT), Hugh Dickins <hughd@google.com> wrote:
> If i915_get_object_get_pages() isn't doing its job, I think you need to
> wonder why not - maybe somewhere doing a put_page or page_cache_release,
> freeing one or all pages too soon?

Thanks, that's a very useful bit of review. I surmised that after seeing
corruption in a batch buffer after a swap storm that the pages were not as
safe required. The fact that swapping was involved could have been a
coincidence, except for the growing number of reports from other users
reporting crashes in conjunction with swapping.

So back to seeing whether i915_gem_object_[get/put]_pages is sufficient
for our uses.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
