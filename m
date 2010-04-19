Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0DSWxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:53:53 -0400
Received: from sous-sol.org ([216.99.217.87]:44423 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751896Ab0DSWxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:53:52 -0400
Date: Mon, 19 Apr 2010 15:52:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Lyon <pugs@cisco.com>, chrisw@sous-sol.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] drivers/pci/intel-iommu.c: errors with smaller iommu
 widths
Message-ID: <20100419225223.GD25955@sequoia.sous-sol.org>
References: <4bccceb0.P4o49QIX47z1ouTs%pugs@cisco.com>
 <20100419154339.e80b6ef3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419154339.e80b6ef3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Mon, 19 Apr 2010 14:44:16 -0700
> "Tom Lyon" <pugs@cisco.com> wrote:
> > 
> > When using iommu_domain_alloc with the Intel iommu, the domain address width
> > is always initialized to 48 bits (agaw 2). __This domain->agaw value is then
> > used by pfn_to_dma_pte to (always) build a 4 level page table. __However, not
> > all systems support iommu width of 48 or 4 level page tables. __In particular,
> > the Core i5-660 and i5-670 support an address width of 36 bits (not 39!), an
> > agaw of only 1, and only 3 level page tables.
> > 
> > This version of the patch simply lops off extra levels of the page tables if
> > the agaw value of the iommu is less than what is currently allocated for the
> > domain (in intel_iommu_attach_device). If there were already allocated
> > addresses above what the new iommu can handle, EFAULT is returned.
> > 	Signed-off-by: Tom Lyon <pugs@cisco.com>
> 
> This smells like a 2.6.34 patch.  Do you agree?

I didn't think this effected in-tree code.  Tom hit this while developing
a new user of the iommu interface, whereas the current user (KVM) doesn't
trigger this.

thanks,
-chris
