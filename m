Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768651Ab2KOSRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:17:39 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:3336 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768572Ab2KOSRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:17:38 -0500
Message-ID: <1353003455.2532.50.camel@lorien2>
Subject: Re: [PATCH RFT linux-next] frv: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: dhowells@redhat.com, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Thu, 15 Nov 2012 11:17:35 -0700
In-Reply-To: <1351271717.4013.39.camel@lorien2>
References: <1351270093.4013.29.camel@lorien2>
	 <1351271717.4013.39.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 11:15 -0600, Shuah Khan wrote:
> On Fri, 2012-10-26 at 10:48 -0600, Shuah Khan wrote:
> > Add support for debug_dma_mapping_error() call to avoid warning from
> > debug_dma_unmap() interface when it checks for mapping error checked
> > status. Without this patch, device driver failed to check map error
> > warning is generated.
> > 
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> 
> Please ignore this patch if frv doesn't use dma_map_page() and
> dma_map_single() from arch/mips/include/asm/dma-mapping.
> 
> frv defines dma_map_page() and dma_map_single() in
> arch/frv/mb93090-mb00/pci-dma.c and
> arch/frv/mb93090-mb00/pci-dma-nommu.c
> 
> -- Shuah
> > ---
> >  arch/frv/include/asm/dma-mapping.h |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
> > index dfb8110..d8a8aac 100644
> > --- a/arch/frv/include/asm/dma-mapping.h
> > +++ b/arch/frv/include/asm/dma-mapping.h
> > @@ -6,6 +6,7 @@
> >  #include <asm/cacheflush.h>
> >  #include <asm/scatterlist.h>
> >  #include <asm/io.h>
> > +#include <linux/dma-debug.h>
> >  
> >  /*
> >   * See Documentation/DMA-API.txt for the description of how the
> > @@ -97,6 +98,7 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nele
> >  static inline
> >  int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> >  {
> > +	debug_dma_mapping_error(dev, dma_addr);
> >  	return 0;
> >  }
> >  
> 

Marek,

This one is for frv to go through your tree with the other arch patches
for debug_dmap_mapping_error(). However, I am not very sure if this
change is necessary for frv if it doesn't use generic dma interfaces. I
will defer to you and David on deciding if this patch is needed.

frv defines dma_map_page() and dma_map_single() in
arch/frv/mb93090-mb00/pci-dma.c and
 arch/frv/mb93090-mb00/pci-dma-nommu.c

Thanks,
-- Shuah


