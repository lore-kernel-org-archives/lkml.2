Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375Ab0EEJxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:53:45 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:46766 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab0EEJxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:53:43 -0400
Date: Wed, 5 May 2010 11:53:39 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Jakob Viketoft <jakob.viketoft@bitsim.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
Message-ID: <20100505095339.GH30801@buzzloop.caiaq.de>
References: <20100416100126.GI30801@buzzloop.caiaq.de>
 <4BC84766.5060208@bitsim.com>
 <4BC8493D.60900@bitsim.com>
 <20100416112820.GM30801@buzzloop.caiaq.de>
 <20100416112931.GN30801@buzzloop.caiaq.de>
 <n2mf17812d71005050045x4359dfeu2f563c3ac0a42223@mail.gmail.com>
 <20100505080015.GD30801@buzzloop.caiaq.de>
 <u2nf17812d71005050228x3c19060n9a096d7bcc1db4d6@mail.gmail.com>
 <20100505094405.GG30801@buzzloop.caiaq.de>
 <j2tf17812d71005050247ybaf95719l27a9f1f403436b7f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <j2tf17812d71005050247ybaf95719l27a9f1f403436b7f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 05:47:14PM +0800, Eric Miao wrote:
> On Wed, May 5, 2010 at 5:44 PM, Daniel Mack <daniel@caiaq.de> wrote:

> >> And I'm not able to find
> >> drivers/pcmcia/pxa2xx_colibri.c as well.
> >
> > Erm - how is that related to the patch in question?
> >
> 
> The error seems to be (as in previous mail):
> 
>  CC      drivers/pcmcia/pxa2xx_colibri.o
> In file included from drivers/pcmcia/pxa2xx_colibri.c:25:
> arch/arm/mach-pxa/include/mach/colibri.h:13: error: expected ')'
> before '*' token
> make[2]: *** [drivers/pcmcia/pxa2xx_colibri.o] Error 1
> make[1]: *** [drivers/pcmcia] Error 2
> make: *** [drivers] Error 2

Ah, sorry.

> And actually, inclusion of <mach/mfp.h> is better to be placed where it's
> used, i.e. drivers/pcmcia/pxa2xx_colibri.c.

In general I agree, but in this case, mfp_t is used in this header file,
so every piece of code which includes colibri.h will need both
<mach/mfp.h> and <net/ax88796.h>. And as this is a rule for all users, I
think the right place for the inclusion is the header file?

Apart from that, this fix will work for both mainline and -stable, which
makes things easier :)

Daniel

