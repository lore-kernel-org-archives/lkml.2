Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1KQLs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:48:58 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56671 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab1KQLs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:48:56 -0500
Date: Thu, 17 Nov 2011 12:48:52 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <greg@kroah.com>, linux-stable <stable@vger.kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86, amd: Avoid cache aliasing penalties on AMD
 family 15h
Message-ID: <20111117114852.GA22750@aftab>
References: <20111104112209.GB8020@aftab>
 <1320405995-10199-1-git-send-email-bp@amd64.org>
 <20111104152532.GB29754@kroah.com>
 <20111116232136.GA3533@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116232136.GA3533@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, let's ping them directly.

x86 guys, do you have an issue with me backporting the aliasing fix to
3.x stable?

I know it doesn't adhere completely to -stable rules for it not being a
regression. Well, think of it as a hardware regression and me trying to
cover all bases :-).

Thanks.

On Wed, Nov 16, 2011 at 03:21:36PM -0800, Greg KH wrote:
> On Fri, Nov 04, 2011 at 08:25:32AM -0700, Greg KH wrote:
> > On Fri, Nov 04, 2011 at 12:26:32PM +0100, Borislav Petkov wrote:
> > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > > Upstream commit: dfb09f9b7ab03fd367740e541a5caf830ed56726
> > > 
> > > This patch provides performance tuning for the "Bulldozer" CPU. With its
> > > shared instruction cache there is a chance of generating an excessive
> > > number of cache cross-invalidates when running specific workloads on the
> > > cores of a compute module.
> > > 
> > > This excessive amount of cross-invalidations can be observed if cache
> > > lines backed by shared physical memory alias in bits [14:12] of their
> > > virtual addresses, as those bits are used for the index generation.
> > > 
> > > This patch addresses the issue by clearing all the bits in the [14:12]
> > > slice of the file mapping's virtual address at generation time, thus
> > > forcing those bits the same for all mappings of a single shared library
> > > across processes and, in doing so, avoids instruction cache aliases.
> > > 
> > > It also adds the command line option "align_va_addr=(32|64|on|off)" with
> > > which virtual address alignment can be enabled for 32-bit or 64-bit x86
> > > individually, or both, or be completely disabled.
> > > 
> > > This change leaves virtual region address allocation on other families
> > > and/or vendors unaffected.
> > > 
> > > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > > Link: http://lkml.kernel.org/r/1312550110-24160-2-git-send-email-bp@amd64.org
> > > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > > ---
> > >  Documentation/kernel-parameters.txt |   13 ++++++
> > >  arch/x86/include/asm/elf.h          |   31 +++++++++++++
> > >  arch/x86/kernel/cpu/amd.c           |   13 ++++++
> > >  arch/x86/kernel/sys_x86_64.c        |   81 +++++++++++++++++++++++++++++++++-
> > >  arch/x86/mm/mmap.c                  |   15 ------
> > >  arch/x86/vdso/vma.c                 |    9 ++++
> > >  6 files changed, 144 insertions(+), 18 deletions(-)
> > 
> > I really feel nervous adding this patch to the -stable tree(s).  It's
> > bigger than "just a bugfix" and it adds new functionality.
> > 
> > I'm aware that it is needed for your new hardware, which is great, but
> > it doesn't really follow the Documentation/stable_kernel_rules.txt
> > requirements, does it?
> > 
> > I need an ACK from the x86 maintainers before I'm going to be
> > comfortable adding this, and then the other, patches in this series.
> > 
> > Peter, Ingo, Thomas, your opinions?
> 
> Ping?
> 
> anyone?
> 
> greg k-h
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
