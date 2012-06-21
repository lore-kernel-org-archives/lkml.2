Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab2FUNcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 09:32:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41737 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab2FUNcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 09:32:07 -0400
Date: Thu, 21 Jun 2012 15:32:03 +0200
From: Uros Vampl <mobile.leecher@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] x86: Aspire One Happy2 reboots only with the kbd method
Message-ID: <20120621133203.GA26316@zverina>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a quirk to make the Acer Aspire One Happy2 reboot properly. For 
reference, discussion at the Arch forums: 
https://bbs.archlinux.org/viewtopic.php?id=143716

Signed-off-by: Uroš Vampl <mobile.leecher@gmail.com>

--- linux-3.4.3.orig/arch/x86/kernel/reboot.c	2012-06-17 20:21:44.000000000 +0200
+++ linux-3.4.3/arch/x86/kernel/reboot.c	2012-06-21 15:16:15.003430778 +0200
@@ -317,6 +317,14 @@
 			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
 		},
 	},
+	{ /* Handle reboot issue on Acer Aspire One Happy2 */
+		.callback = set_kbd_reboot,
+		.ident = "Acer Aspire One Happy2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOHAPPY2"),
+		},
+	},
 	{ }
 };
 
