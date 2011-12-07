Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1LGRDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:03:45 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:51821 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757176Ab1LGRDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:03:42 -0500
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mark Lord <kernel@teksavvy.com>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <4EDF9B5F.6050500@teksavvy.com>
References: <4EA89972.5060101@teksavvy.com>
	 <20111026.194045.2019668159403582571.davem@davemloft.net>
	 <4EA8B283.3010105@teksavvy.com>
	 <20111026.221719.2216112919297458522.davem@davemloft.net>
	 <4EB19BBE.5050602@teksavvy.com> <1320266549.2782.21.camel@bwh-desktop>
	 <4EBAA967.10403@teksavvy.com> <1320856444.18929.78.camel@deadeye>
	 <4EBAAEA5.1060408@teksavvy.com> <4EBAB0EA.1050102@teksavvy.com>
	 <4EBAB643.8020603@teksavvy.com> <1320859911.2781.1.camel@bwh-desktop>
	 <4EBABAFD.6050604@teksavvy.com> <1320860895.2781.6.camel@bwh-desktop>
	 <4EDCD828.2090904@teksavvy.com> <1323098335.7454.214.camel@deadeye>
	 <4EDE0E29.9070809@teksavvy.com> <1323193537.2772.9.camel@bwh-desktop>
	 <4EDF9293.8070809@teksavvy.com> <1323275233.2728.3.camel@bwh-desktop>
	 <4EDF9B5F.6050500@teksavvy.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 7 Dec 2011 17:03:38 +0000
Message-ID: <1323277418.2728.35.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18564.005
X-TM-AS-Result: No--16.892100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 11:59 -0500, Mark Lord wrote:
> On 11-12-07 11:27 AM, Ben Hutchings wrote:
> > On Wed, 2011-12-07 at 11:21 -0500, Mark Lord wrote:
> ..
> >> Heh.. my thinking side says to use the exact same protocol-specific flags
> >> in both "hw_features" and "features", and therefore check for those flags
> >> inside the "set_features()" function.
> > 
> > Right.
> 
> 
> Thanks.
> Now now we have:
> 
> static int ax88772b_set_features(struct net_device *netdev, u32 features)
> {
>         struct usbnet *dev = netdev_priv(netdev);
>         u16 tx_csum = 0, rx_csum = 0;
> 
>         if (features & NETIF_F_IP_CSUM)
>                 tx_csum |= AX_TXCOE_TCP | AX_TXCOE_UDP;
>         if (features & NETIF_F_IPV6_CSUM)
>                 tx_csum |= AX_TXCOE_TCPV6 | AX_TXCOE_UDPV6;
>         if (features & NETIF_F_RXCSUM)
>                 rx_csum = AX_RXCOE_DEF_CSUM;
>         ax8817x_write_cmd(dev, AX_CMD_WRITE_TXCOE_CTL, tx_csum, 0, 0, NULL);
>         ax8817x_write_cmd(dev, AX_CMD_WRITE_RXCOE_CTL, rx_csum, 0, 0, NULL);
>         return 0;
> }
> 
> static int ax88772b_bind(struct usbnet *dev, struct usb_interface *intf)
> {
> 	...
> 
>         /* enable hardware checksums */
>         dev->net->hw_features |=
>                 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM;
>         dev->net->features |=
>                 NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM;
>         ax88772b_set_features(dev->net, dev->net->features);
> 	...
> }

Not knowing the hardware, that looks plausible...

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

