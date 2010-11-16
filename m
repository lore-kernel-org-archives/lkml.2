Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005Ab0KPIZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 03:25:12 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:35281 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932370Ab0KPIZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 03:25:10 -0500
Message-ID: <001501cb8567$c7a38820$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <andrew.chih.howe.khor@intel.com>,
        <qi.wang@intel.com>, <margie.foster@intel.com>,
        <yong.y.wang@intel.com>, "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>
References: <4CE0EFA7.9020007@dsn.okisemi.com> <4CE141EA.5070702@grandegger.com>
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Add Flow control,
Date: Tue, 16 Nov 2010 17:25:06 +0900
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

On Monday, November 15, 2010 11:21 PM, Wolfgang Grandegger wrote:

> 
> More comments to the lec handling below.
> 
> > + cf->data[6] = ioread32(&priv->regs->errc) & PCH_TEC;
> > + cf->data[7] = (ioread32(&priv->regs->errc) & PCH_REC) >> 8;
> 
> Could be handle with just *one* register access.

I will modify.

>   if (reg_stat & PCH_BUS_OFF ||
>     (reg_stat & PCH_LEC_ALL) != PCH_LEC_ALL) {
> 
> Your lec handling is still not correc, 

I will modify like above.

> I believe. The driver needs to
> write PCH_LEC_ALL to the "stat" register once in the initialization code
This is NOT true.
I heard even if CAN driver detects PCH_LEC_ALL, the driver doesn't have to
write PCH_LEC_ALL to LEC.
"PCH_LEC_ALL" means there is no error event.
In case error is occurred, lec value is updated automatically.


> and then after each error observed (lec != PCH_LEC_ALL). I still do not
> find such code. Could you show us the output of
> 
>   "# candump any,0:0,#FFFFFFFF"
> 
> when yo send CAN messages *without* a cable connected?.


[root@localhost can-utils]# ./candump any,0:0,#FFFFFFFF
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 88 00   ERRORFRAME

......It seems the same line continues forever.

---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
