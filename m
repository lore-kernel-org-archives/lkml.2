Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1LIWgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:36:35 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:56621 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1LIWgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:36:33 -0500
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Doug Ledford <dledford@redhat.com> (commit_signer:5/9=56%),
        "Eric W. Biederman" <ebiederm@xmission.com> (commit_signer:2/9=22%),
        Joe Korty <joe.korty@ccur.com> (commit_signer:2/9=22%),
        David Howells <dhowells@redhat.com> (commit_signer:2/9=22%)
Subject: [resend][PATCH 1/3] mqueue: revert bump up DFLT_*MAX
Date: Fri,  9 Dec 2011 17:35:55 -0500
Message-Id: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
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
 include/linux/ipc_namespace.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index e2bac00..2488535 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -118,13 +118,13 @@ extern int mq_init_ns(struct ipc_namespace *ns);
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
-#define DFLT_MSGSIZEMAX		(1024*1024)
-#define HARD_MSGSIZEMAX	     (16*1024*1024)
+#define DFLT_MSGSIZEMAX		     8192
+#define HARD_MSGSIZEMAX	    (16*1024*1024)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #endif
-- 
1.7.1

