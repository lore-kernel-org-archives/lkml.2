Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1HKOE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:04:27 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60071 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab1HKN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:57:45 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 12/41] microblaze: Don't reimplement force_sigsegv()
Date: Thu, 11 Aug 2011 14:56:46 +0100
Message-Id: <1313071035-12047-13-git-send-email-matt@console-pimps.org>
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
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/microblaze/kernel/signal.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index 5996711..90de06d 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -270,9 +270,7 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	return;
 
 give_sigsegv:
-	if (sig == SIGSEGV)
-		ka->sa.sa_handler = SIG_DFL;
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 }
 
 /* Handle restarting system calls */
-- 
1.7.4.4

