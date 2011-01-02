Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1ABHWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:34638 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1ABHWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:17 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Robert Richter <robert.richter@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 060/260] oprofile, x86: fix init_sysfs() function stub
Date: Sun,  2 Jan 2011 02:15:56 -0500
Message-Id: <1293952756-15010-61-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jan 2011 07:21:11.0132 (UTC) FILETIME=[A1A4B1C0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

commit 269f45c25028c75fe10e6d9be86e7202ab461fbc upstream.

The use of the return value of init_sysfs() with commit

 10f0412 oprofile, x86: fix init_sysfs error handling

discovered the following build error for !CONFIG_PM:

 .../linux/arch/x86/oprofile/nmi_int.c: In function ‘op_nmi_init’:
 .../linux/arch/x86/oprofile/nmi_int.c:784: error: expected expression before ‘do’
 make[2]: *** [arch/x86/oprofile/nmi_int.o] Error 1
 make[1]: *** [arch/x86/oprofile] Error 2

This patch fixes this.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/oprofile/nmi_int.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 41b7228..3130a4b 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -535,8 +535,10 @@ static void exit_sysfs(void)
 }
 
 #else
-#define init_sysfs() do { } while (0)
-#define exit_sysfs() do { } while (0)
+
+static inline int  init_sysfs(void) { return 0; }
+static inline void exit_sysfs(void) { }
+
 #endif /* CONFIG_PM */
 
 static int __init p4_init(char **cpu_type)
-- 
1.7.3.3

