Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893Ab2CENxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:38 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34868 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964879Ab2CENxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 31/68] TTY: simserial, remove IRQ_T
Date: Mon,  5 Mar 2012 14:52:18 +0100
Message-Id: <1330955575-26641-32-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not set ASYNC_SHARE_IRQ anywhere. And since IRQF_DISABLED is a
noop, pass zero to request_irq directly instead of this ugly macro.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index c35552d..8b5a134 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -46,8 +46,6 @@
 
 #define NR_PORTS	1	/* only one port for now */
 
-#define IRQ_T(state) ((state->flags & ASYNC_SHARE_IRQ) ? IRQF_SHARED : IRQF_DISABLED)
-
 static char *serial_name = "SimSerial driver";
 static char *serial_version = "0.6";
 
@@ -644,8 +642,8 @@ startup(struct async_struct *info)
 	 * Allocate the IRQ if necessary
 	 */
 	if (state->irq) {
-		retval = request_irq(state->irq, rs_interrupt_single,
-				IRQ_T(state), "simserial", info);
+		retval = request_irq(state->irq, rs_interrupt_single, 0,
+				"simserial", info);
 		if (retval)
 			goto errout;
 	}
-- 
1.7.9.2


