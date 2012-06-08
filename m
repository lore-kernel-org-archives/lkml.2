Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382Ab2FHPiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:38:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:56224 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781Ab2FHPiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:38:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="154924214"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "rkagan@parallels.com" <rkagan@parallels.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: e1000e, 3.4.1, , jumbo frames are not working
Thread-Topic: e1000e, 3.4.1, , jumbo frames are not working
Thread-Index: AQHNRYdJai/bSkJdGUuKEJvmW+Mo6ZbwjfRQ
Date: Fri, 8 Jun 2012 15:38:14 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18428448AE0@ORSMSX102.amr.corp.intel.com>
References: <87ed034d58606650514bdd3b88b0b002@visp.net.lb>
In-Reply-To: <87ed034d58606650514bdd3b88b0b002@visp.net.lb>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q58FcNfC027093

> -----Original Message-----
> From: Denys Fedoryshchenko [mailto:denys@visp.net.lb]
> Sent: Friday, June 08, 2012 7:59 AM
> To: Kirsher, Jeffrey T; rkagan@parallels.com; stable@vger.kernel.org;
> Brandeburg, Jesse; Allan, Bruce W; Wyborny, Carolyn; Skidmore, Donald
> C; Rose, Gregory V; Waskiewicz Jr, Peter P; Duyck, Alexander H;
> Ronciak, John; dnelson@redhat.com; e1000-devel@lists.sourceforge.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: e1000e, 3.4.1, , jumbo frames are not working
> 
> Just tried to enable larger mtu on interface, and failed, even i try
> to
> disable both of mentioned in dmesg offloads.
> 
> 05:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit
> Ethernet Controller (Copper) (rev 01)
> 05:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit
> Ethernet Controller (Copper) (rev 01)
> 
> L2TP ~ # ethtool -i eth0
> driver: e1000e
> version: 1.9.5-k
> firmware-version: 1.0-0
> bus-info: 0000:05:00.0
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> 
> Here is what i did:
> ifconfig eth1 mtu 2000
> got dmesg:
> [ 9160.679354] e1000e 0000:05:00.0: eth0: Jumbo frames cannot be
> enabled when both receive checksum offload and receive hashing are
> enabled.  Disable one of the receive offload features before enabling
> jumbos.
> 
> ethtool -K eth1 rxhash off
> dmesg:
> [ 9194.208856] e1000e 0000:05:00.1: eth1: Reset adapter
> [ 9197.295425] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow
> Control: None
> 
> Lost connectivity for few seconds, then again i tried to:
> ifconfig eth1 mtu 2000
> 
> dmesg:
> [ 9207.797616] e1000e 0000:05:00.0: eth0: Jumbo frames cannot be
> enabled when both receive checksum offload and receive hashing are
> enabled.  Disable one of the receive offload features before enabling
> jumbos.
> 
> ethtool -K eth1 rx off
> [ 9222.398034] e1000e 0000:05:00.1: eth1: Reset adapter
> [ 9225.497550] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow
> Control: None
> 
> Again, tried: ifconfig eth1 mtu 2000
> dmesg:
> [ 9254.795445] e1000e 0000:05:00.0: eth0: Jumbo frames cannot be
> enabled when both receive checksum offload and receive hashing are
> enabled.  Disable one of the receive offload features before enabling
> jumbos.
> 
> L2TP ~ # ethtool -k eth1
> Offload parameters for eth1:
> rx-checksumming: off
> tx-checksumming: on
> scatter-gather: on
> tcp-segmentation-offload: on
> udp-fragmentation-offload: off
> generic-segmentation-offload: on
> generic-receive-offload: on
> large-receive-offload: off
> rx-vlan-offload: on
> tx-vlan-offload: on
> ntuple-filters: off
> receive-hashing: off
> 
> L2TP ~ # ethtool -d eth1
> MAC Registers
> -------------
> 0x00000: CTRL (Device control register)  0x40144241
>        Endian mode (buffers):             little
>        Link reset:                        normal
>        Set link up:                       1
>        Invert Loss-Of-Signal:             no
>        Receive flow control:              disabled
>        Transmit flow control:             disabled
>        VLAN mode:                         enabled
>        Auto speed detect:                 disabled
>        Speed select:                      1000Mb/s
>        Force speed:                       no
>        Force duplex:                      no
> 0x00008: STATUS (Device status register) 0x02080787
>        Duplex:                            full
>        Link up:                           link config
>        TBI mode:                          disabled
>        Link speed:                        1000Mb/s
>        Bus type:                          PCI Express
>        Port number:                       1
> 0x00100: RCTL (Receive control register) 0x04008002
>        Receiver:                          enabled
>        Store bad packets:                 disabled
>        Unicast promiscuous:               disabled
>        Multicast promiscuous:             disabled
>        Long packet:                       disabled
>        Descriptor minimum threshold size: 1/2
>        Broadcast accept mode:             accept
>        VLAN filter:                       disabled
>        Canonical form indicator:          disabled
>        Discard pause frames:              filtered
>        Pass MAC control frames:           don't pass
>        Receive buffer size:               2048
> 0x02808: RDLEN (Receive desc length)     0x00001000
> 0x02810: RDH   (Receive desc head)       0x00000046
> 0x02818: RDT   (Receive desc tail)       0x00000040
> 0x02820: RDTR  (Receive delay timer)     0x00000020
> 0x00400: TCTL (Transmit ctrl register)   0x3103F0FA
>        Transmitter:                       enabled
>        Pad short packets:                 enabled
>        Software XOFF Transmission:        disabled
>        Re-transmit on late collision:     enabled
> 0x03808: TDLEN (Transmit desc length)    0x00001000
> 0x03810: TDH   (Transmit desc head)      0x00000098
> 0x03818: TDT   (Transmit desc tail)      0x00000099
> 0x03820: TIDV  (Transmit delay timer)    0x00000008
> PHY type:                                unknown
> 
> 
> ---
> Denys Fedoryshchenko, Network Engineer, Virtual ISP S.A.L.

Thanks for the report.  We are aware of the issue and have already begun
working on a patch to resolve the issue.

Bruce.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
