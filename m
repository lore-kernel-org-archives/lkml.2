Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2HGRo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:44:28 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35562 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab2HGRo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:26 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v0 02/12] x86, microcode: Save an indentation level in reload_for_cpu
Date: Tue,  7 Aug 2012 19:44:11 +0200
Message-Id: <1344361461-10076-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Invert the uci->valid check so that the later block can be aligned on
the first indentation level of the function. No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_core.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 4873e62db6a1..63a956865022 100644
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
 
-- 
1.7.11.rc1

