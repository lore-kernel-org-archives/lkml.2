Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2HUDCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 23:02:40 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:58048 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab2HUDCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 23:02:36 -0400
Message-ID: <5032FA3E.9000204@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 11:02:22 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 10/12] KVM: introduce KVM_HVA_ERR_RO_BAD
References: <5032F8FD.2020306@linux.vnet.ibm.com>
In-Reply-To: <5032F8FD.2020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082103-2000-0000-0000-000008C7C6A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the later patch, it indicates failure when we try to get a writable
hva from the readonly memslot

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b9bba60..a913ac7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -82,11 +82,12 @@ static inline bool is_invalid_pfn(pfn_t pfn)
 	return !is_noslot_pfn(pfn) && is_error_pfn(pfn);
 }

-#define KVM_HVA_ERR_BAD	(PAGE_OFFSET)
+#define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
+#define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)

 static inline bool kvm_is_error_hva(unsigned long addr)
 {
-	return addr == PAGE_OFFSET;
+	return addr >= PAGE_OFFSET;
 }

 #define KVM_ERR_PTR_BAD_PAGE	(ERR_PTR(-ENOENT))
-- 
1.7.7.6

