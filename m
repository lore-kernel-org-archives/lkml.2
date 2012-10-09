Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2JIPYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:24:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64805 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2JIPX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:23:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 9/9] ARM: warnings in arch/arm/include/asm/uaccess.h
Date: Tue,  9 Oct 2012 17:23:03 +0200
Message-Id: <1349796183-30648-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796183-30648-1-git-send-email-arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:14sXwOa1Qj/ckr9sokrMTqKYxEpNgN9Abb4SiyTh1nD
 npaV3bg9yhlHZWJLUhjM+dMb06MVgRkigWw0OkoYQSLlK933uQ
 +6U6DXWde3QarWnjsuZ1+k5P7i25LBQCJe0sfKRDT2yKTWsPF1
 Mby/MwZxXERdK+tm9QZLuEX3cLBPQ9fxj75mad9YBC2hFX8M0U
 fE/u0VXF4I6C71vrxkH9lfvhz/ug+HeshONJtKhg7QsUh1d/yT
 6/MOuJFmMPmXy4hey9Tr2U33sTSSSrOqo52sESL3lOUirgKofv
 +sjkDTtYuG4GLKmLvab9ztCqo7iC9SXqgH574DkjO92mo95NQM
 JjlJLnnyv4yGmTTnSDM8kVuVnuXzPSWAvouHB6aK1NL63QauUK
 cyKJCKUiaeFQXdNyf5W98dyY5SdmYtWjjM=
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
Acked-by: Greg Ungerer <gerg@uclinux.org>
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

