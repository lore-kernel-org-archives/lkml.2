Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab0FWBr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 21:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab0FWBr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 21:47:27 -0400
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@redhat.com>, stable@kernel.org
Subject: [PATCH] fb: fix colliding defines for fb flags.
Date: Wed, 23 Jun 2010 11:46:52 +1000
Message-Id: <1277257612-8491-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

When I added the flags I must have been using a 25 line terminal and missed the following flags.

The collided with flag has one user in staging despite being in-tree for 5 years.

I'm happy to push this via my drm tree unless someone really wants to do it.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: stable@kernel.org
---
 include/linux/fb.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fb.h b/include/linux/fb.h
index 907ace3..8e5a9df 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -786,8 +786,6 @@ struct fb_tile_ops {
 #define FBINFO_MISC_USEREVENT          0x10000 /* event request
 						  from userspace */
 #define FBINFO_MISC_TILEBLITTING       0x20000 /* use tile blitting */
-#define FBINFO_MISC_FIRMWARE           0x40000 /* a replaceable firmware
-						  inited framebuffer */
 
 /* A driver may set this flag to indicate that it does want a set_par to be
  * called every time when fbcon_switch is executed. The advantage is that with
@@ -801,6 +799,8 @@ struct fb_tile_ops {
  */
 #define FBINFO_MISC_ALWAYS_SETPAR   0x40000
 
+/* where the fb is a firmware driver, and can be replaced with a proper one */
+#define FBINFO_MISC_FIRMWARE        0x80000
 /*
  * Host and GPU endianness differ.
  */
-- 
1.7.1

