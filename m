Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2JDWNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:13:19 -0400
Received: from shutemov.name ([176.9.204.213]:59712 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab2JDWNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:13:15 -0400
Date: Fri, 5 Oct 2012 01:13:54 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.cz,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH v2] mm: thp: Set the accessed flag for old pages on
 access fault.
Message-ID: <20121004221353.GA11454@shutemov.name>
References: <1349197151-19645-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349197151-19645-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
