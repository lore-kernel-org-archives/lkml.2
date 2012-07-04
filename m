Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab2GDB4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 21:56:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11766 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab2GDB4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 21:56:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6761"; a="204942389"
X-IronPort-AV: E=Sophos;i="4.77,518,1336374000"; 
   d="scan'208";a="253001841"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Subject: RE: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Thread-Topic: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Thread-Index: AQHNWNx3rVTcv+CuHUatM2rT5nzBjJcXholAgADW3oA=
Date: Wed, 4 Jul 2012 01:56:41 +0000
Message-ID: <6349D7A510622448B1BA0967850A8438012EBAE2@nasanexd02d.na.qualcomm.com>
References: <1341322056-26582-1-git-send-email-cjren@qca.qualcomm.com>
 <157393863283F442885425D2C454285623DB7BEC@NASANEXD02A.na.qualcomm.com>
In-Reply-To: <157393863283F442885425D2C454285623DB7BEC@NASANEXD02A.na.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.48.1]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q641us5e019804

Xiong, It looks my system time is wrong. After correct it, I will resend it.

Cloud ren

-----Original Message-----
From: Huang, Xiong 
Sent: 2012Äê7ÔÂ3ÈÕ 21:04
To: Ren, Cloud; davem@davemloft.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: qca-linux-team; nic-devel
Subject: RE: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out

Cloud,  why your patch contains :  'From: Cloud Ren <cjren@qca.qualcomm.com>'
I don¡¯t find it in other people's patch.

Doesn't David Miller think your time is wrong ?


> -----Original Message-----
> From: Ren, Cloud
> Sent: Tuesday, July 03, 2012 21:28
> To: davem@davemloft.net; netdev@vger.kernel.org; linux- 
> kernel@vger.kernel.org
> Cc: qca-linux-team; nic-devel; Ren, Cloud
> Subject: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
> 
> From: Cloud Ren <cjren@qca.qualcomm.com>
> 
> some people report atl1c could cause system hang with following kernel 
> trace
> info:
> ---------------------------------------
> WARNING: at.../net/sched/sch_generic.c:258 dev_watchdog+0x1db/0x1d0() ...
> NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out ...
> ---------------------------------------
> This is caused by netif_stop_queue calling when cable Link is down.
> So remove netif_stop_queue, because link_watch will take it over.
> 
> Signed-off-by: xiong <xiong@qca.qualcomm.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 85717cb..7901831 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -261,7 +261,6 @@ static void atl1c_check_link_status(struct 
> atl1c_adapter *adapter)
>  	if ((phy_data & BMSR_LSTATUS) == 0) {
>  		/* link down */
>  		netif_carrier_off(netdev);
> -		netif_stop_queue(netdev);
>  		hw->hibernate = true;
>  		if (atl1c_reset_mac(hw) != 0)
>  			if (netif_msg_hw(adapter))
> --
> 1.7.7

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
