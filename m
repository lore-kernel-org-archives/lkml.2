Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0HZPk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:40:26 -0400
Received: from mail.vyatta.com ([76.74.103.46]:37558 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab0HZPkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:40:25 -0400
Date: Thu, 26 Aug 2010 08:40:22 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ML netdev <netdev@vger.kernel.org>,
        Greg Rose <gregory.v.rose@intel.com>, Maxime Bizon <mbizon@freebox.fr>,
        Kristoffer Glembo <kristoffer@gaisler.com>,
        Ralf Baechle <ralf@linux-mips.org>, John Linn <john.linn@xilinx.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, MeeGo <meego-dev@meego.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>
Subject: Re: [PATCH] Gigabit Ethernet driver of Topcliff PCH
Message-ID: <20100826084022.457ac967@nehalam>
In-Reply-To: <4C763A67.5040107@dsn.okisemi.com>
References: <4C763A67.5040107@dsn.okisemi.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 18:56:55 +0900
Masayuki Ohtake <masa-korg@dsn.okisemi.com> wrote:

> +static int pch_gbe_get_settings(struct net_device *netdev,
> +				 struct ethtool_cmd *ecmd)
> +{
> +	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
> +	int ret;
> +
> +	PCH_GBE_DEBUG("ethtool: %s\n", __func__);
> +
> +	ret = mii_ethtool_gset(&adapter->mii, ecmd);
> +	ecmd->supported &= (u32) (~SUPPORTED_TP);
> +	ecmd->supported &= (u32) (~SUPPORTED_1000baseT_Half);
> +	ecmd->advertising &= (u32) (~ADVERTISED_TP);
> +	ecmd->advertising &= (u32) (~ADVERTISED_1000baseT_Half);
> +
> +	if (netif_carrier_ok(adapter->netdev)) {
> +		;
> +	} else {
> +		ecmd->speed = 0xFFFF;
> +		ecmd->duplex = 0xFF;
> +	}
> +	return ret;
> +}

No need for cast to u32 on the masking:
        ecmd->supported &= ~(SUPPORTED_TP | SUPPORTED_1000baseT_Half);
	ecmd->advertising &= ~(ADVERTISED_TP | ADVERTISED_1000baseT_Half);



Awkward use of if, and don't set other bits in duplex
       if (!netif_carrier_ok(adapter->netdev))
                ecmd->speed = -1;
            

-- 
