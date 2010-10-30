Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0J3O1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:27:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51790 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab0J3O04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YoVNYYr62GRSbk38ZCNjqJ7yYULcDzYu3qbyPeKJ/1o2hClQeyp/kznYO3kLovDCKP
         iL3CDmit+A5IwtbZ2a8C1lcVZX1y/xWBIHlRIvDwQlAWk7fOFBdNM2Y5znIuk7pR01By
         VJL++4yerDL2gqEXgpDKGpDnGGVyFUF4yu/qQ=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipv4: netfilter: ip_tables: fix information leak to userland
Date: Sat, 30 Oct 2010 18:26:50 +0400
Message-Id: <1288448810-6628-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure ipt_getinfo is copied to userland with the field "name"
that has the last elements unitialized.  It leads to leaking of
contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 net/ipv4/netfilter/ip_tables.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index d31b007..a846d63 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1124,6 +1124,7 @@ static int get_info(struct net *net, void __user *user,
 			private = &tmp;
 		}
 #endif
+		memset(&info, 0, sizeof(info));
 		info.valid_hooks = t->valid_hooks;
 		memcpy(info.hook_entry, private->hook_entry,
 		       sizeof(info.hook_entry));
-- 
1.7.0.4

