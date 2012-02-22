Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2BVNt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:49:58 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:50360 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2BVNty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:49:54 -0500
Date: Wed, 22 Feb 2012 16:51:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Pradheep Shrinivasan <pradheep.sh@gmail.com>, devel@driverdev.osuosl.org,
        lucas.demarchi@profusion.mobi, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, joe@perches.com,
        devel@linuxdriverproject.org
Subject: Macros with complex values should be enclosed in parenthesis
Message-ID: <20120222135100.GD3680@mwanda>
References: <4f428dfc.e302440a.02ba.6747@mx.google.com>
 <20120220183109.GL2855@mwanda>
 <CANz8tm3t5HM9QeNk+h4gNtbTs2UUW1qOe0t=TgnuSD3_gw_A7Q@mail.gmail.com>
 <20120220190952.GN2912@mwanda>
 <CANz8tm16FvLjUbgPWTsiz5WTje-bRCEAE1eWx3=F48Lm66-Tyg@mail.gmail.com>
 <20120222112144.GC2491@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xB0nW4MQa6jZONgY"
Content-Disposition: inline
In-Reply-To: <20120222112144.GC2491@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F44F270.0073,ss=1,re=-6.500,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xB0nW4MQa6jZONgY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 22, 2012 at 11:21:44AM +0000, Andy Whitcroft wrote:
> On Tue, Feb 21, 2012 at 01:10:06AM +0530, Pradheep Shrinivasan wrote:
>=20
> > > Are you asking me if I'm going to NAK your patch?  No.  It's an
> > > unfortunate thing.  Checkpatch.pl is going around telling people to
> > > add bogus parenthesis everywhere, and no one likes to redo their
> > > patches.  And I feel like a jerk for telling people that they should
> > > redo their patches.  And checkpatch.pl is a robot which has more
> > > energy than I do.
>=20
> In theory the number of things it gets right outweigh the things it gets
> wrong and you do save energy overall.
>=20
> I will poke checkpatch to try and stop it getting these wrong.
>=20

I tried to run checkpatch.pl over the entire kernel to see how many
warnings it produced but it got stuck part way through parsing:
=2E/scripts/checkpatch.pl -f arch/powerpc/kvm/book3s_32_mmu_host.c
This is on linux next for today.

It turns out the macro warnings are mostly bogus.  For staging, we
always have newbies running ./scripts/checkpatch.pl -f so false
positives affect us more than for other subsystems.

I've attached a random representative list of the warnings below.
I stripped out some comments for clarity.  Looking through the list,
cutting down on the false positives is harder than I had assumed.
I suspect that we should just turn this check off by default.

Btw, smatch has a macro expansion check as well.  I've fixed two
kernel bugs.  The smatch check only complains if there is an actual
expansion across a macro and non-macro.  The only problem with the
smatch check is that it doesn't catch expansion problems where a
macro expands improperly inside another macro.  Probably these are
so rare it's not worth worrying about.

regards,
dan carpenter

PS:  Just to be clear, checkpatch says we should put parenthesis
around each of the following macros.  I removed all the multi-line
macros.  (Why do multi-line macros need parentheses anyway?).  There
are definitely some in the list which should get parenthesis but as
you can see, most are false positives.

