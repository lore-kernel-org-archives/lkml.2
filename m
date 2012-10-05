Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab2JEO5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:57:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61677 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab2JEO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Greg Ungerer <gerg@uclinux.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 01/16] ARM: warnings in arch/arm/include/asm/uaccess.h
Date: Fri,  5 Oct 2012 16:55:15 +0200
Message-Id: <1349448930-23976-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xgkwAi3VsWjkrY6vAMpyEM/iPJLqKEnxkhRRMvqoE4s
 NPBTd36ONPjlG5lLcL/SACiC35fjBoBZLkmKwqYo3pfxUXH9XU
 AUtFMJDEprR45BPNAzyaK2BpgEVjknMF+C2fq6+xNytCh6xE6A
 TK44TZPOarF1rLRSsBhvbdx3Z1xZHnOPSKLSPeljI2V+WcVWMV
 Wncm7Z9LHtdn4rqTLuCX9yvs2h8DzvBTVyCWxArVyouJWx8Q+o
 vqAXoQl84idUsMBltDnrGDZDB9sTF2kr1L624WGJ0vUPgC4qJz
 P7ZAvwzQ8EdMEknIsRqh48SJbnRtPCJdGd19tcW9ReYrmlsJVc
 q9UA7KCxa4iduqIm/uixDYkDKV8pdVUpo5f3Ii9gcvKgVWkmJ4
 25Z9v1F2c0dZxhiFWIxHJvYCzdE+VOxdTg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On NOMMU ARM, the __addr_ok() and __range_ok() macros do not evaluate
their arguments, which may lead to harmless build warnings in some
code where the variables are not used otherwise. Adding a cast to void
gets rid of the warning and does not make any semantic changes.

Without this patch, building at91x40_defconfig results in:

fs/read_write.c: In function 'rw_copy_check_uvector':
fs/read_write.c:684:9: warning: unused variable 'buf' [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/include/asm/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 77bd79f..7e1f760 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -200,8 +200,8 @@ extern int __put_user_8(void *, unsigned long long);
 #define USER_DS			KERNEL_DS
 
 #define segment_eq(a,b)		(1)
-#define __addr_ok(addr)		(1)
-#define __range_ok(addr,size)	(0)
+#define __addr_ok(addr)		((void)(addr),1)
+#define __range_ok(addr,size)	((void)(addr),0)
 #define get_fs()		(KERNEL_DS)
 
 static inline void set_fs(mm_segment_t fs)
-- 
1.7.10

