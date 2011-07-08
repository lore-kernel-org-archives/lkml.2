Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1GHIW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:22:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37903 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab1GHIW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:22:26 -0400
From: "Raju, Sundaram" <sundaram@ti.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Dan <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Jul 2011 13:52:17 +0530
Subject: [RFC] dmaengine: Moving TI SDMA driver to dmaengine - design plan
Thread-Topic: [RFC] dmaengine: Moving TI SDMA driver to dmaengine - design
 plan
Thread-Index: Acw9SCZvPFDynNkITJ+jrLRNAg15bg==
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E94030259CD17@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am planning to move TI SDMA driver in OMAP tree
into the dmaengine framework.

The first immediate issue of concern I noticed is the
huge number of client drivers that use the existing SDMA driver.
More than 15 client drivers are using the current SDMA driver.

Moving the SDMA driver along with all of these client drivers at a
single stretch seems a humungous task. 
I noticed a model in the existing DMA drivers in dmaengine
framework that will over come this issue. 

I would like to follow the Freescale i.MX DMA driver model,
where imx-dma.c in drivers/dma which implements all the
dmaengine hooks, internally uses the APIs in dma-v1.c file in 
arch/arm/mach-imx. All APIs in dma-v1.c are also exported
out for direct use by clients.

Advantages of this model:
1. No compilation breaks for any of the existing client drivers.
2. Client drivers can be moved one by one to the new SDMA driver 
after complete testing on all OMAP boards.

We can mark the old SDMA driver APIs as deprecated and insist on
all client drivers to be moved to the new SDMA driver in the
dmaengine framework soon.

I have made the preliminary changes in code for this design and
I am in the phase of testing a few client drivers. If this is a good way
to proceed then I will send out my patches with the client drivers I
have changed for review once I am done with the testing.

Let me know your thoughts.

Regards,
Sundaram

