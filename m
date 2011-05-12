Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab1ELTTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:19:17 -0400
Received: from mail.perches.com ([173.55.12.10]:1571 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544Ab1ELTTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:19:14 -0400
From: Joe Perches <joe@perches.com>
To: Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] sctp: sctp_sendmsg: Don't test known non-null sinfo
Date: Thu, 12 May 2011 12:19:10 -0700
Message-Id: <b6372a0ac574e3fd110de57eb3e41d97c73d5423.1305227621.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1305227620.git.joe@perches.com>
References: <cover.1305227620.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's already known non-null above.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/sctp/socket.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a5d3560..10ebcd7 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1793,12 +1793,10 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
 		goto out_free;
 	}
 
-	if (sinfo) {
-		/* Check for invalid stream. */
-		if (sinfo->sinfo_stream >= asoc->c.sinit_num_ostreams) {
-			err = -EINVAL;
-			goto out_free;
-		}
+	/* Check for invalid stream. */
+	if (sinfo->sinfo_stream >= asoc->c.sinit_num_ostreams) {
+		err = -EINVAL;
+		goto out_free;
 	}
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
-- 
1.7.5.rc3.dirty

