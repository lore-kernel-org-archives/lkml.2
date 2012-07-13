Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2GMUqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:46:09 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3901 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab2GMUqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:46:05 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Al Cooper" <alcooperx@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
cc: "Al Cooper" <alcooperx@gmail.com>
Subject: [PATCH 3/5] MIPS: perf: Remove unnecessary #ifdef
Date: Fri, 13 Jul 2012 16:44:52 -0400
Message-ID: <1342212294-23014-3-git-send-email-alcooperx@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1342212294-23014-1-git-send-email-alcooperx@gmail.com>
References: <y> <1342212294-23014-1-git-send-email-alcooperx@gmail.com>
MIME-Version: 1.0
X-WSS-ID: 7C1E57523MK9973575-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The #ifdef for CONFIG_HW_PERF_EVENTS is not needed because the
Makefile will only compile the module if this config option is set.
This means that the code under #else would never be compiled. This
may have been done to leave the original broken code around for
reference, but the FIXME comment above the code already shows the
broken code.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
---
 arch/mips/kernel/perf_event_mipsxx.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 4ee1111..19253d7 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -139,13 +139,8 @@ static DEFINE_RWLOCK(pmuint_rwlock);
  * FIXME: For VSMP, vpe_id() is redefined for Perf-events, because
  * cpu_data[cpuid].vpe_id reports 0 for _both_ CPUs.
  */
-#if defined(CONFIG_HW_PERF_EVENTS)
 #define vpe_id()	(cpu_has_mipsmt_pertccounters ? \
 			0 : smp_processor_id())
-#else
-#define vpe_id()	(cpu_has_mipsmt_pertccounters ? \
-			0 : cpu_data[smp_processor_id()].vpe_id)
-#endif
 
 /* Copied from op_model_mipsxx.c */
 static unsigned int vpe_shift(void)
-- 
1.7.6