#define memzero(s,n)	memset ((s),0,(n))
#define bootblock_checksum	__u2.__checksum
#define a_data		ah.dsize
#define a_bss		ah.bsize
#define a_entry		ah.entry
#define a_textstart	ah.text_start
#define a_fprmask	ah.fprmask
#define a_gpvalue	ah.gpvalue
#define __always_inline		inline __attribute__((always_inline))
#define __EXTERN_INLINE extern inline
#define __EXTERN_INLINE extern inline
#define __EXTERN_INLINE extern inline
#define __EXTERN_INLINE extern inline
#define __EXTERN_INLINE extern inline
#define __EXTERN_INLINE extern inline
#define GAMMA_BIAS		alpha_mv.sys.t2.gamma_bias
#define __EXTERN_INLINE extern inline
#define __EXTERN_INLINE extern inline
#define __EXTERN_INLINE extern inline
#define __EXTERN_INLINE extern inline
#define ELF_PLAT_INIT(_r, load_addr)	_r->r0 =3D 0
#define ACTUAL_NR_IRQS	alpha_mv.nr_irqs
#define __EXTERN_INLINE extern inline
#define __EXTERN_INLINE extern inline
#define PCIBIOS_MIN_IO		alpha_mv.min_io_address
#define PCIBIOS_MIN_MEM		alpha_mv.min_mem_address
#define pci_domain_nr(bus) ((struct pci_controller *)(bus)->sysdata)->index
#define v0	$0=09
#define t0	$1=09
#define t1	$2
#define t2	$3
#define t3	$4
#define t4	$5
#define t5	$6
#define t6	$7
#define t7	$8
#define a0	$16=09
#define a1	$17
#define a2	$18
#define a3	$19
#define a4	$20
#define a5	$21
#define t8	$22=09
#define t9	$23
#define t10	$24
#define t11	$25
#define ra	$26=09
#define t12	$27
#define AT	$at=09
#define gp	$29=09
#define sp	$30=09
#define zero	$31=09
#define sa_sigaction	_u._sa_sigaction
#define __halt() __asm__ __volatile__ ("call_pal %0 #halt" : : "i" (PAL_hal=
t))
#define __EXTERN_INLINE extern inline
#define NAME_OFFSET	offsetof (struct osf_dirent, d_name)
#define MAX_BCACHE_SIZE	16*1024*1024
#define DBGS(args)	printk args
#define set_irq_work_pending_flag()  __get_cpu_var(irq_work_pending) =3D 1
#define clear_irq_work_pending()     __get_cpu_var(irq_work_pending) =3D 0
#define LPJ	 cpu_data[smp_processor_id()].loops_per_jiffy
#define abort()			goto bad_insn
#define MMCIF_BASE      (void __iomem *)0xe6bd0000
#define PORT84CR	(void __iomem *)0xe6050054
#define PORT85CR	(void __iomem *)0xe6050055
#define PORT86CR	(void __iomem *)0xe6050056
#define PORT87CR	(void __iomem *)0xe6050057
#define PORT88CR	(void __iomem *)0xe6050058
#define PORT89CR	(void __iomem *)0xe6050059
#define PORT90CR	(void __iomem *)0xe605005a
#define PORT91CR	(void __iomem *)0xe605005b
#define PORT92CR	(void __iomem *)0xe605005c
#define PORT99CR	(void __iomem *)0xe6050063
#define SMSTPCR3	(void __iomem *)0xe615013c
#define SDHI1_BASE	(void __iomem *)0xe6860000
#define get_byte_0      lsl #0
#define get_byte_1	lsr #8
#define get_byte_2	lsr #16
#define get_byte_3	lsr #24
#define put_byte_0      lsl #0
#define put_byte_1	lsl #8
#define put_byte_2	lsl #16
#define put_byte_3	lsl #24
#define get_byte_0	lsr #24
#define get_byte_1	lsr #16
#define get_byte_2	lsr #8
#define get_byte_3      lsl #0
#define put_byte_0	lsl #24
#define put_byte_1	lsl #16
#define put_byte_2	lsl #8
#define put_byte_3      lsl #0
#define ALT_UP_B(label) b label
#define atomic_add(i, v)	(void) atomic_add_return(i, v)
#define atomic_sub(i, v)	(void) atomic_sub_return(i, v)
#define __cpuc_flush_icache_all		cpu_cache.flush_icache_all
#define __cpuc_flush_kern_all		cpu_cache.flush_kern_all
#define __cpuc_flush_user_all		cpu_cache.flush_user_all
#define __cpuc_flush_user_range		cpu_cache.flush_user_range
#define __cpuc_coherent_kern_range	cpu_cache.coherent_kern_range
#define __cpuc_coherent_user_range	cpu_cache.coherent_user_range
#define __cpuc_flush_dcache_area	cpu_cache.flush_kern_dcache_area
#define dmac_map_area			cpu_cache.dma_map_area
#define dmac_unmap_area			cpu_cache.dma_unmap_area
#define dmac_flush_range		cpu_cache.dma_flush_range
#define TUSER(instr)	#instr
#define ELF_PLAT_INIT(_r, load_addr)	(_r)->ARM_r0 =3D 0
#define EXTRA_FLOPPY_PARAMS ,{ "driveswap", &driveswap, NULL, 0, 0 }
#define __inc_irq_stat(cpu, member)	__IRQ_STAT(cpu, member)++
#define IOP3XX_ATUVID		(volatile u16 *)IOP3XX_REG_ADDR(0x0100)
#define IOP3XX_ATUDID		(volatile u16 *)IOP3XX_REG_ADDR(0x0102)
#define IOP3XX_ATUCMD		(volatile u16 *)IOP3XX_REG_ADDR(0x0104)
#define IOP3XX_ATUSR		(volatile u16 *)IOP3XX_REG_ADDR(0x0106)
#define IOP3XX_ATURID		(volatile u8  *)IOP3XX_REG_ADDR(0x0108)
#define IOP3XX_ATUCCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0109)
#define IOP3XX_ATUCLSR		(volatile u8  *)IOP3XX_REG_ADDR(0x010c)
#define IOP3XX_ATULT		(volatile u8  *)IOP3XX_REG_ADDR(0x010d)
#define IOP3XX_ATUHTR		(volatile u8  *)IOP3XX_REG_ADDR(0x010e)
#define IOP3XX_ATUBIST		(volatile u8  *)IOP3XX_REG_ADDR(0x010f)
#define IOP3XX_IABAR0		(volatile u32 *)IOP3XX_REG_ADDR(0x0110)
#define IOP3XX_IAUBAR0		(volatile u32 *)IOP3XX_REG_ADDR(0x0114)
#define IOP3XX_IABAR1		(volatile u32 *)IOP3XX_REG_ADDR(0x0118)
#define IOP3XX_IAUBAR1		(volatile u32 *)IOP3XX_REG_ADDR(0x011c)
#define IOP3XX_IABAR2		(volatile u32 *)IOP3XX_REG_ADDR(0x0120)
#define IOP3XX_IAUBAR2		(volatile u32 *)IOP3XX_REG_ADDR(0x0124)
#define IOP3XX_ASVIR		(volatile u16 *)IOP3XX_REG_ADDR(0x012c)
#define IOP3XX_ASIR		(volatile u16 *)IOP3XX_REG_ADDR(0x012e)
#define IOP3XX_ERBAR		(volatile u32 *)IOP3XX_REG_ADDR(0x0130)
#define IOP3XX_ATUILR		(volatile u8  *)IOP3XX_REG_ADDR(0x013c)
#define IOP3XX_ATUIPR		(volatile u8  *)IOP3XX_REG_ADDR(0x013d)
#define IOP3XX_ATUMGNT		(volatile u8  *)IOP3XX_REG_ADDR(0x013e)
#define IOP3XX_ATUMLAT		(volatile u8  *)IOP3XX_REG_ADDR(0x013f)
#define IOP3XX_IALR0		(volatile u32 *)IOP3XX_REG_ADDR(0x0140)
#define IOP3XX_IATVR0		(volatile u32 *)IOP3XX_REG_ADDR(0x0144)
#define IOP3XX_ERLR		(volatile u32 *)IOP3XX_REG_ADDR(0x0148)
#define IOP3XX_ERTVR		(volatile u32 *)IOP3XX_REG_ADDR(0x014c)
#define IOP3XX_IALR1		(volatile u32 *)IOP3XX_REG_ADDR(0x0150)
#define IOP3XX_IALR2		(volatile u32 *)IOP3XX_REG_ADDR(0x0154)
#define IOP3XX_IATVR2		(volatile u32 *)IOP3XX_REG_ADDR(0x0158)
#define IOP3XX_OIOWTVR		(volatile u32 *)IOP3XX_REG_ADDR(0x015c)
#define IOP3XX_OMWTVR0		(volatile u32 *)IOP3XX_REG_ADDR(0x0160)
#define IOP3XX_OUMWTVR0		(volatile u32 *)IOP3XX_REG_ADDR(0x0164)
#define IOP3XX_OMWTVR1		(volatile u32 *)IOP3XX_REG_ADDR(0x0168)
#define IOP3XX_OUMWTVR1		(volatile u32 *)IOP3XX_REG_ADDR(0x016c)
#define IOP3XX_OUDWTVR		(volatile u32 *)IOP3XX_REG_ADDR(0x0178)
#define IOP3XX_ATUCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0180)
#define IOP3XX_PCSR		(volatile u32 *)IOP3XX_REG_ADDR(0x0184)
#define IOP3XX_ATUISR		(volatile u32 *)IOP3XX_REG_ADDR(0x0188)
#define IOP3XX_ATUIMR		(volatile u32 *)IOP3XX_REG_ADDR(0x018c)
#define IOP3XX_IABAR3		(volatile u32 *)IOP3XX_REG_ADDR(0x0190)
#define IOP3XX_IAUBAR3		(volatile u32 *)IOP3XX_REG_ADDR(0x0194)
#define IOP3XX_IALR3		(volatile u32 *)IOP3XX_REG_ADDR(0x0198)
#define IOP3XX_IATVR3		(volatile u32 *)IOP3XX_REG_ADDR(0x019c)
#define IOP3XX_OCCAR		(volatile u32 *)IOP3XX_REG_ADDR(0x01a4)
#define IOP3XX_OCCDR		(volatile u32 *)IOP3XX_REG_ADDR(0x01ac)
#define IOP3XX_PDSCR		(volatile u32 *)IOP3XX_REG_ADDR(0x01bc)
#define IOP3XX_PMCAPID		(volatile u8  *)IOP3XX_REG_ADDR(0x01c0)
#define IOP3XX_PMNEXT		(volatile u8  *)IOP3XX_REG_ADDR(0x01c1)
#define IOP3XX_APMCR		(volatile u16 *)IOP3XX_REG_ADDR(0x01c2)
#define IOP3XX_APMCSR		(volatile u16 *)IOP3XX_REG_ADDR(0x01c4)
#define IOP3XX_PCIXCAPID	(volatile u8  *)IOP3XX_REG_ADDR(0x01e0)
#define IOP3XX_PCIXNEXT		(volatile u8  *)IOP3XX_REG_ADDR(0x01e1)
#define IOP3XX_PCIXCMD		(volatile u16 *)IOP3XX_REG_ADDR(0x01e2)
#define IOP3XX_PCIXSR		(volatile u32 *)IOP3XX_REG_ADDR(0x01e4)
#define IOP3XX_PCIIRSR		(volatile u32 *)IOP3XX_REG_ADDR(0x01ec)
#define IOP3XX_IMR0		(volatile u32 *)IOP3XX_REG_ADDR(0x0310)
#define IOP3XX_IMR1		(volatile u32 *)IOP3XX_REG_ADDR(0x0314)
#define IOP3XX_OMR0		(volatile u32 *)IOP3XX_REG_ADDR(0x0318)
#define IOP3XX_OMR1		(volatile u32 *)IOP3XX_REG_ADDR(0x031c)
#define IOP3XX_IDR		(volatile u32 *)IOP3XX_REG_ADDR(0x0320)
#define IOP3XX_IISR		(volatile u32 *)IOP3XX_REG_ADDR(0x0324)
#define IOP3XX_IIMR		(volatile u32 *)IOP3XX_REG_ADDR(0x0328)
#define IOP3XX_ODR		(volatile u32 *)IOP3XX_REG_ADDR(0x032c)
#define IOP3XX_OISR		(volatile u32 *)IOP3XX_REG_ADDR(0x0330)
#define IOP3XX_OIMR		(volatile u32 *)IOP3XX_REG_ADDR(0x0334)
#define IOP3XX_MUCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0350)
#define IOP3XX_QBAR		(volatile u32 *)IOP3XX_REG_ADDR(0x0354)
#define IOP3XX_IFHPR		(volatile u32 *)IOP3XX_REG_ADDR(0x0360)
#define IOP3XX_IFTPR		(volatile u32 *)IOP3XX_REG_ADDR(0x0364)
#define IOP3XX_IPHPR		(volatile u32 *)IOP3XX_REG_ADDR(0x0368)
#define IOP3XX_IPTPR		(volatile u32 *)IOP3XX_REG_ADDR(0x036c)
#define IOP3XX_OFHPR		(volatile u32 *)IOP3XX_REG_ADDR(0x0370)
#define IOP3XX_OFTPR		(volatile u32 *)IOP3XX_REG_ADDR(0x0374)
#define IOP3XX_OPHPR		(volatile u32 *)IOP3XX_REG_ADDR(0x0378)
#define IOP3XX_OPTPR		(volatile u32 *)IOP3XX_REG_ADDR(0x037c)
#define IOP3XX_IAR		(volatile u32 *)IOP3XX_REG_ADDR(0x0380)
#define IOP3XX_PBCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0680)
#define IOP3XX_PBISR		(volatile u32 *)IOP3XX_REG_ADDR(0x0684)
#define IOP3XX_PBBAR0		(volatile u32 *)IOP3XX_REG_ADDR(0x0688)
#define IOP3XX_PBLR0		(volatile u32 *)IOP3XX_REG_ADDR(0x068c)
#define IOP3XX_PBBAR1		(volatile u32 *)IOP3XX_REG_ADDR(0x0690)
#define IOP3XX_PBLR1		(volatile u32 *)IOP3XX_REG_ADDR(0x0694)
#define IOP3XX_PBBAR2		(volatile u32 *)IOP3XX_REG_ADDR(0x0698)
#define IOP3XX_PBLR2		(volatile u32 *)IOP3XX_REG_ADDR(0x069c)
#define IOP3XX_PBBAR3		(volatile u32 *)IOP3XX_REG_ADDR(0x06a0)
#define IOP3XX_PBLR3		(volatile u32 *)IOP3XX_REG_ADDR(0x06a4)
#define IOP3XX_PBBAR4		(volatile u32 *)IOP3XX_REG_ADDR(0x06a8)
#define IOP3XX_PBLR4		(volatile u32 *)IOP3XX_REG_ADDR(0x06ac)
#define IOP3XX_PBBAR5		(volatile u32 *)IOP3XX_REG_ADDR(0x06b0)
#define IOP3XX_PBLR5		(volatile u32 *)IOP3XX_REG_ADDR(0x06b4)
#define IOP3XX_PMBR0		(volatile u32 *)IOP3XX_REG_ADDR(0x06c0)
#define IOP3XX_PMBR1		(volatile u32 *)IOP3XX_REG_ADDR(0x06e0)
#define IOP3XX_PMBR2		(volatile u32 *)IOP3XX_REG_ADDR(0x06e4)
#define IOP3XX_GTMR		(volatile u32 *)IOP3XX_REG_ADDR(0x0700)
#define IOP3XX_ESR		(volatile u32 *)IOP3XX_REG_ADDR(0x0704)
#define IOP3XX_EMISR		(volatile u32 *)IOP3XX_REG_ADDR(0x0708)
#define IOP3XX_GTSR		(volatile u32 *)IOP3XX_REG_ADDR(0x0710)
#define IOP3XX_PERCR0		(volatile u32 *)IOP3XX_REG_ADDR(0x0710)
#define IOP3XX_GPOE		(volatile u32 *)IOP3XX_GPIO_REG(0x0000)
#define IOP3XX_GPID		(volatile u32 *)IOP3XX_GPIO_REG(0x0004)
#define IOP3XX_GPOD		(volatile u32 *)IOP3XX_GPIO_REG(0x0008)
#define IOP3XX_TU_TMR0		(volatile u32 *)IOP3XX_TIMER_REG(0x0000)
#define IOP3XX_TU_TMR1		(volatile u32 *)IOP3XX_TIMER_REG(0x0004)
#define IOP3XX_TU_TCR0		(volatile u32 *)IOP3XX_TIMER_REG(0x0008)
#define IOP3XX_TU_TCR1		(volatile u32 *)IOP3XX_TIMER_REG(0x000c)
#define IOP3XX_TU_TRR0		(volatile u32 *)IOP3XX_TIMER_REG(0x0010)
#define IOP3XX_TU_TRR1		(volatile u32 *)IOP3XX_TIMER_REG(0x0014)
#define IOP3XX_TU_TISR		(volatile u32 *)IOP3XX_TIMER_REG(0x0018)
#define IOP3XX_TU_WDTCR		(volatile u32 *)IOP3XX_TIMER_REG(0x001c)
#define IOP3XX_ICR0		(volatile u32 *)IOP3XX_REG_ADDR(0x1680)
#define IOP3XX_ISR0		(volatile u32 *)IOP3XX_REG_ADDR(0x1684)
#define IOP3XX_ISAR0		(volatile u32 *)IOP3XX_REG_ADDR(0x1688)
#define IOP3XX_IDBR0		(volatile u32 *)IOP3XX_REG_ADDR(0x168c)
#define IOP3XX_IBMR0		(volatile u32 *)IOP3XX_REG_ADDR(0x1694)
#define IOP3XX_ICR1		(volatile u32 *)IOP3XX_REG_ADDR(0x16a0)
#define IOP3XX_ISR1		(volatile u32 *)IOP3XX_REG_ADDR(0x16a4)
#define IOP3XX_ISAR1		(volatile u32 *)IOP3XX_REG_ADDR(0x16a8)
#define IOP3XX_IDBR1		(volatile u32 *)IOP3XX_REG_ADDR(0x16ac)
#define IOP3XX_IBMR1		(volatile u32 *)IOP3XX_REG_ADDR(0x16b4)
#define __idmap __section(.idmap.text) noinline notrace
#define __ALIGN .align 0
#define __cpu_clear_user_highpage	cpu_user.cpu_clear_user_highpage
#define __cpu_copy_user_highpage	cpu_user.cpu_copy_user_highpage
#define _L_PTE_DEFAULT	L_PTE_PRESENT | L_PTE_YOUNG
#define __pte_map(pmd)		(pte_t *)kmap_atomic(pmd_page(*(pmd)))
#define cpu_proc_init			processor._proc_init
#define cpu_proc_fin			processor._proc_fin
#define cpu_reset			processor.reset
#define cpu_do_idle			processor._do_idle
#define cpu_dcache_clean_area		processor.dcache_clean_area
#define cpu_set_pte_ext			processor.set_pte_ext
#define cpu_do_switch_mm		processor.switch_mm
#define cpu_do_suspend			processor.do_suspend
#define cpu_do_resume			processor.do_resume
#define nommu_start_thread(regs) regs->ARM_r10 =3D current->mm->start_data
#define KSTK_EIP(tsk)	task_pt_regs(tsk)->ARM_pc
#define KSTK_ESP(tsk)	task_pt_regs(tsk)->ARM_sp
#define instruction_pointer(regs)	(regs)->ARM_pc
#define __tag __used __attribute__((__section__(".taglist.init")))
#define bank_phys_start(bank)	(bank)->start
#define bank_phys_size(bank)	(bank)->size
#define sa_sigaction	_u._sa_sigaction
#define sev()	__asm__ __volatile__ ("sev" : : : "memory")
#define wfe()	__asm__ __volatile__ ("wfe" : : : "memory")
#define wfi()	__asm__ __volatile__ ("wfi" : : : "memory")
#define isb() __asm__ __volatile__ ("isb" : : : "memory")
#define dsb() __asm__ __volatile__ ("dsb" : : : "memory")
#define dmb() __asm__ __volatile__ ("dmb" : : : "memory")
#define dmb() __asm__ __volatile__ ("" : : : "memory")
#define isb() __asm__ __volatile__ ("" : : : "memory")
#define dmb() __asm__ __volatile__ ("" : : : "memory")
#define __tcmfunc __attribute__((long_call)) __section(.tcm.text) noinline
#define __cpu_flush_user_tlb_range	cpu_tlb.flush_user_range
#define __cpu_flush_kern_tlb_range	cpu_tlb.flush_kern_range
#define __cpu_tlb_flags			cpu_tlb.tlb_flags
#define W(instr)	instr.w
#define BSYM(sym)	sym + 1
#define __XOR(a1, a2) a1 ^=3D a2
#define TWICE(x)	x x
#define S(x,s)	[x - IPI_TIMER] =3D s
#define YL9200_FB_VMEM_BASE	YL9200_FB_REG_BASE + SZ_2M
#define tmrHw_ASSERT(a)                     if (!(a)) *(char *)0 =3D 0
#define dmacHw_ASSERT(a)                  if (!(a)) while (1)
#define dmacHw_DST_IS_MEMORY(tt)          (((tt) =3D=3D  dmacHw_TRANSFER_TY=
PE_PERIPHERAL_TO_MEM) || ((tt) =3D=3D dmacHw_TRANSFER_TYPE_MEM_TO_MEM)) ? 1=
 : 0
