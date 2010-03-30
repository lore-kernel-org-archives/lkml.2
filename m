Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab0CaADj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:03:39 -0400
Received: from kroah.org ([198.145.64.141]:45332 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab0C3XSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:38 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:51 2010
Message-Id: <20100330225650.649261499@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [080/116] sunrpc: handle allocation errors from __rpc_lookup_create()
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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


