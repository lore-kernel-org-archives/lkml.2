Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2DQPrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:47:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab2DQPrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:47:21 -0400
From: Doug Ledford <dledford@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [Patch 5/8] mqueue: revert bump up DFLT_*MAX
Date: Tue, 17 Apr 2012 11:46:22 -0400
Message-Id: <de8d761688dd34f312822db71ceed6753493933a.1334676645.git.dledford@redhat.com>
In-Reply-To: <cover.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
In-Reply-To: <cover.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Mqueue limitation is slightly naieve parameter likes other ipcs
because unprivileged user can consume kernel memory by using ipcs.

Thus, too aggressive raise bring us security issue. Example,
current setting allow evil unprivileged user use 256GB (= 256
* 1024 * 1024*1024) and it's enough large to system will belome
unresponsive. Don't do that.

Instead, every admin should adjust the knobs for their own systems.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Acked-by: Joe Korty <joe.korty@ccur.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/ipc_namespace.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 6e1dd08..2488535 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -118,12 +118,12 @@ extern int mq_init_ns(struct ipc_namespace *ns);
 #define DFLT_QUEUESMAX		      256
 #define HARD_QUEUESMAX		     1024
 #define MIN_MSGMAX			1
-#define DFLT_MSG		       64U
-#define DFLT_MSGMAX		     1024
+#define DFLT_MSG		       10U
+#define DFLT_MSGMAX		       10
 #define HARD_MSGMAX		    65536
 #define MIN_MSGSIZEMAX		      128
 #define DFLT_MSGSIZE		     8192U
-#define DFLT_MSGSIZEMAX	       (1024*1024)
+#define DFLT_MSGSIZEMAX		     8192
 #define HARD_MSGSIZEMAX	    (16*1024*1024)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
-- 
1.7.7.6

