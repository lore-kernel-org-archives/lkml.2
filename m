Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab1HFAHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:07:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915Ab1HFAHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:07:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:51 2011
Message-Id: <20110806000251.082061022@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Igor Grinberg <grinberg@compulab.co.il>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [22/55] ARM: pxa/cm-x300: fix V3020 RTC functionality
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -143,10 +143,10 @@ static mfp_cfg_t cm_x300_mfp_cfg[] __ini
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


