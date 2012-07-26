Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab2GZG6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 02:58:15 -0400
Received: from linux-sh.org ([111.68.239.195]:44897 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab2GZG6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 02:58:14 -0400
Date: Thu, 26 Jul 2012 15:58:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 9/9 v3] dma: shdma: convert to the shdma base library
Message-ID: <20120726065804.GF30468@linux-sh.org>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
 <1336576161-27082-10-git-send-email-g.liakhovetski@gmx.de>
 <20120725035935.GA30468@linux-sh.org>
 <1343285361.1726.8980.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343285361.1726.8980.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 12:19:21PM +0530, Vinod Koul wrote:
> On Wed, 2012-07-25 at 12:59 +0900, Paul Mundt wrote:
> > On Wed, May 09, 2012 at 05:09:21PM +0200, Guennadi Liakhovetski wrote:
> > > The shdma base library has originally been extracted from the shdma driver,
> > > which now can be converted to actually use it.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > >  drivers/dma/sh/shdma.c | 1122 ++++++++++++------------------------------------
> > >  drivers/dma/sh/shdma.h |   44 +-
> > >  include/linux/sh_dma.h |   33 +-
> > >  3 files changed, 302 insertions(+), 897 deletions(-)
> > > 
> > Now that this has hit mainline, the sh-sci with DMA enabled build is
> > broken:
> > 
> >   CC      drivers/tty/serial/sh-sci.o
> > drivers/tty/serial/sh-sci.c: In function 'work_fn_rx':
> > drivers/tty/serial/sh-sci.c:1413:67: error: dereferencing pointer to incomplete type
> > drivers/tty/serial/sh-sci.c:1413:81: warning: type defaults to 'int' in declaration of '__mptr'
> > drivers/tty/serial/sh-sci.c:1413:90: warning: initialization from incompatible pointer type
> > drivers/tty/serial/sh-sci.c:1413:161: error: invalid use of undefined type 'struct sh_desc'
> > drivers/tty/serial/sh-sci.c:1419:83: error: dereferencing pointer to incomplete type
> > drivers/tty/serial/sh-sci.c:1419:101: error: dereferencing pointer to incomplete type
> > drivers/tty/serial/sh-sci.c:1423:42: error: dereferencing pointer to incomplete type
> This was in -next for quite some time :(
> 
It seems we don't have any configs that have this default-enabled under
-next, so it wasn't noticed before. Still, as Guennadi wrote this code
I'm surprised it was overlooked.
