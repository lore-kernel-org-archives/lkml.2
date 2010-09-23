Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0IWItd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:49:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53300 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab0IWItc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:49:32 -0400
Date: Thu, 23 Sep 2010 09:49:19 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com
Subject: Re: [PATCH 02/10] hugetlb: add allocate function for hugepage
	migration
Message-ID: <20100923084919.GA5185@csn.ul.ie>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1283908781-13810-3-git-send-email-n-horiguchi@ah.jp.nec.com> <alpine.DEB.2.00.1009221558000.32661@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009221558000.32661@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 04:05:47PM -0500, Christoph Lameter wrote:
> On Wed, 8 Sep 2010, Naoya Horiguchi wrote:
> 
> > We can't use existing hugepage allocation functions to allocate hugepage
> > for page migration, because page migration can happen asynchronously with
> > the running processes and page migration users should call the allocation
> > function with physical addresses (not virtual addresses) as arguments.
> 
> Ummm... Some arches like IA64 need huge pages fixed at certain virtual
> addresses in which only huge pages exist. A vma is needed in order to be
> able to assign proper virtual address to the page.
> 

Are you sure about this case? The virtual address of the page being migrated
should not changed, only the physical address.

> How does that work with transparent huge pages anyways?
> 

IA-64 doesn't support transparent huge pages. Even if it did, this
change is about hugetlbfs, not transparent huge page support.

> This looks like its going to break IA64 hugepage support for good.

How?

> Maybe
> thats okay given the reduced significance of IA64? Certainly would
> simplify the code.
> 

Currently I'm not seeing how IA-64 gets broken.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
