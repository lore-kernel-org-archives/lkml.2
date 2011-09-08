Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab1IHHtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 03:49:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47517 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112Ab1IHHtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 03:49:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4xDh6c5=Uhw9zO34XeY5UNC=fLuRubryks6NOv3T5_kCQ@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	<438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
	<CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
	<438BB0150E931F4B9CE701519A4463010871804A48@bgsmsx502.gar.corp.intel.com>
	<CAGsJ_4yeovNP=6CKTafbxrBTrYQ42B9yvAOM8gM_bYqD6mTnUw@mail.gmail.com>
	<CABb+yY1=P=D3GFFxMOUM0a2yWCiAHNqwVU0a--t+pJnUhqKHKA@mail.gmail.com>
	<CABb+yY3F+DMn2SxeO0chjpiMBkgLvSK5EVYMdhQsfQoZNZ4_7Q@mail.gmail.com>
	<CAGsJ_4xDh6c5=Uhw9zO34XeY5UNC=fLuRubryks6NOv3T5_kCQ@mail.gmail.com>
Date: Thu, 8 Sep 2011 13:19:00 +0530
Message-ID: <CABb+yY26KytnyPiQ7BaMsqjKAF9px9XBXixZiJZL1EYZKBQVow@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 12:06 PM, Barry Song <21cnbao@gmail.com> wrote:
> 2011/9/8 Jassi Brar <jassisinghbrar@gmail.com>:
>> According to figures, {xlen > width} is to be set _only_ when a transfer
>> is divided into _exactly_ two chunks separated by gap _exactly_
>> equal to length of the second chunk (an extremely rare case).
>
> Sorry i didn't list related full information in datasheet in my early reply.
> we don't have the case of xlen > dma_width.
Then the dmac driver becomes even simpler.
Accept strictly 'rectangular' requests and reject every other.


>> Anyways, every case can be easily expressed using the generic api
>> I proposed. See 'struct xfer_template' in https://lkml.org/lkml/2011/8/12/128
>
> i think it is the interleaved DMA case and there is a
> inter-chunk-gap(ICG) between every chunk while dma_width > xlen,
> then your new generic API can definitely cover this case.
>
Yup, it does. Thanks for confirming.
