Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1JNUGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:06:23 -0400
Received: from relais.videotron.ca ([24.201.245.36]:48195 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1JNUGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:06:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 14 Oct 2011 16:06:21 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
In-reply-to: <20111014192011.GS21648@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.02.1110141549160.17040@xanadu.home>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
 <201110141729.41515.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
 <201110141827.53906.arnd@arndb.de>
 <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com>
 <20111014192011.GS21648@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Russell King - ARM Linux wrote:

> But... one thing to note is that it _is_ common to load the decompressor
> at a _different_ address to that where the kernel ultimately ends up
> residing to avoid the additional copy in the decompressor.  My experience
> shows that this is quite common on the platforms I had supplied.  This
> means that if we default to AUTO_ZRELADDR for !ZBOOT_ROM, we end up
> having to have developers change their uboot setups to avoid unexpected
> results.

Currently, U-Boot insists on having a uImage with a fixed absolute load 
address.  This is currently provided by the zreladdr value, whether or 
not AUTO_ZRELADDR is set.  I consider this as a persisting uImage 
limitation.

Either u-Boot gets fixed so it can work with plain zImage (and this 
certainly will happen once the pressure from people wanting a single 
kernel to work on targets with different load addresses increase.  
Tegra is one such example.

Or we create a u-Boot specific Kconfig menu for uImage options that 
would be common to all architectures and kick it out from the ARM 
specific makefile.  This is not solving the u-Boot limitation though.

In either cases this is a u-Boot problem that needs fixing on the u-Boot 
side in the end.


Nicolas
