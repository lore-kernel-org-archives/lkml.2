Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab2EGNkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:40:47 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:45914 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2EGNkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:40:46 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
Organization: ScaleMP Ltd.
To: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] x86: Move x86_cpu_to_apicid to the __read_mostly section
Date: Mon, 7 May 2012 16:41:14 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32-41-generic; KDE/4.4.5; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
References: <201204241429.54089.vlad@scalemp.com> <20120507105247.GJ23002@gmail.com>
In-Reply-To: <20120507105247.GJ23002@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205071641.14946.vlad@scalemp.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 07, 2012 01:52:47 pm Ingo Molnar wrote:
> * Vlad Zolotarov <vlad@scalemp.com> wrote:
> > From: Shai Fultheim <shai@scalemp.com>
> > 
> > x86_cpu_to_apicid is only written to during initialization. Benchmarks
> > show that moving it to the __read_mostly section helps avoid false
> > sharing on large multiprocessing systems.
> > 
> > Signed-off-by: Shai Fultheim <shai@scalemp.com>
> > Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> > ---
> > 
> >  arch/x86/include/asm/smp.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> > index 0434c40..b9d6c1e 100644
> > --- a/arch/x86/include/asm/smp.h
> > +++ b/arch/x86/include/asm/smp.h
> > @@ -53,7 +53,7 @@ static inline struct cpumask *cpu_llc_shared_mask(int
> > cpu)
> > 
> >  	return per_cpu(cpu_llc_shared_map, cpu);
> >  
> >  }
> > 
> > -DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
> > +DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid);
> > 
> >  DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
> >  #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
> >  DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
> 
> Looks like all of the surrounding fields are read mostly as
> well, only initialized very rarely, during cpu init?

U r right. At least x86_bios_cpu_apicid is read mostly as well. I'll fix and 
respin.

Did u have a chance to look at the other "__read_mostly" patch for fs/buffer.c 
I've sent?

thanks,
vlad

> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
