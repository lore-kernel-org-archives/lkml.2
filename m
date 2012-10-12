Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2JLGv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:51:56 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:56185 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2JLGvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:51:55 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2012 02:51:54 EDT
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH] openrisc: avoid using function parameter regs in reset vector
Date: Fri, 12 Oct 2012 09:38:18 +0300
Message-Id: <1350023898-15130-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel might be invoked through the reset vector, so to
preserve parameters passed to it, temp regs that are not
in the function parameter range needs to be used.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/kernel/head.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index 1088b5f..46aa940 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -291,9 +291,9 @@
 	/* Jump to .init code at _start which lives in the .head section
 	 * and will be discarded after boot.
 	 */
-	LOAD_SYMBOL_2_GPR(r4, _start)
-	tophys	(r3,r4)			/* MMU disabled */
-	l.jr	r3
+	LOAD_SYMBOL_2_GPR(r15, _start)
+	tophys	(r13,r15)			/* MMU disabled */
+	l.jr	r13
 	 l.nop
 
 /* ---[ 0x200: BUS exception ]------------------------------------------- */
-- 
1.7.9.5

