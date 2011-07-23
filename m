Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1GWJeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 05:34:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40282 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1GWJej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 05:34:39 -0400
Date: Sat, 23 Jul 2011 11:33:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/quirks change for v3.1
Message-ID: <20110723093356.GA20669@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-quirks-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-quirks-for-linus

 Thanks,

	Ingo

------------------>
Sergei Shtylyov (1):
      x86, quirks: Use pci_dev->revision


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
