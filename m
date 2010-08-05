Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007Ab0HESFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:05:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:51606 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758969Ab0HESFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:05:06 -0400
Date: Thu, 5 Aug 2010 11:02:11 -0700
From: Greg KH <gregkh@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] driver core: Add ability for arch code to setup
 pdev_archdata
Message-ID: <20100805180211.GA12687@suse.de>
References: <1281021347-1278-1-git-send-email-galak@kernel.crashing.org>
 <1281021347-1278-2-git-send-email-galak@kernel.crashing.org>
 <20100806014351.a3bddf08.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806014351.a3bddf08.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 01:43:51AM +1000, Stephen Rothwell wrote:
> Hi Kumar,
> 
> On Thu,  5 Aug 2010 10:15:45 -0500 Kumar Gala <galak@kernel.crashing.org> wrote:
> >
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/err.h>
> >  #include <linux/slab.h>
> >  #include <linux/pm_runtime.h>
> > +#include <asm/platform_device.h>
> >  
> >  #include "base.h"
> >  
> > @@ -170,6 +171,9 @@ struct platform_device *platform_device_alloc(const char *name, int id)
> >  		pa->pdev.id = id;
> >  		device_initialize(&pa->pdev.dev);
> >  		pa->pdev.dev.release = platform_device_release;
> > +#ifdef ARCH_HAS_PDEV_ARCHDATA_SETUP
> > +		arch_setup_pdev_archdata(&pa->pdev);
> > +#endif
> >  	}
> >  
> >  	return pa ? &pa->pdev : NULL;
> > diff --git a/include/asm-generic/platform_device.h b/include/asm-generic/platform_device.h
> > new file mode 100644
> > index 0000000..64806dc
> > --- /dev/null
> > +++ b/include/asm-generic/platform_device.h
> > @@ -0,0 +1,7 @@
> > +#ifndef __ASM_GENERIC_PLATFORM_DEVICE_H_
> > +#define __ASM_GENERIC_PLATFORM_DEVICE_H_
> > +/*
> > + * an architecture can override to define arch_setup_pdev_archdata
> > + */
> > +
> > +#endif /* __ASM_GENERIC_PLATFORM_DEVICE_H_ */
> 
> Why not do:
> 
> #include <linux/platform_device.h>
> 
> #ifndef arch_setup_pdev_archdata
> static inline void arch_setup_pdev_archdata(struct platform_device *pdev) { }
> #endif
> 
> in asm-generic/platform-device.h
> 
> and the the call in platform_device_alloc() can be unconditional.  If the arch wants to override arch_setup_pdev_archdata, it defines the function and then does
> 
> #define arch_setup_pdev_archdata arch_setup_pdev_archdata
> 
> before still including asm-generic/platform_device.h

Yes, I'd prefer that method as well.

thanks,

greg k-h
