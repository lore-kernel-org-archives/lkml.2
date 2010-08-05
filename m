Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901Ab0HEW0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:26:32 -0400
Received: from kroah.org ([198.145.64.141]:37805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934569Ab0HEWY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Christoph Egger <siccegge@cs.fau.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 58/67] serial: 68328serial.c: remove dead (ALMA_ANS | DRAGONIXVZ | M68EZ328ADS)
Date: Thu,  5 Aug 2010 15:23:25 -0700
Message-Id: <1281047014-23429-58-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Egger <siccegge@cs.fau.de>

(ALMA_ANS | DRAGONIXVZ | M68EZ328ADS) doesn't exist in Kconfig, therefore
remove all references to it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/68328serial.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index d8204f4..7356a56 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -98,19 +98,13 @@ static void change_speed(struct m68k_serial *info);
  *	Setup for console. Argument comes from the boot command line.
  */
 
-#if defined(CONFIG_M68EZ328ADS) || defined(CONFIG_ALMA_ANS) || defined(CONFIG_DRAGONIXVZ)
-#define	CONSOLE_BAUD_RATE	115200
-#define	DEFAULT_CBAUD		B115200
-#else
-	/* (es) */
-	/* note: this is messy, but it works, again, perhaps defined somewhere else?*/
-	#ifdef CONFIG_M68VZ328
-	#define CONSOLE_BAUD_RATE	19200
-	#define DEFAULT_CBAUD		B19200
-	#endif
-	/* (/es) */
+/* note: this is messy, but it works, again, perhaps defined somewhere else?*/
+#ifdef CONFIG_M68VZ328
+#define CONSOLE_BAUD_RATE	19200
+#define DEFAULT_CBAUD		B19200
 #endif
 
+
 #ifndef CONSOLE_BAUD_RATE
 #define	CONSOLE_BAUD_RATE	9600
 #define	DEFAULT_CBAUD		B9600
-- 
1.7.2

