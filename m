Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2GQOpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:45:16 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54652 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2GQOpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:45:14 -0400
Message-ID: <50057A73.40005@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 22:45:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 08/10] KVM: introduce readonly_bad_hva
References: <5005791B.8040807@linux.vnet.ibm.com>
In-Reply-To: <5005791B.8040807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071714-4790-0000-0000-000003BABE6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the later patch, it indicates failure when we try to get a writable
hva from the readonly slot

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b70f1a4..c056736 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -994,9 +994,19 @@ static inline unsigned long bad_hva(void)
 	return PAGE_OFFSET;
 }

+static inline unsigned long readonly_bad_hva(void)
+{
+	return PAGE_OFFSET + PAGE_SIZE;
+}
+
+static int kvm_is_readonly_bad_hva(unsigned long addr)
+{
+	return addr == readonly_bad_hva();
+}
+
 int kvm_is_error_hva(unsigned long addr)
 {
-	return addr == bad_hva();
+	return addr == bad_hva() || kvm_is_readonly_bad_hva(addr);
 }
 EXPORT_SYMBOL_GPL(kvm_is_error_hva);

-- 
1.7.7.6

