Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2G2IOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 04:14:34 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51088 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2G2IOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 04:14:32 -0400
Message-ID: <5014F0E1.4010909@linux.vnet.ibm.com>
Date: Sun, 29 Jul 2012 16:14:25 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/9] KVM: define kvm_bad_pfn statically
References: <5014F053.8020305@linux.vnet.ibm.com>
In-Reply-To: <5014F053.8020305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072908-5140-0000-0000-000001D4BCAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then, remove get_bad_pfn

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |    7 +------
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4de56cd..b02203f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -50,6 +50,7 @@

 #define kvm_fault_pfn		(-EFAULT)
 #define kvm_hwpoison_pfn	(-EHWPOISON)
+#define kvm_bad_pfn		(-ENOENT)

 /*
  * vcpu->requests bit members
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 390a03d..da16191 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -943,11 +943,6 @@ int is_error_pfn(pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(is_error_pfn);

-static pfn_t get_bad_pfn(void)
-{
-	return -ENOENT;
-}
-
 int is_noslot_pfn(pfn_t pfn)
 {
 	return pfn == -ENOENT;
@@ -1152,7 +1147,7 @@ static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic, bool *async,

 	addr = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(addr))
-		return get_bad_pfn();
+		return kvm_bad_pfn;

 	return hva_to_pfn(addr, atomic, async, write_fault, writable);
 }
-- 
1.7.7.6

