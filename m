Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab0E3H7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 03:59:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:46213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0E3H7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 03:59:42 -0400
Date: Sun, 30 May 2010 07:59:27 +0000
From: Denis Kirjanov <dkirjanov@hera.kernel.org>
To: dhowells@redhat.com
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] afs: fix possible null pointer dereference in
	afs_alloc_server
Message-ID: <20100530075927.GA4912@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 30 May 2010 07:59:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix possible null pointer dereference since kzalloc can return null

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
fs/afs/server.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/afs/server.c b/fs/afs/server.c
index f490995..32e2a91 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -93,7 +93,10 @@ static struct afs_server *afs_alloc_server(struct afs_cell *cell,
 		server->addr.s_addr = addr->s_addr;
 	}
 
-	_leave(" = %p{%d}", server, atomic_read(&server->usage));
+	if (likely(server))
+		_leave(" = %p{%d}", server, atomic_read(&server->usage));
+	else
+		_leave(" = -ENOMEM");
 	return server;
 }
 
