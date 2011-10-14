Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1JNUUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:20:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57914 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab1JNUUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:20:09 -0400
Date: Fri, 14 Oct 2011 21:19:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@nvidia.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Message-ID: <20111014201953.GX21648@n2100.arm.linux.org.uk>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com> <201110141729.41515.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com> <201110141827.53906.arnd@arndb.de> <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com> <20111014192011.GS21648@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1110141549160.17040@xanadu.home> <20111014201223.GV21648@n2100.arm.linux.org.uk> <74CDBE0F657A3D45AFBB94109FB122FF173BE1A365@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A365@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 01:16:27PM -0700, Stephen Warren wrote:
> Russell King wrote at Friday, October 14, 2011 2:12 PM:
> > I don't think that's so with the various flavours of platform specific
> > uboot which float around.  For instance, on the OMAP4430 SDP, the
> > following commands were used as supplied to load a uImage off the SD
> > card into RAM at a different address to which it was built for, and
> > execute it at that address:
> > 
> > mmcinit 0
> > fatload mmc 0 0x80300000 uImage
> > bootm 80300000
> > 
> > Whether the 'bootm' command then copied the image and called it there,
> > or whether it executed it at 0x80300000 I've no idea - but why then
> > load the image at a different address in the first place?
> 
> Yes, U-Boot's image handling looks at the image at 80300000, extracts the
> "load address" from the image header, memcpy()'s the image to that address,
> then jumps to the "entry address" in the image header.

Ah, so specifying that address is just a total waste of space then,
because you might as well specify an address which results in the
copy not being necessary.

However, I'd expect that uboot is dumb enough to still do the copy
irrespective of whether its already in the right place.
