Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2BXLK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:10:27 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:44129 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2BXLK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:10:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: tony.luck@intel.com
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 2/4] IA64: simserial, include some headers
Date: Fri, 24 Feb 2012 12:10:16 +0100
Message-Id: <1330081818-15517-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330081818-15517-1-git-send-email-jslaby@suse.cz>
References: <1330081818-15517-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And remove declarations which are already in the headers.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/ia64/hp/sim/simserial.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index bff0824..974cac8 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -34,9 +34,12 @@
 #include <linux/sysrq.h>
 
 #include <asm/irq.h>
+#include <asm/hpsim.h>
 #include <asm/hw_irq.h>
 #include <asm/uaccess.h>
 
+#include "hpsim_ssc.h"
+
 #undef SIMSERIAL_DEBUG	/* define this to get some debug information */
 
 #define KEYBOARD_INTR	3	/* must match with simulator! */
@@ -45,11 +48,6 @@
 
 #define IRQ_T(info) ((info->flags & ASYNC_SHARE_IRQ) ? IRQF_SHARED : IRQF_DISABLED)
 
-#define SSC_GETCHAR	21
-
-extern long ia64_ssc (long, long, long, long, int);
-extern void ia64_ssc_connect_irq (long intr, long irq);
-
 static char *serial_name = "SimSerial driver";
 static char *serial_version = "0.6";
 
-- 
1.7.9


