Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2F1B1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:27:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab2F1B06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:26:58 -0400
Date: Wed, 27 Jun 2012 21:44:34 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Avi Kivity <avi@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] kvm: Use pr_<level>
Message-ID: <20120628004434.GA18388@amt.cnet>
References: <1339644021.28729.17.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339644021.28729.17.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The advantage is the added prefix?

$ grep limit Documentation/CodingStyle 
The limit on the length of lines is 80 columns and this is a strongly
preferred limit.

On Wed, Jun 13, 2012 at 08:20:21PM -0700, Joe Perches wrote:
> Use a more current logging style.
> 
> Convert printks to pr_<level>.
> Add pr_fmt.
> 
> All logging messages are now prefixed with
> "kvm: ", "kvm_intel: " or "kvm_amd: "
> 
> Coalesce formats, align arguments.
> Add a few missing newlines.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/kvm/cpuid.c       |    4 +-
>  arch/x86/kvm/lapic.c       |   16 ++++----
>  arch/x86/kvm/mmu.c         |   95 +++++++++++++++++++++++++------------------
>  arch/x86/kvm/mmu_audit.c   |   35 ++++++++--------
>  arch/x86/kvm/paging_tmpl.h |   13 +++---
>  arch/x86/kvm/svm.c         |   27 ++++++------
>  arch/x86/kvm/vmx.c         |   75 +++++++++++++++-------------------
>  arch/x86/kvm/x86.c         |   31 +++++++-------
>  virt/kvm/assigned-dev.c    |   31 +++++++-------
>  virt/kvm/ioapic.c          |   25 +++++++----
>  virt/kvm/ioapic.h          |    4 +-
>  virt/kvm/iommu.c           |   36 ++++++++--------
>  virt/kvm/irq_comm.c        |    8 ++-
>  virt/kvm/kvm_main.c        |   17 ++++----
>  14 files changed, 215 insertions(+), 202 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7df1c6d..1323ffd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -12,6 +12,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kvm_host.h>
>  #include <linux/module.h>
>  #include <linux/vmalloc.h>
> @@ -72,7 +74,7 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
>  	}
>  	if (entry && (entry->edx & (1 << 20)) && !is_efer_nx()) {
>  		entry->edx &= ~(1 << 20);
> -		printk(KERN_INFO "kvm: guest NX capability removed\n");
> +		pr_info("guest NX capability removed\n");
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 93c1574..0b3264f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -18,6 +18,8 @@
>   * the COPYING file in the top-level directory.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kvm_host.h>
>  #include <linux/kvm.h>
>  #include <linux/mm.h>
> @@ -53,7 +55,7 @@
>  
>  #define APIC_BUS_CYCLE_NS 1
>  
> -/* #define apic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
> +/* #define apic_debug(fmt,arg...) pr_warn(fmt,##arg) */
>  #define apic_debug(fmt, arg...)
>  
>  #define APIC_LVT_NUM			6
> @@ -470,8 +472,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>  		break;
>  
>  	default:
> -		printk(KERN_ERR "TODO: unsupported delivery mode %x\n",
> -		       delivery_mode);
> +		pr_err("TODO: unsupported delivery mode %x\n", delivery_mode);
>  		break;
>  	}
>  	return result;
> @@ -648,8 +649,8 @@ static int apic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>  		memcpy(data, (char *)&result + alignment, len);
>  		break;
>  	default:
> -		printk(KERN_ERR "Local APIC read with len = %x, "
> -		       "should be 1,2, or 4 instead\n", len);
> +		pr_err("Local APIC read with len = %x, should be 1,2, or 4 instead\n",
> +		       len);
>  		break;
>  	}
>  	return 0;
> @@ -712,8 +713,7 @@ static void start_apic_timer(struct kvm_lapic *apic)
>  
>  			if (apic->lapic_timer.period < min_period) {
>  				pr_info_ratelimited(
> -				    "kvm: vcpu %i: requested %lld ns "
> -				    "lapic timer period limited to %lld ns\n",
> +				    "vcpu %i: requested %lld ns lapic timer period limited to %lld ns\n",
>  				    apic->vcpu->vcpu_id,
>  				    apic->lapic_timer.period, min_period);
>  				apic->lapic_timer.period = min_period;
> @@ -1175,7 +1175,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
>  
>  	apic->regs = (void *)get_zeroed_page(GFP_KERNEL);
>  	if (!apic->regs) {
> -		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
> +		pr_err("malloc apic regs error for vcpu %x\n",
>  		       vcpu->vcpu_id);
>  		goto nomem_free_apic;
>  	}
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 24dd43d..ab0dbfd 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -18,6 +18,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "irq.h"
>  #include "mmu.h"
>  #include "x86.h"
> @@ -63,13 +65,31 @@ enum {
>  
>  #ifdef MMU_DEBUG
>  
> -#define pgprintk(x...) do { if (dbg) printk(x); } while (0)
> -#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
> +#define DEBUG
> +
> +#define pg_dbg(fmt, ...)					\
> +do {								\
> +	if (dbg)						\
> +		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
> +} while (0)
> +#define rmap_dbg(fmt, ...)					\
> +do {								\
> +	if (dbg)						\
> +		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
> +} while (0)
>  
>  #else
>  
> -#define pgprintk(x...) do { } while (0)
> -#define rmap_printk(x...) do { } while (0)
> +#define pg_dbg(fmt, ...)			\
> +do {						\
> +	if (0)					\
> +		pr_debug(fmt, ##__VA_ARGS__);	\
> +} while (0)
> +#define rmap_dbg(fmt, ...)			\
> +do {						\
> +	if (0)					\
> +		pr_debug(fmt, ##__VA_ARGS__);	\
> +} while (0)
>  
>  #endif
>  
> @@ -83,8 +103,8 @@ module_param(dbg, bool, 0644);
>  #else
>  #define ASSERT(x)							\
>  	if (!(x)) {							\
> -		printk(KERN_WARNING "assertion failed %s:%d: %s\n",	\
> -		       __FILE__, __LINE__, #x);				\
> +		pr_warn("assertion failed %s:%d: %s\n",			\
> +			__FILE__, __LINE__, #x);			\
>  	}
>  #endif
>  
> @@ -825,17 +845,17 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>  	int i, count = 0;
>  
>  	if (!*pte_list) {
> -		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
> +		rmap_dbg("%p %llx 0->1\n", spte, *spte);
>  		*pte_list = (unsigned long)spte;
>  	} else if (!(*pte_list & 1)) {
> -		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
> +		rmap_dbg("%p %llx 1->many\n", spte, *spte);
>  		desc = mmu_alloc_pte_list_desc(vcpu);
>  		desc->sptes[0] = (u64 *)*pte_list;
>  		desc->sptes[1] = spte;
>  		*pte_list = (unsigned long)desc | 1;
>  		++count;
>  	} else {
> -		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
> +		rmap_dbg("%p %llx many->many\n", spte, *spte);
>  		desc = (struct pte_list_desc *)(*pte_list & ~1ul);
>  		while (desc->sptes[PTE_LIST_EXT-1] && desc->more) {
>  			desc = desc->more;
> @@ -881,17 +901,17 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
>  	int i;
>  
>  	if (!*pte_list) {
> -		printk(KERN_ERR "pte_list_remove: %p 0->BUG\n", spte);
> +		pr_err("%s: %p 0->BUG\n", __func__, spte);
>  		BUG();
>  	} else if (!(*pte_list & 1)) {
> -		rmap_printk("pte_list_remove:  %p 1->0\n", spte);
> +		rmap_dbg("%p 1->0\n", spte);
>  		if ((u64 *)*pte_list != spte) {
> -			printk(KERN_ERR "pte_list_remove:  %p 1->BUG\n", spte);
> +			pr_err("%s:  %p 1->BUG\n", __func__, spte);
>  			BUG();
>  		}
>  		*pte_list = 0;
>  	} else {
> -		rmap_printk("pte_list_remove:  %p many->many\n", spte);
> +		rmap_dbg("%p many->many\n", spte);
>  		desc = (struct pte_list_desc *)(*pte_list & ~1ul);
>  		prev_desc = NULL;
>  		while (desc) {
> @@ -1059,7 +1079,7 @@ static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level
>  
>  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
>  		BUG_ON(!(*sptep & PT_PRESENT_MASK));
> -		rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
> +		rmap_dbg("spte %p %llx\n", sptep, *sptep);
>  
>  		if (!is_writable_pte(*sptep)) {
>  			sptep = rmap_get_next(&iter);
> @@ -1134,7 +1154,7 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
>  
>  	while ((sptep = rmap_get_first(*rmapp, &iter))) {
>  		BUG_ON(!(*sptep & PT_PRESENT_MASK));
> -		rmap_printk("kvm_rmap_unmap_hva: spte %p %llx\n", sptep, *sptep);
> +		rmap_dbg("spte %p %llx\n", sptep, *sptep);
>  
>  		drop_spte(kvm, sptep);
>  		need_tlb_flush = 1;
> @@ -1158,7 +1178,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
>  
>  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
>  		BUG_ON(!is_shadow_present_pte(*sptep));
> -		rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n", sptep, *sptep);
> +		rmap_dbg("spte %p %llx\n", sptep, *sptep);
>  
>  		need_flush = 1;
>  
> @@ -1327,8 +1347,7 @@ static int is_empty_shadow_page(u64 *spt)
>  
>  	for (pos = spt, end = pos + PAGE_SIZE / sizeof(u64); pos != end; pos++)
>  		if (is_shadow_present_pte(*pos)) {
> -			printk(KERN_ERR "%s: %p %llx\n", __func__,
> -			       pos, *pos);
> +			pr_err("%s: %p %llx\n", __func__, pos, *pos);
>  			return 0;
>  		}
>  	return 1;
> @@ -2065,12 +2084,11 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
>  	LIST_HEAD(invalid_list);
>  	int r;
>  
> -	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
> +	pg_dbg("looking for gfn %llx\n", gfn);
>  	r = 0;
>  	spin_lock(&kvm->mmu_lock);
>  	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node) {
> -		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
> -			 sp->role.word);
> +		pg_dbg("gfn %llx role %x\n", gfn, sp->role.word);
>  		r = 1;
>  		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
>  	}
> @@ -2310,8 +2328,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  			goto set_pte;
>  
>  		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
> -			pgprintk("%s: found shadow page for %llx, marking ro\n",
> -				 __func__, gfn);
> +			pg_dbg("found shadow page for %llx, marking ro\n",
> +			       gfn);
>  			ret = 1;
>  			pte_access &= ~ACC_WRITE_MASK;
>  			if (is_writable_pte(spte))
> @@ -2346,10 +2364,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	int was_rmapped = 0;
>  	int rmap_count;
>  
> -	pgprintk("%s: spte %llx access %x write_fault %d"
> -		 " user_fault %d gfn %llx\n",
> -		 __func__, *sptep, pt_access,
> -		 write_fault, user_fault, gfn);
> +	pg_dbg("spte %llx access %x write_fault %d user_fault %d gfn %llx\n",
> +	       *sptep, pt_access, write_fault, user_fault, gfn);
>  
>  	if (is_rmap_spte(*sptep)) {
>  		/*
> @@ -2365,8 +2381,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  			drop_parent_pte(child, sptep);
>  			kvm_flush_remote_tlbs(vcpu->kvm);
>  		} else if (pfn != spte_to_pfn(*sptep)) {
> -			pgprintk("hfn old %llx new %llx\n",
> -				 spte_to_pfn(*sptep), pfn);
> +			pg_dbg("hfn old %llx new %llx\n",
> +			       spte_to_pfn(*sptep), pfn);
>  			drop_spte(vcpu->kvm, sptep);
>  			kvm_flush_remote_tlbs(vcpu->kvm);
>  		} else
> @@ -2384,11 +2400,11 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	if (unlikely(is_mmio_spte(*sptep) && emulate))
>  		*emulate = 1;
>  
> -	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
> -	pgprintk("instantiating %s PTE (%s) at %llx (%llx) addr %p\n",
> -		 is_large_pte(*sptep)? "2MB" : "4kB",
> -		 *sptep & PT_PRESENT_MASK ?"RW":"R", gfn,
> -		 *sptep, sptep);
> +	pg_dbg("setting spte %llx\n", *sptep);
> +	pg_dbg("instantiating %s PTE (%s) at %llx (%llx) addr %p\n",
> +	       is_large_pte(*sptep) ? "2MB" : "4kB",
> +	       *sptep & PT_PRESENT_MASK ? "RW" : "R", gfn,
> +	       *sptep, sptep);
>  	if (!was_rmapped && is_large_pte(*sptep))
>  		++vcpu->kvm->stat.lpages;
>  
> @@ -2523,7 +2539,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  					      iterator.level - 1,
>  					      1, ACC_ALL, iterator.sptep);
>  			if (!sp) {
> -				pgprintk("nonpaging_map: ENOMEM\n");
> +				pg_dbg("nonpaging_map: ENOMEM\n");
>  				kvm_release_pfn_clean(pfn);
>  				return -ENOMEM;
>  			}
> @@ -3028,7 +3044,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
>  	gfn_t gfn;
>  	int r;
>  
> -	pgprintk("%s: gva %lx error %x\n", __func__, gva, error_code);
> +	pg_dbg("gva %lx error %x\n", gva, error_code);
>  
>  	if (unlikely(error_code & PFERR_RSVD_MASK))
>  		return handle_mmio_page_fault(vcpu, gva, error_code, true);
> @@ -3181,7 +3197,7 @@ void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
>  
>  static void paging_new_cr3(struct kvm_vcpu *vcpu)
>  {
> -	pgprintk("%s: cr3 %lx\n", __func__, kvm_read_cr3(vcpu));
> +	pg_dbg("cr3 %lx\n", kvm_read_cr3(vcpu));
>  	mmu_free_roots(vcpu);
>  }
>  
> @@ -3619,8 +3635,7 @@ static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
>  {
>  	unsigned offset, pte_size, misaligned;
>  
> -	pgprintk("misaligned: gpa %llx bytes %d role %x\n",
> -		 gpa, bytes, sp->role.word);
> +	pg_dbg("gpa %llx bytes %d role %x\n", gpa, bytes, sp->role.word);
>  
>  	offset = offset_in_page(gpa);
>  	pte_size = sp->role.cr4_pae ? 8 : 4;
> @@ -3690,7 +3705,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  
>  	zap_page = remote_flush = local_flush = false;
>  
> -	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
> +	pg_dbg("gpa %llx bytes %d\n", gpa, bytes);
>  
>  	gentry = mmu_pte_write_fetch_gpte(vcpu, &gpa, new, &bytes);
>  
> diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
> index 7d7d0b9..7625b90 100644
> --- a/arch/x86/kvm/mmu_audit.c
> +++ b/arch/x86/kvm/mmu_audit.c
> @@ -17,6 +17,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/ratelimit.h>
>  
>  char const *audit_point_name[] = {
> @@ -28,9 +30,9 @@ char const *audit_point_name[] = {
>  	"post sync"
>  };
>  
> -#define audit_printk(kvm, fmt, args...)		\
> -	printk(KERN_ERR "audit: (%s) error: "	\
> -		fmt, audit_point_name[kvm->arch.audit_point], ##args)
> +#define audit_err(kvm, fmt, ...)					\
> +	pr_err("(%s) error: " fmt,					\
> +	       audit_point_name[(kvm)->arch.audit_point], ##__VA_ARGS__)
>  
>  typedef void (*inspect_spte_fn) (struct kvm_vcpu *vcpu, u64 *sptep, int level);
>  
> @@ -104,8 +106,8 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
>  
>  	if (sp->unsync) {
>  		if (level != PT_PAGE_TABLE_LEVEL) {
> -			audit_printk(vcpu->kvm, "unsync sp: %p "
> -				     "level = %d\n", sp, level);
> +			audit_err(vcpu->kvm, "unsync sp: %p level = %d\n",
> +				  sp, level);
>  			return;
>  		}
>  	}
> @@ -123,9 +125,8 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
>  
>  	hpa =  pfn << PAGE_SHIFT;
>  	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
> -		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
> -			     "ent %llxn", vcpu->arch.mmu.root_level, pfn,
> -			     hpa, *sptep);
> +		audit_err(vcpu->kvm, "levels %d pfn %llx hpa %llx ent %llx\n",
> +			  vcpu->arch.mmu.root_level, pfn, hpa, *sptep);
>  }
>  
>  static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
> @@ -141,9 +142,9 @@ static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
>  	if (!gfn_to_memslot(kvm, gfn)) {
>  		if (!__ratelimit(&ratelimit_state))
>  			return;
> -		audit_printk(kvm, "no memslot for gfn %llx\n", gfn);
> -		audit_printk(kvm, "index %ld of sp (gfn=%llx)\n",
> -		       (long int)(sptep - rev_sp->spt), rev_sp->gfn);
> +		audit_err(kvm, "no memslot for gfn %llx\n", gfn);
> +		audit_err(kvm, "index %ld of sp (gfn=%llx)\n",
> +			  (long int)(sptep - rev_sp->spt), rev_sp->gfn);
>  		dump_stack();
>  		return;
>  	}
> @@ -152,8 +153,7 @@ static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
>  	if (!*rmapp) {
>  		if (!__ratelimit(&ratelimit_state))
>  			return;
> -		audit_printk(kvm, "no rmap for writable spte %llx\n",
> -			     *sptep);
> +		audit_err(kvm, "no rmap for writable spte %llx\n", *sptep);
>  		dump_stack();
>  	}
>  }
> @@ -169,8 +169,8 @@ static void audit_spte_after_sync(struct kvm_vcpu *vcpu, u64 *sptep, int level)
>  	struct kvm_mmu_page *sp = page_header(__pa(sptep));
>  
>  	if (vcpu->kvm->arch.audit_point == AUDIT_POST_SYNC && sp->unsync)
> -		audit_printk(vcpu->kvm, "meet unsync sp(%p) after sync "
> -			     "root.\n", sp);
> +		audit_err(vcpu->kvm, "meet unsync sp(%p) after sync root\n",
> +			  sp);
>  }
>  
>  static void check_mappings_rmap(struct kvm *kvm, struct kvm_mmu_page *sp)
> @@ -204,9 +204,8 @@ static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
>  	     sptep = rmap_get_next(&iter)) {
>  		if (is_writable_pte(*sptep))
> -			audit_printk(kvm, "shadow page has writable "
> -				     "mappings: gfn %llx role %x\n",
> -				     sp->gfn, sp->role.word);
> +			audit_err(kvm, "shadow page has writable mappings: gfn %llx role %x\n",
> +				  sp->gfn, sp->role.word);
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 34f9709..71d0532 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -302,8 +302,8 @@ retry_walk:
>  
>  	walker->pt_access = pt_access;
>  	walker->pte_access = pte_access;
> -	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
> -		 __func__, (u64)pte, pte_access, pt_access);
> +	pg_dbg("pte %llx pte_access %x pt_access %x\n",
> +	       (u64)pte, pte_access, pt_access);
>  	return 1;
>  
>  error:
> @@ -368,7 +368,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
>  		return;
>  
> -	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
> +	pg_dbg("gpte %llx spte %p\n", (u64)gpte, spte);
>  	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte, true);
>  	pfn = gfn_to_pfn_atomic(vcpu->kvm, gpte_to_gfn(gpte));
>  	if (mmu_invalid_pfn(pfn)) {
> @@ -582,7 +582,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  	unsigned long mmu_seq;
>  	bool map_writable;
>  
> -	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
> +	pg_dbg("addr %lx err %x\n", addr, error_code);
>  
>  	if (unlikely(error_code & PFERR_RSVD_MASK))
>  		return handle_mmio_page_fault(vcpu, addr, error_code,
> @@ -601,7 +601,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  	 * The page is not mapped by the guest.  Let the guest handle it.
>  	 */
>  	if (!r) {
> -		pgprintk("%s: guest page fault\n", __func__);
> +		pg_dbg("guest page fault\n");
>  		if (!prefault)
>  			inject_page_fault(vcpu, &walker.fault);
>  
> @@ -639,8 +639,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
>  			     level, &emulate, pfn, map_writable, prefault);
>  	(void)sptep;
> -	pgprintk("%s: shadow pte %p %llx emulate %d\n", __func__,
> -		 sptep, *sptep, emulate);
> +	pg_dbg("shadow pte %p %llx emulate %d\n", sptep, *sptep, emulate);
>  
>  	++vcpu->stat.pf_fixed;
>  	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 7a41878..b4a722e 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -14,6 +14,9 @@
>   * the COPYING file in the top-level directory.
>   *
>   */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kvm_host.h>
>  
>  #include "irq.h"
> @@ -500,11 +503,11 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  	if (!svm->next_rip) {
>  		if (emulate_instruction(vcpu, EMULTYPE_SKIP) !=
>  				EMULATE_DONE)
> -			printk(KERN_DEBUG "%s: NOP\n", __func__);
> +			pr_debug("%s: NOP\n", __func__);
>  		return;
>  	}
>  	if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
> -		printk(KERN_ERR "%s: ip 0x%lx next 0x%llx\n",
> +		pr_err("%s: ip 0x%lx next 0x%llx\n",
>  		       __func__, kvm_rip_read(vcpu), svm->next_rip);
>  
>  	kvm_rip_write(vcpu, svm->next_rip);
> @@ -598,7 +601,7 @@ static int has_svm(void)
>  	const char *msg;
>  
>  	if (!cpu_has_svm(&msg)) {
> -		printk(KERN_INFO "has_svm: %s\n", msg);
> +		pr_info("%s: %s\n", __func__, msg);
>  		return 0;
>  	}
>  
> @@ -630,15 +633,13 @@ static int svm_hardware_enable(void *garbage)
>  		return -EBUSY;
>  
>  	if (!has_svm()) {
> -		printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n",
> -		       me);
> +		pr_err("%s: err EOPNOTSUPP on %d\n", __func__, me);
>  		return -EINVAL;
>  	}
>  	sd = per_cpu(svm_data, me);
>  
>  	if (!sd) {
> -		printk(KERN_ERR "svm_hardware_enable: svm_data is NULL on %d\n",
> -		       me);
> +		pr_err("%s: svm_data is NULL on %d\n", __func__, me);
>  		return -EINVAL;
>  	}
>  
> @@ -890,7 +891,7 @@ static __init int svm_hardware_setup(void)
>  	}
>  
>  	if (nested) {
> -		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
> +		pr_info("Nested Virtualization enabled\n");
>  		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>  	}
>  
> @@ -904,12 +905,12 @@ static __init int svm_hardware_setup(void)
>  		npt_enabled = false;
>  
>  	if (npt_enabled && !npt) {
> -		printk(KERN_INFO "kvm: Nested Paging disabled\n");
> +		pr_info("Nested Paging disabled\n");
>  		npt_enabled = false;
>  	}
>  
>  	if (npt_enabled) {
> -		printk(KERN_INFO "kvm: Nested Paging enabled\n");
> +		pr_info("Nested Paging enabled\n");
>  		kvm_enable_tdp();
>  	} else
>  		kvm_disable_tdp();
> @@ -3496,10 +3497,8 @@ static int handle_exit(struct kvm_vcpu *vcpu)
>  	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
>  	    exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
>  	    exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
> -		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
> -		       "exit_code 0x%x\n",
> -		       __func__, svm->vmcb->control.exit_int_info,
> -		       exit_code);
> +		pr_err("%s: unexpected exit_ini_info 0x%x exit_code 0x%x\n",
> +		       __func__, svm->vmcb->control.exit_int_info, exit_code);
>  
>  	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
>  	    || !svm_exit_handlers[exit_code]) {
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index eeeb4a2..3257358 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -16,6 +16,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "irq.h"
>  #include "mmu.h"
>  #include "cpuid.h"
> @@ -961,8 +963,7 @@ static void vmcs_clear(struct vmcs *vmcs)
>  		      : "=qm"(error) : "a"(&phys_addr), "m"(phys_addr)
>  		      : "cc", "memory");
>  	if (error)
> -		printk(KERN_ERR "kvm: vmclear fail: %p/%llx\n",
> -		       vmcs, phys_addr);
> +		pr_err("vmclear fail: %p/%llx\n", vmcs, phys_addr);
>  }
>  
>  static inline void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
> @@ -981,8 +982,7 @@ static void vmcs_load(struct vmcs *vmcs)
>  			: "=qm"(error) : "a"(&phys_addr), "m"(phys_addr)
>  			: "cc", "memory");
>  	if (error)
> -		printk(KERN_ERR "kvm: vmptrld %p/%llx failed\n",
> -		       vmcs, phys_addr);
> +		pr_err("vmptrld %p/%llx failed\n", vmcs, phys_addr);
>  }
>  
>  static void __loaded_vmcs_clear(void *arg)
> @@ -1085,8 +1085,8 @@ static __always_inline u64 vmcs_read64(unsigned long field)
>  
>  static noinline void vmwrite_error(unsigned long field, unsigned long value)
>  {
> -	printk(KERN_ERR "vmwrite error: reg %lx value %lx (err %d)\n",
> -	       field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
> +	pr_err("%s: reg %lx value %lx (err %d)\n",
> +	       __func__, field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
>  	dump_stack();
>  }
>  
> @@ -1301,8 +1301,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  			break;
>  
>  	if (i == NR_AUTOLOAD_MSRS) {
> -		printk_once(KERN_WARNING"Not enough mst switch entries. "
> -				"Can't add msr %x\n", msr);
> +		pr_warn_once("Not enough mst switch entries. Can't add msr %x\n",
> +			     msr);
>  		return;
>  	} else if (i == m->nr) {
>  		++m->nr;
> @@ -2138,7 +2138,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
>  	struct shared_msr_entry *msr;
>  
>  	if (!pdata) {
> -		printk(KERN_ERR "BUG: get_msr called with NULL pdata\n");
> +		pr_err("BUG: get_msr called with NULL pdata\n");
>  		return -EINVAL;
>  	}
>  
> @@ -2312,8 +2312,7 @@ static __init int vmx_disabled_by_bios(void)
>  		if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX)
>  			&& (msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX)
>  			&& !tboot_enabled()) {
> -			printk(KERN_WARNING "kvm: disable TXT in the BIOS or "
> -				"activate TXT before enabling KVM\n");
> +			pr_warn("disable TXT in the BIOS or activate TXT before enabling KVM\n");
>  			return 1;
>  		}
>  		/* launched w/o TXT and VMX disabled */
> @@ -2566,8 +2565,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
>  		case 44:
>  		case 46:
>  			cpu_has_load_perf_global_ctrl = false;
> -			printk_once(KERN_WARNING"kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
> -					"does not work properly. Using workaround\n");
> +			pr_warn_once("VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround\n");
>  			break;
>  		default:
>  			break;
> @@ -2777,9 +2775,8 @@ static void fix_rmode_seg(int seg, struct kvm_save_segment *save)
>  	vmcs_write32(sf->limit, 0xffff);
>  	vmcs_write32(sf->ar_bytes, 0xf3);
>  	if (save->base & 0xf)
> -		printk_once(KERN_WARNING "kvm: segment base is not paragraph"
> -			    " aligned when entering protected mode (seg=%d)",
> -			    seg);
> +		pr_warn_once("segment base is not paragraph aligned when entering protected mode (seg=%d)\n",
> +			     seg);
>  }
>  
>  static void enter_rmode(struct kvm_vcpu *vcpu)
> @@ -2799,8 +2796,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
>  	 * vcpu. Call it here with phys address pointing 16M below 4G.
>  	 */
>  	if (!vcpu->kvm->arch.tss_addr) {
> -		printk_once(KERN_WARNING "kvm: KVM_SET_TSS_ADDR need to be "
> -			     "called before entering vcpu\n");
> +		pr_warn_once("KVM_SET_TSS_ADDR need to be called before entering vcpu\n");
>  		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
>  		vmx_set_tss_addr(vcpu->kvm, 0xfeffd000);
>  		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> @@ -3557,8 +3553,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  	if (!enable_ept)
>  		return 1;
>  	if (unlikely(!kvm->arch.ept_identity_pagetable)) {
> -		printk(KERN_ERR "EPT: identity-mapping pagetable "
> -			"haven't been allocated!\n");
> +		pr_err("EPT: identity-mapping pagetable haven't been allocated!\n");
>  		return 0;
>  	}
>  	if (likely(kvm->arch.ept_identity_pagetable_done))
> @@ -4834,18 +4829,18 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
>  
>  	if (exit_qualification & (1 << 6)) {
> -		printk(KERN_ERR "EPT: GPA exceeds GAW!\n");
> +		pr_err("EPT: GPA exceeds GAW!\n");
>  		return -EINVAL;
>  	}
>  
>  	gla_validity = (exit_qualification >> 7) & 0x3;
>  	if (gla_validity != 0x3 && gla_validity != 0x1 && gla_validity != 0) {
> -		printk(KERN_ERR "EPT: Handling EPT violation failed!\n");
> -		printk(KERN_ERR "EPT: GPA: 0x%lx, GVA: 0x%lx\n",
> -			(long unsigned int)vmcs_read64(GUEST_PHYSICAL_ADDRESS),
> -			vmcs_readl(GUEST_LINEAR_ADDRESS));
> -		printk(KERN_ERR "EPT: Exit qualification is 0x%lx\n",
> -			(long unsigned int)exit_qualification);
> +		pr_err("EPT: Handling EPT violation failed!\n");
> +		pr_err("EPT: GPA: 0x%lx, GVA: 0x%lx\n",
> +		       (long unsigned int)vmcs_read64(GUEST_PHYSICAL_ADDRESS),
> +		       vmcs_readl(GUEST_LINEAR_ADDRESS));
> +		pr_err("EPT: Exit qualification is 0x%lx\n",
> +		       (long unsigned int)exit_qualification);
>  		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
>  		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_EPT_VIOLATION;
>  		return 0;
> @@ -4882,7 +4877,7 @@ static u64 ept_rsvd_mask(u64 spte, int level)
>  static void ept_misconfig_inspect_spte(struct kvm_vcpu *vcpu, u64 spte,
>  				       int level)
>  {
> -	printk(KERN_ERR "%s: spte 0x%llx level %d\n", __func__, spte, level);
> +	pr_err("%s: spte 0x%llx level %d\n", __func__, spte, level);
>  
>  	/* 010b (write-only) */
>  	WARN_ON((spte & 0x7) == 0x2);
> @@ -4899,8 +4894,7 @@ static void ept_misconfig_inspect_spte(struct kvm_vcpu *vcpu, u64 spte,
>  		u64 rsvd_bits = spte & ept_rsvd_mask(spte, level);
>  
>  		if (rsvd_bits != 0) {
> -			printk(KERN_ERR "%s: rsvd_bits = 0x%llx\n",
> -					 __func__, rsvd_bits);
> +			pr_err("%s: rsvd_bits = 0x%llx\n", __func__, rsvd_bits);
>  			WARN_ON(1);
>  		}
>  
> @@ -4909,8 +4903,8 @@ static void ept_misconfig_inspect_spte(struct kvm_vcpu *vcpu, u64 spte,
>  
>  			if (ept_mem_type == 2 || ept_mem_type == 3 ||
>  			    ept_mem_type == 7) {
> -				printk(KERN_ERR "%s: ept_mem_type=0x%llx\n",
> -						__func__, ept_mem_type);
> +				pr_err("%s: ept_mem_type=0x%llx\n",
> +				       __func__, ept_mem_type);
>  				WARN_ON(1);
>  			}
>  		}
> @@ -4933,8 +4927,8 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>  		return 1;
>  
>  	/* It is the real ept misconfig */
> -	printk(KERN_ERR "EPT: Misconfiguration.\n");
> -	printk(KERN_ERR "EPT: GPA: 0x%llx\n", gpa);
> +	pr_err("EPT: Misconfiguration\n");
> +	pr_err("EPT: GPA: 0x%llx\n", gpa);
>  
>  	nr_sptes = kvm_mmu_get_spte_hierarchy(vcpu, gpa, sptes);
>  
> @@ -5976,9 +5970,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
>  			exit_reason != EXIT_REASON_EPT_VIOLATION &&
>  			exit_reason != EXIT_REASON_TASK_SWITCH))
> -		printk(KERN_WARNING "%s: unexpected, valid vectoring info "
> -		       "(0x%x) and exit reason is 0x%x\n",
> -		       __func__, vectoring_info, exit_reason);
> +		pr_warn("%s: unexpected, valid vectoring info (0x%x) and exit reason is 0x%x\n",
> +			__func__, vectoring_info, exit_reason);
>  
>  	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked &&
>  	    !(is_guest_mode(vcpu) && nested_cpu_has_virtual_nmis(
> @@ -5993,9 +5986,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  			 * disabled. So we pull the trigger after 1 s of
>  			 * futile waiting, but inform the user about this.
>  			 */
> -			printk(KERN_WARNING "%s: Breaking out of NMI-blocked "
> -			       "state on VCPU %d after 1 s timeout\n",
> -			       __func__, vcpu->vcpu_id);
> +			pr_warn("%s: Breaking out of NMI-blocked state on VCPU %d after 1 s timeout\n",
> +				__func__, vcpu->vcpu_id);
>  			vmx->soft_vnmi_blocked = 0;
>  		}
>  	}
> @@ -6459,8 +6451,7 @@ static void __init vmx_check_processor_compat(void *rtn)
>  	if (setup_vmcs_config(&vmcs_conf) < 0)
>  		*(int *)rtn = -EIO;
>  	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
> -		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
> -				smp_processor_id());
> +		pr_err("CPU %d feature inconsistency!\n", smp_processor_id());
>  		*(int *)rtn = -EIO;
>  	}
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a01a424..0a7eee7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -19,6 +19,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kvm_host.h>
>  #include "irq.h"
>  #include "mmu.h"
> @@ -194,7 +196,7 @@ static void shared_msr_update(unsigned slot, u32 msr)
>  	/* only read, and nobody should modify it at this time,
>  	 * so don't need lock */
>  	if (slot >= shared_msrs_global.nr) {
> -		printk(KERN_ERR "kvm: invalid MSR slot!");
> +		pr_err("invalid MSR slot!\n");
>  		return;
>  	}
>  	rdmsrl_safe(msr, &value);
> @@ -1006,7 +1008,8 @@ static void kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 this_tsc_khz)
>  	thresh_lo = adjust_tsc_khz(tsc_khz, -tsc_tolerance_ppm);
>  	thresh_hi = adjust_tsc_khz(tsc_khz, tsc_tolerance_ppm);
>  	if (this_tsc_khz < thresh_lo || this_tsc_khz > thresh_hi) {
> -		pr_debug("kvm: requested TSC rate %u falls outside tolerance [%u,%u]\n", this_tsc_khz, thresh_lo, thresh_hi);
> +		pr_debug("requested TSC rate %u falls outside tolerance [%u,%u]\n",
> +			 this_tsc_khz, thresh_lo, thresh_hi);
>  		use_scaling = 1;
>  	}
>  	kvm_x86_ops->set_tsc_khz(vcpu, this_tsc_khz, use_scaling);
> @@ -1062,12 +1065,12 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	    vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
>  		if (!check_tsc_unstable()) {
>  			offset = kvm->arch.cur_tsc_offset;
> -			pr_debug("kvm: matched tsc offset for %llu\n", data);
> +			pr_debug("matched tsc offset for %llu\n", data);
>  		} else {
>  			u64 delta = nsec_to_cycles(vcpu, elapsed);
>  			data += delta;
>  			offset = kvm_x86_ops->compute_tsc_offset(vcpu, data);
> -			pr_debug("kvm: adjusted tsc offset by %llu\n", delta);
> +			pr_debug("adjusted tsc offset by %llu\n", delta);
>  		}
>  	} else {
>  		/*
> @@ -1083,7 +1086,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>  		kvm->arch.cur_tsc_nsec = ns;
>  		kvm->arch.cur_tsc_write = data;
>  		kvm->arch.cur_tsc_offset = offset;
> -		pr_debug("kvm: new tsc generation %u, clock %llu\n",
> +		pr_debug("new tsc generation %u, clock %llu\n",
>  			 kvm->arch.cur_tsc_generation, data);
>  	}
>  
> @@ -3967,7 +3970,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
>  	return X86EMUL_CONTINUE;
>  
>  emul_write:
> -	printk_once(KERN_WARNING "kvm: emulating exchange as write\n");
> +	pr_warn_once("emulating exchange as write\n");
>  
>  	return emulator_write_emulated(ctxt, addr, new, bytes, exception);
>  }
> @@ -4802,7 +4805,7 @@ static void kvm_timer_init(void)
>  		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
>  					  CPUFREQ_TRANSITION_NOTIFIER);
>  	}
> -	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
> +	pr_debug("max_tsc_khz = %ld\n", max_tsc_khz);
>  	for_each_online_cpu(cpu)
>  		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
>  }
> @@ -4882,18 +4885,18 @@ int kvm_arch_init(void *opaque)
>  	struct kvm_x86_ops *ops = (struct kvm_x86_ops *)opaque;
>  
>  	if (kvm_x86_ops) {
> -		printk(KERN_ERR "kvm: already loaded the other module\n");
> +		pr_err("already loaded the other module\n");
>  		r = -EEXIST;
>  		goto out;
>  	}
>  
>  	if (!ops->cpu_has_kvm_support()) {
> -		printk(KERN_ERR "kvm: no hardware support\n");
> +		pr_err("no hardware support\n");
>  		r = -EOPNOTSUPP;
>  		goto out;
>  	}
>  	if (ops->disabled_by_bios()) {
> -		printk(KERN_ERR "kvm: disabled by bios\n");
> +		pr_err("disabled by bios\n");
>  		r = -EOPNOTSUPP;
>  		goto out;
>  	}
> @@ -5986,9 +5989,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  						unsigned int id)
>  {
>  	if (check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
> -		printk_once(KERN_WARNING
> -		"kvm: SMP vm created on host with unstable TSC; "
> -		"guest TSC will not be reliable\n");
> +		pr_warn_once("SMP vm created on host with unstable TSC; guest TSC will not be reliable\n");
>  	return kvm_x86_ops->vcpu_create(kvm, id);
>  }
>  
> @@ -6407,9 +6408,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  		ret = vm_munmap(old.userspace_addr,
>  				old.npages * PAGE_SIZE);
>  		if (ret < 0)
> -			printk(KERN_WARNING
> -			       "kvm_vm_ioctl_set_memory_region: "
> -			       "failed to munmap memory\n");
> +			pr_warn("%s: failed to munmap memory\n", __func__);
>  	}
>  
>  	if (!kvm->arch.n_requested_mmu_pages)
> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> index 01f572c..e2b8401 100644
> --- a/virt/kvm/assigned-dev.c
> +++ b/virt/kvm/assigned-dev.c
> @@ -8,6 +8,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kvm_host.h>
>  #include <linux/kvm.h>
>  #include <linux/uaccess.h>
> @@ -50,7 +52,7 @@ static int find_index_from_host_irq(struct kvm_assigned_dev_kernel
>  			break;
>  		}
>  	if (index < 0)
> -		printk(KERN_WARNING "Fail to find correlated MSI-X entry!\n");
> +		pr_warn("Fail to find correlated MSI-X entry!\n");
>  
>  	return index;
>  }
> @@ -270,8 +272,8 @@ static void kvm_free_assigned_device(struct kvm *kvm,
>  	pci_reset_function(assigned_dev->dev);
>  	if (pci_load_and_free_saved_state(assigned_dev->dev,
>  					  &assigned_dev->pci_saved_state))
> -		printk(KERN_INFO "%s: Couldn't reload %s saved state\n",
> -		       __func__, dev_name(&assigned_dev->dev->dev));
> +		pr_info("%s: Couldn't reload %s saved state\n",
> +			__func__, dev_name(&assigned_dev->dev->dev));
>  	else
>  		pci_restore_state(assigned_dev->dev);
>  
> @@ -653,8 +655,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
>  
>  	match = kzalloc(sizeof(struct kvm_assigned_dev_kernel), GFP_KERNEL);
>  	if (match == NULL) {
> -		printk(KERN_INFO "%s: Couldn't allocate memory\n",
> -		       __func__);
> +		pr_info("%s: Couldn't allocate memory\n", __func__);
>  		r = -ENOMEM;
>  		goto out;
>  	}
> @@ -662,7 +663,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
>  				   assigned_dev->busnr,
>  				   assigned_dev->devfn);
>  	if (!dev) {
> -		printk(KERN_INFO "%s: host device not found\n", __func__);
> +		pr_info("%s: host device not found\n", __func__);
>  		r = -EINVAL;
>  		goto out_free;
>  	}
> @@ -679,14 +680,14 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
>  		goto out_put;
>  
>  	if (pci_enable_device(dev)) {
> -		printk(KERN_INFO "%s: Could not enable PCI device\n", __func__);
> +		pr_info("%s: Could not enable PCI device\n", __func__);
>  		r = -EBUSY;
>  		goto out_put;
>  	}
>  	r = pci_request_regions(dev, "kvm_assigned_device");
>  	if (r) {
> -		printk(KERN_INFO "%s: Could not get access to device regions\n",
> -		       __func__);
> +		pr_info("%s: Could not get access to device regions\n",
> +			__func__);
>  		goto out_disable;
>  	}
>  
> @@ -694,8 +695,8 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
>  	pci_save_state(dev);
>  	match->pci_saved_state = pci_store_saved_state(dev);
>  	if (!match->pci_saved_state)
> -		printk(KERN_DEBUG "%s: Couldn't store %s saved state\n",
> -		       __func__, dev_name(&dev->dev));
> +		pr_debug("%s: Couldn't store %s saved state\n",
> +			 __func__, dev_name(&dev->dev));
>  
>  	if (!pci_intx_mask_supported(dev))
>  		assigned_dev->flags &= ~KVM_DEV_ASSIGN_PCI_2_3;
> @@ -729,8 +730,8 @@ out:
>  	return r;
>  out_list_del:
>  	if (pci_load_and_free_saved_state(dev, &match->pci_saved_state))
> -		printk(KERN_INFO "%s: Couldn't reload %s saved state\n",
> -		       __func__, dev_name(&dev->dev));
> +		pr_info("%s: Couldn't reload %s saved state\n",
> +			__func__, dev_name(&dev->dev));
>  	list_del(&match->list);
>  	pci_release_regions(dev);
>  out_disable:
> @@ -755,8 +756,8 @@ static int kvm_vm_ioctl_deassign_device(struct kvm *kvm,
>  	match = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head,
>  				      assigned_dev->assigned_dev_id);
>  	if (!match) {
> -		printk(KERN_INFO "%s: device hasn't been assigned before, "
> -		  "so cannot be deassigned\n", __func__);
> +		pr_info("%s: device hasn't been assigned before, so cannot be deassigned\n",
> +			__func__);
>  		r = -EINVAL;
>  		goto out;
>  	}
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 26fd54d..9cdba16 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -27,6 +27,8 @@
>   *  Based on Xen 3.1 code.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kvm_host.h>
>  #include <linux/kvm.h>
>  #include <linux/mm.h>
> @@ -45,9 +47,15 @@
>  #include "irq.h"
>  
>  #if 0
> -#define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
> +#define ioapic_debug(fmt, ...)			\
> +	pr_warn(fmt, ##__VA_ARGS__)
>  #else
> -#define ioapic_debug(fmt, arg...)
> +#define ioapic_debug(fmt, ...)			\
> +do {						\
> +	if (0)					\
> +		pr_warn(fmt, ##__VA_ARGS__);	\
> +} while (0)
> +
>  #endif
>  static int ioapic_deliver(struct kvm_ioapic *vioapic, int irq);
>  
> @@ -165,8 +173,7 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
>  	union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];
>  	struct kvm_lapic_irq irqe;
>  
> -	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
> -		     "vector=%x trig_mode=%x\n",
> +	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x vector=%x trig_mode=%x\n",
>  		     entry->fields.dest_id, entry->fields.dest_mode,
>  		     entry->fields.delivery_mode, entry->fields.vector,
>  		     entry->fields.trig_mode);
> @@ -289,7 +296,7 @@ static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
>  	if (!ioapic_in_range(ioapic, addr))
>  		return -EOPNOTSUPP;
>  
> -	ioapic_debug("addr %lx\n", (unsigned long)addr);
> +	ioapic_debug("addr %llx\n", addr);
>  	ASSERT(!(addr & 0xf));	/* check alignment */
>  
>  	addr &= 0xff;
> @@ -319,7 +326,7 @@ static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
>  		memcpy(val, (char *)&result, len);
>  		break;
>  	default:
> -		printk(KERN_WARNING "ioapic: wrong length %d\n", len);
> +		pr_warn("wrong length %d\n", len);
>  	}
>  	return 0;
>  }
> @@ -332,8 +339,8 @@ static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
>  	if (!ioapic_in_range(ioapic, addr))
>  		return -EOPNOTSUPP;
>  
> -	ioapic_debug("ioapic_mmio_write addr=%p len=%d val=%p\n",
> -		     (void*)addr, len, val);
> +	ioapic_debug("%s: addr=%llx len=%d val=%p\n",
> +		     __func__, addr, len, val);
>  	ASSERT(!(addr & 0xf));	/* check alignment */
>  
>  	switch (len) {
> @@ -348,7 +355,7 @@ static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
>  		data = *(u8  *) val;
>  		break;
>  	default:
> -		printk(KERN_WARNING "ioapic: Unsupported size %d\n", len);
> +		pr_warn("Unsupported size %d\n", len);
>  		return 0;
>  	}
>  
> diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
> index 32872a0..acac0a7 100644
> --- a/virt/kvm/ioapic.h
> +++ b/virt/kvm/ioapic.h
> @@ -53,8 +53,8 @@ struct kvm_ioapic {
>  #define ASSERT(x)  							\
>  do {									\
>  	if (!(x)) {							\
> -		printk(KERN_EMERG "assertion failed %s: %d: %s\n",	\
> -		       __FILE__, __LINE__, #x);				\
> +		pr_emerg("assertion failed %s: %d: %s\n",		\
> +			 __FILE__, __LINE__, #x);			\
>  		BUG();							\
>  	}								\
>  } while (0)
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index e9fff98..dae601f 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -23,6 +23,8 @@
>   * Author: Ben-Ami Yassour <benami@il.ibm.com>
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/list.h>
>  #include <linux/kvm_host.h>
>  #include <linux/module.h>
> @@ -115,8 +117,8 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
>  		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
>  			      page_size, flags);
>  		if (r) {
> -			printk(KERN_ERR "kvm_iommu_map_address:"
> -			       "iommu failed to map pfn=%llx\n", pfn);
> +			pr_err("%s: iommu failed to map pfn=%llx\n",
> +			       __func__, pfn);
>  			goto unmap_pages;
>  		}
>  
> @@ -168,7 +170,7 @@ int kvm_assign_device(struct kvm *kvm,
>  
>  	r = iommu_attach_device(domain, &pdev->dev);
>  	if (r) {
> -		printk(KERN_ERR "assign device %x:%x:%x.%x failed",
> +		pr_err("assign device %x:%x:%x.%x failed\n",
>  			pci_domain_nr(pdev->bus),
>  			pdev->bus->number,
>  			PCI_SLOT(pdev->devfn),
> @@ -192,11 +194,11 @@ int kvm_assign_device(struct kvm *kvm,
>  
>  	pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
>  
> -	printk(KERN_DEBUG "assign device %x:%x:%x.%x\n",
> -		assigned_dev->host_segnr,
> -		assigned_dev->host_busnr,
> -		PCI_SLOT(assigned_dev->host_devfn),
> -		PCI_FUNC(assigned_dev->host_devfn));
> +	pr_debug("assign device %x:%x:%x.%x\n",
> +		 assigned_dev->host_segnr,
> +		 assigned_dev->host_busnr,
> +		 PCI_SLOT(assigned_dev->host_devfn),
> +		 PCI_FUNC(assigned_dev->host_devfn));
>  
>  	return 0;
>  out_unmap:
> @@ -222,11 +224,11 @@ int kvm_deassign_device(struct kvm *kvm,
>  
>  	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
>  
> -	printk(KERN_DEBUG "deassign device %x:%x:%x.%x\n",
> -		assigned_dev->host_segnr,
> -		assigned_dev->host_busnr,
> -		PCI_SLOT(assigned_dev->host_devfn),
> -		PCI_FUNC(assigned_dev->host_devfn));
> +	pr_debug("deassign device %x:%x:%x.%x\n",
> +		 assigned_dev->host_segnr,
> +		 assigned_dev->host_busnr,
> +		 PCI_SLOT(assigned_dev->host_devfn),
> +		 PCI_FUNC(assigned_dev->host_devfn));
>  
>  	return 0;
>  }
> @@ -236,7 +238,7 @@ int kvm_iommu_map_guest(struct kvm *kvm)
>  	int r;
>  
>  	if (!iommu_present(&pci_bus_type)) {
> -		printk(KERN_ERR "%s: iommu not found\n", __func__);
> +		pr_err("%s: iommu not found\n", __func__);
>  		return -ENODEV;
>  	}
>  
> @@ -251,10 +253,8 @@ int kvm_iommu_map_guest(struct kvm *kvm)
>  	if (!allow_unsafe_assigned_interrupts &&
>  	    !iommu_domain_has_cap(kvm->arch.iommu_domain,
>  				  IOMMU_CAP_INTR_REMAP)) {
> -		printk(KERN_WARNING "%s: No interrupt remapping support,"
> -		       " disallowing device assignment."
> -		       " Re-enble with \"allow_unsafe_assigned_interrupts=1\""
> -		       " module option.\n", __func__);
> +		pr_warn("%s: No interrupt remapping support, disallowing device assignment. Re-enble with \"allow_unsafe_assigned_interrupts=1\" module option.\n",
> +			__func__);
>  		iommu_domain_free(kvm->arch.iommu_domain);
>  		kvm->arch.iommu_domain = NULL;
>  		r = -EPERM;
> diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> index 5afb431..5728dbb 100644
> --- a/virt/kvm/irq_comm.c
> +++ b/virt/kvm/irq_comm.c
> @@ -20,6 +20,8 @@
>   * Copyright 2010 Red Hat, Inc. and/or its affiliates.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kvm_host.h>
>  #include <linux/slab.h>
>  #include <trace/events/kvm.h>
> @@ -86,7 +88,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>  
>  	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
>  			kvm_is_dm_lowest_prio(irq))
> -		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
> +		pr_info("apic: phys broadcast and lowest prio\n");
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (!kvm_apic_present(vcpu))
> @@ -234,7 +236,7 @@ int kvm_request_irq_source_id(struct kvm *kvm)
>  	irq_source_id = find_first_zero_bit(bitmap, BITS_PER_LONG);
>  
>  	if (irq_source_id >= BITS_PER_LONG) {
> -		printk(KERN_WARNING "kvm: exhaust allocatable IRQ sources!\n");
> +		pr_warn("exhaust allocatable IRQ sources!\n");
>  		irq_source_id = -EFAULT;
>  		goto unlock;
>  	}
> @@ -256,7 +258,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
>  	mutex_lock(&kvm->irq_lock);
>  	if (irq_source_id < 0 ||
>  	    irq_source_id >= BITS_PER_LONG) {
> -		printk(KERN_ERR "kvm: IRQ source ID out of range!\n");
> +		pr_err("IRQ source ID out of range!\n");
>  		goto unlock;
>  	}
>  	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 02cb440..4bd6619 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -16,6 +16,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "iodev.h"
>  
>  #include <linux/kvm_host.h>
> @@ -2304,8 +2306,7 @@ static void hardware_enable_nolock(void *junk)
>  	if (r) {
>  		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
>  		atomic_inc(&hardware_enable_failed);
> -		printk(KERN_INFO "kvm: enabling virtualization on "
> -				 "CPU%d failed\n", cpu);
> +		pr_info("enabling virtualization on CPU%d failed\n", cpu);
>  	}
>  }
>  
> @@ -2382,13 +2383,11 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
>  	val &= ~CPU_TASKS_FROZEN;
>  	switch (val) {
>  	case CPU_DYING:
> -		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
> -		       cpu);
> +		pr_info("disabling virtualization on CPU%d\n", cpu);
>  		hardware_disable(NULL);
>  		break;
>  	case CPU_STARTING:
> -		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
> -		       cpu);
> +		pr_info("enabling virtualization on CPU%d\n", cpu);
>  		hardware_enable(NULL);
>  		break;
>  	}
> @@ -2412,7 +2411,7 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
>  	 *
>  	 * And Intel TXT required VMX off for all cpu when system shutdown.
>  	 */
> -	printk(KERN_INFO "kvm: exiting hardware virtualization\n");
> +	pr_info("exiting hardware virtualization\n");
>  	kvm_rebooting = true;
>  	on_each_cpu(hardware_disable_nolock, NULL, 1);
>  	return NOTIFY_OK;
> @@ -2800,7 +2799,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  
>  	r = misc_register(&kvm_dev);
>  	if (r) {
> -		printk(KERN_ERR "kvm: misc device register failed\n");
> +		pr_err("misc device register failed\n");
>  		goto out_unreg;
>  	}
>  
> @@ -2811,7 +2810,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  
>  	r = kvm_init_debug();
>  	if (r) {
> -		printk(KERN_ERR "kvm: create debugfs files failed\n");
> +		pr_err("create debugfs files failed\n");
>  		goto out_undebugfs;
>  	}
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
