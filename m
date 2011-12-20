Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1LTBbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:31:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49826 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1LTBbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:31:19 -0500
Date: Mon, 19 Dec 2011 17:31:10 -0800
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-13529caa10734c46e3ab049cc1a441f332646b0c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1324338394-4670-9-git-send-email-andi@firstfloor.org>
References: <1324338394-4670-9-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/autoprobe] x86:
  Autoload microcode driver on Intel and AMD systems
Git-Commit-ID: 13529caa10734c46e3ab049cc1a441f332646b0c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Dec 2011 17:31:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13529caa10734c46e3ab049cc1a441f332646b0c
Gitweb:     http://git.kernel.org/tip/13529caa10734c46e3ab049cc1a441f332646b0c
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 19 Dec 2011 15:46:34 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 19 Dec 2011 15:50:08 -0800

x86: Autoload microcode driver on Intel and AMD systems

Don't try to describe the actual models for now.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1324338394-4670-9-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_core.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 9d46f5e..6911a41 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -86,6 +86,7 @@
 
 #include <asm/microcode.h>
 #include <asm/processor.h>
+#include <asm/cpu_device_id.h>
 
 MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
@@ -502,6 +503,20 @@ static struct notifier_block __refdata mc_cpu_notifier = {
 	.notifier_call	= mc_cpu_callback,
 };
 
+#ifdef MODULE
+/* Autoload on Intel and AMD systems */
+static const struct x86_cpu_id microcode_id[] = {
+#ifdef CONFIG_MICROCODE_INTEL
+       { X86_VENDOR_INTEL, X86_VENDOR_ANY, X86_MODEL_ANY, },
+#endif
+#ifdef CONFIG_MICROCODE_AMD
+       { X86_VENDOR_AMD, X86_VENDOR_ANY, X86_MODEL_ANY, },
+#endif
+       {}
+};
+MODULE_DEVICE_TABLE(x86cpu, microcode_id);
+#endif
+
 static int __init microcode_init(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
