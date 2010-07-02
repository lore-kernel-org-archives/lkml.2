Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab0GBMlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 08:41:14 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:32948 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754550Ab0GBMlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 08:41:12 -0400
Date: Fri, 2 Jul 2010 16:41:11 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>,
       Peter Tyser <ptyser@xes-inc.com>, Dave Jiang <djiang@mvista.com>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 1/2] edac: mpc85xx: Fix MPC85xx dependency
Message-ID: <20100702124111.GA23320@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 5753c082f66eca5be81f6bda85c1718c5eea6ada ("powerpc/85xx:
Kconfig cleanup"), there is no MPC85xx Kconfig symbol anymore, so the
driver became non-selectable.

This patch fixes the issue by switching to PPC_85xx symbol.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/edac/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index aedef79..0d2f9db 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -209,7 +209,7 @@ config EDAC_I5100
 
 config EDAC_MPC85XX
 	tristate "Freescale MPC83xx / MPC85xx"
-	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || MPC85xx)
+	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || PPC_85xx)
 	help
 	  Support for error detection and correction on the Freescale
 	  MPC8349, MPC8560, MPC8540, MPC8548
-- 
1.7.0.5

