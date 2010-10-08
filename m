Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab0JHIYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:24:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:20068 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab0JHIYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:24:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,302,1283756400"; 
   d="scan'208";a="665368431"
Subject: [PATCH 1/2] kvm, MCE, Add MCG_SER_P into KVM_MCE_CAP_SUPPORTED
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Dean Nelson <dnelson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 16:24:14 +0800
Message-ID: <1286526254.7768.95.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have MCG_SER_P (and corresponding SRAO/SRAR MCE) support in
kernel and QEMU-KVM, the MCG_SER_P should be added into
KVM_MCE_CAP_SUPPORTED to make all these code really works.

Reported-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -71,7 +71,7 @@
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
 #define KVM_MAX_MCE_BANKS 32
-#define KVM_MCE_CAP_SUPPORTED MCG_CTL_P
+#define KVM_MCE_CAP_SUPPORTED (MCG_CTL_P | MCG_SER_P)
 
 /* EFER defaults:
  * - enable syscall per default because its emulated by KVM


