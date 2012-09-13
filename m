Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab2IMRQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:16:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab2IMRQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:16:19 -0400
Date: Thu, 13 Sep 2012 19:16:13 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v3 10/10] thp: implement refcounting for huge zero page
Message-ID: <20120913171613.GJ3388@redhat.com>
References: <1347282813-21935-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1347444473-26468-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347444473-26468-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On Wed, Sep 12, 2012 at 01:07:53PM +0300, Kirill A. Shutemov wrote:
> -	hpage = alloc_pages(GFP_TRANSHUGE | __GFP_ZERO, HPAGE_PMD_ORDER);

The page is likely as large as a pageblock so it's unlikely to create
much fragmentation even if the __GFP_MOVABLE is set. Said that I guess
it would be more correct if __GFP_MOVABLE was clear, like
(GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE because this page isn't
really movable (it's only reclaimable).

The xchg vs xchgcmp locking also looks good.

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

Thanks,
Andrea
