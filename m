Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2GZVja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:39:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2GZVj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:39:27 -0400
Date: Thu, 26 Jul 2012 23:39:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 9/9 v3] dma: shdma: convert to the shdma base library
In-Reply-To: <1343301622.1726.9021.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1207262338130.2723@axis700.grange>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de> 
 <1336576161-27082-10-git-send-email-g.liakhovetski@gmx.de> 
 <20120725035935.GA30468@linux-sh.org>  <1343285361.1726.8980.camel@vkoul-udesk3>
  <20120726065804.GF30468@linux-sh.org> <1343301622.1726.9021.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:zZe9oyns4kism8RJedRKUG3eDPnpFEdOwUftaN4hR6S
 rueSKaiATTLSAimnW3JD1uETEpZPu53nNKW1qohV6tsyat0ksb
 TJ3XqvyR+SZMXsNWx07VFDAsLFfLKEREiVb4x0+14JBNqiDPWC
 vLDfopT2RQiGholWS+Mu420yQ+MBK9+ShE4ZJeNMBuvKi4nDik
 4vRT06U8ZOK1m4fG2BfNm/9E7MWrZSykdaSRNdJfazQ5/01g4J
 SWlM05h0/JqAvwVIf6L8w4GJfYpOY6zyBrCJzAlcCMBYDsQFMy
 EqrsanIOA76Ie7OoX4yimWRbX8TQjw7hFds9u3YjQuOkXoffn1
 2EcBfIqIFhIKnUlexJYcJVwCXgPiJQroZgqYJkzoIvIkhQ7Sic
 nx2SIugJaKv2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012, Vinod Koul wrote:

> On Thu, 2012-07-26 at 15:58 +0900, Paul Mundt wrote:
> > On Thu, Jul 26, 2012 at 12:19:21PM +0530, Vinod Koul wrote:
> > > On Wed, 2012-07-25 at 12:59 +0900, Paul Mundt wrote:
> > > > On Wed, May 09, 2012 at 05:09:21PM +0200, Guennadi Liakhovetski wrote:
> > > > > The shdma base library has originally been extracted from the shdma driver,
> > > > > which now can be converted to actually use it.
> > > > > 
> > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > > ---
> > > > >  drivers/dma/sh/shdma.c | 1122 ++++++++++++------------------------------------
> > > > >  drivers/dma/sh/shdma.h |   44 +-
> > > > >  include/linux/sh_dma.h |   33 +-
> > > > >  3 files changed, 302 insertions(+), 897 deletions(-)
> > > > > 
> > > > Now that this has hit mainline, the sh-sci with DMA enabled build is
> > > > broken:
> > > > 
> > > >   CC      drivers/tty/serial/sh-sci.o
> > > > drivers/tty/serial/sh-sci.c: In function 'work_fn_rx':
> > > > drivers/tty/serial/sh-sci.c:1413:67: error: dereferencing pointer to incomplete type
> > > > drivers/tty/serial/sh-sci.c:1413:81: warning: type defaults to 'int' in declaration of '__mptr'
> > > > drivers/tty/serial/sh-sci.c:1413:90: warning: initialization from incompatible pointer type
> > > > drivers/tty/serial/sh-sci.c:1413:161: error: invalid use of undefined type 'struct sh_desc'
> > > > drivers/tty/serial/sh-sci.c:1419:83: error: dereferencing pointer to incomplete type
> > > > drivers/tty/serial/sh-sci.c:1419:101: error: dereferencing pointer to incomplete type
> > > > drivers/tty/serial/sh-sci.c:1423:42: error: dereferencing pointer to incomplete type
> > > This was in -next for quite some time :(
> > > 
> > It seems we don't have any configs that have this default-enabled under
> > -next, so it wasn't noticed before. Still, as Guennadi wrote this code
> > I'm surprised it was overlooked.
> So did my script :(
> 
> 
> I tried checking this, struct sh_desc have moved to struct shdma_desc in
> shdma-base.h. But the field partial was dropped, so we need to use
> residue here. But, shdma or base doesn't calculate residue for err
> transactions, so you cannot use it to start a new one.

Hi Vinod, Paul

I'm on a holiday ATM, coming back late Saturday / Sunday. I'll have a look 
at this breakage ASAP and submit a fix.

Thank
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
