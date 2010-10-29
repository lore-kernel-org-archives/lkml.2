Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059Ab0J2Vhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 17:37:37 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:45666 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761716Ab0J2Vhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 17:37:36 -0400
Date: Fri, 29 Oct 2010 23:31:09 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mach-pxa: sharpsl_pm: simplify conditional
Message-ID: <20101029233109.28692cbf@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify: ((a && b) || !a) => (b || !a)

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 arch/arm/mach-pxa/sharpsl_pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 8fed027..d08763c 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -619,7 +619,7 @@ static void corgi_goto_sleep(unsigned long alarm_time, unsigned int alarm_enable
 	PEDR = 0xffffffff; /* clear it */
 
 	sharpsl_pm.flags &= ~SHARPSL_ALARM_ACTIVE;
-	if ((sharpsl_pm.charge_mode == CHRG_ON) && ((alarm_enable && ((alarm_time - RCNR) > (SHARPSL_BATCHK_TIME_SUSPEND + 30))) || !alarm_enable)) {
+	if ((sharpsl_pm.charge_mode == CHRG_ON) && (((alarm_time - RCNR) > (SHARPSL_BATCHK_TIME_SUSPEND + 30)) || !alarm_enable)) {
 		RTSR &= RTSR_ALE;
 		RTAR = RCNR + SHARPSL_BATCHK_TIME_SUSPEND;
 		dev_dbg(sharpsl_pm.dev, "Charging alarm at: %08x\n", RTAR);
-- 
1.7.2.2
