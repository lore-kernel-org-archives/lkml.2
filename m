Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab1CATSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:18:52 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:53399 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757157Ab1CATSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:18:50 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Ondrej Zajicek <santiago@crfreenet.org>
Subject: [PATCH 5/5] s3fb: use new start address register
Date: Tue, 1 Mar 2011 20:18:43 +0100
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103012018.45635.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "new" start address register 0x69 (bits 16-20) instead of "old" 0x31
(bits 16-17) and 0x51 (bits 18-19). This is needed for panning to work
correctly on Trio3D/2X cards (and does no harm on other ones).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.38-rc4-/drivers/video/s3fb.c	2011-03-01 18:38:58.000000000 +0100
+++ linux-2.6.38-rc4/drivers/video/s3fb.c	2011-03-01 18:39:35.000000000 +0100
@@ -123,7 +123,7 @@ static const struct vga_regset s3_v_sync
 static const struct vga_regset s3_v_sync_end_regs[]     = {{0x11, 0, 3}, VGA_REGSET_END};
 
 static const struct vga_regset s3_line_compare_regs[]   = {{0x18, 0, 7}, {0x07, 4, 4}, {0x09, 6, 6}, {0x5E, 6, 6}, VGA_REGSET_END};
-static const struct vga_regset s3_start_address_regs[]  = {{0x0d, 0, 7}, {0x0c, 0, 7}, {0x31, 4, 5}, {0x51, 0, 1}, VGA_REGSET_END};
+static const struct vga_regset s3_start_address_regs[]  = {{0x0d, 0, 7}, {0x0c, 0, 7}, {0x69, 0, 4}, VGA_REGSET_END};
 static const struct vga_regset s3_offset_regs[]         = {{0x13, 0, 7}, {0x51, 4, 5}, VGA_REGSET_END}; /* set 0x43 bit 2 to 0 */
 
 static const struct vga_regset s3_dtpc_regs[]		= {{0x3B, 0, 7}, {0x5D, 6, 6}, VGA_REGSET_END};

-- 
Ondrej Zary
