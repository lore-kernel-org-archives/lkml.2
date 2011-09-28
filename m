Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1I1GxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:53:06 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:53726 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1I1GxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:53:04 -0400
Date: Wed, 28 Sep 2011 16:53:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yogesh Ashok Powar <yogeshp@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the moduleh tree with the  tree
Message-Id: <20110928165300.8126288f6c0e0554acda4c21@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got conflicts in
net/mac80211/util.c and net/wireless/util.c between commit 0879fa44b541
("cfg80211/mac80211: move information element parsing logic to cfg80211")
from the net tree and commit c1f5764979c5 ("net: Add export.h for
EXPORT_SYMBOL/THIS_MODULE to non-modules") from the moduleh tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/mac80211/util.c
index 2c9dc36,7a55c69..0000000
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@@ -19,6 -19,8 +19,7 @@@
  #include <linux/etherdevice.h>
  #include <linux/if_arp.h>
  #include <linux/bitmap.h>
 -#include <linux/crc32.h>
+ #include <linux/export.h>
  #include <net/net_namespace.h>
  #include <net/cfg80211.h>
  #include <net/rtnetlink.h>
diff --cc net/wireless/util.c
index 6304ed6,3ba8eea..0000000
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@@ -6,7 -6,7 +6,8 @@@
  #include <linux/bitops.h>
  #include <linux/etherdevice.h>
  #include <linux/slab.h>
 +#include <linux/crc32.h>
+ #include <linux/export.h>
  #include <net/cfg80211.h>
  #include <net/ip.h>
  #include "core.h"
