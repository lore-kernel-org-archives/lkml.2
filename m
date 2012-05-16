Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967225Ab2EPBHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:07:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:5988 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932Ab2EPBG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:06:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100560908"
Date: Wed, 16 May 2012 09:10:29 +0800
From: Xudong Hao <xudong.hao@linux.intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, haitao.shan@intel.com,
        xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: [PATCH 3/4] Enable EPT A/D bits if supported by turning on
	relevant bit in EPTP
Message-ID: <20120516011029.GD14256@hp-xd.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
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
+   if (enable_ept_ad_bits)
+       eptp |= VMX_EPT_AD_ENABLE_BIT;
    eptp |= (root_hpa & PAGE_MASK);

    return eptp;
--
1.7.1

