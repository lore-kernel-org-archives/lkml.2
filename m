Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0GINvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:51:25 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50492 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab0GINvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:51:23 -0400
Date: Fri, 9 Jul 2010 15:51:21 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 02/11] Removing dead CONSOLE_*
Message-ID: <12d3f51154aac6de4f85b1a3d64ba91d8e0f0339.1278682302.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONSOLE_* doesn't exist in Kconfig, therefore removing all references
for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/68360serial.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/68360serial.c b/drivers/serial/68360serial.c
index 24661cd..f72972b 100644
--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -303,16 +303,8 @@ static int baud_table[] = {
 	9600, 19200, 38400, 57600, 115200, 230400, 460800, 0 };
 
 /* This sucks. There is a better way: */
-#if defined(CONFIG_CONSOLE_9600)
-  #define CONSOLE_BAUDRATE 9600
-#elif defined(CONFIG_CONSOLE_19200)
-  #define CONSOLE_BAUDRATE 19200
-#elif defined(CONFIG_CONSOLE_115200)
-  #define CONSOLE_BAUDRATE 115200
-#else
-  #warning "console baud rate undefined"
-  #define CONSOLE_BAUDRATE 9600
-#endif
+#warning "console baud rate undefined"
+#define CONSOLE_BAUDRATE 9600
 
 /*
  * ------------------------------------------------------------
-- 
1.7.0.4

