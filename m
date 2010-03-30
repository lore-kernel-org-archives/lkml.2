Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab0C3XJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:09:01 -0400
Received: from kroah.org ([198.145.64.141]:48440 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab0C3XI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:58 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:47 2010
Message-Id: <20100330224947.310212430@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sascha Hlusiak <contact@saschahlusiak.de>,
       "Fred L. Templin" <Fred.L.Templin@boeing.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [13/45] sit: fix off-by-one in ipip6_tunnel_get_prl
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sascha Hlusiak <contact@saschahlusiak.de>

commit 298bf12ddb25841804f26234a43b89da1b1c0e21 upstream.

When requesting all prl entries (kprl.addr == INADDR_ANY) and there are
more prl entries than there is space passed from userspace, the existing
code would always copy cmax+1 entries, which is more than can be handled.

This patch makes the kernel copy only exactly cmax entries.

Signed-off-by: Sascha Hlusiak <contact@saschahlusiak.de>
Acked-By: Fred L. Templin <Fred.L.Templin@boeing.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/sit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -260,7 +260,7 @@ static int ipip6_tunnel_get_prl(struct i
 
 	c = 0;
 	for (prl = t->prl; prl; prl = prl->next) {
-		if (c > cmax)
+		if (c >= cmax)
 			break;
 		if (kprl.addr != htonl(INADDR_ANY) && prl->addr != kprl.addr)
 			continue;


