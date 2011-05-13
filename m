Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064Ab1EMBFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 21:05:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46787 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759045Ab1EMBFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 21:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UFTFHCVlG4MfG8aXKVnICUMqTYmTuCiL8d+UP4YKsS+QnZQ7FFYihcUPNreBemi1S5
         J1Pl3nqiJg+HAkN08UwPw9Kazi8tw60jZiKPVN07UhXr4wYzAIVXJR9PHTM5oiVPY2+J
         rumJaT00QZAczCrKxa4c4cxEHu6sYdiexwgTQ=
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH] x86: Add Dell E5420 reboot quirk
Date: Fri, 13 May 2011 09:04:59 +0800
Message-Id: <1305248699-2347-1-git-send-email-daniel.blueman@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebooting on the Dell E5420 often hangs with the keyboard method,
but is reliable via the PCI method.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 08c44b0..b16032d 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -411,6 +411,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
+	{
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E5420",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
+		},
+	},
 	{ }
 };
 
-- 
1.7.4.1

