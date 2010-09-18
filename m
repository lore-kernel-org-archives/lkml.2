Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0IRTl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:41:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39385 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab0IRTl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:41:56 -0400
Date: Sat, 18 Sep 2010 20:41:55 +0100
To: linux-arch@vger.kernel.org
Subject: [PATCH 3/5] frv: avoid infinite loop of SIGSEGV delivery
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Ox3IJ-0006RR-BZ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


force_sigsegv() exists for a good reason...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/frv/kernel/signal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index d06226b..fa40d54 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -329,7 +329,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
 	return 0;
 
 give_sigsegv:
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 	return -EFAULT;
 
 } /* end setup_frame() */
@@ -431,7 +431,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	return 0;
 
 give_sigsegv:
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 	return -EFAULT;
 
 } /* end setup_rt_frame() */
-- 
1.5.6.5


