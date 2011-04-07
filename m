Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab1DGBfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 21:35:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:50963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757265Ab1DGBfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 21:35:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,313,1299484800"; 
   d="scan'208";a="676184504"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, alan@linux.intel.com
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH 2/2] x86/vrtc: fix a bug in mrst_rtc_init()
Date: Thu,  7 Apr 2011 09:39:49 +0800
Message-Id: <1302140389-27603-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sfi_mrtc_array[] only gets initialized when the sfi mrtc table
is parsed, so the vrtc_paddr should be initalized after it too.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/platform/mrst/vrtc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index 04cf645..73d70d6 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -100,9 +100,11 @@ int vrtc_set_mmss(unsigned long nowtime)
 
 void __init mrst_rtc_init(void)
 {
-	unsigned long vrtc_paddr = sfi_mrtc_array[0].phys_addr;
+	unsigned long vrtc_paddr;
 
 	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
+
+	vrtc_paddr = sfi_mrtc_array[0].phys_addr;
 	if (!sfi_mrtc_num || !vrtc_paddr)
 		return;
 
-- 
1.7.0.4

