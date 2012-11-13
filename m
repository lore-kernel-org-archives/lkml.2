Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2KMTl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:41:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:21483 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab2KMTlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:41:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,768,1352102400"; 
   d="scan'208";a="246495391"
From: "Dave, Tushar N" <tushar.n.dave@intel.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: e1000e on DH55HC stalling and kernel panic in 3.6.6
Thread-Topic: e1000e on DH55HC stalling and kernel panic in 3.6.6
Thread-Index: AQHNwacPGURSxafHL0OJWKnl8W4sf5foKJ0g
Date: Tue, 13 Nov 2012 19:41:52 +0000
Message-ID: <061C8A8601E8EE4CA8D8FD6990CEA8913348A9F7@ORSMSX102.amr.corp.intel.com>
References: <46948b0ae98fcae5d08fd9fe61fd2e47@visp.net.lb>
In-Reply-To: <46948b0ae98fcae5d08fd9fe61fd2e47@visp.net.lb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qADJfwqI017420

>-----Original Message-----
>From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
>On Behalf Of Denys Fedoryshchenko
>Sent: Tuesday, November 13, 2012 5:59 AM
>To: Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Wyborny,
>Carolyn; Skidmore, Donald C; Rose, Gregory V; Waskiewicz Jr, Peter P;
>Duyck, Alexander H; Ronciak, John; e1000-devel@lists.sourceforge.net;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: e1000e on DH55HC stalling and kernel panic in 3.6.6
>
>Hi
>
>I just tried to run latest kernel on my DH55HC motherboard latest kernel
>3.6.6 and got various network problems, such as network traffic are
>stopping, and sometimes i am getting kernel panic.
>When traffic are stopping, ethtool -r eth0 sometimes helps.
>When i do ethtool -G eth0 rx NNN , sometimes it will give kernel panic,
>but it is hard to reproduce.
>
>I tried to capture panic on pictures, so will try to decode on what i got
>photo, it is a nightmare, but sadly i dont have serial in hands to get
>data over it.
>
>skbuff: skb_over_panic: text:f86fc769 len:25807 put:25807 head:c1da1800
>data:c1da1840 tail:0xc1da7d0f end:c1da1f40 dev:eth0 kernel BUG at
>net/core/skbuff.c:127
>opcode: 0000 [#1] SMP
>Pid: 0 comm: swapper/6 Not tained 3.6.6-build-0063 #23
>EIP: 0060:[<c02e7980>] EFLAGS: 00010296 CPU:6 EIP is at skb_put+0x83/0x8e
>
>There is registers and stack, let me know if you need specific fields
>
>Call trace:
>f86fc769 ? e1000_clean_rx_irq+0x1e1/0x2af [e1000e]
>f86fc769 e1000_clean_rx_irq+0x1e1/0x2af [e1000e]
>f86fcc73 e1000e_poll+0x6a/0x209 [e1000e]
>c02f1630 net_rx_action+0x90/0x15d
>c01302d5 __do_softirq+0x8a/-x13b
>c013024b ? local_bh_enable+0xd/0xd
><IRQ>
>c0130504 irq_exit+0x41/0x91
>c0102c37 do_IRQ+0x79/0x8d
>
>There is also more data, let me know if you need it.
Yes, please send us the full dmesg log with error.
Have you tried out-of-tree e1000e driver?

-Tushar
 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
