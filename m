Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab1HCXZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:25:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab1HCXZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:25:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:46 2011
Message-Id: <20110803221245.931335650@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Igor Grinberg <grinberg@compulab.co.il>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [019/102] ARM: pxa/cm-x300: fix V3020 RTC functionality
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Igor Grinberg <grinberg@compulab.co.il>

commit 6c7b3ea52e345ab614edb91d3f0e9f3bb3713871 upstream.

While in sleep mode the CS# and other V3020 RTC GPIOs must be driven
high, otherwise V3020 RTC fails to keep the right time in sleep mode.

Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-pxa/cm-x300.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -161,10 +161,10 @@ static mfp_cfg_t cm_x3xx_mfp_cfg[] __ini
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


