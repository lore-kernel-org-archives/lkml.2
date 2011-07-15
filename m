Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1GOPE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:04:28 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:33252 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1GOPE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:04:27 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 1/3] ARM: vexpress: Add clock definition for the SP805.
Date: Fri, 15 Jul 2011 11:04:00 -0400
Message-Id: <1310742242-14647-2-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com>
References: <1310742242-14647-1-git-send-email-nbowler@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that an entry for the SP805 watchdog in the table of clocks was
missing.  This results in the sp805_wdt driver rejecting the device with
the following errors:

  sp805-wdt mb:wdt: Clock not found
  sp805-wdt mb:wdt: Probe Failed!!!
  sp805-wdt: probe of mb:wdt failed with error -2

While not obviously stated in the hardware docs, the onboard SP810's
"REFCLK" is connected to a 32.768KHz crystal, and this drives the
watchdog.  Add a struct clk and corresponding lookup entry for it.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
---
 arch/arm/mach-vexpress/v2m.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 9e6b93b..d0d267a 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -318,6 +318,10 @@ static struct clk v2m_sp804_clk = {
 	.rate	= 1000000,
 };
 
+static struct clk v2m_ref_clk = {
+	.rate   = 32768,
+};
+
 static struct clk dummy_apb_pclk;
 
 static struct clk_lookup v2m_lookups[] = {
@@ -348,6 +352,9 @@ static struct clk_lookup v2m_lookups[] = {
 	}, {	/* CLCD */
 		.dev_id		= "mb:clcd",
 		.clk		= &osc1_clk,
+	}, {	/* SP805 WDT */
+		.dev_id		= "mb:wdt",
+		.clk		= &v2m_ref_clk,
 	}, {	/* SP804 timers */
 		.dev_id		= "sp804",
 		.con_id		= "v2m-timer0",
-- 
1.7.3.4

