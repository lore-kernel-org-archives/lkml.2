Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965728Ab2EOCmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:42:20 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53478 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275Ab2EOCRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 123/179] ARM: pxa/cm-x300: fix V3020 RTC functionality
Date: Mon, 14 May 2012 22:13:39 -0400
Message-ID: <1337048075-6132-124-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Igor Grinberg <grinberg@compulab.co.il>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6c7b3ea52e345ab614edb91d3f0e9f3bb3713871 upstream.

While in sleep mode the CS# and other V3020 RTC GPIOs must be driven
high, otherwise V3020 RTC fails to keep the right time in sleep mode.

Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/mach-pxa/cm-x300.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-pxa/cm-x300.c b/arch/arm/mach-pxa/cm-x300.c
index f054062..945b52a 100644
--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -154,10 +154,10 @@ static mfp_cfg_t cm_x3xx_mfp_cfg[] __initdata = {
 	GPIO99_GPIO,			/* Ethernet IRQ */
 
 	/* RTC GPIOs */
-	GPIO95_GPIO,			/* RTC CS */
-	GPIO96_GPIO,			/* RTC WR */
-	GPIO97_GPIO,			/* RTC RD */
-	GPIO98_GPIO,			/* RTC IO */
+	GPIO95_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC CS */
+	GPIO96_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC WR */
+	GPIO97_GPIO | MFP_LPM_DRIVE_HIGH,	/* RTC RD */
+	GPIO98_GPIO,				/* RTC IO */
 
 	/* Standard I2C */
 	GPIO21_I2C_SCL,
-- 
1.7.9.6

