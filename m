Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab1BPAfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:35:47 -0500
Received: from kroah.org ([198.145.64.141]:49663 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab1BPAYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:47 2011
Message-Id: <20110216001447.331899878@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eugene Teo <eugeneteo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [222/272] net: clear heap allocation for ethtool_get_regs()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eugene Teo <eugeneteo@kernel.org>

commit b7c7d01aaed1f71d9afe815a569f0a81465a1744 upstream.

There is a conflict between commit b00916b1 and a77f5db3. This patch resolves
the conflict by clearing the heap allocation in ethtool_get_regs().

Signed-off-by: Eugene Teo <eugeneteo@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -817,7 +817,7 @@ static int ethtool_get_regs(struct net_d
 	if (regs.len > reglen)
 		regs.len = reglen;
 
-	regbuf = vmalloc(reglen);
+	regbuf = vzalloc(reglen);
 	if (!regbuf)
 		return -ENOMEM;
 


