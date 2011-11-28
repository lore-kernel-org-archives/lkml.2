Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1K1N7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:59:21 -0500
Received: from mx1.zuehlke.com ([193.135.254.67]:51924 "EHLO mx1.zuehlke.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1K1N7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:59:19 -0500
From: "Mosler, Martin" <mmo@zuehlke.com>
To: Wolfgang Grandegger <wg@grandegger.com>
CC: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH] net/can/mscan: Enable interrupts when all TX buffers
 are occupied to get notified when they are available again
Thread-Topic: [PATCH] net/can/mscan: Enable interrupts when all TX buffers
 are occupied to get notified when they are available again
Thread-Index: Acytz0PEWH6BZ/i4S3OXVrtQzUPclf//9pCAgAATdf4=
Date: Mon, 28 Nov 2011 13:59:17 +0000
Message-ID: <C3745E3C7FD07D429C54EB3D7606A5A7677EB2@ZRHEX021.ads.zuehlke.com>
References: <C3745E3C7FD07D429C54EB3D7606A5A7677E7C@ZRHEX021.ads.zuehlke.com>,<4ED38EB1.6030806@grandegger.com>
In-Reply-To: <4ED38EB1.6030806@grandegger.com>
Accept-Language: de-CH, en-US
Content-Language: de-CH
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.31.255.3]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> When all TX buffers of the mscan are occupied the network layer is told to stop sending further packets. However the TX interrupts are not enabled and therefore the driver has no chance to tell the network layer when it is ready to accept further packets.
>>
>> Signed-off-by: Martin Mosler <mmo@zuehlke.com>
>>
>> --- linux-2.6/drivers/net/can/mscan/mscan.c.orig    2011-11-28 13:54:29.547850661 +0100
>> +++ linux-2.6/drivers/net/can/mscan/mscan.c 2011-11-28 13:55:52.427849601 +0100
>> @@ -214,6 +214,7 @@ static netdev_tx_t mscan_start_xmit(stru
>>     case 0:
>>         netif_stop_queue(dev);
>>         dev_err(dev->dev.parent, "Tx Ring full when queue awake!\n");
>> +       out_8(&regs->cantier, priv->tx_active);
>>         return NETDEV_TX_BUSY;
>>     case 1:
>>         /*
>
>Hm, did you see the error message. Actually, it should never happen, IIRC.
>
>Wolfgang.

It is in fact a very rare condition, but it was triggered during testing when pulling CAN-HI and CAN-LO lines
to GND and VCC in various combinations to verify how the system is recovering. I am working with a MPC5125 
if this is valuable information. (This was only one issue I ran into, I had to do other modifications for other 
issues as well, but I think they are chip specific, I'll share them in a separate thread if you like).

