Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab2DNKWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:22:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37761 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2DNKWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:22:17 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg, kaber@trash.net,
        davem@davemloft.net
Cc: davej@redhat.com, netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v2 2/2] netfilter: ipvs: use GFP_KERNEL allocation where possible
Date: Sat, 14 Apr 2012 09:22:02 -0400
Message-Id: <1334409722-26315-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334409722-26315-1-git-send-email-levinsasha928@gmail.com>
References: <1334409722-26315-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use GFP_KERNEL instead of GFP_ATOMIC when registering an ipvs protocol.

This is safe since it will always run from a process context.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 net/netfilter/ipvs/ip_vs_proto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto.c b/net/netfilter/ipvs/ip_vs_proto.c
index 57a242d..73d06c6 100644
--- a/net/netfilter/ipvs/ip_vs_proto.c
+++ b/net/netfilter/ipvs/ip_vs_proto.c
@@ -71,7 +71,7 @@ register_ip_vs_proto_netns(struct net *net, struct ip_vs_protocol *pp)
 	struct netns_ipvs *ipvs = net_ipvs(net);
 	unsigned hash = IP_VS_PROTO_HASH(pp->protocol);
 	struct ip_vs_proto_data *pd =
-			kzalloc(sizeof(struct ip_vs_proto_data), GFP_ATOMIC);
+			kzalloc(sizeof(struct ip_vs_proto_data), GFP_KERNEL);
 
 	if (!pd)
 		return -ENOMEM;
-- 
1.7.8.5

