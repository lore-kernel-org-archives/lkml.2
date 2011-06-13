Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1FMWLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:11:10 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42127 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab1FMWLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:11:07 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: Weiping Pan <panweiping3@gmail.com>
cc: error27@gmail.com,
        Andy Gospodarek (supporter:BONDING DRIVER) <andy@greyhouse.net>,
        netdev@vger.kernel.org (open list:BONDING DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] bonding:delete a dereference before check
In-reply-to: <1307975410-13523-1-git-send-email-panweiping3@gmail.com>
References: <20110611081214.GA21427@shale.localdomain> <1307975410-13523-1-git-send-email-panweiping3@gmail.com>
Comments: In-reply-to Weiping Pan <panweiping3@gmail.com>
   message dated "Mon, 13 Jun 2011 22:30:10 +0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Mon, 13 Jun 2011 15:11:01 -0700
Message-ID: <18226.1308003061@death>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Weiping Pan <panweiping3@gmail.com> wrote:

>Dan Carpenter found that there was a dereference before a check,
>added in 56d00c677de0(bonding:delete lacp_fast from ad_bond_info).
>
>Signed-off-by: Weiping Pan <panweiping3@gmail.com>

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>

	-J

> drivers/net/bonding/bond_3ad.c |    3 +--
> 1 files changed, 1 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>index 6122725..77da2e8 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -1900,7 +1900,6 @@ void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
> int bond_3ad_bind_slave(struct slave *slave)
> {
> 	struct bonding *bond = bond_get_bond_by_slave(slave);
>-	int lacp_fast = bond->params.lacp_fast;
> 	struct port *port;
> 	struct aggregator *aggregator;
>
>@@ -1916,7 +1915,7 @@ int bond_3ad_bind_slave(struct slave *slave)
> 		// port initialization
> 		port = &(SLAVE_AD_INFO(slave).port);
>
>-		ad_initialize_port(port, lacp_fast);
>+		ad_initialize_port(port, bond->params.lacp_fast);
>
> 		port->slave = slave;
> 		port->actor_port_number = SLAVE_AD_INFO(slave).id;
>-- 
>1.7.4.4
