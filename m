Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965017Ab2HWRgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:36:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58268 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964853Ab2HWRgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:36:11 -0400
Date: Thu, 23 Aug 2012 18:36:02 +0100
From: Will Deacon <will.deacon@arm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm: hugetlb: add arch hook for clearing page flags
 before entering pool
Message-ID: <20120823173602.GA3117@mudshark.cambridge.arm.com>
References: <1345739833-25008-1-git-send-email-will.deacon@arm.com>
 <20120823171156.GE19968@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823171156.GE19968@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 06:11:56PM +0100, Michal Hocko wrote:
> On Thu 23-08-12 17:37:13, Will Deacon wrote:
> > The core page allocator ensures that page flags are zeroed when freeing
> > pages via free_pages_check. A number of architectures (ARM, PPC, MIPS)
> > rely on this property to treat new pages as dirty with respect to the
> > data cache and perform the appropriate flushing before mapping the pages
> > into userspace.
> > 
> > This can lead to cache synchronisation problems when using hugepages,
> > since the allocator keeps its own pool of pages above the usual page
> > allocator and does not reset the page flags when freeing a page into
> > the pool.
> > 
> > This patch adds a new architecture hook, arch_clear_hugepage_flags, so
> > that architectures which rely on the page flags being in a particular
> > state for fresh allocations can adjust the flags accordingly when a
> > page is freed into the pool.
> > 
> > Cc: Michal Hocko <mhocko@suse.cz>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> Looks good to me
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Cheers Michal. Next step: start posting the ARM code!

Will