#define dmacHw_0_MODULE_BASE_ADDR        (char *) MM_IO_BASE_DMA0=09
#define dmacHw_1_MODULE_BASE_ADDR        (char *) MM_IO_BASE_DMA1=09
#define AUTCPU12_PHYS_CHAR_LCD         	CS1_PHYS_BASE +0x00000000 =20
#define AUTCPU12_PHYS_NVRAM            	CS1_PHYS_BASE +0x02000000 =20
#define AUTCPU12_PHYS_CSAUX1           	CS1_PHYS_BASE +0x04000000 =20
#define AUTCPU12_PHYS_SMC              	CS1_PHYS_BASE +0x06000000 =20
#define AUTCPU12_PHYS_CAN              	CS1_PHYS_BASE +0x08000000 =20
#define AUTCPU12_PHYS_TOUCH            	CS1_PHYS_BASE +0x0A000000 =20
#define AUTCPU12_PHYS_IO               	CS1_PHYS_BASE +0x0C000000 =20
#define AUTCPU12_PHYS_LPT              	CS1_PHYS_BASE +0x0E000000 =20
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
#define PCI_BUS_PREMEM_START	PCI_BUS_NONMEM_START + PCI_BUS_NONMEM_SIZE
#define NR_IXP23XX_IRQS			IRQ_IXP23XX_INTB+1
#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
#define DEBUG_IRQ(fmt...)	while (0) {}
#define xip_cpu_idle()  asm volatile ("mcr p15, 0, %0, c7, c0, 4" :: "r" (1=
))
#define ARM_SAVE(x) arm_sleep_save[ARM_SLEEP_SAVE_##x] =3D omap_readl(x)
#define DSP_SAVE(x) dsp_sleep_save[DSP_SLEEP_SAVE_##x] =3D __raw_readw(x)
#define ULPD_SAVE(x) ulpd_sleep_save[ULPD_SLEEP_SAVE_##x] =3D omap_readw(x)
#define MPUI7XX_SAVE(x) mpui7xx_sleep_save[MPUI7XX_SLEEP_SAVE_##x] =3D omap=
_readl(x)
#define MPUI1510_SAVE(x) mpui1510_sleep_save[MPUI1510_SLEEP_SAVE_##x] =3D o=
map_readl(x)
#define MPUI1610_SAVE(x) mpui1610_sleep_save[MPUI1610_SLEEP_SAVE_##x] =3D o=
map_readl(x)
#define INT_USB_IRQ_GEN		IH2_BASE + 20
#define INT_USB_IRQ_NISO	IH2_BASE + 30
#define INT_USB_IRQ_ISO		IH2_BASE + 29
#define INT_USB_IRQ_OTG		IH2_BASE + 8
#define PNX4008_UART_CLK CLK_RATE_13MHZ * 1000=20
#define CCLKCFG			CCLKCFG_TURBO | CCLKCFG_FCS
#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
#define xip_cpu_idle()  asm volatile ("mcr p14, 0, %0, c7, c0, 0" :: "r" (1=
))
#define PWER_GPIO0	PWER_GPIO (0)=09
#define PWER_GPIO1	PWER_GPIO (1)=09
#define PWER_GPIO2	PWER_GPIO (2)=09
#define PWER_GPIO3	PWER_GPIO (3)=09
#define PWER_GPIO4	PWER_GPIO (4)=09
#define PWER_GPIO5	PWER_GPIO (5)=09
#define PWER_GPIO6	PWER_GPIO (6)=09
#define PWER_GPIO7	PWER_GPIO (7)=09
#define PWER_GPIO8	PWER_GPIO (8)=09
#define PWER_GPIO9	PWER_GPIO (9)=09
#define PWER_GPIO10	PWER_GPIO (10)=09
#define PWER_GPIO11	PWER_GPIO (11)=09
#define PWER_GPIO12	PWER_GPIO (12)=09
#define PWER_GPIO13	PWER_GPIO (13)=09
#define PWER_GPIO14	PWER_GPIO (14)=09
#define PWER_GPIO15	PWER_GPIO (15)=09
#define LCCR1_PPL	Fld (10, 0)=09
#define LCCR1_HSW	Fld (6, 10)=09
#define LCCR1_ELW	Fld (8, 16)=09
#define LCCR1_BLW	Fld (8, 24)=09
#define LCCR2_LPP	Fld (10, 0)=09
#define LCCR2_VSW	Fld (6, 10)=09
#define LCCR2_EFW	Fld (8, 16)=09
#define LCCR2_BFW	Fld (8, 24)=09
#define LCCR3_PCD	Fld (8, 0)=09
#define LCCR3_ACB	Fld (8, 8)=09
#define BOOTSTRAP_WORDS		mioa701_bootstrap_lg/4
#define SAVE(x)		sleep_save[SLEEP_SAVE_##x] =3D x
#define RESTORE(x)	x =3D sleep_save[SLEEP_SAVE_##x]
#define SAVE(x)		sleep_save[SLEEP_SAVE_##x] =3D x
#define RESTORE(x)	x =3D sleep_save[SLEEP_SAVE_##x]
#define palette_setpixel(p)	*(unsigned long *)(IO_START+0x00400000) =3D 0x1=
0000000|((p) & 255)
#define palette_write(v)	*(unsigned long *)(IO_START+0x00400000) =3D 0x0000=
0000|((v) & 0x00ffffff)
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define UCON S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define UCON S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG12 | S3C2410_UFCON_FIFOMODE
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define UCON S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define UCON S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG12 | S3C2410_UFCON_FIFOMODE
#define UCON S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define UCON S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define UCON S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define UCON S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define UCON S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK
#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
#define _PCMCIAIO(Nb)	_PCMCIA (Nb)=09
#define _PCMCIA0	_PCMCIA (0)=09
#define _PCMCIA0IO	_PCMCIAIO (0)=09
#define _PCMCIA0Attr	_PCMCIAAttr (0)=09
#define _PCMCIA0Mem	_PCMCIAMem (0)=09
#define _PCMCIA1	_PCMCIA (1)=09
#define _PCMCIA1IO	_PCMCIAIO (1)=09
#define _PCMCIA1Attr	_PCMCIAAttr (1)=09
#define _PCMCIA1Mem	_PCMCIAMem (1)=09
#define UDCAR_ADD	Fld (7, 0)=09
#define UDCOMP_OUTMAXP	Fld (8, 0)=09
#define UDCIMP_INMAXP	Fld (8, 0)=09
#define UDCD0_DATA	Fld (8, 0)=09
#define UDCWC_WC	Fld (4, 0)=09
#define UDCDR_DATA	Fld (8, 0)=09
#define Ser1UTCR0	_UTCR0 (1)=09
#define Ser1UTCR1	_UTCR1 (1)=09
#define Ser1UTCR2	_UTCR2 (1)=09
#define Ser1UTCR3	_UTCR3 (1)=09
#define Ser1UTDR	_UTDR (1)=09
#define Ser1UTSR0	_UTSR0 (1)=09
#define Ser1UTSR1	_UTSR1 (1)=09
#define Ser2UTCR0	_UTCR0 (2)=09
#define Ser2UTCR1	_UTCR1 (2)=09
#define Ser2UTCR2	_UTCR2 (2)=09
#define Ser2UTCR3	_UTCR3 (2)=09
#define Ser2UTCR4	_UTCR4 (2)=09
#define Ser2UTDR	_UTDR (2)=09
#define Ser2UTSR0	_UTSR0 (2)=09
#define Ser2UTSR1	_UTSR1 (2)=09
#define Ser3UTCR0	_UTCR0 (3)=09
#define Ser3UTCR1	_UTCR1 (3)=09
#define Ser3UTCR2	_UTCR2 (3)=09
#define Ser3UTCR3	_UTCR3 (3)=09
#define Ser3UTDR	_UTDR (3)=09
#define Ser3UTSR0	_UTSR0 (3)=09
#define Ser3UTSR1	_UTSR1 (3)=09
#define UTCR1_BRD	Fld (4, 0)=09
#define UTCR2_BRD	Fld (8, 0)=09
#define UTDR_DATA	Fld (8, 0)=09
#define SDCR2_AMV	Fld (8, 0)=09
#define SDCR3_BRD	Fld (4, 0)=09
#define SDCR4_BRD	Fld (8, 0)=09
#define SDDR_DATA	Fld (8, 0)=09
#define HSCR1_AMV	Fld (8, 0)=09
#define HSDR_DATA	Fld (8, 0)=09
#define MCCR0_ASD	Fld (7, 0)=09
#define MCCR0_TSD	Fld (7, 8)=09
#define MCCR0_ECP	Fld (2, 24)=09
#define MCDR0_DATA	Fld (12, 4)=09
#define MCDR1_DATA	Fld (14, 2)=09
#define MCDR2_DATA	Fld (16, 0)=09
#define MCDR2_ADD	Fld (4, 17)=09
#define SSCR0_DSS	Fld (4, 0)=09
#define SSCR0_FRF	Fld (2, 4)=09
#define SSCR0_SCR	Fld (8, 8)=09
#define SSDR_DATA	Fld (16, 0)=09
#define OSSR_M0 	OSSR_M (0)=09
#define OSSR_M1 	OSSR_M (1)=09
#define OSSR_M2 	OSSR_M (2)=09
#define OSSR_M3 	OSSR_M (3)=09
#define OIER_E0 	OIER_E (0)=09
#define OIER_E1 	OIER_E (1)=09
#define OIER_E2 	OIER_E (2)=09
#define OIER_E3 	OIER_E (3)=09
#define RTTR_C  	Fld (16, 0)=09
#define RTTR_D  	Fld (10, 16)=09
#define PWER_GPIO(Nb)	GPIO_GPIO (Nb)=09
#define PWER_GPIO0	PWER_GPIO (0)=09
#define PWER_GPIO1	PWER_GPIO (1)=09
#define PWER_GPIO2	PWER_GPIO (2)=09
#define PWER_GPIO3	PWER_GPIO (3)=09
#define PWER_GPIO4	PWER_GPIO (4)=09
#define PWER_GPIO5	PWER_GPIO (5)=09
#define PWER_GPIO6	PWER_GPIO (6)=09
#define PWER_GPIO7	PWER_GPIO (7)=09
#define PWER_GPIO8	PWER_GPIO (8)=09
#define PWER_GPIO9	PWER_GPIO (9)=09
#define PWER_GPIO10	PWER_GPIO (10)=09
#define PWER_GPIO11	PWER_GPIO (11)=09
#define PWER_GPIO12	PWER_GPIO (12)=09
#define PWER_GPIO13	PWER_GPIO (13)=09
#define PWER_GPIO14	PWER_GPIO (14)=09
#define PWER_GPIO15	PWER_GPIO (15)=09
#define PWER_GPIO16	PWER_GPIO (16)=09
#define PWER_GPIO17	PWER_GPIO (17)=09
#define PWER_GPIO18	PWER_GPIO (18)=09
#define PWER_GPIO19	PWER_GPIO (19)=09
#define PWER_GPIO20	PWER_GPIO (20)=09
#define PWER_GPIO21	PWER_GPIO (21)=09
#define PWER_GPIO22	PWER_GPIO (22)=09
#define PWER_GPIO23	PWER_GPIO (23)=09
#define PWER_GPIO24	PWER_GPIO (24)=09
#define PWER_GPIO25	PWER_GPIO (25)=09
#define PWER_GPIO26	PWER_GPIO (26)=09
#define PWER_GPIO27	PWER_GPIO (27)=09
#define PPCR_CCF	Fld (5, 0)=09
#define TUCR_CTB	Fld (3, 20)=09
#define TUCR_TSEL	Fld (3, 29)=09
#define GPIO_GPIO0	GPIO_GPIO (0)=09
#define GPIO_GPIO1	GPIO_GPIO (1)=09
#define GPIO_GPIO2	GPIO_GPIO (2)=09
#define GPIO_GPIO3	GPIO_GPIO (3)=09
#define GPIO_GPIO4	GPIO_GPIO (4)=09
#define GPIO_GPIO5	GPIO_GPIO (5)=09
#define GPIO_GPIO6	GPIO_GPIO (6)=09
#define GPIO_GPIO7	GPIO_GPIO (7)=09
#define GPIO_GPIO8	GPIO_GPIO (8)=09
#define GPIO_GPIO9	GPIO_GPIO (9)=09
#define GPIO_GPIO10	GPIO_GPIO (10)=09
#define GPIO_GPIO11	GPIO_GPIO (11)=09
#define GPIO_GPIO12	GPIO_GPIO (12)=09
#define GPIO_GPIO13	GPIO_GPIO (13)=09
#define GPIO_GPIO14	GPIO_GPIO (14)=09
#define GPIO_GPIO15	GPIO_GPIO (15)=09
#define GPIO_GPIO16	GPIO_GPIO (16)=09
#define GPIO_GPIO17	GPIO_GPIO (17)=09
#define GPIO_GPIO18	GPIO_GPIO (18)=09
#define GPIO_GPIO19	GPIO_GPIO (19)=09
#define GPIO_GPIO20	GPIO_GPIO (20)=09
#define GPIO_GPIO21	GPIO_GPIO (21)=09
#define GPIO_GPIO22	GPIO_GPIO (22)=09
#define GPIO_GPIO23	GPIO_GPIO (23)=09
#define GPIO_GPIO24	GPIO_GPIO (24)=09
#define GPIO_GPIO25	GPIO_GPIO (25)=09
#define GPIO_GPIO26	GPIO_GPIO (26)=09
#define GPIO_GPIO27	GPIO_GPIO (27)=09
#define GPIO_LDD8	GPIO_LDD (8)=09
#define GPIO_LDD9	GPIO_LDD (9)=09
#define GPIO_LDD10	GPIO_LDD (10)=09
#define GPIO_LDD11	GPIO_LDD (11)=09
#define GPIO_LDD12	GPIO_LDD (12)=09
#define GPIO_LDD13	GPIO_LDD (13)=09
#define GPIO_LDD14	GPIO_LDD (14)=09
#define GPIO_LDD15	GPIO_LDD (15)=09
#define GPIO_SSP_TXD	GPIO_GPIO (10)=09
#define GPIO_SSP_RXD	GPIO_GPIO (11)=09
#define GPIO_SSP_SCLK	GPIO_GPIO (12)=09
#define GPIO_SSP_SFRM	GPIO_GPIO (13)=09
#define GPIO_UART_TXD	GPIO_GPIO (14)=09
#define GPIO_UART_RXD	GPIO_GPIO (15)=09
#define GPIO_SDLC_SCLK	GPIO_GPIO (16)=09
#define GPIO_SDLC_AAF	GPIO_GPIO (17)=09
#define GPIO_UART_SCLK1	GPIO_GPIO (18)=09
#define GPIO_SSP_CLK	GPIO_GPIO (19)=09
#define GPIO_UART_SCLK3	GPIO_GPIO (20)=09
#define GPIO_MCP_CLK	GPIO_GPIO (21)=09
#define GPIO_TIC_ACK	GPIO_GPIO (21)=09
#define GPIO_MBGNT	GPIO_GPIO (21)=09
#define GPIO_TREQA	GPIO_GPIO (22)=09
#define GPIO_MBREQ	GPIO_GPIO (22)=09
#define GPIO_TREQB	GPIO_GPIO (23)=09
#define GPIO_1Hz	GPIO_GPIO (25)=09
#define GPIO_RCLK	GPIO_GPIO (26)=09
#define GPIO_32_768kHz	GPIO_GPIO (27)=09
#define IC_GPIO0	IC_GPIO (0)=09
#define IC_GPIO1	IC_GPIO (1)=09
#define IC_GPIO2	IC_GPIO (2)=09
#define IC_GPIO3	IC_GPIO (3)=09
#define IC_GPIO4	IC_GPIO (4)=09
#define IC_GPIO5	IC_GPIO (5)=09
#define IC_GPIO6	IC_GPIO (6)=09
#define IC_GPIO7	IC_GPIO (7)=09
#define IC_GPIO8	IC_GPIO (8)=09
#define IC_GPIO9	IC_GPIO (9)=09
#define IC_GPIO10	IC_GPIO (10)=09
#define IC_DMA0 	IC_DMA (0)=09
#define IC_DMA1 	IC_DMA (1)=09
#define IC_DMA2 	IC_DMA (2)=09
#define IC_DMA3 	IC_DMA (3)=09
#define IC_DMA4 	IC_DMA (4)=09
#define IC_DMA5 	IC_DMA (5)=09
#define IC_OST0 	IC_OST (0)=09
#define IC_OST1 	IC_OST (1)=09
#define IC_OST2 	IC_OST (2)=09
#define IC_OST3 	IC_OST (3)=09
#define PPC_LDD0	PPC_LDD (0)=09
#define PPC_LDD1	PPC_LDD (1)=09
#define PPC_LDD2	PPC_LDD (2)=09
#define PPC_LDD3	PPC_LDD (3)=09
#define PPC_LDD4	PPC_LDD (4)=09
#define PPC_LDD5	PPC_LDD (5)=09
#define PPC_LDD6	PPC_LDD (6)=09
#define PPC_LDD7	PPC_LDD (7)=09
#define MDCNFG_DE0	MDCNFG_DE (0)=09
#define MDCNFG_DE1	MDCNFG_DE (1)=09
#define MDCNFG_DE2	MDCNFG_DE (2)=09
#define MDCNFG_DE3	MDCNFG_DE (3)=09
#define MDCNFG_DRAC	Fld (2, 4)=09
#define MDCNFG_TRP	Fld (4, 7)=09
#define MDCNFG_TRASR	Fld (4, 11)=09
#define MDCNFG_TDL	Fld (2, 15)=09
#define MDCNFG_DRI	Fld (15, 17)=09
#define MSC0_Bnk0	MSC_Bnk (0)=09
#define MSC0_Bnk1	MSC_Bnk (1)=09
#define MSC1_Bnk2	MSC_Bnk (2)=09
#define MSC1_Bnk3	MSC_Bnk (3)=09
#define MSC_RT  	Fld (2, 0)=09
#define MSC_RDF 	Fld (5, 3)=09
#define MSC_RDN 	Fld (5, 8)=09
#define MSC_RRR 	Fld (3, 13)=09
#define MECR_PCMCIA0	MECR_PCMCIA (0)=09
#define MECR_PCMCIA1	MECR_PCMCIA (1)=09
#define MECR_BSIO	Fld (5, 0)=09
#define MECR_BSA	Fld (5, 5)=09
#define MECR_BSM	Fld (5, 10)=09
#define MDREFR_TRASR		Fld (4, 0)
#define MDREFR_DRI		Fld (12, 4)
#define LCD_PGrey	Fld (4, 0)=09
#define LCD_PBlue	Fld (4, 0)=09
#define LCD_PGreen	Fld (4, 4)=09
#define LCD_PRed	Fld (4, 8)=09
#define LCD_PBS 	Fld (2, 12)=09
#define LCCR0_PDD	Fld (8, 12)=09
#define LCCR1_PPL	Fld (6, 4)=09
#define LCCR1_HSW	Fld (6, 10)=09
#define LCCR1_ELW	Fld (8, 16)=09
#define LCCR1_BLW	Fld (8, 24)=09
#define LCCR2_LPP	Fld (10, 0)=09
#define LCCR2_VSW	Fld (6, 10)=09
#define LCCR2_EFW	Fld (8, 16)=09
#define LCCR2_BFW	Fld (8, 24)=09
#define LCCR3_PCD	Fld (8, 0)=09
#define LCCR3_ACB	Fld (8, 8)=09
#define LCCR3_API	Fld (4, 16)=09
#define UFSR_FifoGTnFlag	0x01		#define UFSR_FifoEmpty		0x80		/* FIFO is emp=
ty */
#define ASSABET_GPIO_RADIO_IRQ		GPIO_GPIO (14)=09
#define ASSABET_GPIO_PS_MODE_SYNC	GPIO_GPIO (16)=09
#define ASSABET_GPIO_STEREO_64FS_CLK	GPIO_GPIO (19)=09
#define ASSABET_GPIO_GFX_IRQ		GPIO_GPIO (24)=09
#define ASSABET_GPIO_BATT_LOW		GPIO_GPIO (26)=09
#define ASSABET_GPIO_RCLK		GPIO_GPIO (26)=09
#define SHANNON_GPIO_SPI_FLASH		GPIO_GPIO (0)=09
#define SHANNON_GPIO_SPI_DSP		GPIO_GPIO (1)=09
#define SHANNON_GPIO_SPI_OUTPUT		GPIO_GPIO (10)=09
#define SHANNON_GPIO_SPI_INPUT		GPIO_GPIO (11)=09
#define SHANNON_GPIO_SPI_CLOCK		GPIO_GPIO (12)=09
#define SHANNON_GPIO_SPI_FRAME		GPIO_GPIO (13)=09
#define SHANNON_GPIO_SPI_RTS		GPIO_GPIO (14)=09
#define SHANNON_GPIO_SPI_CTS		GPIO_GPIO (15)=09
#define SHANNON_GPIO_IRQ_CODEC		GPIO_GPIO (16)=09
#define SHANNON_GPIO_DSP_RESET		GPIO_GPIO (17)=09
#define SHANNON_GPIO_CODEC_RESET	GPIO_GPIO (18)=09
#define SHANNON_GPIO_U3_RTS		GPIO_GPIO (19)=09
#define SHANNON_GPIO_U3_CTS		GPIO_GPIO (20)=09
#define SHANNON_GPIO_SENSE_12V		GPIO_GPIO (21)=09
#define EPSONFBLEN	512*1024
#define PM_OPS &neponset_pm_ops
#define SAVE(x)		sleep_save[SLEEP_SAVE_##x] =3D x
#define RESTORE(x)	x =3D sleep_save[SLEEP_SAVE_##x]
#define INTC_PINT_E_NONE 0, 0, 0, 0, 0, 0, 0, 0,
#define PORT185CR      (void __iomem *)0xe60520b9
#define PORT186CR      (void __iomem *)0xe60520ba
#define PORT187CR      (void __iomem *)0xe60520bb
#define PORT188CR      (void __iomem *)0xe60520bc
#define PORTR191_160DR (void __iomem *)0xe6056014
#define PORT0CR      (void __iomem *)0xe6051000
#define PORT1CR      (void __iomem *)0xe6051001
#define PORT2CR      (void __iomem *)0xe6051002
#define PORT159CR    (void __iomem *)0xe605009f
#define PORTR031_000DR (void __iomem *)0xe6055000
#define PORTL159_128DR (void __iomem *)0xe6054010
#define irq_cb(cb, irq) irq_get_chip(irq)->cb(irq_get_irq_data(irq))
#define irq_cbp(cb, irq, p...) irq_get_chip(irq)->cb(irq_get_irq_data(irq),=
 p)
