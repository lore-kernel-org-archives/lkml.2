Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000Ab0G2ENO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 00:13:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60541 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab0G2ENM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 00:13:12 -0400
Date: Thu, 29 Jul 2010 14:13:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kravkov <dmitry@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>
Subject: linux-next: build failure after merge of the final tree (net tree
 related)
Message-Id: <20100729141306.f27fad7a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/bnx2x/bnx2x_cmn.c: In function 'bnx2x_start_xmit':
drivers/net/bnx2x/bnx2x_cmn.c:2015: error: implicit declaration of function 'csum_ipv6_magic'

Caused by commit 9f6c925889ad9204c7d1f5ca116d2e5fd6036c72 ("bnx2x: Create
bnx2x_cmn.* files").  See Rule 1 in Documentation/SubmitChecklist. :-)

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 29 Jul 2010 14:07:49 +1000
Subject: [PATCH] net: bnx2x_cmn.c needs net/ip6_checksum.h for csum_ipv6_magic

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/bnx2x/bnx2x_cmn.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/bnx2x/bnx2x_cmn.c b/drivers/net/bnx2x/bnx2x_cmn.c
index 30d20c7..02bf710 100644
--- a/drivers/net/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/bnx2x/bnx2x_cmn.c
@@ -19,6 +19,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <net/ip6_checksum.h>
 #include "bnx2x_cmn.h"
 
 #ifdef BCM_VLAN
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
