Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab1JNP3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:29:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60236 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab1JNP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:29:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Date: Fri, 14 Oct 2011 17:29:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com> <20111014071500.GP21648@n2100.arm.linux.org.uk> <74CDBE0F657A3D45AFBB94109FB122FF173BE1A260@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A260@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110141729.41515.arnd@arndb.de>
X-Provags-ID: V02:K0:hK4TJiqsHrhiPfc9FasvIyckgWxtLd0jpIEsH3tmqQD
 4uUl2n4s1DQA/cad0KEytxvQ5HjOodNqnHsZPwDG7KtAluv1RM
 oaG/loVk1OxIRFISljzdvOvwU9b5c2Vd387sV+TrpgaBx/Xqr5
 ELzPjl56J20YbFYDD6g7TDJ/KzEfZiSw8vgqtVn9XaPS4dPxsh
 JtCCob8AjZl1rCnoK664qcDGmsD5+Z7AnVuwaCtPz9bOp6CEe9
 CVBsRFPewG0Si4akRhD1QUa7XAQsWrlLTSgI971tL6DdHX4OER
 NgcauxkRuki6xddFuBHcHO10NPt4c2GvwBFQmIZy7cxB59v3xM
 5cYT4ZZN8EL//QhzlqAE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 October 2011, Stephen Warren wrote:
> Russell King wrote at Friday, October 14, 2011 1:15 AM:
> > On Thu, Oct 13, 2011 at 04:38:46PM -0700, Olof Johansson wrote:
> > 
> > I'll point out that this makes Tegra incompatible with ZBOOT_ROM, which
> > can still be enabled.  ZBOOT_ROM=y AUTO_ZRELADDR=y is an invalid
> > configuration at runtime.
> 
> I see that at least one machine solves that by doing:
> 
> config ARCH_EP93XX
> ...
>         select AUTO_ZRELADDR if !ZBOOT_ROM
> 
> That said, given the way Tegra works, ZBOOT_ROM isn't useful; typically,
> systems don't use NOR flash for storage of the kernel, so I don't think
> ZBOOT_ROM is likely to be used. Perhaps we should just depend on !ZBOOT_ROM?

That sounds like a correct fix, but also confusing because the top-level
subarchitecture selection should not depend on too many things that are
not obvious to someone configuring the kernel. From the perspective
of least suprise I would think that instead ZBOOTROM should depend on
!ARCH_TEGRA, but there is no precedent for this in the current Kconfig.

You mention that tegra30 will require AUTO_ZRELADDR. Does that mean that
with tegra30 merged you would no longer be able to build any tegra
kernel? If not, the best solution for now would probably be to
put AUTO_ZRELADDR into the defconfig for now (provided that tegra20 can
still boot without it) and make tegra30 depend on AUTO_ZRELADDR within
the tegra Kconfig.

This is only a temporary solution I think, because it is one of the
areas that we will have to revisit once we make it possible to combine
multiple subarchitectures into a single kernel. I have some ideas how
I would express that in Kconfig but I'm sure that we will have a lot
of debate over it before we coem to a solution that works for everyone.

	Arnd
