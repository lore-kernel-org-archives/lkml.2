Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1IKP7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 11:59:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:40017 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab1IKP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 11:59:31 -0400
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vkoul@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: vinod.koul@intel.com, Jassi Brar <jassisinghbrar@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CAGsJ_4xDh6c5=Uhw9zO34XeY5UNC=fLuRubryks6NOv3T5_kCQ@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	 <438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
	 <CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
	 <438BB0150E931F4B9CE701519A4463010871804A48@bgsmsx502.gar.corp.intel.com>
	 <CAGsJ_4yeovNP=6CKTafbxrBTrYQ42B9yvAOM8gM_bYqD6mTnUw@mail.gmail.com>
	 <CABb+yY1=P=D3GFFxMOUM0a2yWCiAHNqwVU0a--t+pJnUhqKHKA@mail.gmail.com>
	 <CABb+yY3F+DMn2SxeO0chjpiMBkgLvSK5EVYMdhQsfQoZNZ4_7Q@mail.gmail.com>
	 <CAGsJ_4xDh6c5=Uhw9zO34XeY5UNC=fLuRubryks6NOv3T5_kCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Sun, 11 Sep 2011 21:29:41 +0530
Message-ID: <1315756781.2246.1.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 14:36 +0800, Barry Song wrote:
> 2011/9/8 Jassi Brar <jassisinghbrar@gmail.com>:
> > On Thu, Sep 8, 2011 at 8:47 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> >> On Thu, Sep 8, 2011 at 7:42 AM, Barry Song <21cnbao@gmail.com> wrote:
> >>
> >>>>> it is much different with primacell based DMA like pl080, pl330.
> >>>>> prima2 has a self-defined DMAC IP. basically it is a 2D mode dma with
> >>>>> two scales X and Y and direct way to start and stop DMA.
> >>>>> every channel has fixed function to serve only one perpheral. so you
> >>>>> find we have a filter id.
> >>>> okay, what do you mean by 2D mode? Is it similar to what TI folks, Linus
> >>>> W and Jassi Brar posted RFC's on?
> >>>
> >>> In SiRFprimaII 2-D DMA, the system memory space is interpreted
> >>> as a 2-D layout instead of a linear 1-D layout. More specifically, the
> >>> system memory can be considered as
> >>> multiple data lines. The length of the data line is determined by the
> >>> user-selected DMA_WIDTH register.
> >>> The user can specify a data window that the user wants to access using
> >>> four parameters:
> >>> ■ Start address
> >>> ■ X length
> >>> ■ Y length
> >>> ■ Width
> >>>
> >>> The idea of a 2-D DMA is shown in figure 2d-dma.png attached.
> >>>
> >>> If you specifies the Y length as 0 or the X length equals to the DMA
> >>> width, then this 2-D DMA reduces to
> >>> 1-D. If the user configures the X length greater than the DMA width,
> >>> then the extra data is wrapped around
> >>> to the next data line, this may corrupt the DMA transfer for
> >>> multiple-line 2-D DMA. If this is a 1-D DMA, then
> >>> there is no issue. The attached diagram 2d-dma2.png shows the
> >>> wrap-around of the extra data in case the X length
> >>> greater than DMA width.
> >>
> >> Sorry, the role of DMA_WIDTH is not clear to me yet.
> >> In which case the user _must_ set {xlen > width} ?
> >>
> > Perhaps 2d-dma.PNG is inaccurate - it shouldn't depict any deltaX.
> > Doesn't xlen and width always start together ? If no, please don't read ahead.
> >
> > According to figures, {xlen > width} is to be set _only_ when a transfer
> > is divided into _exactly_ two chunks separated by gap _exactly_
> > equal to length of the second chunk (an extremely rare case).
> 
> Sorry i didn't list related full information in datasheet in my early reply.
> we don't have the case of xlen > dma_width.
But is it theoretically possible or just an error case?? Looks like its
latter, right?

-- 
~Vinod Koul
Intel Corp.

