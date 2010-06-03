Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab0FCANm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:13:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab0FCANk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:13:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>
Subject: [RFC 3/5] BKL: do not take BKL in do_coredump
Date: Thu,  3 Jun 2010 02:13:17 +0200
Message-Id: <1275523999-27462-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275523999-27462-1-git-send-email-arnd@arndb.de>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/gpletCs/Yl6+a6ApmFuW4xbMQHz++h0CFYnE
 fI/SQ4lu8LdsRuJFS6Z1MDcNei2at3IGPyknE7XCtDv0zp9vJZ
 eSJ5XhBiOB0ebMD79Sp0A==
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
1.7.0.4

