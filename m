Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1K1Nug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:50:36 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:52615 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1K1Nua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:50:30 -0500
X-Greylist: delayed 755 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 08:50:30 EST
X-manitu-Original-Sender-IP: 79.214.45.183
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <4ED38EB1.6030806@grandegger.com>
Date: Mon, 28 Nov 2011 14:37:53 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: "Mosler, Martin" <mmo@zuehlke.com>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/can/mscan: Enable interrupts when all TX buffers
 are occupied to get notified when they are available again
References: <C3745E3C7FD07D429C54EB3D7606A5A7677E7C@ZRHEX021.ads.zuehlke.com>
In-Reply-To: <C3745E3C7FD07D429C54EB3D7606A5A7677E7C@ZRHEX021.ads.zuehlke.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 02:25 PM, Mosler, Martin wrote:
> When all TX buffers of the mscan are occupied the network layer is told to stop sending further packets. However the TX interrupts are not enabled and therefore the driver has no chance to tell the network layer when it is ready to accept further packets.
> 
> Signed-off-by: Martin Mosler <mmo@zuehlke.com>
> 
> --- linux-2.6/drivers/net/can/mscan/mscan.c.orig    2011-11-28 13:54:29.547850661 +0100
> +++ linux-2.6/drivers/net/can/mscan/mscan.c 2011-11-28 13:55:52.427849601 +0100
> @@ -214,6 +214,7 @@ static netdev_tx_t mscan_start_xmit(stru
>     case 0:
>         netif_stop_queue(dev);
>         dev_err(dev->dev.parent, "Tx Ring full when queue awake!\n");
> +       out_8(&regs->cantier, priv->tx_active);
>         return NETDEV_TX_BUSY;
>     case 1:
>         /*  

Hm, did you see the error message. Actually, it should never happen, IIRC.

Wolfgang.

