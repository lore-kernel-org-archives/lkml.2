Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab2EUDuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 23:50:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:5457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab2EUDuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 23:50:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="142675165"
From: Xudong Hao <xudong.hao@intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com, xiantao.zhang@intel.com,
        Xudong Hao <xudong.hao@intel.com>, Haitao Shan <haitao.shan@intel.com>
Subject: [PATCH v2 3/4] Enable EPT A/D bits if supported by turning on relevant bit in EPTP
Date: Mon, 21 May 2012 11:54:02 +0800
Message-Id: <1337572443-22482-3-git-send-email-xudong.hao@intel.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1337572443-22482-1-git-send-email-xudong.hao@intel.com>
References: <1337572443-22482-1-git-send-email-xudong.hao@intel.com>
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
index f3858bf..e8003b6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3018,6 +3018,8 @@ static u64 construct_eptp(unsigned long root_hpa)
 	/* TODO write the value reading from MSR */
 	eptp = VMX_EPT_DEFAULT_MT |
 		VMX_EPT_DEFAULT_GAW << VMX_EPT_GAW_EPTP_SHIFT;
+	if (enable_ept_ad_bits)
+		eptp |= VMX_EPT_AD_ENABLE_BIT;
 	eptp |= (root_hpa & PAGE_MASK);
 
 	return eptp;
-- 
1.5.6

