Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab0HVLMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 07:12:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58204 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab0HVLMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 07:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NoXKAaFCQx+lK0Nhin/M410pOrFrmecBQyg3PxhWSFNaIIK7kbnC0GZMPsroYfWnMQ
         mknKTayYegXzN6wWcB1nrPv2LFh1kqKPfgDZ+o+MOkFddPKPUGjIXE2IxqGPSUuKvM4K
         h6OEVMdiNlCN10+Lv1hf0XDGHznweigrSCHn4=
From: Changli Gao <xiaosuo@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] net: define __packed for the userspace code
Date: Sun, 22 Aug 2010 19:12:24 +0800
Message-Id: <1282475544-24708-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit

 commit bc10502dba37d3b210efd9f3867212298f13b78e
 Author: Eric Dumazet <eric.dumazet@gmail.com>
 Date:   Thu Jun 3 03:21:52 2010 -0700

    net: use __packed annotation

makes use of __packed in the userspace code. So we'd better define __packed
for the userspace code too.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 include/linux/compiler.h |    4 ++++
 include/linux/if_pppox.h |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c1a62c5..515b174 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -304,4 +304,8 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+#ifndef __packed
+# define __packed __attribute__((packed))
+#endif
+
 #endif /* __LINUX_COMPILER_H */
