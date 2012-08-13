Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2HMG17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 02:27:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:42442 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2HMG16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 02:27:58 -0400
From: Ying Xue <ying.xue@windriver.com>
To: <teigland@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] dlm: cleanup send_to_sock routine
Date: Mon, 13 Aug 2012 14:29:55 +0800
Message-ID: <1344839395-22189-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary code form send_to_sock routine.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 fs/dlm/lowcomms.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 5c1b0e3..f8eefe2 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1358,8 +1358,7 @@ static void send_to_sock(struct connection *con)
 				}
 				cond_resched();
 				goto out;
-			}
-			if (ret <= 0)
+			} else if (ret < 0)
 				goto send_error;
 		}
 
@@ -1376,7 +1375,6 @@ static void send_to_sock(struct connection *con)
 		if (e->len == 0 && e->users == 0) {
 			list_del(&e->list);
 			free_entry(e);
-			continue;
 		}
 	}
 	spin_unlock(&con->writequeue_lock);
@@ -1394,7 +1392,6 @@ out_connect:
 	mutex_unlock(&con->sock_mutex);
 	if (!test_bit(CF_INIT_PENDING, &con->flags))
 		lowcomms_connect_sock(con);
-	return;
 }
 
 static void clean_one_writequeue(struct connection *con)
-- 
1.6.2.3

