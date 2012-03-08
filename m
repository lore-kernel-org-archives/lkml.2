Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab2CHUBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:01:50 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58281 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab2CHUBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:01:38 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] [IA64] simserial, include some headers
Date: Thu,  8 Mar 2012 21:01:17 +0100
Message-Id: <1331236879-20124-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1331236879-20124-1-git-send-email-jslaby@suse.cz>
References: <20120308195028.GA17564@kroah.com>
 <1331236879-20124-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And remove declarations which are already in the headers.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/hp/sim/simserial.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

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
1.7.9.2


