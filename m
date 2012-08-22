Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab2HVXh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:37:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47450 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab2HVXhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:37:55 -0400
Date: Wed, 22 Aug 2012 16:37:41 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-4dbf32c30f7e5379588a692c7bf80b05d9ef8026@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-3-git-send-email-bp@amd64.org>
References: <1344361461-10076-3-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode:
  Save an indentation level in reload_for_cpu
Git-Commit-ID: 4dbf32c30f7e5379588a692c7bf80b05d9ef8026
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:37:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4dbf32c30f7e5379588a692c7bf80b05d9ef8026
Gitweb:     http://git.kernel.org/tip/4dbf32c30f7e5379588a692c7bf80b05d9ef8026
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 23 Jul 2012 19:05:53 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:14:08 -0700

x86, microcode: Save an indentation level in reload_for_cpu

Invert the uci->valid check so that the later block can be aligned on
the first indentation level of the function. No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-3-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_core.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 4873e62..63a9568 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -276,19 +276,18 @@ static struct platform_device	*microcode_pdev;
 static int reload_for_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	enum ucode_state ustate;
 	int err = 0;
 
-	if (uci->valid) {
-		enum ucode_state ustate;
-
-		ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
-		if (ustate == UCODE_OK)
-			apply_microcode_on_target(cpu);
-		else
-			if (ustate == UCODE_ERROR)
-				err = -EINVAL;
-	}
+	if (!uci->valid)
+		return err;
 
+	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
+	if (ustate == UCODE_OK)
+		apply_microcode_on_target(cpu);
+	else
+		if (ustate == UCODE_ERROR)
+			err = -EINVAL;
 	return err;
 }
 
