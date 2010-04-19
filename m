Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0DSWn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:43:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493Ab0DSWn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:43:58 -0400
Date: Mon, 19 Apr 2010 15:43:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Tom Lyon" <pugs@cisco.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, chrisw@sous-sol.org, dwmw2@infradead.org
Subject: Re: [PATCH v3] drivers/pci/intel-iommu.c: errors with smaller iommu
 widths
Message-Id: <20100419154339.e80b6ef3.akpm@linux-foundation.org>
In-Reply-To: <4bccceb0.P4o49QIX47z1ouTs%pugs@cisco.com>
References: <4bccceb0.P4o49QIX47z1ouTs%pugs@cisco.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 14:44:16 -0700
"Tom Lyon" <pugs@cisco.com> wrote:

> 
> When using iommu_domain_alloc with the Intel iommu, the domain address width
> is always initialized to 48 bits (agaw 2). __This domain->agaw value is then
> used by pfn_to_dma_pte to (always) build a 4 level page table. __However, not
> all systems support iommu width of 48 or 4 level page tables. __In particular,
> the Core i5-660 and i5-670 support an address width of 36 bits (not 39!), an
> agaw of only 1, and only 3 level page tables.
> 
> This version of the patch simply lops off extra levels of the page tables if
> the agaw value of the iommu is less than what is currently allocated for the
> domain (in intel_iommu_attach_device). If there were already allocated
> addresses above what the new iommu can handle, EFAULT is returned.
> 	Signed-off-by: Tom Lyon <pugs@cisco.com>

This smells like a 2.6.34 patch.  Do you agree?
