Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab1I1XDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:03:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933060Ab1I1WrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:44 2011
Message-Id: <20110928220144.741062190@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [184/244] scm: Capture the full credentials of the scm sender
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Tim Chen <tim.c.chen@linux.intel.com>

[ Upstream commit e33f7a9f37d486f4c6cce5de18a6eea11d68f64f ]

This patch corrects an erroneous update of credential's gid with uid
introduced in commit 257b5358b32f17 since 2.6.36.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Reviewed-by: James Morris <jmorris@namei.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/scm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -192,7 +192,7 @@ int __scm_send(struct socket *sock, stru
 					goto error;
 
 				cred->uid = cred->euid = p->creds.uid;
-				cred->gid = cred->egid = p->creds.uid;
+				cred->gid = cred->egid = p->creds.gid;
 				put_cred(p->cred);
 				p->cred = cred;
 			}


