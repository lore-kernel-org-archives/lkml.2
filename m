Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab0FKUli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:41:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38755 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab0FKUlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mKZI+yAPQ6uzkG2ordPLKNSkzNLQyv9Z5Nr/PCfekBCgJWQkxV7g5RNK5/WCNulwyf
         2vgnELfuNYrd0Kwts1FBUW0ZA12C0+nrPa1o2gYmhMyGZCK7NkRjGICmLXBGfNHzcwlc
         UvmGLAcDGFaU4gme26HjrXHVmP8wNDmjQEooA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, zippel@linux-m68k.org,
       linux-fsdevel@vger.kernel.org, rusty@rustcorp.com.au,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 6/6]afs:fsclient.c Fix variable 'bp' set but not used
Date: Fri, 11 Jun 2010 13:41:09 -0700
Message-Id: <1276288869-16815-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
References: <1276288869-16815-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes this warning message I'm getting:

  CC [M]  fs/afs/fsclient.o
fs/afs/fsclient.c: In function 'afs_deliver_fs_xxxx_lock':
fs/afs/fsclient.c:1759:16: warning: variable 'bp' set but not used
  CC [M]  fs/afs/inode.o

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/afs/fsclient.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 4bd0218..aca2ccb 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -1756,8 +1756,7 @@ int afs_fs_get_volume_status(struct afs_server *server,
 static int afs_deliver_fs_xxxx_lock(struct afs_call *call,
 				    struct sk_buff *skb, bool last)
 {
-	const __be32 *bp;
-
+	
 	_enter("{%u},{%u},%d", call->unmarshall, skb->len, last);
 
 	afs_transfer_reply(call, skb);
@@ -1767,8 +1766,6 @@ static int afs_deliver_fs_xxxx_lock(struct afs_call *call,
 	if (call->reply_size != call->reply_max)
 		return -EBADMSG;
 
-	/* unmarshall the reply once we've received all of it */
-	bp = call->buffer;
 	/* xdr_decode_AFSVolSync(&bp, call->replyX); */
 
 	_leave(" = 0 [done]");
-- 
1.7.1.rc1.21.gf3bd6

