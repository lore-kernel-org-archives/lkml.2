Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2HPKOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:14:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50649 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab2HPKOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:14:05 -0400
Date: Thu, 16 Aug 2012 19:13:58 +0900 (JST)
Message-Id: <20120816.191358.127675610.hdk@igel.co.jp>
To: m.szyprowski@samsung.com
Cc: laurent.pinchart@ideasonboard.com, linux@arm.linux.org.uk,
        pawel@osciak.com, kyungmin.park@samsung.com, mchehab@infradead.org,
        FlorianSchandinat@gmx.de, perex@perex.cz, tiwai@suse.de,
        t.stanislaws@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        matsu@igel.co.jp, dhobsong@igel.co.jp
Subject: Re: [PATCH v3 3/4] media: videobuf2-dma-contig: use
 dma_mmap_coherent if available
From: Hideki EIRAKU <hdk@igel.co.jp>
In-Reply-To: <012701cd74ac$6a617060$3f245120$%szyprowski@samsung.com>
References: <1344246924-32620-1-git-send-email-hdk@igel.co.jp>
	<1344246924-32620-4-git-send-email-hdk@igel.co.jp>
	<012701cd74ac$6a617060$3f245120$%szyprowski@samsung.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v3 3/4] media: videobuf2-dma-contig: use dma_mmap_coherent if available
Date: Tue, 07 Aug 2012 16:53:25 +0200

> I'm sorry for bringing this issue now, once you have already created v3 of your
> patches, but similar patch has been already proposed some time ago. It is already
> processed together with general videobuf2-dma-contig redesign and dma-buf extensions
> by Tomasz Stanislawski.
> 
> See post http://thread.gmane.org/gmane.comp.video.dri.devel/70402/focus=49461 and
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/49438 
> 
> It doesn't use conditional code inside videobuf2 allocator and rely entirely on 
> dma-mapping subsystem to provide a working dma_mmap_coherent/writecombine/attrs() 
> function. When it was posted, it relied on the dma-mapping extensions, which now
> have been finally merged to v3.6-rc1. Now I wonder if there are any architectures, 
> which don't use dma_map_ops based dma-mapping framework, which might use 
> videobuf2-dma-conting module. 

Thank you for telling me about videobuf2-dma-contig and v3.6-rc1.  The
videobuf2-dma-contig patch I sent is now unnecessary.  So I will
remove the patch.  I will remove the patch defining
ARCH_HAS_DMA_MMAP_COHERENT too because the v3.6-rc1 kernel has generic
dma_mmap_coherent() API for every architecture.

I will also remove the Laurent's patch I sent because it was related
to ARCH_HAS_DMA_MMAP_COHERENT.

The remaining patch is sh_mobile_lcdc.  I will remove ifdefs from the
patch and re-post it as a patch v4.

-- 
Hideki EIRAKU <hdk@igel.co.jp>
