Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab2EUVUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:20:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759168Ab2EUVSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:18:45 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] dlm: avoid unnecessary search in search_rsb
Date: Mon, 21 May 2012 16:18:36 -0500
Message-Id: <1337635120-19969-5-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the rsb is found in the "keep" tree, but is
not the right type (i.e. not MASTER), we can
return immediately with the result.  There's
no point in going on to search the "toss" list
as if we hadn't found it.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 3d35c59..49926f1 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -479,6 +479,9 @@ static int _search_rsb(struct dlm_ls *ls, char *name, int len, int b,
 		kref_get(&r->res_ref);
 		goto out;
 	}
+	if (error == -ENOTBLK)
+		goto out;
+
 	error = dlm_search_rsb_tree(&ls->ls_rsbtbl[b].toss, name, len, flags, &r);
 	if (error)
 		goto out;
-- 
1.7.10.1.362.g242cab3

