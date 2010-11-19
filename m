Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab0KSHhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 02:37:06 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6108 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab0KSHhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 02:37:05 -0500
Message-ID: <00bf01cb87bc$8ed6e300$66f8800a@maildom.okisemi.com>
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
References: <4CE0EFA7.9020007@dsn.okisemi.com> <4CE141EA.5070702@grandegger.com> <001501cb8567$c7a38820$66f8800a@maildom.okisemi.com> <4CE259FB.5090402@grandegger.com>
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Add Flow control,
Date: Fri, 19 Nov 2010 16:36:58 +0900
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

On Tuesday, November 16, 2010 7:16 PM, Wolfgang Grandegger wrote :

> > ......It seems the same line continues forever.
> 
> Yes, it will continue until you connect the cable, that's normal
> behavior. But that's not the full sequence. Could you please repeat the
> test as shown below:
> 
>   First start the following command in a *separate* session.
>   # candump any,0:0,#FFFFFFFF"
> 
>   Then setup and start the CAN controller:
>   # ip link set can0 up type can bitrate 125000
>   # cansend can0 123#deadbeef
> 

I show the result of the above command below,

[root@localhost can-utils]# candump any,0:0,#FFFFFFFF
  can0  20000020  [8] 00 00 00 00 00 00 08 00   ERRORFRAME
  can0  20000020  [8] 00 00 00 00 00 00 10 00   ERRORFRAME
  can0  20000020  [8] 00 00 00 00 00 00 18 00   ERRORFRAME
  can0  20000020  [8] 00 00 00 00 00 00 20 00   ERRORFRAME
  can0  20000020  [8] 00 00 00 00 00 00 28 00   ERRORFRAME
  can0  20000020  [8] 00 00 00 00 00 00 30 00   ERRORFRAME
  can0  20000020  [8] 00 00 00 00 00 00 38 00   ERRORFRAME
  can0  20000020  [8] 00 00 00 00 00 00 40 00   ERRORFRAME
  can0  20000020  [8] 00 00 00 00 00 00 48 00   ERRORFRAME
  can0  20000020  [8] 00 00 00 00 00 00 50 00   ERRORFRAME
  can0  20000020  [8] 00 00 00 00 00 00 58 00   ERRORFRAME
  can0  20000024  [8] 00 00 00 00 00 00 60 00   ERRORFRAME
  can0  20000024  [8] 00 08 00 00 00 00 68 00   ERRORFRAME
  can0  20000024  [8] 00 08 00 00 00 00 70 00   ERRORFRAME
  can0  20000024  [8] 00 08 00 00 00 00 78 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
  can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME

.....continue forever

------
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

