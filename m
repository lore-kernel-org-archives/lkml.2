Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab2BVJkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:40:00 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:18894 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2BVJj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:39:58 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 05/19] ARM: at91/ST: remove not needed casts
Date: Wed, 22 Feb 2012 10:39:31 +0100
Message-Id: <7fc3c7e0093a675e205fe1763de7dfccdda8e692.1329903206.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unnecessary (void) cast on at91_st_read()
return value.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91rm9200_time.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index 0c1980c..dd7f782 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -111,7 +111,7 @@ clkevt32k_mode(enum clock_event_mode mode, struct clock_event_device *dev)
 {
 	/* Disable and flush pending timer interrupts */
 	at91_st_write(AT91_ST_IDR, AT91_ST_PITS | AT91_ST_ALMS);
-	(void) at91_st_read(AT91_ST_SR);
+	at91_st_read(AT91_ST_SR);
 
 	last_crtr = read_CRTR();
 	switch (mode) {
@@ -157,7 +157,7 @@ clkevt32k_next_event(unsigned long delta, struct clock_event_device *dev)
 
 	/* Cancel any pending alarm; flush any pending IRQ */
 	at91_st_write(AT91_ST_RTAR, alm);
-	(void) at91_st_read(AT91_ST_SR);
+	at91_st_read(AT91_ST_SR);
 
 	/* Schedule alarm by writing RTAR. */
 	alm += delta;
@@ -192,7 +192,7 @@ void __init at91rm9200_timer_init(void)
 	/* Disable all timer interrupts, and clear any pending ones */
 	at91_st_write(AT91_ST_IDR,
 		AT91_ST_PITS | AT91_ST_WDOVF | AT91_ST_RTTINC | AT91_ST_ALMS);
-	(void) at91_st_read(AT91_ST_SR);
+	at91_st_read(AT91_ST_SR);
 
 	/* Make IRQs happen for the system timer */
 	setup_irq(AT91_ID_SYS, &at91rm9200_timer_irq);
-- 
1.7.9