#define _GP_INOUTSEL(pfx, sfx) GP##pfx##_IN, GP##pfx##_OUT
#define IOMEM(a) (void __iomem *) a
#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
#define VERSATILE_PCI_VIRT_BASE		(void __iomem *)0xe8000000ul
#define VERSATILE_PCI_CFG_VIRT_BASE	(void __iomem *)0xe9000000ul
#define debug_writel(val)	outer_cache.set_debug(val)
#define MLK(b, t) b, t, ((t) - (b)) >> 10
#define MLM(b, t) b, t, ((t) - (b)) >> 20
#define MLK_ROUNDUP(b, t) b, t, DIV_ROUND_UP(((t) - (b)), SZ_1K)
#define PROT_PTE_DEVICE		L_PTE_PRESENT|L_PTE_YOUNG|L_PTE_DIRTY|L_PTE_XN
#define PROT_SECT_DEVICE	PMD_TYPE_SECT|PMD_SECT_AP_WRITE
#define __pgd_alloc()	(pgd_t *)__get_free_pages(GFP_KERNEL, 2)
#define INLINE static inline
#define MASK_RFC	~MASK_RESET
#define mfpr_sync()	(void)__raw_readl(mfpr_mmio_base + mfpr_off_readback)
#define print_ns(x) ((x) / 10), ((x) % 10)
#define print_ns(x) ((x) / 10), ((x) % 10)
#define print_ns(x) ((x) / 10), ((x) % 10)
#define print_mhz(m) ((m) / MHZ), (((m) / 1000) % 1000)
#define uart_base S3C_PA_UART + (S3C_UART_OFFSET * CONFIG_S3C_LOWLEVEL_UART=
_PORT)
#define vfpreg(_vfp_) #_vfp_
#define mask_interrupts		ssrf	SYSREG_GM_OFFSET
#define mask_exceptions		ssrf	SYSREG_EM_OFFSET
#define unmask_interrupts	csrf	SYSREG_GM_OFFSET
#define unmask_exceptions	csrf	SYSREG_EM_OFFSET
#define atomic_sub(i, v)	(void)atomic_sub_return(i, v)
#define atomic_add(i, v)	(void)atomic_add_return(i, v)
#define flush_write_buffer() asm volatile("sync 0" : : : "memory")
#define __ALIGN .balign 2
#define cpu_sync_pipeline()	asm volatile("sub pc, -2" : : : "memory")
#define __tag __used __attribute__((__section__(".taglist.init")))
#define sa_sigaction	_u._sa_sigaction
#define nop() asm volatile("nop")
#define mb()			asm volatile("" : : : "memory")
#define wmb()			asm volatile("sync 0" : : : "memory")
#define COPY(x)		err |=3D __get_user(regs->x, &sc->x)
#define COPY(x)		err |=3D __put_user(regs->x, &sc->x)
#define BFIN_SIMPLE_TIMER_IOCTL_MAGIC 't'
#define SPORT_IOC_MAGIC		'P'
#define CPLB_DEF_CACHE		CPLB_L1_CHBL | CPLB_WT
#define CPLB_CACHE_ENABLED	CPLB_L1_CHBL | CPLB_DIRTY
#define CPLB_I_PAGE_MGMT	CPLB_LOCK | CPLB_VALID
#define CPLB_D_PAGE_MGMT	CPLB_LOCK | CPLB_ALL_ACCESS | CPLB_VALID
#define CPLB_DNOCACHE		CPLB_ALL_ACCESS | CPLB_VALID
#define CPLB_DDOCACHE		CPLB_DNOCACHE | CPLB_DEF_CACHE
#define CPLB_INOCACHE   	CPLB_USER_RD | CPLB_VALID
#define CPLB_IDOCACHE   	CPLB_INOCACHE | CPLB_L1_CHBL
#define CPLB_ALL_ACCESS CPLB_SUPV_WR | CPLB_USER_RD | CPLB_USER_WR
#define ELF_PLAT_INIT(_r)	_r->p1 =3D 0
#define NUMREGBYTES BFIN_NUM_REGS*4
#define __ALIGN .align 4
#define mem_SDRRC       (((CONFIG_SCLK_HZ / 1000) * SDRAM_Tref) / SDRAM_NRA=
) - (SDRAM_tRAS_num + SDRAM_tRP_num)
#define lock_mm_switch(flags)	flags =3D hard_local_irq_save_cond()
#define si_uid16	_sifields._kill._uid
#define nop()  __asm__ __volatile__ ("nop;\n\t" : : )
#define DEFAULT_CFLAG CS8|B57600
#define RESTORE(x) err |=3D __get_user(regs->x, &sc->sc_##x)
#define SETUP(x) err |=3D __put_user(regs->x, &sc->sc_##x)
#define P1_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P2_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P3_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P4_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P5_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P6_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P7_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define P9_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P10_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P11_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P12_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P13_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P14_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P15_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define P17_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P18_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P19_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P20_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P21_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P22_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P23_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define P25_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P26_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P27_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P28_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P29_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P30_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P31_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define                   HOST_CNTR_ nBT_EN  0x0
#define P1_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P2_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P3_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P4_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P5_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P6_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P7_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define P9_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P10_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P11_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P12_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P13_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P14_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P15_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define P17_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P18_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P19_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P20_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P21_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P22_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P23_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define P25_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P26_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P27_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P28_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P29_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P30_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P31_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define                   HOST_CNTR_ nBT_EN  0x0
#define P1_IVG(x)    ((x)-7) << 0x4=09
#define P2_IVG(x)    ((x)-7) << 0x8=09
#define P3_IVG(x)    ((x)-7) << 0xC=09
#define P4_IVG(x)    ((x)-7) << 0x10=09
#define P5_IVG(x)    ((x)-7) << 0x14=09
#define P6_IVG(x)    ((x)-7) << 0x18=09
#define P7_IVG(x)    ((x)-7) << 0x1C=09
#define P9_IVG(x)     ((x)-7) << 0x4=09
#define P10_IVG(x)    ((x)-7) << 0x8=09
#define P11_IVG(x)    ((x)-7) << 0xC=09
#define P12_IVG(x)    ((x)-7) << 0x10=09
#define P13_IVG(x)    ((x)-7) << 0x14=09
#define P14_IVG(x)    ((x)-7) << 0x18=09
#define P15_IVG(x)    ((x)-7) << 0x1C=09
#define P17_IVG(x)    ((x)-7) << 0x4=09
#define P18_IVG(x)    ((x)-7) << 0x8=09
#define P19_IVG(x)    ((x)-7) << 0xC=09
#define P20_IVG(x)    ((x)-7) << 0x10=09
#define P21_IVG(x)    ((x)-7) << 0x14=09
#define P22_IVG(x)    ((x)-7) << 0x18=09
#define P23_IVG(x)    ((x)-7) << 0x1C=09
#define bfin_read_CAN_AM_L(x)()              bfin_read16(CAN_AM_L(x))
#define bfin_write_CAN_AM_L(x)(val)          bfin_write16(CAN_AM_L(x),val)
#define bfin_read_CAN_AM_H(x)()              bfin_read16(CAN_AM_H(x))
#define bfin_write_CAN_AM_H(x)(val)          bfin_write16(CAN_AM_H(x),val)
#define bfin_read_CAN_MB_ID1(x)()            bfin_read16(CAN_MB_ID1(x))
#define bfin_write_CAN_MB_ID1(x)(val)        bfin_write16(CAN_MB_ID1(x),val)
#define bfin_read_CAN_MB_ID0(x)()            bfin_read16(CAN_MB_ID0(x))
#define bfin_write_CAN_MB_ID0(x)(val)        bfin_write16(CAN_MB_ID0(x),val)
#define bfin_read_CAN_MB_TIMESTAMP(x)()      bfin_read16(CAN_MB_TIMESTAMP(x=
))
#define bfin_write_CAN_MB_TIMESTAMP(x)(val)  bfin_write16(CAN_MB_TIMESTAMP(=
x),val)
#define bfin_read_CAN_MB_LENGTH(x)()         bfin_read16(CAN_MB_LENGTH(x))
#define bfin_write_CAN_MB_LENGTH(x)(val)     bfin_write16(CAN_MB_LENGTH(x),=
val)
#define bfin_read_CAN_MB_DATA3(x)()          bfin_read16(CAN_MB_DATA3(x))
#define bfin_write_CAN_MB_DATA3(x)(val)      bfin_write16(CAN_MB_DATA3(x),v=
al)
#define bfin_read_CAN_MB_DATA2(x)()          bfin_read16(CAN_MB_DATA2(x))
#define bfin_write_CAN_MB_DATA2(x)(val)      bfin_write16(CAN_MB_DATA2(x),v=
al)
#define bfin_read_CAN_MB_DATA1(x)()          bfin_read16(CAN_MB_DATA1(x))
#define bfin_write_CAN_MB_DATA1(x)(val)      bfin_write16(CAN_MB_DATA1(x),v=
al)
#define bfin_read_CAN_MB_DATA0(x)()          bfin_read16(CAN_MB_DATA0(x))
#define bfin_write_CAN_MB_DATA0(x)(val)      bfin_write16(CAN_MB_DATA0(x),v=
al)
#define P1_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P2_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P3_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P4_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P5_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P6_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P7_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define P9_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P10_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P11_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P12_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P13_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P14_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P15_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define P17_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P18_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P19_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P20_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P21_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P22_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P23_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define P25_IVG(x)		(((x)&0xF)-7) << 0x4=09
#define P26_IVG(x)		(((x)&0xF)-7) << 0x8=09
#define P27_IVG(x)		(((x)&0xF)-7) << 0xC=09
#define P28_IVG(x)		(((x)&0xF)-7) << 0x10=09
#define P29_IVG(x)		(((x)&0xF)-7) << 0x14=09
#define P30_IVG(x)		(((x)&0xF)-7) << 0x18=09
#define P31_IVG(x)		(((x)&0xF)-7) << 0x1C=09
#define __ALIGN		.align 2
#define __SYSCALL(nr, call) [nr] =3D (call),
#define i2c_enable() *R_PORT_PB_I2C =3D (port_pb_i2c_shadow |=3D IO_MASK(R_=
PORT_PB_I2C, i2c_en))
#define i2c_disable() *R_PORT_PB_I2C =3D (port_pb_i2c_shadow &=3D ~IO_MASK(=
R_PORT_PB_I2C, i2c_en))
#define BITOFF *((unsigned char *)0xb0000030) =3D 0xff
#define BITON *((unsigned char *)0xb0000030) =3D 0x0
#define OUT_BUFFER_SIZE 1024*8
#define FLUSH_ALL (void*)0xffffffff
#define RESERVED_SIZE 66*1024
#define STRINGIFY(x) #x
#define REG_SHADOW_SET(r,s,b,v) *r =3D s =3D (s & ~(1 << (b))) | ((v) << (b=
))
#define __STR(x) #x
#define IO_MASK(reg, field) IO_MASK_ (reg##_, field##_)
#define IO_STATE(reg, field, state) IO_STATE_ (reg##_, field##_, _##state)
#define IO_EXTRACT(reg, field, val) IO_EXTRACT_ (reg##_, field##_, val)
#define IO_FIELD(reg, field, val) IO_FIELD_ (reg##_, field##_, val)
#define IO_BITNR(reg, field) IO_BITNR_ (reg##_, field##_)
#define IO_WIDTH(reg, field) IO_WIDTH_ (reg##_, field##_)
#define BUG() __asm__ __volatile__ ("break 14\n\t")
#define STRINGIFYFY(i) #i
#define CRIS_LED_NETWORK_GRP0_SET(x) while (0) {}
#define CRIS_LED_NETWORK_GRP1_SET(x) while (0) {}
#define STR2(x) #x
#define wrusp(usp) __asm__ __volatile__ ("move %0, $usp" : : "rm" (usp))
#define NETWORK_ETH0 RX_DMA_NBR 1=09
#define set_bit(nr, addr)    (void)test_and_set_bit(nr, addr)
#define clear_bit(nr, addr)  (void)test_and_clear_bit(nr, addr)
#define change_bit(nr, addr) (void)test_and_change_bit(nr, addr)
#define SET_ETH_SPEED_10        SIOCDEVPRIVATE+1       =20
#define SET_ETH_SPEED_100       SIOCDEVPRIVATE+2       =20
#define SET_ETH_DUPLEX_AUTO     SIOCDEVPRIVATE+3       =20
#define SET_ETH_DUPLEX_HALF     SIOCDEVPRIVATE+4       =20
#define SET_ETH_DUPLEX_FULL     SIOCDEVPRIVATE+5       =20
#define SET_ETH_ENABLE_LEDS     SIOCDEVPRIVATE+6       =20
#define SET_ETH_DISABLE_LEDS    SIOCDEVPRIVATE+7       =20
#define SET_ETH_AUTONEG         SIOCDEVPRIVATE+8
#define outb(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(uns=
igned)data,1,1)
#define outw(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(uns=
igned)data,2,1)
#define outl(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(uns=
igned)data,4,1)
#define outsb(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void=
*)addr,1,count)
#define outsw(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void=
*)addr,2,count)
#define outsl(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void=
*)addr,3,count)
#define RTC_MAGIC 'p'
#define sa_sigaction	_u._sa_sigaction
#define barrier() __asm__ __volatile__("": : :"memory")
#define BLANK() asm volatile("\n->" : : )
#define __ALIGN		.align 4
#define FPDATA		%a2
#define __reg_MB86943_sl_ctl		*(volatile uint32_t *) (__region_CS1 + 0x00)
#define __reg_MB86943_ecs_ctl(N)	*(volatile uint32_t *) (__region_CS1 + 0x0=
8 + (0x08*(N)))
#define __reg_MB86943_ecs_range(N)	*(volatile uint32_t *) (__region_CS1 + 0=
x20 + (0x10*(N)))
#define __reg_MB86943_ecs_base(N)	*(volatile uint32_t *) (__region_CS1 + 0x=
28 + (0x10*(N)))
#define __reg_MB86943_sl_pci_io_range	*(volatile uint32_t *) (__region_CS1 =
+ 0x50)
#define __reg_MB86943_sl_pci_io_base	*(volatile uint32_t *) (__region_CS1 +=
 0x58)
