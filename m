Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966554Ab2EQNlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 09:41:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54166 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966361Ab2EQNk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 09:40:59 -0400
Date: Thu, 17 May 2012 06:40:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH] driver: char: bfin_crc: CRC hardware accelerator driver
 for BF60x family processors.
Message-ID: <20120517134054.GC5380@kroah.com>
References: <1337156767-13232-1-git-send-email-sonic.zhang@analog.com>
 <20120516121237.GC31261@kroah.com>
 <DB904C5425BA6F4E8424B3B51A1414D16F64F85057@NWD2CMBX1.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D16F64F85057@NWD2CMBX1.ad.analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 06:55:36AM -0400, Zhang, Sonic wrote:
> Hi Greg,
> 
> >-----Original Message-----
> >From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> >Sent: Wednesday, May 16, 2012 8:13 PM
> >To: Zhang, Sonic
> >Cc: Arnd Bergmann; LKML; uclinux-dist-devel@blackfin.uclinux.org
> >Subject: Re: [PATCH] driver: char: bfin_crc: CRC hardware accelerator driver for
> >BF60x family processors.
> >
> >On Wed, May 16, 2012 at 04:26:07PM +0800, sonic.zhang@analog.com wrote:
> >> From: Sonic Zhang <sonic.zhang@analog.com>
> >>
> >> The CRC peripheral is a hardware block used to compute the CRC of the block
> >> of data. This is based on a CRC32 engine which computes the CRC value of 32b
> >> data words presented to it. For data words of < 32b in size, it is the
> >> responsibility of the application to pack the data into 32b data units.
> >>
> >> This driver defines data strcture crc_info and 4 IOCTL interfaces for applciations.
> >> 1) CRC Memory Scan
> >> 2) CRC Memory Transfer
> >> 3) CRC Data Verify
> >> 4) CRC Data Fill
> >>
> >> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> >> ---
> >>  drivers/char/Kconfig    |    8 +
> >>  drivers/char/Makefile   |    1 +
> >>  drivers/char/bfin_crc.c |  537
> >+++++++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 546 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/char/bfin_crc.c
> >
> >Why is this a char driver, and not a crypto driver, using the existing
> >crypto userspace api for things like this?
> >
> 
> It looks only the CRC memory scan mode can be implemented as a crypto
> ahash driver. The other 3 functions are not supported in the crypto
> framework.  I will post a crypto driver for the CRC memory scan mode
> later.

Then why not extend the crypto framework to handle these 3 other
functions?

greg k-h
