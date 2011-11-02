Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029Ab1KBTkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:40:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35037 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1KBTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:40:17 -0400
Date: Wed, 2 Nov 2011 19:39:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>, Nicolas Pitre <nico@fluxnic.net>
Cc: Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Gary King <gking@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/tegra: add support for tegra30 interrupts
Message-ID: <20111102193947.GD12913@n2100.arm.linux.org.uk>
References: <1320248292-22736-1-git-send-email-pdeschrijver@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173F9A46E5@HQMAIL01.nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173F9A4758@HQMAIL01.nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173F9A47A7@HQMAIL01.nvidia.com> <20111102192112.GC12913@n2100.arm.linux.org.uk> <20111102192625.GD14372@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102192625.GD14372@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 09:26:26PM +0200, Felipe Balbi wrote:
> would it be better to just change the default value in
> arm-generic/gpio.h to something very large ?
> 
> I mean, ideally that wouldn't be gpio_desc wouldn't be an array anyway
> right ?

You'll excuse me if I take this slightly personally.

You really can't expect me to say that I'm fine with a 6K growth in
kernel size for something that not every platform needs if there's
been objections to maybe a 128 byte growth for including the V:P
patching code in the kernel by default.

Either we care about memory usage or we don't.  If we don't, lets get
rid of offering ARM_PATCH_PHYS_VIRT in any configuration and always
build with the dynamic V:P stuff enabled for the trivial cases.  I
mean:

 config ARM_PATCH_PHYS_VIRT
-	bool "Patch physical to virtual translations at runtime" if EMBEDDED
+	bool
	default y
	depends on !XIP_KERNEL && MMU
	depends on !ARCH_REALVIEW || !SPARSEMEM
