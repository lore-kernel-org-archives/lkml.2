Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1HKN6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:58:07 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60103 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab1HKN56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:57:58 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 18/41] OpenRISC: Don't reimplement force_sigsegv()
Date: Thu, 11 Aug 2011 14:56:52 +0100
Message-Id: <1313071035-12047-19-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Instead of open coding the sequence from force_sigsegv() just call
it. This also fixes a race because sa_handler was being modified
without holding ->sighand->siglock.

Cc: Oleg Nesterov <oleg@redhat.com>
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

