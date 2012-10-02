Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab2JBRqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:46:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2JBRqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:46:40 -0400
Date: Tue, 2 Oct 2012 19:46:24 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.cz,
        kirill@shutemov.name, Chris Metcalf <cmetcalf@tilera.com>,
        Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH v2] mm: thp: Set the accessed flag for old pages on
 access fault.
Message-ID: <20121002174624.GI4763@redhat.com>
References: <1349197151-19645-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349197151-19645-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 05:59:11PM +0100, Will Deacon wrote:
> On x86 memory accesses to pages without the ACCESSED flag set result in the
> ACCESSED flag being set automatically. With the ARM architecture a page access
> fault is raised instead (and it will continue to be raised until the ACCESSED
> flag is set for the appropriate PTE/PMD).
> 
> For normal memory pages, handle_pte_fault will call pte_mkyoung (effectively
> setting the ACCESSED flag). For transparent huge pages, pmd_mkyoung will only
> be called for a write fault.
> 
> This patch ensures that faults on transparent hugepages which do not result
> in a CoW update the access flags for the faulting pmd.
> 
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Steve Capper <steve.capper@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
> 
> v2: - Use pmd_trans_huge_lock to guard against splitting pmds
>     - Propogate dirty (write) flag to low-level pmd modifier
> 
>  include/linux/huge_mm.h |    2 ++
>  mm/huge_memory.c        |    8 ++++++++
>  mm/memory.c             |    9 ++++++++-
>  3 files changed, 18 insertions(+), 1 deletions(-)

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
