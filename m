Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2HBCFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 22:05:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:25938 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab2HBCFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 22:05:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192273025"
Date: Thu, 2 Aug 2012 10:00:22 +0800
From: Feng Tang <feng.tang@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <lenb@kernel.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>
Subject: Re: linux-next: build failure after merge of the acpi tree
Message-ID: <20120802100022.58a5ebd8@feng-i7>
In-Reply-To: <20120802112033.c1531ffe7bf7147c461cac0a@canb.auug.org.au>
References: <20120802112033.c1531ffe7bf7147c461cac0a@canb.auug.org.au>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2012 11:20:33 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Len,
> 
> After merging the acpi tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/iommu/amd_iommu_init.c: In function 'early_amd_iommu_init':
> drivers/iommu/amd_iommu_init.c:1535:2: error: implicit declaration of
> function 'acpi_get_table_with_size' [-Werror=implicit-function-declaration]
> 
> Caused by commit 705d9245d714 ("ACPI: remove acpi_get_table_with_size()
> fucntion").
> 
> This extra call to acpi_get_table_with_size() was added by commit
> 02f3b3f5449c ("iommu/amd: Use acpi_get_table instead of
> acpi_table_parse") added to Linus' tree on about July 25 via the iommu
> tree.

Thanks for the root cause, Yinghai also noticed me about that, and I've
send a updated patch 
	https://lkml.org/lkml/2012/8/1/25 

So it should be ok after Len merge this v2 patch.

Thanks,
Feng

> 
> I have reverted the acpi tree commit for today.
