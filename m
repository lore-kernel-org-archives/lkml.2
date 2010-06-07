Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab0FGXcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 19:32:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:49773 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0FGXcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 19:32:12 -0400
Date: Tue, 8 Jun 2010 08:31:59 +0900
To: michal.simek@petalogix.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.35-rc3 v2
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C0D3853.60000@petalogix.com>
References: <4C0D3853.60000@petalogix.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100608083015L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 08 Jun 2010 08:32:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jun 2010 20:20:03 +0200
Michal Simek <michal.simek@petalogix.com> wrote:

> Hi Linus,
> 
> here are only fixes for Microblaze. There is no any new features. 
> (flush_dcache_page patch fix problem on WB system)
> Just note: Some new patches broke Microblaze arch that's why I would 
> like to add at least these patches to your tree.
> 
> Thanks,
> Michal
> 
> 
> The following changes since commit 386f40c86d6c8d5b717ef20620af1a750d0dacb4:
>    Linus Torvalds (1):
>          Revert "tty: fix a little bug in scrup, vt.c"
> 
> are available in the git repository at:
> 
>    git://git.monstr.eu/linux-2.6-microblaze.git next
> 
> Michal Simek (7):
>        microblaze: Fix __copy_to/from_user_inatomic macros
>        microblaze: Sync noMMU and MMU setup_memory
>        microblaze: Fix comment for TLB
>        microblaze: Implement flush_dcache_page macro
>        microblaze: Enable NEED_SG_DMA_LENGTH

Sorry, my scatterlist patchset breaks microblaze?

Seems that microblaze can simply remove sg->dma_length instead of
enabling NEED_SG_DMA_LENGTH. If sg->dma_length is always equal to
sg->length on your architecture, you don't need to waste memory for
sg->dma_length.


diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
index 9dcd90b..79c7465 100644
--- a/arch/microblaze/kernel/dma.c
+++ b/arch/microblaze/kernel/dma.c
@@ -90,7 +90,6 @@ static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 	/* FIXME this part of code is untested */
 	for_each_sg(sgl, sg, nents, i) {
 		sg->dma_address = sg_phys(sg) + get_dma_direct_offset(dev);
-		sg->dma_length = sg->length;
 		__dma_sync_page(page_to_phys(sg_page(sg)), sg->offset,
 							sg->length, direction);
 	}
