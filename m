Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab1HSQsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:48:05 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57311 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756374Ab1HSQrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:47:52 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 20/43] OpenRISC: Don't reimplement force_sigsegv()
Date: Fri, 19 Aug 2011 17:46:36 +0100
Message-Id: <1313772419-21951-21-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Instead of open coding the sequence from force_sigsegv() just call
it. This also fixes a bug because we were modifying ka->sa.sa_handler
(which is a copy of sighand->action[]), whereas the intention of the
code was to modify sighand->action[] directly.

As the original code was working with a copy it had no effect on
signal delivery.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/openrisc/kernel/signal.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index 5f759c7..c023db9 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -257,9 +257,7 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	return;
 
 give_sigsegv:
-	if (sig == SIGSEGV)
-		ka->sa.sa_handler = SIG_DFL;
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 }
 
 static inline void
-- 
1.7.4.4

