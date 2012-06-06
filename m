Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2FFKNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:13:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53620 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2FFKNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:13:12 -0400
Date: Wed, 6 Jun 2012 11:12:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Vincent Sanders <vincent.sanders@collabora.co.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Vincent Sanders <vince@collabora.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Allow constructor name selection by architecture.
Message-ID: <20120606101253.GM8262@n2100.arm.linux.org.uk>
References: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk> <1338230018-31052-2-git-send-email-vincent.sanders@collabora.co.uk> <20120528203005.GA20560@merkur.ravnborg.org> <20120529090614.GD12217@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529090614.GD12217@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 10:06:14AM +0100, Russell King - ARM Linux wrote:
> On Mon, May 28, 2012 at 10:30:05PM +0200, Sam Ravnborg wrote:
> > On Mon, May 28, 2012 at 07:33:37PM +0100, Vincent Sanders wrote:
> > > From: Vincent Sanders <vince@collabora.co.uk>
> > > 
> > > The constructor symbol name is different between platforms. Allow this
> > > to be selected by configuration and set suitable default values.
> > > 
> > > Signed-off-by: Vincent Sanders <vincent.sanders@collabora.co.uk>
> > > ---
> > >  include/asm-generic/vmlinux.lds.h |    6 +++---
> > >  init/Kconfig                      |    6 ++++++
> > >  kernel/module.c                   |    2 +-
> > >  3 files changed, 10 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > > index 8aeadf6..fd34808 100644
> > > --- a/include/asm-generic/vmlinux.lds.h
> > > +++ b/include/asm-generic/vmlinux.lds.h
> > > @@ -471,9 +471,9 @@
> > >  	}
> > >  
> > >  #ifdef CONFIG_CONSTRUCTORS
> > > -#define KERNEL_CTORS()	. = ALIGN(8);			   \
> > > -			VMLINUX_SYMBOL(__ctors_start) = .; \
> > > -			*(.ctors)			   \
> > > +#define KERNEL_CTORS()	. = ALIGN(8);					\
> > > +			VMLINUX_SYMBOL(__ctors_start) = .;		\
> > > +			*(CONFIG_CONSTRUCTORS_NAME)			\
> > >  			VMLINUX_SYMBOL(__ctors_end) = .;
> > 
> > What is wrong with adding both "standard" names for ctors uncnditionally?
> > Like this:
> > > 			*(.ctors)			   \
> > > +			*(.init_array)			   \
> 
> That doesn't get rid of CONFIG_CONSTRUCTORS_NAME, because it's needed
> in the module code.  Do you have a suggestion to solve that as well?

Ping.
