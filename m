Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2EGOHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:07:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58975 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab2EGOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:07:50 -0400
Date: Mon, 7 May 2012 16:07:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/2] x86: Move x86_cpu_to_apicid to the __read_mostly
 section
Message-ID: <20120507140744.GA28254@gmail.com>
References: <201204241429.54089.vlad@scalemp.com>
 <20120507105247.GJ23002@gmail.com>
 <201205071641.14946.vlad@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205071641.14946.vlad@scalemp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vlad Zolotarov <vlad@scalemp.com> wrote:

> On Monday, May 07, 2012 01:52:47 pm Ingo Molnar wrote:
> > * Vlad Zolotarov <vlad@scalemp.com> wrote:
> > > From: Shai Fultheim <shai@scalemp.com>
> > > 
> > > x86_cpu_to_apicid is only written to during initialization. Benchmarks
> > > show that moving it to the __read_mostly section helps avoid false
> > > sharing on large multiprocessing systems.
> > > 
> > > Signed-off-by: Shai Fultheim <shai@scalemp.com>
> > > Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> > > ---
> > > 
> > >  arch/x86/include/asm/smp.h |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> > > index 0434c40..b9d6c1e 100644
> > > --- a/arch/x86/include/asm/smp.h
> > > +++ b/arch/x86/include/asm/smp.h
> > > @@ -53,7 +53,7 @@ static inline struct cpumask *cpu_llc_shared_mask(int
> > > cpu)
> > > 
> > >  	return per_cpu(cpu_llc_shared_map, cpu);
> > >  
> > >  }
> > > 
> > > -DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
> > > +DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid);
> > > 
> > >  DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
> > >  #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
> > >  DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
> > 
> > Looks like all of the surrounding fields are read mostly as
> > well, only initialized very rarely, during cpu init?
> 
> U r right. At least x86_bios_cpu_apicid is read mostly as 
> well. I'll fix and respin.

Thanks.

> Did u have a chance to look at the other "__read_mostly" patch for fs/buffer.c 
> I've sent?

Haven't been involved with fs/buffer.c for some time, please 
send it to the relevant maintainer:

 $ scripts/get_maintainer.pl -f fs/buffer.c 
 Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS...)
 linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS...)
 linux-kernel@vger.kernel.org (open list)

Thanks,

	Ingo
