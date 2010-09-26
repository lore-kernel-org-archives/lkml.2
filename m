Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab0IZS2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:28:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50366 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab0IZS2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:28:33 -0400
Date: Sun, 26 Sep 2010 19:28:32 +0100
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] mn10300: avoid SIGSEGV delivery loop
Cc: dhowells@redhat.com, torvalds@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Ozvxg-0002oJ-75@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


force_sigsegv() is there for purpose...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mn10300/kernel/signal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 717db14..57178a8 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -345,7 +345,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	return 0;
 
 give_sigsegv:
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 	return -EFAULT;
 }
 
@@ -428,7 +428,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	return 0;
 
 give_sigsegv:
-	force_sig(SIGSEGV, current);
+	force_sigsegv(sig, current);
 	return -EFAULT;
 }
 
-- 
1.5.6.5

