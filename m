Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1CXCmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 22:42:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58512 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab1CXCmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 22:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EPNIpBaZm6jPS4FGkfNiqcfhn/C2EihEQBPThEcO2yflEUY5TOVVUdPVViIFwWPK/q
         bWbh/gN0nkdaHyWpKv8a4HCypyBPUfS4T4NGtIefwFZG4fEBvrS0ngIlpKmVizUJnl2K
         HFu2XOjCXfmZA4a7GvZ0Ua6+cKKyoRF2fof6M=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v2 2/2] x86, dumpstack: use %pB format specifier for stack trace
Date: Thu, 24 Mar 2011 11:42:30 +0900
Message-Id: <1300934550-21394-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300934550-21394-1-git-send-email-namhyung@gmail.com>
References: <1300934550-21394-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/dumpstack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 914065620f2c..fac6d82b5afa 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -27,7 +27,7 @@ static int die_counter;

 void printk_address(unsigned long address, int reliable)
 {
-	printk(" [<%p>] %s%pS\n", (void *) address,
+	printk(" [<%p>] %s%pB\n", (void *) address,
 			reliable ? "" : "? ", (void *) address);
 }

--
1.7.4

