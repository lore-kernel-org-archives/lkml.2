Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1GUKMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:12:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:54116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab1GUKMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:12:12 -0400
Date: Thu, 21 Jul 2011 10:11:42 GMT
From: tip-bot for Sergei Shtylyov <sshtylyov@ru.mvista.com>
Message-ID: <tip-38175051f8e79c5e9f65daab7200fd8d1fa4a912@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sshtylyov@ru.mvista.com, jbarnes@virtuousgeek.org, davej@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sshtylyov@ru.mvista.com, jbarnes@virtuousgeek.org, tglx@linutronix.de,
        davej@redhat.com, mingo@elte.hu
In-Reply-To: <201107111901.39281.sshtylyov@ru.mvista.com>
References: <201107111901.39281.sshtylyov@ru.mvista.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/quirks] x86, quirks: Use pci_dev->revision
Git-Commit-ID: 38175051f8e79c5e9f65daab7200fd8d1fa4a912
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:11:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38175051f8e79c5e9f65daab7200fd8d1fa4a912
Gitweb:     http://git.kernel.org/tip/38175051f8e79c5e9f65daab7200fd8d1fa4a912
Author:     Sergei Shtylyov <sshtylyov@ru.mvista.com>
AuthorDate: Mon, 11 Jul 2011 19:01:38 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 10:26:00 +0200

x86, quirks: Use pci_dev->revision

This code uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so
it wasn't converted by commit 44c10138fd4bbc ("PCI: Change all
drivers to use pci_device->revision") before being moved to arch/x86/...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/r/201107111901.39281.sshtylyov@ru.mvista.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/quirks.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 8bbe8c5..b78643d 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -10,7 +10,7 @@
 
 static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
 {
-	u8 config, rev;
+	u8 config;
 	u16 word;
 
 	/* BIOS may enable hardware IRQ balancing for
@@ -18,8 +18,7 @@ static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
 	 * based platforms.
 	 * Disable SW irqbalance/affinity on those platforms.
 	 */
-	pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
-	if (rev > 0x9)
+	if (dev->revision > 0x9)
 		return;
 
 	/* enable access to config space*/
