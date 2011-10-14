Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab1JNOXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:23:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44983 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab1JNOX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:23:29 -0400
Subject: Re: [PATCH] jffs2: allow disabling of compression schemes at runtime
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Oct 2011 17:22:59 +0300
In-Reply-To: <20111014071416.5278051d@debxo>
References: <20111003191624.7efd3dce@queued.net>
	 <1318582244.12351.73.camel@sauron> <20111014071416.5278051d@debxo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318602186.12351.141.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 07:14 -0700, Andres Salomon wrote:
> On Fri, 14 Oct 2011 11:50:37 +0300
> Artem Bityutskiy <dedekind1@gmail.com> wrote:
> 
> > On Mon, 2011-10-03 at 19:16 -0700, Andres Salomon wrote:
> > > Currently jffs2 has compile-time constants (and .config options)
> > > regarding whether or not the various compression/decompression
> > > drivers are built in and enabled.  This is fine for embedded
> > > systems, but it clashes with distribution kernels.  Distro kernels
> > > tend to turn on everything; this causes OpenFirmware to fall
> > > over, as it only supports ZLIB decompression.  Booting a kernel
> > > that has LZO compression enabled, writing to the boot partition,
> > > and then rebooting causes OFW to fail to read the kernel from
> > > the filesystem.  This is because LZO compression has priority
> > > when writing new data to jffs2, if LZO is enabled.
> > > 
> > > To get around that, this patch adds jffs2 module params for each
> > > compressor type that isn't decompression-only.  That means I can run
> > > a kernel that has support for LZO and ZLIB decompression (allowing
> > > me to read LZO data off of the root partition), while  disabling
> > > LZO compression writes (jffs2.disable_lzo=1) so that the boot
> > > partition stays compatible with OFW.
> > > 
> > > Signed-off-by: Andres Salomon <dilinger@queued.net>
> > 
> > You should use mount options instead. Invent nice mount options to
> > configure compression strategy of JFFS2.
> 
> I thought about it, but currently jffs2 doesn't support parsing
> mount options.  It seemed like a lot of extra code for such an obscure
> feature, on a filesystem that's merely in maintenance mode (I don't know
> if anyone else has run into the same issue that I have).  However, I can
> do that if desired.

Yeah, but module parameter for FS is very unusual thing. It should not
be very difficult to introduce an option, really. Mount and remount just
give you the string where you can find every non-standard mount option.
And you can copypaste parts UBIFS code and tweak it.

-- 
Best Regards,
Artem Bityutskiy

