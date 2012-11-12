Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2KLKil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 05:38:41 -0500
Received: from londo.lunn.ch ([80.238.139.98]:51225 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2KLKik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 05:38:40 -0500
Date: Mon, 12 Nov 2012 11:38:20 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Soeren Moch <smoch@web.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Message-ID: <20121112103820.GX22029@lunn.ch>
References: <1352356737-14413-1-git-send-email-m.szyprowski@samsung.com>
 <20121111172243.GB821@lunn.ch>
 <50A0C5D2.7000806@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A0C5D2.7000806@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 10:48:02AM +0100, Soeren Moch wrote:
> On 11.11.2012 18:22, Andrew Lunn wrote:
> > On Thu, Nov 08, 2012 at 07:38:57AM +0100, Marek Szyprowski wrote:
> >> dmapool always calls dma_alloc_coherent() with GFP_ATOMIC flag,
> regardless
> >> the flags provided by the caller. This causes excessive pruning of
> >> emergency memory pools without any good reason. This patch
> changes the code
> >> to correctly use gfp flags provided by the dmapool caller. This should
> >> solve the dmapool usage on ARM architecture, where GFP_ATOMIC DMA
> >> allocations can be served only from the special, very limited
> memory pool.
> >>
> >> Reported-by: Soren Moch <smoch@web.de>
> Please use
> Reported-by: Soeren Moch <smoch@web.de>
> 
> >> Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> >> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >
> > Tested-by: Andrew Lunn <andrew@lunn.ch>
> >
> > I tested this on a Kirkwood QNAP after removing the call to
> > init_dma_coherent_pool_size().
> >
> >     Andrew
> 
> Tested-by: Soeren Moch <smoch@web.de>
> 
> Now I had a chance to test this patch on my Kirkwood guruplug
> system with linux-3.6.6 . It is running much better now, but with the
> original 256K coherent pool size I still see errors after several hours
> of runtime:
> 
> Nov 12 09:42:32 guru kernel: ERROR: 256 KiB atomic DMA coherent pool
> is too small!
> Nov 12 09:42:32 guru kernel: Please increase it with coherent_pool=
> kernel parameter!

Hi Soeren

Could you tell us what DVB devices you are using.

Thanks
	Andrew
