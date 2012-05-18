Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030718Ab2ERCwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:52:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40527 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762557Ab2ERCwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:41 -0400
Message-Id: <20120518023259.384798393@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?=C3=89meric=20Maschino?= <emeric.maschino@gmail.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [ 37/53] ia64: Add accept4() syscall
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Émeric Maschino <emeric.maschino@gmail.com>

commit 65cc21b4523e94d5640542a818748cd3be8cd6b4 upstream.

While debugging udev > 170 failure on Debian Wheezy
(http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=648325), it appears
that the issue was in fact due to missing accept4() in ia64.

This patch simply adds accept4() to ia64.

Signed-off-by: Émeric Maschino <emeric.maschino@gmail.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/ia64/include/asm/unistd.h |    3 ++-
 arch/ia64/kernel/entry.S       |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index 7617248..7a3bd25 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -323,11 +323,12 @@
 #define __NR_sendmmsg			1331
 #define __NR_process_vm_readv		1332
 #define __NR_process_vm_writev		1333
+#define __NR_accept4			1334
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			310 /* length of syscall table */
+#define NR_syscalls			311 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index 5b31d46..1ccbe12 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1779,6 +1779,7 @@ sys_call_table:
 	data8 sys_sendmmsg
 	data8 sys_process_vm_readv
 	data8 sys_process_vm_writev
+	data8 sys_accept4
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
-- 
1.7.10