#define __reg_MB86943_sl_pci_mem_range	*(volatile uint32_t *) (__region_CS1=
 + 0x60)
#define __reg_MB86943_sl_pci_mem_base	*(volatile uint32_t *) (__region_CS1 =
+ 0x68)
#define __reg_MB86943_pci_sl_io_base	*(volatile uint32_t *) (__region_CS1 +=
 0x70)
#define __reg_MB86943_pci_sl_mem_base	*(volatile uint32_t *) (__region_CS1 =
+ 0x78)
#define __reg_MB86943_pci_arbiter	*(volatile uint32_t *) (__region_CS2 + 0x=
01300014)
#define sa_sigaction	_u._sa_sigaction
#define nop()			asm volatile ("nop"::)
#define mb()			asm volatile ("membar" : : :"memory")
#define rmb()			asm volatile ("membar" : : :"memory")
#define wmb()			asm volatile ("membar" : : :"memory")
#define UART_RX		0*8=09
#define UART_TX		0*8=09
#define UART_DLL	0*8=09
#define UART_DLM	1*8=09
#define UART_IER	1*8=09
#define UART_IIR	2*8=09
#define UART_FCR	2*8=09
#define UART_LCR	3*8=09
#define UART_MCR	4*8=09
#define UART_LSR	5*8=09
#define UART_MSR	6*8=09
#define UART_SCR	7*8=09
#define memzero(s, n)     memset ((s), 0, (n))
#define SCR *((volatile unsigned char *)0xffff8a)
#define TDR *((volatile unsigned char *)0xffff8b)
#define SSR *((volatile unsigned char *)0xffff8c)
#define ELF_PLAT_INIT(_r)	_r->er1 =3D 0
#define IER_REGS *(volatile unsigned char *)IER
#define IER_REGS *(volatile unsigned short *)IER
#define SYMBOL_NAME_LABEL(_name_) _##_name_##:
#define sa_sigaction	_u._sa_sigaction
#define iret() __asm__ __volatile__ ("rte": : :"memory", "sp", "cc")
#define nop()  asm volatile ("nop"::)
#define mb()   asm volatile (""   : : :"memory")
#define rmb()  asm volatile (""   : : :"memory")
#define wmb()  asm volatile (""   : : :"memory")
#define COPY(r) err |=3D __get_user(regs->r, &usc->sc_##r)   =20
#define H8300_TIMER_FREQ CONFIG_CPU_CLOCK*10000=20
#define __ALIGN		.align 4
#define qstr(s) #s
#define __SYSCALL(nr, call) [nr] =3D (call),
#define MACHVEC_PLATFORM_HEADER		<asm/machvec_dig.h>
#define MACHVEC_PLATFORM_HEADER		<asm/machvec_dig_vtd.h>
#define RESMAP_MASK(n)    ~(~0UL << (n))
#define MACHVEC_PLATFORM_HEADER		<asm/machvec_hpsim.h>
#define MACHVEC_PLATFORM_HEADER		<asm/machvec_hpzx1.h>
#define MACHVEC_PLATFORM_HEADER		<asm/machvec_hpzx1_swiotlb.h>
#define ia64_barrier()	asm volatile ("":::"memory")
#define ia64_stop()	asm volatile (";;"::)
#define ia64_invala_gr(regnum)	asm volatile ("invala.e r%0" :: "i"(regnum))
#define ia64_invala_fr(regnum)	asm volatile ("invala.e f%0" :: "i"(regnum))
#define ia64_flushrs() asm volatile ("flushrs;;":::"memory")
#define ia64_loadrs() asm volatile ("loadrs;;":::"memory")
#define ia64_mf()	asm volatile ("mf" ::: "memory")
#define ia64_mfa()	asm volatile ("mf.a" ::: "memory")
#define ia64_invala() asm volatile ("invala" ::: "memory")
#define ia64_srlz_i()	asm volatile (";; srlz.i ;;" ::: "memory")
#define ia64_itci(addr)	asm volatile ("itc.i %0;;" :: "r"(addr) : "memory")
#define ia64_itcd(addr)	asm volatile ("itc.d %0;;" :: "r"(addr) : "memory")
#define ia64_native_fc(addr)	asm volatile ("fc %0" :: "r"(addr) : "memory")
#define ia64_sync_i()	asm volatile (";; sync.i" ::: "memory")
#define ia64_native_ssm(mask)	asm volatile ("ssm %0":: "i"((mask)) : "memor=
y")
#define ia64_native_rsm(mask)	asm volatile ("rsm %0":: "i"((mask)) : "memor=
y")
#define ia64_sum(mask)	asm volatile ("sum %0":: "i"((mask)) : "memory")
#define ia64_rum(mask)	asm volatile ("rum %0":: "i"((mask)) : "memory")
#define ia64_ptce(addr)	asm volatile ("ptc.e %0" :: "r"(addr))
#define irq_to_domain(x)	irq_cfg[(x)].domain
#define KVM_CONTEXT_SIZE	8*1024
#define asmlinkage CPP_ASMLINKAGE __attribute__((syscall_linkage))
#define cmcv_mask		cmcv_reg_s.cmcr_mask
#define cmcv_vector		cmcv_reg_s.cmcr_vector
#define pcci_ld_hints		pcci_info_1.pcci1_bits.load_hints
#define pcci_st_hints		pcci_info_1.pcci1_bits.store_hints
#define pcci_ld_latency		pcci_info_1.pcci1_bits.load_latency
#define pcci_st_latency		pcci_info_1.pcci1_bits.store_latency
#define pcci_stride		pcci_info_1.pcci1_bits.stride
#define pcci_line_size		pcci_info_1.pcci1_bits.line_size
#define pcci_assoc		pcci_info_1.pcci1_bits.associativity
#define pcci_cache_attr		pcci_info_1.pcci1_bits.at
#define pcci_unified		pcci_info_1.pcci1_bits.u
#define pcci_tag_msb		pcci_info_2.pcci2_bits.tag_ms_bit
#define pcci_tag_lsb		pcci_info_2.pcci2_bits.tag_ls_bit
#define pcci_alias_boundary	pcci_info_2.pcci2_bits.alias_boundary
#define pcci_cache_size		pcci_info_2.pcci2_bits.cache_size
#define pcpi_cache_prot_part	pcp_info.t_d
#define pcpi_prot_method	pcp_info.method
#define pcpi_prot_bits		pcp_info.prot_bits
#define pcpi_tagprot_msb	pcp_info.tagprot_msb
#define pcpi_tagprot_lsb	pcp_info.tagprot_lsb
#define pcpi_data_bits		pcp_info.data_bits
#define pclid_read_part		pclid_info_read.part
#define pclid_read_way		pclid_info_read.way
#define pclid_read_level	pclid_info_read.level
#define pclid_read_cache_type	pclid_info_read.cache_type
#define pclid_write_trigger	pclid_info_write.trigger
#define pclid_write_length	pclid_info_write.length
#define pclid_write_start	pclid_info_write.start
#define pclid_write_mesi	pclid_info_write.mesi
#define pclid_write_part	pclid_info_write.part
#define pclid_write_way		pclid_info_write.way
#define pclid_write_level	pclid_info_write.level
#define pclid_write_cache_type	pclid_info_write.cache_type
#define pmci_proc_unknown_check			pme_processor.uc
#define pmci_proc_bus_check			pme_processor.bc
#define pmci_proc_tlb_check			pme_processor.tc
#define pmci_proc_cache_check			pme_processor.cc
#define pmci_proc_dynamic_state_size		pme_processor.dsize
#define pmci_proc_gpr_valid			pme_processor.gr
#define pmci_proc_preserved_bank0_gpr_valid	pme_processor.b0
#define pmci_proc_preserved_bank1_gpr_valid	pme_processor.b1
#define pmci_proc_fp_valid			pme_processor.fp
#define pmci_proc_predicate_regs_valid		pme_processor.pr
#define pmci_proc_branch_regs_valid		pme_processor.br
#define pmci_proc_app_regs_valid		pme_processor.ar
#define pmci_proc_region_regs_valid		pme_processor.rr
#define pmci_proc_translation_regs_valid	pme_processor.tr
#define pmci_proc_debug_regs_valid		pme_processor.dr
#define pmci_proc_perf_counters_valid		pme_processor.pc
#define pmci_proc_control_regs_valid		pme_processor.cr
#define pmci_proc_machine_check_expected	pme_processor.ex
#define pmci_proc_machine_check_corrected	pme_processor.cm
#define pmci_proc_rse_valid			pme_processor.rs
#define pmci_proc_machine_check_or_init		pme_processor.in
#define pmci_proc_dynamic_state_valid		pme_processor.dy
#define pmci_proc_operation			pme_processor.op
#define pmci_proc_trap_lost			pme_processor.tl
#define pmci_proc_hardware_damage		pme_processor.hd
#define pmci_proc_uncontained_storage_damage	pme_processor.us
#define pmci_proc_machine_check_isolated	pme_processor.ci
#define pmci_proc_continuable			pme_processor.co
#define pmci_proc_storage_intergrity_synced	pme_processor.sy
#define pmci_proc_min_state_save_area_regd	pme_processor.mn
#define pmci_proc_pal_attempted_rendezvous	pme_processor.ra
#define pmci_proc_pal_rendezvous_complete	pme_processor.rz
#define pmci_cache_level			pme_cache.level
#define pmci_cache_line_state			pme_cache.mesi
#define pmci_cache_line_state_valid		pme_cache.mv
#define pmci_cache_line_index			pme_cache.index
#define pmci_cache_instr_cache_fail		pme_cache.ic
#define pmci_cache_data_cache_fail		pme_cache.dc
#define pmci_cache_line_tag_fail		pme_cache.tl
#define pmci_cache_line_data_fail		pme_cache.dl
#define pmci_cache_operation			pme_cache.op
#define pmci_cache_way_valid			pme_cache.wv
#define pmci_cache_target_address_valid		pme_cache.tv
#define pmci_cache_way				pme_cache.way
#define pmci_cache_mc				pme_cache.mc
#define pmci_tlb_instr_translation_cache_fail	pme_tlb.itc
#define pmci_tlb_data_translation_cache_fail	pme_tlb.dtc
#define pmci_tlb_instr_translation_reg_fail	pme_tlb.itr
#define pmci_tlb_data_translation_reg_fail	pme_tlb.dtr
#define pmci_tlb_translation_reg_slot		pme_tlb.tr_slot
#define pmci_tlb_mc				pme_tlb.mc
#define pmci_bus_status_info			pme_bus.bsi
#define pmci_bus_req_address_valid		pme_bus.rq
#define pmci_bus_resp_address_valid		pme_bus.rp
#define pmci_bus_target_address_valid		pme_bus.tv
#define pmci_bus_error_severity			pme_bus.sev
#define pmci_bus_transaction_type		pme_bus.type
#define pmci_bus_cache_cache_transfer		pme_bus.cc
#define pmci_bus_transaction_size		pme_bus.size
#define pmci_bus_internal_error			pme_bus.ib
#define pmci_bus_external_error			pme_bus.eb
#define pmci_bus_mc				pme_bus.mc
#define tc_reduce_tr		pal_tc_info_s.reduce_tr
#define tc_unified		pal_tc_info_s.unified
#define tc_pf			pal_tc_info_s.pf
#define tc_num_entries		pal_tc_info_s.num_entries
#define tc_associativity	pal_tc_info_s.associativity
#define tc_num_sets		pal_tc_info_s.num_sets
#define overview_num_log	overview.overview_bits.num_log
#define overview_tpc		overview.overview_bits.tpc
#define overview_cpp		overview.overview_bits.cpp
#define overview_ppid		overview.overview_bits.ppid
#define log1_tid		ppli1.ppli1_bits.tid
#define log1_cid		ppli1.ppli1_bits.cid
#define log2_la			ppli2.ppli2_bits.la
#define paravirt_ssm_i()	pv_cpu_ops.ssm_i()
#define paravirt_rsm_i()	pv_cpu_ops.rsm_i()
#define __paravirt_getreg()	pv_cpu_ops.getreg()
#define __ACCESS_BITS		_PAGE_ED | _PAGE_A | _PAGE_P | _PAGE_MA_WB
#define __DIRTY_BITS_NO_ED	_PAGE_A | _PAGE_P | _PAGE_D | _PAGE_MA_WB
#define __DIRTY_BITS		_PAGE_ED | __DIRTY_BITS_NO_ED
#define si_imm		_sifields._sigfault._imm=09
#define si_flags	_sifields._sigfault._flags
#define si_isr		_sifields._sigfault._isr
#define NASID_GET(x)		(int) (((u64) (x) >> NASID_SHIFT) & NASID_BITMASK)
#define INVALID_SLAB            (slabid_t)-1
#define INVALID_SLOT            (slotid_t)-1
#define iu_rbr u1.rbr
#define iu_thr u1.thr
#define iu_dll u1.dll
#define iu_ier u2.ier
#define iu_dlm u2.dlm
#define iu_iir u3.iir
#define iu_fcr u3.fcr
#define a_sidn		ii_icrb0_a_fld_s.ia_sidn
#define a_tnum		ii_icrb0_a_fld_s.ia_tnum
#define a_addr          ii_icrb0_a_fld_s.ia_addr
#define a_valid         ii_icrb0_a_fld_s.ia_vld
#define a_iow           ii_icrb0_a_fld_s.ia_iow
#define b_use_old       ii_icrb0_b_fld_s.ib_use_old
#define b_imsgtype      ii_icrb0_b_fld_s.ib_imsgtype
#define b_imsg          ii_icrb0_b_fld_s.ib_imsg
#define b_initiator     ii_icrb0_b_fld_s.ib_init
#define b_exc           ii_icrb0_b_fld_s.ib_exc
#define b_ackcnt        ii_icrb0_b_fld_s.ib_ack_cnt
#define b_resp          ii_icrb0_b_fld_s.ib_resp
#define b_ack           ii_icrb0_b_fld_s.ib_ack
#define b_hold          ii_icrb0_b_fld_s.ib_hold
#define b_wb            ii_icrb0_b_fld_s.ib_wb
#define b_intvn         ii_icrb0_b_fld_s.ib_intvn
#define b_stall_ib      ii_icrb0_b_fld_s.ib_stall_ib
#define b_stall_int     ii_icrb0_b_fld_s.ib_stall__intr
#define b_stall_bte_0   ii_icrb0_b_fld_s.ib_stall__bte_0
#define b_stall_bte_1   ii_icrb0_b_fld_s.ib_stall__bte_1
#define b_error         ii_icrb0_b_fld_s.ib_error
#define b_ecode         ii_icrb0_b_fld_s.ib_errcode
#define b_lnetuce       ii_icrb0_b_fld_s.ib_ln_uce
#define b_mark          ii_icrb0_b_fld_s.ib_mark
#define b_xerr          ii_icrb0_b_fld_s.ib_xt_err
#define c_suppl         ii_icrb0_c_fld_s.ic_suppl
#define c_barrop        ii_icrb0_c_fld_s.ic_bo
#define c_doresp        ii_icrb0_c_fld_s.ic_resprqd
#define c_gbr           ii_icrb0_c_fld_s.ic_gbr
#define c_btenum        ii_icrb0_c_fld_s.ic_bte_num
#define c_cohtrans      ii_icrb0_c_fld_s.ic_ct
#define c_xtsize        ii_icrb0_c_fld_s.ic_size
#define c_source        ii_icrb0_c_fld_s.ic_source
#define d_sleep         ii_icrb0_d_fld_s.id_sleep
#define d_pricnt        ii_icrb0_d_fld_s.id_pr_cnt
#define d_pripsc        ii_icrb0_d_fld_s.id_pr_psc
#define d_bteop         ii_icrb0_d_fld_s.id_bte_op
#define d_bteaddr       ii_icrb0_d_fld_s.id_pa_be=09
#define d_benable       ii_icrb0_d_fld_s.id_pa_be=09
#define icrbe_ctxtvld   ii_icrb0_e_fld_s.ie_cvld
#define icrbe_toutvld   ii_icrb0_e_fld_s.ie_tvld
#define icrbe_context   ii_icrb0_e_fld_s.ie_context
#define icrbe_timeout   ii_icrb0_e_fld_s.ie_timeout
#define iprb_mult_err	ii_iprb0_fld_s.i_mult_err
#define iprb_spur_rd	ii_iprb0_fld_s.i_spur_rd
#define iprb_spur_wr	ii_iprb0_fld_s.i_spur_wr
#define iprb_rd_to	ii_iprb0_fld_s.i_rd_to
#define iprb_ovflow     ii_iprb0_fld_s.i_of_cnt
#define iprb_error      ii_iprb0_fld_s.i_error
#define iprb_ff         ii_iprb0_fld_s.i_f
#define iprb_mode       ii_iprb0_fld_s.i_m
#define iprb_bnakctr    ii_iprb0_fld_s.i_nb
#define iprb_anakctr    ii_iprb0_fld_s.i_na
#define iprb_xtalkctr   ii_iprb0_fld_s.i_c
#define iwcr_dir_con    wcr_fields_s.wcr_dir_con
#define sn_hwp_this_part	f.fields.this_part
#define sn_hwp_is_shared	f.fields.is_shared
#define sn_hwp_flags		f.b.flags
#define pcibus_to_node(bus) PCI_CONTROLLER(bus)->node
#define uc_link		uc_mcontext.sc_gr[0]=09
#define uc_sigmask	uc_mcontext.sc_sigmask
#define uc_stack	uc_mcontext.sc_stack
#define MOV_FROM_IVR(reg, clob)	__MOV_FROM_IVR reg, clob
#define MOV_FROM_PSR(pred, reg, clob)	__MOV_FROM_PSR pred, reg, clob
#define ITC_I(pred, reg, clob)	__ITC_I pred, reg, clob
#define ITC_D(pred, reg, clob)	__ITC_D pred, reg, clob
#define THASH(pred, reg0, reg1, clob) __THASH pred, reg0, reg1, clob
#define XEN_HYPER_RFI			break HYPERPRIVOP_RFI
#define XEN_HYPER_RSM_PSR_DT		break HYPERPRIVOP_RSM_DT
#define XEN_HYPER_SSM_PSR_DT		break HYPERPRIVOP_SSM_DT
#define XEN_HYPER_COVER			break HYPERPRIVOP_COVER
#define XEN_HYPER_ITC_D			break HYPERPRIVOP_ITC_D
#define XEN_HYPER_ITC_I			break HYPERPRIVOP_ITC_I
#define XEN_HYPER_SSM_I			break HYPERPRIVOP_SSM_I
#define XEN_HYPER_GET_IVR		break HYPERPRIVOP_GET_IVR
#define XEN_HYPER_THASH			break HYPERPRIVOP_THASH
#define XEN_HYPER_ITR_D			break HYPERPRIVOP_ITR_D
#define XEN_HYPER_SET_KR		break HYPERPRIVOP_SET_KR
#define XEN_HYPER_GET_PSR		break HYPERPRIVOP_GET_PSR
#define XEN_HYPER_SET_RR0_TO_RR4	break HYPERPRIVOP_SET_RR0_TO_RR4
#define init_thread_info	init_task_mem.s.thread_info
#define IA64_LOG_NEXT_INDEX(it)    ia64_state_log[it].isl_index
#define IA64_LOG_CURR_INDEX(it)    1 - ia64_state_log[it].isl_index
#define IA64_LOG_COUNT(it)         ia64_state_log[it].isl_count
#define N(reloc)	[R_IA64_##reloc] =3D #reloc
#define NR_PALINFO_ENTRIES	(int) ARRAY_SIZE(palinfo_entries)
#define req_cpu	pal_func_cpu.req_cpu
#define func_id pal_func_cpu.func_id
#define PMC_DFL_VAL(i)     pmu_conf->pmc_desc[i].default_value
#define PMC_RSVD_MASK(i)   pmu_conf->pmc_desc[i].reserved_mask
#define PMD_PMD_DEP(i)	   pmu_conf->pmd_desc[i].dep_pmd[0]
#define PMC_PMD_DEP(i)	   pmu_conf->pmc_desc[i].dep_pmd[0]
#define PFM_CTX_TASK(h)		(h)->ctx_task
#define CTX_USED_PMD(ctx, mask) (ctx)->ctx_used_pmds[0] |=3D (mask)
#define CTX_USED_MONITOR(ctx, mask) (ctx)->ctx_used_monitors[0] |=3D (mask)
#define CTX_USED_IBR(ctx,n) 	(ctx)->ctx_used_ibrs[(n)>>6] |=3D 1UL<< ((n) %=
 64)
