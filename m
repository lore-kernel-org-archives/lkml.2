Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0HZPnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:43:16 -0400
Received: from mail.vyatta.com ([76.74.103.46]:46210 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab0HZPnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:43:14 -0400
Date: Thu, 26 Aug 2010 08:43:12 -0700
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
Message-ID: <20100826084312.2b23048f@nehalam>
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

> s32 pch_gbe_mac_read_mac_addr(struct pch_gbe_hw *hw)
> +{
> +	u32  adr1a, adr1b;
> +
> +	PCH_GBE_DEBUG("pch_gbe_mac_read_mac_addr\n");
> +
> +	adr1a = ioread32(&hw->reg->mac_adr[0].high);
> +	adr1b = ioread32(&hw->reg->mac_adr[0].low);
> +
> +	hw->mac.addr[0] = (u8)(adr1a & 0xFF);
> +	hw->mac.addr[1] = (u8)((adr1a >> 8) & 0xFF);
> +	hw->mac.addr[2] = (u8)((adr1a >> 16) & 0xFF);
> +	hw->mac.addr[3] = (u8)((adr1a >> 24) & 0xFF);
> +	hw->mac.addr[4] = (u8)(adr1b & 0xFF);
> +	hw->mac.addr[5] = (u8)((adr1b >> 8) & 0xFF);
> +
> +	PCH_GBE_DEBUG("hw->mac.addr : 0x%02x %02x %02x %02x %02x %02x\n",
> +		hw->mac.addr[0], hw->mac.addr[1], hw->mac.addr[2],
> +		hw->mac.addr[3], hw->mac.addr[4], hw->mac.addr[5]);

can use new %pM printk format here.
