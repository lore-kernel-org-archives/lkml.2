Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab0GAPzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:55:06 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47063 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106Ab0GAPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:10 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/21] x86, mce: Notify about corrected events too
Date: Thu,  1 Jul 2010 17:56:01 +0200
Message-Id: <1277999763-20357-20-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Notify all parties registered on the mce decoder chain about logged
correctable MCEs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 42d2808..4dc20f0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -601,6 +601,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 */
 		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
 			mce_log(&m);
+			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
 			add_taint(TAINT_MACHINE_CHECK);
 		}
 
-- 
1.7.1

