Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2B0Tmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:42:46 -0500
Received: from be1ssnxpe1.nxp.com ([57.67.164.69]:49047 "EHLO
	be1ssnxpe1.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2B0Tmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:42:45 -0500
From: Kevin Wells <kevin.wells@nxp.com>
To: Roland Stigge <stigge@antcom.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "eilong@broadcom.com" <eilong@broadcom.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "joe@perches.com" <joe@perches.com>
Date: Mon, 27 Feb 2012 20:42:07 +0100
Subject: RE: [PATCH v3] lpc32xx: Added ethernet driver
Thread-Topic: [PATCH v3] lpc32xx: Added ethernet driver
Thread-Index: Acz1d14Q1r4N28p7Qly9QB9GF7bIgQADjGcA
Message-ID: <083DF309106F364B939360100EC290F81F365B2AE1@eu1rdcrdc1wx030.exi.nxp.com>
References: <1330364539-23152-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1330364539-23152-1-git-send-email-stigge@antcom.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-02-27_04:2012-02-27,2012-02-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This patch adds an ethernet driver for the LPC32xx ARM SoC.
>
>Signed-off-by: Roland Stigge <stigge@antcom.de>
>
>---
> drivers/net/ethernet/Kconfig       |    1 
> drivers/net/ethernet/Makefile      |    1 
> drivers/net/ethernet/nxp/Kconfig   |    8 
> drivers/net/ethernet/nxp/Makefile  |    1 
> drivers/net/ethernet/nxp/lpc_eth.c | 1311 +++++++++++++++++++++++++++++++++++++
> drivers/net/ethernet/nxp/lpc_eth.h |  336 +++++++++
> 6 files changed, 1658 insertions(+)

...

>+#define ENET_MAXF_SIZE 1536
>+#define ENET_RX_DESC 48
>+#define ENET_TX_DESC 16
>+
>+/*
>+ * FIXME
>+ * Dynamic buffer allocation as needed
>+ * Check/fix ethtool support
>+ * Better MAC address support
>+ * Better DMA allocation support (dma pool)
>+ */

Although the packet buffers are handled correctly, the
number of MAC DMA descriptors are hard coded to the
ENET_RX_DESC and ENET_TX_DESC size values. There is
also a 'funky' scheme for doing virt<>phy address
translation for the descriptors.

I'm ok with releasing this driver "as is" with its
current quirks, but I do think these fixmes need to be
fixed at some time.

