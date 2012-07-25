Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab2GYGaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:30:23 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37486 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab2GYGaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:30:14 -0400
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Katsuya MATSUBARA <matsu@igel.co.jp>, Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH 0/3] Use dma_mmap_coherent to support IOMMU mapper
Date: Wed, 25 Jul 2012 15:29:21 +0900
Message-Id: <1343197764-13659-1-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a dma_mmap_coherent() API in some architectures.  This API
provides a mmap function for memory allocated by dma_alloc_coherent().
Some drivers mmap a dma_addr_t returned by dma_alloc_coherent() as a
physical address.  But such drivers do not work correctly when IOMMU
mapper is used.

Hideki EIRAKU (3):
  ARM: dma-mapping: define ARCH_HAS_DMA_MMAP_COHERENT
  media: videobuf2-dma-contig: use dma_mmap_coherent if available
  fbdev: sh_mobile_lcdc: use dma_mmap_coherent if available

 arch/arm/include/asm/dma-mapping.h         |    1 +
 drivers/media/video/videobuf2-dma-contig.c |   18 ++++++++++++++++++
 drivers/video/sh_mobile_lcdcfb.c           |   14 ++++++++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

