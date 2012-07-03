Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab2GCGbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:31:13 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49388 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab2GCGbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:31:11 -0400
Message-ID: <4FF291A5.5090803@linux.vnet.ibm.com>
Date: Tue, 03 Jul 2012 14:31:01 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/3] KVM: fix fault page leak
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12070306-8878-0000-0000-0000031E132C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fault_page is forgot to be freed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 02cb440..157226d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2857,6 +2857,7 @@ void kvm_exit(void)
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
 	free_cpumask_var(cpus_hardware_enabled);
+	__free_page(fault_page);
 	__free_page(hwpoison_page);
 	__free_page(bad_page);
 }
-- 
1.7.7.6

