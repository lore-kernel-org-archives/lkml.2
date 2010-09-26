Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0IZSIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:08:40 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:47049 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab0IZSIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:08:38 -0400
Date: Sun, 26 Sep 2010 11:07:26 -0700
From: matt mooney <mfm@muteddisk.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: kernel-janitors@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 05/24] i2c: change to new flag variable
Message-ID: <20100926180726.GD8191@haskell.muteddisk.com>
Mail-Followup-To: Jean Delvare <khali@linux-fr.org>,
	kernel-janitors@vger.kernel.org,
	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
	linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
 <036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com>
 <ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
 <b3e2061e1e6703f7b84c0484030e07de6000546a.1285355033.git.mfm@muteddisk.com>
 <20100925132611.03ef0882@endymion.delvare>
 <20100926021217.GC8191@haskell.muteddisk.com>
 <20100926092931.68980448@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100926092931.68980448@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:29 Sun 26 Sep     , Jean Delvare wrote:
> On Sat, 25 Sep 2010 19:12:17 -0700, matt mooney wrote:
> > On 13:26 Sat 25 Sep     , Jean Delvare wrote:
> > > On Fri, 24 Sep 2010 12:17:15 -0700, matt mooney wrote:
> > > > Replace EXTRA_CFLAGS with ccflags-y.
> > > > 
> > > > Signed-off-by: matt mooney <mfm@muteddisk.com>
> > > > ---
> > > >  drivers/i2c/Makefile        |    4 +---
> > > >  drivers/i2c/algos/Makefile  |    4 +---
> > > >  drivers/i2c/busses/Makefile |    4 +---
> > > >  drivers/i2c/muxes/Makefile  |    4 +---
> > > >  4 files changed, 4 insertions(+), 12 deletions(-)
> > > > 
> > > > diff --git a/drivers/i2c/Makefile b/drivers/i2c/Makefile
> > > > index c00fd66..23ac61e 100644
> > > > --- a/drivers/i2c/Makefile
> > > > +++ b/drivers/i2c/Makefile
> > > > @@ -9,6 +9,4 @@ obj-$(CONFIG_I2C_CHARDEV)	+= i2c-dev.o
> > > >  obj-$(CONFIG_I2C_MUX)		+= i2c-mux.o
> > > >  obj-y				+= algos/ busses/ muxes/
> > > >  
> > > > -ifeq ($(CONFIG_I2C_DEBUG_CORE),y)
> > > > -EXTRA_CFLAGS += -DDEBUG
> > > > -endif
> > > > +ccflags-$(CONFIG_I2C_DEBUG_CORE) := -DDEBUG
> > > > diff --git a/drivers/i2c/algos/Makefile b/drivers/i2c/algos/Makefile
> > > > index 18b3e96..215303f 100644
> > > > --- a/drivers/i2c/algos/Makefile
> > > > +++ b/drivers/i2c/algos/Makefile
> > > > @@ -6,6 +6,4 @@ obj-$(CONFIG_I2C_ALGOBIT)	+= i2c-algo-bit.o
> > > >  obj-$(CONFIG_I2C_ALGOPCF)	+= i2c-algo-pcf.o
> > > >  obj-$(CONFIG_I2C_ALGOPCA)	+= i2c-algo-pca.o
> > > >  
> > > > -ifeq ($(CONFIG_I2C_DEBUG_ALGO),y)
> > > > -EXTRA_CFLAGS += -DDEBUG
> > > > -endif
> > > > +ccflags-$(CONFIG_I2C_DEBUG_ALGO) := -DDEBUG
> > > > diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> > > > index c3ef492..033ad41 100644
> > > > --- a/drivers/i2c/busses/Makefile
> > > > +++ b/drivers/i2c/busses/Makefile
> > > > @@ -76,6 +76,4 @@ obj-$(CONFIG_I2C_STUB)		+= i2c-stub.o
> > > >  obj-$(CONFIG_SCx200_ACB)	+= scx200_acb.o
> > > >  obj-$(CONFIG_SCx200_I2C)	+= scx200_i2c.o
> > > >  
> > > > -ifeq ($(CONFIG_I2C_DEBUG_BUS),y)
> > > > -EXTRA_CFLAGS += -DDEBUG
> > > > -endif
> > > > +ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG
> > > > diff --git a/drivers/i2c/muxes/Makefile b/drivers/i2c/muxes/Makefile
> > > > index bd83b52..6f49786 100644
> > > > --- a/drivers/i2c/muxes/Makefile
> > > > +++ b/drivers/i2c/muxes/Makefile
> > > > @@ -3,6 +3,4 @@
> > > >  
> > > >  obj-$(CONFIG_I2C_MUX_PCA954x)	+= pca954x.o
> > > >  
> > > > -ifeq ($(CONFIG_I2C_DEBUG_BUS),y)
> > > > -EXTRA_CFLAGS += -DDEBUG
> > > > -endif
> > > > +ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG
> > > 
> > > If this is the way the whole kernel is going, I have no objection. 
> > 
> > Sam had implemented these newer style flag variables a while back as an
> > eloquent way of handling conditional flags. A lot of newer (and some older)
> > modules and subsystems were using them already, so to provide uniformity and for
> > an eventual removal of the deprecated flags, I converted all remaining instances
> > to the newer style. (IMHO, I think it flows better with the way the rest of the
> > build system works.)
> 
> Fine with me. What's the planned merge path for this patch? Will you
> push all the patches upstream yourself, or do you expect me to pick
> this one?

I was hoping subsystem maintainers would pick them up, but a lot of the patches
have been acked without being applied. My new plan is to have the unapplied ones
go through the kbuild tree. So you can either pick it up or just ack it.

Thanks,
mfm
