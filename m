Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1FMOaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:30:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61544 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab1FMOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OumcI9qdqNTqAIUSK/piWoZnjYYf+Tqb4bRTWcJS7KdriaAT8iib1nJ+vVF87ilT5w
         cLlMBs247LtsvxeaInnqhEahcn43Pj4wSfvpj+rkCBSD/+pCM3BLuezU4uRlvGddKbZ1
         PYVOV0zhKffV9zuODQupl/1tvbOC+tstEAZXc=
From: Weiping Pan <panweiping3@gmail.com>
To: error27@gmail.com
Cc: Weiping Pan <panweiping3@gmail.com>,
        Jay Vosburgh <fubar@us.ibm.com> (supporter:BONDING DRIVER),
        Andy Gospodarek <andy@greyhouse.net> (supporter:BONDING DRIVER),
        netdev@vger.kernel.org (open list:BONDING DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] bonding:delete a dereference before check
Date: Mon, 13 Jun 2011 22:30:10 +0800
Message-Id: <1307975410-13523-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20110611081214.GA21427@shale.localdomain>
References: <20110611081214.GA21427@shale.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter found that there was a dereference before a check,
added in 56d00c677de0(bonding:delete lacp_fast from ad_bond_info).

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_3ad.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 6122725..77da2e8 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1900,7 +1900,6 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 int bond_3ad_bind_slave(struct slave *slave)
 {
 	struct bonding *bond = bond_get_bond_by_slave(slave);
-	int lacp_fast = bond->params.lacp_fast;
 	struct port *port;
 	struct aggregator *aggregator;
 
@@ -1916,7 +1915,7 @@ int bond_3ad_bind_slave(struct slave *slave)
 		// port initialization
 		port = &(SLAVE_AD_INFO(slave).port);
 
-		ad_initialize_port(port, lacp_fast);
+		ad_initialize_port(port, bond->params.lacp_fast);
 
 		port->slave = slave;
 		port->actor_port_number = SLAVE_AD_INFO(slave).id;
-- 
1.7.4.4

