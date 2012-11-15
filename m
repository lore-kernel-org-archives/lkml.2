Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993317Ab2KOEMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:12:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:49833 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993281Ab2KOEMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 24/57] NFSv4: nfs4_locku_done must release the sequence id
Date: Wed, 14 Nov 2012 20:11:32 -0800
Message-Id: <20121115040934.713728526@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2b1bc308f492589f7d49012ed24561534ea2be8c upstream.

If the state recovery machinery is triggered by the call to
nfs4_async_handle_error() then we can deadlock.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4306,6 +4306,7 @@ static void nfs4_locku_done(struct rpc_t
 			if (nfs4_async_handle_error(task, calldata->server, NULL) == -EAGAIN)
 				rpc_restart_call_prepare(task);
 	}
+	nfs_release_seqid(calldata->arg.seqid);
 }
 
 static void nfs4_locku_prepare(struct rpc_task *task, void *data)


