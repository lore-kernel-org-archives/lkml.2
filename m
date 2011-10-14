Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab1JNUMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:12:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45603 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab1JNUMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:12:41 -0400
Date: Fri, 14 Oct 2011 21:12:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Message-ID: <20111014201223.GV21648@n2100.arm.linux.org.uk>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com> <201110141729.41515.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com> <201110141827.53906.arnd@arndb.de> <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com> <20111014192011.GS21648@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1110141549160.17040@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110141549160.17040@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:06:21PM -0400, Nicolas Pitre wrote:
> Currently, U-Boot insists on having a uImage with a fixed absolute load 
> address.  This is currently provided by the zreladdr value, whether or 
> not AUTO_ZRELADDR is set.  I consider this as a persisting uImage 
> limitation.
> 
> Either u-Boot gets fixed so it can work with plain zImage (and this 
> certainly will happen once the pressure from people wanting a single 
> kernel to work on targets with different load addresses increase.  
> Tegra is one such example.
> 
> Or we create a u-Boot specific Kconfig menu for uImage options that 
> would be common to all architectures and kick it out from the ARM 
> specific makefile.  This is not solving the u-Boot limitation though.
> 
> In either cases this is a u-Boot problem that needs fixing on the u-Boot 
> side in the end.

I don't think that's so with the various flavours of platform specific
uboot which float around.  For instance, on the OMAP4430 SDP, the
following commands were used as supplied to load a uImage off the SD
card into RAM at a different address to which it was built for, and
execute it at that address:

mmcinit 0
fatload mmc 0 0x80300000 uImage
bootm 80300000

Whether the 'bootm' command then copied the image and called it there,
or whether it executed it at 0x80300000 I've no idea - but why then
load the image at a different address in the first place?
