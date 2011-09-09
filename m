Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab1IIQYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:24:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:36523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759284Ab1IIQYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:24:48 -0400
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vkoul@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: vinod.koul@intel.com, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CAGsJ_4zaOwHvViuh=nKhvxw3irnE9mXaG_FAKLp_a__XpdXtSA@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	 <438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
	 <CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
	 <438BB0150E931F4B9CE701519A4463010871804A48@bgsmsx502.gar.corp.intel.com>
	 <CAGsJ_4yeovNP=6CKTafbxrBTrYQ42B9yvAOM8gM_bYqD6mTnUw@mail.gmail.com>
	 <CABb+yY1=P=D3GFFxMOUM0a2yWCiAHNqwVU0a--t+pJnUhqKHKA@mail.gmail.com>
	 <CABb+yY3F+DMn2SxeO0chjpiMBkgLvSK5EVYMdhQsfQoZNZ4_7Q@mail.gmail.com>
	 <CAGsJ_4xDh6c5=Uhw9zO34XeY5UNC=fLuRubryks6NOv3T5_kCQ@mail.gmail.com>
	 <1315518676.6638.6.camel@vkoul-mobl4>
	 <CAGsJ_4zQ0H99w4vDkFG2DtA561e0oPjKVgEZb1kBkGab=c-OAw@mail.gmail.com>
	 <CAGsJ_4zaOwHvViuh=nKhvxw3irnE9mXaG_FAKLp_a__XpdXtSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Fri, 09 Sep 2011 21:55:08 +0530
Message-ID: <1315585508.30522.3.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 10:52 +0800, Barry Song wrote:
> >
> > Actually, there is no real case for xlen > dma_width. this picture is
> > only explaining what will happen if we set xlen > dma_width.
> > when xlen > dma_width, for every line, dma will transfer only
> > dma_width. Then the extra data is wrapped around
> > to the next data line, it will corrupt the DMA transfer for
> > multiple-line 2-D DMA since the extra data will overlap with the real
> > next line.
> >
> > if we set ylen to 0, the DMA becomes 1D, the wrap-around of the extra
> > data has no issue nobody will overlap with it.
> >
> 
> For example, if we set xlen = 7, dma_width =4, ylen > 0
> then dma will happen like:
> 0~6
> 4~10
> 8~14
> 12~18
> ....
Is there a real world use case of this??

> 
> But for ylen=0, it has no issue. there is no next line to overlap with
> the extra data.
> 
> in case we set xlen = 0, something funny will happen:
> i will copy the same memory again and again(ylen+1 times).


-- 
~Vinod Koul
Intel Corp.

