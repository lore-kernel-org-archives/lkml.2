Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1ABHjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:39:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:36692 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab1ABHYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Kees Cook <kees.cook@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 198/260] net: clear heap allocations for privileged ethtool actions
Date: Sun,  2 Jan 2011 02:18:14 -0500
Message-Id: <1293952756-15010-199-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:47.0526 (UTC) FILETIME=[FEDC8660:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <kees.cook@canonical.com>

commit b00916b189d13a615ff05c9242201135992fcda3 upstream.

Several other ethtool functions leave heap uncleared (potentially) by
drivers. Some interfaces appear safe (eeprom, etc), in that the sizes
are well controlled. In some situations (e.g. unchecked error conditions),
the heap will remain unchanged in areas before copying back to userspace.
Note that these are less of an issue since these all require CAP_NET_ADMIN.

[PG: 34 doesn't have ethtool_get_rxnfc(), drop that chunk]

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/ethtool.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index f4d6a12..5328c62 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -464,7 +464,7 @@ static int ethtool_get_rx_ntuple(struct net_device *dev, void __user *useraddr)
 
 	gstrings.len = ret;
 
-	data = kmalloc(gstrings.len * ETH_GSTRING_LEN, GFP_USER);
+	data = kzalloc(gstrings.len * ETH_GSTRING_LEN, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -701,7 +701,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 	if (regs.len > reglen)
 		regs.len = reglen;
 
-	regbuf = kmalloc(reglen, GFP_USER);
+	regbuf = kzalloc(reglen, GFP_USER);
 	if (!regbuf)
 		return -ENOMEM;
 
-- 
1.7.3.3

