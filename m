Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab0C3XbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:31:05 -0400
Received: from kroah.org ([198.145.64.141]:46650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474Ab0C3XVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:38 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:41 2010
Message-Id: <20100330224841.293482367@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Zhu Yi <yi.zhu@intel.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [124/156] llc: use limited socket backlog
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

[ Upstream commit 79545b681961d7001c1f4c3eb9ffb87bed4485db ]

Make llc adapt to the limited socket backlog change.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/llc/llc_conn.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -756,7 +756,8 @@ void llc_conn_handler(struct llc_sap *sa
 	else {
 		dprintk("%s: adding to backlog...\n", __func__);
 		llc_set_backlog_type(skb, LLC_PACKET);
-		sk_add_backlog(sk, skb);
+		if (sk_add_backlog_limited(sk, skb))
+			goto drop_unlock;
 	}
 out:
 	bh_unlock_sock(sk);


