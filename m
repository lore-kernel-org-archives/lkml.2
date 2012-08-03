Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2HCHjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:39:44 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:54821 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2HCHjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:39:43 -0400
Message-ID: <501B8027.4060100@linux.vnet.ibm.com>
Date: Fri, 03 Aug 2012 15:39:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 04/10] KVM: introduce KVM_PFN_ERR_BAD
References: <501B7F94.7090308@linux.vnet.ibm.com>
In-Reply-To: <501B7F94.7090308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080307-5816-0000-0000-000003D7D551
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
index cbd5af8..ba8b222 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -50,6 +50,7 @@

 #define KVM_PFN_ERR_FAULT	(-EFAULT)
 #define KVM_PFN_ERR_HWPOISON	(-EHWPOISON)
+#define KVM_PFN_ERR_BAD		(-ENOENT)

 /*
  * vcpu->requests bit members
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f17ce44..75d3c76 100644
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
+		return KVM_PFN_ERR_BAD;

 	return hva_to_pfn(addr, atomic, async, write_fault, writable);
 }
-- 
1.7.7.6

