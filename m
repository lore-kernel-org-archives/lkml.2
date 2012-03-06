Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab2CFVZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:25:24 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39897 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab2CFVZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:25:23 -0500
Date: Tue, 06 Mar 2012 16:20:17 -0500 (EST)
Message-Id: <20120306.162017.761246743182346842.davem@davemloft.net>
To: stigge@antcom.de
Cc: jeffrey.t.kirsher@intel.com, alexander.h.duyck@intel.com,
        eilong@broadcom.com, ian.campbell@citrix.com, netdev@vger.kernel.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, baruch@tkos.co.il, joe@perches.com
Subject: Re: [PATCH v5] lpc32xx: Added ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331067664-9124-1-git-send-email-stigge@antcom.de>
References: <1331067664-9124-1-git-send-email-stigge@antcom.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 06 Mar 2012 13:20:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>
Date: Tue,  6 Mar 2012 22:01:04 +0100

> +#define RXSTATUS_STATUS_ERROR \
> +	(RXSTATUS_NODESC | RXSTATUS_OVERRUN | RXSTATUS_ALIGN | RXSTATUS_RANGE \
> +	 | RXSTATUS_LENGTH | RXSTATUS_SYMBOL | RXSTATUS_CRC)

Should be:

#define RXSTATUS_STATUS_ERROR \
	(RXSTATUS_NODESC | RXSTATUS_OVERRUN | RXSTATUS_ALIGN | RXSTATUS_RANGE | \
	 RXSTATUS_LENGTH | RXSTATUS_SYMBOL | RXSTATUS_CRC)

> +static int lpc_eth_hard_start_xmit(struct sk_buff *skb,
> +	struct net_device *ndev);

Should be:

static int lpc_eth_hard_start_xmit(struct sk_buff *skb,
				   struct net_device *ndev);

> +struct txrx_desc_t {
> +	u32 packet;
> +	u32 control;
> +};
> +struct rx_status_t {
> +	u32 statusinfo;
> +	u32 statushashcrc;
> +};

What is the endianness of these descriptors?  Based upon the answer to
that question use __be32 or __le32  instead of u32.

> +static void __lpc_eth_clock_enable(struct netdata_local *pldat,
> +	int enable)

Should be:

static void __lpc_eth_clock_enable(struct netdata_local *pldat,
				   int enable)

And you should also use "bool" for enable and pass in true/false
at the call sites.

> +	writel((LPC_MACINT_RXDONEINTEN | LPC_MACINT_TXDONEINTEN),
> +		LPC_ENET_INTENABLE(regbase));

Should be:

	writel((LPC_MACINT_RXDONEINTEN | LPC_MACINT_TXDONEINTEN),
	       LPC_ENET_INTENABLE(regbase));

> +	/* Setup base addresses in hardware to point to buffers and
> +	   descriptors */

Should be:

	/* Setup base addresses in hardware to point to buffers and
	 * descriptors.
	 */

> +	writel((ENET_TX_DESC - 1),
> +		LPC_ENET_TXDESCRIPTORNUMBER(pldat->net_base));

All of these writel() calls are improperly indented on the second and
any subsequent lines just like the one I pointed out above, fix them
all.

> +MODULE_LICENSE("GPL");
> +

Tailing empty line in this file, please remove.
