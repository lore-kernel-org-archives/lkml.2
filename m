Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2HNPco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:32:44 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:53961
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703Ab2HNPcm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:32:42 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC101.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz9371I542M1432Izz1202hzz8275bh6d523hz2fh2a8h668h839h944hd25hf0ah107ah)
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Ilya Shchepetkov <shchepetkov@ispras.ru>,
        KY Srinivasan <kys@microsoft.com>
CC: "David S. Miller" <davem@davemloft.net>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldv-project@ispras.ru" <ldv-project@ispras.ru>
Subject: RE: [PATCH 5/5] net/hyperv: Call netif_carrier_off() after
 register_netdev()
Thread-Topic: [PATCH 5/5] net/hyperv: Call netif_carrier_off() after
 register_netdev()
Thread-Index: AQHNeges46uQe/2y3kuj3w65p+hIIZdZb1VA
Date: Tue, 14 Aug 2012 15:32:34 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DDFD867@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
 <1344940135-17079-6-git-send-email-shchepetkov@ispras.ru>
In-Reply-To: <1344940135-17079-6-git-send-email-shchepetkov@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ilya Shchepetkov [mailto:shchepetkov@ispras.ru]
> Sent: Tuesday, August 14, 2012 6:29 AM
> To: KY Srinivasan
> Cc: Ilya Shchepetkov; Haiyang Zhang; David S. Miller;
> devel@linuxdriverproject.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; ldv-project@ispras.ru
> Subject: [PATCH 5/5] net/hyperv: Call netif_carrier_off() after
> register_netdev()
> 
> For carrier detection to work properly when binding the driver with a
> cable unplugged, netif_carrier_off() should be called after
> register_netdev(), not before.
> 
> Calling netif_carrier_off() before register_netdev() was causing the
> network interface to miss a linkwatch pending event leading to an
> inconsistent state if the link is not up when interface is initialized.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Ilya Shchepetkov <shchepetkov@ispras.ru>
> ---
>  drivers/net/hyperv/netvsc_drv.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> index 8c5a1c4..5734ad0 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -416,9 +416,6 @@ static int netvsc_probe(struct hv_device *dev,
>  	if (!net)
>  		return -ENOMEM;
> 
> -	/* Set initial state */
> -	netif_carrier_off(net);
> -
>  	net_device_ctx = netdev_priv(net);
>  	net_device_ctx->device_ctx = dev;
>  	hv_set_drvdata(dev, net);
> @@ -441,6 +438,9 @@ static int netvsc_probe(struct hv_device *dev,
>  		goto out;
>  	}
> 
> +	/* Set initial state */
> +	netif_carrier_off(net);
> +
>  	/* Notify the netvsc driver of the new device */
>  	device_info.ring_size = ring_size;
>  	ret = rndis_filter_device_add(dev, &device_info);

Thanks.

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>



