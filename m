Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab0JROkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:40:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab0JROhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:39 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/22] GFS2: Update handling of DLM return codes to match reality
Date: Mon, 18 Oct 2010 15:15:32 +0100
Message-Id: <1287411346-17855-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFS2's idea of which return codes it needs to handle was based
upon those listed in dlm.h. Those didn't cover all the possible
codes and listed some which never happen. This updates GFS2 to
handle all the codes which can actually be returned from the
DLM under various circumstances.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 0e0470e..1c09425 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -42,9 +42,9 @@ static void gdlm_ast(void *arg)
 		ret |= LM_OUT_CANCELED;
 		goto out;
 	case -EAGAIN: /* Try lock fails */
+	case -EDEADLK: /* Deadlock detected */
 		goto out;
-	case -EINVAL: /* Invalid */
-	case -ENOMEM: /* Out of memory */
+	case -ETIMEDOUT: /* Canceled due to timeout */
 		ret |= LM_OUT_ERROR;
 		goto out;
 	case 0: /* Success */
-- 
1.7.1.1

