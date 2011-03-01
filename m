Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab1CATSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:18:21 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:55666 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756903Ab1CATST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:18:19 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Ondrej Zajicek <santiago@crfreenet.org>
Subject: [PATCH 1/5] s3fb: maximize virtual vertical size for fast scrolling
Date: Tue, 1 Mar 2011 20:18:08 +0100
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103012018.11283.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maximize virtual vertical framebuffer size during init to allow fast scrolling 
(accelerated by panning).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.38-rc4-/drivers/video/s3fb.c	2011-02-20 19:11:28.000000000 +0100
+++ linux-2.6.38-rc4/drivers/video/s3fb.c	2011-02-20 19:17:04.000000000 +0100
@@ -1060,6 +1060,14 @@ static int __devinit s3_pci_probe(struct
 		goto err_find_mode;
 	}
 
+	/* maximize virtual vertical size for fast scrolling */
+	info->var.yres_virtual = info->fix.smem_len * 8 /
+			(info->var.bits_per_pixel * info->var.xres_virtual);
+	if (info->var.yres_virtual < info->var.yres) {
+		dev_err(info->device, "virtual vertical size smaller than real\n");
+		goto err_find_mode;
+	}
+
 	rc = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (rc < 0) {
 		dev_err(info->device, "cannot allocate colormap\n");

-- 
Ondrej Zary
