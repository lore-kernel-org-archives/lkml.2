Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994Ab2C2VP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:15:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33798 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922Ab2C2VM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:12:58 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
Subject: [PATCH 10/17] ia64: mark const init data with __initconst instead of __initdata
Date: Thu, 29 Mar 2012 23:12:27 +0200
Message-Id: <1333055554-31300-10-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <20120329211131.GA31250@pengutronix.de>
References: <20120329211131.GA31250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there is no other non-const variable marked __initdata in the
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/xen/irq_xen.c |    2 +-
 arch/ia64/xen/irq_xen.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/xen/irq_xen.c b/arch/ia64/xen/irq_xen.c
index 3bb1223..01f479e 100644
--- a/arch/ia64/xen/irq_xen.c
+++ b/arch/ia64/xen/irq_xen.c
@@ -433,7 +433,7 @@ xen_resend_irq(unsigned int vector)
 	(void)resend_irq_on_evtchn(vector);
 }
 
-const struct pv_irq_ops xen_irq_ops __initdata = {
+const struct pv_irq_ops xen_irq_ops __initconst = {
 	.register_ipi = xen_register_ipi,
 
 	.assign_irq_vector = xen_assign_irq_vector,
diff --git a/arch/ia64/xen/irq_xen.h b/arch/ia64/xen/irq_xen.h
index 26110f3..1778517 100644
--- a/arch/ia64/xen/irq_xen.h
+++ b/arch/ia64/xen/irq_xen.h
@@ -27,7 +27,7 @@ extern void (*late_time_init)(void);
 extern char xen_event_callback;
 void __init xen_init_IRQ(void);
 
-extern const struct pv_irq_ops xen_irq_ops __initdata;
+extern const struct pv_irq_ops xen_irq_ops __initconst;
 extern void xen_smp_intr_init(void);
 extern void xen_send_ipi(int cpu, int vec);
 
-- 
1.7.9.1

