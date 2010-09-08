Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab0IHQMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:12:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53155 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab0IHQMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:12:48 -0400
Date: Wed, 8 Sep 2010 10:12:45 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jassi Brar <jassi.brar@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi/spi_s3c64xx: Move to subsys_initcall()
Message-ID: <20100908161245.GC3686@angua.secretlab.ca>
References: <1283855357-15179-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <AANLkTim=ArPyqC7K-aaer97deGeR6yU-FS1Hpm3D_1ER@mail.gmail.com>
 <20100908091242.GB31253@rakim.wolfsonmicro.main>
 <AANLkTimvc52yXuMFN2=qLKX1MSyTum1GHnLdDW8dMR=2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimvc52yXuMFN2=qLKX1MSyTum1GHnLdDW8dMR=2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 06:37:59PM +0900, Jassi Brar wrote:
> On Wed, Sep 8, 2010 at 6:12 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Wed, Sep 08, 2010 at 01:55:39PM +0900, Jassi Brar wrote:
> >> On Tue, Sep 7, 2010 at 7:29 PM, Mark Brown
> >> <broonie@opensource.wolfsonmicro.com> wrote:
> >> > Allow the use of the S3C64xx SPI controller with things like PMICs by
> >> > moving the init up to subsys_initcall().
> >
> >> Couldn't any user ever need to load it as a module?
> >> If no, we might as well drop the s3c64xx_spi_exit and s3c64xx_spi_remove
> >
> > This doesn't prevent building as a module - when built as a module
> > subsys_initcall() is identical to module_init(), the change will only
> > affect the order in which things are done when the code is built into
> > the kernel otherwise it's a noop.
> I didn't know that, thanks for the info.
> 
> Acked-by: Jassi Brar <jassi.brar@samsung.com>

Applied, thanks.

... but it seems to me that there is a systemic problem in the way the driver model is being used if SPI (and I2C) bus drivers need to be 'special' in this regard.  What are the ordering requirements on things like PMICs?  (My uneducated assumption is that other devices depend on them being enabled before being probed.)  Would it be better to have a mechanism to defer probing on certain devices until other devices are probed?  Then the relationships could be made explicit instead of the rather coarse-grained (and potentially fragile) approach of changing the init order.

g.
