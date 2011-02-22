Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1BVOTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:19:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1BVOTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:19:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 09/12] unicore32 machine related files: hardware registers
Date: Tue, 22 Feb 2011 15:19:03 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <015301cbcdae$55cdb7e0$016927a0$@mprc.pku.edu.cn> <201102181142.42614.arnd@arndb.de> <018601cbd29a$118b27c0$34a17740$@mprc.pku.edu.cn>
In-Reply-To: <018601cbd29a$118b27c0$34a17740$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102221519.03423.arnd@arndb.de>
X-Provags-ID: V02:K0:ISwH1YTPibggXle65UuBrSvlqNNenlnnU3IZNw0/Nvp
 ud43ctYuFXJkrpBc/JG7W5kCD5ncPlfCT+EYrlXaDV1QlPO9GI
 Us4YMIl6olmuZE3MChJCUaRRz3VyzJjy3IkE5kpH81GfVsQWWD
 pKbOuT2+hbzX3g2HvKUyd8o3XhS+BRVKnafMMTSbPfV4ngO2qm
 IqQOwf5dPW6vKFc+P3MAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 February 2011, Guan Xuetao wrote:
> > > diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
> > > index 3fb7236..ebce7de 100644
> > > --- a/arch/unicore32/include/mach/hardware.h
> > > +++ b/arch/unicore32/include/mach/hardware.h
> > > @@ -17,19 +17,14 @@
> > >
> > >  #include "PKUnity.h"
> > >
> > > -#define io_p2v(x)  ((x) - PKUNITY_IOSPACE_BASE)
> > > -#define io_v2p(x)  ((x) + PKUNITY_IOSPACE_BASE)
> > > +#define io_p2v(x)  ((x) - PKUNITY_MMIO_BASE)
> > > +#define io_v2p(x)  ((x) + PKUNITY_MMIO_BASE)
> > >
> I apply the patch as following:
> 
> @@ -22,8 +22,7 @@
>  
>  #ifndef __ASSEMBLY__
>  
> -# define __REG(x)      (*((volatile unsigned long *)io_p2v(x)))
> -# define __PREG(x)     (io_v2p((unsigned long)&(x)))
> +# define __REG(x)      (void __iomem *)io_p2v(x)

The patch looks correct, but if you make the the definition for
PKUNITY_MMIO_BASE contain the cast to (void __iomem *), you no
longer need another cast.

> __REG reserved only for all registers prefix.
> And all using for __REG converted to readl/writel.

Fair enough.

	Arnd
