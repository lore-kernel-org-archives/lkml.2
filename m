Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2GYQA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:00:58 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:48695 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2GYQA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:00:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Katsuya MATSUBARA <matsu@igel.co.jp>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] ALSA: pcm - Don't define ARCH_HAS_DMA_MMAP_COHERENT privately for ARM
Date: Wed, 25 Jul 2012 18:01:00 +0200
Message-Id: <1343232060-17851-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1343197764-13659-1-git-send-email-hdk@igel.co.jp>
References: <1343197764-13659-1-git-send-email-hdk@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM architecture now defines ARCH_HAS_DMA_MMAP_COHERENT, there's no
need to define it privately anymore.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 sound/core/pcm_native.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

Hi Eiraku-san,

Could you please add this cleanup patch to your "Use dma_mmap_coherent to
support IOMMU mapper" series ?

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 53b5ada..84ead60 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3156,13 +3156,6 @@ static const struct vm_operations_struct snd_pcm_vm_ops_data_fault = {
 	.fault =	snd_pcm_mmap_data_fault,
 };
 
-#ifndef ARCH_HAS_DMA_MMAP_COHERENT
-/* This should be defined / handled globally! */
-#ifdef CONFIG_ARM
-#define ARCH_HAS_DMA_MMAP_COHERENT
-#endif
-#endif
-
 /*
  * mmap the DMA buffer on RAM
  */
-- 
Regards,

Laurent Pinchart

