Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2DXMql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:46:41 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:45823 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753967Ab2DXMqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:46:40 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2012 08:46:40 EDT
From: Reinhard Tartler <tartler@cs.fau.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Reinhard Tartler <siretart@tauware.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.cs.fau.de, Reinhard Tartler <tartler@cs.fau.de>
Subject: [PATCH] ARM: mach-iop13xx: fix parameter declaration of iq81340sc_atux_map_irq
Date: Tue, 24 Apr 2012 14:36:16 +0200
Message-Id: <1335270976-5553-1-git-send-email-tartler@cs.fau.de>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Reinhard Tartler <siretart@tauware.de>

Fixes the following compiler warning:
arch/arm/mach-iop13xx/iq81340sc.c:63: warning: initialization from incompatible pointer type | warning: (near initialization for ‘iq81340sc_pci.map_irq’)

Signed-off-by: Reinhard Tartler <tartler@cs.fau.de>
---
 arch/arm/mach-iop13xx/iq81340sc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-iop13xx/iq81340sc.c b/arch/arm/mach-iop13xx/iq81340sc.c
index cd9e274..70e8db0 100644
--- a/arch/arm/mach-iop13xx/iq81340sc.c
+++ b/arch/arm/mach-iop13xx/iq81340sc.c
@@ -30,7 +30,7 @@
 extern int init_atu;
 
 static int __init
-iq81340sc_atux_map_irq(struct pci_dev *dev, u8 idsel, u8 pin)
+iq81340sc_atux_map_irq(const struct pci_dev *dev, u8 idsel, u8 pin)
 {
 	WARN_ON(idsel < 1 || idsel > 2);
 
-- 
1.7.9.5

