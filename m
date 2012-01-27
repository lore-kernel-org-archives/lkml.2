Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2A0PKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:10:01 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45583 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2A0PKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:10:00 -0500
Message-ID: <4F22CC37.8010307@mvista.com>
Date: Fri, 27 Jan 2012 19:09:27 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pasupathy, Visuvanadan" <vichu@ti.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
References: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com>
In-Reply-To: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/25/2012 06:22 PM, Gupta, Ajay Kumar wrote:

> As a next step to dma-engine based cppi4.1 driver implementation
> this RFC has the overview of changes in the musb driver.
> RFC on CPPI slave driver changes will follow next.

> Overview of changes in the musb driver
> ======================================

> 1)Add a dma-engine.c file in the drivers/usb/musb folder
> 2)This file will host the current musb dma APIs and translates them to
>    dmaengine APIs.
> 3)This will help to keep the changes in drivers/usb/musb/musb* files
>    minimal and also to retain compatibility other DMA (Mentor etc.)
>    drivers which are yet to be moved to drivers/dma
> 4)drivers/usb/musb/dma-engine.c, will wrap the dmaengine APIs to
>    make existing musb APIs compatible.
> 5)drivers/usb/musb/dma-engine.c file will implement the filter
>    functions and also implement .dma_controller_create (allocates
>    &  provides "dma_controller" object) and .dma_controller_delete
> 6)CPPI4.1 DMA specific queue and buffer management will be internal
>    to slave CPPI DMA driver implementation.

    You mean drivers/dma/ driver? I think you are forgotting that CPPI 4.1 MUSB 
has some registers controlling DMA/interrupts beside those of CPPI 4.1 
controller and MUSB core itself. How do they fit in your scheme?

WBR, Sergei
