Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514Ab2BNLnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:43:10 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57755 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760346Ab2BNLnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:43:08 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Jonas Bonn <jonas@southpole.se>, Arnd Bergmann <arnd@arndb.de>,
        linux@openrisc.net
Subject: [PATCH 21/40] OpenRISC: Don't reimplement force_sigsegv()
Date: Tue, 14 Feb 2012 11:40:54 +0000
Message-Id: <1329219673-28711-22-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
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
Cc: linux@lists.openrisc.net
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/openrisc/kernel/signal.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index 95207ab..53741ba 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -250,9 +250,7 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
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

