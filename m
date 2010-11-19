Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751005Ab0KSGTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 01:19:03 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26347 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704Ab0KSGTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 01:19:01 -0500
Message-ID: <007401cb87b1$a773b3d0$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <andrew.chih.howe.khor@intel.com>,
        <qi.wang@intel.com>, <margie.foster@intel.com>,
        <yong.y.wang@intel.com>, "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>
References: <4CE2434B.5050701@dsn.okisemi.com> <4CE27796.2000206@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 v3] can: Topcliff: PCH_CAN driver: Add Flow control,
Date: Fri, 19 Nov 2010 15:18:58 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 16, 2010 9:22 PM, Marc Kleine-Budde wrote :

Except the following, I have updated/resubmitted already .

>>  static int pch_can_rx_poll(struct napi_struct *napi, int quota)
>>  {
>>   struct net_device *ndev = napi->dev;
>>   struct pch_can_priv *priv = netdev_priv(ndev);
>> - struct net_device_stats *stats = &(priv->ndev->stats);
>> - u32 dlc;
>>   u32 int_stat;
>>   int rcv_pkts = 0;
                    ^^^^
>can be removed...if you remove the += below
Since there is "goto" code, "=0" is better.



>> - spin_unlock_irqrestore(&priv->msgif_reg_lock, flags);
>> + pch_can_rw_msg_obj(&priv->regs->ifregs[1].creq, tx_obj_no);
>Still we have the busy waiting in the TX path. Maybe you can move the
>waiting before accessing the if[1] and remove the busy waiting here.
I can't understand your saying.
For transmitting data, calling pch_can_rw_msg_obj is mandatory.


---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
