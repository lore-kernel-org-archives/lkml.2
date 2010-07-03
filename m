Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0GCWDK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:03:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64561 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab0GCWCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:02:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/8] do_coredump: do not take BKL
Date: Sun,  4 Jul 2010 00:02:25 +0200
Message-Id: <1278194552-24943-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278194552-24943-1-git-send-email-arnd@arndb.de>
References: <1278194552-24943-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:d8pGYMlFB98FmMBR30cRNijc0iRM9+V69fYAhiRwYHF
 fwbASU1r+6nu2b8tMtiETIGGUymH5k+1VwyWe7SzLpHKdcEN5V
 JxZ3qJAlt301QgVuu0yxMwZwLthD7PDytSHpReDd/o648SKzCG
 srPvMa5R/SrrNIcvu0JIO48sQLKmMqrcKKorftxArujeOC3WJ6
 hOZOIrSveZQknYQ2jHq8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

core_pattern is not actually protected and hasn't been
ever since we introduced procfs support for sysctl -- a
_long_ time. Don't take it here either.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/exec.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e19de6a..3d7aeeb 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1891,13 +1891,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
-	/*
-	 * lock_kernel() because format_corename() is controlled by sysctl, which
-	 * uses lock_kernel()
-	 */
- 	lock_kernel();
 	ispipe = format_corename(corename, signr);
-	unlock_kernel();
 
  	if (ispipe) {
 		int dump_count;
-- 
1.7.1

