Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab1JBOu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:50:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1JBOrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 28/30] ARM: omap: select CPU_FREQ_TABLE where needed
Date: Sun,  2 Oct 2011 16:45:58 +0200
Message-Id: <1317566760-25681-29-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1XHcFtNq01ejbeVpSwhISYDDdBGV58KPFtPo26nhvqr
 kwewvL2yLvPifdXSoz9w2wfE6srRPouRHYFPuF71RL4p1noXCc
 HJzTt6jsoRwuKnyakt+BBzG6Jkv82uchWMPRAjZgQchXrZs1GK
 1SWqKsCvTAMjJjjEPD09EuaZIEUiTwF3zvpARs9JNcRIvkVeUb
 hV46SNQoBEzzNmSxpaf/3+p5r4j8PxAmQxBsTLFA/emy2mXxaT
 t4LhLQqv+8tgWk1r0peKYsj5PFJTK9FQ60WIwRqZnG++822Sxl
 KfkT6goPqBoFC450L6Ab15u3EMagb38tzGBgkdXvUo5fOstCs1
 FK9XZWTVxlL0LnktsUKFvnpAMZv0rygjg5KfMansH6Lgog+2Ln
 XwX+voLba0FOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap platform requires CPU_FREQ_TABLE support to be enabled for its
CPU_FREQ implementations, so automatically select that when CPU_FREQ
is enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/plat-omap/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index bb8f4a6..f7ef9f4 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -217,6 +217,11 @@ config OMAP_PM_NOOP
 
 endchoice
 
+config OMAP_CPU_FREQ
+	def_bool "y"
+	depends on CPU_FREQ
+	select CPU_FREQ_TABLE
+
 endmenu
 
 endif
-- 
1.7.5.4