#define CTX_USED_DBR(ctx,n) 	(ctx)->ctx_used_dbrs[(n)>>6] |=3D 1UL<< ((n) %=
 64)
#define PFM_CPUINFO_CLEAR(v)	pfm_get_cpu_var(pfm_syst_info) &=3D ~(v)
#define PFM_CPUINFO_SET(v)	pfm_get_cpu_var(pfm_syst_info) |=3D (v)
#define INC_ACTIVATION()	pfm_get_cpu_var(pmu_activation_number)++
#define SET_ACTIVATION(c)	(c)->ctx_last_activation =3D GET_ACTIVATION()
#define SET_LAST_CPU(ctx, v)	(ctx)->ctx_last_cpu =3D (v)
#define GET_LAST_CPU(ctx)	(ctx)->ctx_last_cpu
#define ctx_fl_block		ctx_flags.block
#define ctx_fl_system		ctx_flags.system
#define ctx_fl_using_dbreg	ctx_flags.using_dbreg
#define ctx_fl_is_sampling	ctx_flags.is_sampling
#define ctx_fl_excl_idle	ctx_flags.excl_idle
#define ctx_fl_going_zombie	ctx_flags.going_zombie
#define ctx_fl_trap_reason	ctx_flags.trap_reason
#define ctx_fl_no_msg		ctx_flags.no_msg
#define ctx_fl_can_restart	ctx_flags.can_restart
#define PFM_GET_WORK_PENDING(t)		(t)->thread.pfm_needs_checking
#define PFM_CMD_NAME(cmd)	pfm_cmd_tab[(cmd)].cmd_name
#define SAVE_REGS(_x) 	regs->_x =3D vcpu->arch._x
#define PIB_LOW_HALF(ofst)     !(ofst & (1 << 20))
#define VP_FW_ACC   	1UL<<63
#define xb_wid_id 		xb_widget.w_id
#define xb_wid_stat 		xb_widget.w_status
#define xb_wid_err_upper 	xb_widget.w_err_upper_addr
#define xb_wid_err_lower 	xb_widget.w_err_lower_addr
#define xb_wid_control		xb_widget.w_control
#define xb_wid_req_timeout 	xb_widget.w_req_timeout
#define xb_wid_int_upper 	xb_widget.w_intdest_upper_addr
#define xb_wid_int_lower 	xb_widget.w_intdest_lower_addr
#define xb_wid_err_cmdword 	xb_widget.w_err_cmd_word
#define xb_wid_llp 		xb_widget.w_llp_cfg
#define xb_wid_stat_clr 	xb_widget.w_tflush
#define MACHVEC_PLATFORM_HEADER	<asm/machvec_sn2.h>
#define MACHVEC_PLATFORM_HEADER	<asm/machvec_uv.h>
#define MACHVEC_PLATFORM_HEADER         <asm/machvec_xen.h>
#define memzero(s, n)     memset ((s), 0, (n))
#define ENTRY(name) ENTRY_M name
#define LDIMM(reg,x) LDIMM reg x
#define ENABLE_INTERRUPTS(reg) ENABLE_INTERRUPTS reg
#define DISABLE_INTERRUPTS(reg) DISABLE_INTERRUPTS reg
#define ENABLE_INTERRUPTS(reg) ENABLE_INTERRUPTS reg
#define DISABLE_INTERRUPTS(reg) DISABLE_INTERRUPTS reg
#define GET_CURRENT(reg)  get_current reg
#define ELF_PLAT_INIT(_r, load_addr)	(_r)->r0 =3D 0
#define __ALIGN		.balign 4
#define M32R_ICU_ISTS_ADDR  M32R_ICU_ISTS_PORTL+NONCACHE_OFFSET
#define M32R_ICU_IPICR_ADDR  M32R_ICU_IPICR0_PORTL+NONCACHE_OFFSET
#define M32R_ICU_IMASK_ADDR  M32R_ICU_IMASK_PORTL+NONCACHE_OFFSET
#define M32R_FPGA_CPU_NAME_ADDR  M32R_FPGA_CPU_NAME0_PORTL+NONCACHE_OFFSET
#define M32R_FPGA_MODEL_ID_ADDR  M32R_FPGA_MODEL_ID0_PORTL+NONCACHE_OFFSET
#define M32R_FPGA_VERSION_ADDR   M32R_FPGA_VERSION0_PORTL+NONCACHE_OFFSET
#define mm_context(mm)		mm->context
#define mm_context(mm)		mm->context[smp_processor_id()]
#define RTC_MAGIC 'p'
#define sa_sigaction	_u._sa_sigaction
#define nop()	__asm__ __volatile__ ("nop" : : )
#define VGA_MAP_MEM(x,s) (unsigned long)phys_to_virt(x)
#define COPY(x)		err |=3D __get_user(regs->x, &sc->sc_##x)
#define COPY(x)	err |=3D __put_user(regs->x, &sc->sc_##x)
#define SAVEKMSG_MAXMEM		128*1024
#define COPY(v) val->v=3D(mste_rtc.v & 0xf)
#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
#define bi_amiga	bi_un.bi_ami
#define bi_atari	bi_un.bi_ata
#define bi_mac		bi_un.bi_mac
#define config_reg_ptr	(volatile unsigned char *)BVME_CONFIG_REG
#define bvme_acr_a32vba		*(volatile unsigned char *)BVME_ACR_A32VBA
#define bvme_acr_a32msk		*(volatile unsigned char *)BVME_ACR_A32MSK
#define bvme_acr_a24vba		*(volatile unsigned char *)BVME_ACR_A24VBA
#define bvme_acr_a24msk		*(volatile unsigned char *)BVME_ACR_A24MSK
#define bvme_acr_a16vba		*(volatile unsigned char *)BVME_ACR_A16VBA
#define bvme_acr_a32lba		*(volatile unsigned char *)BVME_ACR_A32LBA
#define bvme_acr_a24lba		*(volatile unsigned char *)BVME_ACR_A24LBA
#define bvme_acr_addrctl	*(volatile unsigned char *)BVME_ACR_ADDRCTL
#define BREAK *(volatile unsigned char *)0xdeadbee0 =3D 0
#define ELF_PLAT_INIT(_r, load_addr)	_r->a1 =3D 0
#define GET_CURRENT(tmp) get_current tmp
#define STR1(X) #X
#define intersil_clear() (void)intersil_clock->int_reg
#define __ALIGN .align 4
#define MCF5282_GPIO_PASPAR     (volatile u16 *) (MCF_IPSBAR + 0x00100056)
#define MCF5282_INTC0_IMRL      (volatile u32 *) (MCF_IPSBAR + 0x0C0C)
#define MCF5282_INTC0_ICR17     (volatile u8 *) (MCF_IPSBAR + 0x0C51)
#define MCF5282_I2C_I2ADR       (volatile u8 *) (MCF_IPSBAR + 0x0300) // Ad=
dress=20
#define MCF5282_I2C_I2FDR       (volatile u8 *) (MCF_IPSBAR + 0x0304) // Fr=
eq Divider
#define MCF5282_I2C_I2CR        (volatile u8 *) (MCF_IPSBAR + 0x0308) // Co=
ntrol
#define MCF5282_I2C_I2SR        (volatile u8 *) (MCF_IPSBAR + 0x030C) // St=
atus
#define MCF5282_I2C_I2DR        (volatile u8 *) (MCF_IPSBAR + 0x0310) // Da=
ta I/O
#define MCF532x_I2C_I2ADR       (volatile u8 *) (0xFC058000) // Address=20
#define MCF532x_I2C_I2FDR       (volatile u8 *) (0xFC058004) // Freq Divider
#define MCF532x_I2C_I2CR        (volatile u8 *) (0xFC058008) // Control
#define MCF532x_I2C_I2SR        (volatile u8 *) (0xFC05800C) // Status
#define MCF532x_I2C_I2DR        (volatile u8 *) (0xFC058010) // Data I/O
#define MCF532x_PAR_FECI2C	(volatile u8 *) (0xFC0A4053)
#define CLEAR_BIT(x, bit)  x =3Dbit=20
#define NUM_IOP_MSGS	NUM_IOP_CHAN*8
#define FPDATA		%a2
#define sa_sigaction	_u._sa_sigaction

