Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab0H1HWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 03:22:49 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:37889 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab0H1HWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 03:22:47 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Date: Sat, 28 Aug 2010 10:19:43 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.36-rc2; KDE/4.4.3; x86_64; ; )
Cc: u.kleine-koenig@pengutronix.de, g.liakhovetski@gmx.de,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, philippe.retornaz@epfl.ch, gregkh@suse.de,
        jkrzyszt@tis.icnet.pl
References: <201008270923.30297.mitov@issp.bas.bg> <201008280914.34233.mitov@issp.bas.bg> <20100828160921U.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100828160921U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008281019.52515.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 28, 2010 10:10:28 am FUJITA Tomonori wrote:
> On Sat, 28 Aug 2010 09:14:25 +0300
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > On Friday, August 27, 2010 09:32:14 am FUJITA Tomonori wrote:
> > > On Fri, 27 Aug 2010 09:23:21 +0300
> > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > 
> > > > On Friday, August 27, 2010 08:57:59 am FUJITA Tomonori wrote:
> > > > > On Fri, 27 Aug 2010 07:19:07 +0200
> > > > > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > > > > 
> > > > > > Hey,
> > > > > > 
> > > > > > On Fri, Aug 27, 2010 at 02:00:17PM +0900, FUJITA Tomonori wrote:
> > > > > > > On Fri, 27 Aug 2010 06:41:42 +0200
> > > > > > > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > > > > > > > On Thu, Aug 26, 2010 at 07:00:24PM +0900, FUJITA Tomonori wrote:
> > > > > > > > > On Thu, 26 Aug 2010 11:53:11 +0200
> > > > > > > > > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > > > > > > > > 
> > > > > > > > > > > > We have currently a number of boards broken in the mainline. They must be 
> > > > > > > > > > > > fixed for 2.6.36. I don't think the mentioned API will do this for us. So, 
> > > > > > > > > > > > as I suggested earlier, we need either this or my patch series
> > > > > > > > > > > > 
> > > > > > > > > > > > http://thread.gmane.org/gmane.linux.ports.sh.devel/8595
> > > > > > > > > > > > 
> > > > > > > > > > > > for 2.6.36.
> > > > > > > > > > > 
> > > > > > > > > > > Why can't you revert a commit that causes the regression?
> > > > > > > > > > > 
> > > > > > > > > > > The related DMA API wasn't changed in 2.6.36-rc1. The DMA API is not
> > > > > > > > > > > responsible for the regression. And the patchset even exnteds the
> > > > > > > > > > > definition of the DMA API (dma_declare_coherent_memory). Such change
> > > > > > > > > > > shouldn't applied after rc1. I think that DMA-API.txt says that
> > > > > > > > > > > dma_declare_coherent_memory() handles coherent memory for a particular
> > > > > > > > > > > device. It's not for the API that reserves coherent memory that can be
> > > > > > > > > > > used for any device for a single device.
> > > > > > > > > > The patch that made the problem obvious for ARM is
> > > > > > > > > > 309caa9cc6ff39d261264ec4ff10e29489afc8f8 aka v2.6.36-rc1~591^2~2^4~12.
> > > > > > > > > > So this went in before v2.6.36-rc1.  One of the "architectures which
> > > > > > > > > > similar restrictions" is x86 BTW.
> > > > > > > > > > 
> > > > > > > > > > And no, we won't revert 309caa9cc6ff39d261264ec4ff10e29489afc8f8 as it
> > > > > > > > > > addresses a hardware restriction.
> > > > > > > > > 
> > > > > > > > > How these drivers were able to work without hitting the hardware restriction?
> > > > > > > > In my case the machine in question is an ARMv5, the hardware restriction
> > > > > > > > is on ARMv6+ only.  You could argue that so the breaking patch for arm
> > > > > > > > should only break ARMv6, but I don't think this is sensible from a
> > > > > > > > maintainers POV.  We need an API that works independant of the machine
> > > > > > > > that runs the code.
> > > > > > > 
> > > > > > > Agreed. But insisting that the DMA API needs to be extended wrongly
> > > > > > > after rc2 to fix the regression is not sensible too. The related DMA
> > > > > > > API wasn't changed in 2.6.36-rc1. The API isn't responsible for the
> > > > > > > regression at all.
> > > > > > I think this isn't about "responsiblity".  Someone in arm-land found
> > > > > > that the way dma memory allocation worked for some time doesn't work
> > > > > > anymore on new generation chips.  As pointing out this problem was
> > > > > > expected to find some matches it was merged in the merge window.  One
> > > > > > such match is the current usage of the DMA API that doesn't currently
> > > > > > offer a way to do it right, so it needs a patch, no?
> > > > > 
> > > > > No, I don't think so. We are talking about a regression, right?
> > > > > 
> > > > > On new generation chips, something often doesn't work (which have
> > > > > worked on old chips for some time). It's not a regresiion. I don't
> > > > > think that it's sensible to make large change (especially after rc1)
> > > > > to fix such issue. If you say that the DMA API doesn't work on new
> > > > > chips and proposes a patch for the next merge window, it's sensible, I
> > > > > suppose.
> > > > > 
> > > > > Btw, the patch isn't a fix for the DMA API. It tries to extend the DMA
> > > > > API (and IMO in the wrong way). 
> > > > > In addition, the patch might break the
> > > > > current code. 
> > > > 
> > > > To "break the current code" is simply not possible. Sorry to oppose. As you have written it 
> > > > "extend the DMA API", so if you do not use the new API (and no current code is using it)
> > > > you cannot "break the current code". 
> > > 
> > > Looks like that the patch adds the new API that touches the exisitng
> > > code. It means the existing code could break. So the exsising API
> > > could break too.
> > > 
> > > http://thread.gmane.org/gmane.linux.ports.sh.devel/8595
> > 
> > The above reference is not my patch. I am speaking for my patch:
> > 
> > http://lkml.org/lkml/2010/8/19/200
> 
> I think that I already NACK'ed the patch.

OK.

Thanks,

Marin Mitov

> 
> 1) drivers/media/videobuf-dma-contig.c should not use
> dma_alloc_coherent. We shouldn't support the proposed API.
> 
> 2) I don't think that the DMA API (drivers/base/dma-mapping.c) is not
> for creating "cache". Generally, the kernel uses "pool" concept for
> something like that.
> 
> IMHO, reverting the commit 309caa9cc6ff39d261264ec4ff10e29489afc8f8
> temporary (or temporary disabling it for systems that had worked) is
> the most reasonable approach. I don't think that breaking systems that
> had worked is a good idea even if the patch does the right thing. I
> believe that we need to fix the broken solution
> (videobuf-dma-contig.c) before the commit.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
