Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2KNF7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:59:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55184 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756352Ab2KNFuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:50 -0500
Message-Id: <20121114053940.095395596@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:18 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 45/82] NFSv4: nfs4_locku_done must release the sequence id
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2b1bc308f492589f7d49012ed24561534ea2be8c upstream.

If the state recovery machinery is triggered by the call to
nfs4_async_handle_error() then we can deadlock.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index e0423bb..1465364 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4531,6 +4531,7 @@ static void nfs4_locku_done(struct rpc_task *task, void *data)
 			if (nfs4_async_handle_error(task, calldata->server, NULL) == -EAGAIN)
 				rpc_restart_call_prepare(task);
 	}
+	nfs_release_seqid(calldata->arg.seqid);
 }
 
 static void nfs4_locku_prepare(struct rpc_task *task, void *data)


