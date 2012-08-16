Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab2HPXMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 19:12:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:29322 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab2HPXMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 19:12:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,781,1336374000"; 
   d="scan'208";a="203082086"
Date: Thu, 16 Aug 2012 16:12:47 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-mm@kvack.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, RFC 0/9] Introduce huge zero page
Message-ID: <20120816231247.GA4461@tassilo.jf.intel.com>
References: <1344503300-9507-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120816122023.c0e9bbc0.akpm@linux-foundation.org>
 <20120816194024.GP11188@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816194024.GP11188@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Because this is done the right way (i.e. to allocate an hugepage at
> the first wp fault, and to fallback exclusively if compaction fails)
> it will help much less than the 4k zero pages if the zero pages are

The main benefit is that you have a zero page with THP enabled.
So it lowers the cost of having THP on (for workloads that benefit
from a zero page)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
