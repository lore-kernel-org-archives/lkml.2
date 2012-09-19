Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab2ISUWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:22:53 -0400
Received: from mail.vyatta.com ([76.74.103.46]:33928 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab2ISUWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:22:51 -0400
Date: Wed, 19 Sep 2012 13:22:48 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, davem@davemloft.net, mlindner@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net] sky2: fix rx filter setup on link up
Message-ID: <20120919132248.5fced1c7@s6510.linuxnetplumber.net>
In-Reply-To: <1347894617-13614-1-git-send-email-jiri@resnulli.us>
References: <1347894617-13614-1-git-send-email-jiri@resnulli.us>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than saving and restoring values, why not just redo the
full setup? This would also determine if the change was a result
of something outside the driver.


--- a/drivers/net/ethernet/marvell/sky2.c	2012-09-18 21:12:01.156438131 -0700
+++ b/drivers/net/ethernet/marvell/sky2.c	2012-09-19 13:20:40.373620276 -0700
@@ -2201,6 +2201,8 @@ static void sky2_link_up(struct sky2_por
 
 	sky2_enable_rx_tx(sky2);
 
+	sky2_set_multicast(sky2->netdev);
+
 	gm_phy_write(hw, port, PHY_MARV_INT_MASK, PHY_M_DEF_MSK);
 
 	netif_carrier_on(sky2->netdev);
