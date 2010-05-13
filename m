Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab0EMXjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:39:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44499 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab0EMXjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:39:43 -0400
From: "Arce, Abraham" <x0066660@ti.com>
To: "Ha, Tristram" <Tristram.Ha@micrel.com>, Ben Dooks <ben@simtec.co.uk>
CC: David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Jan, Sebastien" <s-jan@ti.com>
Date: Thu, 13 May 2010 18:39:35 -0500
Subject: RE: [PATCH 2.6.34-rc6] net: Improve ks8851 snl transmit performance
Thread-Topic: [PATCH 2.6.34-rc6] net: Improve ks8851 snl transmit performance
Thread-Index: AcrtboWeBzoU+Bp2RryGc5lv2EoDowAL251AAS+WXTEAI50MYA==
Message-ID: <27F9C60D11D683428E133F85D2BB4A53043E113D4C@dlee03.ent.ti.com>
References: <14385191E87B904DBD836449AA30269D021A64@MORGANITE.micrel.com>
 <27F9C60D11D683428E133F85D2BB4A53043DF7779A@dlee03.ent.ti.com>
 <14385191E87B904DBD836449AA30269D021A66@MORGANITE.micrel.com>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A66@MORGANITE.micrel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tristram,

> The latest nuttcp default size for UDP is 1500 bytes, rather than 8192 bytes.
> In my case, the transmit performance improves from 10 Mbps to 11.  Have you
> tried TCP?
> 

Not yet... one point to highlight before:

  - SPI controller clock rate is 24 MHz, unable to set ~40 MHz, 

Now testing in 2.6.34 rc7 using now TCP, nuttcp version 6.1.2:

Before the patch

  # /testsuites/ethernet/bin/nuttcp -i -Ri50m 10.87.231.229
      1.1460 MB /   1.00 sec =    9.6134 Mbps
      1.1858 MB /   1.00 sec =    9.9473 Mbps
      1.2258 MB /   1.00 sec =   10.2828 Mbps
      1.1996 MB /   1.00 sec =   10.0628 Mbps
      1.2203 MB /   1.00 sec =   10.2365 Mbps
      1.2258 MB /   1.00 sec =   10.2828 Mbps
      1.2134 MB /   1.00 sec =   10.1786 Mbps
      1.2235 MB /   1.00 sec =   10.2636 Mbps
      1.2134 MB /   1.00 sec =   10.1785 Mbps
      1.2120 MB /   1.00 sec =   10.1670 Mbps

     12.6250 MB /  10.46 sec =   10.1240 Mbps 2 %TX 0 %RX 0 retrans 7.91 msRTT

  # /testsuites/ethernet/bin/nuttcp 10.87.231.229
     12.9319 MB /  10.58 sec =   10.2553 Mbps 1 %TX 0 %RX 0 retrans 7.90 msRTT

After the patch

  # /testsuites/ethernet/bin/nuttcp -i -Ri50m 10.87.231.229
      1.1671 MB /   1.00 sec =    9.7902 Mbps
      1.2169 MB /   1.00 sec =   10.2077 Mbps
      1.2175 MB /   1.00 sec =   10.2134 Mbps
      1.2396 MB /   1.00 sec =   10.3986 Mbps
      1.2396 MB /   1.00 sec =   10.3987 Mbps
      1.2387 MB /   1.00 sec =   10.3910 Mbps
      1.2410 MB /   1.00 sec =   10.4102 Mbps
      1.2203 MB /   1.00 sec =   10.2365 Mbps
      1.2382 MB /   1.00 sec =   10.3871 Mbps
      1.2369 MB /   1.00 sec =   10.3755 Mbps

     12.8125 MB /  10.45 sec =   10.2820 Mbps 2 %TX 0 %RX 0 retrans 7.90 msRTT

  # /testsuites/ethernet/bin/nuttcp 10.87.231.229
     13.0808 MB /  10.64 sec =   10.3123 Mbps 1 %TX 0 %RX 0 retrans 7.90 msRTT

Best Regards
Abraham

