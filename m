Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab2KPHDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:03:22 -0500
Received: from mail.southpole.se ([37.247.8.11]:37578 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab2KPHDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:03:21 -0500
Message-ID: <1353049393.7748.156.camel@jerome.southpole.se>
Subject: Re: [PATCH RFT RESEND linux-next] openrisc: dma-mapping: support
 debug_dma_mapping_error
From: Jonas Bonn <jonas@southpole.se>
To: shuah.khan@hp.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com,
        linux-arch@vger.kernel.org
Date: Fri, 16 Nov 2012 08:03:13 +0100
In-Reply-To: <1353002435.2532.39.camel@lorien2>
References: <1351208548.6851.19.camel@lorien2>
	 <1351267555.4013.15.camel@lorien2> <1353002435.2532.39.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 49154-04650
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 11:00 -0700, Shuah Khan wrote:
> On Fri, 2012-10-26 at 10:05 -0600, Shuah Khan wrote:
> > Add support for debug_dma_mapping_error() call to avoid warning from
> > debug_dma_unmap() interface when it checks for mapping error checked
> > status. Without this patch, device driver failed to check map error
> > warning is generated.
> > 
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > ---
> >  arch/openrisc/include/asm/dma-mapping.h |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/openrisc/include/asm/dma-mapping.h b/arch/openrisc/include/asm/dma-mapping.h
> > index fab8628..f12de49 100644
> > --- a/arch/openrisc/include/asm/dma-mapping.h
> > +++ b/arch/openrisc/include/asm/dma-mapping.h
> > @@ -95,6 +95,7 @@ static inline int dma_supported(struct device *dev, u64 dma_mask)
> >  
> >  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> >  {
> > +	debug_dma_mapping_error(dev, dma_addr);
> >  	return 0;
> >  }
> >  
> 
> Marek/Jonas,
> 
> This one is for openrisc to go through Marek's tree with the other arch
> debug_dma_mapping_error() patches. Hoping it is ok with Jonas.

NAK... for a bunch of reasons.

i)   You've sent this exact patch 4 times already... and this time
you're trying to bypass me altogether by going through some other tree.
First it was a PATCH, now it's an RFT... what do you want me to do with
this?

ii)  There isn't enough information in the commit message to understand
what's going on here.  Why do I suddenly need this when I never needed
it before?

iii) This doesn't compile... but I figured out that it depends on other
changes that seem to have snuck into linux-next already.  linux-arch was
never included in that discussion, despite the fact that you have now
introduced warnings for everybody

iv)  From what I can tell, you haven't even attempted to fix all
architectures... but I could be wrong, see next comment.

v)  You've sent this patch series per-architecture which really only
serves to fragment the discussion.  When a change is this
straight-forward (exact same change in each architecture), then it's
better to consolidate everything into a single patch to allow a single
discussion to take place.  As it stands now, I have to go rummaging
through the threads of all 30 architectures to see what others think of
this; I'd say the silence is telling, but the few responses you did
receive all show the same confusion and you're answering the same
questions over and over.  I realize that you can't inflate your patch
statistics this way and you'll probably just miss the top 10 of "Who
wrote 3.8" because of it, but you can always try to write something
witty in your commit message and hope to make "Quotes of the week"
instead.

vi)  If you _had_ requested comment on your underlying dma-debug patch
on linux-arch, I think you would have found that:

1)  introducing warnings without fixing them _at the same time_ isn't OK
when the fix is this simple
2)  if you make changes to core code, you make it optional until all
arches have caught up
3)  you are using get_dma_ops which isn't even implemented on every
architecture
4)  this change probably doesn't belong in every architecture but should
be centralized in more generic code

/Jonas

