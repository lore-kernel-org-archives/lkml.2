Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2FTE1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 00:27:36 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:49398 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325Ab2FTE1e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 00:27:34 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Federico Vaga <federico.vaga@gmail.com>,
        Giancarlo ASNAGHI <giancarlo.asnaghi@st.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed, 20 Jun 2012 12:27:11 +0800
Subject: RE: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: Ac1OnCUvKtgefNF1QuWMIVF/Bj0XqwAABr4g
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FAA275CA8@EAPEX1MAIL1.st.com>
References: <20120620133348.a9ff31a72ffd11818f574fe3@canb.auug.org.au>
In-Reply-To: <20120620133348.a9ff31a72ffd11818f574fe3@canb.auug.org.au>
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

Hi,

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Wednesday, June 20, 2012 9:04 AM
> To: David Miller; netdev@vger.kernel.org
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Federico
> Vaga; Giancarlo ASNAGHI; Wolfgang Grandegger; Bhupesh SHARMA; Marc
> Kleine-Budde
> Subject: linux-next: build failure after merge of the net-next tree
> 
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "clk_get_rate" [drivers/net/can/c_can/c_can_pci.ko] undefined!
> ERROR: "clk_get" [drivers/net/can/c_can/c_can_pci.ko] undefined!
> ERROR: "clk_put" [drivers/net/can/c_can/c_can_pci.ko] undefined!
> 
> Caused by commit 5b92da0443c2 ("c_can_pci: generic module for
> C_CAN/D_CAN on PCI").  Maybe a missing Kconfig dependency/select?
> 
> I have used the net-next tree from next-20120619 for today.
> --

clk_get/clk_put* variants are usually used by ARM platforms.
Protecting their calls under macro 'CONFIG_HAVE_CLK' should solve the problem.

See [1] for how it is done in c_can_platform.c

Could you possibly add these checks and send a patch for the same?
It should be fairly simple.

[1] http://lxr.linux.no/linux+v3.4.3/drivers/net/can/c_can/c_can_platform.c#L68

Regards,
Bhupesh

