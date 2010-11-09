Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0KIM0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:26:49 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:2263 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013Ab0KIM0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:26:46 -0500
Message-ID: <00fd01cb8009$5efc5fd0$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Oliver Hartkopp" <socketcan@hartkopp.net>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        <andrew.chih.howe.khor@intel.com>, <qi.wang@intel.com>,
        <margie.foster@intel.com>, <yong.y.wang@intel.com>,
        "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>
References: <4CCAA3D4.8070408@dsn.okisemi.com> <4CCAC4CD.7000503@pengutronix.de> <4CCAFA68.2030903@hartkopp.net>
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build warnings
Date: Tue, 9 Nov 2010 21:26:41 +0900
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

Sorry, for late response.
On Saturday, October 30, 2010 1:46 AM,  Oliver Hartkopp wrote:

> 
> It's just a question if the driver for an Intel Chipset should/could ignore
> the endian problematic.
> 
> If this is intended the driver should only appear in Kconfig depending on X86
> or little endian systems.

This driver is for only x86 processor.
I have no intention to support processor except x86.

> 
> Besides this remark, the struct pch_can_regs could also be defined in a way
> that every single CAN payload data byte could be accessed directly to allow
> e.g. this code in pch_can_rx_normal():
> 
> cf->data[0] = ioread8(&priv->regs->if1_data0);
> cf->data[1] = ioread8(&priv->regs->if1_data1);
> cf->data[2] = ioread8(&priv->regs->if1_data2);
> (..)
> cf->data[6] = ioread8(&priv->regs->if1_data6);
> cf->data[7] = ioread8(&priv->regs->if1_data7);
> 
> This is easy to understand and additionally endian aware.

I agree. Thease codes are very simple.
I will modify like above.

> 
> In opposite to this:
> 
> + if (cf->can_dlc > 2) {
> + u32 data1 = *((u16 *)&cf->data[2]);
> + iowrite32(data1, &priv->regs->if2_dataa2);
> + }
> 
> Which puts a little? endian u16 into the big endian register layout.
> Sorry i'm just getting curious on this register access implementation.

I think cf->data is like below
MSB----------LSB
D3-D2-D1-D0
D7-D6-D5-D4

*((u16 *)&cf->data[2]) means "D3-D2".
This order coprresponds to register order.
data register is like below
MSB----------LSB
**-**-D3-D2

** means reserved area.

Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
