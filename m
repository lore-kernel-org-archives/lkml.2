Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1H2X1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:27:48 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43949 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab1H2X1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:27:43 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        mtosatti@redhat.com, riel@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm-ppc@vger.kernel.org, aliguori@us.ibm.com, raharper@us.ibm.com,
        kvm-ia64@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 3/4] Add generic stubs for kvm stop check functions
Date: Mon, 29 Aug 2011 17:27:14 -0600
Message-Id: <1314660435-23293-4-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is called from the watchdog code when a soft lockup is detected.
If this is an arch that does not support pvclock, this function is used.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 include/asm-generic/pvclock.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/pvclock.h

diff --git a/include/asm-generic/pvclock.h b/include/asm-generic/pvclock.h
new file mode 100644
index 0000000..ff046b6
--- /dev/null
+++ b/include/asm-generic/pvclock.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_GENERIC_PVCLOCK_H
+#define _ASM_GENERIC_PVCLOCK_H
+
+
+/*
+ * These functions are used by architectures that support kvm to avoid issuing
+ * false soft lockup messages.
+ */
+static inline bool kvm_check_and_clear_host_stopped(int cpu)
+{
+	return false;
+}
+
+#endif
-- 
1.7.4.1

