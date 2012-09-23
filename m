Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2IWRAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 13:00:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63957 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab2IWRAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 13:00:43 -0400
Date: Sun, 23 Sep 2012 13:03:30 -0400
From: "Maxin B. John" <maxin.john@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Catherine Zhang <cxzhang@watson.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: scm: moving dereference after NULL check
Message-ID: <20120923170330.GA5038@linux-3ix0.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scm_destroy_cred() dereferences 'scm' before null check

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/include/net/scm.h b/include/net/scm.h
index 7dc0854..ed25aa1 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -64,9 +64,11 @@ static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
 
 static __inline__ void scm_destroy(struct scm_cookie *scm)
 {
-	scm_destroy_cred(scm);
-	if (scm && scm->fp)
-		__scm_destroy(scm);
+	if (scm) {
+		scm_destroy_cred(scm);
+		if (scm->fp)
+			__scm_destroy(scm);
+	}
 }
 
 static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
