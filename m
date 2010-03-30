Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab0C3XkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:40:05 -0400
Received: from kroah.org ([198.145.64.141]:46294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932645Ab0C3XUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:39 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:15 2010
Message-Id: <20100330224814.417404844@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [083/156] sunrpc: handle allocation errors from __rpc_lookup_create()
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit f1f0abe192a72e75d7c59972e30784d043fd8d73 upstream.

__rpc_lookup_create() can return ERR_PTR(-ENOMEM).

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/rpc_pipe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -587,6 +587,8 @@ static struct dentry *__rpc_lookup_creat
 	struct dentry *dentry;
 
 	dentry = __rpc_lookup_create(parent, name);
+	if (IS_ERR(dentry))
+		return dentry;
 	if (dentry->d_inode == NULL)
 		return dentry;
 	dput(dentry);


