Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab1ECEoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 00:44:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:57403 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab1ECEoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 00:44:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,307,1301900400"; 
   d="scan'208";a="637011663"
Subject: Re: Can I/OAT DMA engineer access PCI MMIO space
From: "Koul, Vinod" <vinod.koul@intel.com>
To: =?UTF-8?Q?=E5=BA=B7=E5=89=91=E6=96=8C?= <kjbmail@gmail.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com
In-Reply-To: <4DBF66C0.9020600@gmail.com>
References: <4DBA8F30.2060206@gmail.com>
	 <1304316260.1589.2.camel@vkoul-udesk3>  <4DBF66C0.9020600@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 09:42:06 +0530
Message-ID: <1304395926.1589.27.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 10:21 +0800, 康剑斌 wrote:
> >> I try to use ioatdam to copy data from system memory to pci MMIO space:
> >> If dst points to a memory space, the operation would pass.
> >> But if dst points to a pci MMIO space, it failed with kernel oops.
> >> It seems the code:
> >> BUG_ON(is_ioat_bug(chanerr));
> >> in drivers/dma/ioat/dma_v3.c, line 365 cause the oops.
> >> Is there anyway to access pci MMIO space using ioat?
> >> The datasheet says that ioat supports MMIO access.
> > Did you map the IO memory in kernel using ioremap and friends first?
> >
> yes, I had used 'ioremap_nocache' to map the IO memory and I can use
> memcpy to copy data to this region. The async_tx should have been 
> correctly configured as
> I can use aync_memcpy to copy data between different system memory address.
Then you should be using memcpy_toio() and friends

~Vinod

-- 
~Vinod

