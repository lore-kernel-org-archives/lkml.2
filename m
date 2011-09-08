Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1IHGhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 02:37:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50403 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1IHGho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 02:37:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4yzxz2rdyN-DDbcUM4BYXwmmDQU2oxX7HVKDtQsESaZfw@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	<438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
	<CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
	<438BB0150E931F4B9CE701519A4463010871804A48@bgsmsx502.gar.corp.intel.com>
	<CAGsJ_4yeovNP=6CKTafbxrBTrYQ42B9yvAOM8gM_bYqD6mTnUw@mail.gmail.com>
	<CABb+yY1=P=D3GFFxMOUM0a2yWCiAHNqwVU0a--t+pJnUhqKHKA@mail.gmail.com>
	<CAGsJ_4yzxz2rdyN-DDbcUM4BYXwmmDQU2oxX7HVKDtQsESaZfw@mail.gmail.com>
Date: Thu, 8 Sep 2011 12:07:43 +0530
Message-ID: <CABb+yY3tJc3eaEV2ZhW6D5S5whr5fWZ-9pY5kOLN_bRLbz5u6w@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 11:44 AM, Barry Song <21cnbao@gmail.com> wrote:
>> Sorry, the role of DMA_WIDTH is not clear to me yet.
>> In which case the user _must_ set {xlen > width} ?
>
> DMA_WIDTH is the size address will increase after every DMA line.
> For example:
> if xlen = 4, dma_width=8, ylen=5;
> Then DMA will run as(suppose DMA address start from 0):
> 0~3
> 8~11
> 16~19
> 24~27
> ...
Ok, so I guessed right.  2d-dma.PNG is indeed inaccurate, unless
there is some separate start-address of the 'width-window' which
you haven't mentioned.

> This feature can help us to do DMA operation to non-continuous memory
> area, for example, pick a part of a image.
That's just a small part of what the proposed api can do.

> The DMA X-length is in the 32-bit D-word boundary. This value
> specifies the number of D-words transferred
> in each line. The value should be less than or equal to the value of
> DMA width register.
>
> The DMA Y-length specifies the number of lines in DMA transfers. The
> number of the lines in DMA transfer
> is Y-length + 1.
>
> Each channel has dedicated DMA Width registers. Each DMA channel
> should not use other channel’s DMA
> width.
> To enable a correct 2-D DMA, the DMA Width register must be correctly
> set. The value of the DMA Width
> register must be greater than or equal to the X-length, otherwise, the
> data is overlapped. DMA_WIDTH
> should not be set to 0.
>
Ok, so what I said in my last post [https://lkml.org/lkml/2011/9/8/10] seems
quite accurate. Maybe you only need to additionally take care of
conversion of sizes between bytes and words.
