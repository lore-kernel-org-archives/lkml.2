Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2BFP5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:57:21 -0500
Received: from mxout1.idt.com ([157.165.5.25]:55085 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab2BFP5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:57:20 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: RE: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sg and prep_dma_cyclic
Date: Mon, 6 Feb 2012 07:56:57 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55202872A3B@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1328542134.26182.111.camel@vkoul-udesk3>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sg and prep_dma_cyclic
Thread-Index: Aczk4/TuFafiaKCOT42MXf3EVASeWQAAVkDA
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com> <20120202214350.GB4432@flint.arm.linux.org.uk> <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com> <1328529182.26182.92.camel@vkoul-udesk3> <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com> <1328542134.26182.111.camel@vkoul-udesk3>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: Russell King <rmk@arm.linux.org.uk>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q16FvTJW020387

On Mon, Feb 06, 2012 at 10:29 AM, Vinod Koul wrote:
> 
> On Mon, 2012-02-06 at 07:04 -0800, Bounine, Alexandre wrote:
> > I was thinking about keeping the original scatterlist for dmac
> unchanged,
> > but allocating another scatterlist in rio_dma_prep_slave_sg() and
> chaining
> > two lists together. After it passed to device specific function, it
> parses
> > first section of the chain for additional transfer parameters and use
> > following scatterlist as intended for dmac.
> hmmm, but that wouldn't make it generic for other systems like proposed
> MSM box mode..., right?

Yes, you are right. It is just another way to pass subsystem specific info
while preserving existing DMA API definitions.

> >
> > But Russell's idea (See https://lkml.org/lkml/2012/2/3/269 ) seems to
> be
> > a better way without added complexity and I am ready to take that
> path and
> > make new patches if you and Dan agree with it.
> but it still doesn't fix his concerns for the using void pointer.

At least corresponding inline functions may use specific data types
or hide the new parameter like in Russell's code example. (I believe
he forgot to pass NULL in chan->device->device_prep_slave_sg() as
the new param there).

> 
> If we agree that this is the way, then I was thinking to add arch
> specif
> calls which cast the context pointer to void for passing to dmac. The
> arch specific struct gets defined in dmaengine_arch.h <or something
> similar>. That way clients cant define their own stuff and we continue
> to be generic as well as cater to arch specific requirements.
> 

May we keep arch/subsystem specific calls within a subsystem code?
E.g. I am providing rio_dma_prep_slave_sg() which has an interface defined
in RapidIO terms plus I am filtering for an appropriate dmac. 

Alex.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
