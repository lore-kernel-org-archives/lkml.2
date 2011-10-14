Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab1JNOOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:14:37 -0400
Received: from lunge.queued.net ([173.255.254.236]:42944 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1JNOOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:14:36 -0400
Date: Fri, 14 Oct 2011 07:14:16 -0700
From: Andres Salomon <dilinger@queued.net>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jffs2: allow disabling of compression schemes at
 runtime
Message-ID: <20111014071416.5278051d@debxo>
In-Reply-To: <1318582244.12351.73.camel@sauron>
References: <20111003191624.7efd3dce@queued.net>
	<1318582244.12351.73.camel@sauron>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011 11:50:37 +0300
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> On Mon, 2011-10-03 at 19:16 -0700, Andres Salomon wrote:
> > Currently jffs2 has compile-time constants (and .config options)
> > regarding whether or not the various compression/decompression
> > drivers are built in and enabled.  This is fine for embedded
> > systems, but it clashes with distribution kernels.  Distro kernels
> > tend to turn on everything; this causes OpenFirmware to fall
> > over, as it only supports ZLIB decompression.  Booting a kernel
> > that has LZO compression enabled, writing to the boot partition,
> > and then rebooting causes OFW to fail to read the kernel from
> > the filesystem.  This is because LZO compression has priority
> > when writing new data to jffs2, if LZO is enabled.
> > 
> > To get around that, this patch adds jffs2 module params for each
> > compressor type that isn't decompression-only.  That means I can run
> > a kernel that has support for LZO and ZLIB decompression (allowing
> > me to read LZO data off of the root partition), while  disabling
> > LZO compression writes (jffs2.disable_lzo=1) so that the boot
> > partition stays compatible with OFW.
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> You should use mount options instead. Invent nice mount options to
> configure compression strategy of JFFS2.

I thought about it, but currently jffs2 doesn't support parsing
mount options.  It seemed like a lot of extra code for such an obscure
feature, on a filesystem that's merely in maintenance mode (I don't know
if anyone else has run into the same issue that I have).  However, I can
do that if desired.

> 
> Or you can simply implement the same option as UBIFS has: compr=xxx.
> 

Yep.

> See Documentation/filesystems/ubifs.txt
> 
> With this option you set the default compressor which is use when
> writing, and on reading all decompression are supported, seems like
> exactly what you want. You can also look how it is implemented in
> UBIFS for reference.
> 

