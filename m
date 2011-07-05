Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1GEMnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:43:37 -0400
Received: from tex.lwn.net ([70.33.254.29]:56849 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab1GEMng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:43:36 -0400
Date: Tue, 5 Jul 2011 06:43:34 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20110705064334.0beba89e@bike.lwn.net>
In-Reply-To: <20110704130442.c4125fd9.sfr@canb.auug.org.au>
References: <20110704130442.c4125fd9.sfr@canb.auug.org.au>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jul 2011 13:04:42 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "vb2_dma_contig_init_ctx" [drivers/media/video/marvell-ccic/cafe_ccic.ko] undefined!
> ERROR: "vb2_dma_contig_cleanup_ctx" [drivers/media/video/marvell-ccic/cafe_ccic.ko] undefined!
> ERROR: "vb2_dma_contig_memops" [drivers/media/video/marvell-ccic/cafe_ccic.ko] undefined!
> 
> I have used the v4l-dvb tree from next-20110701 for today.

That was my silly mistake, sorry; I messed up the configuration for that
platform.  Hans ran into it first; this patch from him will fix things up
until my next series gets into Mauro's tree.

Sorry,

jon

From: Hans Verkuil <hverkuil@xs4all.nl>
Add a missing selection for cafe_ccic

diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
index 22314a0..68ff5d6 100644
--- a/drivers/media/video/marvell-ccic/Kconfig
+++ b/drivers/media/video/marvell-ccic/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_CAFE_CCIC
 	depends on PCI && I2C && VIDEO_V4L2
 	select VIDEO_OV7670
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
 	  CMOS camera controller.  This is the controller found on first-
