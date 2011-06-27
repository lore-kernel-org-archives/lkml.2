Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab1F0WR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:17:29 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:49047 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab1F0WPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:15:41 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Mathias Krause <minipli@googlemail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/4] um, exec: remove redundant set_fs(USER_DS)
Date: Tue, 28 Jun 2011 00:15:30 +0200
Message-Id: <1309212931-19772-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309212931-19772-1-git-send-email-richard@nod.at>
References: <1309212931-19772-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/kernel/exec.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index 09bd7b5..939a4a6 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -38,7 +38,6 @@ void flush_thread(void)
 
 void start_thread(struct pt_regs *regs, unsigned long eip, unsigned long esp)
 {
-	set_fs(USER_DS);
 	PT_REGS_IP(regs) = eip;
 	PT_REGS_SP(regs) = esp;
 }
-- 
1.7.5.4

