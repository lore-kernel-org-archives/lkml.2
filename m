Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab2IQA70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:59:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33906 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515Ab2IQAvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:22 -0400
Message-Id: <20120917003632.487583174@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pavel Shilovsky <pshilovsky@etersoft.ru>,
        Steve French <smfrench@gmail.com>
Subject: [ 045/135] CIFS: Fix error handling in cifs_push_mandatory_locks
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@etersoft.ru>

commit e2f2886a824ff0a56da1eaa13019fde86aa89fa6 upstream.

Signed-off-by: Pavel Shilovsky <pshilovsky@etersoft.ru>
Signed-off-by: Steve French <smfrench@gmail.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -882,7 +882,7 @@ cifs_push_mandatory_locks(struct cifsFil
 	if (!buf) {
 		mutex_unlock(&cinode->lock_mutex);
 		FreeXid(xid);
-		return rc;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < 2; i++) {


