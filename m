Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab1HJGmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:42:10 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:61511 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab1HJGmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:42:08 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix volatile warning issue in das16.c
Date: Wed, 10 Aug 2011 12:11:51 +0530
Message-Id: <1312958511-3716-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging: comedi:fix volatile warning issue in das16.c>
References: <[PATCH]Staging: comedi:fix volatile warning issue in das16.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das16.c file that fixes up a volatile warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das16.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index e7905ba..e25c6b4 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -740,8 +740,9 @@ struct das16_private_struct {
 	unsigned int ai_unipolar;	/*  unipolar flag */
 	unsigned int ai_singleended;	/*  single ended flag */
 	unsigned int clockbase;	/*  master clock speed in ns */
-	volatile unsigned int control_state;	/*  dma, interrupt and trigger control bits */
-	volatile unsigned long adc_byte_count;	/*  number of bytes remaining */
+	/* dma, interrupt and trigger control bits */
+	unsigned int control_state;
+	unsigned long adc_byte_count;	/*  number of bytes remaining */
 	/*  divisor dividing master clock to get conversion frequency */
 	unsigned int divisor1;
 	/*  divisor dividing master clock to get conversion frequency */
@@ -750,7 +751,8 @@ struct das16_private_struct {
 	uint16_t *dma_buffer[2];
 	dma_addr_t dma_buffer_addr[2];
 	unsigned int current_buffer;
-	volatile unsigned int dma_transfer_size;	/*  target number of bytes to transfer per dma shot */
+	/* target number of bytes to transfer per dma shot */
+	unsigned int dma_transfer_size;
 	/**
 	 * user-defined analog input and output ranges
 	 * defined from config options
@@ -759,8 +761,8 @@ struct das16_private_struct {
 	struct comedi_lrange *user_ao_range_table;
 
 	struct timer_list timer;	/*  for timed interrupt */
-	volatile short timer_running;
-	volatile short timer_mode;	/*  true if using timer mode */
+	short timer_running;
+	short timer_mode;	/*  true if using timer mode */
 };
 #define devpriv ((struct das16_private_struct *)(dev->private))
 #define thisboard ((struct das16_board *)(dev->board_ptr))
-- 
1.6.5.2

