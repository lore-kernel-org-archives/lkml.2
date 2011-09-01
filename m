Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1IAUAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 16:00:17 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:53012
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757777Ab1IAUAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 16:00:15 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Stephen George <stephen.george@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: Stephen George <stephen.george@freescale.com>
Subject: [PATCH] perf: Exporting perf PMU functions
Date: Thu, 1 Sep 2011 14:58:54 -0500
Message-ID: <1314907134-5098-1-git-send-email-stephen.george@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These exports allow a perf PMU to be implemented as a module
instead of being restricted to being a built-in.

Signed-off-by: Stephen George <stephen.george@freescale.com>
---
 kernel/events/core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9efe710..007c848 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -555,6 +555,7 @@ void perf_pmu_disable(struct pmu *pmu)
 	if (!(*count)++)
 		pmu->pmu_disable(pmu);
 }
+EXPORT_SYMBOL_GPL(perf_pmu_disable);
 
 void perf_pmu_enable(struct pmu *pmu)
 {
@@ -562,6 +563,7 @@ void perf_pmu_enable(struct pmu *pmu)
 	if (!--(*count))
 		pmu->pmu_enable(pmu);
 }
+EXPORT_SYMBOL_GPL(perf_pmu_enable);
 
 static DEFINE_PER_CPU(struct list_head, rotation_list);
 
@@ -6085,6 +6087,7 @@ free_pdc:
 	free_percpu(pmu->pmu_disable_count);
 	goto unlock;
 }
+EXPORT_SYMBOL_GPL(perf_pmu_register);
 
 void perf_pmu_unregister(struct pmu *pmu)
 {
@@ -6106,6 +6109,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	put_device(pmu->dev);
 	free_pmu_context(pmu);
 }
+EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
 struct pmu *perf_init_event(struct perf_event *event)
 {
-- 
1.7.1


