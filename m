Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1CLWvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:51:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40480 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab1CLWu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:50:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=e2WnTZ8pSAfFfiyg441CWHXpn8o7Z9+lPter2lXJqu2DbuDJ0rFyKEk3dXBnCWJmTV
         GhVrRqullcXsxofM0nTftwkEnuzG3W0JPeBNYsrWEYBJS8rq4dLP1s24bA6RgJhhaL3s
         JUGQWsokAL1oaj59bxFXlcxpxO2B8M8XWpqrQ=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 3/5] OMAP2+:Common CPU DIE ID reading code reads wrong
 registers for OMAP4430
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:50:54 +0000
Message-ID: <20110312225054.27728.89155.stgit@otae.warmcat.com>
In-Reply-To: <20110312224440.27728.60593.stgit@otae.warmcat.com>
References: <20110312224440.27728.60593.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adapts the register offsets used to read the CPU DIE ID registers
when run on 44XX so they match what is in the OMAP4430 Reference Manual
page 269

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 arch/arm/mach-omap2/id.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index fc69ec5..733bb27 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -84,6 +84,11 @@ EXPORT_SYMBOL(omap_type);
 #define OMAP_TAP_DIE_ID_2	0x0220
 #define OMAP_TAP_DIE_ID_3	0x0224
 
+#define OMAP_TAP_DIE_ID_44XX_0	0x0200
+#define OMAP_TAP_DIE_ID_44XX_1	0x0208
+#define OMAP_TAP_DIE_ID_44XX_2	0x020c
+#define OMAP_TAP_DIE_ID_44XX_3	0x0210
+
 #define read_tap_reg(reg)	__raw_readl(tap_base  + (reg))
 
 struct omap_id {
@@ -107,6 +112,14 @@ static u16 tap_prod_id;
 
 void omap_get_die_id(struct omap_die_id *odi)
 {
+	if (cpu_is_omap44xx()) {
+		odi->id_0 = read_tap_reg(OMAP_TAP_DIE_ID_44XX_0);
+		odi->id_1 = read_tap_reg(OMAP_TAP_DIE_ID_44XX_1);
+		odi->id_2 = read_tap_reg(OMAP_TAP_DIE_ID_44XX_2);
+		odi->id_3 = read_tap_reg(OMAP_TAP_DIE_ID_44XX_3);
+
+		return;
+	}
 	odi->id_0 = read_tap_reg(OMAP_TAP_DIE_ID_0);
 	odi->id_1 = read_tap_reg(OMAP_TAP_DIE_ID_1);
 	odi->id_2 = read_tap_reg(OMAP_TAP_DIE_ID_2);

