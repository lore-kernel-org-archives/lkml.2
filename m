Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1AFA37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:59 -0500
Received: from kroah.org ([198.145.64.141]:35739 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab1AFA35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:57 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:02 2011
Message-Id: <20110106002302.752605499@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hillf Danton <dhillf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [065/152] bonding: Fix slave selection bug.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Hillf Danton <dhillf@gmail.com>

[ Upstream commit af3e5bd5f650163c2e12297f572910a1af1b8236 ]

The returned slave is incorrect, if the net device under check is not
charged yet by the master.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/bonding/bonding.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -240,11 +240,11 @@ static inline struct slave *bond_get_sla
 
 	bond_for_each_slave(bond, slave, i) {
 		if (slave->dev == slave_dev) {
-			break;
+			return slave;
 		}
 	}
 
-	return slave;
+	return 0;
 }
 
 static inline struct bonding *bond_get_bond_by_slave(struct slave *slave)


