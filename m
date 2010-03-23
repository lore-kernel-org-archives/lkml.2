Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0CWOuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:50:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab0CWOuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:50:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] fscache: add missing unlock
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, Trond.Myklebust@netapp.com,
       linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Tue, 23 Mar 2010 14:48:37 +0000
Message-ID: <20100323144837.24147.90288.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

Sparse complained about this missing spin_unlock()

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/page.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index c598ea4..6980902 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -881,6 +881,7 @@ submit_failed:
 	goto nobufs;
 
 nobufs_unlock_obj:
+	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 nobufs:
 	spin_unlock(&cookie->lock);

