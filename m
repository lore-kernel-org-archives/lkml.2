Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab1EZVpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:45:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39399 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab1EZVpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:45:11 -0400
Date: Thu, 26 May 2011 22:44:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/19] ARM: Add support for the Large Physical
	Address Extensions
Message-ID: <20110526214449.GK24876@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com> <20110523165412.GF15138@n2100.arm.linux.org.uk> <1306231448.19557.23.camel@e102109-lin.cambridge.arm.com> <BANLkTikjBm3tn4Q4T1r9qyB2ma88YydDZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikjBm3tn4Q4T1r9qyB2ma88YydDZQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:15:49PM +0100, Catalin Marinas wrote:
> On 24 May 2011 11:04, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Mon, 2011-05-23 at 17:54 +0100, Russell King - ARM Linux wrote:
> >> On Sun, May 08, 2011 at 01:51:19PM +0100, Catalin Marinas wrote:
> >> > This set of patches adds support for the Large Physical Extensions on
> >> > the ARM architecture (available with the Cortex-A15 processor). LPAE
> >> > comes with a 3-level page table format (compared to 2-level for the
> >> > classic one), allowing up to 40-bit physical address space.
> >> >
> >> > The ARM LPAE documentation is available from (free registration needed):
> >> >
> >> > http://infocenter.arm.com/help/topic/com.arm.doc.ddi0406b_virtualization_extns/index.html
> >> >
> >> > The full set of patches on top of linux-next (LPAE, support for an
> >> > emulated Versatile Express with Cortex-A15 tile and generic timers) is
> >> > available on this branch:
> >> >
> >> > git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-2.6-cm.git arm-lpae-next
> >>
> >> FYI, I'm going to drop the pgt patch because the warnings are still there
> >
> > What warnings are you seeing? Could you please post them?
> 
> Ping?
> 
> I'd like to fix those warning but I can't reproduce them (maybe
> different compiler versions?).

They're certainly not compiler version dependent (or if they are, your
compiler is broken).  It'll probably be because you're building for
SMP, in which case the affected code is not built:

arch/arm/mm/ioremap.c: In function ■unmap_area_sections■:
arch/arm/mm/ioremap.c:86: warning: passing argument 1 of ■pmd_offset■ from incompatible pointer type
arch/arm/mm/ioremap.c: In function ■remap_area_sections■:
arch/arm/mm/ioremap.c:136: warning: passing argument 1 of ■pmd_offset■ from incompatible pointer type
arch/arm/mm/ioremap.c: In function ■remap_area_supersections■:
arch/arm/mm/ioremap.c:173: warning: passing argument 1 of ■pmd_offset■ from incompatible pointer type

These need to be fixed before I push the pgt branch out into mainline,
otherwise I'm going to get nagged.
