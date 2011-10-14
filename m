Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1JNRxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:53:15 -0400
Received: from relais.videotron.ca ([24.201.245.36]:56644 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1JNRxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:53:14 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 14 Oct 2011 13:53:13 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Subject: RE: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
In-reply-to: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
Message-id: <alpine.LFD.2.02.1110141348270.17040@xanadu.home>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
 <20111014071500.GP21648@n2100.arm.linux.org.uk>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A260@HQMAIL01.nvidia.com>
 <201110141729.41515.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Stephen Warren wrote:

> Arnd Bergmann wrote at Friday, October 14, 2011 9:30 AM:
> ...
> > You mention that tegra30 will require AUTO_ZRELADDR.
> 
> Well, just to be clear, here's the situation I think:
> 
> Tegra20's SDRAM starts at physical address 0.
> 
> Tegra30's SDRAM starts at physical address 2G.
> 
> To support that, we could either:
> 
> a) Introduce a new Kconfig variable for Tegra30, make T20/T30 mutually
> exclusive, and update arch/arm/mach-tegra/Makefile.boot to set zreladdr
> etc. based on the new Tegra30 config variable too. Then, there's no need
> for AUTO_ZRELADDR anywhere.
> 
> b) Have no new config variable, build a unified T20/T30 kernel, leave
> Makefile.boot untouched, and rely on using AUTO_ZRELADDR for Tegra30 to
> account for the different SDRAM physical addresses.

As I explained yesterday, I'm working on more cleanups that involve
reworking the dependencies around ZBOOTROM, AUTO_ZRELADDR and friends, 
and removing zreladdr for all platforms.  So please do not come up with 
Tegra specific hacks to fix this up.  So for the time being I'd simply 
suggest using the minimal fix i.e.:

	select AUTO_ZRELADDR if !ZBOOT_ROM

And eventually this will disappear entirely in favor of a single global 
config option which is not platform dependent.


Nicolas
