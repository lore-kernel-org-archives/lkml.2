Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab0DSWup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:50:45 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:8285 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab0DSWuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:50:44 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALt6zEurR7Hu/2dsb2JhbACcAXGkTpk9hQ4EgzI
X-IronPort-AV: E=Sophos;i="4.52,237,1270425600"; 
   d="scan'208";a="117617646"
From: Tom Lyon <pugs@lyon-about.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] drivers/pci/intel-iommu.c: errors with smaller iommu widths
Date: Mon, 19 Apr 2010 15:47:53 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, chrisw@sous-sol.org, dwmw2@infradead.org
References: <4bccceb0.P4o49QIX47z1ouTs%pugs@cisco.com> <20100419154339.e80b6ef3.akpm@linux-foundation.org>
In-Reply-To: <20100419154339.e80b6ef3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004191547.53930.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree, but I defer to Mr. Woodhouse.

On Monday 19 April 2010 03:43:39 pm Andrew Morton wrote:
> On Mon, 19 Apr 2010 14:44:16 -0700
> "Tom Lyon" <pugs@cisco.com> wrote:
> 
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
> 


