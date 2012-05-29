Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2E2J6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:58:34 -0400
Received: from flounder.pepperfish.net ([89.238.129.35]:54163 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2E2J6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:58:31 -0400
X-Greylist: delayed 2222 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2012 05:58:31 EDT
Date: Tue, 29 May 2012 10:21:20 +0100
From: Vincent Sanders <vincent.sanders@collabora.co.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Vincent Sanders <vincent.sanders@collabora.co.uk>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Allow constructor name selection by architecture.
Message-ID: <20120529092120.GA6433@kyllikki.org>
References: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk>
 <1338230018-31052-2-git-send-email-vincent.sanders@collabora.co.uk>
 <20120528203005.GA20560@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528203005.GA20560@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 10:30:05PM +0200, Sam Ravnborg wrote:
> On Mon, May 28, 2012 at 07:33:37PM +0100, Vincent Sanders wrote:
> > From: Vincent Sanders <vince@collabora.co.uk>
> > 
> > The constructor symbol name is different between platforms. Allow this
> > to be selected by configuration and set suitable default values.
> > 
> > Signed-off-by: Vincent Sanders <vincent.sanders@collabora.co.uk>
> > ---
> >  include/asm-generic/vmlinux.lds.h |    6 +++---
> >  init/Kconfig                      |    6 ++++++
> >  kernel/module.c                   |    2 +-
> >  3 files changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index 8aeadf6..fd34808 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -471,9 +471,9 @@
> >  	}
> >  
> >  #ifdef CONFIG_CONSTRUCTORS
> > -#define KERNEL_CTORS()	. = ALIGN(8);			   \
> > -			VMLINUX_SYMBOL(__ctors_start) = .; \
> > -			*(.ctors)			   \
> > +#define KERNEL_CTORS()	. = ALIGN(8);					\
> > +			VMLINUX_SYMBOL(__ctors_start) = .;		\
> > +			*(CONFIG_CONSTRUCTORS_NAME)			\
> >  			VMLINUX_SYMBOL(__ctors_end) = .;
> 
> What is wrong with adding both "standard" names for ctors uncnditionally?
> Like this:
> > 			*(.ctors)			   \
> > +			*(.init_array)			   \
> 

Persoinally I have no strong opinion and would alter approach.

As I understand it the previous objections to the "put them all in"
approach (this change has been round the loop before) were:

 - It contaminates the x86 symbol namespace and if init_array was used on
   not ARM it might lead to surprises

 - If another architecture needs something different again then we are
   going to end up with another symbol.

 - The module loading code has to be changed to allow either symbol.

The only technical issue really is the module symbol handling and I am
unsure how to robustly handle that.

-- 
Regards Vincent
http://www.kyllikki.org/
