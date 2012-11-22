Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab2KVWAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:00:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:49635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab2KVSkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michael Burkey <mdburkey@gmail.com>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [ 35/83] ARM: imx: ehci: fix host power mask bit
Date: Wed, 21 Nov 2012 16:41:57 -0800
Message-Id: <20121122004216.531273574@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/ehci-imx25.c |    2 +-
 arch/arm/mach-imx/ehci-imx35.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-imx/ehci-imx25.c
+++ b/arch/arm/mach-imx/ehci-imx25.c
@@ -30,7 +30,7 @@
 #define MX25_H1_SIC_SHIFT	21
 #define MX25_H1_SIC_MASK	(0x3 << MX25_H1_SIC_SHIFT)
 #define MX25_H1_PP_BIT		(1 << 18)
-#define MX25_H1_PM_BIT		(1 << 8)
+#define MX25_H1_PM_BIT		(1 << 16)
 #define MX25_H1_IPPUE_UP_BIT	(1 << 7)
 #define MX25_H1_IPPUE_DOWN_BIT	(1 << 6)
 #define MX25_H1_TLL_BIT		(1 << 5)
--- a/arch/arm/mach-imx/ehci-imx35.c
+++ b/arch/arm/mach-imx/ehci-imx35.c
@@ -30,7 +30,7 @@
 #define MX35_H1_SIC_SHIFT	21
 #define MX35_H1_SIC_MASK	(0x3 << MX35_H1_SIC_SHIFT)
 #define MX35_H1_PP_BIT		(1 << 18)
-#define MX35_H1_PM_BIT		(1 << 8)
+#define MX35_H1_PM_BIT		(1 << 16)
 #define MX35_H1_IPPUE_UP_BIT	(1 << 7)
 #define MX35_H1_IPPUE_DOWN_BIT	(1 << 6)
 #define MX35_H1_TLL_BIT		(1 << 5)


