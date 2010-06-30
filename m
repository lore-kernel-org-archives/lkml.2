Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0F3Vc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:32:28 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:54291 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab0F3VcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:32:24 -0400
Date: Wed, 30 Jun 2010 17:32:18 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 4/4] x86: OLPC: add OLPC device-tree support
Message-ID: <20100630173218.2bdd18d4@dev.queued.net>
In-Reply-To: <AANLkTik7rqaGz7RtsOlhoSZw_-6bhv43YlWETsB17__4@mail.gmail.com>
References: <20100628215407.2017bf2f@debian>
	<20100628220058.19e8f143@debian>
	<AANLkTinUy_FGuN9DiF5KtMCsqYUbByfS6g2Mdw0ATvtQ@mail.gmail.com>
	<20100629102339.5e8a30b6@dev.queued.net>
	<AANLkTik7rqaGz7RtsOlhoSZw_-6bhv43YlWETsB17__4@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 15:13:26 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Tue, Jun 29, 2010 at 8:23 AM, Andres Salomon <dilinger@queued.net>
> wrote:
> > On Tue, 29 Jun 2010 01:12:36 -0700
> > Grant Likely <grant.likely@secretlab.ca> wrote:
[...]
> >> > +extern void prom_build_devicetree(void);
> >> > +
> >> > +extern void *prom_early_alloc(unsigned long size);
> >> > +
> >> > +extern char *prom_firstprop(phandle node, char *buf);
> >> > +extern char *prom_nextprop(phandle node, const char *prev, char
> >> > *buf); +extern int prom_getproplen(phandle node, const char
> >> > *prop); +extern int prom_getproperty(phandle node, const char
> >> > *prop,
> >> > +                            char *buffer, int bufsize);
> >> > +extern phandle prom_getchild(phandle node);
> >> > +extern phandle prom_getsibling(phandle node);
> >> > +
> >> > +#endif /* __KERNEL__ */
> >> > +#endif /* _X86_PROM_OLPC_H */
> >> > diff --git a/arch/x86/include/asm/prom.h
> >> > b/arch/x86/include/asm/prom.h new file mode 100644
> >> > index 0000000..7b561b2
> >> > --- /dev/null
> >> > +++ b/arch/x86/include/asm/prom.h
> >> > @@ -0,0 +1,5 @@
> >> > +#ifdef CONFIG_OLPC_OPENFIRMWARE
> >> > +# include <asm/olpc_prom.h>
> >> > +#else
> >> > +# error "No OFW prom defined for x86!"
> >> > +#endif
> >>
> >> Personally, I wouldn't bother with the header file redirection.
> >
> > The reason for the header file redirection is because this is
> > OLPC-only; the x86 folks don't want me claiming this to be the One
> > True x86 OFW.
> 
> However, the #ifdef/#elseif/#else/#endif approach also makes the
> assumption that only one kind of OFW will be supported by any given
> kernel.  Or for that matter, both OFW and the flattened tree also
> become mutually exclusive due to the default behaviour override.
> 
> Besides, aren't the function declarations just the interface defined
> by the prom extraction code?  Is there any need to #ifdef that API?  I
> would think those function prototypes should be defined by the header
> for the prom extraction code.

Mm, both are good points; I suppose for now it doesn't hurt to lose the
#ifdefs, and deal w/ additional x86 proms support if it comes up.

