Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab2FRMhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:37:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43782 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2FRMhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:37:39 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] usb: gadget: storage_common: remove FSG_BUFFHD_STATIC_BUFFER support
Date: Mon, 18 Jun 2012 14:37:19 +0200
Message-Id: <d3dce6e6d68f76850b1c1e55dae63a0d65145b60.1340022674.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <cover.1340022674.git.mina86@mina86.com>
References: <cover.1340022674.git.mina86@mina86.com>
In-Reply-To: <cover.1340022674.git.mina86@mina86.com>
References: <cover.1340022674.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Since f_mass_storage stopped using FSG_BUFFHD_STATIC_BUFFER (because it
caused buffers not to be page aligned which did not work well with at
least some UDCs), no code was using it.  Removing not to bloat the code
too much.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/storage_common.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 8081ca3..8a8157f 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -38,12 +38,6 @@
  */
 
 /*
- * When FSG_BUFFHD_STATIC_BUFFER is defined when this file is included
- * the fsg_buffhd structure's buf field will be an array of FSG_BUFLEN
- * characters rather then a pointer to void.
- */
-
-/*
  * When USB_GADGET_DEBUG_FILES is defined the module param num_buffers
  * sets the number of pipeline buffers (length of the fsg_buffhd array).
  * The valid range of num_buffers is: num >= 2 && num <= 4.
@@ -260,11 +254,7 @@ enum fsg_buffer_state {
 };
 
 struct fsg_buffhd {
-#ifdef FSG_BUFFHD_STATIC_BUFFER
-	char				buf[FSG_BUFLEN];
-#else
 	void				*buf;
-#endif
 	enum fsg_buffer_state		state;
 	struct fsg_buffhd		*next;
 
-- 
1.7.7.3

