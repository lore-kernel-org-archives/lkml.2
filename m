Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab2BGODY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:03:24 -0500
Received: from mxout1.idt.com ([157.165.5.25]:55054 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab2BGODX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:03:23 -0500
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: RE: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sgand prep_dma_cyclic
Date: Tue, 7 Feb 2012 06:01:23 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552028C2A5D@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1328585993.26182.143.camel@vkoul-udesk3>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 01/11] dmaengine: add context parameter toprep_slave_sgand prep_dma_cyclic
Thread-Index: AczlSgyiyvhqyW/cSTSwYUVZFrzQ5gAVNpiw
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com> <20120202214350.GB4432@flint.arm.linux.org.uk> <0CE8B6BE3C4AD74AB97D9D29BD24E55202872683@CORPEXCH1.na.ads.idt.com> <1328529182.26182.92.camel@vkoul-udesk3> <0CE8B6BE3C4AD74AB97D9D29BD24E552028729F9@CORPEXCH1.na.ads.idt.com> <1328542134.26182.111.camel@vkoul-udesk3> <20120206155318.GA20852@flint.arm.linux.org.uk> <0CE8B6BE3C4AD74AB97D9D29BD24E55202872AB1@CORPEXCH1.na.ads.idt.com> <1328551625.26182.139.camel@vkoul-udesk3> <0CE8B6BE3C4AD74AB97D9D29BD24E55202872B3D@CORPEXCH1.na.ads.idt.com> <1328585993.26182.143.camel@vkoul-udesk3>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q17E3Ynq028641

On Mon, Feb 06, 2012 at 10:40 PM, Vinod Koul wrote:
> 
> On Mon, 2012-02-06 at 10:45 -0800, Bounine, Alexandre wrote:
> > On Mon, Feb 06, 2012 at 1:07 PM, Vinod Koul wrote:
> > >
> > > On Mon, 2012-02-06 at 09:02 -0800, Bounine, Alexandre wrote:
> > > >
> > > > What if we introduce another dma_transaction_type like
> DMA_SLAVE_EXT
> > > > (extended?).
> > > > In this case all devices that adhere to the generic SLAVE
> interface
> > > > still be
> > > > registered as DMA_SLAVE and those that do not follow generic
> route
> > > use
> > > > DMA_SLAVE_EXT.
> > > that way it would be channel specific not transaction specific as
> you
> > > had asked for...?
> > >
> > > Again, how does this solve problem of passing parameters while
> > > preventing abuse...
> >
> > This gives a channel-specific treatment to the parameter. Channels
> registered
> > as DMA_SLAVE never expect an extra parameter (BUG_ON if the pointer
> is not NULL).
> > In the generic use scenario described by Russell clients are safe to
> request
> > any such channel without an additional HW knowledge (as it is now).
> >
> > Channels registered as DMA_SLAVE_EXT will accept a pointer to
> parameter structure.
> > This, combined with configuration specific wrappers as you described
> > in earlier e-mail with #ifdef CONFIG_RAPIDIO, should ensure that
> there is no
> > unexpected treatment of (void *) parameter. Also for channels
> registered
> > as DMA_SLAVE_EXT a corresponding filter routine must be provided.
> Okay this sounds better :)
> Sorry I didnt quite get the last line about filter routine?
> 
Currently function private_candidate() allows filtering function
not to be specified and therefore skip the filter check.
It may be a good safety measure to ensure that channels specified
as DMA_SLAVE_EXT provide a corresponding filter routine so they
positively identify dma channel that will accept intended extra parameter.
I assume that a system may have more than one dmac registered as DMA_SLAVE_EXT. 

This is what I have for RapidIO - the filter call ensures that DMA
channel is associated with a RapidIO controller that provides access
to the specified SRIO device.


Alex.
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
