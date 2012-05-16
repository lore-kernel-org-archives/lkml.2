Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab2EPNkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:40:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab2EPNkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:40:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] driver: char: bfin_crc: CRC hardware accelerator driver for BF60x family processors.
Date: Wed, 16 May 2012 13:39:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: sonic.zhang@analog.com, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
References: <1337156767-13232-1-git-send-email-sonic.zhang@analog.com> <20120516121237.GC31261@kroah.com>
In-Reply-To: <20120516121237.GC31261@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205161339.41736.arnd@arndb.de>
X-Provags-ID: V02:K0:LCS7nrYCkl84rjWXwp20vwSwyWz9+SUfIPbXZ6HTiQ1
 XVMrwsPq8v7D+JKDSwZeSGlLoqlFiH3KjIBpkpKiVvwhEmzHh7
 elkdXsL72xipjgV7lq9LX0hP7RDAZ6kaBSb3YS4Od6xkrn5upQ
 nUHiNFG3RkHgMydbNq3lTfWxPoYUitrlj4HwZ5k2Pgo+26vlIq
 uYV6S/84DphXZntPk6h8OrIZ81dOJK91ntWp5oQ+Q+Cjt7Rv2r
 dRJCxKrqBDK8KVoQJjVzysJT8FweBj0Q2F80ysnuq6ZYalmKYr
 XESc+0E84j3a5M2+XL/14qQgODJ3skyBs3COZC42bvwtRgum4V
 j5kvMmHgeSAB59gdPqAc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2012, Greg Kroah-Hartman wrote:
> On Wed, May 16, 2012 at 04:26:07PM +0800, sonic.zhang@analog.com wrote:
> > From: Sonic Zhang <sonic.zhang@analog.com>
> > 
> > The CRC peripheral is a hardware block used to compute the CRC of the block
> > of data. This is based on a CRC32 engine which computes the CRC value of 32b
> > data words presented to it. For data words of < 32b in size, it is the
> > responsibility of the application to pack the data into 32b data units.
> > 
> > This driver defines data strcture crc_info and 4 IOCTL interfaces for applciations.
> > 1) CRC Memory Scan
> > 2) CRC Memory Transfer
> > 3) CRC Data Verify
> > 4) CRC Data Fill
> > 
> > Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> > ---
> >  drivers/char/Kconfig    |    8 +
> >  drivers/char/Makefile   |    1 +
> >  drivers/char/bfin_crc.c |  537 +++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 546 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/char/bfin_crc.c
> 
> Why is this a char driver, and not a crypto driver, using the existing
> crypto userspace api for things like this?

Do we have a userspace crypto API these days? The last I remember every
attempt to add one so far was abandoned before it got merged. There is
drivers/s390/crypto/zcrypt*, which has a nonportable API, and 
then there is the in-kernel crypto layer in drivers/crypto that has
no user interface at all.

I agree that having another private driver for bfin_crc is not a good
idea, but I also don't have a better one.

About the driver itself, the submission seems incomplete (missing at
least the bfin_crc.h file) and the driver has a number of shortcomings
that we should discuss in case we decide to merge it.

	Arnd
