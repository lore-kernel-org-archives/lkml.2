Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0IDKbx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 06:31:53 -0400
Received: from sh.osrg.net ([192.16.179.4]:44841 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab0IDKbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 06:31:52 -0400
Date: Sat, 4 Sep 2010 19:31:26 +0900
To: sam@ravnborg.org
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
        miklos@szeredi.hu, jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] uml: disable CONFIG_HAS_DMA
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100904101313.GA26489@merkur.ravnborg.org>
References: <20100904181622P.fujita.tomonori@lab.ntt.co.jp>
	<20100904101313.GA26489@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100904193013B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 04 Sep 2010 19:31:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Sep 2010 12:13:13 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sat, Sep 04, 2010 at 06:17:56PM +0900, FUJITA Tomonori wrote:
> > I think that it's better to detect DMA misuse at build time rather
> > than calling BUG_ON. Architectures that can't do DMA need to disable
> > CONFIG_HAS_DMA.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/um/Kconfig.um                |    3 +
> >  arch/um/defconfig                 |    1 -
> >  arch/um/include/asm/dma-mapping.h |  112 -------------------------------------
> >  3 files changed, 3 insertions(+), 113 deletions(-)
> >  delete mode 100644 arch/um/include/asm/dma-mapping.h
> > 
> > diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
> > index ec2b8da..3de40b8 100644
> > --- a/arch/um/Kconfig.um
> > +++ b/arch/um/Kconfig.um
> > @@ -147,3 +147,6 @@ config KERNEL_STACK_ORDER
> >  	  This option determines the size of UML kernel stacks.  They will
> >  	  be 1 << order pages.  The default is OK unless you're running Valgrind
> >  	  on UML, in which case, set this to 3.
> > +
> > +config HAS_DMA
> > +       def_bool n
> 
> Other archs define NO_DMA to say they do not have DMA.
> We should do it the same way for um.

Defining NO_DMA affects any code? In other words, we can kill NO_DMA
definition?
