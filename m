Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2EPOxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:53:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36521 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2EPOxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:53:38 -0400
Date: Wed, 16 May 2012 07:53:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: sonic.zhang@analog.com, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] driver: char: bfin_crc: CRC hardware accelerator driver
 for BF60x family processors.
Message-ID: <20120516145333.GB1139@kroah.com>
References: <1337156767-13232-1-git-send-email-sonic.zhang@analog.com>
 <20120516121237.GC31261@kroah.com>
 <201205161339.41736.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205161339.41736.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 01:39:41PM +0000, Arnd Bergmann wrote:
> On Wednesday 16 May 2012, Greg Kroah-Hartman wrote:
> > On Wed, May 16, 2012 at 04:26:07PM +0800, sonic.zhang@analog.com wrote:
> > > From: Sonic Zhang <sonic.zhang@analog.com>
> > > 
> > > The CRC peripheral is a hardware block used to compute the CRC of the block
> > > of data. This is based on a CRC32 engine which computes the CRC value of 32b
> > > data words presented to it. For data words of < 32b in size, it is the
> > > responsibility of the application to pack the data into 32b data units.
> > > 
> > > This driver defines data strcture crc_info and 4 IOCTL interfaces for applciations.
> > > 1) CRC Memory Scan
> > > 2) CRC Memory Transfer
> > > 3) CRC Data Verify
> > > 4) CRC Data Fill
> > > 
> > > Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> > > ---
> > >  drivers/char/Kconfig    |    8 +
> > >  drivers/char/Makefile   |    1 +
> > >  drivers/char/bfin_crc.c |  537 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 546 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/char/bfin_crc.c
> > 
> > Why is this a char driver, and not a crypto driver, using the existing
> > crypto userspace api for things like this?
> 
> Do we have a userspace crypto API these days? The last I remember every
> attempt to add one so far was abandoned before it got merged. There is
> drivers/s390/crypto/zcrypt*, which has a nonportable API, and 
> then there is the in-kernel crypto layer in drivers/crypto that has
> no user interface at all.

What is CONFIG_CRYPTO_USER for then, with the matching,
crypto/crypto_user.c file?

> I agree that having another private driver for bfin_crc is not a good
> idea, but I also don't have a better one.
> 
> About the driver itself, the submission seems incomplete (missing at
> least the bfin_crc.h file) and the driver has a number of shortcomings
> that we should discuss in case we decide to merge it.

I suggest at least tieing into the in-kernel crypto api first, and then
worrying about the userspace side of things, right?

thanks,

greg k-h
