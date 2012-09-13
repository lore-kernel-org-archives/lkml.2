Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2IMRiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:38:07 -0400
Received: from shutemov.name ([176.9.204.213]:59596 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab2IMRiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:38:05 -0400
Date: Thu, 13 Sep 2012 20:37:58 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/10] thp: implement refcounting for huge zero page
Message-ID: <20120913173758.GA4181@shutemov.name>
References: <1347282813-21935-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1347444473-26468-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120913171613.GJ3388@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913171613.GJ3388@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 07:16:13PM +0200, Andrea Arcangeli wrote:
> Hi Kirill,
> 
> On Wed, Sep 12, 2012 at 01:07:53PM +0300, Kirill A. Shutemov wrote:
> > -	hpage = alloc_pages(GFP_TRANSHUGE | __GFP_ZERO, HPAGE_PMD_ORDER);
> 
> The page is likely as large as a pageblock so it's unlikely to create
> much fragmentation even if the __GFP_MOVABLE is set. Said that I guess
> it would be more correct if __GFP_MOVABLE was clear, like
> (GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE because this page isn't
> really movable (it's only reclaimable).

Good point. I'll update the patchset.

> The xchg vs xchgcmp locking also looks good.
> 
> Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

Is it for the whole patchset? :)

-- 
 Kirill A. Shutemov
