Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab0KSWWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:22:14 -0500
Received: from kroah.org ([198.145.64.141]:45259 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab0KSV6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:54 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:43 2010
Message-Id: <20101119215643.514073636@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <kees.cook@canonical.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [58/82] net: clear heap allocations for privileged ethtool actions
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Kees Cook <kees.cook@canonical.com>

[ Upstream commit b00916b189d13a615ff05c9242201135992fcda3 ]

Several other ethtool functions leave heap uncleared (potentially) by
drivers. Some interfaces appear safe (eeprom, etc), in that the sizes
are well controlled. In some situations (e.g. unchecked error conditions),
the heap will remain unchanged in areas before copying back to userspace.
Note that these are less of an issue since these all require CAP_NET_ADMIN.

Cc: stable@kernel.org
Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/ethtool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -482,7 +482,7 @@ static int ethtool_get_rx_ntuple(struct
 
 	gstrings.len = ret;
 
-	data = kmalloc(gstrings.len * ETH_GSTRING_LEN, GFP_USER);
+	data = kzalloc(gstrings.len * ETH_GSTRING_LEN, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -719,7 +719,7 @@ static int ethtool_get_regs(struct net_d
 	if (regs.len > reglen)
 		regs.len = reglen;
 
-	regbuf = kmalloc(reglen, GFP_USER);
+	regbuf = kzalloc(reglen, GFP_USER);
 	if (!regbuf)
 		return -ENOMEM;
 


