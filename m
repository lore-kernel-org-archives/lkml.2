Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0HZPpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:45:38 -0400
Received: from mail.vyatta.com ([76.74.103.46]:46331 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0HZPpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:45:36 -0400
Date: Thu, 26 Aug 2010 08:45:33 -0700
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
Message-ID: <20100826084533.1dfbd9bf@nehalam>
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


> +/**
> + * pch_gbe_mac_init_rx_addrs - Initialize receive address's
> + * @hw:	Pointer to the HW structure
> + * @mar_count: Receive address registers
> + */
> +void pch_gbe_mac_init_rx_addrs(struct pch_gbe_hw *hw, u16 mar_count)
> +{
> +	u32 i;
> +	PCH_GBE_DEBUG("pch_gbe_mac_init_rx_addrs\n");
> +
> +	/* Setup the receive address */
> +	pch_gbe_mac_mar_set(hw, hw->mac.addr, 0);
> +
> +	/* Zero out the other receive addresses */
> +	for (i = 1; i < mar_count; i++) {
> +		iowrite32(0, &hw->reg->mac_adr[i].high);
> +		iowrite32(0, &hw->reg->mac_adr[i].low);
> +	}
> +	iowrite32(0xFFFE, &hw->reg->ADDR_MASK);
> +	/* wait busy */
> +	while ((ioread32(&hw->reg->ADDR_MASK) & PCH_GBE_BUSY))
> +		;
> +}

Use cpu_relax here to allow other hyper-thread to run.
	/* wait busy */
	while ((ioread32(&hw->reg->ADDR_MASK) & PCH_GBE_BUSY))
		cpu_relax();
