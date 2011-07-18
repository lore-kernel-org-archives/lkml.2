Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1GRHw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 03:52:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60454 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab1GRHwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 03:52:25 -0400
From: "Raju, Sundaram" <sundaram@ti.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 18 Jul 2011 13:21:58 +0530
Subject: RE: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride
 configuration
Thread-Topic: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride
 configuration
Thread-Index: AcxAkZNQeCganO0bQ/WRSoddqS+hOAEjTojw
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E9403026FE695@dbde02.ent.ti.com>
References: <1310310203-12288-1-git-send-email-sundaram@ti.com>
	<CABb+yY1HJOR+QzmM4-ju4cs+8keoyUbMv+SpVoM6BW=DCMzmQQ@mail.gmail.com>
	<CACRpkdbLg0+_2kpi4NizFj0fDWb6QPtkcKirKgoH+83vGD0O0A@mail.gmail.com>
	<CABb+yY1RqHJ6jsMB2RqPNnBLff-bzhwaXG1U-hCD8CpME+a3aA@mail.gmail.com>
	<E0D41E29EB0DAC4E9F3FF173962E9E94030259DBBE@dbde02.ent.ti.com>
 <CABb+yY1_vuM7NGxV4o103YmYfte09XKpaXnYARcn3jjnChiBsQ@mail.gmail.com>
In-Reply-To: <CABb+yY1_vuM7NGxV4o103YmYfte09XKpaXnYARcn3jjnChiBsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6I7qZ71002588

> -----Original Message-----
> From: Jassi Brar [mailto:jassisinghbrar@gmail.com]
> Sent: Tuesday, July 12, 2011 6:15 PM
> To: Raju, Sundaram
> Cc: Linus Walleij; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; davinci-linux-open-source@linux.davincidsp.com;
> linux@arm.linux.org.uk; dan.j.williams@intel.com; linux-omap@vger.kernel.org
> Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride
> configuration
> 
> On Tue, Jul 12, 2011 at 5:01 PM, Raju, Sundaram <sundaram@ti.com> wrote:
> >> -----Original Message-----
> >> From: Jassi Brar [mailto:jassisinghbrar@gmail.com]
> >> Sent: Tuesday, July 12, 2011 4:51 PM
> >> To: Linus Walleij
> >> Cc: Raju, Sundaram; linux-arm-kernel@lists.infradead.org; linux-
> >> kernel@vger.kernel.org; davinci-linux-open-source@linux.davincidsp.com;
> >> linux@arm.linux.org.uk; dan.j.williams@intel.com; linux-
> omap@vger.kernel.org
> >> Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride
> >> configuration
> >>
> >> On Tue, Jul 12, 2011 at 3:33 PM, Linus Walleij <linus.walleij@linaro.org>
> >> wrote:
> >> > On Tue, Jul 12, 2011 at 6:17 AM, Jassi Brar <jassisinghbrar@gmail.com>
> >> wrote:
> >> >
> >> >> 1) Striding, in one form or other, is supported by other DMACs as well.
> >> >> Â  The number will only increase in future.
> >> >> Â  Are we to add Â <VENDOR>_DMA_STRIDE_CONFIG for each case ?
> >> >
> >> > If we are sure about this and striding will work in a similar way on all
> >> > then let's have the enum named DMA_STRIDE_CONFIG and move the
> >> > passed-in struct to <linux/dmaengine.h) then?
> >> >
> >> > Would that be:
> >> >
> >> > struct dma_stride_config {
> >> > Â  Â u32 read_bytes;
> >> > Â  Â u32 skip_bytes;
> >> > };
> >> >
> >> > Or something more complex?
> >> Well, I am not sure if striding needs any special treatment at all.
> >> Why not have client drivers prepare and submit sg-list.
> >> Let the DMAC drivers interpret/parse the sg-list and program it
> >> as strides if the h/w supports it.
> >> If anything, we should make preparation and submission of sg-list
> >> as efficient as possible.
> > Jassi,
> >
> > sg_lists describe only a bunch of disjoint buffers. But what if the
> > DMAC can skip and read the bytes within each of the buffers in
> > the sg_list? (like TI EDMAC and TI SDMAC)
> > How can that information be passed to the offload
> > engine driver from the client?
> >
> OK, I overlooked.
> We do need something new to handle these ultra-fine-grained sg-lists.
> But still we shouldn't add SoC specific API to the common sub-systems.
> 
> Maybe a new api to pass fixed-format variable-length encoded message
> to the DMAC drivers?
> Which could be interpreted by DMAC drivers to extract all the needed xfer
> parameters from the 'header' section and instructions to program the xfers
> in the DMAC from the variable length body of the 'message' buffer.
> It might sound complicated but we can have helpers to make the job easy.
> Btw, the regular single/sg-list xfers could also be expressed by this method.

Do you expect this variable length body of the message to be DMAC
independent? I don't think so. In that case how is this different from what
we have here already?

If it can be DMAC independent, can you illustrate more on how this can
be done? But the point to note is, if this can be made DMAC independent
then the control command we have also can be made DMAC independent
by generalizing the configuration structure passed to it.

~ Sundaram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
