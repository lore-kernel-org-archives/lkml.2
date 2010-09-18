Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0IRPxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 11:53:37 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55044 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab0IRPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 11:53:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=btyK47Mjbv3y6oklz8gLCFzPfBhha07C3cJ90w5HBwvZsyFtFMlNqZEHsUuPDK7aAb
         eBkVjIhCLpHPKUphYEtkFqbFSEQmBRvCKTZ7pP1qhhxdcojkS/Fmrr2QRxa1HKQUlLbU
         18yefeyTBL0aPWsoWe/RhnF2pY7aH44jp2Jms=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] printk: Add lock context annotation
Date: Sun, 19 Sep 2010 00:53:00 +0900
Message-Id: <1284825182-32588-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284825182-32588-1-git-send-email-namhyung@gmail.com>
References: <1284825182-32588-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acquire_console_semaphore_for_printk() releases logbuf_lock but
was missing proper annotation. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/printk.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index a491251..a7aa858 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -647,6 +647,7 @@ static inline int can_use_console(unsigned int cpu)
  * released but interrupts still disabled.
  */
 static int acquire_console_semaphore_for_printk(unsigned int cpu)
+	__releases(&logbuf_lock)
 {
 	int retval = 0;
 
-- 
1.7.0.4

