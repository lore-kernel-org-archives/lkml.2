Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2E1Ldq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 07:33:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:61054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab2E1Ldl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 07:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="149221432"
From: Xudong Hao <xudong.hao@intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        xiantao.zhang@intel.com, Xudong Hao <xudong.hao@intel.com>,
        Haitao Shan <haitao.shan@intel.com>
Subject: [PATCH v3 3/4] Enable EPT A/D bits if supported by turning on relevant bit in EPTP.
Date: Mon, 28 May 2012 19:33:36 +0800
Message-Id: <1338204816-20654-3-git-send-email-xudong.hao@intel.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1338204816-20654-1-git-send-email-xudong.hao@intel.com>
References: <1338204816-20654-1-git-send-email-xudong.hao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In EPT page structure entry, Enable EPT A/D bits if processor supported.

Signed-off-by: Haitao Shan <haitao.shan@intel.com>
Signed-off-by: Xudong Hao <xudong.hao@intel.com>
---
 arch/x86/kvm/vmx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 811a61e..89151a9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3005,6 +3005,8 @@ static u64 construct_eptp(unsigned long root_hpa)
 	/* TODO write the value reading from MSR */
 	eptp = VMX_EPT_DEFAULT_MT |
 		VMX_EPT_DEFAULT_GAW << VMX_EPT_GAW_EPTP_SHIFT;
+	if (enable_ept_ad_bits)
+		eptp |= VMX_EPT_AD_ENABLE_BIT;
 	eptp |= (root_hpa & PAGE_MASK);
 
 	return eptp;
-- 
1.7.1

