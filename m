Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0IESdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:33:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60131 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0IESdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:33:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FAgap7W4hCuTm9pEx+HKi9bAKD1W+5VuMD95aQlz6RdmGqMuWxzGx6NyXmLeL9zMYO
         lcMd3z2LeMv86cxa+X83DnT4M3AcwYR/ayEAdJ8fjiA7TVE8J1qiS4RcVhEiaWGUOaTD
         gn7x0vKsanJWxZg1buC3RvDqbGXt504VefE04=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, Julia Lawall <julia@diku.dk>,
        Tejun Heo <tj@kernel.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] ubifs: check return code of ubifs_lpt_lookup
Date: Sun,  5 Sep 2010 22:33:00 +0400
Message-Id: <1283711580-7546-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function ubifs_lpt_lookup may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 fs/ubifs/lpt.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c
index 0084a33..841bb36 100644
--- a/fs/ubifs/lpt.c
+++ b/fs/ubifs/lpt.c
@@ -1351,6 +1351,7 @@ static int read_lsave(struct ubifs_info *c)
 {
 	int err, i;
 	void *buf;
+	struct ubifs_lprops *perr;
 
 	buf = vmalloc(c->lsave_sz);
 	if (!buf)
@@ -1370,7 +1371,11 @@ static int read_lsave(struct ubifs_info *c)
 		 */
 		if (lnum >= c->leb_cnt)
 			continue;
-		ubifs_lpt_lookup(c, lnum);
+		perr = ubifs_lpt_lookup(c, lnum);
+		if (IS_ERR(perr)) {
+			err = PTR_ERR(perr);
+			goto out;
+		}
 	}
 out:
 	vfree(buf);
-- 
1.7.0.4

