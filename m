Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab1BSV4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 16:56:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45697 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1BSV4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 16:56:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xyZxzWRYgtbLo6nBh9JcxdvbNqAL2ZnMA/cQPuNXkNPMWm1wzY7Jr9bv4wKywfaXYX
         7YEKcYvalxNgIQtSZc6BKugkQOpEWN+F7q1i+GpmlKLgdlvdJpAYN8G0UZaT8uK3eP19
         qTCadMTuzj8JDGtZZyHMcHQl0Z4XjT31g0hsA=
From: Kushal Koolwal <kushalkoolwal@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Kushal Koolwal <kushalkoolwal@gmail.com>
Subject: [PATCH 1/1] x86: Fix reboot problem on VersaLogic Menlow boards.
Date: Sat, 19 Feb 2011 13:56:03 -0800
Message-Id: <1298152563-21594-1-git-send-email-kushalkoolwal@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VersaLogic Menlow based boards hang on reboot unless reboot=bios is used.
Add quirk to reboot through the BIOS.

Tested on at least four boards.

Signed-off-by: Kushal Koolwal <kushalkoolwal@gmail.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index fc7aae1..715037c 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -285,6 +285,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
+	{	/* Handle problems with rebooting on VersaLogic Menlow boards */
+		.callback = set_bios_reboot,
+		.ident = "VersaLogic Menlow based board",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "VersaLogic Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "VersaLogic Menlow board"),
+		},
+	},
 	{ }
 };
 
-- 
1.7.2.3

