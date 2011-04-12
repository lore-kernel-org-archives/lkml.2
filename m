Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab1DLJrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:47:51 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44445 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1DLJrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:47:49 -0400
Date: Tue, 12 Apr 2011 11:47:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Dooks <ben-linux@fluff.org>
Cc: Baruch Siach <baruch@tkos.co.il>, linux-i2c@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next reresend] i2c: designware-pcidrv depends on PCI
Message-ID: <20110412114722.0f2e67d6@endymion.delvare>
In-Reply-To: <BANLkTikX_rG+6Eg4owary1YRGRG8NzyrGQ@mail.gmail.com>
References: <20110408083215.6b3b0bfe.randy.dunlap@oracle.com>
	<BANLkTikX_rG+6Eg4owary1YRGRG8NzyrGQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert, Randy,

On Sat, 9 Apr 2011 13:34:49 +0200, Geert Uytterhoeven wrote:
> On Fri, Apr 8, 2011 at 17:32, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > i2c-designware-pcidrv is a PCI driver and should depend on PCI.
> > Fixes these build errors:
> >
> > drivers/i2c/busses/i2c-designware-pcidrv.c:256: error: implicit declaration of function 'pci_request_region'
> > drivers/i2c/busses/i2c-designware-pcidrv.c:338: error: implicit declaration of function 'pci_release_region'
> >
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  drivers/i2c/busses/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > Does anybody merge i2c patches???
> 
> Yes please, it's been there since Mar 17, reported several times, and probably
> masking other build failures.

This bug only exists in linux-next, as the code in question wasn't
merged in Linus's tree yet. It is drawn into linux-next from Ben
Dooks's next-i2c branch:
  http://git.fluff.org/gitweb?p=bjdooks/linux.git;a=shortlog;h=refs/heads/next-i2c

This is where it has to be fixed, so only Ben can do it. Ben, please?

Meanwhile, it should be possible to apply a hot fix to linux-next
directly, Stephen does it pretty often. Stephen, could you please apply
this fix temporarily until Ben wakes up and applies it to his tree?

> > --- linux-next-20110316.orig/drivers/i2c/busses/Kconfig
> > +++ linux-next-20110316/drivers/i2c/busses/Kconfig
> > @@ -359,6 +359,7 @@ config I2C_DESIGNWARE_PLATFORM
> >
> >  config I2C_DESIGNWARE_PCI
> >        tristate "Synopsys DesignWare PCI"
> > +       depends on PCI
> >        help
> >          If you say yes to this option, support will be included for the
> >          Synopsys DesignWare I2C adapter. Only master mode is supported.

-- 
Jean Delvare
