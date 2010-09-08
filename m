Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab0IHJMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:12:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58883 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752714Ab0IHJMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:12:45 -0400
Date: Wed, 8 Sep 2010 10:12:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Jassi Brar <jassi.brar@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi/spi_s3c64xx: Move to subsys_initcall()
Message-ID: <20100908091242.GB31253@rakim.wolfsonmicro.main>
References: <1283855357-15179-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <AANLkTim=ArPyqC7K-aaer97deGeR6yU-FS1Hpm3D_1ER@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim=ArPyqC7K-aaer97deGeR6yU-FS1Hpm3D_1ER@mail.gmail.com>
X-Cookie: Crazee Edeee, his prices are INSANE!!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 01:55:39PM +0900, Jassi Brar wrote:
> On Tue, Sep 7, 2010 at 7:29 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > Allow the use of the S3C64xx SPI controller with things like PMICs by
> > moving the init up to subsys_initcall().

> Couldn't any user ever need to load it as a module?
> If no, we might as well drop the s3c64xx_spi_exit and s3c64xx_spi_remove

This doesn't prevent building as a module - when built as a module
subsys_initcall() is identical to module_init(), the change will only
affect the order in which things are done when the code is built into
the kernel otherwise it's a noop.

> as well and save space. Rather going a step further, shouldn't then all
> spi drivers be that way? Two steps further, why not every 'bus-driver' ?

Yes, we probably do need to do the same thing for all embedded SPI
controllers (as has already happened with embedded I2C controllers),
though it's less pressing since outside of a few CPUs it's much less
common for things like PMICs to be on SPI than I2C.
