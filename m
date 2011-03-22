Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1CVX1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:27:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56368 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab1CVX1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p77UU2jAV1ZPjkHWVKHOYpc1B/OBnBLhn25G0UsxWPYAzonb06goFQ5VTfldun3W09
         EFyYCTCu5oK6SKNq1nc7H6W40Fx5SnatCbyEP8Yx7dcsKqt1NbHXQsEmhhibPDct1hjR
         Y5rI/cuG+RZ4LQ3FI2dk0xm4gO+nPsQlpIm4g=
From: Pat Kane <pekane52@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pat Kane <pekane52@gmail.com>
Subject: [PATCH] Add secdata to unix_streams.
Date: Tue, 22 Mar 2011 18:27:02 -0500
Message-Id: <1300836422-3839-1-git-send-email-pekane52@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unix_dgram routines add secdata to socket message,
but the unix_stream routines do not.  We add the two
missing lines of code.

Signed-off-by: Pat Kane <pekane52@gmail.com>
---
 net/unix/af_unix.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 1663e1a..3873523 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1642,6 +1642,8 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
 		max_level = err + 1;
 		fds_sent = true;
 
+                unix_get_secdata(siocb->scm, skb);
+
 		err = memcpy_fromiovec(skb_put(skb, size), msg->msg_iov, size);
 		if (err) {
 			kfree_skb(skb);
@@ -1930,6 +1932,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 		} else {
 			/* Copy credentials */
 			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
+                        unix_set_secdata(siocb->scm, skb);
 			check_creds = 1;
 		}
 
-- 
1.7.1

