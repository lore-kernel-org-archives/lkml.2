Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab0FSVAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 17:00:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38003 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0FSVAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 17:00:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uTq7kwX3cpnI9oO+00h5Pa5kaR/nRjTRbyVxHQxmwi2GhkUXa+7qk0tNhwanNkezKL
         x89hfA6A4BpJDuWs/hrEc66hlbTJWSUxouMD1JRaYC6eVHSBSQC1wDvlbpcU0/uQymw1
         iB2NWrShroG4+HMbnx60E5zFbyxdaur6oGPKw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-afs@lists.infradead.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 6/6 v2]afs:fsclient.c Fix variable 'bp' set but not used
Date: Sat, 19 Jun 2010 14:00:16 -0700
Message-Id: <1276981216-25252-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend from the original, due to whitespace issues.
The below patch fixes a warning message recieved when building
the kernel with gcc 4.6.0
  CC [M]  fs/afs/fsclient.o
fs/afs/fsclient.c: In function 'afs_deliver_fs_xxxx_lock':
fs/afs/fsclient.c:1759:16: warning: variable 'bp' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/afs/fsclient.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 4bd0218..1f63eca 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -1756,7 +1756,6 @@ int afs_fs_get_volume_status(struct afs_server *server,
 static int afs_deliver_fs_xxxx_lock(struct afs_call *call,
 				    struct sk_buff *skb, bool last)
 {
-	const __be32 *bp;
 
 	_enter("{%u},{%u},%d", call->unmarshall, skb->len, last);
 
@@ -1767,8 +1766,6 @@ static int afs_deliver_fs_xxxx_lock(struct afs_call *call,
 	if (call->reply_size != call->reply_max)
 		return -EBADMSG;
 
-	/* unmarshall the reply once we've received all of it */
-	bp = call->buffer;
 	/* xdr_decode_AFSVolSync(&bp, call->replyX); */
 
 	_leave(" = 0 [done]");
-- 
1.7.1.rc1.21.gf3bd6

