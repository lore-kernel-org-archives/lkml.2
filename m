Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab2HQNqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:46:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32874 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753049Ab2HQNpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:45:51 -0400
Date: Fri, 17 Aug 2012 14:45:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120817134515.GH24389@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
 <alpine.LFD.2.02.1208161438110.1541@xanadu.home>
 <201208171120.40740.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208171120.40740.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 12:20:40PM +0100, Arnd Bergmann wrote:
> On Thursday 16 August 2012, Nicolas Pitre wrote:
> > > +3. Decompress the kernel image
> > > +------------------------------
> > > +
> > > +Requirement: OPTIONAL
> > > +
> > > +The AArch64 kernel does not provide a decompressor and therefore
> > > +requires gzip decompression to be performed by the boot loader if the
> > > +default Image.gz target is used.  For bootloaders that do not implement
> > > +this requirement, the larger Image target is available instead.
> > 
> > Some people will want to use bzip2 or whatever other decompressor du 
> > jour.  Maybe this shouldn't be gzip specific, or just presented as a 
> > possible option?
> 
> Good point. Whether this should be part of this document depends on
> what assumptions we make about the boot loader getting the image
> in the first place.

It ended up here because there is a Makefile target, Image.gz, though I
haven't used it at all. I'll expand the text so that it is not
restricted to gzip.

> In the strict sense, we are documenting the interface between the boot
> loader and the kernel here, which already specifies that  the kernel
> must be uncompressed by the time we enter it. If the boot loader wants
> to add its own encryption or compression methods, or its own headers
> in front of the binary, the boot protocol isn't really impacted.

Yes.

> That said, I think it's a good idea to also specify what kind of
> format we want to be used, e.g. a stripped ELF Image compressed
> with one of gzip/bzip2/lzo/xz and with no other headers added,
> on a vfat/ext4/btrfs formatted file system. There are probably a
> lot of other things one might want to specify if we go down this
> route. Or we could refer to the UEFI spec and mandate that the
> same format that UEFI uses should be used here independent of
> what boot loader is used. I think we can still allow other ways to
> get to the image for deeply embedded systems, e.g. linking the
> kernel into the boot loader as a blob on tightly constrained
> systems. For that case, we'd only specify the interface between
> boot loader and kernel as described above.

At least the latter case is used on the model. For the other cases, it's
quite early to clearly specify what is needed as we don't currently have
a boot-loader other than UEFI. We may expect GRUB as well.

-- 
Catalin
