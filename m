Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2CYAbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 20:31:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63036 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab2CYAbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 20:31:16 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Torben Hohn <torbenh@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] gpio/sodaville: Mark broken due to core irqdomain migration
Date: Sat, 24 Mar 2012 08:11:19 +0000
Message-Id: <1332576679-6251-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sodaville driver doesn't build anymore due to the transition to
common irq_domain in the core code.  It needs to be reworked, but
the rework isn't trivial.  Since this is a new driver anyway for
v3.4, mark it as broken now and a fixup patch can re-enable it when
the rework change has been tested.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Hans J. Koch <hjk@linutronix.de>
Cc: Torben Hohn <torbenh@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

Hans,

I'm sorry that I need to do this, but the irqdomain rework broke this
driver. The fixup turns out to be non-trivial so I'm not confident to
just merge it.  I'll send you the draft patch that I have to fix it up
in a separate email.  It will be up to you to test and repost it.
However, the fix doesn't need to wait for v3.5; I'm okay to take a
fixup patch after the merge window closes.

Cheers,
g.

 drivers/gpio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index dbb1909..dfea1d8 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -419,7 +419,7 @@ config GPIO_ML_IOH
 
 config GPIO_SODAVILLE
 	bool "Intel Sodaville GPIO support"
-	depends on X86 && PCI && OF
+	depends on X86 && PCI && OF && BROKEN
 	select GPIO_GENERIC
 	select GENERIC_IRQ_CHIP
 	help
-- 
1.7.9.1

