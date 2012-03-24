Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2CXPxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 11:53:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57846 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753159Ab2CXPxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 11:53:20 -0400
Message-ID: <1332604398.6160.47.camel@joe2Laptop>
Subject: Re: [PATCH v3] Ethernet driver for the WIZnet W5300 chip
From: Joe Perches <joe@perches.com>
To: Mike Sinkovsky <msink@permonline.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 24 Mar 2012 08:53:18 -0700
In-Reply-To: <1332586938-2804-1-git-send-email-msink@permonline.ru>
References: <1332149037-12025-1-git-send-email-msink@permonline.ru>
	 <1332586938-2804-1-git-send-email-msink@permonline.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-24 at 16:02 +0500, Mike Sinkovsky wrote:
> Based on original driver from chip manufacturer, but nearly full rewite.
> Tested and used in production with Blackfin BF531 embedded processor.

Hi Mike.

Just a trivial comment.  Instead of:
	if (netif_<test>(priv))
		netdev_<level>(ndev, ...)
you can use
	netif_<level>(priv, <test>, ndev, ,...)

> diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
[]
> +static irqreturn_t w5300_detect_link(int irq, void *ndev_instance)
> +{
> +	struct net_device *ndev = ndev_instance;
> +	struct w5300_private *priv = netdev_priv(ndev);
> +
> +	if (netif_running(ndev)) {
> +		if (gpio_get_value(priv->link_gpio) != 0) {
[]
> +			if (netif_msg_link(priv))
> +				netdev_info(ndev, "link is Up\n");

like:
			netif_info(priv, link, ndev, "link is up\n");

> +			netif_carrier_on(ndev);
> +		} else {
> +			if (netif_msg_link(priv))
> +				netdev_info(ndev, "link is Down\n");

			netif_info(priv, link, ndev, "link is down\n");

> +static int w5300_stop(struct net_device *ndev)
> +{
> +	struct w5300_private *priv = netdev_priv(ndev);
> +
> +	if (netif_msg_ifdown(priv))
> +		netdev_dbg(ndev, "shutting down\n");

		netif_dbg(priv, ifdown, ndev, "shutting down\n");


