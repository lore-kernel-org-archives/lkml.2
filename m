Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0GINta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:49:30 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50304 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756517Ab0GINt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:49:28 -0400
Date: Fri, 9 Jul 2010 15:49:27 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Greg Ungerer <gerg@uclinux.org>,
       Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 04/11] Removing dead (ALMA_ANS | DRAGONIXVZ | M68EZ328ADS)
Message-ID: <875b29bdbcde4a108967933020bc00283921b968.1278682302.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(ALMA_ANS | DRAGONIXVZ | M68EZ328ADS) doesn't exist in Kconfig,
therefore removing all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/68328serial.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 3046386..db7d8eb 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -102,19 +102,13 @@ static void change_speed(struct m68k_serial *info);
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
1.7.0.4

