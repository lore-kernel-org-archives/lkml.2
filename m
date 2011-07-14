Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1GNHpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 03:45:03 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53025 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1GNHpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 03:45:00 -0400
Date: Thu, 14 Jul 2011 09:44:55 +0200
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, tglx@linutronix.de, benh@kernel.crashing.org,
        yinghai@kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/8] bootmem: Replace work_with_active_regions() with
 for_each_mem_pfn_range()
Message-ID: <20110714074455.GC3455@htj.dyndns.org>
References: <1310460395-30913-1-git-send-email-tj@kernel.org>
 <1310460395-30913-2-git-send-email-tj@kernel.org>
 <4E1E5058.5020702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E1E5058.5020702@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 07:11:36PM -0700, H. Peter Anvin wrote:
> On 07/12/2011 01:46 AM, Tejun Heo wrote:
> > Callback based iteration is cumbersome and much less useful than
> > for_each_*() iterator.  This patch implements for_each_mem_pfn_range()
> > which replaces work_with_active_regions().  All the current users of
> > work_with_active_regions() are converted.
> > 
> > This simplifies walking over early_node_map and will allow converting
> > internal logics in page_alloc to use iterator instead of walking
> > early_node_map directly, which in turn will enable moving node
> > information to memblock.
> > 
> > powerpc change is only compile tested.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> This patch causes a build failure on x86-64 with the attached .config:
> 
> /home/hpa/kernel/linux-2.6-tip.memblock/drivers/pci/intel-iommu.c: In
> function ‘si_domain_init’:
> /home/hpa/kernel/linux-2.6-tip.memblock/drivers/pci/intel-iommu.c:2216:4: error:
> implicit declaration of function ‘iommuc_domain_identity_map’
> [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

It was a typo that I fixed before sending the patches but obviously I
sent the old one.  The git tree had the updated one.  I'll re-post the
updated one.

Thank you.

-- 
tejun
