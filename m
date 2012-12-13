Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2LMOsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:48:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44429 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab2LMOGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Fritz <chf.fritz@googlemail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 098/241] ARM: imx: ehci: fix host power mask bit
Date: Thu, 13 Dec 2012 11:57:43 -0200
Message-Id: <1355407206-17100-99-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Fritz <chf.fritz@googlemail.com>

commit 3d5e2abe6e265acc5e1fda810301243e9bac92b2 upstream.

This patch sets HPM (Host power mask bit) to bit 16 according to i.MX
Reference Manual. Falsely it was set to bit 8, but this controls pull-up
Impedance.

Reported-by: Michael Burkey <mdburkey@gmail.com>
Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Acked-by: Eric Bénard <eric@eukrea.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/mach-imx/ehci-imx25.c |    2 +-
 arch/arm/mach-imx/ehci-imx35.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/ehci-imx25.c b/arch/arm/mach-imx/ehci-imx25.c
index 865daf0..dabc5d5 100644
--- a/arch/arm/mach-imx/ehci-imx25.c
+++ b/arch/arm/mach-imx/ehci-imx25.c
@@ -27,7 +27,7 @@
 
 #define MX25_H1_SIC_SHIFT	21
 #define MX25_H1_SIC_MASK	(0x3 << MX25_H1_SIC_SHIFT)
-#define MX25_H1_PM_BIT		(1 << 8)
+#define MX25_H1_PM_BIT		(1 << 16)
 #define MX25_H1_IPPUE_UP_BIT	(1 << 7)
 #define MX25_H1_IPPUE_DOWN_BIT	(1 << 6)
 #define MX25_H1_TLL_BIT		(1 << 5)
diff --git a/arch/arm/mach-imx/ehci-imx35.c b/arch/arm/mach-imx/ehci-imx35.c
index 001ec39..8ea2dfa 100644
--- a/arch/arm/mach-imx/ehci-imx35.c
+++ b/arch/arm/mach-imx/ehci-imx35.c
@@ -27,7 +27,7 @@
 
 #define MX35_H1_SIC_SHIFT	21
 #define MX35_H1_SIC_MASK	(0x3 << MX35_H1_SIC_SHIFT)
-#define MX35_H1_PM_BIT		(1 << 8)
+#define MX35_H1_PM_BIT		(1 << 16)
 #define MX35_H1_IPPUE_UP_BIT	(1 << 7)
 #define MX35_H1_IPPUE_DOWN_BIT	(1 << 6)
 #define MX35_H1_TLL_BIT		(1 << 5)
-- 
1.7.9.5

