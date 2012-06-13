Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2FMCCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 22:02:49 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59266 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2FMCCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 22:02:46 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 09/15] ARM: etm: Power down etm(s) when tracing is not enabled
Date: Tue, 12 Jun 2012 19:01:27 -0700
Message-Id: <1339552887-17204-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1339552887-17204-1-git-send-email-john.stultz@linaro.org>
References: <1339552887-17204-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061302-6148-0000-0000-000006A6D447
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Without this change a saw an 18% increase in idle power consumption
on one deivce when trace support is compiled into the kernel. Now
I see the same increase only when tracing.

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
CC: Mathieu Poirier <mathieu.poirier@linaro.org>

Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/kernel/etm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index e3309ea..66bf592 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -200,7 +200,7 @@ static int trace_stop_etm(struct tracectx *t, int id)
 
 	etm_unlock(t, id);
 
-	etm_writel(t, id, 0x440, ETMR_CTRL);
+	etm_writel(t, id, 0x441, ETMR_CTRL);
 	while (!(etm_readl(t, id, ETMR_CTRL) & ETMCTRL_PROGRAM) && --timeout)
 		;
 	if (!timeout) {
@@ -739,7 +739,7 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
 	(void)etm_readl(&tracer, t->etm_regs_count, ETMMR_OSSRR);
 
 	t->ncmppairs = etm_readl(t, t->etm_regs_count, ETMR_CONFCODE) & 0xf;
-	etm_writel(t, t->etm_regs_count, 0x440, ETMR_CTRL);
+	etm_writel(t, t->etm_regs_count, 0x441, ETMR_CTRL);
 	etm_writel(t, t->etm_regs_count, new_count, ETMR_TRACEIDR);
 	etm_lock(t, t->etm_regs_count);
 
-- 
1.7.3.2.146.gca209

