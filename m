Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab1ANMaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 07:30:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:35410 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1ANMaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 07:30:05 -0500
From: Michal Marek <mmarek@suse.cz>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: sdhci-of does not build on x86
Date: Fri, 14 Jan 2011 13:29:51 +0100
Message-Id: <1295008191-1596-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit c10d1e2, CONFIG_OLPC selects CONFIG_OF, which enables to
select CONFIG_MMC_SDHCI_OF, which does not build on x86:

drivers/mmc/host/sdhci-of-core.c:24:25: fatal error: asm/machdep.h: No
such file or directory

Signed-off-by: Michal Marek <mmarek@suse.cz>
---

I don't know if the driver could possibly work on some OLPC hardware,
but it wasn't used on x86 before, so this patch won't make things any worse.

Michal
---
 drivers/mmc/host/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index afe8c6f..9901656 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -83,7 +83,7 @@ config MMC_RICOH_MMC
 
 config MMC_SDHCI_OF
 	tristate "SDHCI support on OpenFirmware platforms"
-	depends on MMC_SDHCI && OF
+	depends on MMC_SDHCI && OF && !X86
 	help
 	  This selects the OF support for Secure Digital Host Controller
 	  Interfaces.
-- 
1.7.3.4