--xB0nW4MQa6jZONgY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRPLDAAoJEOnZkXI/YHqRO7oP/Re1b4HNchU87kHZ/M4Gzmpi
eIoeZUPB/S9AmcIBYvLxUruiYY+Cw1KLYCq7lNdaXonAzf4y7fsvzHKIMg0E5vsl
P0F4d0qwQhpgzCAmW5rD2ZzIStUkIORXXjgYpbCu5lFveqYExe5FsSGw2+1xEESx
iy3Kvh5HRvEeWv+L7y68FPqpq8y6vkLzhRAFUpzS42EKw3Ez/LuJE8tF+zCvRVuV
T6xECWT3SJKlsgfbv42ubobyc+bpA8u+AFu/NM7KUPX/NefZklQlLBNKKdH72rXD
7kC7Ya3cZU0T0vchuhYrHuQp84N+QwLyA3x/JeCTR8cPa89hK87sZersGxuchCGX
GE5iwtuYVM04yNkxSLSMT/uY4+GgtIz6XnAlOXXoWCZoxvNTcdnNXvcpHAwOhjwy
pznXmEAEZwXDrbiIE9r4UXO8tqbmvCpfjkB94psWLEO1I/TKyrrwQ2qAKQcqisgU
mJBD31oIdGMsrsoUNsk2bpC3E4NwREKrOH5WvdT1erOI33ESCcIMYyPIQJfyLIGZ
zcwKq4atAeOflFxoVWhsaY6EjMUDT3hC1mEJ/QjmU7fBsKImKrr9kyIcCzJJZYEl
rJ+i4f6M0xG5d1oPA21cUOc+qMjwZV3LS5z4IPe4Meoiri59bDqLlVmKaSconMr6
RxnlA973FuruienpoKdT
=YSt5
-----END PGP SIGNATURE-----

--xB0nW4MQa6jZONgY--
