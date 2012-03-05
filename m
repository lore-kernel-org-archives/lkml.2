Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965204Ab2CEOE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:04:29 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34696 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab2CENxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:14 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 08/68] TTY: serial, simplify ASYNC_USR_MASK
Date: Mon,  5 Mar 2012 14:51:55 +0100
Message-Id: <1330955575-26641-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using ASYNC_SPD_MASK instead of the single speed bits.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/serial.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/serial.h b/include/linux/serial.h
index 3d86517..441980e 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -152,8 +152,8 @@ struct serial_uart_config {
 #define ASYNC_AUTOPROBE		(1U << ASYNCB_AUTOPROBE)
 
 #define ASYNC_FLAGS		((1U << (ASYNCB_LAST_USER + 1)) - 1)
-#define ASYNC_USR_MASK		(ASYNC_SPD_HI|ASYNC_SPD_VHI| \
-		ASYNC_CALLOUT_NOHUP|ASYNC_SPD_SHI|ASYNC_LOW_LATENCY)
+#define ASYNC_USR_MASK		(ASYNC_SPD_MASK|ASYNC_CALLOUT_NOHUP| \
+		ASYNC_LOW_LATENCY)
 #define ASYNC_SPD_CUST		(ASYNC_SPD_HI|ASYNC_SPD_VHI)
 #define ASYNC_SPD_WARP		(ASYNC_SPD_HI|ASYNC_SPD_SHI)
 #define ASYNC_SPD_MASK		(ASYNC_SPD_HI|ASYNC_SPD_VHI|ASYNC_SPD_SHI)
-- 
1.7.9.2


