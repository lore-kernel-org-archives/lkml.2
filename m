Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2L1QxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 11:53:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:40904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab2L1QxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 11:53:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,371,1355126400"; 
   d="scan'208";a="264270449"
From: shuox.liu@intel.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, yanmin_zhang@intel.linux.com,
        ShuoX Liu <shuox.liu@intel.com>
Subject: [PATCH] perf/x86: Enable Intel Lincroft/Penwell/Cloverview Atom support
Date: Sat, 29 Dec 2012 00:48:44 +0800
Message-Id: <1356713324-12442-1-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

These three chip are based on Atom and have different model id.
So add such three id for perf HW event support.

Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 93b9e11..c788e5f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2019,6 +2019,9 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 28: /* Atom */
+	case 38: /* Lincroft */
+	case 39: /* Penwell */
+	case 53: /* Cloverview */
 	case 54: /* Cedariew */
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
-- 
1.7.1

