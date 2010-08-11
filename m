Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab0HKNKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:10:07 -0400
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:60350 "EHLO
	homiemail-a5.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751871Ab0HKNKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:10:05 -0400
Subject: [PATCH] nfs: Remove redundant NULL check upon kfree()
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 09:10:00 -0400
Message-ID: <1281532200.2067.7.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nfs: Remove redundant NULL check upon kfree().

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 fs/nfs/nfs4proc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 7ffbb98..6b44bbf 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2273,8 +2273,7 @@ static int nfs4_get_referral(struct inode *dir, const struct qstr *name, struct
 out:
 	if (page)
 		__free_page(page);
-	if (locations)
-		kfree(locations);
+	kfree(locations);
 	return status;
 }
 
-- 
1.7.0.4



