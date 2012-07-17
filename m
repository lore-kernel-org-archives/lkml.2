Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2GQNzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:55:11 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41619 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab2GQNzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:55:08 -0400
Message-ID: <50056EAC.2020409@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 21:54:52 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 7/9] KVM: mark do not extern bad_pfn
References: <50056DB8.7080702@linux.vnet.ibm.com>
In-Reply-To: <50056DB8.7080702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071704-3568-0000-0000-00000225BAFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bad_pfn is not used out of kvm_main.c, so mark it static, also move it near
hwpoison_pfn and fault_pfn

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    1 -
 virt/kvm/kvm_main.c      |    6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 258b35a..bafcc56 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -383,7 +383,6 @@ id_to_memslot(struct kvm_memslots *slots, int id)
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }

 extern struct page *bad_page;
-extern pfn_t bad_pfn;

 int is_error_page(struct page *page);
 int is_error_pfn(pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index feef72e..7082e33 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -100,6 +100,9 @@ EXPORT_SYMBOL_GPL(kvm_rebooting);

 static bool largepages_enabled = true;

+struct page *bad_page;
+static pfn_t bad_pfn;
+
 static struct page *hwpoison_page;
 static pfn_t hwpoison_pfn;

@@ -2692,9 +2695,6 @@ static struct syscore_ops kvm_syscore_ops = {
 	.resume = kvm_resume,
 };

-struct page *bad_page;
-pfn_t bad_pfn;
-
 static inline
 struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
 {
-- 
1.7.7.6

