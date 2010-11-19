Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab0KSWBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:01:37 -0500
Received: from kroah.org ([198.145.64.141]:45394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757637Ab0KSV7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:06 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:45 2010
Message-Id: <20101119215645.071030053@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ulrich Weber <uweber@astaro.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [77/82] xfrm4: strip ECN bits from tos field
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Ulrich Weber <uweber@astaro.com>

[ Upstream commit 94e2238969e89f5112297ad2a00103089dde7e8f ]

otherwise ECT(1) bit will get interpreted as RTO_ONLINK
and routing will fail with XfrmOutBundleGenError.

Signed-off-by: Ulrich Weber <uweber@astaro.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/xfrm4_policy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -61,7 +61,7 @@ static int xfrm4_get_saddr(struct net *n
 
 static int xfrm4_get_tos(struct flowi *fl)
 {
-	return fl->fl4_tos;
+	return IPTOS_RT_MASK & fl->fl4_tos; /* Strip ECN bits */
 }
 
 static int xfrm4_init_path(struct xfrm_dst *path, struct dst_entry *dst,


