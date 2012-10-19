Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab2JSSt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:49:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2JSSt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:49:56 -0400
Date: Fri, 19 Oct 2012 11:49:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: David Miller <davem@davemloft.net>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        Steve Capper <Steve.Capper@arm.com>
Subject: Re: [PATCH v2] mm: thp: Set the accessed flag for old pages on
 access fault.
Message-Id: <20121019114955.3a0c2b66.akpm@linux-foundation.org>
In-Reply-To: <20121019091016.GA4582@mudshark.cambridge.arm.com>
References: <1349197151-19645-1-git-send-email-will.deacon@arm.com>
	<20121002150104.da57fa94.akpm@linux-foundation.org>
	<20121017130125.GH5973@mudshark.cambridge.arm.com>
	<20121017.112620.1865348978594874782.davem@davemloft.net>
	<20121017155401.GJ5973@mudshark.cambridge.arm.com>
	<20121018150502.3dee7899.akpm@linux-foundation.org>
	<20121019091016.GA4582@mudshark.cambridge.arm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 10:10:16 +0100
Will Deacon <will.deacon@arm.com> wrote:

> On Thu, Oct 18, 2012 at 11:05:02PM +0100, Andrew Morton wrote:
> > On Wed, 17 Oct 2012 16:54:02 +0100
> > Will Deacon <will.deacon@arm.com> wrote:
> > 
> > > On x86 memory accesses to pages without the ACCESSED flag set result in the
> > > ACCESSED flag being set automatically. With the ARM architecture a page access
> > > fault is raised instead (and it will continue to be raised until the ACCESSED
> > > flag is set for the appropriate PTE/PMD).
> > > 
> > > For normal memory pages, handle_pte_fault will call pte_mkyoung (effectively
> > > setting the ACCESSED flag). For transparent huge pages, pmd_mkyoung will only
> > > be called for a write fault.
> > > 
> > > This patch ensures that faults on transparent hugepages which do not result
> > > in a CoW update the access flags for the faulting pmd.
> > 
> > Confused.  Where is the arm implementation of update_mmu_cache_pmd()?
> 
> Right at the end of this patch, which was posted to the ARM list yesterday:
> 
>   http://lists.infradead.org/pipermail/linux-arm-kernel/2012-October/126387.html

I received and then merged a patch which won't compile!

Ho hum.  I'll drop
mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch and
shall assume that you'll sort things out at the appropriate time.

