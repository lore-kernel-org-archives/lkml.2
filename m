Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0IDLSa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 07:18:30 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50939 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0IDLS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 07:18:29 -0400
Date: Sat, 4 Sep 2010 13:18:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, miklos@szeredi.hu, jdike@addtoit.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] uml: disable CONFIG_HAS_DMA
Message-ID: <20100904111825.GA26654@merkur.ravnborg.org>
References: <20100904181622P.fujita.tomonori@lab.ntt.co.jp> <20100904101313.GA26489@merkur.ravnborg.org> <20100904193013B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100904193013B.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 07:31:26PM +0900, FUJITA Tomonori wrote:
> On Sat, 4 Sep 2010 12:13:13 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sat, Sep 04, 2010 at 06:17:56PM +0900, FUJITA Tomonori wrote:
> > > I think that it's better to detect DMA misuse at build time rather
> > > than calling BUG_ON. Architectures that can't do DMA need to disable
> > > CONFIG_HAS_DMA.
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > >  arch/um/Kconfig.um                |    3 +
> > >  arch/um/defconfig                 |    1 -
> > >  arch/um/include/asm/dma-mapping.h |  112 -------------------------------------
> > >  3 files changed, 3 insertions(+), 113 deletions(-)
> > >  delete mode 100644 arch/um/include/asm/dma-mapping.h
> > > 
> > > diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
> > > index ec2b8da..3de40b8 100644
> > > --- a/arch/um/Kconfig.um
> > > +++ b/arch/um/Kconfig.um
> > > @@ -147,3 +147,6 @@ config KERNEL_STACK_ORDER
> > >  	  This option determines the size of UML kernel stacks.  They will
> > >  	  be 1 << order pages.  The default is OK unless you're running Valgrind
> > >  	  on UML, in which case, set this to 3.
> > > +
> > > +config HAS_DMA
> > > +       def_bool n
> > 
> > Other archs define NO_DMA to say they do not have DMA.
> > We should do it the same way for um.
> 
> Defining NO_DMA affects any code? In other words, we can kill NO_DMA
> definition?

NO_DMA affects HAS_DMA.

HAS_DMA is defined like this:

config HAS_DMA
        boolean
        depends on !NO_DMA
        default y

So to set HAS_DMA to true an arch should do:
1) Do not define NO_DMA
2) Define NO_DMA abd set it to 'n'

Must archs - including um - used principle 1).

In the um case we want to say that we do NOT have any DMA.
This can be done in two ways.
a) define NO_DMA and set it to 'y'
b) redefine HAS_DMA and set it to 'n'.

The patch you provided used principle b) where other archs use principle a).
So I suggest you should use principle a) for um too.

> Defining NO_DMA affects any code? 
As per above - yes it does. Because NO_DMA affects HAS_DMA and HAS_DMA affects code.

	Sam
