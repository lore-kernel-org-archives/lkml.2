Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0KXAJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:09:22 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:32498 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833Ab0KXAJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:09:21 -0500
Message-ID: <000b01cb8b6b$d7542a90$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: <andrew.chih.howe.khor@intel.com>, <socketcan-core@lists.berlios.de>,
        "Samuel Ortiz" <sameo@linux.intel.com>, <margie.foster@intel.com>,
        <netdev@vger.kernel.org>, "Christian Pellegrin" <chripell@fsfe.org>,
        <linux-kernel@vger.kernel.org>, <yong.y.wang@intel.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Wolfgang Grandegger" <wg@grandegger.com>, <qi.wang@intel.com>
References: <4CE2434B.5050701@dsn.okisemi.com>	<4CE27796.2000206@pengutronix.de>	<007401cb87b1$a773b3d0$66f8800a@maildom.okisemi.com>	<4CE64167.2030405@pengutronix.de> <003201cb8a02$f05b15e0$66f8800a@maildom.okisemi.com> <4CEA2986.4080607@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 v3] can: Topcliff: PCH_CAN driver: Add Flow control,
Date: Wed, 24 Nov 2010 09:09:16 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
x-mimeole: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 22, 2010 5:27 PM, Marc Kleine-Budde wrote:
>>>>> Still we have the busy waiting in the TX path. Maybe you can move the
>>>>> waiting before accessing the if[1] and remove the busy waiting here.
>>>> I can't understand your saying.
>>>> For transmitting data, calling pch_can_rw_msg_obj is mandatory.
>>> Yes, but the busy wait is not needed. It should be enough to do the
>>> busy-waiting _before_ accessing the if[1].
>>
>> Do you mean we should create other pch_can_rw_msg_obj which doesn't have busy wait ?
>ACK, and this non busy waiting is use in the TX path. But you add a busy
>wait only function before accessing the if[1] in the TX path.

The "busy waiting" of pch_can_rw_msg_obj is for next processing accesses to Message object.
If deleting this busy waiting, next processing can access to Message object, regardless previous transfer doesn't
complete yet.
Thus, I think, the "busy waiting" is necessary.

---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

----- Original Message ----- 
From: "Marc Kleine-Budde" <mkl@pengutronix.de>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
Cc: <andrew.chih.howe.khor@intel.com>; <socketcan-core@lists.berlios.de>; "Samuel Ortiz" <sameo@linux.intel.com>;
<margie.foster@intel.com>; <netdev@vger.kernel.org>; "Christian Pellegrin" <chripell@fsfe.org>;
<linux-kernel@vger.kernel.org>; <yong.y.wang@intel.com>; "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>;
<kok.howg.ewe@intel.com>; <joel.clark@intel.com>; "David S. Miller" <davem@davemloft.net>; "Wolfgang Grandegger"
<wg@grandegger.com>; <qi.wang@intel.com>
Sent: Monday, November 22, 2010 5:27 PM
Subject: Re: [PATCH net-next-2.6 v3] can: Topcliff: PCH_CAN driver: Add Flow control,


