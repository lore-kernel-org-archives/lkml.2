Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967229Ab2EPBEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:04:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:43032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967209Ab2EPBEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:04:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166845075"
Date: Wed, 16 May 2012 09:08:18 +0800
From: Xudong Hao <xudong.hao@linux.intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, haitao.shan@intel.com,
        xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: [PATCH 2/4] Add parameter to control A/D bits support
Message-ID: <20120516010818.GC14256@hp-xd.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
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
index d2bd719..811a61e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -64,6 +64,9 @@ static bool __read_mostly enable_unrestricted_guest = 1;
 module_param_named(unrestricted_guest,
            enable_unrestricted_guest, bool, S_IRUGO);

+static int __read_mostly enable_ept_ad_bits = 1;
+module_param_named(ept_ad_bits, enable_ept_ad_bits, bool, S_IRUGO);
+
 static bool __read_mostly emulate_invalid_guest_state = 0;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);

@@ -779,6 +782,11 @@ static inline bool cpu_has_vmx_ept_4levels(void)
    return vmx_capability.ept & VMX_EPT_PAGE_WALK_4_BIT;
 }

+static inline bool cpu_has_vmx_ept_ad_bits(void)
+{
+   return vmx_capability.ept & VMX_EPT_AD_BIT;
+}
+
 static inline bool cpu_has_vmx_invept_individual_addr(void)
 {
    return vmx_capability.ept & VMX_EPT_EXTENT_INDIVIDUAL_BIT;
@@ -2611,8 +2619,12 @@ static __init int hardware_setup(void)
        !cpu_has_vmx_ept_4levels()) {
        enable_ept = 0;
        enable_unrestricted_guest = 0;
+       enable_ept_ad_bits = 0;
    }

+   if (!cpu_has_vmx_ept_ad_bits())
+       enable_ept_ad_bits = 0;
+
    if (!cpu_has_vmx_unrestricted_guest())
        enable_unrestricted_guest = 0;

--
1.7.1

