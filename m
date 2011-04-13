Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab1DMQYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:24:13 -0400
Received: from kroah.org ([198.145.64.141]:52845 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932852Ab1DMQNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:45 2011
Message-Id: <20110413161045.528078570@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [29/71] UBIFS: fix oops on error path in read_pnode
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 54acbaaa523ca0bd284a18f67ad213c379679e86 upstream.

Thanks to coverity which spotted that UBIFS will oops if 'kmalloc()'
in 'read_pnode()' fails and we dereference a NULL 'pnode' pointer
when we 'goto out'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/lpt.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ubifs/lpt.c
+++ b/fs/ubifs/lpt.c
@@ -1269,10 +1269,9 @@ static int read_pnode(struct ubifs_info
 	lnum = branch->lnum;
 	offs = branch->offs;
 	pnode = kzalloc(sizeof(struct ubifs_pnode), GFP_NOFS);
-	if (!pnode) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!pnode)
+		return -ENOMEM;
+
 	if (lnum == 0) {
 		/*
 		 * This pnode was not written which just means that the LEB


