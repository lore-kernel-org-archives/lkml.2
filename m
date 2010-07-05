Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0GEIBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:01:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37734 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0GEIBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=WPK7jIr0Riqq2diGG0qUMn3IgesbPv93QPPQZXQColzgoZz5H5Ml3+EZsS3lSjmWSa
         kCLA95HTJCekZZ0AzamhMn9LEPGkwgPyH7fZxXoGtJnRHrLK2Todqs5+gP9/WwsvBYOR
         Bkqgm99VHu+SXrLHIpmi0MuSLsef2CTP8DJGM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Don Zickus <dzickus@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/watchdog: Initialize 'result'
Date: Mon,  5 Jul 2010 12:00:54 +0400
Message-Id: <1278316854-28442-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable on the stack is not initialized to zero, do it explicitly.

This patch silences a compiler warning:
kernel/watchdog.c:463: warning: ‘result’ may be used uninitialized in this function

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 kernel/watchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 91b0b26..613bc1f 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -460,7 +460,7 @@ static void watchdog_disable(int cpu)
 static void watchdog_enable_all_cpus(void)
 {
 	int cpu;
-	int result;
+	int result = 0;
 
 	for_each_online_cpu(cpu)
 		result += watchdog_enable(cpu);
-- 
1.7.0.4

