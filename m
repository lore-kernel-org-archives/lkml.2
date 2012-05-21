Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab2EUDu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 23:50:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:5457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab2EUDuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 23:50:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="142675159"
From: Xudong Hao <xudong.hao@intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com, xiantao.zhang@intel.com,
        Xudong Hao <xudong.hao@intel.com>, Haitao Shan <haitao.shan@intel.com>
Subject: [PATCH v2 2/4] Add parameter to control A/D bits support
Date: Mon, 21 May 2012 11:54:01 +0800
Message-Id: <1337572443-22482-2-git-send-email-xudong.hao@intel.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1337572443-22482-1-git-send-email-xudong.hao@intel.com>
References: <1337572443-22482-1-git-send-email-xudong.hao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel parameter to control A/D bits support, it's on by default.

Signed-off-by: Haitao Shan <haitao.shan@intel.com>
Signed-off-by: Xudong Hao <xudong.hao@intel.com>
---
 arch/x86/kvm/vmx.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3062ea9..f3858bf 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -71,6 +71,9 @@ static bool __read_mostly enable_unrestricted_guest = 1;
 module_param_named(unrestricted_guest,
 			enable_unrestricted_guest, bool, S_IRUGO);
 
+static bool __read_mostly enable_ept_ad_bits = 1;
+module_param_named(eptad, enable_ept_ad_bits, bool, S_IRUGO);
+
 static bool __read_mostly emulate_invalid_guest_state = 0;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 
@@ -786,6 +789,11 @@ static inline bool cpu_has_vmx_ept_4levels(void)
 	return vmx_capability.ept & VMX_EPT_PAGE_WALK_4_BIT;
 }
 
+static inline bool cpu_has_vmx_ept_ad_bits(void)
+{
+	return vmx_capability.ept & VMX_EPT_AD_BIT;
+}
+
 static inline bool cpu_has_vmx_invept_individual_addr(void)
 {
 	return vmx_capability.ept & VMX_EPT_EXTENT_INDIVIDUAL_BIT;
@@ -2624,8 +2632,12 @@ static __init int hardware_setup(void)
 	    !cpu_has_vmx_ept_4levels()) {
 		enable_ept = 0;
 		enable_unrestricted_guest = 0;
+		enable_ept_ad_bits = 0;
 	}
 
+	if (!cpu_has_vmx_ept_ad_bits())
+		enable_ept_ad_bits = 0;
+
 	if (!cpu_has_vmx_unrestricted_guest())
 		enable_unrestricted_guest = 0;
 
-- 
1.5.6

