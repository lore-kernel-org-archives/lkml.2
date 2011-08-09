Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1HIMTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:19:16 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:58809 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab1HIMTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:19:15 -0400
From: Julia Lawall <julia@diku.dk>
To: Dave Airlie <airlied@redhat.com>
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/gpu/vga/vgaarb.c: add missing kfree
Date: Tue,  9 Aug 2011 14:19:08 +0200
Message-Id: <1312892348-22615-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

kbuf is a buffer that is local to this function, so all of the error paths
leaving the function should release it.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/gpu/vga/vgaarb.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index c72f1c0..18376f1 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -993,14 +993,20 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 				uc = &priv->cards[i];
 		}
 
-		if (!uc)
-			return -EINVAL;
+		if (!uc) {
+			ret_val = -EINVAL;
+			goto done;
+		}
 
-		if (io_state & VGA_RSRC_LEGACY_IO && uc->io_cnt == 0)
-			return -EINVAL;
+		if (io_state & VGA_RSRC_LEGACY_IO && uc->io_cnt == 0) {
+			ret_val = -EINVAL;
+			goto done;
+		}
 
-		if (io_state & VGA_RSRC_LEGACY_MEM && uc->mem_cnt == 0)
-			return -EINVAL;
+		if (io_state & VGA_RSRC_LEGACY_MEM && uc->mem_cnt == 0) {
+			ret_val = -EINVAL;
+			goto done;
+		}
 
 		vga_put(pdev, io_state);
 

