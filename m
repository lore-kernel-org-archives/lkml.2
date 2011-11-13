Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1KMNgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 08:36:46 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:56544 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1KMNgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 08:36:45 -0500
Subject: [PATCH] rds: drop "select LLIST"
From: Paul Bolle <pebolle@tiscali.nl>
To: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 14:36:37 +0100
Message-ID: <1321191397.20271.62.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1bc144b625 ("net, rds, Replace xlist in net/rds/xlist.h with
llist") added "select LLIST" to the RDS_RDMA Kconfig entry. But there is
no Kconfig symbol named LLIST. The select statement for that symbol is a
nop. Drop it.

lib/llist.o is builtin, so all that's needed to use the llist
functionality is to include linux/llist.h, which this commit also did.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "yes "" | make config" before and after applying this patch.
Identical .config files were generated, as was expected

 net/rds/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/rds/Kconfig b/net/rds/Kconfig
index 4cf6dc7..ec753b3 100644
--- a/net/rds/Kconfig
+++ b/net/rds/Kconfig
@@ -9,7 +9,6 @@ config RDS
 
 config RDS_RDMA
 	tristate "RDS over Infiniband and iWARP"
-	select LLIST
 	depends on RDS && INFINIBAND && INFINIBAND_ADDR_TRANS
 	---help---
 	  Allow RDS to use Infiniband and iWARP as a transport.
-- 
1.7.4.4



