Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241Ab2CUVua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:50:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50903 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab2CUVu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:50:28 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH] x86: Fix typo in syscall table
Date: Wed, 21 Mar 2012 22:50:08 +0100
Message-Id: <1332366608-2695-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.9.4
X-Provags-ID: V02:K0:HT6i2A7wsaej4Jle/SSwpZFHx8Rl723fFw/k6H0EH1W
 oTTonjiMnZ54OSC79sJc58r+xWfiP1NTd8/sUFHY7mWiRdOQvu
 xPhJVcfZU4cSMeL5bnWFbdm9z0R57KTFrWfyV76RNMrAY4UX0d
 LUMSGjGWk+CTmfuO0DG729VvAjg0i2Kxqm4z7sPZ+3KHmcO0hs
 0nw7H71LRnGG2YLX0t5p+8FMlppeypO3dUQnsVfdXfbCltxYRL
 fTnHsPknw1WuE/WE3qmFO9CbvXnSpXCCgVfzl/a42KV7C7jGV+
 SJbv0y9Eme/tnsZ/LH4BR7JkdQuHG8Cx+fSJDd1ZtIHksONgYK
 5xb/9IbMaB0geLVNy7P6lze7PhorUby2BoQUzLnRMtZzbI53+v
 dyGWuTETb3OXNvhI3gz1Dcf9Ky/AeWwUrMZay/pNFNLXumvhGO
 AsFZv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Syscall 282 was mistakenly named mq_getsetaddr instead of mq_getsetattr.
When building uClibc against the Linux kernel this would result in a
shared library that doesn't provide the mq_getattr() and mq_setattr()
functions.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: stable@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/syscalls/syscall_32.tbl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index dfa4993..7a35a6e 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -288,7 +288,7 @@
 279	i386	mq_timedsend		sys_mq_timedsend		compat_sys_mq_timedsend
 280	i386	mq_timedreceive		sys_mq_timedreceive		compat_sys_mq_timedreceive
 281	i386	mq_notify		sys_mq_notify			compat_sys_mq_notify
-282	i386	mq_getsetaddr		sys_mq_getsetattr		compat_sys_mq_getsetattr
+282	i386	mq_getsetattr		sys_mq_getsetattr		compat_sys_mq_getsetattr
 283	i386	kexec_load		sys_kexec_load			compat_sys_kexec_load
 284	i386	waitid			sys_waitid			compat_sys_waitid
 # 285 sys_setaltroot
-- 
1.7.9.4

