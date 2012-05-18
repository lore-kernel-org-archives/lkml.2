Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966398Ab2ERR75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:59:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:51773 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965576Ab2ERR74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:59:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: kvm@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] kvm: make asm-generic/kvm_para.h have an ifdef __KERNEL__ block
Date: Fri, 18 May 2012 13:59:39 -0400
Message-Id: <1337363979-5121-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two functions in this asm-generic file.  Looking at
other arch which do not use the generic version, these two fcns
are within an #ifdef __KERNEL__ block, so make the generic one
consistent with those.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/include/asm-generic/kvm_para.h b/include/asm-generic/kvm_para.h
index 9a7bbad..5cba37f 100644
--- a/include/asm-generic/kvm_para.h
+++ b/include/asm-generic/kvm_para.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_GENERIC_KVM_PARA_H
 #define _ASM_GENERIC_KVM_PARA_H
 
+#ifdef __KERNEL__
 
 /*
  * This function is used by architectures that support kvm to avoid issuing
@@ -16,4 +17,6 @@ static inline unsigned int kvm_arch_para_features(void)
 	return 0;
 }
 
+#endif	/* _KERNEL__ */
+
 #endif
-- 
1.7.9.1

