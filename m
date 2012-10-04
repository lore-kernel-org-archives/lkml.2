Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2JDTPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:15:49 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:15981 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751816Ab2JDTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:15:48 -0400
Message-ID: <1349378144.2817.23.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 11/11] net: xilinx: Show csum in bootlog
From: Ben Hutchings <bhutchings@solarflare.com>
To: Michal Simek <monstr@monstr.eu>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 4 Oct 2012 20:15:44 +0100
In-Reply-To: <1349374497-9540-11-git-send-email-monstr@monstr.eu>
References: <1349374497-9540-1-git-send-email-monstr@monstr.eu>
	 <1349374497-9540-11-git-send-email-monstr@monstr.eu>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 20:14 +0200, Michal Simek wrote:
> Just show current setting in bootlog.
[...]
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1052,12 +1052,14 @@ static int __devinit temac_of_probe(struct platform_device *op)
>  	/* Setup checksum offload, but default to off if not specified */
>  	lp->temac_features = 0;
>  	p = (__be32 *)of_get_property(op->dev.of_node, "xlnx,txcsum", NULL);
> +	dev_info(&op->dev, "TX_CSUM %d\n", be32_to_cpup(p));
>  	if (p && be32_to_cpu(*p)) {
>  		lp->temac_features |= TEMAC_FEATURE_TX_CSUM;
>  		/* Can checksum TCP/UDP over IPv4. */
>  		ndev->features |= NETIF_F_IP_CSUM;
>  	}
>  	p = (__be32 *)of_get_property(op->dev.of_node, "xlnx,rxcsum", NULL);
> +	dev_info(&op->dev, "RX_CSUM %d\n", be32_to_cpup(p));
[...]

Is there any particular reason you think this needs to be logged by
default, rather than letting users run ethtool -k?  I suggest using
dev_dbg() instead.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

