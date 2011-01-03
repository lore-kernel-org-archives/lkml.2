Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1ACNvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:51:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58971 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab1ACNuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=h0f9b2FMGpAa/nuOF43SxHHHunah7ekHEy8o+36M4s5GNv1uxAvmV3C9zGFjRolJpw
         8H5sQiBMLVtw7gEk0ygb/XoTqJG+6K2McTU5sl2wsIczlqQKLjjjPWk3ugSpgS027Px1
         f163RPiJo1/OMVBHyxbcWWLof3OPYu5Li5Yyc=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH 32/32] rxrpc: rxrpc_workqueue isn't used during memory reclaim
Date: Mon,  3 Jan 2011 14:49:55 +0100
Message-Id: <1294062595-30097-33-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rxrpc_workqueue isn't depended upon while reclaiming memory.  Convert
to alloc_workqueue() without WQ_MEM_RECLAIM.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 net/rxrpc/af_rxrpc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 0b9bb20..74c064c 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -808,7 +808,7 @@ static int __init af_rxrpc_init(void)
 		goto error_call_jar;
 	}
 
-	rxrpc_workqueue = create_workqueue("krxrpcd");
+	rxrpc_workqueue = alloc_workqueue("krxrpcd", 0, 1);
 	if (!rxrpc_workqueue) {
 		printk(KERN_NOTICE "RxRPC: Failed to allocate work queue\n");
 		goto error_work_queue;
-- 
1.7.1

