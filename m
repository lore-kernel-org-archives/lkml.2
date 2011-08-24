Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1HXPLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:11:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34808 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab1HXPK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:10:58 -0400
From: Julia Lawall <julia@diku.dk>
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/x86/kernel/microcode_core.c: add missing platform_device_unregister
Date: Wed, 24 Aug 2011 17:10:52 +0200
Message-Id: <1314198652-10333-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Call platform_device_unregister as in the previous error-handling code.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This is not tested, but I couldn't see how else platform_device_unregister
could be called.

 arch/x86/kernel/microcode_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index f924280..1872a3a 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -532,8 +532,10 @@ static int __init microcode_init(void)
 	}
 
 	error = microcode_dev_init();
-	if (error)
+	if (error) {
+		platform_device_unregister(microcode_pdev);
 		return error;
+	}
 
 	register_syscore_ops(&mc_syscore_ops);
 	register_hotcpu_notifier(&mc_cpu_notifier);

