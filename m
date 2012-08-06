Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2HFJ4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:56:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64887 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab2HFJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:56:11 -0400
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, Katsuya MATSUBARA <matsu@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH v3 0/4] Use dma_mmap_coherent to support IOMMU mapper
Date: Mon,  6 Aug 2012 18:55:20 +0900
Message-Id: <1344246924-32620-1-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a dma_mmap_coherent() API in some architectures.  This API
provides a mmap function for memory allocated by dma_alloc_coherent().
Some drivers mmap a dma_addr_t returned by dma_alloc_coherent() as a
physical address.  But such drivers do not work correctly when IOMMU
mapper is used.

v3:
- Remove an unnecessary line which sets page protection bits.
v2:
- Rebase on fbdev-next branch of
  git://github.com/schandinat/linux-2.6.git.
- Initialize .fb_mmap in both sh_mobile_lcdc_overlay_ops and
  sh_mobile_lcdc_ops.
- Add Laurent's clean up patch.

Hideki EIRAKU (3):
  ARM: dma-mapping: define ARCH_HAS_DMA_MMAP_COHERENT
  media: videobuf2-dma-contig: use dma_mmap_coherent if available
  fbdev: sh_mobile_lcdc: use dma_mmap_coherent if available

Laurent Pinchart (1):
  ALSA: pcm - Don't define ARCH_HAS_DMA_MMAP_COHERENT privately for ARM

 arch/arm/include/asm/dma-mapping.h         |    1 +
 drivers/media/video/videobuf2-dma-contig.c |   17 +++++++++++++++++
 drivers/video/sh_mobile_lcdcfb.c           |   28 ++++++++++++++++++++++++++++
 sound/core/pcm_native.c                    |    7 -------
 4 files changed, 46 insertions(+), 7 deletions(-)

