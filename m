Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1JQPLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:11:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1JQPLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:11:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] dmaengine: add CSR SiRFprimaII DMAC driver
Date: Mon, 17 Oct 2011 17:11:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Barry Song <21cnbao@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        Barry Song <Barry.Song@csr.com>
References: <1318844199-19303-1-git-send-email-Barry.Song@csr.com> <1318859861.23438.137.camel@vkoul-udesk3> <CAGsJ_4y4ZxqmefxXS+2QEtTcq6Jr9+o92pd4enRYQMkG3kZ=ng@mail.gmail.com>
In-Reply-To: <CAGsJ_4y4ZxqmefxXS+2QEtTcq6Jr9+o92pd4enRYQMkG3kZ=ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110171711.07384.arnd@arndb.de>
X-Provags-ID: V02:K0:jrNLJLbFDc+a5iI9lQb6rlyn0SCECTx3BsoITVXvzX1
 vblq3VL6z5tZWtwJ/5ecjOAGKcf6evqLj9NPO34+X88UdId7Yp
 49uHeXqkLd5V7Qnhqf5yuT4SUoElOLwtKGwq4y/iN14JLorKKk
 o4AjnKtA4xer2QKsP6vDszsS30X0Kpc5Pyzn4uyJpw+3lwwJg/
 +KI4kbORnW7hXA06X1DAZuJhC/6kMoMncxd5u3Li75sey78WF/
 FN4RxOeHN26mgsKnt/CSd6Ub/ljnGKYqNYLVFxbk2FPTEphfsv
 +Low7Byl2zfdwVHyfMJSkhqcq5Vju8s1xyjo1jWe6h2cCZ9tR9
 kONQoynw2q4wfZTDD2pg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 October 2011, Barry Song wrote:
> >> +
> >> +     /* Start the DMA transfer */
> >> +     writel_relaxed(sdesc->width, sdma->base + SIRFSOC_DMA_WIDTH_0 + cid * 4);
> >> +     writel_relaxed(cid | (schan->mode << SIRFSOC_DMA_MODE_CTRL_BIT) |
> >> +             (sdesc->dir << SIRFSOC_DMA_DIR_CTRL_BIT),
> >> +             sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_CTRL);
> >> +     writel_relaxed(sdesc->xlen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_XLEN);
> >> +     writel_relaxed(sdesc->ylen, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_YLEN);
> >> +     writel_relaxed(readl_relaxed(sdma->base + SIRFSOC_DMA_INT_EN) | (1 << cid),
> >> +             sdma->base + SIRFSOC_DMA_INT_EN);
> >> +     writel(sdesc->addr >> 2, sdma->base + cid * 0x10 + SIRFSOC_DMA_CH_ADDR);
> >> +
> >> +     if (sdesc->cyclic) {
> >> +             writel((1 << cid) | 1 << (cid + 16) |
> >> +                     readl_relaxed(sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL),
> >> +                     sdma->base + SIRFSOC_DMA_CH_LOOP_CTRL);
> >> +             schan->happened_cyclic = schan->completed_cyclic = 0;
> >> +     }
> > any reason why we have mixed use of writel_relaxes and writel?
> > Shouldn't all the DMA register writes be done only using writel?
> 
> Arnd comment this in v2.

The new version looks good to me, but a comment in the source code would
be very helpful, especially to prevent people from attempting to "fix" it
in the future.

I'm not sure about the writel/readl_relaxed in the end of that function,
because I don't understand what having a "cyclic" descriptor means.

	Arnd
