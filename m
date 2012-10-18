Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2JRO5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:57:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44394 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab2JRO5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:57:20 -0400
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 22:57:19 +0800
Message-ID: <CAPgLHd8atrHJK0oiOsrJo1+GECi7YaJ+ZDd1oFE-VBmO1aHicQ@mail.gmail.com>
Subject: [PATCH] dlm: remove unused variable in *dlm_lowcomms_get_buffer()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: ccaulfie@redhat.com, teigland@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable users is initialized but never used
otherwise, so remove the unused variable.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/dlm/lowcomms.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 331ea4f..dd87a31 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1385,7 +1385,6 @@ void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc)
 	struct connection *con;
 	struct writequeue_entry *e;
 	int offset = 0;
-	int users = 0;
 
 	con = nodeid2con(nodeid, allocation);
 	if (!con)
@@ -1399,7 +1398,7 @@ void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc)
 	} else {
 		offset = e->end;
 		e->end += len;
-		users = e->users++;
+		e->users++;
 	}
 	spin_unlock(&con->writequeue_lock);
 
@@ -1414,7 +1413,7 @@ void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc)
 		spin_lock(&con->writequeue_lock);
 		offset = e->end;
 		e->end += len;
-		users = e->users++;
+		e->users++;
 		list_add_tail(&e->list, &con->writequeue);
 		spin_unlock(&con->writequeue_lock);
 		goto got_one;

