Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0JJPrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:47:41 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:57409 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab0JJPrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:47:40 -0400
X-Greylist: delayed 2106 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Oct 2010 11:47:39 EDT
To: benh@kernel.crashing.org
Cc: nacc@us.ibm.com, miltonm@bga.com, paulus@samba.org,
        akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        galak@kernel.crashing.org, scottwood@freescale.com,
        avorontsov@mvista.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 03/11] ppc: Create ops to choose between direct
 window and iommu based on device mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1286581493.2463.428.camel@pasglop>
References: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
	<1286559192-10898-4-git-send-email-nacc@us.ibm.com>
	<1286581493.2463.428.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101011000903R.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 11 Oct 2010 00:09:03 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Oct 2010 10:44:53 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Fri, 2010-10-08 at 10:33 -0700, Nishanth Aravamudan wrote:
> > Also allow the coherent ops to be iommu if only the coherent mask is too
> > small, mostly for driver that do not set set the coherent mask but also
> > don't use the coherent api.
> 
> You are doing the transition at map_sg time which is a hot path, I don't
> like that. Also you add all those "choose" variants of the dma ops...
> not very nice at all.

Agreed, looks hacky.


> You may want to look at the patches I posted to the list a while back
> for doing direct DMA on Bimini:
> 
> [PATCH 1/2] powerpc/dma: Add optional platform override of dma_set_mask()

Would it be cleaner if each ppc dma_map_ops has the own set_dma_mask
and dma_set_mask simply calls dma_map_ops->set_dma_mask?


> [PATCH 2/2] powerpc/dart_iommu: Support for 64-bit iommu bypass window on PCIe



