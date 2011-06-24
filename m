Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1FXLWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:22:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:50560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab1FXLWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:22:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,419,1304319600"; 
   d="scan'208";a="17715961"
Subject: Re: [PATCH] dmaengine: failure to get a specific DMA channel is
 not critical
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <BANLkTingHGRRCOsVZDs1W+FfdL1s1NCxhw@mail.gmail.com>
References: <Pine.LNX.4.64.1106201657280.11365@axis700.grange>
	 <w3pzklcxchm.wl%kuninori.morimoto.gx@renesas.com>
	 <BANLkTingHGRRCOsVZDs1W+FfdL1s1NCxhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 16:15:29 +0530
Message-ID: <1308912329.1536.0.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 10:49 +0900, Magnus Damm wrote:
> On Tue, Jun 21, 2011 at 9:19 AM, Kuninori Morimoto
> <kuninori.morimoto.gx@renesas.com> wrote:
> >
> > Dear Guennadi, all
> >
> >> There exist systems with multiple DMA controllers with different
> >> capabilities. For example, on some sh-mobile / rmobile systems there are
> >> DMA controllers, whose channels can be configured to be used with
> >> SD- and MMC-host controllers, serial ports etc. Besides there are also
> >> DMA controllers, that can only be used for one special function, e.g.,
> >> for USB. In such cases the DMA client filter function can just choose
> >> to specify to the DMA driver, which channel it needs. Then the
> >> .device_alloc_chan_resources() method of the DMA driver will check,
> >> whether it can provide that dunction. If not, it will fail and the loop
> >> in __dma_request_channel() will continue to the next DMA device, until
> >> it finds a suitable one. This works fine with just one minor glitch:
> >> the kernel logs error messages like
> >>
> >> dmaengine: failed to get <channel name>: (-<error code>)
> >>
> >> after each such non-critical failure. This patch lowers priority of
> >> this message to the debug level.
> >>
> >> Reported-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> >> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> ---
> >>
> >> Morimoto-san, I don't expect this patch to fail;), but if you like, you
> >> could give it a short spin and send your "tested-by" in reply to this
> >> mail.
> >
> > Thanks.
> > I tested this patch.
> >
> > I don't know that the dmaengine design,
> > but this patch remove non-critical error message from USB-DMAC for me.
> > I tested it on mackerel board + renesas_usbhs + USB-DMAC
> >
> > Tested-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> So I too gave the USBHS + USBHS-DMAC patches a go on top of
> linux-3.0-rc and they seem to work as expected.
> Without "[PATCH] dmaengine: failure to get a specific DMA channel is
> not critical" applied I get the following log:
> 
> / # echo /dev/mtdblock4 > /sys/devices/platform/renesas_usbhs.1/gadget/lun0/file
> 
> [hook up laptop to the USB gadget port]
> 
> / # dmaengine: failed to get dma0chan4: (-22)
> dmaengine: failed to get dma1chan0: (-22)
> dmaengine: failed to get dma2chan0: (-22)
> dmaengine: failed to get dma3chan0: (-22)
> dmaengine: failed to get dma0chan4: (-22)
> dmaengine: failed to get dma1chan0: (-22)
> dmaengine: failed to get dma2chan0: (-22)
> dmaengine: failed to get dma3chan0: (-22)
> g_mass_storage gadget: high speed config #1: Linux File-Backed Storage
> 
> With this patch applied the "dmaengine: failed to get..." messages all go away.
> 
> Tested-by: Magnus Damm <damm@opensource.se>
Applied Thanks.



-- 
~Vinod

