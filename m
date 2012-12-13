Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2LMODB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:03:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44112 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab2LMOC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:02:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 036/241] NFSv4: nfs4_locku_done must release the sequence id
Date: Thu, 13 Dec 2012 11:56:41 -0200
Message-Id: <1355407206-17100-37-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2b1bc308f492589f7d49012ed24561534ea2be8c upstream.

If the state recovery machinery is triggered by the call to
nfs4_async_handle_error() then we can deadlock.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/nfs4proc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index e690a13..9b1ac5c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4342,6 +4342,7 @@ static void nfs4_locku_done(struct rpc_task *task, void *data)
 			if (nfs4_async_handle_error(task, calldata->server, NULL) == -EAGAIN)
 				rpc_restart_call_prepare(task);
 	}
+	nfs_release_seqid(calldata->arg.seqid);
 }
 
 static void nfs4_locku_prepare(struct rpc_task *task, void *data)
-- 
1.7.9.5

