Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609Ab2JZO65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:58:57 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:12943 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZO6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:58:55 -0400
Message-ID: <1351263531.2712.3.camel@lorien2>
Subject: Re: [PATCH RFT] microblaze: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: monstr@monstr.eu
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com, arnd@arndb.de,
        andrzej.p@samsung.com, microblaze-uclinux@itee.uq.edu.au,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Fri, 26 Oct 2012 08:58:51 -0600
In-Reply-To: <508A49D3.2080303@monstr.eu>
References: <1351207747.6851.15.camel@lorien2> <508A49D3.2080303@monstr.eu>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 10:29 +0200, Michal Simek wrote:
> On 10/26/2012 01:29 AM, Shuah Khan wrote:
> > Add support for debug_dma_mapping_error() call to avoid warning from
> > debug_dma_unmap() interface when it checks for mapping error checked
> > status. Without this patch, device driver failed to check map error
> > warning is generated.
> >
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > ---
> >   arch/microblaze/include/asm/dma-mapping.h |    1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
> > index 01d2282..4451c7a 100644
> > --- a/arch/microblaze/include/asm/dma-mapping.h
> > +++ b/arch/microblaze/include/asm/dma-mapping.h
> > @@ -114,6 +114,7 @@ static inline void __dma_sync(unsigned long paddr,
> >   static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> >   {
> >   	struct dma_map_ops *ops = get_dma_ops(dev);
> 
> here should be empty line.
> 
> > +	debug_dma_mapping_error(dev, dma_addr);
> >   	if (ops->mapping_error)
> >   		return ops->mapping_error(dev, dma_addr);
> 
> Patch looks good to me. I was greping the latest mainline tree and I can't see
> reference to debug_dma_mapping_error. Can you tell me where this function
> is implemented.
> I have also seen that you have sent several similar patches like this.
> 
> If you want to add it through any other tree here is my ACK:
> 
> Acked-by: Michal Simek <monstr@monstr.eu>
> 
> I will definitely keep my eyes on it.

debug_dma_mapping_error() patch is in linux-next. I probably should send
all of these patches marked explicitly for linux-next.

Thanks,
-- Shuah


