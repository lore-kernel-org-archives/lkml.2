Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab2GHKS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 06:18:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61508 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab2GHKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 06:18:26 -0400
Date: Sun, 8 Jul 2012 11:18:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120708101812.GE3845@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Sat, Jul 07, 2012 at 04:53:08AM +0100, Olof Johansson wrote:
> On Fri, Jul 6, 2012 at 2:05 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > ARM introduced AArch64 as part of the ARMv8 architecture
> 
> With the risk of bikeshedding here, but I find the name awkward. How
> about just naming the arch port arm64 instead? It's considerably more
> descriptive in the context of the kernel.  For reference, we didn't
> name ppc64, nor powerpc, after what the IBM/power.org marketing people
> were currently calling the architecture at the time either.

The name may not be as nice but AArch64 is the official architecture
name as per the (not yet released) ARM ARM. It's not a marketing name.
The complier triplet also uses it, so to avoid confusion I went with the
same. If you want a comparison, IA-64 is also coming form Intel but it
wasn't the architecture to be known as x86_64.

On the good side, alphabetically it's before arch/alpha :), so easier to
grep.

> > There is no hardware platform available at this point. From a kernel
> > perspective, the aim is to minimise (or even completely remove) the
> > platform code from the architecture specific directory. FDT is
> > currently mandated and there are ongoing discussions for ACPI
> > support.
> 
> This will be interesting to see how it plays out over time, and how
> many vendors will drop in arm64 cores on their existing designs and
> thus need to pull over infrastructure from arch/arm for their platform
> type. A lot of the drivers have moved out to common code so much of it
> should be possible to do cleanly, but there is still some risk for
> duplication.
> 
> I guess it's a good chance to clean up some of it and start from a
> clean slate, if you can avoid the temptation of just moving over code.

I agree, it's a great advantage to start with a clean port and I will
try as much as possible to keep the SoC code duplication to a minimum.
We'll also benefit from the experience of the arm-soc team, which I see
as taking active role in the AArch64 SoC support.

The architecture is also in a much better shape with generic timers, GIC
(though not the GICv2 version that we have on arch/arm/) so most of the
remaining SoC code would belong to drivers/. There is still debate
around CPU boot and power management and the firmware involvement and we
try to standardise this as well. Basically AArch64 Linux only runs in
non-secure mode but some operations require secure side code.

Thanks.

-- 
Catalin
