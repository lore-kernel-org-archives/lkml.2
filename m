Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750778Ab0KVFF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 00:05:56 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14174 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767Ab0KVFFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 00:05:54 -0500
Message-ID: <003201cb8a02$f05b15e0$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: <andrew.chih.howe.khor@intel.com>,
        "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>, <margie.foster@intel.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <socketcan-core@lists.berlios.de>, <yong.y.wang@intel.com>,
        <kok.howg.ewe@intel.com>, "Wolfgang Grandegger" <wg@grandegger.com>,
        <joel.clark@intel.com>, "David S. Miller" <davem@davemloft.net>,
        "Christian Pellegrin" <chripell@fsfe.org>, <qi.wang@intel.com>
References: <4CE2434B.5050701@dsn.okisemi.com>	<4CE27796.2000206@pengutronix.de> <007401cb87b1$a773b3d0$66f8800a@maildom.okisemi.com> <4CE64167.2030405@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 v3] can: Topcliff: PCH_CAN driver: Add Flow control,
Date: Mon, 22 Nov 2010 14:05:52 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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

On Friday, November 19, 2010 6:20 PM,  Marc Kleine-Budde wrote :

>>>> - spin_unlock_irqrestore(&priv->msgif_reg_lock, flags);
>>>> + pch_can_rw_msg_obj(&priv->regs->ifregs[1].creq, tx_obj_no);
>>> Still we have the busy waiting in the TX path. Maybe you can move the
>>> waiting before accessing the if[1] and remove the busy waiting here.
>> I can't understand your saying.
>> For transmitting data, calling pch_can_rw_msg_obj is mandatory.
>Yes, but the busy wait is not needed. It should be enough to do the
>busy-waiting _before_ accessing the if[1].

Do you mean we should create other pch_can_rw_msg_obj which doesn't have busy wait ?

---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
