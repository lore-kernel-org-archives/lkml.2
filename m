Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967366Ab2EPKrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:47:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:46940 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966987Ab2EPKrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="144622152"
Date: Wed, 16 May 2012 18:51:12 +0800
From: Xudong Hao <xudong.hao@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haitao Shan <haitao.shan@intel.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Xudong Hao <xudong.hao@intel.com>
Subject: [PATCH v2 2/4] Add parameter to control A/D bits support
Message-ID: <20120516105112.GA21786@hp-xd.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel parameter to control A/D bits support, it's on by default.

Changes from v1:
-Use bool type for enable_ept_ad_bit.
-Use "eptad" to replace "ept_ad_bits".

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

+static bool __read_mostly enable_ept_ad_bits = 1;
+module_param_named(eptad, enable_ept_ad_bits, bool, S_IRUGO);
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

