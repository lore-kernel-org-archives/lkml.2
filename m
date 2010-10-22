Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0JVSit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:38:49 -0400
Received: from kroah.org ([198.145.64.141]:45787 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733Ab0JVSis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:59 2010
Message-Id: <20101022183559.861034955@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <kees.cook@canonical.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [41/66] net: clear heap allocations for privileged ethtool actions
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
 net/core/ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -311,7 +311,7 @@ static int ethtool_get_regs(struct net_d
 	if (regs.len > reglen)
 		regs.len = reglen;
 
-	regbuf = kmalloc(reglen, GFP_USER);
+	regbuf = kzalloc(reglen, GFP_USER);
 	if (!regbuf)
 		return -ENOMEM;
 


