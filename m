Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943Ab0KVFUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 00:20:25 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:39814 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779Ab0KVFUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 00:20:23 -0500
Message-ID: <006801cb8a04$f60f4810$66f8800a@maildom.okisemi.com>
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
References: <4CE0EFA7.9020007@dsn.okisemi.com> <4CE141EA.5070702@grandegger.com> <001501cb8567$c7a38820$66f8800a@maildom.okisemi.com> <4CE259FB.5090402@grandegger.com> <00bf01cb87bc$8ed6e300$66f8800a@maildom.okisemi.com> <4CE63C05.6060101@grandegger.com>
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Add Flow control,
Date: Mon, 22 Nov 2010 14:20:19 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010 5:57 PM,  wrote :
> Could you please do the same testing while triggering a bus-off? After
> the test, the output of "ip -d -s link" would be interesting as well.

I show the result below.

[root@localhost can]# ip -d -s link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    RX: bytes  packets  errors  dropped overrun mcast
    2280       40       0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    2280       40       0       0       0       0
2: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 00:40:26:c0:8a:31 brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    10119825   10809    0       0       0       664
    TX: bytes  packets  errors  dropped carrier collsns
    979543     6434     0       0       0       0
3: pan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN
    link/ether de:02:85:50:76:f6 brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast
    0          0        0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    0          0        0       0       0       0
8: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN qlen 10
    link/can
    can state ERROR-PASSIVE restart-ms 0
    bitrate 125000 sample-point 0.875
    tq 500 prop-seg 6 phase-seg1 7 phase-seg2 2 sjw 1
    pch_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..1024 brp-inc 1
    clock 50000000
    re-started bus-errors arbit-lost error-warn error-pass bus-off
    0          156295     0          156284     156280     0
    RX: bytes  packets  errors  dropped overrun mcast
    1250360    156295   156295  0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    0          0        0       0       0       0
[root@localhost can]#


------
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

----- Original Message ----- 
From: "Wolfgang Grandegger" <wg@grandegger.com>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
Cc: "David S. Miller" <davem@davemloft.net>; "Wolfram Sang" <w.sang@pengutronix.de>; "Christian Pellegrin"
<chripell@fsfe.org>; "Barry Song" <21cnbao@gmail.com>; "Samuel Ortiz" <sameo@linux.intel.com>;
<socketcan-core@lists.berlios.de>; <netdev@vger.kernel.org>; <linux-kernel@vger.kernel.org>;
<andrew.chih.howe.khor@intel.com>; <qi.wang@intel.com>; <margie.foster@intel.com>; <yong.y.wang@intel.com>; "Masayuki
Ohtake" <masa-korg@dsn.okisemi.com>; <kok.howg.ewe@intel.com>; <joel.clark@intel.com>
Sent: Friday, November 19, 2010 5:57 PM
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Add Flow control,


> Hi Tomoya,
>
> On 11/19/2010 08:36 AM, Tomoya MORINAGA wrote:
> > On Tuesday, November 16, 2010 7:16 PM, Wolfgang Grandegger wrote :
> >
> >>> ......It seems the same line continues forever.
> >>
> >> Yes, it will continue until you connect the cable, that's normal
> >> behavior. But that's not the full sequence. Could you please repeat the
> >> test as shown below:
> >>
> >>   First start the following command in a *separate* session.
> >>   # candump any,0:0,#FFFFFFFF"
> >>
> >>   Then setup and start the CAN controller:
> >>   # ip link set can0 up type can bitrate 125000
> >>   # cansend can0 123#deadbeef
> >>
> >
> > I show the result of the above command below,
> >
> > [root@localhost can-utils]# candump any,0:0,#FFFFFFFF
> >   can0  20000020  [8] 00 00 00 00 00 00 08 00   ERRORFRAME
> >   can0  20000020  [8] 00 00 00 00 00 00 10 00   ERRORFRAME
> >   can0  20000020  [8] 00 00 00 00 00 00 18 00   ERRORFRAME
> >   can0  20000020  [8] 00 00 00 00 00 00 20 00   ERRORFRAME
> >   can0  20000020  [8] 00 00 00 00 00 00 28 00   ERRORFRAME
> >   can0  20000020  [8] 00 00 00 00 00 00 30 00   ERRORFRAME
> >   can0  20000020  [8] 00 00 00 00 00 00 38 00   ERRORFRAME
> >   can0  20000020  [8] 00 00 00 00 00 00 40 00   ERRORFRAME
> >   can0  20000020  [8] 00 00 00 00 00 00 48 00   ERRORFRAME
> >   can0  20000020  [8] 00 00 00 00 00 00 50 00   ERRORFRAME
> >   can0  20000020  [8] 00 00 00 00 00 00 58 00   ERRORFRAME
>
> The above lines describe bus errors. Therefore it should be
>
>     can0  20000088  [8] 00 00 80 19 00 00 58 00   ERRORFRAME
>
> >   can0  20000024  [8] 00 00 00 00 00 00 60 00   ERRORFRAME
>
> The TX error counter has reached 96 signaling a can error state change
> to "error warning".
>
> >   can0  20000024  [8] 00 08 00 00 00 00 68 00   ERRORFRAME
>
> CAN_ERR_CRTL in the id and CAN_ERR_CRTL_TX_WARNING in data[1], but ...
>
> >   can0  20000024  [8] 00 08 00 00 00 00 70 00   ERRORFRAME
>
> the state change should be signaled only *once*.
>
> >   can0  20000024  [8] 00 08 00 00 00 00 78 00   ERRORFRAME
> >   can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
>
> "Error passive" state is reached and CAN_ERR_CRTL_TX_PASSIVE sould be
> set in data[1], but CAN_ERR_CRTL_TX_WARNING should be removed.
>
> >   can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
> >   can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
> >   can0  20000024  [8] 00 28 00 00 00 00 80 00   ERRORFRAME
>
> Sounds magic, well, I'm going to prepare a patch as soon as your pending
> patch series is applied.
>
> Could you please do the same testing while triggering a bus-off? After
> the test, the output of "ip -d -s link" would be interesting as well.
>
> Thanks,
>
> Wolfgang.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

