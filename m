Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0JaRKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:10:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53346 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0JaRKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JDuui4PYMoh4BwvtowCYNIuLyMt2E5Cu+0PRAVUbJJbTV1XXruTBZw1qRMpg+FeMEI
         3u/waQ8wutBHwn3ba8CIhrvQ7rwR72r86AmGuBMcBwnpYDAM60Qj/vsFWj4qzcWlwq0R
         n3DQch6eDmufpEW82wlbN9gg7R0QHgFwhrcko=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Joerg Reuter <jreuter@yaina.de>, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: ax25: fix information leak to userland
Date: Sun, 31 Oct 2010 20:10:22 +0300
Message-Id: <1288545022-16393-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes ax25_getname() doesn't initialize all members of fsa_digipeater
field of fsa struct.  This structure is then copied to userland.  It leads to
leaking of contents of kernel stack memory.  We have to initialize them to zero.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 net/ax25/af_ax25.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 26eaebf..a324d83 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1392,6 +1392,7 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
 	ax25_cb *ax25;
 	int err = 0;
 
+	memset(&fsa->fsa_digipeater, 0, sizeof(fsa->fsa_digipeater));
 	lock_sock(sk);
 	ax25 = ax25_sk(sk);
 
-- 
1.7.0.4

