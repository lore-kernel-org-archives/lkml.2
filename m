Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab1INFKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 01:10:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:60171 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1INFKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 01:10:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,378,1312182000"; 
   d="scan'208";a="51038515"
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CAJe_ZhdTnRSzfRvnAaCy1M-LpAk0FqjNSXRLnQW2ksOS77A+=w@mail.gmail.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
	 <438BB0150E931F4B9CE701519A4463010871804A46@bgsmsx502.gar.corp.intel.com>
	 <CAGsJ_4x4S+8d3xS+QTrjDpoxcHo3p7qArd7yFr=+h1vxSRvEpA@mail.gmail.com>
	 <438BB0150E931F4B9CE701519A4463010871804A48@bgsmsx502.gar.corp.intel.com>
	 <CAGsJ_4yeovNP=6CKTafbxrBTrYQ42B9yvAOM8gM_bYqD6mTnUw@mail.gmail.com>
	 <CABb+yY1=P=D3GFFxMOUM0a2yWCiAHNqwVU0a--t+pJnUhqKHKA@mail.gmail.com>
	 <CABb+yY3F+DMn2SxeO0chjpiMBkgLvSK5EVYMdhQsfQoZNZ4_7Q@mail.gmail.com>
	 <1315518378.6638.2.camel@vkoul-mobl4>
	 <CAGsJ_4xv9+=+=2b=i47P5V5sOQH-GyTMaESwbeHxu439Vx1gLA@mail.gmail.com>
	 <1315756966.2246.3.camel@vkoul-mobl4>
	 <CAJe_ZhdTnRSzfRvnAaCy1M-LpAk0FqjNSXRLnQW2ksOS77A+=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 10:37:17 +0530
Message-ID: <1315976837.26251.473.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 12:03 +0530, Jassi Brar wrote:
> On 11 September 2011 21:32, Vinod Koul <vkoul@infradead.org> wrote:
> > On Fri, 2011-09-09 at 16:18 +0800, Barry Song wrote:
> 
> >> Jassi prefer to use a transfer type instead of a control command.
> >> though we will not really change the interleaved setting for every
> >> transfer(it is more possible for one device, we will not change the
> >> xlen/ylen/dma_width setting in the whole life period), i do believe
> >> the transfer type is enough flexible for my possible applications to
> >> change xlen, ylen and dma_width in different transfers.
> 
> > Is this usually the assumption or yours is a special case, how about
> > your's Jassi?
> 
> 1) Having type per transfer is more flexible than having to set the type
>      for a channel using a control command. The overhead is negligible
>      because the client reuses the same descriptors with only changed
>      source/destination addresses.
> 2) DMA_SLAVE_CONFIG is meant for slave (Mem<->Dev) channels,
>     whereas it is very likely(for multimedia drives) to have such operations
>     Mem->Mem as well.
> 3) Someday if people realize we can fold many, if not all, transfer types into
>     one, this api has the potential to be the survivor.
> 
> That was where my mind was grazing when I chose to do what I did.
I would agree that it makes sense to have it in API rather than config.


-- 
~Vinod

