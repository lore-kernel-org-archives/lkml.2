Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422836Ab2JXWsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:48:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62376 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422655Ab2JXWst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:48:49 -0400
Message-ID: <50887042.9040703@gmail.com>
Date: Wed, 24 Oct 2012 15:48:34 -0700
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@gmail.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com> <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
In-Reply-To: <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding H. Peter Anvin to the Cc list.

Best,

- Juri

On 10/24/2012 02:53 PM, Juri Lelli wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Grow rudimentary u128 support without relying on gcc/libgcc.
>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-pppjsy9fz2v57x98hsts2cj3@git.kernel.org
> ---
>   arch/alpha/include/asm/Kbuild      |    1 +
>   arch/arm/include/asm/Kbuild        |    1 +
>   arch/avr32/include/asm/Kbuild      |    2 +
>   arch/blackfin/include/asm/Kbuild   |    1 +
>   arch/c6x/include/asm/Kbuild        |    1 +
>   arch/cris/include/asm/Kbuild       |    1 +
>   arch/frv/include/asm/Kbuild        |    3 +
>   arch/h8300/include/asm/Kbuild      |    1 +
>   arch/hexagon/include/asm/Kbuild    |    1 +
>   arch/ia64/include/asm/Kbuild       |    1 +
>   arch/m32r/include/asm/Kbuild       |    1 +
>   arch/m68k/include/asm/Kbuild       |    1 +
>   arch/microblaze/include/asm/Kbuild |    1 +
>   arch/mips/include/asm/Kbuild       |    1 +
>   arch/mn10300/include/asm/Kbuild    |    1 +
>   arch/openrisc/include/asm/Kbuild   |    1 +
>   arch/parisc/include/asm/Kbuild     |    2 +-
>   arch/powerpc/include/asm/Kbuild    |    1 +
>   arch/s390/include/asm/Kbuild       |    2 +-
>   arch/score/include/asm/Kbuild      |    1 +
>   arch/sh/include/asm/Kbuild         |    1 +
>   arch/sparc/include/asm/Kbuild      |    1 +
>   arch/tile/include/asm/Kbuild       |    1 +
>   arch/um/include/asm/Kbuild         |    2 +-
>   arch/unicore32/include/asm/Kbuild  |    1 +
>   arch/x86/include/asm/Kbuild        |    1 +
>   arch/xtensa/include/asm/Kbuild     |    1 +
>   include/asm-generic/math128.h      |    4 +
>   include/linux/math128.h            |  180 ++++++++++++++++++++++++++++++++++++
>   lib/Makefile                       |    2 +-
>   lib/math128.c                      |   40 ++++++++
>   31 files changed, 255 insertions(+), 4 deletions(-)
>   create mode 100644 include/asm-generic/math128.h
>   create mode 100644 include/linux/math128.h
>   create mode 100644 lib/math128.c
>
> diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
> index 64ffc9e..e012ed5 100644
> --- a/arch/alpha/include/asm/Kbuild
> +++ b/arch/alpha/include/asm/Kbuild
> @@ -11,3 +11,4 @@ header-y += reg.h
>   header-y += regdef.h
>   header-y += sysinfo.h
>   generic-y += exec.h
> +generic-y += math128.h
> diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
> index f70ae17..07023d4 100644
> --- a/arch/arm/include/asm/Kbuild
> +++ b/arch/arm/include/asm/Kbuild
> @@ -33,3 +33,4 @@ generic-y += termios.h
>   generic-y += timex.h
>   generic-y += types.h
>   generic-y += unaligned.h
> +generic-y += math128.h
> diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
> index 4807ded..4384224 100644
> --- a/arch/avr32/include/asm/Kbuild
> +++ b/arch/avr32/include/asm/Kbuild
> @@ -1,3 +1,5 @@
>
>   generic-y	+= clkdev.h
>   generic-y	+= exec.h
> +generic-y	+= math128.h
> +header-y	+= cachectl.h
> diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
> index 5a0625a..6836e68 100644
> --- a/arch/blackfin/include/asm/Kbuild
> +++ b/arch/blackfin/include/asm/Kbuild
> @@ -47,3 +47,4 @@ generic-y += xor.h
>   header-y += bfin_sport.h
>   header-y += cachectl.h
>   header-y += fixed_code.h
> +generic-y += math128.h
> diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
> index 112a496..ab11744 100644
> --- a/arch/c6x/include/asm/Kbuild
> +++ b/arch/c6x/include/asm/Kbuild
> @@ -53,3 +53,4 @@ generic-y += types.h
>   generic-y += ucontext.h
>   generic-y += user.h
>   generic-y += vga.h
> +generic-y += math128.h
> diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
> index 6d43a95..7674e82 100644
> --- a/arch/cris/include/asm/Kbuild
> +++ b/arch/cris/include/asm/Kbuild
> @@ -11,3 +11,4 @@ header-y += sync_serial.h
>   generic-y += clkdev.h
>   generic-y += exec.h
>   generic-y += module.h
> +generic-y += math128.h
> diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
> index 4a159da..732d864 100644
> --- a/arch/frv/include/asm/Kbuild
> +++ b/arch/frv/include/asm/Kbuild
> @@ -1,3 +1,6 @@
>
>   generic-y += clkdev.h
>   generic-y += exec.h
> +generic-y += math128.h
> +header-y += registers.h
> +header-y += termios.h
> diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
> index 50bbf38..1270ae0 100644
> --- a/arch/h8300/include/asm/Kbuild
> +++ b/arch/h8300/include/asm/Kbuild
> @@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
>   generic-y += clkdev.h
>   generic-y += exec.h
>   generic-y += module.h
> +generic-y += math128.h
> diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
> index 3bfa9b3..8c179f4 100644
> --- a/arch/hexagon/include/asm/Kbuild
> +++ b/arch/hexagon/include/asm/Kbuild
> @@ -52,3 +52,4 @@ generic-y += types.h
>   generic-y += ucontext.h
>   generic-y += unaligned.h
>   generic-y += xor.h
> +generic-y += math128.h
> diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
> index dd02f09..f10618b 100644
> --- a/arch/ia64/include/asm/Kbuild
> +++ b/arch/ia64/include/asm/Kbuild
> @@ -2,3 +2,4 @@
>   generic-y += clkdev.h
>   generic-y += exec.h
>   generic-y += kvm_para.h
> +generic-y += math128.h
> diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
> index 50bbf38..1270ae0 100644
> --- a/arch/m32r/include/asm/Kbuild
> +++ b/arch/m32r/include/asm/Kbuild
> @@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
>   generic-y += clkdev.h
>   generic-y += exec.h
>   generic-y += module.h
> +generic-y += math128.h
> diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
> index 88fa3ac..46d4b99 100644
> --- a/arch/m68k/include/asm/Kbuild
> +++ b/arch/m68k/include/asm/Kbuild
> @@ -27,3 +27,4 @@ generic-y += topology.h
>   generic-y += types.h
>   generic-y += word-at-a-time.h
>   generic-y += xor.h
> +generic-y += math128.h
> diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
> index 8653072..4809e13 100644
> --- a/arch/microblaze/include/asm/Kbuild
> +++ b/arch/microblaze/include/asm/Kbuild
> @@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
>   header-y  += elf.h
>   generic-y += clkdev.h
>   generic-y += exec.h
> +generic-y += math128.h
> diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
> index 533053d..0de09e8 100644
> --- a/arch/mips/include/asm/Kbuild
> +++ b/arch/mips/include/asm/Kbuild
> @@ -1 +1,2 @@
>   # MIPS headers
> +generic-y += math128.h
> diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
> index 4a159da..6b54375 100644
> --- a/arch/mn10300/include/asm/Kbuild
> +++ b/arch/mn10300/include/asm/Kbuild
> @@ -1,3 +1,4 @@
>
>   generic-y += clkdev.h
>   generic-y += exec.h
> +generic-y += math128.h
> diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
> index 78de680..fa6fa87 100644
> --- a/arch/openrisc/include/asm/Kbuild
> +++ b/arch/openrisc/include/asm/Kbuild
> @@ -64,3 +64,4 @@ generic-y += types.h
>   generic-y += ucontext.h
>   generic-y += user.h
>   generic-y += word-at-a-time.h
> +generic-y += math128.h
> diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
> index bac8deb..cab5ff7 100644
> --- a/arch/parisc/include/asm/Kbuild
> +++ b/arch/parisc/include/asm/Kbuild
> @@ -2,4 +2,4 @@
>   generic-y += word-at-a-time.h auxvec.h user.h cputime.h emergency-restart.h \
>   	  segment.h topology.h vga.h device.h percpu.h hw_irq.h mutex.h \
>   	  div64.h irq_regs.h kdebug.h kvm_para.h local64.h local.h param.h \
> -	  poll.h xor.h clkdev.h exec.h
> +	  poll.h xor.h clkdev.h exec.h math128.h
> diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
> index a4fe15e..61d8f6e 100644
> --- a/arch/powerpc/include/asm/Kbuild
> +++ b/arch/powerpc/include/asm/Kbuild
> @@ -2,3 +2,4 @@
>
>   generic-y += clkdev.h
>   generic-y += rwsem.h
> +generic-y += math128.h
> diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
> index 0633dc6..daa2d19 100644
> --- a/arch/s390/include/asm/Kbuild
> +++ b/arch/s390/include/asm/Kbuild
> @@ -1,3 +1,3 @@
>
> -
>   generic-y += clkdev.h
> +generic-y += math128.h
> diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
> index ec697ae..e14c1ed 100644
> --- a/arch/score/include/asm/Kbuild
> +++ b/arch/score/include/asm/Kbuild
> @@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
>   header-y +=
>
>   generic-y += clkdev.h
> +generic-y += math128.h
> diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
> index 29f83be..2cf354a 100644
> --- a/arch/sh/include/asm/Kbuild
> +++ b/arch/sh/include/asm/Kbuild
> @@ -33,3 +33,4 @@ generic-y += termbits.h
>   generic-y += termios.h
>   generic-y += ucontext.h
>   generic-y += xor.h
> +generic-y += math128.h
> diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
> index 645a58d..ba284f9 100644
> --- a/arch/sparc/include/asm/Kbuild
> +++ b/arch/sparc/include/asm/Kbuild
> @@ -9,3 +9,4 @@ generic-y += irq_regs.h
>   generic-y += local.h
>   generic-y += module.h
>   generic-y += word-at-a-time.h
> +generic-y += math128.h
> diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
> index 6948015..e3a37ac 100644
> --- a/arch/tile/include/asm/Kbuild
> +++ b/arch/tile/include/asm/Kbuild
> @@ -36,3 +36,4 @@ generic-y += termbits.h
>   generic-y += termios.h
>   generic-y += types.h
>   generic-y += xor.h
> +generic-y += math128.h
> diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
> index 0f6e7b3..f1a5a8f 100644
> --- a/arch/um/include/asm/Kbuild
> +++ b/arch/um/include/asm/Kbuild
> @@ -1,4 +1,4 @@
>   generic-y += bug.h cputime.h device.h emergency-restart.h futex.h hardirq.h
>   generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
>   generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
> -generic-y += switch_to.h clkdev.h
> +generic-y += switch_to.h clkdev.h math128.h
> diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
> index c910c98..3a5e70e 100644
> --- a/arch/unicore32/include/asm/Kbuild
> +++ b/arch/unicore32/include/asm/Kbuild
> @@ -60,3 +60,4 @@ generic-y += unaligned.h
>   generic-y += user.h
>   generic-y += vga.h
>   generic-y += xor.h
> +generic-y += math128.h
> diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
> index 66e5f0e..0a34aef 100644
> --- a/arch/x86/include/asm/Kbuild
> +++ b/arch/x86/include/asm/Kbuild
> @@ -28,3 +28,4 @@ genhdr-y += unistd_64.h
>   genhdr-y += unistd_x32.h
>
>   generic-y += clkdev.h
> +generic-y += math128.h
> diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
> index 6d13027..edb183d 100644
> --- a/arch/xtensa/include/asm/Kbuild
> +++ b/arch/xtensa/include/asm/Kbuild
> @@ -26,3 +26,4 @@ generic-y += statfs.h
>   generic-y += termios.h
>   generic-y += topology.h
>   generic-y += xor.h
> +generic-y += math128.h
> diff --git a/include/asm-generic/math128.h b/include/asm-generic/math128.h
> new file mode 100644
> index 0000000..3582691
> --- /dev/null
> +++ b/include/asm-generic/math128.h
> @@ -0,0 +1,4 @@
> +#ifndef _ASM_GENERIC_MATH128_H
> +#define _ASM_GENERIC_MATH128_H
> +
> +#endif /*_ASM_GENERIC_MATH128_H */
> diff --git a/include/linux/math128.h b/include/linux/math128.h
> new file mode 100644
> index 0000000..5b0eef6
> --- /dev/null
> +++ b/include/linux/math128.h
> @@ -0,0 +1,180 @@
> +#ifndef _LINUX_MATH128_H
> +#define _LINUX_MATH128_H
> +
> +#include <linux/types.h>
> +
> +typedef union {
> +	struct {
> +#if __BYTE_ORDER__  == __ORDER_LITTLE_ENDIAN__
> +		u64 lo, hi;
> +#else
> +		u64 hi, lo;
> +#endif
> +	};
> +#ifdef __SIZEOF_INT128__ /* gcc-4.6+ */
> +	unsigned __int128 val;
> +#endif
> +} u128;
> +
> +#define U128_INIT(_hi, _lo) (u128){{ .hi = (_hi), .lo = (_lo) }}
> +
> +#include <asm/math128.h>
> +
> +/*
> + * Make usage of __int128 dependent on arch code so they can
> + * judge if gcc is doing the right thing for them and can over-ride
> + * any funnies.
> + */
> +
> +#ifndef ARCH_HAS_INT128
> +
> +#ifndef add_u128
> +static inline u128 add_u128(u128 a, u128 b)
> +{
> +	a.hi += b.hi;
> +	a.lo += b.lo;
> +	if (a.lo < b.lo)
> +		a.hi++;
> +
> +	return a;
> +}
> +#endif /* add_u128 */
> +
> +#ifndef mul_u64_u64
> +extern u128 mul_u64_u64(u64 a, u64 b);
> +#endif
> +
> +#ifndef mul_u64_u32_shr
> +static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
> +{
> +	u32 ah, al;
> +	u64 t1, t2;
> +
> +	ah = a >> 32;
> +	al = a;
> +
> +	t1 = ((u64)al * mul) >> shift;
> +	t2 = ((u64)ah * mul) << (32 - shift);
> +
> +	return t1 + t2;
> +}
> +#endif /* mul_u64_u32_shr */
> +
> +#ifndef shl_u128
> +static inline u128 shl_u128(u128 x, unsigned int n)
> +{
> +	u128 res;
> +
> +	if (!n)
> +		return x;
> +
> +	if (n < 64) {
> +		res.hi = x.hi << n;
> +		res.hi |= x.lo >> (64 - n);
> +		res.lo = x.lo << n;
> +	} else {
> +		res.lo = 0;
> +		res.hi = x.lo << (n - 64);
> +	}
> +
> +	return res;
> +}
> +#endif /* shl_u128 */
> +
> +#ifndef shr_u128
> +static inline u128 shr_u128(u128 x, unsigned int n)
> +{
> +	u128 res;
> +
> +	if (!n)
> +		return x;
> +
> +	if (n < 64) {
> +		res.lo = x.lo >> n;
> +		res.lo |= x.hi << (64 - n);
> +		res.hi = x.hi >> n;
> +	} else {
> +		res.hi = 0;
> +		res.lo = x.hi >> (n - 64);
> +	}
> +
> +	return res;
> +}
> +#endif /* shr_u128 */
> +
> +#ifndef cmp_u128
> +static inline int cmp_u128(u128 a, u128 b)
> +{
> +	if (a.hi > b.hi)
> +		return 1;
> +	if (a.hi < b.hi)
> +		return -1;
> +	if (a.lo > b.lo)
> +		return 1;
> +	if (a.lo < b.lo)
> +		return -1;
> +
> +	return 0;
> +}
> +#endif /* cmp_u128 */
> +
> +#else /* ARCH_HAS_INT128 */
> +
> +#ifndef add_u128
> +static inline u128 add_u128(u128 a, u128 b)
> +{
> +	a.val += b.val;
> +	return a;
> +}
> +#endif /* add_u128 */
> +
> +#ifndef mul_u64_u64
> +static inline u128 mul_u64_u64(u64 a, u64 b)
> +{
> +	u128 res;
> +
> +	res.val = a;
> +	res.val *= b;
> +
> +	return res;
> +}
> +#define mul_u64_u64 mul_u64_u64
> +#endif
> +
> +#ifndef mul_u64_u32_shr
> +static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
> +{
> +	return (u64)(((unsigned __int128)a * mul) >> shift);
> +}
> +#endif /* mul_u64_u32_shr */
> +
> +#ifndef shl_u128
> +static inline u128 shl_u128(u128 x, unsigned int n)
> +{
> +	x.val <<= n;
> +	return x;
> +}
> +#endif /* shl_u128 */
> +
> +#ifndef shr_u128
> +static inline u128 shr_u128(u128 x, unsigned int n)
> +{
> +	x.val >>= n;
> +	return x;
> +}
> +#endif /* shr_u128 */
> +
> +#ifndef cmp_u128
> +static inline int cmp_u128(u128 a, u128 b)
> +{
> +	if (a.val < b.val)
> +		return -1;
> +	if (a.val > b.val)
> +		return 1;
> +	return 0;
> +}
> +#endif /* cmp_u128 */
> +
> +#endif /* ARCH_HAS_INT128 */
> +
> +#endif /* _LINUX_MATH128_H */
> diff --git a/lib/Makefile b/lib/Makefile
> index 821a162..367c62c 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>   	 idr.o int_sqrt.o extable.o \
>   	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
>   	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
> -	 is_single_threaded.o plist.o decompress.o
> +	 is_single_threaded.o plist.o decompress.o math128.o
>
>   lib-$(CONFIG_MMU) += ioremap.o
>   lib-$(CONFIG_SMP) += cpumask.o
> diff --git a/lib/math128.c b/lib/math128.c
> new file mode 100644
> index 0000000..55b123a
> --- /dev/null
> +++ b/lib/math128.c
> @@ -0,0 +1,40 @@
> +#include <linux/math128.h>
> +
> +#ifndef mul_u64_u64
> +/*
> + * a * b = (ah * 2^32 + al) * (bh * 2^32 + bl) =
> + *   ah*bh * 2^64 + (ah*bl + bh*al) * 2^32 + al*bl
> + */
> +u128 mul_u64_u64(u64 a, u64 b)
> +{
> +	u128 t1, t2, t3, t4;
> +	u32 ah, al;
> +	u32 bh, bl;
> +
> +	ah = a >> 32;
> +	al = a;
> +
> +	bh = b >> 32;
> +	bl = b;
> +
> +	t1.lo = 0;
> +	t1.hi = (u64)ah * bh;
> +
> +	t2.lo = (u64)ah * bl;
> +	t2.hi = t2.lo >> 32;
> +	t2.lo <<= 32;
> +
> +	t3.lo = (u64)al * bh;
> +	t3.hi = t3.lo >> 32;
> +	t3.lo <<= 32;
> +
> +	t4.lo = (u64)al * bl;
> +	t4.hi = 0;
> +
> +	t1 = add_u128(t1, t2);
> +	t1 = add_u128(t1, t3);
> +	t1 = add_u128(t1, t4);
> +
> +	return t1;
> +}
> +#endif /* mul_u64_u64 */
>
