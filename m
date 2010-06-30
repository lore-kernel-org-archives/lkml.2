Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab0F3SoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:44:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:52058 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab0F3Sn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:43:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,514,1272870000"; 
   d="scan'208";a="294888579"
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: David Woodhouse <David.Woodhouse@intel.com>
To: Chris Li <lkml@chrisli.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	 <4C29420D.2010406@intel.com>
	 <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	 <4C2A8879.8010000@intel.com>
	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	 <4C2AC55E.3040303@intel.com>
	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation
Date: Wed, 30 Jun 2010 19:43:42 +0100
Message-ID: <1277923422.16256.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 19:26 +0100, Chris Li wrote:
> 
> The delta seems to be this line:
> ioatdma 0000:00:0f.0: ioat2_set_chainaddr: chainaddr: ffffe000 

That's a reasonable address if the IOMMU is enabled. We start at 4GiB
and work down, so that's the second page given out (or the first 8KiB
chunk).

It looks like the DMA is going AWOL causing the initialisation to
fail... but it's interesting that there are no DMA faults reported by
the IOMMU.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

