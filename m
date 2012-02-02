Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2BBE5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 23:57:22 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42493 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab2BBE5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 23:57:21 -0500
From: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pasupathy, Visuvanadan" <vichu@ti.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: RE: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
Thread-Topic: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
Thread-Index: AczbdSds1n6amVVGTfqCj870KpG3gwBasnSAALx8WYAAAtK0gABiTqQQ
Date: Thu, 2 Feb 2012 04:57:16 +0000
Message-ID: <47CEF8C4B26E8C44B22B028A650E0EA9317D9346@DBDE01.ent.ti.com>
References: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com>
 <4F22CC37.8010307@mvista.com>
 <47CEF8C4B26E8C44B22B028A650E0EA9317D2B9D@DBDE01.ent.ti.com>
 <4F27D011.8060203@mvista.com>
In-Reply-To: <4F27D011.8060203@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> On 31-01-2012 8:41, Gupta, Ajay Kumar wrote:
> 
> >>> As a next step to dma-engine based cppi4.1 driver implementation
> >>> this RFC has the overview of changes in the musb driver.
> >>> RFC on CPPI slave driver changes will follow next.
> 
> >>> Overview of changes in the musb driver
> >>> ======================================
> 
> >>> 1)Add a dma-engine.c file in the drivers/usb/musb folder
> >>> 2)This file will host the current musb dma APIs and translates them
> to
> >>>     dmaengine APIs.
> >>> 3)This will help to keep the changes in drivers/usb/musb/musb* files
> >>>     minimal and also to retain compatibility other DMA (Mentor etc.)
> >>>     drivers which are yet to be moved to drivers/dma
> >>> 4)drivers/usb/musb/dma-engine.c, will wrap the dmaengine APIs to
> >>>     make existing musb APIs compatible.
> >>> 5)drivers/usb/musb/dma-engine.c file will implement the filter
> >>>     functions and also implement .dma_controller_create (allocates
> >>>     &   provides "dma_controller" object) and .dma_controller_delete
> >>> 6)CPPI4.1 DMA specific queue and buffer management will be internal
> >>>     to slave CPPI DMA driver implementation.
> 
> >>      You mean drivers/dma/ driver?
> 
> > yes.
> 
> >> I think you are forgotting that CPPI 4.1 MUSB
> >> has some registers controlling DMA/interrupts beside those of CPPI
> 4.1
> >> controller and MUSB core itself. How do they fit in your scheme?
> 
> > We have been discussing on how to handle these in slave driver and
> 
>     These certainly cannot be handled in the slave driver because the
> registers are different for every controller implementation and, the
> main thing, they don't belong to CPPI 4.1 as such.

Felipe suggested to use device tree for differences in register maps
among different platforms.

I do see issues in reading wrapper interrupt status register and then
calling musb_interrupt() [defined inside musb_core.c] from slave driver.

> 
> > would post our proposal in RFC for slave driver design. Do you have
> > any proposal?
> 
>     I think this will need hooks from dma-engine.c to the glue layers. I
> was going to implement such in my version of MUSB CPPI 4.1 driver (in order
> to also support AM35x) but lacked time.

That would mean a change in current drivers/dma API.
 
Ajay
> 
> > Regards,
> > Ajay
> 
> WBR, Sergei
