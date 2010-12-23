Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0LWXYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 18:24:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:37732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab0LWXYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 18:24:03 -0500
Date: Thu, 23 Dec 2010 23:21:46 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4D0AD464.2020408@kernel.org>
References: <4D0AD464.2020408@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, acpi: Add MAX_LOCAL_APIC for 32bit
Message-ID: <tip-56d91f132c9be66e98cce1b1e77a28027048bb26@git.kernel.org>
Git-Commit-ID: 56d91f132c9be66e98cce1b1e77a28027048bb26
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 23 Dec 2010 23:21:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56d91f132c9be66e98cce1b1e77a28027048bb26
Gitweb:     http://git.kernel.org/tip/56d91f132c9be66e98cce1b1e77a28027048bb26
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 16 Dec 2010 19:09:24 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 23 Dec 2010 13:15:53 -0800

x86, acpi: Add MAX_LOCAL_APIC for 32bit

We should use MAX_LOCAL_APIC for max apic ids and MAX_APICS as number
of local apics.

Also apic_version[] array should use MAX_LOCAL_APICs.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D0AD464.2020408@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/apicdef.h |    1 +
 arch/x86/include/asm/mpspec.h  |    2 +-
 arch/x86/kernel/apic/apic.c    |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index a859ca4..47a30ff 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -145,6 +145,7 @@
 
 #ifdef CONFIG_X86_32
 # define MAX_IO_APICS 64
+# define MAX_LOCAL_APIC 256
 #else
 # define MAX_IO_APICS 128
 # define MAX_LOCAL_APIC 32768
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index c82868e..7c1aebf 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -6,7 +6,7 @@
 #include <asm/mpspec_def.h>
 #include <asm/x86_init.h>
 
-extern int apic_version[MAX_APICS];
+extern int apic_version[];
 extern int pic_mode;
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4638396..0d5d07f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1707,7 +1707,7 @@ void __init init_apic_mappings(void)
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
  */
-int apic_version[MAX_APICS];
+int apic_version[MAX_LOCAL_APIC];
 
 int __init APIC_init_uniprocessor(void)
 {
