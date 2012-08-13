Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab2HMWPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:15:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48802 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab2HMWPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:15:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joe Perches <joe@perches.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 03/65] sunrpc: clnt: Add missing braces
Date: Mon, 13 Aug 2012 15:13:47 -0700
Message-Id: <20120813221415.269249269@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Perches <joe@perches.com>

commit cac5d07e3ca696dcacfb123553cf6c722111cfd3 upstream.

Add a missing set of braces that commit 4e0038b6b24
("SUNRPC: Move clnt->cl_server into struct rpc_xprt")
forgot.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1846,12 +1846,13 @@ call_timeout(struct rpc_task *task)
 		return;
 	}
 	if (RPC_IS_SOFT(task)) {
-		if (clnt->cl_chatty)
+		if (clnt->cl_chatty) {
 			rcu_read_lock();
 			printk(KERN_NOTICE "%s: server %s not responding, timed out\n",
 				clnt->cl_protname,
 				rcu_dereference(clnt->cl_xprt)->servername);
 			rcu_read_unlock();
+		}
 		if (task->tk_flags & RPC_TASK_TIMEOUT)
 			rpc_exit(task, -ETIMEDOUT);
 		else


