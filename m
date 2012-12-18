Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2LRMHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:07:44 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40615 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2LRMHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:07:43 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, nico@linaro.org, will.deacon@arm.com,
        marc.zyngier@arm.com, john.stultz@linaro.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 1/5] ARM: remove useless guard in smp.c
Date: Tue, 18 Dec 2012 12:06:54 +0000
Message-Id: <1355832418-31692-2-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
X-OriginalArrivalTime: 18 Dec 2012 12:07:17.0922 (UTC) FILETIME=[399DF820:01CDDD18]
X-MC-Unique: 112121812072003201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qBIC7ioA018305

Currently we only provide an implementation of smp_timer_broadcast in
smp.c if GENERIC_CLOCKEVENTS_BROADCAST is selected. As
smp_timer_broadcast is only used in smp.c, smp.c depends on SMP, and
GENERIC_CLOCKEVENTS_BROADCAST is selected by SMP, this is unnecessary.

This patch removes the redundant guard.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm/kernel/smp.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index fbc8b26..21954bc 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -473,14 +473,10 @@ static void ipi_timer(void)
 	evt->event_handler(evt);
 }
 
-#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 static void smp_timer_broadcast(const struct cpumask *mask)
 {
 	smp_cross_call(mask, IPI_TIMER);
 }
-#else
-#define smp_timer_broadcast	NULL
-#endif
 
 static void broadcast_timer_set_mode(enum clock_event_mode mode,
 	struct clock_event_device *evt)
-- 
1.7.0.4


