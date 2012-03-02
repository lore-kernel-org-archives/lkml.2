Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030361Ab2CBPlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:41:13 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030330Ab2CBPlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:41:10 -0500
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] OpenRISC: syscallno is gone, use orig_gpr11
Date: Fri,  2 Mar 2012 16:41:01 +0100
Message-Id: <1330702862-5688-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a build error introduced by "openrisc: sanitize use of orig_gpr11"

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index cf35ea0..e970743 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -305,7 +305,7 @@ void do_signal(struct pt_regs *regs)
 	 * below mean that the syscall executed to completion and no
 	 * restart is necessary.
 	 */
-	if (regs->syscallno) {
+	if (regs->orig_gpr11) {
 		int restart = 0;
 
 		switch (regs->gpr[11]) {
-- 
1.7.7.3

