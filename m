Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900Ab2CNMJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 08:09:45 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:46412 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab2CNMJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 08:09:43 -0400
Message-ID: <4F608A15.9030609@snapgear.com>
Date: Wed, 14 Mar 2012 22:07:49 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: <paul.gortmaker@windriver.com>, <hpa@zytor.com>,
        <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <arnd@arndb.de>,
        <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 13/35] Disintegrate asm/system.h for M68K [ver #2]
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233816.13888.142.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233816.13888.142.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 03/13/2012 09:38 AM, David Howells wrote:
> Disintegrate asm/system.h for M68K.
>
> Signed-off-by: David Howells<dhowells@redhat.com>
> cc: linux-m68k@lists.linux-m68k.org
> ---
>
>   arch/m68k/amiga/amisound.c          |    1
>   arch/m68k/amiga/config.c            |    1
>   arch/m68k/apollo/config.c           |    1
>   arch/m68k/atari/ataints.c           |    1
>   arch/m68k/atari/atasound.c          |    1
>   arch/m68k/atari/config.c            |    1
>   arch/m68k/bvme6000/config.c         |    1
>   arch/m68k/bvme6000/rtc.c            |    1
>   arch/m68k/hp300/time.c              |    1
>   arch/m68k/include/asm/atomic.h      |    2
>   arch/m68k/include/asm/barrier.h     |   20 ++++
>   arch/m68k/include/asm/cmpxchg.h     |  129 +++++++++++++++++++++++
>   arch/m68k/include/asm/exec.h        |    6 +
>   arch/m68k/include/asm/sun3xflop.h   |    1
>   arch/m68k/include/asm/switch_to.h   |   41 +++++++
>   arch/m68k/include/asm/system.h      |  198 +----------------------------------
>   arch/m68k/kernel/ints.c             |    1
>   arch/m68k/kernel/irq.c              |    1
>   arch/m68k/kernel/process_mm.c       |    1
>   arch/m68k/kernel/process_no.c       |    1
>   arch/m68k/kernel/ptrace_mm.c        |    1
>   arch/m68k/kernel/ptrace_no.c        |    1
>   arch/m68k/kernel/traps.c            |    1
>   arch/m68k/kernel/vectors.c          |    1
>   arch/m68k/mac/config.c              |    1
>   arch/m68k/mac/misc.c                |    1
>   arch/m68k/mm/fault.c                |    1
>   arch/m68k/mm/init_mm.c              |    1
>   arch/m68k/mm/init_no.c              |    1
>   arch/m68k/mm/kmap.c                 |    1
>   arch/m68k/mm/memory.c               |    1
>   arch/m68k/mm/motorola.c             |    1
>   arch/m68k/mm/sun3mmu.c              |    1
>   arch/m68k/mvme147/config.c          |    1
>   arch/m68k/mvme16x/config.c          |    1
>   arch/m68k/mvme16x/rtc.c             |    1
>   arch/m68k/platform/68328/config.c   |    1
>   arch/m68k/platform/68328/timers.c   |    1
>   arch/m68k/platform/68360/config.c   |    1
>   arch/m68k/platform/68EZ328/config.c |    1
>   arch/m68k/platform/68VZ328/config.c |    1
>   arch/m68k/q40/config.c              |    1
>   arch/m68k/q40/q40ints.c             |    1
>   arch/m68k/sun3/intersil.c           |    1
>   arch/m68k/sun3/mmu_emu.c            |    1
>   arch/m68k/sun3/prom/console.c       |    1
>   arch/m68k/sun3x/config.c            |    1
>   arch/m68k/sun3x/time.c              |    1
>   48 files changed, 202 insertions(+), 236 deletions(-)
>   create mode 100644 arch/m68k/include/asm/barrier.h
>   create mode 100644 arch/m68k/include/asm/cmpxchg.h
>   create mode 100644 arch/m68k/include/asm/exec.h
>   create mode 100644 arch/m68k/include/asm/switch_to.h
>
[snip]
 >
> diff --git a/arch/m68k/include/asm/cmpxchg.h b/arch/m68k/include/asm/cmpxchg.h
> new file mode 100644
> index 0000000..f8acc0f
> --- /dev/null
> +++ b/arch/m68k/include/asm/cmpxchg.h
> @@ -0,0 +1,129 @@
> +#ifndef __ARCH_M68K_CMPXCHG__
> +#define __ARCH_M68K_CMPXCHG__
> +
> +#include<linux/irqflags.h>
> +
> +struct __xchg_dummy { unsigned long a[100]; };
> +#define __xg(x) ((volatile struct __xchg_dummy *)(x))
> +
> +#ifndef CONFIG_RMW_INSNS
> +static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
> +{
> +	unsigned long flags, tmp;
> +
> +	local_irq_save(flags);
> +
> +	switch (size) {
> +	case 1:
> +		tmp = *(u8 *)ptr;
> +		*(u8 *)ptr = x;
> +		x = tmp;
> +		break;
> +	case 2:
> +		tmp = *(u16 *)ptr;
> +		*(u16 *)ptr = x;
> +		x = tmp;
> +		break;
> +	case 4:
> +		tmp = *(u32 *)ptr;
> +		*(u32 *)ptr = x;
> +		x = tmp;
> +		break;
> +	default:
> +		BUG();

This breaks compilation for m68k targets with:

   CC      net/ipv4/ip_input.o
In file included from 
/home/gerg/new-wave.320/linux-3.x/arch/m68k/include/asm/system.h:3:0,
                  from net/ipv4/ip_input.c:116:
/home/gerg/new-wave.320/linux-3.x/arch/m68k/include/asm/cmpxchg.h: In 
function ‘__xchg’:
/home/gerg/new-wave.320/linux-3.x/arch/m68k/include/asm/cmpxchg.h:33:3: 
error: implicit declaration of function ‘BUG’

The old system.h included linux/kernel.h which includes asm/bug.h.
Just including asm/bug.h here in cmpxchg.h is not enough to fix it.
If you include linux/kernel.h though it compiles cleanly.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
