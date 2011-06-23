Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab1FWRgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:36:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:34553 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372Ab1FWRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 112/247] ARM: Ensure predictable endian state on signal handler entry
Date: Thu, 23 Jun 2011 13:33:00 -0400
Message-Id: <1308850515-15242-53-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 53399053eb505cf541b2405bd9d9bca5ecfb96fb upstream.

Ensure a predictable endian state when entering signal handlers.  This
avoids programs which use SETEND to momentarily switch their endian
state from having their signal handlers entered with an unpredictable
endian state.

Acked-by: Dave Martin <dave.martin@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/kernel/signal.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 907d5a6..abaf844 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -474,7 +474,9 @@ setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 	unsigned long handler = (unsigned long)ka->sa.sa_handler;
 	unsigned long retcode;
 	int thumb = 0;
-	unsigned long cpsr = regs->ARM_cpsr & ~PSR_f;
+	unsigned long cpsr = regs->ARM_cpsr & ~(PSR_f | PSR_E_BIT);
+
+	cpsr |= PSR_ENDSTATE;
 
 	/*
 	 * Maybe we need to deliver a 32-bit signal to a 26-bit task.
-- 
1.7.4.4

