Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1G0SFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:05:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51056 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab1G0SFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:05:36 -0400
From: "N, Mugunthan V" <mugunthanvnm@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Wed, 27 Jul 2011 23:35:19 +0530
Subject: RE: [ANNOUNCE] 3.0-rt3
Thread-Topic: [ANNOUNCE] 3.0-rt3
Thread-Index: AcxJ7TEYIE0St97rTeWF5uLP+ycb1gCY+ROA
Message-ID: <45EE9921DD12714AB1D7B7B9D2FE208B0230256D48BF@dbde03.ent.ti.com>
References: <alpine.LFD.2.02.1107241223560.2702@ionos>
In-Reply-To: <alpine.LFD.2.02.1107241223560.2702@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_003_45EE9921DD12714AB1D7B7B9D2FE208B0230256D48BFdbde03entti_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_003_45EE9921DD12714AB1D7B7B9D2FE208B0230256D48BFdbde03entti_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi RT Folks

I am testing 3.0-rt3 on AM3517 - Arm Cortex A8. As the kernel from the
mainline is not booting I am using a patch to boot AM3517 kernel on top of
the mainline kernel. Its crashing when I start hackbench and cyclictest.

There were two warnings while starting the test and then the kernel crashes=
.
Attaching the patch and the rt-config file.

[  266.001220] BUG: sleeping function called from invalid context at
kernel/rtmutex.c:645
[  266.001251] in_atomic(): 1, irqs_disabled(): 0, pid: 3, name: ksoftirqd/=
0
[  266.001281] 1 lock held by ksoftirqd/0/3:
[  266.001281]  #0:  (cpu_asid_lock){+.+...}, at: [<c006acfc>]
__new_context+0x14/0xbc
[  266.001403] [<c0065f40>] (unwind_backtrace+0x0/0xf8) from [<c0466c80>]
(rt_spin_lock+0x24/0x5c)
[  266.001434] [<c0466c80>] (rt_spin_lock+0x24/0x5c) from [<c006aca8>]
(set_mm_context+0x1c/0x5c)
[  266.001464] [<c006aca8>] (set_mm_context+0x1c/0x5c) from [<c006ad3c>]
(__new_context+0x54/0xbc)
[  266.001495] [<c006ad3c>] (__new_context+0x54/0xbc) from [<c0464f14>]
(__schedule+0x738/0x818)
[  266.001556] [<c0464f14>] (__schedule+0x738/0x818) from [<c0095408>]
(schedule+0x34/0xac)
[  266.001586] [<c0095408>] (schedule+0x34/0xac) from [<c046569c>]
(schedule_preempt_disabled+0x14/0x20)
[  266.001647] [<c046569c>] (schedule_preempt_disabled+0x14/0x20) from
[<c00a2a74>] (run_ksoftirqd+0x174/0x194)
[  266.001678] [<c00a2a74>] (run_ksoftirqd+0x174/0x194) from [<c00bc81c>]
(kthread+0x84/0x8c)
[  266.001739] [<c00bc81c>] (kthread+0x84/0x8c) from [<c005fd2c>]
(kernel_thread_exit+0x0/0x8)

[  267.494995] ------------[ cut here ]------------
[  267.495086] WARNING: at kernel/lockdep.c:939 __bfs+0x1f8/0x254()
[  267.495086] Modules linked in:
[  267.495147] [<c0065f40>] (unwind_backtrace+0x0/0xf8) from [<c009b774>]
(warn_slowpath_common+0x4c/0x64)
[  267.495178] [<c009b774>] (warn_slowpath_common+0x4c/0x64) from
[<c009b7a8>] (warn_slowpath_null+0x1c/0x24)
[  267.495208] [<c009b7a8>] (warn_slowpath_null+0x1c/0x24) from
[<c00d0014>] (__bfs+0x1f8/0x254)
[  267.495239] [<c00d0014>] (__bfs+0x1f8/0x254) from [<c00d38bc>]
(check_usage_backwards+0x74/0xfc)
[  267.495269] [<c00d38bc>] (check_usage_backwards+0x74/0xfc) from
[<c00d2990>] (mark_lock+0x20c/0x660)
[  267.495300] [<c00d2990>] (mark_lock+0x20c/0x660) from [<c00d495c>]
(__lock_acquire+0x74c/0x1c84)
[  267.495330] [<c00d495c>] (__lock_acquire+0x74c/0x1c84) from [<c00d64c0>]
(lock_acquire+0x104/0x124)
[  267.495361] [<c00d64c0>] (lock_acquire+0x104/0x124) from [<c046753c>]
(_raw_spin_lock+0x3c/0x4c)
[  267.495422] [<c046753c>] (_raw_spin_lock+0x3c/0x4c) from [<c04665a4>]
(rt_mutex_slowlock+0x28/0x178)
[  267.495452] [<c04665a4>] (rt_mutex_slowlock+0x28/0x178) from
[<c00eb734>] (rcu_boost_kthread+0xd4/0x168)
[  267.495513] [<c00eb734>] (rcu_boost_kthread+0xd4/0x168) from
[<c00bc81c>] (kthread+0x84/0x8c)
[  267.495544] [<c00bc81c>] (kthread+0x84/0x8c) from [<c005fd2c>]
(kernel_thread_exit+0x0/0x8)
[  267.495574] ---[ end trace 000000000000000d ]---

[  267.495605] Unable to handle kernel NULL pointer dereference at virtual
address 00000008
[  267.495605] pgd =3D c0004000
[  267.495635] [00000008] *pgd=3D00000000
[  267.495635] Internal error: Oops: 17 [#1] PREEMPT SMP
[  267.495666] Modules linked in:
[  267.495697] CPU: 0    Tainted: G        W
(3.0.0-rt3-00001-gcd4001e-dirty #6)
[  267.495697] PC is at __bfs+0x118/0x254
[  267.495727] LR is at warn_slowpath_null+0x1c/0x24
[  267.495758] pc : [<c00cff34>]    lr : [<c009b7a8>]    psr: 60000093
[  267.495758] sp : cf84bce8  ip : 00000000  fp : cf84bcfc
[  267.495788] r10: 00004954  r9 : 00004958  r8 : c056c688
[  267.495788] r7 : c8df6be0  r6 : c0948b20  r5 : c06f3258  r4 : 00000000
[  267.495819] r3 : c094cb10  r2 : 00000200  r1 : c068ee10  r0 : 00000000
[  267.495819] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[  267.495849] Control: 10c5387d  Table: 8df68019  DAC: 00000017
[  267.495849] Process rcub0 (pid: 10, stack limit =3D 0xcf84a2f8)
[  267.495880] Stack: (0xcf84bce8 to 0xcf84c000)
[  267.495910] bce0:                   cf84bff8 cf84bd54 c00cfd14 00000000
00000000 cf84bd30
[  267.495941] bd00: cf84bd34 00000000 cf84bd30 cf8499d8 cf849520 c056c688
c00d3848 cf84a000
[  267.495941] bd20: c09dc8d0 c00d38bc 00000000 c00626a8 00000000 00000000
c06f3160 c005fd2c
[  267.495971] bd40: c005fd2c c06f31a0 00000000 00000000 00000000 c06f31a0
00000004 00000000
[  267.496002] bd60: 00000002 cf8499d8 cf849520 c00d2990 00000008 cf849520
00000000 cf849520
[  267.496032] bd80: 00000000 cf8499d8 cf84bf38 3c3be3df 00000000 c00d495c
00000093 00000000
[  267.496063] bda0: cf84a000 00000000 00000000 00000000 cf84a000 cf84a000
00000000 3c3be3de
[  267.496063] bdc0: 60000013 c0664ffc 00000000 cf849520 00000001 00000000
00000000 c046a3b0
[  267.496093] bde0: 00000000 c008b7a4 00000000 cf849520 00000010 cf849520
00000000 cf8499d8
[  267.496124] be00: c0666814 0000002a 00000000 c00d4670 cf849520 c0090bb8
00000001 00000000
[  267.496154] be20: cf84a000 00000000 00000000 00000000 60000013 cf84bf38
00000002 c00d64c0
[  267.496185] be40: 00000002 00000000 00000000 c04665a4 00000000 00000001
ffffffff 00000000
[  267.496215] be60: cf84bf24 c04665a4 00000001 cf84bf24 00000000 a0000013
00000002 c046753c
[  267.496215] be80: 00000002 00000000 c04665a4 cf84a000 ce25cae0 c0666800
cf84a000 c04665a4
[  267.496246] bea0: 00000000 00000000 60000093 00000000 00000002 c00d64c0
00000002 00000080
[  267.496276] bec0: 00000000 c00eb778 00000000 c0052520 c0052520 00000000
c0666800 c00eb778
[  267.496307] bee0: a0000013 00000000 cf849520 00000000 cf84a000 00000000
cf84bf0c ce25cae0
[  267.496337] bf00: c0666800 cf84a000 00000001 00000000 00000000 a0000013
cf84bf24 c00eb734
[  267.496337] bf20: c0052520 cf84995c cf849520 c04677a8 c0df0520 c00eb660
00000000 c00d3160
[  267.496368] bf40: cf84a000 00000001 cf84bf48 cf84bf48 ce25cae0 c0666800
c00eb660 cf84bf8c
[  267.496398] bf60: cf82fec8 c0666800 c00eb660 00000000 00000000 00000000
00000000 c00bc81c
[  267.496429] bf80: cf84a000 00000000 c0666800 00000000 00000000 c005ed18
dead4ead ffffffff
[  267.496459] bfa0: ffffffff c06a1120 00000000 00000000 c0569f74 cf84bfb4
cf84bfb4 00000000
[  267.496490] bfc0: cf82fec8 c00bc798 c06a1104 00000000 00000000 c0575564
cf84bfd8 cf84bfd8
[  267.496490] bfe0: 00000000 cf82fec8 c00bc798 c005fd2c 00000013 c005fd2c
fc9cff55 b687ef0f
[  267.496551] [<c00cff34>] (__bfs+0x118/0x254) from [<c00d38bc>]
(check_usage_backwards+0x74/0xfc)
[  267.496582] [<c00d38bc>] (check_usage_backwards+0x74/0xfc) from
[<c00d2990>] (mark_lock+0x20c/0x660)
[  267.496582] [<c00d2990>] (mark_lock+0x20c/0x660) from [<c00d495c>]
(__lock_acquire+0x74c/0x1c84)
[  267.496612] [<c00d495c>] (__lock_acquire+0x74c/0x1c84) from [<c00d64c0>]
(lock_acquire+0x104/0x124)
[  267.496643] [<c00d64c0>] (lock_acquire+0x104/0x124) from [<c046753c>]
(_raw_spin_lock+0x3c/0x4c)
[  267.496673] [<c046753c>] (_raw_spin_lock+0x3c/0x4c) from [<c04665a4>]
(rt_mutex_slowlock+0x28/0x178)
[  267.496734] [<c04665a4>] (rt_mutex_slowlock+0x28/0x178) from
[<c00eb734>] (rcu_boost_kthread+0xd4/0x168)
[  267.496765] [<c00eb734>] (rcu_boost_kthread+0xd4/0x168) from
[<c00bc81c>] (kthread+0x84/0x8c)
[  267.496795] [<c00bc81c>] (kthread+0x84/0x8c) from [<c005fd2c>]
(kernel_thread_exit+0x0/0x8)
[  267.496826] Code: e0837182 e1570001 2a000035 e59f3114 (e5941008)

---
Regards,
Mugunthan V N.

-----Original Message-----
From: linux-rt-users-owner@vger.kernel.org [mailto:linux-rt-users-owner@vge=
r.kernel.org] On Behalf Of Thomas Gleixner
Sent: Sunday, July 24, 2011 4:04 PM
To: LKML
Cc: linux-rt-users
Subject: [ANNOUNCE] 3.0-rt3

Dear RT Folks,

I'm pleased to announce the 3.0-rt3 release.

Changes versus 3.0-rt2:

  * Fix earlyprintk really

  * AMD NB fix for allocation in smp function call, reported by Ed

  * Disabled a few config options on RT which have known issues

Patch against 3.0 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt3.patch.bz=
2

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0-rt3.tar.bz=
2

Delta patch below.

Thanks,

        tglx
----
 arch/x86/include/asm/amd_nb.h         |    6 +
 arch/x86/kernel/cpu/intel_cacheinfo.c |  121 +++++++++++------------------=
-----
 arch/x86/kernel/early_printk.c        |    2
 drivers/net/Kconfig                   |    1
 localversion-rt                       |    2
 mm/Kconfig                            |    2
 6 files changed, 51 insertions(+), 83 deletions(-)

Index: linux-2.6/arch/x86/kernel/early_printk.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/arch/x86/kernel/early_printk.c
+++ linux-2.6/arch/x86/kernel/early_printk.c
@@ -171,7 +171,7 @@ static struct console early_serial_conso

 static inline void early_console_register(struct console *con, int keep_ea=
rly)
 {
-       if (early_console->index !=3D -1) {
+       if (con->index !=3D -1) {
                printk(KERN_CRIT "ERROR: earlyprintk=3D %s already used\n",
                       con->name);
                return;
Index: linux-2.6/localversion-rt
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt2
+-rt3
Index: linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -151,28 +151,17 @@ union _cpuid4_leaf_ecx {
        u32 full;
 };

-struct amd_l3_cache {
-       struct   amd_northbridge *nb;
-       unsigned indices;
-       u8       subcaches[4];
-};
-
-struct _cpuid4_info {
+struct _cpuid4_info_regs {
        union _cpuid4_leaf_eax eax;
        union _cpuid4_leaf_ebx ebx;
        union _cpuid4_leaf_ecx ecx;
        unsigned long size;
-       struct amd_l3_cache *l3;
-       DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
+       struct amd_northbridge *nb;
 };

-/* subset of above _cpuid4_info w/o shared_cpu_map */
-struct _cpuid4_info_regs {
-       union _cpuid4_leaf_eax eax;
-       union _cpuid4_leaf_ebx ebx;
-       union _cpuid4_leaf_ecx ecx;
-       unsigned long size;
-       struct amd_l3_cache *l3;
+struct _cpuid4_info {
+       struct _cpuid4_info_regs base;
+       DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
 };

 unsigned short                 num_cache_leaves;
@@ -314,12 +303,13 @@ struct _cache_attr {
 /*
  * L3 cache descriptors
  */
-static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
+static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
 {
+       struct amd_l3_cache *l3 =3D &nb->l3_cache;
        unsigned int sc0, sc1, sc2, sc3;
        u32 val =3D 0;

-       pci_read_config_dword(l3->nb->misc, 0x1C4, &val);
+       pci_read_config_dword(nb->misc, 0x1C4, &val);

        /* calculate subcache sizes */
        l3->subcaches[0] =3D sc0 =3D !(val & BIT(0));
@@ -333,33 +323,16 @@ static void __cpuinit amd_calc_l3_indice
 static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_lea=
f,
                                        int index)
 {
-       static struct amd_l3_cache *__cpuinitdata l3_caches;
        int node;

        /* only for L3, and not in virtualized environments */
-       if (index < 3 || amd_nb_num() =3D=3D 0)
+       if (index < 3)
                return;

-       /*
-        * Strictly speaking, the amount in @size below is leaked since it =
is
-        * never freed but this is done only on shutdown so it doesn't matt=
er.
-        */
-       if (!l3_caches) {
-               int size =3D amd_nb_num() * sizeof(struct amd_l3_cache);
-
-               l3_caches =3D kzalloc(size, GFP_ATOMIC);
-               if (!l3_caches)
-                       return;
-       }
-
        node =3D amd_get_nb_id(smp_processor_id());
-
-       if (!l3_caches[node].nb) {
-               l3_caches[node].nb =3D node_to_amd_nb(node);
-               amd_calc_l3_indices(&l3_caches[node]);
-       }
-
-       this_leaf->l3 =3D &l3_caches[node];
+       this_leaf->nb =3D node_to_amd_nb(node);
+       if (this_leaf->nb && !this_leaf->nb->l3_cache.indices)
+               amd_calc_l3_indices(this_leaf->nb);
 }

 /*
@@ -369,11 +342,11 @@ static void __cpuinit amd_init_l3_cache(
  *
  * @returns: the disabled index if used or negative value if slot free.
  */
-int amd_get_l3_disable_slot(struct amd_l3_cache *l3, unsigned slot)
+int amd_get_l3_disable_slot(struct amd_northbridge *nb, unsigned slot)
 {
        unsigned int reg =3D 0;

-       pci_read_config_dword(l3->nb->misc, 0x1BC + slot * 4, &reg);
+       pci_read_config_dword(nb->misc, 0x1BC + slot * 4, &reg);

        /* check whether this slot is activated already */
        if (reg & (3UL << 30))
@@ -387,11 +360,10 @@ static ssize_t show_cache_disable(struct
 {
        int index;

-       if (!this_leaf->l3 ||
-           !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+       if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISA=
BLE))
                return -EINVAL;

-       index =3D amd_get_l3_disable_slot(this_leaf->l3, slot);
+       index =3D amd_get_l3_disable_slot(this_leaf->base.nb, slot);
        if (index >=3D 0)
                return sprintf(buf, "%d\n", index);

@@ -408,7 +380,7 @@ show_cache_disable_##slot(struct _cpuid4
 SHOW_CACHE_DISABLE(0)
 SHOW_CACHE_DISABLE(1)

-static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
+static void amd_l3_disable_index(struct amd_northbridge *nb, int cpu,
                                 unsigned slot, unsigned long idx)
 {
        int i;
@@ -421,10 +393,10 @@ static void amd_l3_disable_index(struct
        for (i =3D 0; i < 4; i++) {
                u32 reg =3D idx | (i << 20);

-               if (!l3->subcaches[i])
+               if (!nb->l3_cache.subcaches[i])
                        continue;

-               pci_write_config_dword(l3->nb->misc, 0x1BC + slot * 4, reg)=
;
+               pci_write_config_dword(nb->misc, 0x1BC + slot * 4, reg);

                /*
                 * We need to WBINVD on a core on the node containing the L=
3
@@ -434,7 +406,7 @@ static void amd_l3_disable_index(struct
                wbinvd_on_cpu(cpu);

                reg |=3D BIT(31);
-               pci_write_config_dword(l3->nb->misc, 0x1BC + slot * 4, reg)=
;
+               pci_write_config_dword(nb->misc, 0x1BC + slot * 4, reg);
        }
 }

@@ -448,24 +420,24 @@ static void amd_l3_disable_index(struct
  *
  * @return: 0 on success, error status on failure
  */
-int amd_set_l3_disable_slot(struct amd_l3_cache *l3, int cpu, unsigned slo=
t,
+int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned =
slot,
                            unsigned long index)
 {
        int ret =3D 0;

        /*  check if @slot is already used or the index is already disabled=
 */
-       ret =3D amd_get_l3_disable_slot(l3, slot);
+       ret =3D amd_get_l3_disable_slot(nb, slot);
        if (ret >=3D 0)
                return -EINVAL;

-       if (index > l3->indices)
+       if (index > nb->l3_cache.indices)
                return -EINVAL;

        /* check whether the other slot has disabled the same index already=
 */
-       if (index =3D=3D amd_get_l3_disable_slot(l3, !slot))
+       if (index =3D=3D amd_get_l3_disable_slot(nb, !slot))
                return -EINVAL;

-       amd_l3_disable_index(l3, cpu, slot, index);
+       amd_l3_disable_index(nb, cpu, slot, index);

        return 0;
 }
@@ -480,8 +452,7 @@ static ssize_t store_cache_disable(struc
        if (!capable(CAP_SYS_ADMIN))
                return -EPERM;

-       if (!this_leaf->l3 ||
-           !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+       if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISA=
BLE))
                return -EINVAL;

        cpu =3D cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
@@ -489,7 +460,7 @@ static ssize_t store_cache_disable(struc
        if (strict_strtoul(buf, 10, &val) < 0)
                return -EINVAL;

-       err =3D amd_set_l3_disable_slot(this_leaf->l3, cpu, slot, val);
+       err =3D amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val)=
;
        if (err) {
                if (err =3D=3D -EEXIST)
                        printk(KERN_WARNING "L3 disable slot %d in use!\n",
@@ -518,7 +489,7 @@ static struct _cache_attr cache_disable_
 static ssize_t
 show_subcaches(struct _cpuid4_info *this_leaf, char *buf, unsigned int cpu=
)
 {
-       if (!this_leaf->l3 || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+       if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONI=
NG))
                return -EINVAL;

        return sprintf(buf, "%x\n", amd_get_subcaches(cpu));
@@ -533,7 +504,7 @@ store_subcaches(struct _cpuid4_info *thi
        if (!capable(CAP_SYS_ADMIN))
                return -EPERM;

-       if (!this_leaf->l3 || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+       if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONI=
NG))
                return -EINVAL;

        if (strict_strtoul(buf, 16, &val) < 0)
@@ -769,7 +740,7 @@ static void __cpuinit cache_shared_cpu_m
                return;
        }
        this_leaf =3D CPUID4_INFO_IDX(cpu, index);
-       num_threads_sharing =3D 1 + this_leaf->eax.split.num_threads_sharin=
g;
+       num_threads_sharing =3D 1 + this_leaf->base.eax.split.num_threads_s=
haring;

        if (num_threads_sharing =3D=3D 1)
                cpumask_set_cpu(cpu, to_cpumask(this_leaf->shared_cpu_map))=
;
@@ -820,29 +791,19 @@ static void __cpuinit free_cache_attribu
        for (i =3D 0; i < num_cache_leaves; i++)
                cache_remove_shared_cpu_map(cpu, i);

-       kfree(per_cpu(ici_cpuid4_info, cpu)->l3);
        kfree(per_cpu(ici_cpuid4_info, cpu));
        per_cpu(ici_cpuid4_info, cpu) =3D NULL;
 }

-static int
-__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
-{
-       struct _cpuid4_info_regs *leaf_regs =3D
-               (struct _cpuid4_info_regs *)this_leaf;
-
-       return cpuid4_cache_lookup_regs(index, leaf_regs);
-}
-
 static void __cpuinit get_cpu_leaves(void *_retval)
 {
        int j, *retval =3D _retval, cpu =3D smp_processor_id();

        /* Do cpuid and store the results */
        for (j =3D 0; j < num_cache_leaves; j++) {
-               struct _cpuid4_info *this_leaf;
-               this_leaf =3D CPUID4_INFO_IDX(cpu, j);
-               *retval =3D cpuid4_cache_lookup(j, this_leaf);
+               struct _cpuid4_info *this_leaf =3D CPUID4_INFO_IDX(cpu, j);
+
+               *retval =3D cpuid4_cache_lookup_regs(j, &this_leaf->base);
                if (unlikely(*retval < 0)) {
                        int i;

@@ -900,16 +861,16 @@ static ssize_t show_##file_name(struct _
        return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val=
); \
 }

-show_one_plus(level, eax.split.level, 0);
-show_one_plus(coherency_line_size, ebx.split.coherency_line_size, 1);
-show_one_plus(physical_line_partition, ebx.split.physical_line_partition, =
1);
-show_one_plus(ways_of_associativity, ebx.split.ways_of_associativity, 1);
-show_one_plus(number_of_sets, ecx.split.number_of_sets, 1);
+show_one_plus(level, base.eax.split.level, 0);
+show_one_plus(coherency_line_size, base.ebx.split.coherency_line_size, 1);
+show_one_plus(physical_line_partition, base.ebx.split.physical_line_partit=
ion, 1);
+show_one_plus(ways_of_associativity, base.ebx.split.ways_of_associativity,=
 1);
+show_one_plus(number_of_sets, base.ecx.split.number_of_sets, 1);

 static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf,
                         unsigned int cpu)
 {
-       return sprintf(buf, "%luK\n", this_leaf->size / 1024);
+       return sprintf(buf, "%luK\n", this_leaf->base.size / 1024);
 }

 static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
@@ -946,7 +907,7 @@ static inline ssize_t show_shared_cpu_li
 static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf,
                         unsigned int cpu)
 {
-       switch (this_leaf->eax.split.type) {
+       switch (this_leaf->base.eax.split.type) {
        case CACHE_TYPE_DATA:
                return sprintf(buf, "Data\n");
        case CACHE_TYPE_INST:
@@ -1135,7 +1096,7 @@ static int __cpuinit cache_add_dev(struc

                ktype_cache.default_attrs =3D default_attrs;
 #ifdef CONFIG_AMD_NB
-               if (this_leaf->l3)
+               if (this_leaf->base.nb)
                        ktype_cache.default_attrs =3D amd_l3_attrs();
 #endif
                retval =3D kobject_init_and_add(&(this_object->kobj),
Index: linux-2.6/arch/x86/include/asm/amd_nb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/arch/x86/include/asm/amd_nb.h
+++ linux-2.6/arch/x86/include/asm/amd_nb.h
@@ -19,9 +19,15 @@ extern int amd_numa_init(void);
 extern int amd_get_subcaches(int);
 extern int amd_set_subcaches(int, int);

+struct amd_l3_cache {
+       unsigned indices;
+       u8       subcaches[4];
+};
+
 struct amd_northbridge {
        struct pci_dev *misc;
        struct pci_dev *link;
+       struct amd_l3_cache l3_cache;
 };

 struct amd_northbridge_info {
Index: linux-2.6/drivers/net/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/drivers/net/Kconfig
+++ linux-2.6/drivers/net/Kconfig
@@ -3410,6 +3410,7 @@ config NET_FC

 config NETCONSOLE
        tristate "Network console logging support"
+       depends on !PREEMPT_RT_FULL
        ---help---
        If you want to log kernel messages over the network, enable this.
        See <file:Documentation/networking/netconsole.txt> for details.
Index: linux-2.6/mm/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/mm/Kconfig
+++ linux-2.6/mm/Kconfig
@@ -304,7 +304,7 @@ config NOMMU_INITIAL_TRIM_EXCESS

 config TRANSPARENT_HUGEPAGE
        bool "Transparent Hugepage Support"
-       depends on X86 && MMU
+       depends on X86 && MMU && !PREEMPT_RT_FULL
        select COMPACTION
        help
          Transparent Hugepages allows the kernel to use huge pages and
--
To unsubscribe from this list: send the line "unsubscribe linux-rt-users" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--_003_45EE9921DD12714AB1D7B7B9D2FE208B0230256D48BFdbde03entti_
Content-Type: application/octet-stream; name="am3517evm.patch"
Content-Description: am3517evm.patch
Content-Disposition: attachment; filename="am3517evm.patch"; size=4456;
	creation-date="Thu, 16 Jun 2011 16:47:10 GMT";
	modification-date="Thu, 16 Jun 2011 16:47:10 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21hY2gtb21hcDIvS2NvbmZpZyBiL2FyY2gvYXJtL21hY2gt
b21hcDIvS2NvbmZpZwppbmRleCBiOTk3YTM1Li4xMmU4ZTM3IDEwMDY0NAotLS0gYS9hcmNoL2Fy
bS9tYWNoLW9tYXAyL0tjb25maWcKKysrIGIvYXJjaC9hcm0vbWFjaC1vbWFwMi9LY29uZmlnCkBA
IC0xNyw4ICsxNyw4IEBAIGNvbmZpZyBBUkNIX09NQVAyUExVU19UWVBJQ0FMCiAJc2VsZWN0IEky
Q19PTUFQCiAJc2VsZWN0IE1GRF9TVVBQT1JUCiAJc2VsZWN0IE1FTkVMQVVTIGlmIEFSQ0hfT01B
UDIKLQlzZWxlY3QgVFdMNDAzMF9DT1JFIGlmIEFSQ0hfT01BUDMgfHwgQVJDSF9PTUFQNAotCXNl
bGVjdCBUV0w0MDMwX1BPV0VSIGlmIEFSQ0hfT01BUDMgfHwgQVJDSF9PTUFQNAorCXNlbGVjdCBU
V0w0MDMwX0NPUkUgaWYgIU1BQ0hfT01BUDM1MTdFVk0gJiYgKEFSQ0hfT01BUDMgfHwgQVJDSF9P
TUFQNCkKKwlzZWxlY3QgVFdMNDAzMF9QT1dFUiBpZiAhTUFDSF9PTUFQMzUxN0VWTSAmJiAoQVJD
SF9PTUFQMyB8fCBBUkNIX09NQVA0KQogCWhlbHAKIAkgIENvbXBpbGUgYSBrZXJuZWwgc3VpdGFi
bGUgZm9yIGJvb3RpbmcgbW9zdCBib2FyZHMKIApkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vbWFjaC1v
bWFwMi9vbWFwX2h3bW9kXzN4eHhfZGF0YS5jIGIvYXJjaC9hcm0vbWFjaC1vbWFwMi9vbWFwX2h3
bW9kXzN4eHhfZGF0YS5jCmluZGV4IDkwOWE4NGQuLjEyNDhmZTcgMTAwNjQ0Ci0tLSBhL2FyY2gv
YXJtL21hY2gtb21hcDIvb21hcF9od21vZF8zeHh4X2RhdGEuYworKysgYi9hcmNoL2FybS9tYWNo
LW9tYXAyL29tYXBfaHdtb2RfM3h4eF9kYXRhLmMKQEAgLTM2NTksNyArMzY1OSwxMTYgQEAgc3Rh
dGljIF9faW5pdGRhdGEgc3RydWN0IG9tYXBfaHdtb2QgKm9tYXAzeHh4X2h3bW9kc1tdID0gewog
CU5VTEwsCiB9OwogCisvKioKKyAqIEhXTU9EcyBzcGVjaWZpYyB0byBBTTM1eCBwcm9jZXNzb3Jz
CisgKiBUaG91Z2ggdGhleSBhcmUgcXVpdGUgc2ltaWxhciB0byBPTUFQMzR4eCBkZWZpbml0aW9u
cywKKyAqIGhhdmluZyBzZXBhcmF0ZSBhcnJheSBtYWtlcyBjdXN0b21pemF0aW9uIGVhc3kuCisg
Ki8KK3N0YXRpYyBfX2luaXRkYXRhIHN0cnVjdCBvbWFwX2h3bW9kICphbTM1eHhfaHdtb2RzW10g
PSB7CisJJm9tYXAzeHh4X2wzX21haW5faHdtb2QsCisJJm9tYXAzeHh4X2w0X2NvcmVfaHdtb2Qs
CisJJm9tYXAzeHh4X2w0X3Blcl9od21vZCwKKwkmb21hcDN4eHhfbDRfd2t1cF9od21vZCwKKwkm
b21hcDN4eHhfbW1jMV9od21vZCwKKwkmb21hcDN4eHhfbW1jMl9od21vZCwKKwkmb21hcDN4eHhf
bW1jM19od21vZCwKKwkmb21hcDN4eHhfbXB1X2h3bW9kLAorCisJJm9tYXAzeHh4X3RpbWVyMV9o
d21vZCwKKwkmb21hcDN4eHhfdGltZXIyX2h3bW9kLAorCSZvbWFwM3h4eF90aW1lcjNfaHdtb2Qs
CisJJm9tYXAzeHh4X3RpbWVyNF9od21vZCwKKwkmb21hcDN4eHhfdGltZXI1X2h3bW9kLAorCSZv
bWFwM3h4eF90aW1lcjZfaHdtb2QsCisJJm9tYXAzeHh4X3RpbWVyN19od21vZCwKKwkmb21hcDN4
eHhfdGltZXI4X2h3bW9kLAorCSZvbWFwM3h4eF90aW1lcjlfaHdtb2QsCisJJm9tYXAzeHh4X3Rp
bWVyMTBfaHdtb2QsCisJJm9tYXAzeHh4X3RpbWVyMTFfaHdtb2QsCisJJm9tYXAzeHh4X3RpbWVy
MTJfaHdtb2QsCisKKwkmb21hcDN4eHhfd2RfdGltZXIyX2h3bW9kLAorCSZvbWFwM3h4eF91YXJ0
MV9od21vZCwKKwkmb21hcDN4eHhfdWFydDJfaHdtb2QsCisJJm9tYXAzeHh4X3VhcnQzX2h3bW9k
LAorCSZvbWFwM3h4eF91YXJ0NF9od21vZCwKKwkvKiBkc3MgY2xhc3MgKi8KKwkmb21hcDM0MzBl
czFfZHNzX2NvcmVfaHdtb2QsCisJJm9tYXAzeHh4X2Rzc19jb3JlX2h3bW9kLAorCSZvbWFwM3h4
eF9kc3NfZGlzcGNfaHdtb2QsCisJJm9tYXAzeHh4X2Rzc19kc2kxX2h3bW9kLAorCSZvbWFwM3h4
eF9kc3NfcmZiaV9od21vZCwKKwkmb21hcDN4eHhfZHNzX3ZlbmNfaHdtb2QsCisKKwkvKiBpMmMg
Y2xhc3MgKi8KKwkmb21hcDN4eHhfaTJjMV9od21vZCwKKwkmb21hcDN4eHhfaTJjMl9od21vZCwK
Kwkmb21hcDN4eHhfaTJjM19od21vZCwKKworCS8qIGdwaW8gY2xhc3MgKi8KKwkmb21hcDN4eHhf
Z3BpbzFfaHdtb2QsCisJJm9tYXAzeHh4X2dwaW8yX2h3bW9kLAorCSZvbWFwM3h4eF9ncGlvM19o
d21vZCwKKwkmb21hcDN4eHhfZ3BpbzRfaHdtb2QsCisJJm9tYXAzeHh4X2dwaW81X2h3bW9kLAor
CSZvbWFwM3h4eF9ncGlvNl9od21vZCwKKworCS8qIGRtYV9zeXN0ZW0gY2xhc3MqLworCSZvbWFw
M3h4eF9kbWFfc3lzdGVtX2h3bW9kLAorCisJLyogbWNic3AgY2xhc3MgKi8KKwkmb21hcDN4eHhf
bWNic3AxX2h3bW9kLAorCSZvbWFwM3h4eF9tY2JzcDJfaHdtb2QsCisJJm9tYXAzeHh4X21jYnNw
M19od21vZCwKKwkmb21hcDN4eHhfbWNic3A0X2h3bW9kLAorCSZvbWFwM3h4eF9tY2JzcDVfaHdt
b2QsCisJJm9tYXAzeHh4X21jYnNwMl9zaWRldG9uZV9od21vZCwKKwkmb21hcDN4eHhfbWNic3Az
X3NpZGV0b25lX2h3bW9kLAorCisJLyogbWFpbGJveCBjbGFzcyAqLworCSZvbWFwM3h4eF9tYWls
Ym94X2h3bW9kLAorCisJLyogbWNzcGkgY2xhc3MgKi8KKwkmb21hcDM0eHhfbWNzcGkxLAorCSZv
bWFwMzR4eF9tY3NwaTIsCisJJm9tYXAzNHh4X21jc3BpMywKKwkmb21hcDM0eHhfbWNzcGk0LAor
CisJLyogdXNib3RnIGNsYXNzICovCisJJm9tYXAzeHh4X3VzYmhzb3RnX2h3bW9kLAorCisJLyog
dXNib3RnIGZvciBhbTM1eCAqLworCSZhbTM1eHhfdXNiaHNvdGdfaHdtb2QsCisKKwlOVUxMLAor
fTsKKwogaW50IF9faW5pdCBvbWFwM3h4eF9od21vZF9pbml0KHZvaWQpCiB7Ci0JcmV0dXJuIG9t
YXBfaHdtb2RfcmVnaXN0ZXIob21hcDN4eHhfaHdtb2RzKTsKKyAJaWYgKGNwdV9pc19vbWFwMzUw
NSgpIHx8IGNwdV9pc19vbWFwMzUxNygpKSB7CisKKyAJCS8qIFRPRE86IEZpbmQgYmV0dGVyIHdh
eSB0byBnZXQgdGhpcyBkb25lLgorIAkJICoKKyAJCSAqIEFNMzV4eCBkb2Vzbid0IHN1cHBvcnQg
c21hcnRyZWZsZXguIFRoaXMgcmVxdWlyZXM6CisgCQkgKiAxKSBSZW1vdmluZyByZWxhdGVkIGh3
bW9kcyBmcm9tIHRoZSBpbml0aWFsaXphdGlvbiBsaXN0LgorIAkJICogICAgKGRvbmUpLgorIAkJ
ICogMikgUmVtb3Zpbmcgb21hcDNfbDRfY29yZV9fc3IxIGFuZCBvbWFwM19sNF9jb3JlX19zcjIK
KyAJCSAqICAgIGZyb20gb21hcDN4eHhfbDRfY29yZV9zbGF2ZXMuCisgCQkgKiAgICBUaGlzLCBo
b3dldmVyLCBoYXMgY2FzY2FkaW5nIGVmZmVjdCBvbiBhbGwgaHdtb2RzLAorCQkgKiAgICBkdWUg
dG8gbWFzdGVyLXNsYXZlIHJlbGF0aW9ucyBiZXR3ZWVuIHRoZXNlIGh3bW9kcy4KKyAJCSAqCisg
CQkgKiBJbnN0ZWFkIG9mIGR1cGxpY2F0aW5nIGNvbnRlbnRzIG9mIHRoaXMgZmlsZSwgdXBkYXRp
bmcKKyAJCSAqIHRoZSBzdHJ1Y3R1cmUgdG8gcmVzdHJpY3Qgc2xhdmUgY291bnQgdG8gMTsgYW5k
IHNldHRpbmcKKyAJCSAqIGFkZHJlc3Mgb2Ygb21hcDNfbDRfY29yZV9fc3IxICYgb21hcDNfbDRf
Y29yZV9fc3IyIHRvCisJIAkgKiBOVUxMIHNob3VsZCBiZSBhIHJlYXNvbmFibGUgd29ya2Fyb3Vu
ZC4KKwkJICovCisgCQlvbWFwM3h4eF9sNF9jb3JlX3NsYXZlc1sxXSA9IE5VTEw7CisgCQlvbWFw
M19zcjFfc2xhdmVzWzFdID0gTlVMTDsKKworIAkJb21hcDN4eHhfbDRfY29yZV9od21vZC5zbGF2
ZXNfY250ID0gMTsKKworCQlyZXR1cm4gb21hcF9od21vZF9yZWdpc3RlcihhbTM1eHhfaHdtb2Rz
KTsKKyAJfSBlbHNlIHsKKyAJCXJldHVybiBvbWFwX2h3bW9kX3JlZ2lzdGVyKG9tYXAzeHh4X2h3
bW9kcyk7CisgCX0KIH0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21hY2gtb21hcDIvb21hcF90d2wu
YyBiL2FyY2gvYXJtL21hY2gtb21hcDIvb21hcF90d2wuYwppbmRleCAwN2Q2MTQwLi5mZThlODUx
IDEwMDY0NAotLS0gYS9hcmNoL2FybS9tYWNoLW9tYXAyL29tYXBfdHdsLmMKKysrIGIvYXJjaC9h
cm0vbWFjaC1vbWFwMi9vbWFwX3R3bC5jCkBAIC0yNjksNiArMjY5LDEzIEBAIGludCBfX2luaXQg
b21hcDNfdHdsX2luaXQodm9pZCkKIAlpZiAoIWNwdV9pc19vbWFwMzR4eCgpKQogCQlyZXR1cm4g
LUVOT0RFVjsKIAorCS8qCisJICogSW4gY2FzZSBvZiBBTTM1MTcvQU0zNTA1IHdlIHNob3VsZCBu
b3QgYmUgZ29pbmcgZG93bgorCSAqIGZ1cnRoZXIsIHNpbmNlIFNSIGlzIG5vdCBhcHBsaWNhYmxl
IHRoZXJlLgorCSAqLworCWlmIChjcHVfaXNfb21hcDM1MDUoKSB8fCBjcHVfaXNfb21hcDM1MTco
KSkKKwkJcmV0dXJuIC1FTk9ERVY7CisKIAlpZiAoY3B1X2lzX29tYXAzNjMwKCkpIHsKIAkJb21h
cDNfbXB1X3ZvbHRfaW5mby52cF92ZGRtaW4gPSBPTUFQMzYzMF9WUDFfVkxJTUlUVE9fVkRETUlO
OwogCQlvbWFwM19tcHVfdm9sdF9pbmZvLnZwX3ZkZG1heCA9IE9NQVAzNjMwX1ZQMV9WTElNSVRU
T19WRERNQVg7Cg==

--_003_45EE9921DD12714AB1D7B7B9D2FE208B0230256D48BFdbde03entti_
Content-Type: application/octet-stream; name="am3517-rt.config"
Content-Description: am3517-rt.config
Content-Disposition: attachment; filename="am3517-rt.config"; size=62917;
	creation-date="Wed, 27 Jul 2011 23:28:01 GMT";
	modification-date="Wed, 27 Jul 2011 23:28:01 GMT"
Content-Transfer-Encoding: base64

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMgTGlu
dXgvYXJtIDMuMC4wIEtlcm5lbCBDb25maWd1cmF0aW9uCiMKQ09ORklHX0FSTT15CkNPTkZJR19T
WVNfU1VQUE9SVFNfQVBNX0VNVUxBVElPTj15CkNPTkZJR19IQVZFX1NDSEVEX0NMT0NLPXkKQ09O
RklHX0dFTkVSSUNfR1BJTz15CiMgQ09ORklHX0FSQ0hfVVNFU19HRVRUSU1FT0ZGU0VUIGlzIG5v
dCBzZXQKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFM9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VW
RU5UU19CUk9BRENBU1Q9eQpDT05GSUdfS1RJTUVfU0NBTEFSPXkKQ09ORklHX0hBVkVfUFJPQ19D
UFU9eQpDT05GSUdfU1RBQ0tUUkFDRV9TVVBQT1JUPXkKQ09ORklHX0xPQ0tERVBfU1VQUE9SVD15
CkNPTkZJR19UUkFDRV9JUlFGTEFHU19TVVBQT1JUPXkKQ09ORklHX0hBUkRJUlFTX1NXX1JFU0VO
RD15CkNPTkZJR19HRU5FUklDX0lSUV9QUk9CRT15CkNPTkZJR19HRU5FUklDX0xPQ0tCUkVBSz15
CkNPTkZJR19SV1NFTV9HRU5FUklDX1NQSU5MT0NLPXkKQ09ORklHX0FSQ0hfSEFTX0NQVUZSRVE9
eQpDT05GSUdfQVJDSF9IQVNfQ1BVX0lETEVfV0FJVD15CkNPTkZJR19HRU5FUklDX0hXRUlHSFQ9
eQpDT05GSUdfR0VORVJJQ19DQUxJQlJBVEVfREVMQVk9eQpDT05GSUdfTkVFRF9ETUFfTUFQX1NU
QVRFPXkKQ09ORklHX1ZFQ1RPUlNfQkFTRT0weGZmZmYwMDAwCiMgQ09ORklHX0FSTV9QQVRDSF9Q
SFlTX1ZJUlQgaXMgbm90IHNldApDT05GSUdfREVGQ09ORklHX0xJU1Q9Ii9saWIvbW9kdWxlcy8k
VU5BTUVfUkVMRUFTRS8uY29uZmlnIgpDT05GSUdfSEFWRV9JUlFfV09SSz15CkNPTkZJR19JUlFf
V09SSz15CgojCiMgR2VuZXJhbCBzZXR1cAojCkNPTkZJR19FWFBFUklNRU5UQUw9eQpDT05GSUdf
SU5JVF9FTlZfQVJHX0xJTUlUPTMyCkNPTkZJR19DUk9TU19DT01QSUxFPSIiCkNPTkZJR19MT0NB
TFZFUlNJT049IiIKQ09ORklHX0xPQ0FMVkVSU0lPTl9BVVRPPXkKQ09ORklHX0hBVkVfS0VSTkVM
X0daSVA9eQpDT05GSUdfSEFWRV9LRVJORUxfTFpNQT15CkNPTkZJR19IQVZFX0tFUk5FTF9MWk89
eQpDT05GSUdfS0VSTkVMX0daSVA9eQojIENPTkZJR19LRVJORUxfTFpNQSBpcyBub3Qgc2V0CiMg
Q09ORklHX0tFUk5FTF9MWk8gaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9IT1NUTkFNRT0iKG5v
bmUpIgpDT05GSUdfU1dBUD15CkNPTkZJR19TWVNWSVBDPXkKQ09ORklHX1NZU1ZJUENfU1lTQ1RM
PXkKQ09ORklHX1BPU0lYX01RVUVVRT15CkNPTkZJR19QT1NJWF9NUVVFVUVfU1lTQ1RMPXkKQ09O
RklHX0JTRF9QUk9DRVNTX0FDQ1Q9eQojIENPTkZJR19CU0RfUFJPQ0VTU19BQ0NUX1YzIGlzIG5v
dCBzZXQKIyBDT05GSUdfRkhBTkRMRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RBU0tTVEFUUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FVRElUIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfR0VORVJJQ19IQVJE
SVJRUz15CgojCiMgSVJRIHN1YnN5c3RlbQojCkNPTkZJR19HRU5FUklDX0hBUkRJUlFTPXkKQ09O
RklHX0hBVkVfU1BBUlNFX0lSUT15CkNPTkZJR19HRU5FUklDX0lSUV9TSE9XPXkKQ09ORklHX0dF
TkVSSUNfSVJRX0NISVA9eQpDT05GSUdfSVJRX0ZPUkNFRF9USFJFQURJTkc9eQojIENPTkZJR19T
UEFSU0VfSVJRIGlzIG5vdCBzZXQKCiMKIyBSQ1UgU3Vic3lzdGVtCiMKQ09ORklHX1RSRUVfUFJF
RU1QVF9SQ1U9eQpDT05GSUdfUFJFRU1QVF9SQ1U9eQojIENPTkZJR19SQ1VfVFJBQ0UgaXMgbm90
IHNldApDT05GSUdfUkNVX0ZBTk9VVD0zMgojIENPTkZJR19SQ1VfRkFOT1VUX0VYQUNUIGlzIG5v
dCBzZXQKIyBDT05GSUdfVFJFRV9SQ1VfVFJBQ0UgaXMgbm90IHNldApDT05GSUdfUkNVX0JPT1NU
PXkKQ09ORklHX1JDVV9CT09TVF9QUklPPTEKQ09ORklHX1JDVV9CT09TVF9ERUxBWT01MDAKQ09O
RklHX0lLQ09ORklHPXkKQ09ORklHX0lLQ09ORklHX1BST0M9eQpDT05GSUdfTE9HX0JVRl9TSElG
VD0xNgojIENPTkZJR19DR1JPVVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfTkFNRVNQQUNFUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDSEVEX0FVVE9HUk9VUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NZU0ZT
X0RFUFJFQ0FURUQgaXMgbm90IHNldAojIENPTkZJR19SRUxBWSBpcyBub3Qgc2V0CkNPTkZJR19C
TEtfREVWX0lOSVRSRD15CkNPTkZJR19JTklUUkFNRlNfU09VUkNFPSIiCkNPTkZJR19SRF9HWklQ
PXkKIyBDT05GSUdfUkRfQlpJUDIgaXMgbm90IHNldAojIENPTkZJR19SRF9MWk1BIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUkRfWFogaXMgbm90IHNldAojIENPTkZJR19SRF9MWk8gaXMgbm90IHNldAoj
IENPTkZJR19DQ19PUFRJTUlaRV9GT1JfU0laRSBpcyBub3Qgc2V0CkNPTkZJR19TWVNDVEw9eQpD
T05GSUdfQU5PTl9JTk9ERVM9eQpDT05GSUdfRVhQRVJUPXkKQ09ORklHX1VJRDE2PXkKIyBDT05G
SUdfU1lTQ1RMX1NZU0NBTEwgaXMgbm90IHNldApDT05GSUdfS0FMTFNZTVM9eQpDT05GSUdfS0FM
TFNZTVNfQUxMPXkKQ09ORklHX0hPVFBMVUc9eQpDT05GSUdfUFJJTlRLPXkKQ09ORklHX0JVRz15
CkNPTkZJR19FTEZfQ09SRT15CkNPTkZJR19CQVNFX0ZVTEw9eQpDT05GSUdfRlVURVg9eQpDT05G
SUdfRVBPTEw9eQpDT05GSUdfU0lHTkFMRkQ9eQpDT05GSUdfVElNRVJGRD15CkNPTkZJR19FVkVO
VEZEPXkKQ09ORklHX1NITUVNPXkKQ09ORklHX0FJTz15CiMgQ09ORklHX0VNQkVEREVEIGlzIG5v
dCBzZXQKQ09ORklHX0hBVkVfUEVSRl9FVkVOVFM9eQpDT05GSUdfUEVSRl9VU0VfVk1BTExPQz15
CgojCiMgS2VybmVsIFBlcmZvcm1hbmNlIEV2ZW50cyBBbmQgQ291bnRlcnMKIwpDT05GSUdfUEVS
Rl9FVkVOVFM9eQojIENPTkZJR19QRVJGX0NPVU5URVJTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVC
VUdfUEVSRl9VU0VfVk1BTExPQyBpcyBub3Qgc2V0CkNPTkZJR19WTV9FVkVOVF9DT1VOVEVSUz15
CkNPTkZJR19DT01QQVRfQlJLPXkKQ09ORklHX1NMQUI9eQpDT05GSUdfUFJPRklMSU5HPXkKQ09O
RklHX1RSQUNFUE9JTlRTPXkKQ09ORklHX09QUk9GSUxFPXkKQ09ORklHX0hBVkVfT1BST0ZJTEU9
eQpDT05GSUdfS1BST0JFUz15CkNPTkZJR19LUkVUUFJPQkVTPXkKQ09ORklHX0hBVkVfS1BST0JF
Uz15CkNPTkZJR19IQVZFX0tSRVRQUk9CRVM9eQpDT05GSUdfVVNFX0dFTkVSSUNfU01QX0hFTFBF
UlM9eQpDT05GSUdfSEFWRV9SRUdTX0FORF9TVEFDS19BQ0NFU1NfQVBJPXkKQ09ORklHX0hBVkVf
Q0xLPXkKQ09ORklHX0hBVkVfRE1BX0FQSV9ERUJVRz15CkNPTkZJR19IQVZFX0hXX0JSRUFLUE9J
TlQ9eQoKIwojIEdDT1YtYmFzZWQga2VybmVsIHByb2ZpbGluZwojCiMgQ09ORklHX0dDT1ZfS0VS
TkVMIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfR0VORVJJQ19ETUFfQ09IRVJFTlQ9eQpDT05GSUdf
U0xBQklORk89eQpDT05GSUdfUlRfTVVURVhFUz15CkNPTkZJR19CQVNFX1NNQUxMPTAKQ09ORklH
X01PRFVMRVM9eQpDT05GSUdfTU9EVUxFX0ZPUkNFX0xPQUQ9eQpDT05GSUdfTU9EVUxFX1VOTE9B
RD15CkNPTkZJR19NT0RVTEVfRk9SQ0VfVU5MT0FEPXkKQ09ORklHX01PRFZFUlNJT05TPXkKQ09O
RklHX01PRFVMRV9TUkNWRVJTSU9OX0FMTD15CkNPTkZJR19TVE9QX01BQ0hJTkU9eQpDT05GSUdf
QkxPQ0s9eQpDT05GSUdfTEJEQUY9eQojIENPTkZJR19CTEtfREVWX0JTRyBpcyBub3Qgc2V0CiMg
Q09ORklHX0JMS19ERVZfSU5URUdSSVRZIGlzIG5vdCBzZXQKCiMKIyBJTyBTY2hlZHVsZXJzCiMK
Q09ORklHX0lPU0NIRURfTk9PUD15CkNPTkZJR19JT1NDSEVEX0RFQURMSU5FPXkKQ09ORklHX0lP
U0NIRURfQ0ZRPXkKIyBDT05GSUdfREVGQVVMVF9ERUFETElORSBpcyBub3Qgc2V0CkNPTkZJR19E
RUZBVUxUX0NGUT15CiMgQ09ORklHX0RFRkFVTFRfTk9PUCBpcyBub3Qgc2V0CkNPTkZJR19ERUZB
VUxUX0lPU0NIRUQ9ImNmcSIKIyBDT05GSUdfSU5MSU5FX1NQSU5fVFJZTE9DSyBpcyBub3Qgc2V0
CiMgQ09ORklHX0lOTElORV9TUElOX1RSWUxPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJ
TkVfU1BJTl9MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fTE9DS19CSCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX0xPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5MSU5FX1NQSU5fTE9DS19JUlFTQVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5f
VU5MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fVU5MT0NLX0JIIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fVU5MT0NLX0lSUSBpcyBub3Qgc2V0CiMgQ09ORklHX0lO
TElORV9TUElOX1VOTE9DS19JUlFSRVNUT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JF
QURfVFJZTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFEX0xPQ0sgaXMgbm90IHNl
dAojIENPTkZJR19JTkxJTkVfUkVBRF9MT0NLX0JIIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5F
X1JFQURfTE9DS19JUlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9MT0NLX0lSUVNB
VkUgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9VTkxPQ0sgaXMgbm90IHNldAojIENP
TkZJR19JTkxJTkVfUkVBRF9VTkxPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVB
RF9VTkxPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfVU5MT0NLX0lSUVJF
U1RPUkUgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfVFJZTE9DSyBpcyBub3Qgc2V0
CiMgQ09ORklHX0lOTElORV9XUklURV9MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1dS
SVRFX0xPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfTE9DS19JUlEgaXMg
bm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfTE9DS19JUlFTQVZFIGlzIG5vdCBzZXQKIyBD
T05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklU
RV9VTkxPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfVU5MT0NLX0lSUSBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9VTkxPQ0tfSVJRUkVTVE9SRSBpcyBub3Qg
c2V0CiMgQ09ORklHX01VVEVYX1NQSU5fT05fT1dORVIgaXMgbm90IHNldApDT05GSUdfRlJFRVpF
Uj15CgojCiMgU3lzdGVtIFR5cGUKIwpDT05GSUdfTU1VPXkKIyBDT05GSUdfQVJDSF9JTlRFR1JB
VE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9SRUFMVklFVyBpcyBub3Qgc2V0CiMgQ09ORklH
X0FSQ0hfVkVSU0FUSUxFIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9WRVhQUkVTUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0FSQ0hfQVQ5MSBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfQkNNUklORyBp
cyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfQ0xQUzcxMVggaXMgbm90IHNldAojIENPTkZJR19BUkNI
X0NOUzNYWFggaXMgbm90IHNldAojIENPTkZJR19BUkNIX0dFTUlOSSBpcyBub3Qgc2V0CiMgQ09O
RklHX0FSQ0hfRUJTQTExMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfRVA5M1hYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVJDSF9GT09UQlJJREdFIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9NWEMg
aXMgbm90IHNldAojIENPTkZJR19BUkNIX01YUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfTkVU
WCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfSDcyMFggaXMgbm90IHNldAojIENPTkZJR19BUkNI
X0lPUDEzWFggaXMgbm90IHNldAojIENPTkZJR19BUkNIX0lPUDMyWCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FSQ0hfSU9QMzNYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9JWFAyM1hYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQVJDSF9JWFAyMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9JWFA0WFgg
aXMgbm90IHNldAojIENPTkZJR19BUkNIX0RPVkUgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0tJ
UktXT09EIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9MT0tJIGlzIG5vdCBzZXQKIyBDT05GSUdf
QVJDSF9MUEMzMlhYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9NVjc4WFgwIGlzIG5vdCBzZXQK
IyBDT05GSUdfQVJDSF9PUklPTjVYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9NTVAgaXMgbm90
IHNldAojIENPTkZJR19BUkNIX0tTODY5NSBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfVzkwWDkw
MCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfTlVDOTNYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJD
SF9URUdSQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUE5YNDAwOCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FSQ0hfUFhBIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9NU00gaXMgbm90IHNldAojIENP
TkZJR19BUkNIX1NITU9CSUxFIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9SUEMgaXMgbm90IHNl
dAojIENPTkZJR19BUkNIX1NBMTEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUzNDMjQxMCBp
cyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUzNDNjRYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hf
UzVQNjRYMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUzVQQzEwMCBpcyBub3Qgc2V0CiMgQ09O
RklHX0FSQ0hfUzVQVjIxMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfRVhZTk9TNCBpcyBub3Qg
c2V0CiMgQ09ORklHX0FSQ0hfU0hBUksgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1RDQ185MjYg
aXMgbm90IHNldAojIENPTkZJR19BUkNIX1UzMDAgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1U4
NTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9OT01BRElLIGlzIG5vdCBzZXQKIyBDT05GSUdf
QVJDSF9EQVZJTkNJIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfT01BUD15CiMgQ09ORklHX1BMQVRf
U1BFQVIgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1ZUODUwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X0dQSU9fUENBOTUzWCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0dQSU9fUE9MTEVEIGlz
IG5vdCBzZXQKCiMKIyBUSSBPTUFQIENvbW1vbiBGZWF0dXJlcwojCkNPTkZJR19BUkNIX09NQVBf
T1RHPXkKIyBDT05GSUdfQVJDSF9PTUFQMSBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX09NQVAyUExV
Uz15CgojCiMgT01BUCBGZWF0dXJlIFNlbGVjdGlvbnMKIwpDT05GSUdfT01BUF9ERUJVR19ERVZJ
Q0VTPXkKIyBDT05GSUdfT01BUF9TTUFSVFJFRkxFWCBpcyBub3Qgc2V0CkNPTkZJR19PTUFQX1JF
U0VUX0NMT0NLUz15CkNPTkZJR19PTUFQX01VWD15CkNPTkZJR19PTUFQX01VWF9ERUJVRz15CkNP
TkZJR19PTUFQX01VWF9XQVJOSU5HUz15CkNPTkZJR19PTUFQX01DQlNQPXkKIyBDT05GSUdfT01B
UF9NQk9YX0ZXSyBpcyBub3Qgc2V0CkNPTkZJR19PTUFQXzMyS19USU1FUj15CiMgQ09ORklHX09N
QVAzX0wyX0FVWF9TRUNVUkVfU0FWRV9SRVNUT1JFIGlzIG5vdCBzZXQKQ09ORklHX09NQVBfMzJL
X1RJTUVSX0haPTEyOApDT05GSUdfT01BUF9ETV9USU1FUj15CiMgQ09ORklHX09NQVBfUE1fTk9O
RSBpcyBub3Qgc2V0CkNPTkZJR19PTUFQX1BNX05PT1A9eQpDT05GSUdfTUFDSF9PTUFQX0dFTkVS
SUM9eQoKIwojIFRJIE9NQVAyLzMvNCBTcGVjaWZpYyBGZWF0dXJlcwojCkNPTkZJR19BUkNIX09N
QVAyUExVU19UWVBJQ0FMPXkKQ09ORklHX0FSQ0hfT01BUDI9eQpDT05GSUdfQVJDSF9PTUFQMz15
CkNPTkZJR19BUkNIX09NQVA0PXkKCiMKIyBPTUFQIENvcmUgVHlwZQojCkNPTkZJR19TT0NfT01B
UDI0MjA9eQpDT05GSUdfU09DX09NQVAyNDMwPXkKQ09ORklHX1NPQ19PTUFQMzQzMD15CkNPTkZJ
R19TT0NfT01BUFRJODE2WD15CkNPTkZJR19PTUFQX1BBQ0tBR0VfWkFGPXkKQ09ORklHX09NQVBf
UEFDS0FHRV9aQUM9eQpDT05GSUdfT01BUF9QQUNLQUdFX0NCQj15CkNPTkZJR19PTUFQX1BBQ0tB
R0VfQ1VTPXkKQ09ORklHX09NQVBfUEFDS0FHRV9DQlA9eQpDT05GSUdfT01BUF9QQUNLQUdFX0NC
TD15CkNPTkZJR19PTUFQX1BBQ0tBR0VfQ0JTPXkKCiMKIyBPTUFQIEJvYXJkIFR5cGUKIwpDT05G
SUdfTUFDSF9PTUFQMl9UVVNCNjAxMD15CkNPTkZJR19NQUNIX09NQVBfSDQ9eQpDT05GSUdfTUFD
SF9PTUFQX0FQT0xMT049eQpDT05GSUdfTUFDSF9PTUFQXzI0MzBTRFA9eQpDT05GSUdfTUFDSF9P
TUFQM19CRUFHTEU9eQpDT05GSUdfTUFDSF9ERVZLSVQ4MDAwPXkKQ09ORklHX01BQ0hfT01BUF9M
RFA9eQpDT05GSUdfTUFDSF9PTUFQMzUzMF9MVl9TT009eQpDT05GSUdfTUFDSF9PTUFQM19UT1JQ
RURPPXkKQ09ORklHX01BQ0hfT1ZFUk89eQpDT05GSUdfTUFDSF9PTUFQM0VWTT15CkNPTkZJR19N
QUNIX09NQVAzNTE3RVZNPXkKIyBDT05GSUdfTUFDSF9DUkFORUJPQVJEIGlzIG5vdCBzZXQKQ09O
RklHX01BQ0hfT01BUDNfUEFORE9SQT15CkNPTkZJR19NQUNIX09NQVAzX1RPVUNIQk9PSz15CkNP
TkZJR19NQUNIX09NQVBfMzQzMFNEUD15CkNPTkZJR19NQUNIX05PS0lBX044MDA9eQpDT05GSUdf
TUFDSF9OT0tJQV9OODEwPXkKQ09ORklHX01BQ0hfTk9LSUFfTjgxMF9XSU1BWD15CkNPTkZJR19N
QUNIX05PS0lBX044WDA9eQpDT05GSUdfTUFDSF9OT0tJQV9STTY4MD15CkNPTkZJR19NQUNIX05P
S0lBX1JYNTE9eQpDT05GSUdfTUFDSF9PTUFQX1pPT00yPXkKQ09ORklHX01BQ0hfT01BUF9aT09N
Mz15CkNPTkZJR19NQUNIX0NNX1QzNT15CkNPTkZJR19NQUNIX0NNX1QzNTE3PXkKQ09ORklHX01B
Q0hfSUdFUDAwMjA9eQpDT05GSUdfTUFDSF9JR0VQMDAzMD15CkNPTkZJR19NQUNIX1NCQzM1MzA9
eQpDT05GSUdfTUFDSF9PTUFQXzM2MzBTRFA9eQpDT05GSUdfTUFDSF9USTgxNjhFVk09eQpDT05G
SUdfTUFDSF9PTUFQXzQ0MzBTRFA9eQpDT05GSUdfTUFDSF9PTUFQNF9QQU5EQT15CiMgQ09ORklH
X09NQVAzX0VNVSBpcyBub3Qgc2V0CiMgQ09ORklHX09NQVAzX1NEUkNfQUNfVElNSU5HIGlzIG5v
dCBzZXQKCiMKIyBTeXN0ZW0gTU1VCiMKCiMKIyBQcm9jZXNzb3IgVHlwZQojCkNPTkZJR19DUFVf
VjY9eQpDT05GSUdfQ1BVX1Y3PXkKQ09ORklHX0NQVV8zMnY2PXkKQ09ORklHX0NQVV8zMnY2Sz15
CkNPTkZJR19DUFVfMzJ2Nz15CkNPTkZJR19DUFVfQUJSVF9FVjY9eQpDT05GSUdfQ1BVX0FCUlRf
RVY3PXkKQ09ORklHX0NQVV9QQUJSVF9WNj15CkNPTkZJR19DUFVfUEFCUlRfVjc9eQpDT05GSUdf
Q1BVX0NBQ0hFX1Y2PXkKQ09ORklHX0NQVV9DQUNIRV9WNz15CkNPTkZJR19DUFVfQ0FDSEVfVklQ
VD15CkNPTkZJR19DUFVfQ09QWV9WNj15CkNPTkZJR19DUFVfVExCX1Y2PXkKQ09ORklHX0NQVV9U
TEJfVjc9eQpDT05GSUdfQ1BVX0hBU19BU0lEPXkKQ09ORklHX0NQVV9DUDE1PXkKQ09ORklHX0NQ
VV9DUDE1X01NVT15CkNPTkZJR19DUFVfVVNFX0RPTUFJTlM9eQoKIwojIFByb2Nlc3NvciBGZWF0
dXJlcwojCkNPTkZJR19BUk1fVEhVTUI9eQpDT05GSUdfQVJNX1RIVU1CRUU9eQojIENPTkZJR19D
UFVfSUNBQ0hFX0RJU0FCTEUgaXMgbm90IHNldAojIENPTkZJR19DUFVfRENBQ0hFX0RJU0FCTEUg
aXMgbm90IHNldAojIENPTkZJR19DUFVfQlBSRURJQ1RfRElTQUJMRSBpcyBub3Qgc2V0CkNPTkZJ
R19PVVRFUl9DQUNIRT15CkNPTkZJR19PVVRFUl9DQUNIRV9TWU5DPXkKQ09ORklHX0NBQ0hFX0wy
WDA9eQpDT05GSUdfQVJNX0wxX0NBQ0hFX1NISUZUPTUKQ09ORklHX0FSTV9ETUFfTUVNX0JVRkZF
UkFCTEU9eQpDT05GSUdfQVJNX0VSUkFUQV80MTE5MjA9eQojIENPTkZJR19BUk1fRVJSQVRBXzQz
MDk3MyBpcyBub3Qgc2V0CiMgQ09ORklHX0FSTV9FUlJBVEFfNDU4NjkzIGlzIG5vdCBzZXQKIyBD
T05GSUdfQVJNX0VSUkFUQV80NjAwNzUgaXMgbm90IHNldAojIENPTkZJR19BUk1fRVJSQVRBXzc0
MjIzMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSTV9FUlJBVEFfNzQyMjMxIGlzIG5vdCBzZXQKQ09O
RklHX1BMMzEwX0VSUkFUQV81ODgzNjk9eQpDT05GSUdfQVJNX0VSUkFUQV83MjA3ODk9eQpDT05G
SUdfUEwzMTBfRVJSQVRBXzcyNzkxNT15CiMgQ09ORklHX0FSTV9FUlJBVEFfNzQzNjIyIGlzIG5v
dCBzZXQKIyBDT05GSUdfQVJNX0VSUkFUQV83NTE0NzIgaXMgbm90IHNldAojIENPTkZJR19BUk1f
RVJSQVRBXzc1NDMyMiBpcyBub3Qgc2V0CiMgQ09ORklHX0FSTV9FUlJBVEFfNzU0MzI3IGlzIG5v
dCBzZXQKQ09ORklHX0FSTV9HSUM9eQoKIwojIEJ1cyBzdXBwb3J0CiMKIyBDT05GSUdfUENJX1NZ
U0NBTEwgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1NVUFBPUlRTX01TSSBpcyBub3Qgc2V0CiMg
Q09ORklHX1BDQ0FSRCBpcyBub3Qgc2V0CgojCiMgS2VybmVsIEZlYXR1cmVzCiMKQ09ORklHX1RJ
Q0tfT05FU0hPVD15CkNPTkZJR19OT19IWj15CkNPTkZJR19ISUdIX1JFU19USU1FUlM9eQpDT05G
SUdfR0VORVJJQ19DTE9DS0VWRU5UU19CVUlMRD15CkNPTkZJR19TTVA9eQpDT05GSUdfU01QX09O
X1VQPXkKQ09ORklHX0hBVkVfQVJNX1NDVT15CkNPTkZJR19IQVZFX0FSTV9UV0Q9eQpDT05GSUdf
Vk1TUExJVF8zRz15CiMgQ09ORklHX1ZNU1BMSVRfMkcgaXMgbm90IHNldAojIENPTkZJR19WTVNQ
TElUXzFHIGlzIG5vdCBzZXQKQ09ORklHX1BBR0VfT0ZGU0VUPTB4QzAwMDAwMDAKQ09ORklHX05S
X0NQVVM9MgpDT05GSUdfSE9UUExVR19DUFU9eQpDT05GSUdfTE9DQUxfVElNRVJTPXkKQ09ORklH
X1BSRUVNUFQ9eQpDT05GSUdfUFJFRU1QVF9SVF9CQVNFPXkKIyBDT05GSUdfUFJFRU1QVF9OT05F
IGlzIG5vdCBzZXQKIyBDT05GSUdfUFJFRU1QVF9WT0xVTlRBUlkgaXMgbm90IHNldAojIENPTkZJ
R19QUkVFTVBUX0xMIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJFRU1QVF9SVEIgaXMgbm90IHNldApD
T05GSUdfUFJFRU1QVF9SVF9GVUxMPXkKQ09ORklHX0haPTEyOApDT05GSUdfQUVBQkk9eQpDT05G
SUdfT0FCSV9DT01QQVQ9eQpDT05GSUdfQVJDSF9IQVNfSE9MRVNfTUVNT1JZTU9ERUw9eQojIENP
TkZJR19BUkNIX1NQQVJTRU1FTV9ERUZBVUxUIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9TRUxF
Q1RfTUVNT1JZX01PREVMIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJDSF9QRk5fVkFMSUQ9eQpD
T05GSUdfU0VMRUNUX01FTU9SWV9NT0RFTD15CkNPTkZJR19GTEFUTUVNX01BTlVBTD15CkNPTkZJ
R19GTEFUTUVNPXkKQ09ORklHX0ZMQVRfTk9ERV9NRU1fTUFQPXkKQ09ORklHX0hBVkVfTUVNQkxP
Q0s9eQpDT05GSUdfUEFHRUZMQUdTX0VYVEVOREVEPXkKQ09ORklHX1NQTElUX1BUTE9DS19DUFVT
PTk5OTk5OQojIENPTkZJR19DT01QQUNUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfUEhZU19BRERS
X1RfNjRCSVQgaXMgbm90IHNldApDT05GSUdfWk9ORV9ETUFfRkxBRz0wCkNPTkZJR19WSVJUX1RP
X0JVUz15CiMgQ09ORklHX0tTTSBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX01NQVBfTUlOX0FE
RFI9NDA5NgojIENPTkZJR19DTEVBTkNBQ0hFIGlzIG5vdCBzZXQKQ09ORklHX0ZPUkNFX01BWF9a
T05FT1JERVI9MTEKQ09ORklHX0xFRFM9eQpDT05GSUdfQUxJR05NRU5UX1RSQVA9eQojIENPTkZJ
R19VQUNDRVNTX1dJVEhfTUVNQ1BZIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VDQ09NUCBpcyBub3Qg
c2V0CiMgQ09ORklHX0NDX1NUQUNLUFJPVEVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfREVQUkVD
QVRFRF9QQVJBTV9TVFJVQ1QgaXMgbm90IHNldAoKIwojIEJvb3Qgb3B0aW9ucwojCiMgQ09ORklH
X1VTRV9PRiBpcyBub3Qgc2V0CkNPTkZJR19aQk9PVF9ST01fVEVYVD0weDAKQ09ORklHX1pCT09U
X1JPTV9CU1M9MHgwCkNPTkZJR19DTURMSU5FPSJyb290PS9kZXYvbW1jYmxrMHAyIHJvb3R3YWl0
IGNvbnNvbGU9dHR5TzIsMTE1MjAwIgpDT05GSUdfQ01ETElORV9GUk9NX0JPT1RMT0FERVI9eQoj
IENPTkZJR19DTURMSU5FX0VYVEVORCBpcyBub3Qgc2V0CiMgQ09ORklHX0NNRExJTkVfRk9SQ0Ug
aXMgbm90IHNldAojIENPTkZJR19YSVBfS0VSTkVMIGlzIG5vdCBzZXQKQ09ORklHX0tFWEVDPXkK
Q09ORklHX0FUQUdTX1BST0M9eQojIENPTkZJR19DUkFTSF9EVU1QIGlzIG5vdCBzZXQKIyBDT05G
SUdfQVVUT19aUkVMQUREUiBpcyBub3Qgc2V0CgojCiMgQ1BVIFBvd2VyIE1hbmFnZW1lbnQKIwoK
IwojIENQVSBGcmVxdWVuY3kgc2NhbGluZwojCiMgQ09ORklHX0NQVV9GUkVRIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ1BVX0lETEUgaXMgbm90IHNldAoKIwojIEZsb2F0aW5nIHBvaW50IGVtdWxhdGlv
bgojCgojCiMgQXQgbGVhc3Qgb25lIGVtdWxhdGlvbiBtdXN0IGJlIHNlbGVjdGVkCiMKQ09ORklH
X0ZQRV9OV0ZQRT15CiMgQ09ORklHX0ZQRV9OV0ZQRV9YUCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZQ
RV9GQVNURlBFIGlzIG5vdCBzZXQKQ09ORklHX1ZGUD15CkNPTkZJR19WRlB2Mz15CkNPTkZJR19O
RU9OPXkKCiMKIyBVc2Vyc3BhY2UgYmluYXJ5IGZvcm1hdHMKIwpDT05GSUdfQklORk1UX0VMRj15
CkNPTkZJR19DT1JFX0RVTVBfREVGQVVMVF9FTEZfSEVBREVSUz15CkNPTkZJR19IQVZFX0FPVVQ9
eQojIENPTkZJR19CSU5GTVRfQU9VVCBpcyBub3Qgc2V0CkNPTkZJR19CSU5GTVRfTUlTQz15Cgoj
CiMgUG93ZXIgbWFuYWdlbWVudCBvcHRpb25zCiMKQ09ORklHX1NVU1BFTkQ9eQpDT05GSUdfU1VT
UEVORF9GUkVFWkVSPXkKQ09ORklHX1BNX1NMRUVQPXkKQ09ORklHX1BNX1NMRUVQX1NNUD15CkNP
TkZJR19QTV9SVU5USU1FPXkKQ09ORklHX1BNPXkKQ09ORklHX1BNX0RFQlVHPXkKIyBDT05GSUdf
UE1fQURWQU5DRURfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19QTV9URVNUX1NVU1BFTkQgaXMg
bm90IHNldApDT05GSUdfQ0FOX1BNX1RSQUNFPXkKIyBDT05GSUdfQVBNX0VNVUxBVElPTiBpcyBu
b3Qgc2V0CkNPTkZJR19BUkNIX0hBU19PUFA9eQpDT05GSUdfUE1fT1BQPXkKQ09ORklHX1BNX1JV
TlRJTUVfQ0xLPXkKQ09ORklHX0FSQ0hfU1VTUEVORF9QT1NTSUJMRT15CkNPTkZJR19ORVQ9eQoK
IwojIE5ldHdvcmtpbmcgb3B0aW9ucwojCkNPTkZJR19QQUNLRVQ9eQpDT05GSUdfVU5JWD15CkNP
TkZJR19YRlJNPXkKQ09ORklHX1hGUk1fVVNFUj15CiMgQ09ORklHX1hGUk1fU1VCX1BPTElDWSBp
cyBub3Qgc2V0CkNPTkZJR19YRlJNX01JR1JBVEU9eQojIENPTkZJR19YRlJNX1NUQVRJU1RJQ1Mg
aXMgbm90IHNldApDT05GSUdfTkVUX0tFWT15CkNPTkZJR19ORVRfS0VZX01JR1JBVEU9eQpDT05G
SUdfSU5FVD15CkNPTkZJR19JUF9NVUxUSUNBU1Q9eQojIENPTkZJR19JUF9BRFZBTkNFRF9ST1VU
RVIgaXMgbm90IHNldApDT05GSUdfSVBfUE5QPXkKQ09ORklHX0lQX1BOUF9ESENQPXkKQ09ORklH
X0lQX1BOUF9CT09UUD15CkNPTkZJR19JUF9QTlBfUkFSUD15CiMgQ09ORklHX05FVF9JUElQIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkVUX0lQR1JFX0RFTVVYIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBf
TVJPVVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJQRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NZTl9D
T09LSUVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9BSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lO
RVRfRVNQIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9JUENPTVAgaXMgbm90IHNldAojIENPTkZJ
R19JTkVUX1hGUk1fVFVOTkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9UVU5ORUwgaXMgbm90
IHNldApDT05GSUdfSU5FVF9YRlJNX01PREVfVFJBTlNQT1JUPXkKQ09ORklHX0lORVRfWEZSTV9N
T0RFX1RVTk5FTD15CkNPTkZJR19JTkVUX1hGUk1fTU9ERV9CRUVUPXkKIyBDT05GSUdfSU5FVF9M
Uk8gaXMgbm90IHNldApDT05GSUdfSU5FVF9ESUFHPXkKQ09ORklHX0lORVRfVENQX0RJQUc9eQoj
IENPTkZJR19UQ1BfQ09OR19BRFZBTkNFRCBpcyBub3Qgc2V0CkNPTkZJR19UQ1BfQ09OR19DVUJJ
Qz15CkNPTkZJR19ERUZBVUxUX1RDUF9DT05HPSJjdWJpYyIKIyBDT05GSUdfVENQX01ENVNJRyBp
cyBub3Qgc2V0CiMgQ09ORklHX0lQVjYgaXMgbm90IHNldAojIENPTkZJR19ORVRMQUJFTCBpcyBu
b3Qgc2V0CiMgQ09ORklHX05FVFdPUktfU0VDTUFSSyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVFdP
UktfUEhZX1RJTUVTVEFNUElORyBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVI9eQojIENPTkZJ
R19ORVRGSUxURVJfREVCVUcgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX0FEVkFOQ0VEPXkK
CiMKIyBDb3JlIE5ldGZpbHRlciBDb25maWd1cmF0aW9uCiMKIyBDT05GSUdfTkVURklMVEVSX05F
VExJTktfUVVFVUUgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfTkVUTElOS19MT0cgaXMg
bm90IHNldAojIENPTkZJR19ORl9DT05OVFJBQ0sgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxU
RVJfWFRBQkxFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX1ZTIGlzIG5vdCBzZXQKCiMKIyBJUDog
TmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24KIwojIENPTkZJR19ORl9ERUZSQUdfSVBWNCBpcyBub3Qg
c2V0CiMgQ09ORklHX0lQX05GX1FVRVVFIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfTkZfSVBUQUJM
RVMgaXMgbm90IHNldAojIENPTkZJR19JUF9ORl9BUlBUQUJMRVMgaXMgbm90IHNldAojIENPTkZJ
R19JUF9EQ0NQIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfU0NUUCBpcyBub3Qgc2V0CiMgQ09ORklH
X1JEUyBpcyBub3Qgc2V0CiMgQ09ORklHX1RJUEMgaXMgbm90IHNldAojIENPTkZJR19BVE0gaXMg
bm90IHNldAojIENPTkZJR19MMlRQIGlzIG5vdCBzZXQKIyBDT05GSUdfQlJJREdFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkVUX0RTQSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZMQU5fODAyMVEgaXMgbm90
IHNldAojIENPTkZJR19ERUNORVQgaXMgbm90IHNldAojIENPTkZJR19MTEMyIGlzIG5vdCBzZXQK
IyBDT05GSUdfSVBYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBTEsgaXMgbm90IHNldAojIENPTkZJ
R19YMjUgaXMgbm90IHNldAojIENPTkZJR19MQVBCIGlzIG5vdCBzZXQKIyBDT05GSUdfRUNPTkVU
IGlzIG5vdCBzZXQKIyBDT05GSUdfV0FOX1JPVVRFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1BIT05F
VCBpcyBub3Qgc2V0CiMgQ09ORklHX0lFRUU4MDIxNTQgaXMgbm90IHNldAojIENPTkZJR19ORVRf
U0NIRUQgaXMgbm90IHNldAojIENPTkZJR19EQ0IgaXMgbm90IHNldApDT05GSUdfRE5TX1JFU09M
VkVSPXkKIyBDT05GSUdfQkFUTUFOX0FEViBpcyBub3Qgc2V0CkNPTkZJR19SUFM9eQpDT05GSUdf
UkZTX0FDQ0VMPXkKQ09ORklHX1hQUz15CgojCiMgTmV0d29yayB0ZXN0aW5nCiMKIyBDT05GSUdf
TkVUX1BLVEdFTiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9UQ1BQUk9CRSBpcyBub3Qgc2V0CiMg
Q09ORklHX05FVF9EUk9QX01PTklUT1IgaXMgbm90IHNldAojIENPTkZJR19IQU1SQURJTyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSREEgaXMgbm90IHNldApD
T05GSUdfQlQ9bQojIENPTkZJR19CVF9MMkNBUCBpcyBub3Qgc2V0CiMgQ09ORklHX0JUX1NDTyBp
cyBub3Qgc2V0CgojCiMgQmx1ZXRvb3RoIGRldmljZSBkcml2ZXJzCiMKIyBDT05GSUdfQlRfSENJ
QlRVU0IgaXMgbm90IHNldAojIENPTkZJR19CVF9IQ0lCVFNESU8gaXMgbm90IHNldApDT05GSUdf
QlRfSENJVUFSVD1tCkNPTkZJR19CVF9IQ0lVQVJUX0g0PXkKQ09ORklHX0JUX0hDSVVBUlRfQkNT
UD15CiMgQ09ORklHX0JUX0hDSVVBUlRfQVRIM0sgaXMgbm90IHNldApDT05GSUdfQlRfSENJVUFS
VF9MTD15CkNPTkZJR19CVF9IQ0lCQ00yMDNYPW0KQ09ORklHX0JUX0hDSUJQQTEwWD1tCiMgQ09O
RklHX0JUX0hDSUJGVVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfQlRfSENJVkhDSSBpcyBub3Qgc2V0
CiMgQ09ORklHX0JUX01SVkwgaXMgbm90IHNldAojIENPTkZJR19BRl9SWFJQQyBpcyBub3Qgc2V0
CkNPTkZJR19XSVJFTEVTUz15CkNPTkZJR19XSVJFTEVTU19FWFQ9eQpDT05GSUdfV0VYVF9DT1JF
PXkKQ09ORklHX1dFWFRfUFJPQz15CkNPTkZJR19XRVhUX1NQWT15CkNPTkZJR19DRkc4MDIxMT1t
CiMgQ09ORklHX05MODAyMTFfVEVTVE1PREUgaXMgbm90IHNldAojIENPTkZJR19DRkc4MDIxMV9E
RVZFTE9QRVJfV0FSTklOR1MgaXMgbm90IHNldAojIENPTkZJR19DRkc4MDIxMV9SRUdfREVCVUcg
aXMgbm90IHNldApDT05GSUdfQ0ZHODAyMTFfREVGQVVMVF9QUz15CiMgQ09ORklHX0NGRzgwMjEx
X0RFQlVHRlMgaXMgbm90IHNldAojIENPTkZJR19DRkc4MDIxMV9JTlRFUk5BTF9SRUdEQiBpcyBu
b3Qgc2V0CkNPTkZJR19DRkc4MDIxMV9XRVhUPXkKQ09ORklHX1dJUkVMRVNTX0VYVF9TWVNGUz15
CkNPTkZJR19MSUI4MDIxMT1tCiMgQ09ORklHX0xJQjgwMjExX0RFQlVHIGlzIG5vdCBzZXQKQ09O
RklHX01BQzgwMjExPW0KQ09ORklHX01BQzgwMjExX0hBU19SQz15CkNPTkZJR19NQUM4MDIxMV9S
Q19QSUQ9eQpDT05GSUdfTUFDODAyMTFfUkNfTUlOU1RSRUw9eQpDT05GSUdfTUFDODAyMTFfUkNf
TUlOU1RSRUxfSFQ9eQpDT05GSUdfTUFDODAyMTFfUkNfREVGQVVMVF9QSUQ9eQojIENPTkZJR19N
QUM4MDIxMV9SQ19ERUZBVUxUX01JTlNUUkVMIGlzIG5vdCBzZXQKQ09ORklHX01BQzgwMjExX1JD
X0RFRkFVTFQ9InBpZCIKIyBDT05GSUdfTUFDODAyMTFfTUVTSCBpcyBub3Qgc2V0CiMgQ09ORklH
X01BQzgwMjExX0RFQlVHRlMgaXMgbm90IHNldAojIENPTkZJR19NQUM4MDIxMV9ERUJVR19NRU5V
IGlzIG5vdCBzZXQKIyBDT05GSUdfV0lNQVggaXMgbm90IHNldAojIENPTkZJR19SRktJTEwgaXMg
bm90IHNldAojIENPTkZJR19SRktJTExfUkVHVUxBVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVU
XzlQIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FJRiBpcyBub3Qgc2V0CiMgQ09ORklHX0NFUEhfTElC
IGlzIG5vdCBzZXQKCiMKIyBEZXZpY2UgRHJpdmVycwojCgojCiMgR2VuZXJpYyBEcml2ZXIgT3B0
aW9ucwojCkNPTkZJR19VRVZFTlRfSEVMUEVSX1BBVEg9Ii9zYmluL2hvdHBsdWciCiMgQ09ORklH
X0RFVlRNUEZTIGlzIG5vdCBzZXQKQ09ORklHX1NUQU5EQUxPTkU9eQpDT05GSUdfUFJFVkVOVF9G
SVJNV0FSRV9CVUlMRD15CkNPTkZJR19GV19MT0FERVI9eQpDT05GSUdfRklSTVdBUkVfSU5fS0VS
TkVMPXkKQ09ORklHX0VYVFJBX0ZJUk1XQVJFPSIiCiMgQ09ORklHX0RFQlVHX0RSSVZFUiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RFQlVHX0RFVlJFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NZU19IWVBF
UlZJU09SIGlzIG5vdCBzZXQKQ09ORklHX0NPTk5FQ1RPUj15CkNPTkZJR19QUk9DX0VWRU5UUz15
CkNPTkZJR19NVEQ9eQojIENPTkZJR19NVERfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19NVERf
VEVTVFMgaXMgbm90IHNldAojIENPTkZJR19NVERfUkVEQk9PVF9QQVJUUyBpcyBub3Qgc2V0CkNP
TkZJR19NVERfQ01ETElORV9QQVJUUz15CiMgQ09ORklHX01URF9BRlNfUEFSVFMgaXMgbm90IHNl
dAojIENPTkZJR19NVERfQVI3X1BBUlRTIGlzIG5vdCBzZXQKCiMKIyBVc2VyIE1vZHVsZXMgQW5k
IFRyYW5zbGF0aW9uIExheWVycwojCkNPTkZJR19NVERfQ0hBUj15CkNPTkZJR19NVERfQkxLREVW
Uz15CkNPTkZJR19NVERfQkxPQ0s9eQojIENPTkZJR19GVEwgaXMgbm90IHNldAojIENPTkZJR19O
RlRMIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5GVEwgaXMgbm90IHNldAojIENPTkZJR19SRkRfRlRM
IGlzIG5vdCBzZXQKIyBDT05GSUdfU1NGREMgaXMgbm90IHNldAojIENPTkZJR19TTV9GVEwgaXMg
bm90IHNldApDT05GSUdfTVREX09PUFM9eQojIENPTkZJR19NVERfU1dBUCBpcyBub3Qgc2V0Cgoj
CiMgUkFNL1JPTS9GbGFzaCBjaGlwIGRyaXZlcnMKIwpDT05GSUdfTVREX0NGST15CiMgQ09ORklH
X01URF9KRURFQ1BST0JFIGlzIG5vdCBzZXQKQ09ORklHX01URF9HRU5fUFJPQkU9eQojIENPTkZJ
R19NVERfQ0ZJX0FEVl9PUFRJT05TIGlzIG5vdCBzZXQKQ09ORklHX01URF9NQVBfQkFOS19XSURU
SF8xPXkKQ09ORklHX01URF9NQVBfQkFOS19XSURUSF8yPXkKQ09ORklHX01URF9NQVBfQkFOS19X
SURUSF80PXkKIyBDT05GSUdfTVREX01BUF9CQU5LX1dJRFRIXzggaXMgbm90IHNldAojIENPTkZJ
R19NVERfTUFQX0JBTktfV0lEVEhfMTYgaXMgbm90IHNldAojIENPTkZJR19NVERfTUFQX0JBTktf
V0lEVEhfMzIgaXMgbm90IHNldApDT05GSUdfTVREX0NGSV9JMT15CkNPTkZJR19NVERfQ0ZJX0ky
PXkKIyBDT05GSUdfTVREX0NGSV9JNCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9DRklfSTggaXMg
bm90IHNldApDT05GSUdfTVREX0NGSV9JTlRFTEVYVD15CiMgQ09ORklHX01URF9DRklfQU1EU1RE
IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX0NGSV9TVEFBIGlzIG5vdCBzZXQKQ09ORklHX01URF9D
RklfVVRJTD15CiMgQ09ORklHX01URF9SQU0gaXMgbm90IHNldAojIENPTkZJR19NVERfUk9NIGlz
IG5vdCBzZXQKIyBDT05GSUdfTVREX0FCU0VOVCBpcyBub3Qgc2V0CgojCiMgTWFwcGluZyBkcml2
ZXJzIGZvciBjaGlwIGFjY2VzcwojCiMgQ09ORklHX01URF9DT01QTEVYX01BUFBJTkdTIGlzIG5v
dCBzZXQKIyBDT05GSUdfTVREX1BIWVNNQVAgaXMgbm90IHNldAojIENPTkZJR19NVERfQVJNX0lO
VEVHUkFUT1IgaXMgbm90IHNldAojIENPTkZJR19NVERfUExBVFJBTSBpcyBub3Qgc2V0CgojCiMg
U2VsZi1jb250YWluZWQgTVREIGRldmljZSBkcml2ZXJzCiMKIyBDT05GSUdfTVREX0RBVEFGTEFT
SCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9NMjVQODAgaXMgbm90IHNldAojIENPTkZJR19NVERf
U1NUMjVMIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX1NMUkFNIGlzIG5vdCBzZXQKIyBDT05GSUdf
TVREX1BIUkFNIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX01URFJBTSBpcyBub3Qgc2V0CiMgQ09O
RklHX01URF9CTE9DSzJNVEQgaXMgbm90IHNldAoKIwojIERpc2stT24tQ2hpcCBEZXZpY2UgRHJp
dmVycwojCiMgQ09ORklHX01URF9ET0MyMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX0RPQzIw
MDEgaXMgbm90IHNldAojIENPTkZJR19NVERfRE9DMjAwMVBMVVMgaXMgbm90IHNldApDT05GSUdf
TVREX05BTkRfRUNDPXkKIyBDT05GSUdfTVREX05BTkRfRUNDX1NNQyBpcyBub3Qgc2V0CkNPTkZJ
R19NVERfTkFORD15CiMgQ09ORklHX01URF9OQU5EX1ZFUklGWV9XUklURSBpcyBub3Qgc2V0CiMg
Q09ORklHX01URF9OQU5EX0VDQ19CQ0ggaXMgbm90IHNldAojIENPTkZJR19NVERfU01fQ09NTU9O
IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX05BTkRfTVVTRVVNX0lEUyBpcyBub3Qgc2V0CiMgQ09O
RklHX01URF9OQU5EX0dQSU8gaXMgbm90IHNldApDT05GSUdfTVREX05BTkRfT01BUDI9eQpDT05G
SUdfTVREX05BTkRfSURTPXkKIyBDT05GSUdfTVREX05BTkRfRElTS09OQ0hJUCBpcyBub3Qgc2V0
CiMgQ09ORklHX01URF9OQU5EX05BTkRTSU0gaXMgbm90IHNldAojIENPTkZJR19NVERfTkFORF9Q
TEFURk9STSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9BTEFVREEgaXMgbm90IHNldApDT05GSUdf
TVREX09ORU5BTkQ9eQpDT05GSUdfTVREX09ORU5BTkRfVkVSSUZZX1dSSVRFPXkKIyBDT05GSUdf
TVREX09ORU5BTkRfR0VORVJJQyBpcyBub3Qgc2V0CkNPTkZJR19NVERfT05FTkFORF9PTUFQMj15
CiMgQ09ORklHX01URF9PTkVOQU5EX09UUCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9PTkVOQU5E
XzJYX1BST0dSQU0gaXMgbm90IHNldAojIENPTkZJR19NVERfT05FTkFORF9TSU0gaXMgbm90IHNl
dAoKIwojIExQRERSIGZsYXNoIG1lbW9yeSBkcml2ZXJzCiMKIyBDT05GSUdfTVREX0xQRERSIGlz
IG5vdCBzZXQKQ09ORklHX01URF9VQkk9eQpDT05GSUdfTVREX1VCSV9XTF9USFJFU0hPTEQ9NDA5
NgpDT05GSUdfTVREX1VCSV9CRUJfUkVTRVJWRT0xCiMgQ09ORklHX01URF9VQklfR0xVRUJJIGlz
IG5vdCBzZXQKIyBDT05GSUdfTVREX1VCSV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBUlBP
UlQgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVj15CiMgQ09ORklHX0JMS19ERVZfQ09XX0NPTU1P
TiBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX0xPT1A9eQojIENPTkZJR19CTEtfREVWX0NSWVBU
T0xPT1AgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0RSQkQgaXMgbm90IHNldAojIENPTkZJ
R19CTEtfREVWX05CRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfVUIgaXMgbm90IHNldApD
T05GSUdfQkxLX0RFVl9SQU09eQpDT05GSUdfQkxLX0RFVl9SQU1fQ09VTlQ9MTYKQ09ORklHX0JM
S19ERVZfUkFNX1NJWkU9MTYzODQKIyBDT05GSUdfQkxLX0RFVl9YSVAgaXMgbm90IHNldAojIENP
TkZJR19DRFJPTV9QS1RDRFZEIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBX09WRVJfRVRIIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUdfRElTSyBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfUkJEIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MSVMzTFYwMkQgaXMgbm90IHNldAojIENPTkZJR19N
SVNDX0RFVklDRVMgaXMgbm90IHNldApDT05GSUdfSEFWRV9JREU9eQojIENPTkZJR19JREUgaXMg
bm90IHNldAoKIwojIFNDU0kgZGV2aWNlIHN1cHBvcnQKIwpDT05GSUdfU0NTSV9NT0Q9eQojIENP
TkZJR19SQUlEX0FUVFJTIGlzIG5vdCBzZXQKQ09ORklHX1NDU0k9eQpDT05GSUdfU0NTSV9ETUE9
eQojIENPTkZJR19TQ1NJX1RHVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfTkVUTElOSyBpcyBu
b3Qgc2V0CkNPTkZJR19TQ1NJX1BST0NfRlM9eQoKIwojIFNDU0kgc3VwcG9ydCB0eXBlIChkaXNr
LCB0YXBlLCBDRC1ST00pCiMKQ09ORklHX0JMS19ERVZfU0Q9eQojIENPTkZJR19DSFJfREVWX1NU
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hSX0RFVl9PU1NUIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxL
X0RFVl9TUiBpcyBub3Qgc2V0CiMgQ09ORklHX0NIUl9ERVZfU0cgaXMgbm90IHNldAojIENPTkZJ
R19DSFJfREVWX1NDSCBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX01VTFRJX0xVTj15CiMgQ09ORklH
X1NDU0lfQ09OU1RBTlRTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9MT0dHSU5HIGlzIG5vdCBz
ZXQKQ09ORklHX1NDU0lfU0NBTl9BU1lOQz15CkNPTkZJR19TQ1NJX1dBSVRfU0NBTj1tCgojCiMg
U0NTSSBUcmFuc3BvcnRzCiMKIyBDT05GSUdfU0NTSV9TUElfQVRUUlMgaXMgbm90IHNldAojIENP
TkZJR19TQ1NJX0ZDX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9JU0NTSV9BVFRSUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfU0FTX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NT
SV9TQVNfTElCU0FTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9TUlBfQVRUUlMgaXMgbm90IHNl
dApDT05GSUdfU0NTSV9MT1dMRVZFTD15CiMgQ09ORklHX0lTQ1NJX1RDUCBpcyBub3Qgc2V0CiMg
Q09ORklHX0lTQ1NJX0JPT1RfU1lTRlMgaXMgbm90IHNldAojIENPTkZJR19MSUJGQyBpcyBub3Qg
c2V0CiMgQ09ORklHX0xJQkZDT0UgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0RFQlVHIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NTSV9ESCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfT1NEX0lOSVRJ
QVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQSBpcyBub3Qgc2V0CkNPTkZJR19NRD15CiMgQ09O
RklHX0JMS19ERVZfTUQgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX0RNIGlzIG5vdCBzZXQK
IyBDT05GSUdfVEFSR0VUX0NPUkUgaXMgbm90IHNldApDT05GSUdfTkVUREVWSUNFUz15CiMgQ09O
RklHX0RVTU1ZIGlzIG5vdCBzZXQKIyBDT05GSUdfQk9ORElORyBpcyBub3Qgc2V0CiMgQ09ORklH
X01BQ1ZMQU4gaXMgbm90IHNldAojIENPTkZJR19FUVVBTElaRVIgaXMgbm90IHNldAojIENPTkZJ
R19UVU4gaXMgbm90IHNldAojIENPTkZJR19WRVRIIGlzIG5vdCBzZXQKQ09ORklHX01JST15CkNP
TkZJR19QSFlMSUI9eQoKIwojIE1JSSBQSFkgZGV2aWNlIGRyaXZlcnMKIwojIENPTkZJR19NQVJW
RUxMX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX0RBVklDT01fUEhZIGlzIG5vdCBzZXQKIyBDT05G
SUdfUVNFTUlfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTFhUX1BIWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0NJQ0FEQV9QSFkgaXMgbm90IHNldAojIENPTkZJR19WSVRFU1NFX1BIWSBpcyBub3Qgc2V0
CkNPTkZJR19TTVNDX1BIWT15CiMgQ09ORklHX0JST0FEQ09NX1BIWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0lDUExVU19QSFkgaXMgbm90IHNldAojIENPTkZJR19SRUFMVEVLX1BIWSBpcyBub3Qgc2V0
CiMgQ09ORklHX05BVElPTkFMX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NURTEwWFAgaXMgbm90
IHNldAojIENPTkZJR19MU0lfRVQxMDExQ19QSFkgaXMgbm90IHNldAojIENPTkZJR19NSUNSRUxf
UEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfRklYRURfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTURJ
T19CSVRCQU5HIGlzIG5vdCBzZXQKQ09ORklHX05FVF9FVEhFUk5FVD15CiMgQ09ORklHX0FYODg3
OTYgaXMgbm90IHNldApDT05GSUdfU01DOTFYPXkKIyBDT05GSUdfVElfREFWSU5DSV9FTUFDIGlz
IG5vdCBzZXQKIyBDT05GSUdfVElfREFWSU5DSV9NRElPIGlzIG5vdCBzZXQKIyBDT05GSUdfVElf
REFWSU5DSV9DUERNQSBpcyBub3Qgc2V0CiMgQ09ORklHX0RNOTAwMCBpcyBub3Qgc2V0CiMgQ09O
RklHX0VOQzI4SjYwIGlzIG5vdCBzZXQKIyBDT05GSUdfRVRIT0MgaXMgbm90IHNldAojIENPTkZJ
R19TTUM5MTFYIGlzIG5vdCBzZXQKQ09ORklHX1NNU0M5MTFYPXkKIyBDT05GSUdfU01TQzkxMVhf
QVJDSF9IT09LUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RORVQgaXMgbm90IHNldAojIENPTkZJR19J
Qk1fTkVXX0VNQUNfWk1JSSBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19SR01JSSBp
cyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19UQUggaXMgbm90IHNldAojIENPTkZJR19J
Qk1fTkVXX0VNQUNfRU1BQzQgaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfTk9fRkxP
V19DVFJMIGlzIG5vdCBzZXQKIyBDT05GSUdfSUJNX05FV19FTUFDX01BTF9DTFJfSUNJTlRTVEFU
IGlzIG5vdCBzZXQKIyBDT05GSUdfSUJNX05FV19FTUFDX01BTF9DT01NT05fRVJSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQjQ0IGlzIG5vdCBzZXQKQ09ORklHX0tTODg1MT15CkNPTkZJR19LUzg4NTFf
TUxMPXkKIyBDT05GSUdfRlRNQUMxMDAgaXMgbm90IHNldApDT05GSUdfTkVUREVWXzEwMDA9eQoj
IENPTkZJR19TVE1NQUNfRVRIIGlzIG5vdCBzZXQKQ09ORklHX05FVERFVl8xMDAwMD15CkNPTkZJ
R19XTEFOPXkKIyBDT05GSUdfTElCRVJUQVNfVEhJTkZJUk0gaXMgbm90IHNldAojIENPTkZJR19B
VDc2QzUwWF9VU0IgaXMgbm90IHNldAojIENPTkZJR19VU0JfWkQxMjAxIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX05FVF9STkRJU19XTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRMODE4NyBpcyBu
b3Qgc2V0CiMgQ09ORklHX01BQzgwMjExX0hXU0lNIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRIX0NP
TU1PTiBpcyBub3Qgc2V0CiMgQ09ORklHX0I0MyBpcyBub3Qgc2V0CiMgQ09ORklHX0I0M0xFR0FD
WSBpcyBub3Qgc2V0CiMgQ09ORklHX0hPU1RBUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lXTSBpcyBu
b3Qgc2V0CkNPTkZJR19MSUJFUlRBUz1tCkNPTkZJR19MSUJFUlRBU19VU0I9bQpDT05GSUdfTElC
RVJUQVNfU0RJTz1tCiMgQ09ORklHX0xJQkVSVEFTX1NQSSBpcyBub3Qgc2V0CkNPTkZJR19MSUJF
UlRBU19ERUJVRz15CiMgQ09ORklHX0xJQkVSVEFTX01FU0ggaXMgbm90IHNldAojIENPTkZJR19Q
NTRfQ09NTU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfUlQyWDAwIGlzIG5vdCBzZXQKIyBDT05GSUdf
UlRMODE5MlNFIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRMODE5MkNVIGlzIG5vdCBzZXQKIyBDT05G
SUdfV0wxMjUxIGlzIG5vdCBzZXQKIyBDT05GSUdfV0wxMlhYX01FTlUgaXMgbm90IHNldAojIENP
TkZJR19aRDEyMTFSVyBpcyBub3Qgc2V0CiMgQ09ORklHX01XSUZJRVggaXMgbm90IHNldAoKIwoj
IEVuYWJsZSBXaU1BWCAoTmV0d29ya2luZyBvcHRpb25zKSB0byBzZWUgdGhlIFdpTUFYIGRyaXZl
cnMKIwoKIwojIFVTQiBOZXR3b3JrIEFkYXB0ZXJzCiMKIyBDT05GSUdfVVNCX0NBVEMgaXMgbm90
IHNldAojIENPTkZJR19VU0JfS0FXRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1BFR0FTVVMg
aXMgbm90IHNldAojIENPTkZJR19VU0JfUlRMODE1MCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfVVNC
TkVUPXkKQ09ORklHX1VTQl9ORVRfQVg4ODE3WD15CkNPTkZJR19VU0JfTkVUX0NEQ0VUSEVSPXkK
IyBDT05GSUdfVVNCX05FVF9DRENfRUVNIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9ORVRfQ0RDX05D
TT15CiMgQ09ORklHX1VTQl9ORVRfRE05NjAxIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX05FVF9T
TVNDNzVYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9ORVRfU01TQzk1WFggaXMgbm90IHNldAoj
IENPTkZJR19VU0JfTkVUX0dMNjIwQSBpcyBub3Qgc2V0CkNPTkZJR19VU0JfTkVUX05FVDEwODA9
eQojIENPTkZJR19VU0JfTkVUX1BMVVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX05FVF9NQ1M3
ODMwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX05FVF9STkRJU19IT1NUIGlzIG5vdCBzZXQKQ09O
RklHX1VTQl9ORVRfQ0RDX1NVQlNFVD15CkNPTkZJR19VU0JfQUxJX001NjMyPXkKQ09ORklHX1VT
Ql9BTjI3MjA9eQpDT05GSUdfVVNCX0JFTEtJTj15CkNPTkZJR19VU0JfQVJNTElOVVg9eQpDT05G
SUdfVVNCX0VQU09OMjg4OD15CkNPTkZJR19VU0JfS0MyMTkwPXkKQ09ORklHX1VTQl9ORVRfWkFV
UlVTPXkKIyBDT05GSUdfVVNCX05FVF9DWDgyMzEwX0VUSCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9ORVRfS0FMTUlBIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX05FVF9JTlQ1MVgxIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX0lQSEVUSCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TSUVSUkFfTkVU
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1ZMNjAwIGlzIG5vdCBzZXQKIyBDT05GSUdfV0FOIGlz
IG5vdCBzZXQKCiMKIyBDQUlGIHRyYW5zcG9ydCBkcml2ZXJzCiMKIyBDT05GSUdfUFBQIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0xJUCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVFBPTEwgaXMgbm90IHNl
dAojIENPTkZJR19ORVRfUE9MTF9DT05UUk9MTEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSVNETiBp
cyBub3Qgc2V0CiMgQ09ORklHX1BIT05FIGlzIG5vdCBzZXQKCiMKIyBJbnB1dCBkZXZpY2Ugc3Vw
cG9ydAojCkNPTkZJR19JTlBVVD15CiMgQ09ORklHX0lOUFVUX0ZGX01FTUxFU1MgaXMgbm90IHNl
dAojIENPTkZJR19JTlBVVF9QT0xMREVWIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfU1BBUlNF
S01BUCBpcyBub3Qgc2V0CgojCiMgVXNlcmxhbmQgaW50ZXJmYWNlcwojCkNPTkZJR19JTlBVVF9N
T1VTRURFVj15CkNPTkZJR19JTlBVVF9NT1VTRURFVl9QU0FVWD15CkNPTkZJR19JTlBVVF9NT1VT
RURFVl9TQ1JFRU5fWD0xMDI0CkNPTkZJR19JTlBVVF9NT1VTRURFVl9TQ1JFRU5fWT03NjgKQ09O
RklHX0lOUFVUX0pPWURFVj15CkNPTkZJR19JTlBVVF9FVkRFVj15CiMgQ09ORklHX0lOUFVUX0VW
QlVHIGlzIG5vdCBzZXQKCiMKIyBJbnB1dCBEZXZpY2UgRHJpdmVycwojCkNPTkZJR19JTlBVVF9L
RVlCT0FSRD15CiMgQ09ORklHX0tFWUJPQVJEX0FEUDU1ODggaXMgbm90IHNldAojIENPTkZJR19L
RVlCT0FSRF9BRFA1NTg5IGlzIG5vdCBzZXQKQ09ORklHX0tFWUJPQVJEX0FUS0JEPXkKIyBDT05G
SUdfS0VZQk9BUkRfUVQxMDcwIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfUVQyMTYwIGlz
IG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTEtLQkQgaXMgbm90IHNldApDT05GSUdfS0VZQk9B
UkRfR1BJTz15CiMgQ09ORklHX0tFWUJPQVJEX1RDQTY0MTYgaXMgbm90IHNldAojIENPTkZJR19L
RVlCT0FSRF9NQVRSSVggaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9NQVg3MzU5IGlzIG5v
dCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTUNTIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRf
TVBSMTIxIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTkVXVE9OIGlzIG5vdCBzZXQKIyBD
T05GSUdfS0VZQk9BUkRfT1BFTkNPUkVTIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfU1RP
V0FXQVkgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9TVU5LQkQgaXMgbm90IHNldAojIENP
TkZJR19LRVlCT0FSRF9PTUFQIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfT01BUDQgaXMg
bm90IHNldAojIENPTkZJR19LRVlCT0FSRF9UV0w0MDMwIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZ
Qk9BUkRfWFRLQkQgaXMgbm90IHNldApDT05GSUdfSU5QVVRfTU9VU0U9eQpDT05GSUdfTU9VU0Vf
UFMyPXkKQ09ORklHX01PVVNFX1BTMl9BTFBTPXkKQ09ORklHX01PVVNFX1BTMl9MT0dJUFMyUFA9
eQpDT05GSUdfTU9VU0VfUFMyX1NZTkFQVElDUz15CkNPTkZJR19NT1VTRV9QUzJfVFJBQ0tQT0lO
VD15CiMgQ09ORklHX01PVVNFX1BTMl9FTEFOVEVDSCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNF
X1BTMl9TRU5URUxJQyBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX1BTMl9UT1VDSEtJVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01PVVNFX1NFUklBTCBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX0FQ
UExFVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9CQ001OTc0IGlzIG5vdCBzZXQKIyBD
T05GSUdfTU9VU0VfVlNYWFhBQSBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX0dQSU8gaXMgbm90
IHNldAojIENPTkZJR19NT1VTRV9TWU5BUFRJQ1NfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5Q
VVRfSk9ZU1RJQ0sgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9UQUJMRVQgaXMgbm90IHNldApD
T05GSUdfSU5QVVRfVE9VQ0hTQ1JFRU49eQpDT05GSUdfVE9VQ0hTQ1JFRU5fQURTNzg0Nj15CiMg
Q09ORklHX1RPVUNIU0NSRUVOX0FENzg3NyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVO
X0FENzg3OSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0FUTUVMX01YVCBpcyBub3Qg
c2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0JVMjEwMTMgaXMgbm90IHNldAojIENPTkZJR19UT1VD
SFNDUkVFTl9DWThDVE1HMTEwIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fRFlOQVBS
TyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0hBTVBTSElSRSBpcyBub3Qgc2V0CiMg
Q09ORklHX1RPVUNIU0NSRUVOX0VFVEkgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9G
VUpJVFNVIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fR1VOWkUgaXMgbm90IHNldAoj
IENPTkZJR19UT1VDSFNDUkVFTl9FTE8gaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9X
QUNPTV9XODAwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX01BWDExODAxIGlzIG5v
dCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTUNTNTAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1RP
VUNIU0NSRUVOX01UT1VDSCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0lORVhJTyBp
cyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX01LNzEyIGlzIG5vdCBzZXQKIyBDT05GSUdf
VE9VQ0hTQ1JFRU5fUEVOTU9VTlQgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9UT1VD
SFJJR0hUIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVE9VQ0hXSU4gaXMgbm90IHNl
dAojIENPTkZJR19UT1VDSFNDUkVFTl9VU0JfQ09NUE9TSVRFIGlzIG5vdCBzZXQKIyBDT05GSUdf
VE9VQ0hTQ1JFRU5fVE9VQ0hJVDIxMyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1RT
QzIwMDUgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9UU0MyMDA3IGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9VQ0hTQ1JFRU5fVzkwWDkwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NS
RUVOX1NUMTIzMiBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1RQUzY1MDdYIGlzIG5v
dCBzZXQKQ09ORklHX0lOUFVUX01JU0M9eQojIENPTkZJR19JTlBVVF9BRDcxNFggaXMgbm90IHNl
dAojIENPTkZJR19JTlBVVF9BVElfUkVNT1RFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQVRJ
X1JFTU9URTIgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9LRVlTUEFOX1JFTU9URSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lOUFVUX1BPV0VSTUFURSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1lF
QUxJTksgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9DTTEwOSBpcyBub3Qgc2V0CiMgQ09ORklH
X0lOUFVUX1RXTDQwMzBfUFdSQlVUVE9OIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfVFdMNDAz
MF9WSUJSQSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1VJTlBVVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOUFVUX1BDRjg1NzQgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9HUElPX1JPVEFSWV9F
TkNPREVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQURYTDM0WCBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOUFVUX0NNQTMwMDAgaXMgbm90IHNldAoKIwojIEhhcmR3YXJlIEkvTyBwb3J0cwojCkNP
TkZJR19TRVJJTz15CkNPTkZJR19TRVJJT19TRVJQT1JUPXkKQ09ORklHX1NFUklPX0xJQlBTMj15
CiMgQ09ORklHX1NFUklPX1JBVyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklPX0FMVEVSQV9QUzIg
aXMgbm90IHNldAojIENPTkZJR19TRVJJT19QUzJNVUxUIGlzIG5vdCBzZXQKIyBDT05GSUdfR0FN
RVBPUlQgaXMgbm90IHNldAoKIwojIENoYXJhY3RlciBkZXZpY2VzCiMKQ09ORklHX1ZUPXkKQ09O
RklHX0NPTlNPTEVfVFJBTlNMQVRJT05TPXkKQ09ORklHX1ZUX0NPTlNPTEU9eQpDT05GSUdfSFdf
Q09OU09MRT15CkNPTkZJR19WVF9IV19DT05TT0xFX0JJTkRJTkc9eQpDT05GSUdfVU5JWDk4X1BU
WVM9eQojIENPTkZJR19ERVZQVFNfTVVMVElQTEVfSU5TVEFOQ0VTIGlzIG5vdCBzZXQKIyBDT05G
SUdfTEVHQUNZX1BUWVMgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfTk9OU1RBTkRBUkQgaXMg
bm90IHNldAojIENPTkZJR19OX0dTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1RSQUNFX1NJTksgaXMg
bm90IHNldApDT05GSUdfREVWS01FTT15CgojCiMgU2VyaWFsIGRyaXZlcnMKIwpDT05GSUdfU0VS
SUFMXzgyNTA9eQpDT05GSUdfU0VSSUFMXzgyNTBfQ09OU09MRT15CkNPTkZJR19TRVJJQUxfODI1
MF9OUl9VQVJUUz0zMgpDT05GSUdfU0VSSUFMXzgyNTBfUlVOVElNRV9VQVJUUz00CkNPTkZJR19T
RVJJQUxfODI1MF9FWFRFTkRFRD15CkNPTkZJR19TRVJJQUxfODI1MF9NQU5ZX1BPUlRTPXkKQ09O
RklHX1NFUklBTF84MjUwX1NIQVJFX0lSUT15CkNPTkZJR19TRVJJQUxfODI1MF9ERVRFQ1RfSVJR
PXkKQ09ORklHX1NFUklBTF84MjUwX1JTQT15CgojCiMgTm9uLTgyNTAgc2VyaWFsIHBvcnQgc3Vw
cG9ydAojCiMgQ09ORklHX1NFUklBTF9NQVgzMTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFM
X01BWDMxMDcgaXMgbm90IHNldApDT05GSUdfU0VSSUFMX0NPUkU9eQpDT05GSUdfU0VSSUFMX0NP
UkVfQ09OU09MRT15CkNPTkZJR19TRVJJQUxfT01BUD15CkNPTkZJR19TRVJJQUxfT01BUF9DT05T
T0xFPXkKIyBDT05GSUdfU0VSSUFMX1RJTUJFUkRBTEUgaXMgbm90IHNldAojIENPTkZJR19TRVJJ
QUxfQUxURVJBX0pUQUdVQVJUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX0FMVEVSQV9VQVJU
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX0lGWDZYNjAgaXMgbm90IHNldAojIENPTkZJR19T
RVJJQUxfWElMSU5YX1BTX1VBUlQgaXMgbm90IHNldAojIENPTkZJR19UVFlfUFJJTlRLIGlzIG5v
dCBzZXQKIyBDT05GSUdfSFZDX0RDQyBpcyBub3Qgc2V0CiMgQ09ORklHX0lQTUlfSEFORExFUiBp
cyBub3Qgc2V0CkNPTkZJR19IV19SQU5ET009eQojIENPTkZJR19IV19SQU5ET01fVElNRVJJT01F
TSBpcyBub3Qgc2V0CkNPTkZJR19IV19SQU5ET01fT01BUD15CiMgQ09ORklHX1IzOTY0IGlzIG5v
dCBzZXQKIyBDT05GSUdfUkFXX0RSSVZFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1RDR19UUE0gaXMg
bm90IHNldAojIENPTkZJR19SQU1PT1BTIGlzIG5vdCBzZXQKQ09ORklHX0kyQz15CkNPTkZJR19J
MkNfQk9BUkRJTkZPPXkKQ09ORklHX0kyQ19DT01QQVQ9eQpDT05GSUdfSTJDX0NIQVJERVY9eQoj
IENPTkZJR19JMkNfTVVYIGlzIG5vdCBzZXQKQ09ORklHX0kyQ19IRUxQRVJfQVVUTz15CgojCiMg
STJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0CiMKCiMKIyBJMkMgc3lzdGVtIGJ1cyBkcml2ZXJzICht
b3N0bHkgZW1iZWRkZWQgLyBzeXN0ZW0tb24tY2hpcCkKIwojIENPTkZJR19JMkNfREVTSUdOV0FS
RSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19HUElPIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX09D
T1JFUyBpcyBub3Qgc2V0CkNPTkZJR19JMkNfT01BUD15CiMgQ09ORklHX0kyQ19QQ0FfUExBVEZP
Uk0gaXMgbm90IHNldAojIENPTkZJR19JMkNfUFhBX1BDSSBpcyBub3Qgc2V0CiMgQ09ORklHX0ky
Q19TSU1URUMgaXMgbm90IHNldAojIENPTkZJR19JMkNfWElMSU5YIGlzIG5vdCBzZXQKCiMKIyBF
eHRlcm5hbCBJMkMvU01CdXMgYWRhcHRlciBkcml2ZXJzCiMKIyBDT05GSUdfSTJDX0RJT0xBTl9V
MkMgaXMgbm90IHNldAojIENPTkZJR19JMkNfUEFSUE9SVF9MSUdIVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0kyQ19UQU9TX0VWTSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19USU5ZX1VTQiBpcyBub3Qg
c2V0CgojCiMgT3RoZXIgSTJDL1NNQnVzIGJ1cyBkcml2ZXJzCiMKIyBDT05GSUdfSTJDX1NUVUIg
aXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX0ky
Q19ERUJVR19BTEdPIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0JVUyBpcyBub3Qgc2V0
CkNPTkZJR19TUEk9eQojIENPTkZJR19TUElfREVCVUcgaXMgbm90IHNldApDT05GSUdfU1BJX01B
U1RFUj15CgojCiMgU1BJIE1hc3RlciBDb250cm9sbGVyIERyaXZlcnMKIwojIENPTkZJR19TUElf
QUxURVJBIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX0JJVEJBTkcgaXMgbm90IHNldAojIENPTkZJ
R19TUElfR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9PQ19USU5ZIGlzIG5vdCBzZXQKQ09O
RklHX1NQSV9PTUFQMjRYWD15CiMgQ09ORklHX1NQSV9QWEEyWFhfUENJIGlzIG5vdCBzZXQKIyBD
T05GSUdfU1BJX1hJTElOWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9ERVNJR05XQVJFIGlzIG5v
dCBzZXQKCiMKIyBTUEkgUHJvdG9jb2wgTWFzdGVycwojCiMgQ09ORklHX1NQSV9TUElERVYgaXMg
bm90IHNldAojIENPTkZJR19TUElfVExFNjJYMCBpcyBub3Qgc2V0CgojCiMgUFBTIHN1cHBvcnQK
IwojIENPTkZJR19QUFMgaXMgbm90IHNldAoKIwojIFBQUyBnZW5lcmF0b3JzIHN1cHBvcnQKIwoK
IwojIFBUUCBjbG9jayBzdXBwb3J0CiMKCiMKIyBFbmFibGUgRGV2aWNlIERyaXZlcnMgLT4gUFBT
IHRvIHNlZSB0aGUgUFRQIGNsb2NrIG9wdGlvbnMuCiMKQ09ORklHX0FSQ0hfUkVRVUlSRV9HUElP
TElCPXkKQ09ORklHX0dQSU9MSUI9eQpDT05GSUdfREVCVUdfR1BJTz15CkNPTkZJR19HUElPX1NZ
U0ZTPXkKCiMKIyBNZW1vcnkgbWFwcGVkIEdQSU8gZHJpdmVyczoKIwojIENPTkZJR19HUElPX0JB
U0lDX01NSU8gaXMgbm90IHNldAojIENPTkZJR19HUElPX0lUODc2MUUgaXMgbm90IHNldAoKIwoj
IEkyQyBHUElPIGV4cGFuZGVyczoKIwojIENPTkZJR19HUElPX01BWDczMDAgaXMgbm90IHNldAoj
IENPTkZJR19HUElPX01BWDczMlggaXMgbm90IHNldAojIENPTkZJR19HUElPX1BDRjg1N1ggaXMg
bm90IHNldAojIENPTkZJR19HUElPX1NYMTUwWCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fVFdM
NDAzMCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fQURQNTU4OCBpcyBub3Qgc2V0CgojCiMgUENJ
IEdQSU8gZXhwYW5kZXJzOgojCgojCiMgU1BJIEdQSU8gZXhwYW5kZXJzOgojCiMgQ09ORklHX0dQ
SU9fTUFYNzMwMSBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTUNQMjNTMDggaXMgbm90IHNldAoj
IENPTkZJR19HUElPX01DMzM4ODAgaXMgbm90IHNldAojIENPTkZJR19HUElPXzc0WDE2NCBpcyBu
b3Qgc2V0CgojCiMgQUM5NyBHUElPIGV4cGFuZGVyczoKIwoKIwojIE1PRFVMYnVzIEdQSU8gZXhw
YW5kZXJzOgojCkNPTkZJR19XMT15CkNPTkZJR19XMV9DT049eQoKIwojIDEtd2lyZSBCdXMgTWFz
dGVycwojCiMgQ09ORklHX1cxX01BU1RFUl9EUzI0OTAgaXMgbm90IHNldAojIENPTkZJR19XMV9N
QVNURVJfRFMyNDgyIGlzIG5vdCBzZXQKIyBDT05GSUdfVzFfTUFTVEVSX0RTMVdNIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVzFfTUFTVEVSX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19IRFFfTUFTVEVS
X09NQVAgaXMgbm90IHNldAoKIwojIDEtd2lyZSBTbGF2ZXMKIwojIENPTkZJR19XMV9TTEFWRV9U
SEVSTSBpcyBub3Qgc2V0CiMgQ09ORklHX1cxX1NMQVZFX1NNRU0gaXMgbm90IHNldAojIENPTkZJ
R19XMV9TTEFWRV9EUzI0MDggaXMgbm90IHNldAojIENPTkZJR19XMV9TTEFWRV9EUzI0MjMgaXMg
bm90IHNldAojIENPTkZJR19XMV9TTEFWRV9EUzI0MzEgaXMgbm90IHNldAojIENPTkZJR19XMV9T
TEFWRV9EUzI0MzMgaXMgbm90IHNldAojIENPTkZJR19XMV9TTEFWRV9EUzI3NjAgaXMgbm90IHNl
dAojIENPTkZJR19XMV9TTEFWRV9EUzI3ODAgaXMgbm90IHNldAojIENPTkZJR19XMV9TTEFWRV9C
UTI3MDAwIGlzIG5vdCBzZXQKQ09ORklHX1BPV0VSX1NVUFBMWT15CiMgQ09ORklHX1BPV0VSX1NV
UFBMWV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1BEQV9QT1dFUiBpcyBub3Qgc2V0CiMgQ09O
RklHX1RFU1RfUE9XRVIgaXMgbm90IHNldAojIENPTkZJR19CQVRURVJZX0RTMjc4MCBpcyBub3Qg
c2V0CiMgQ09ORklHX0JBVFRFUllfRFMyNzgyIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9C
UTIwWjc1IGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9CUTI3eDAwIGlzIG5vdCBzZXQKIyBD
T05GSUdfQkFUVEVSWV9NQVgxNzA0MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfTUFYMTcw
NDIgaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX01BWDg5MDMgaXMgbm90IHNldAojIENPTkZJ
R19DSEFSR0VSX1RXTDQwMzAgaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX0dQSU8gaXMgbm90
IHNldApDT05GSUdfSFdNT049eQojIENPTkZJR19IV01PTl9WSUQgaXMgbm90IHNldAojIENPTkZJ
R19IV01PTl9ERUJVR19DSElQIGlzIG5vdCBzZXQKCiMKIyBOYXRpdmUgZHJpdmVycwojCiMgQ09O
RklHX1NFTlNPUlNfQUQ3NDE0IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRDc0MTggaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX0FEQ1hYIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19BRE0xMDIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI1IGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19BRE0xMDI2IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0x
MDI5IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDMxIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19BRE05MjQwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDExIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDYyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19BRFQ3NDcwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDc1IGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19BU0M3NjIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19B
VFhQMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRFM2MjAgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0RTMTYyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRjcxODA1RiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRjcxODgyRkcgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX0Y3NTM3NVMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0c3NjBBIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19HTDUxOFNNIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19HTDUy
MFNNIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19HUElPX0ZBTiBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfSVQ4NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSkM0MiBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfTElORUFHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
TE02MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03MCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTE03MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03NSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfTE03NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03OCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfTE04MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04NSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfTE04NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05
MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRDNDE1MSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTFRDNDIxNSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRDNDI0NSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRDNDI2MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfTE05NTI0MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYMTExMSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfTUFYMTYwNjUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01B
WDE2MTkgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDY2MzkgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX01BWDY2NDIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDY2NTAg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1BDODczNjAgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX1BDODc0MjcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1BDRjg1OTEgaXMgbm90
IHNldAojIENPTkZJR19QTUJVUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0hUMTUgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX1NIVDIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19TTU02NjUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0RNRTE3MzcgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0VNQzE0MDMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0VNQzIx
MDMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0VNQzZXMjAxIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19TTVNDNDdNMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU01TQzQ3TTE5
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU01TQzQ3QjM5NyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfU0NINTYyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURTMTAxNSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURTNzgyOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfQURTNzg3MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQU1DNjgyMSBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfVEhNQzUwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19U
TVAxMDIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1RNUDQwMSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfVE1QNDIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19WVDEyMTEgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4Mzc4MUQgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX1c4Mzc5MUQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4Mzc5MkQgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX1c4Mzc5MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgz
Nzk1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19XODNMNzg1VFMgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX1c4M0w3ODZORyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNjI3
SEYgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4MzYyN0VIRiBpcyBub3Qgc2V0CiMgQ09O
RklHX1RIRVJNQUwgaXMgbm90IHNldApDT05GSUdfV0FUQ0hET0c9eQojIENPTkZJR19XQVRDSERP
R19OT1dBWU9VVCBpcyBub3Qgc2V0CgojCiMgV2F0Y2hkb2cgRGV2aWNlIERyaXZlcnMKIwojIENP
TkZJR19TT0ZUX1dBVENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfTVBDT1JFX1dBVENIRE9HIGlz
IG5vdCBzZXQKQ09ORklHX09NQVBfV0FUQ0hET0c9eQojIENPTkZJR19UV0w0MDMwX1dBVENIRE9H
IGlzIG5vdCBzZXQKIyBDT05GSUdfTUFYNjNYWF9XQVRDSERPRyBpcyBub3Qgc2V0CgojCiMgVVNC
LWJhc2VkIFdhdGNoZG9nIENhcmRzCiMKIyBDT05GSUdfVVNCUENXQVRDSERPRyBpcyBub3Qgc2V0
CkNPTkZJR19TU0JfUE9TU0lCTEU9eQoKIwojIFNvbmljcyBTaWxpY29uIEJhY2twbGFuZQojCiMg
Q09ORklHX1NTQiBpcyBub3Qgc2V0CkNPTkZJR19CQ01BX1BPU1NJQkxFPXkKCiMKIyBCcm9hZGNv
bSBzcGVjaWZpYyBBTUJBCiMKIyBDT05GSUdfQkNNQSBpcyBub3Qgc2V0CkNPTkZJR19NRkRfU1VQ
UE9SVD15CiMgQ09ORklHX01GRF9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEXzg4UE04NjBY
IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1NNNTAxIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0FT
SUMzIGlzIG5vdCBzZXQKIyBDT05GSUdfSFRDX0VHUElPIGlzIG5vdCBzZXQKIyBDT05GSUdfSFRD
X1BBU0lDMyBpcyBub3Qgc2V0CiMgQ09ORklHX0hUQ19JMkNQTEQgaXMgbm90IHNldAojIENPTkZJ
R19UUFM2MTA1WCBpcyBub3Qgc2V0CiMgQ09ORklHX1RQUzY1MDEwIGlzIG5vdCBzZXQKIyBDT05G
SUdfVFBTNjUwN1ggaXMgbm90IHNldAojIENPTkZJR19NRkRfVFBTNjU4NlggaXMgbm90IHNldApD
T05GSUdfTUVORUxBVVM9eQpDT05GSUdfVFdMNDAzMF9DT1JFPXkKIyBDT05GSUdfVFdMNDAzMF9N
QURDIGlzIG5vdCBzZXQKQ09ORklHX1RXTDQwMzBfUE9XRVI9eQojIENPTkZJR19UV0w0MDMwX0NP
REVDIGlzIG5vdCBzZXQKIyBDT05GSUdfVFdMNjAzMF9QV00gaXMgbm90IHNldAojIENPTkZJR19N
RkRfU1RNUEUgaXMgbm90IHNldAojIENPTkZJR19NRkRfVEMzNTg5WCBpcyBub3Qgc2V0CiMgQ09O
RklHX01GRF9UTUlPIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1Q3TDY2WEIgaXMgbm90IHNldAoj
IENPTkZJR19NRkRfVEM2Mzg3WEIgaXMgbm90IHNldAojIENPTkZJR19NRkRfVEM2MzkzWEIgaXMg
bm90IHNldAojIENPTkZJR19QTUlDX0RBOTAzWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BNSUNfQURQ
NTUyMCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg4OTI1IGlzIG5vdCBzZXQKIyBDT05GSUdf
TUZEX01BWDg5OTcgaXMgbm90IHNldAojIENPTkZJR19NRkRfTUFYODk5OCBpcyBub3Qgc2V0CiMg
Q09ORklHX01GRF9XTTg0MDAgaXMgbm90IHNldAojIENPTkZJR19NRkRfV004MzFYX0kyQyBpcyBu
b3Qgc2V0CiMgQ09ORklHX01GRF9XTTgzMVhfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dN
ODM1MF9JMkMgaXMgbm90IHNldAojIENPTkZJR19NRkRfV004OTk0IGlzIG5vdCBzZXQKIyBDT05G
SUdfTUZEX1BDRjUwNjMzIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01DMTNYWFggaXMgbm90IHNl
dAojIENPTkZJR19BQlg1MDBfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX0VaWF9QQ0FQIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUZEX1dMMTI3M19DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RQ
UzY1OTEwIGlzIG5vdCBzZXQKQ09ORklHX1JFR1VMQVRPUj15CiMgQ09ORklHX1JFR1VMQVRPUl9E
RUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9EVU1NWSBpcyBub3Qgc2V0CkNPTkZJ
R19SRUdVTEFUT1JfRklYRURfVk9MVEFHRT15CiMgQ09ORklHX1JFR1VMQVRPUl9WSVJUVUFMX0NP
TlNVTUVSIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1VTRVJTUEFDRV9DT05TVU1FUiBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9CUTI0MDIyIGlzIG5vdCBzZXQKIyBDT05GSUdf
UkVHVUxBVE9SX01BWDE1ODYgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfTUFYODY0OSBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NQVg4NjYwIGlzIG5vdCBzZXQKIyBDT05GSUdf
UkVHVUxBVE9SX01BWDg5NTIgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfVFdMNDAzMCBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9MUDM5NzEgaXMgbm90IHNldAojIENPTkZJR19S
RUdVTEFUT1JfTFAzOTcyIGlzIG5vdCBzZXQKQ09ORklHX1JFR1VMQVRPUl9UUFM2NTAyMz15CkNP
TkZJR19SRUdVTEFUT1JfVFBTNjUwN1g9eQojIENPTkZJR19SRUdVTEFUT1JfSVNMNjI3MUEgaXMg
bm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfQUQ1Mzk4IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVH
VUxBVE9SX1RQUzY1MjRYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVESUFfU1VQUE9SVCBpcyBub3Qg
c2V0CgojCiMgR3JhcGhpY3Mgc3VwcG9ydAojCiMgQ09ORklHX0RSTSBpcyBub3Qgc2V0CiMgQ09O
RklHX1ZHQVNUQVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfVklERU9fT1VUUFVUX0NPTlRST0wgaXMg
bm90IHNldApDT05GSUdfRkI9eQpDT05GSUdfRklSTVdBUkVfRURJRD15CiMgQ09ORklHX0ZCX0RE
QyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0JPT1RfVkVTQV9TVVBQT1JUIGlzIG5vdCBzZXQKQ09O
RklHX0ZCX0NGQl9GSUxMUkVDVD1tCkNPTkZJR19GQl9DRkJfQ09QWUFSRUE9bQpDT05GSUdfRkJf
Q0ZCX0lNQUdFQkxJVD1tCiMgQ09ORklHX0ZCX0NGQl9SRVZfUElYRUxTX0lOX0JZVEUgaXMgbm90
IHNldAojIENPTkZJR19GQl9TWVNfRklMTFJFQ1QgaXMgbm90IHNldAojIENPTkZJR19GQl9TWVNf
Q09QWUFSRUEgaXMgbm90IHNldAojIENPTkZJR19GQl9TWVNfSU1BR0VCTElUIGlzIG5vdCBzZXQK
IyBDT05GSUdfRkJfRk9SRUlHTl9FTkRJQU4gaXMgbm90IHNldAojIENPTkZJR19GQl9TWVNfRk9Q
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1dNVF9HRV9ST1BTIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfU1ZHQUxJQiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX01BQ01PREVTIGlzIG5vdCBzZXQKIyBD
T05GSUdfRkJfQkFDS0xJR0hUIGlzIG5vdCBzZXQKQ09ORklHX0ZCX01PREVfSEVMUEVSUz15CkNP
TkZJR19GQl9USUxFQkxJVFRJTkc9eQoKIwojIEZyYW1lIGJ1ZmZlciBoYXJkd2FyZSBkcml2ZXJz
CiMKIyBDT05GSUdfRkJfVVZFU0EgaXMgbm90IHNldAojIENPTkZJR19GQl9TMUQxM1hYWCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0ZCX1VETCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZJUlRVQUwgaXMg
bm90IHNldAojIENPTkZJR19GQl9NRVRST05PTUUgaXMgbm90IHNldAojIENPTkZJR19GQl9CUk9B
RFNIRUVUIGlzIG5vdCBzZXQKQ09ORklHX0ZCX09NQVBfTENEX1ZHQT15CiMgQ09ORklHX0ZCX09N
QVBfQk9PVExPQURFUl9JTklUIGlzIG5vdCBzZXQKQ09ORklHX09NQVAyX1ZSQU09eQpDT05GSUdf
T01BUDJfVlJGQj15CkNPTkZJR19PTUFQMl9EU1M9bQpDT05GSUdfT01BUDJfVlJBTV9TSVpFPTAK
Q09ORklHX09NQVAyX0RTU19ERUJVR19TVVBQT1JUPXkKIyBDT05GSUdfT01BUDJfRFNTX0NPTExF
Q1RfSVJRX1NUQVRTIGlzIG5vdCBzZXQKQ09ORklHX09NQVAyX0RTU19EUEk9eQpDT05GSUdfT01B
UDJfRFNTX1JGQkk9eQpDT05GSUdfT01BUDJfRFNTX1ZFTkM9eQpDT05GSUdfT01BUDRfRFNTX0hE
TUk9eQpDT05GSUdfT01BUDJfRFNTX1NEST15CkNPTkZJR19PTUFQMl9EU1NfRFNJPXkKIyBDT05G
SUdfT01BUDJfRFNTX0ZBS0VfVlNZTkMgaXMgbm90IHNldApDT05GSUdfT01BUDJfRFNTX01JTl9G
Q0tfUEVSX1BDSz0wCkNPTkZJR19PTUFQMl9EU1NfU0xFRVBfQkVGT1JFX1JFU0VUPXkKQ09ORklH
X09NQVAyX0RTU19TTEVFUF9BRlRFUl9WRU5DX1JFU0VUPXkKQ09ORklHX0ZCX09NQVAyPW0KQ09O
RklHX0ZCX09NQVAyX0RFQlVHX1NVUFBPUlQ9eQpDT05GSUdfRkJfT01BUDJfTlVNX0ZCUz0zCgoj
CiMgT01BUDIvMyBEaXNwbGF5IERldmljZSBEcml2ZXJzCiMKQ09ORklHX1BBTkVMX0dFTkVSSUNf
RFBJPW0KIyBDT05GSUdfUEFORUxfTEdQSElMSVBTX0xCMDM1UTAyIGlzIG5vdCBzZXQKQ09ORklH
X1BBTkVMX1NIQVJQX0xTMDM3VjdEVzAxPW0KQ09ORklHX1BBTkVMX05FQ19OTDgwNDhITDExXzAx
Qj1tCkNPTkZJR19QQU5FTF9UQUFMPW0KQ09ORklHX1BBTkVMX1RQT19URDA0M01URUExPW0KQ09O
RklHX1BBTkVMX0FDWDU2NUFLTT1tCkNPTkZJR19CQUNLTElHSFRfTENEX1NVUFBPUlQ9eQpDT05G
SUdfTENEX0NMQVNTX0RFVklDRT15CiMgQ09ORklHX0xDRF9MNEYwMDI0MlQwMyBpcyBub3Qgc2V0
CiMgQ09ORklHX0xDRF9MTVMyODNHRjA1IGlzIG5vdCBzZXQKIyBDT05GSUdfTENEX0xUVjM1MFFW
IGlzIG5vdCBzZXQKIyBDT05GSUdfTENEX1RETzI0TSBpcyBub3Qgc2V0CiMgQ09ORklHX0xDRF9W
R0cyNDMyQTQgaXMgbm90IHNldApDT05GSUdfTENEX1BMQVRGT1JNPXkKIyBDT05GSUdfTENEX1M2
RTYzTTAgaXMgbm90IHNldAojIENPTkZJR19MQ0RfTEQ5MDQwIGlzIG5vdCBzZXQKQ09ORklHX0JB
Q0tMSUdIVF9DTEFTU19ERVZJQ0U9eQpDT05GSUdfQkFDS0xJR0hUX0dFTkVSSUM9eQojIENPTkZJ
R19CQUNLTElHSFRfQURQODg2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9BRFA4ODcw
IGlzIG5vdCBzZXQKCiMKIyBEaXNwbGF5IGRldmljZSBzdXBwb3J0CiMKQ09ORklHX0RJU1BMQVlf
U1VQUE9SVD15CgojCiMgRGlzcGxheSBoYXJkd2FyZSBkcml2ZXJzCiMKCiMKIyBDb25zb2xlIGRp
c3BsYXkgZHJpdmVyIHN1cHBvcnQKIwpDT05GSUdfRFVNTVlfQ09OU09MRT15CkNPTkZJR19GUkFN
RUJVRkZFUl9DT05TT0xFPXkKIyBDT05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRV9ERVRFQ1RfUFJJ
TUFSWSBpcyBub3Qgc2V0CkNPTkZJR19GUkFNRUJVRkZFUl9DT05TT0xFX1JPVEFUSU9OPXkKQ09O
RklHX0ZPTlRTPXkKQ09ORklHX0ZPTlRfOHg4PXkKQ09ORklHX0ZPTlRfOHgxNj15CiMgQ09ORklH
X0ZPTlRfNngxMSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZPTlRfN3gxNCBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZPTlRfUEVBUkxfOHg4IGlzIG5vdCBzZXQKIyBDT05GSUdfRk9OVF9BQ09STl84eDggaXMg
bm90IHNldAojIENPTkZJR19GT05UX01JTklfNHg2IGlzIG5vdCBzZXQKIyBDT05GSUdfRk9OVF9T
VU44eDE2IGlzIG5vdCBzZXQKIyBDT05GSUdfRk9OVF9TVU4xMngyMiBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZPTlRfMTB4MTggaXMgbm90IHNldApDT05GSUdfTE9HTz15CkNPTkZJR19MT0dPX0xJTlVY
X01PTk89eQpDT05GSUdfTE9HT19MSU5VWF9WR0ExNj15CkNPTkZJR19MT0dPX0xJTlVYX0NMVVQy
MjQ9eQpDT05GSUdfU09VTkQ9bQpDT05GSUdfU09VTkRfT1NTX0NPUkU9eQpDT05GSUdfU09VTkRf
T1NTX0NPUkVfUFJFQ0xBSU09eQpDT05GSUdfU05EPW0KQ09ORklHX1NORF9USU1FUj1tCkNPTkZJ
R19TTkRfUENNPW0KQ09ORklHX1NORF9IV0RFUD1tCkNPTkZJR19TTkRfUkFXTUlEST1tCkNPTkZJ
R19TTkRfSkFDSz15CiMgQ09ORklHX1NORF9TRVFVRU5DRVIgaXMgbm90IHNldApDT05GSUdfU05E
X09TU0VNVUw9eQpDT05GSUdfU05EX01JWEVSX09TUz1tCkNPTkZJR19TTkRfUENNX09TUz1tCkNP
TkZJR19TTkRfUENNX09TU19QTFVHSU5TPXkKIyBDT05GSUdfU05EX0hSVElNRVIgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfRFlOQU1JQ19NSU5PUlMgaXMgbm90IHNldApDT05GSUdfU05EX1NVUFBP
UlRfT0xEX0FQST15CkNPTkZJR19TTkRfVkVSQk9TRV9QUk9DRlM9eQpDT05GSUdfU05EX1ZFUkJP
U0VfUFJJTlRLPXkKQ09ORklHX1NORF9ERUJVRz15CiMgQ09ORklHX1NORF9ERUJVR19WRVJCT1NF
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1BDTV9YUlVOX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05G
SUdfU05EX1JBV01JRElfU0VRIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX09QTDNfTElCX1NFUSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9PUEw0X0xJQl9TRVEgaXMgbm90IHNldAojIENPTkZJR19T
TkRfU0JBV0VfU0VRIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0VNVTEwSzFfU0VRIGlzIG5vdCBz
ZXQKQ09ORklHX1NORF9EUklWRVJTPXkKIyBDT05GSUdfU05EX0RVTU1ZIGlzIG5vdCBzZXQKIyBD
T05GSUdfU05EX0FMT09QIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX01UUEFWIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX1NFUklBTF9VMTY1NTAgaXMgbm90IHNldAojIENPTkZJR19TTkRfTVBVNDAx
IGlzIG5vdCBzZXQKQ09ORklHX1NORF9BUk09eQpDT05GSUdfU05EX1NQST15CkNPTkZJR19TTkRf
VVNCPXkKQ09ORklHX1NORF9VU0JfQVVESU89bQojIENPTkZJR19TTkRfVVNCX1VBMTAxIGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX1VTQl9DQUlBUSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9VU0Jf
NkZJUkUgaXMgbm90IHNldApDT05GSUdfU05EX1NPQz1tCiMgQ09ORklHX1NORF9TT0NfQ0FDSEVf
TFpPIGlzIG5vdCBzZXQKQ09ORklHX1NORF9PTUFQX1NPQz1tCiMgQ09ORklHX1NORF9PTUFQX1NP
Q19OODEwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX09NQVBfU09DX1JYNTEgaXMgbm90IHNldAoj
IENPTkZJR19TTkRfT01BUF9TT0NfT1ZFUk8gaXMgbm90IHNldAojIENPTkZJR19TTkRfT01BUF9T
T0NfT01BUDNFVk0gaXMgbm90IHNldAojIENPTkZJR19TTkRfT01BUF9TT0NfQU0zNTE3RVZNIGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX09NQVBfU09DX1NEUDM0MzAgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfT01BUF9TT0NfU0RQNDQzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9PTUFQX1NPQ19P
TUFQM19QQU5ET1JBIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX09NQVBfU09DX09NQVAzX0JFQUdM
RSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9PTUFQX1NPQ19aT09NMiBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9PTUFQX1NPQ19JR0VQMDAyMCBpcyBub3Qgc2V0CkNPTkZJR19TTkRfU09DX0kyQ19B
TkRfU1BJPW0KIyBDT05GSUdfU05EX1NPQ19BTExfQ09ERUNTIGlzIG5vdCBzZXQKIyBDT05GSUdf
U09VTkRfUFJJTUUgaXMgbm90IHNldApDT05GSUdfSElEX1NVUFBPUlQ9eQpDT05GSUdfSElEPXkK
IyBDT05GSUdfSElEUkFXIGlzIG5vdCBzZXQKCiMKIyBVU0IgSW5wdXQgRGV2aWNlcwojCkNPTkZJ
R19VU0JfSElEPXkKIyBDT05GSUdfSElEX1BJRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9ISURE
RVYgaXMgbm90IHNldAoKIwojIFNwZWNpYWwgSElEIGRyaXZlcnMKIwojIENPTkZJR19ISURfQTRU
RUNIIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0FDUlVYIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X0FQUExFIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0JFTEtJTiBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJRF9DSEVSUlkgaXMgbm90IHNldAojIENPTkZJR19ISURfQ0hJQ09OWSBpcyBub3Qgc2V0CiMg
Q09ORklHX0hJRF9QUk9ESUtFWVMgaXMgbm90IHNldAojIENPTkZJR19ISURfQ1lQUkVTUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hJRF9EUkFHT05SSVNFIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0VN
U19GRiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9FWktFWSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJ
RF9LRVlUT1VDSCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9LWUUgaXMgbm90IHNldAojIENPTkZJ
R19ISURfVUNMT0dJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9XQUxUT1AgaXMgbm90IHNldAoj
IENPTkZJR19ISURfR1lSQVRJT04gaXMgbm90IHNldAojIENPTkZJR19ISURfVFdJTkhBTiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hJRF9LRU5TSU5HVE9OIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0xD
UE9XRVIgaXMgbm90IHNldAojIENPTkZJR19ISURfTE9HSVRFQ0ggaXMgbm90IHNldAojIENPTkZJ
R19ISURfTUlDUk9TT0ZUIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX01PTlRFUkVZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSElEX01VTFRJVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19ISURfTlRSSUcg
aXMgbm90IHNldAojIENPTkZJR19ISURfT1JURUsgaXMgbm90IHNldAojIENPTkZJR19ISURfUEFO
VEhFUkxPUkQgaXMgbm90IHNldAojIENPTkZJR19ISURfUEVUQUxZTlggaXMgbm90IHNldAojIENP
TkZJR19ISURfUElDT0xDRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9RVUFOVEEgaXMgbm90IHNl
dAojIENPTkZJR19ISURfUk9DQ0FUIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1JPQ0NBVF9BUlZP
IGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1JPQ0NBVF9LT05FIGlzIG5vdCBzZXQKIyBDT05GSUdf
SElEX1JPQ0NBVF9LT05FUExVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9ST0NDQVRfS09WQVBM
VVMgaXMgbm90IHNldAojIENPTkZJR19ISURfUk9DQ0FUX1BZUkEgaXMgbm90IHNldAojIENPTkZJ
R19ISURfU0FNU1VORyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TT05ZIGlzIG5vdCBzZXQKIyBD
T05GSUdfSElEX1NVTlBMVVMgaXMgbm90IHNldAojIENPTkZJR19ISURfR1JFRU5BU0lBIGlzIG5v
dCBzZXQKIyBDT05GSUdfSElEX1NNQVJUSk9ZUExVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9U
T1BTRUVEIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1RIUlVTVE1BU1RFUiBpcyBub3Qgc2V0CiMg
Q09ORklHX0hJRF9aRVJPUExVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9aWURBQ1JPTiBpcyBu
b3Qgc2V0CkNPTkZJR19VU0JfU1VQUE9SVD15CkNPTkZJR19VU0JfQVJDSF9IQVNfSENEPXkKQ09O
RklHX1VTQl9BUkNIX0hBU19PSENJPXkKQ09ORklHX1VTQl9BUkNIX0hBU19FSENJPXkKQ09ORklH
X1VTQj15CkNPTkZJR19VU0JfREVCVUc9eQpDT05GSUdfVVNCX0FOTk9VTkNFX05FV19ERVZJQ0VT
PXkKCiMKIyBNaXNjZWxsYW5lb3VzIFVTQiBvcHRpb25zCiMKQ09ORklHX1VTQl9ERVZJQ0VGUz15
CkNPTkZJR19VU0JfREVWSUNFX0NMQVNTPXkKIyBDT05GSUdfVVNCX0RZTkFNSUNfTUlOT1JTIGlz
IG5vdCBzZXQKQ09ORklHX1VTQl9TVVNQRU5EPXkKIyBDT05GSUdfVVNCX09URyBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9PVEdfV0hJVEVMSVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX09UR19C
TEFDS0xJU1RfSFVCIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9NT049eQojIENPTkZJR19VU0JfV1VT
QiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9XVVNCX0NCQUYgaXMgbm90IHNldAoKIwojIFVTQiBI
b3N0IENvbnRyb2xsZXIgRHJpdmVycwojCiMgQ09ORklHX1VTQl9DNjdYMDBfSENEIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX0VIQ0lfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX09YVTIxMEhQ
X0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxMTZYX0hDRCBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9JU1AxNzYwX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxMzYyX0hDRCBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9PSENJX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9T
TDgxMV9IQ0QgaXMgbm90IHNldAojIENPTkZJR19VU0JfUjhBNjY1OTdfSENEIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX0hXQV9IQ0QgaXMgbm90IHNldAojIENPTkZJR19VU0JfTVVTQl9IRFJDIGlz
IG5vdCBzZXQKCiMKIyBVU0IgRGV2aWNlIENsYXNzIGRyaXZlcnMKIwojIENPTkZJR19VU0JfQUNN
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1BSSU5URVIgaXMgbm90IHNldApDT05GSUdfVVNCX1dE
TT15CiMgQ09ORklHX1VTQl9UTUMgaXMgbm90IHNldAoKIwojIE5PVEU6IFVTQl9TVE9SQUdFIGRl
cGVuZHMgb24gU0NTSSBidXQgQkxLX0RFVl9TRCBtYXkKIwoKIwojIGFsc28gYmUgbmVlZGVkOyBz
ZWUgVVNCX1NUT1JBR0UgSGVscCBmb3IgbW9yZSBpbmZvCiMKQ09ORklHX1VTQl9TVE9SQUdFPXkK
IyBDT05GSUdfVVNCX1NUT1JBR0VfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFH
RV9SRUFMVEVLIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfREFUQUZBQiBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0ZSRUVDT00gaXMgbm90IHNldAojIENPTkZJR19VU0Jf
U1RPUkFHRV9JU0QyMDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9VU0JBVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX1NERFIwOSBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9TVE9SQUdFX1NERFI1NSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0pVTVBTSE9U
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfQUxBVURBIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NUT1JBR0VfT05FVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9L
QVJNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0NZUFJFU1NfQVRBQ0IgaXMgbm90
IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9FTkVfVUI2MjUwIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX1VBUyBpcyBub3Qgc2V0CkNPTkZJR19VU0JfTElCVVNVQUw9eQoKIwojIFVTQiBJbWFnaW5n
IGRldmljZXMKIwojIENPTkZJR19VU0JfTURDODAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX01J
Q1JPVEVLIGlzIG5vdCBzZXQKCiMKIyBVU0IgcG9ydCBkcml2ZXJzCiMKIyBDT05GSUdfVVNCX1NF
UklBTCBpcyBub3Qgc2V0CgojCiMgVVNCIE1pc2NlbGxhbmVvdXMgZHJpdmVycwojCiMgQ09ORklH
X1VTQl9FTUk2MiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9FTUkyNiBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9BRFVUVVggaXMgbm90IHNldAojIENPTkZJR19VU0JfU0VWU0VHIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1JJTzUwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRUdPVE9XRVIgaXMg
bm90IHNldAojIENPTkZJR19VU0JfTENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0xFRCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9DWVBSRVNTX0NZN0M2MyBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9DWVRIRVJNIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lETU9VU0UgaXMgbm90IHNldAojIENP
TkZJR19VU0JfRlRESV9FTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0FQUExFRElTUExBWSBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9UUkFOQ0VW
SUJSQVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JT1dBUlJJT1IgaXMgbm90IHNldApDT05G
SUdfVVNCX1RFU1Q9eQojIENPTkZJR19VU0JfSVNJR0hURlcgaXMgbm90IHNldAojIENPTkZJR19V
U0JfWVVSRVggaXMgbm90IHNldApDT05GSUdfVVNCX0dBREdFVD15CkNPTkZJR19VU0JfR0FER0VU
X0RFQlVHPXkKQ09ORklHX1VTQl9HQURHRVRfREVCVUdfRklMRVM9eQpDT05GSUdfVVNCX0dBREdF
VF9ERUJVR19GUz15CkNPTkZJR19VU0JfR0FER0VUX1ZCVVNfRFJBVz0yCkNPTkZJR19VU0JfR0FE
R0VUX1NFTEVDVEVEPXkKQ09ORklHX1VTQl9HQURHRVRfRlVTQjMwMD15CkNPTkZJR19VU0JfRlVT
QjMwMD15CiMgQ09ORklHX1VTQl9HQURHRVRfT01BUCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9H
QURHRVRfUjhBNjY1OTcgaXMgbm90IHNldAojIENPTkZJR19VU0JfR0FER0VUX1BYQV9VMk8gaXMg
bm90IHNldAojIENPTkZJR19VU0JfR0FER0VUX002NjU5MiBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9HQURHRVRfRFVNTVlfSENEIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9HQURHRVRfRFVBTFNQRUVE
PXkKQ09ORklHX1VTQl9aRVJPPW0KIyBDT05GSUdfVVNCX0FVRElPIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX0VUSCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HX05DTSBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9HQURHRVRGUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9GVU5DVElPTkZTIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0ZJTEVfU1RPUkFHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9N
QVNTX1NUT1JBR0UgaXMgbm90IHNldAojIENPTkZJR19VU0JfR19TRVJJQUwgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfTUlESV9HQURHRVQgaXMgbm90IHNldAojIENPTkZJR19VU0JfR19QUklOVEVS
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NEQ19DT01QT1NJVEUgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfR19NVUxUSSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HX0hJRCBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9HX0RCR1AgaXMgbm90IHNldAoKIwojIE9URyBhbmQgcmVsYXRlZCBpbmZyYXN0
cnVjdHVyZQojCiMgQ09ORklHX1VTQl9HUElPX1ZCVVMgaXMgbm90IHNldAojIENPTkZJR19JU1Ax
MzAxX09NQVAgaXMgbm90IHNldAojIENPTkZJR19VU0JfVUxQSSBpcyBub3Qgc2V0CiMgQ09ORklH
X1RXTDYwMzBfVVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfTk9QX1VTQl9YQ0VJViBpcyBub3Qgc2V0
CkNPTkZJR19NTUM9eQojIENPTkZJR19NTUNfREVCVUcgaXMgbm90IHNldApDT05GSUdfTU1DX1VO
U0FGRV9SRVNVTUU9eQojIENPTkZJR19NTUNfQ0xLR0FURSBpcyBub3Qgc2V0CgojCiMgTU1DL1NE
L1NESU8gQ2FyZCBEcml2ZXJzCiMKQ09ORklHX01NQ19CTE9DSz15CkNPTkZJR19NTUNfQkxPQ0tf
TUlOT1JTPTgKQ09ORklHX01NQ19CTE9DS19CT1VOQ0U9eQpDT05GSUdfU0RJT19VQVJUPXkKIyBD
T05GSUdfTU1DX1RFU1QgaXMgbm90IHNldAoKIwojIE1NQy9TRC9TRElPIEhvc3QgQ29udHJvbGxl
ciBEcml2ZXJzCiMKIyBDT05GSUdfTU1DX1NESENJIGlzIG5vdCBzZXQKQ09ORklHX01NQ19PTUFQ
PXkKQ09ORklHX01NQ19PTUFQX0hTPXkKIyBDT05GSUdfTU1DX1NQSSBpcyBub3Qgc2V0CiMgQ09O
RklHX01NQ19EVyBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19WVUIzMDAgaXMgbm90IHNldAojIENP
TkZJR19NTUNfVVNIQyBpcyBub3Qgc2V0CiMgQ09ORklHX01FTVNUSUNLIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVXX0xFRFMgaXMgbm90IHNldAojIENPTkZJR19ORkNfREVWSUNFUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0FDQ0VTU0lCSUxJVFkgaXMgbm90IHNldApDT05GSUdfUlRDX0xJQj15CkNPTkZJ
R19SVENfQ0xBU1M9eQpDT05GSUdfUlRDX0hDVE9TWVM9eQpDT05GSUdfUlRDX0hDVE9TWVNfREVW
SUNFPSJydGMwIgojIENPTkZJR19SVENfREVCVUcgaXMgbm90IHNldAoKIwojIFJUQyBpbnRlcmZh
Y2VzCiMKQ09ORklHX1JUQ19JTlRGX1NZU0ZTPXkKQ09ORklHX1JUQ19JTlRGX1BST0M9eQpDT05G
SUdfUlRDX0lOVEZfREVWPXkKIyBDT05GSUdfUlRDX0lOVEZfREVWX1VJRV9FTVVMIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUlRDX0RSVl9URVNUIGlzIG5vdCBzZXQKCiMKIyBJMkMgUlRDIGRyaXZlcnMK
IwojIENPTkZJR19SVENfRFJWX0RTMTMwNyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMx
Mzc0IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE2NzIgaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX0RTMzIzMiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTUFYNjkwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlM1QzM3MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19E
UlZfSVNMMTIwOCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfSVNMMTIwMjIgaXMgbm90IHNl
dAojIENPTkZJR19SVENfRFJWX1gxMjA1IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9QQ0Y4
NTYzIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9QQ0Y4NTgzIGlzIG5vdCBzZXQKIyBDT05G
SUdfUlRDX0RSVl9NNDFUODAgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0JRMzJLIGlzIG5v
dCBzZXQKQ09ORklHX1JUQ19EUlZfVFdMOTIzMzA9eQojIENPTkZJR19SVENfRFJWX1RXTDQwMzAg
aXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1MzNTM5MEEgaXMgbm90IHNldAojIENPTkZJR19S
VENfRFJWX0ZNMzEzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlg4NTgxIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUlRDX0RSVl9SWDgwMjUgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0VN
MzAyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlYzMDI5QzIgaXMgbm90IHNldAoKIwoj
IFNQSSBSVEMgZHJpdmVycwojCiMgQ09ORklHX1JUQ19EUlZfTTQxVDkzIGlzIG5vdCBzZXQKIyBD
T05GSUdfUlRDX0RSVl9NNDFUOTQgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTMwNSBp
cyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxMzkwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRD
X0RSVl9NQVg2OTAyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9SOTcwMSBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfUlM1QzM0OCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMz
MjM0IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9QQ0YyMTIzIGlzIG5vdCBzZXQKCiMKIyBQ
bGF0Zm9ybSBSVEMgZHJpdmVycwojCiMgQ09ORklHX1JUQ19EUlZfQ01PUyBpcyBub3Qgc2V0CiMg
Q09ORklHX1JUQ19EUlZfRFMxMjg2IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE1MTEg
aXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTU1MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
Q19EUlZfRFMxNzQyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9TVEsxN1RBOCBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUQ19EUlZfTTQ4VDg2IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9N
NDhUMzUgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX000OFQ1OSBpcyBub3Qgc2V0CiMgQ09O
RklHX1JUQ19EUlZfTVNNNjI0MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfQlE0ODAyIGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9SUDVDMDEgaXMgbm90IHNldAojIENPTkZJR19SVENf
RFJWX1YzMDIwIGlzIG5vdCBzZXQKCiMKIyBvbi1DUFUgUlRDIGRyaXZlcnMKIwojIENPTkZJR19E
TUFERVZJQ0VTIGlzIG5vdCBzZXQKIyBDT05GSUdfQVVYRElTUExBWSBpcyBub3Qgc2V0CiMgQ09O
RklHX1VJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NUQUdJTkcgaXMgbm90IHNldApDT05GSUdfQ0xL
REVWX0xPT0tVUD15CiMgQ09ORklHX0hXU1BJTkxPQ0sgaXMgbm90IHNldAoKIwojIEZpbGUgc3lz
dGVtcwojCkNPTkZJR19FWFQyX0ZTPXkKIyBDT05GSUdfRVhUMl9GU19YQVRUUiBpcyBub3Qgc2V0
CiMgQ09ORklHX0VYVDJfRlNfWElQIGlzIG5vdCBzZXQKQ09ORklHX0VYVDNfRlM9eQpDT05GSUdf
RVhUM19ERUZBVUxUU19UT19PUkRFUkVEPXkKIyBDT05GSUdfRVhUM19GU19YQVRUUiBpcyBub3Qg
c2V0CiMgQ09ORklHX0VYVDRfRlMgaXMgbm90IHNldApDT05GSUdfSkJEPXkKIyBDT05GSUdfSkJE
X0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVJU0VSRlNfRlMgaXMgbm90IHNldAojIENPTkZJ
R19KRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19YRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19H
RlMyX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQlRSRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19O
SUxGUzJfRlMgaXMgbm90IHNldApDT05GSUdfRlNfUE9TSVhfQUNMPXkKQ09ORklHX0ZJTEVfTE9D
S0lORz15CkNPTkZJR19GU05PVElGWT15CkNPTkZJR19ETk9USUZZPXkKQ09ORklHX0lOT1RJRllf
VVNFUj15CiMgQ09ORklHX0ZBTk9USUZZIGlzIG5vdCBzZXQKQ09ORklHX1FVT1RBPXkKIyBDT05G
SUdfUVVPVEFfTkVUTElOS19JTlRFUkZBQ0UgaXMgbm90IHNldApDT05GSUdfUFJJTlRfUVVPVEFf
V0FSTklORz15CiMgQ09ORklHX1FVT1RBX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1FVT1RBX1RS
RUU9eQojIENPTkZJR19RRk1UX1YxIGlzIG5vdCBzZXQKQ09ORklHX1FGTVRfVjI9eQpDT05GSUdf
UVVPVEFDVEw9eQojIENPTkZJR19BVVRPRlM0X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfRlVTRV9G
UyBpcyBub3Qgc2V0CgojCiMgQ2FjaGVzCiMKIyBDT05GSUdfRlNDQUNIRSBpcyBub3Qgc2V0Cgoj
CiMgQ0QtUk9NL0RWRCBGaWxlc3lzdGVtcwojCiMgQ09ORklHX0lTTzk2NjBfRlMgaXMgbm90IHNl
dAojIENPTkZJR19VREZfRlMgaXMgbm90IHNldAoKIwojIERPUy9GQVQvTlQgRmlsZXN5c3RlbXMK
IwpDT05GSUdfRkFUX0ZTPXkKQ09ORklHX01TRE9TX0ZTPXkKQ09ORklHX1ZGQVRfRlM9eQpDT05G
SUdfRkFUX0RFRkFVTFRfQ09ERVBBR0U9NDM3CkNPTkZJR19GQVRfREVGQVVMVF9JT0NIQVJTRVQ9
Imlzbzg4NTktMSIKIyBDT05GSUdfTlRGU19GUyBpcyBub3Qgc2V0CgojCiMgUHNldWRvIGZpbGVz
eXN0ZW1zCiMKQ09ORklHX1BST0NfRlM9eQpDT05GSUdfUFJPQ19TWVNDVEw9eQpDT05GSUdfUFJP
Q19QQUdFX01PTklUT1I9eQpDT05GSUdfU1lTRlM9eQpDT05GSUdfVE1QRlM9eQojIENPTkZJR19U
TVBGU19QT1NJWF9BQ0wgaXMgbm90IHNldAojIENPTkZJR19UTVBGU19YQVRUUiBpcyBub3Qgc2V0
CiMgQ09ORklHX0hVR0VUTEJfUEFHRSBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTkZJR0ZTX0ZTIGlz
IG5vdCBzZXQKQ09ORklHX01JU0NfRklMRVNZU1RFTVM9eQojIENPTkZJR19BREZTX0ZTIGlzIG5v
dCBzZXQKIyBDT05GSUdfQUZGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0VDUllQVF9GUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hGU1BMVVNfRlMgaXMg
bm90IHNldAojIENPTkZJR19CRUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQkZTX0ZTIGlzIG5v
dCBzZXQKIyBDT05GSUdfRUZTX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0pGRlMyX0ZTPXkKQ09ORklH
X0pGRlMyX0ZTX0RFQlVHPTAKQ09ORklHX0pGRlMyX0ZTX1dSSVRFQlVGRkVSPXkKIyBDT05GSUdf
SkZGUzJfRlNfV0JVRl9WRVJJRlkgaXMgbm90IHNldApDT05GSUdfSkZGUzJfU1VNTUFSWT15CkNP
TkZJR19KRkZTMl9GU19YQVRUUj15CkNPTkZJR19KRkZTMl9GU19QT1NJWF9BQ0w9eQpDT05GSUdf
SkZGUzJfRlNfU0VDVVJJVFk9eQpDT05GSUdfSkZGUzJfQ09NUFJFU1NJT05fT1BUSU9OUz15CkNP
TkZJR19KRkZTMl9aTElCPXkKQ09ORklHX0pGRlMyX0xaTz15CkNPTkZJR19KRkZTMl9SVElNRT15
CkNPTkZJR19KRkZTMl9SVUJJTj15CiMgQ09ORklHX0pGRlMyX0NNT0RFX05PTkUgaXMgbm90IHNl
dApDT05GSUdfSkZGUzJfQ01PREVfUFJJT1JJVFk9eQojIENPTkZJR19KRkZTMl9DTU9ERV9TSVpF
IGlzIG5vdCBzZXQKIyBDT05GSUdfSkZGUzJfQ01PREVfRkFWT1VSTFpPIGlzIG5vdCBzZXQKQ09O
RklHX1VCSUZTX0ZTPXkKIyBDT05GSUdfVUJJRlNfRlNfWEFUVFIgaXMgbm90IHNldAojIENPTkZJ
R19VQklGU19GU19BRFZBTkNFRF9DT01QUiBpcyBub3Qgc2V0CkNPTkZJR19VQklGU19GU19MWk89
eQpDT05GSUdfVUJJRlNfRlNfWkxJQj15CiMgQ09ORklHX1VCSUZTX0ZTX0RFQlVHIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTE9HRlMgaXMgbm90IHNldApDT05GSUdfQ1JBTUZTPXkKIyBDT05GSUdfU1FV
QVNIRlMgaXMgbm90IHNldAojIENPTkZJR19WWEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlO
SVhfRlMgaXMgbm90IHNldAojIENPTkZJR19PTUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSFBG
U19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1FOWDRGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JP
TUZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfUFNUT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lT
Vl9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VGU19GUyBpcyBub3Qgc2V0CkNPTkZJR19ORVRXT1JL
X0ZJTEVTWVNURU1TPXkKQ09ORklHX05GU19GUz15CkNPTkZJR19ORlNfVjM9eQpDT05GSUdfTkZT
X1YzX0FDTD15CkNPTkZJR19ORlNfVjQ9eQojIENPTkZJR19ORlNfVjRfMSBpcyBub3Qgc2V0CkNP
TkZJR19ST09UX05GUz15CiMgQ09ORklHX05GU19VU0VfTEVHQUNZX0ROUyBpcyBub3Qgc2V0CkNP
TkZJR19ORlNfVVNFX0tFUk5FTF9ETlM9eQojIENPTkZJR19ORlNfVVNFX05FV19JRE1BUFBFUiBp
cyBub3Qgc2V0CiMgQ09ORklHX05GU0QgaXMgbm90IHNldApDT05GSUdfTE9DS0Q9eQpDT05GSUdf
TE9DS0RfVjQ9eQpDT05GSUdfTkZTX0FDTF9TVVBQT1JUPXkKQ09ORklHX05GU19DT01NT049eQpD
T05GSUdfU1VOUlBDPXkKQ09ORklHX1NVTlJQQ19HU1M9eQojIENPTkZJR19DRVBIX0ZTIGlzIG5v
dCBzZXQKIyBDT05GSUdfQ0lGUyBpcyBub3Qgc2V0CiMgQ09ORklHX05DUF9GUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0NPREFfRlMgaXMgbm90IHNldAojIENPTkZJR19BRlNfRlMgaXMgbm90IHNldAoK
IwojIFBhcnRpdGlvbiBUeXBlcwojCkNPTkZJR19QQVJUSVRJT05fQURWQU5DRUQ9eQojIENPTkZJ
R19BQ09STl9QQVJUSVRJT04gaXMgbm90IHNldAojIENPTkZJR19PU0ZfUEFSVElUSU9OIGlzIG5v
dCBzZXQKIyBDT05GSUdfQU1JR0FfUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBUklf
UEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFDX1BBUlRJVElPTiBpcyBub3Qgc2V0CkNP
TkZJR19NU0RPU19QQVJUSVRJT049eQojIENPTkZJR19CU0RfRElTS0xBQkVMIGlzIG5vdCBzZXQK
IyBDT05GSUdfTUlOSVhfU1VCUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfU09MQVJJU19Y
ODZfUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfVU5JWFdBUkVfRElTS0xBQkVMIGlzIG5v
dCBzZXQKIyBDT05GSUdfTERNX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NHSV9QQVJU
SVRJT04gaXMgbm90IHNldAojIENPTkZJR19VTFRSSVhfUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBD
T05GSUdfU1VOX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0tBUk1BX1BBUlRJVElPTiBp
cyBub3Qgc2V0CiMgQ09ORklHX0VGSV9QQVJUSVRJT04gaXMgbm90IHNldAojIENPTkZJR19TWVNW
NjhfUEFSVElUSU9OIGlzIG5vdCBzZXQKQ09ORklHX05MUz15CkNPTkZJR19OTFNfREVGQVVMVD0i
aXNvODg1OS0xIgpDT05GSUdfTkxTX0NPREVQQUdFXzQzNz15CiMgQ09ORklHX05MU19DT0RFUEFH
RV83MzcgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfNzc1IGlzIG5vdCBzZXQKIyBD
T05GSUdfTkxTX0NPREVQQUdFXzg1MCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84
NTIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODU1IGlzIG5vdCBzZXQKIyBDT05G
SUdfTkxTX0NPREVQQUdFXzg1NyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjAg
aXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYxIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkxTX0NPREVQQUdFXzg2MiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjMgaXMg
bm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxT
X0NPREVQQUdFXzg2NSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjYgaXMgbm90
IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY5IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NP
REVQQUdFXzkzNiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85NTAgaXMgbm90IHNl
dAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTMyIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQ
QUdFXzk0OSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NzQgaXMgbm90IHNldAoj
IENPTkZJR19OTFNfSVNPODg1OV84IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzEy
NTAgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfMTI1MSBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19BU0NJSSBpcyBub3Qgc2V0CkNPTkZJR19OTFNfSVNPODg1OV8xPXkKIyBDT05GSUdf
TkxTX0lTTzg4NTlfMiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzMgaXMgbm90IHNl
dAojIENPTkZJR19OTFNfSVNPODg1OV80IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlf
NSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzYgaXMgbm90IHNldAojIENPTkZJR19O
TFNfSVNPODg1OV83IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfOSBpcyBub3Qgc2V0
CiMgQ09ORklHX05MU19JU084ODU5XzEzIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlf
MTQgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8xNSBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19LT0k4X1IgaXMgbm90IHNldAojIENPTkZJR19OTFNfS09JOF9VIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkxTX1VURjggaXMgbm90IHNldAoKIwojIEtlcm5lbCBoYWNraW5nCiMKQ09ORklHX1BS
SU5US19USU1FPXkKQ09ORklHX0RFRkFVTFRfTUVTU0FHRV9MT0dMRVZFTD00CkNPTkZJR19FTkFC
TEVfV0FSTl9ERVBSRUNBVEVEPXkKQ09ORklHX0VOQUJMRV9NVVNUX0NIRUNLPXkKQ09ORklHX0ZS
QU1FX1dBUk49MTAyNApDT05GSUdfTUFHSUNfU1lTUlE9eQojIENPTkZJR19TVFJJUF9BU01fU1lN
UyBpcyBub3Qgc2V0CiMgQ09ORklHX1VOVVNFRF9TWU1CT0xTIGlzIG5vdCBzZXQKQ09ORklHX0RF
QlVHX0ZTPXkKIyBDT05GSUdfSEVBREVSU19DSEVDSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVH
X1NFQ1RJT05fTUlTTUFUQ0ggaXMgbm90IHNldApDT05GSUdfREVCVUdfS0VSTkVMPXkKIyBDT05G
SUdfTE9DS1VQX0RFVEVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfSEFSRExPQ0tVUF9ERVRFQ1RP
UiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFVEVDVF9IVU5HX1RBU0sgaXMgbm90IHNldApDT05GSUdf
U0NIRURfREVCVUc9eQpDT05GSUdfU0NIRURTVEFUUz15CkNPTkZJR19USU1FUl9TVEFUUz15CiMg
Q09ORklHX0RFQlVHX09CSkVDVFMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19TTEFCIGlzIG5v
dCBzZXQKIyBDT05GSUdfREVCVUdfS01FTUxFQUsgaXMgbm90IHNldApDT05GSUdfREVCVUdfUFJF
RU1QVD15CiMgQ09ORklHX0RFQlVHX1JUX01VVEVYRVMgaXMgbm90IHNldAojIENPTkZJR19SVF9N
VVRFWF9URVNURVIgaXMgbm90IHNldApDT05GSUdfREVCVUdfU1BJTkxPQ0s9eQpDT05GSUdfREVC
VUdfTVVURVhFUz15CkNPTkZJR19ERUJVR19MT0NLX0FMTE9DPXkKQ09ORklHX1BST1ZFX0xPQ0tJ
Tkc9eQojIENPTkZJR19QUk9WRV9SQ1UgaXMgbm90IHNldAojIENPTkZJR19TUEFSU0VfUkNVX1BP
SU5URVIgaXMgbm90IHNldApDT05GSUdfTE9DS0RFUD15CiMgQ09ORklHX0xPQ0tfU1RBVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RFQlVHX0xPQ0tERVAgaXMgbm90IHNldApDT05GSUdfVFJBQ0VfSVJR
RkxBR1M9eQpDT05GSUdfREVCVUdfU1BJTkxPQ0tfU0xFRVA9eQojIENPTkZJR19ERUJVR19MT0NL
SU5HX0FQSV9TRUxGVEVTVFMgaXMgbm90IHNldApDT05GSUdfU1RBQ0tUUkFDRT15CiMgQ09ORklH
X0RFQlVHX1NUQUNLX1VTQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfS09CSkVDVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RFQlVHX0JVR1ZFUkJPU0UgaXMgbm90IHNldApDT05GSUdfREVCVUdf
SU5GTz15CiMgQ09ORklHX0RFQlVHX0lORk9fUkVEVUNFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0RF
QlVHX1ZNIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfV1JJVEVDT1VOVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0RFQlVHX01FTU9SWV9JTklUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTElTVCBp
cyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfTElTVF9TT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVC
VUdfU0cgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19OT1RJRklFUlMgaXMgbm90IHNldAojIENP
TkZJR19ERUJVR19DUkVERU5USUFMUyBpcyBub3Qgc2V0CiMgQ09ORklHX0JPT1RfUFJJTlRLX0RF
TEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNVX1RPUlRVUkVfVEVTVCBpcyBub3Qgc2V0CkNPTkZJ
R19SQ1VfQ1BVX1NUQUxMX1RJTUVPVVQ9NjAKQ09ORklHX1JDVV9DUFVfU1RBTExfVkVSQk9TRT15
CiMgQ09ORklHX0tQUk9CRVNfU0FOSVRZX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19CQUNLVFJB
Q0VfU0VMRl9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfQkxPQ0tfRVhUX0RFVlQgaXMg
bm90IHNldAojIENPTkZJR19ERUJVR19GT1JDRV9XRUFLX1BFUl9DUFUgaXMgbm90IHNldAojIENP
TkZJR19ERUJVR19QRVJfQ1BVX01BUFMgaXMgbm90IHNldAojIENPTkZJR19MS0RUTSBpcyBub3Qg
c2V0CiMgQ09ORklHX0NQVV9OT1RJRklFUl9FUlJPUl9JTkpFQ1QgaXMgbm90IHNldAojIENPTkZJ
R19GQVVMVF9JTkpFQ1RJT04gaXMgbm90IHNldAojIENPTkZJR19TWVNDVExfU1lTQ0FMTF9DSEVD
SyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1BBR0VBTExPQyBpcyBub3Qgc2V0CkNPTkZJR19O
T1BfVFJBQ0VSPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VSPXkKQ09ORklHX0hBVkVfRlVO
Q1RJT05fR1JBUEhfVFJBQ0VSPXkKQ09ORklHX0hBVkVfRFlOQU1JQ19GVFJBQ0U9eQpDT05GSUdf
SEFWRV9GVFJBQ0VfTUNPVU5UX1JFQ09SRD15CkNPTkZJR19IQVZFX0NfUkVDT1JETUNPVU5UPXkK
Q09ORklHX1JJTkdfQlVGRkVSPXkKQ09ORklHX0VWRU5UX1RSQUNJTkc9eQpDT05GSUdfRVZFTlRf
UE9XRVJfVFJBQ0lOR19ERVBSRUNBVEVEPXkKQ09ORklHX0NPTlRFWFRfU1dJVENIX1RSQUNFUj15
CkNPTkZJR19SSU5HX0JVRkZFUl9BTExPV19TV0FQPXkKQ09ORklHX1RSQUNJTkc9eQpDT05GSUdf
VFJBQ0lOR19TVVBQT1JUPXkKQ09ORklHX0ZUUkFDRT15CiMgQ09ORklHX0ZVTkNUSU9OX1RSQUNF
UiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSUVNPRkZfVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05GSUdf
UFJFRU1QVF9UUkFDRVIgaXMgbm90IHNldAojIENPTkZJR19TQ0hFRF9UUkFDRVIgaXMgbm90IHNl
dAojIENPTkZJR19NSVNTRURfVElNRVJfT0ZGU0VUU19ISVNUIGlzIG5vdCBzZXQKIyBDT05GSUdf
RU5BQkxFX0RFRkFVTFRfVFJBQ0VSUyBpcyBub3Qgc2V0CkNPTkZJR19CUkFOQ0hfUFJPRklMRV9O
T05FPXkKIyBDT05GSUdfUFJPRklMRV9BTk5PVEFURURfQlJBTkNIRVMgaXMgbm90IHNldAojIENP
TkZJR19QUk9GSUxFX0FMTF9CUkFOQ0hFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NUQUNLX1RSQUNF
UiBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfSU9fVFJBQ0UgaXMgbm90IHNldApDT05GSUdf
S1BST0JFX0VWRU5UPXkKIyBDT05GSUdfUklOR19CVUZGRVJfQkVOQ0hNQVJLIGlzIG5vdCBzZXQK
IyBDT05GSUdfRFlOQU1JQ19ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0RNQV9BUElfREVCVUcg
aXMgbm90IHNldAojIENPTkZJR19BVE9NSUM2NF9TRUxGVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NBTVBMRVMgaXMgbm90IHNldApDT05GSUdfSEFWRV9BUkNIX0tHREI9eQojIENPTkZJR19LR0RC
IGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9LU1RSVE9YIGlzIG5vdCBzZXQKIyBDT05GSUdfU1RS
SUNUX0RFVk1FTSBpcyBub3Qgc2V0CkNPTkZJR19BUk1fVU5XSU5EPXkKIyBDT05GSUdfREVCVUdf
VVNFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0xMIGlzIG5vdCBzZXQKIyBDT05GSUdfT0Nf
RVRNIGlzIG5vdCBzZXQKCiMKIyBTZWN1cml0eSBvcHRpb25zCiMKQ09ORklHX0tFWVM9eQojIENP
TkZJR19LRVlTX0RFQlVHX1BST0NfS0VZUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFQ1VSSVRZX0RN
RVNHX1JFU1RSSUNUIGlzIG5vdCBzZXQKQ09ORklHX1NFQ1VSSVRZPXkKIyBDT05GSUdfU0VDVVJJ
VFlGUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFQ1VSSVRZX05FVFdPUksgaXMgbm90IHNldAojIENP
TkZJR19TRUNVUklUWV9QQVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VDVVJJVFlfVE9NT1lPIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VDVVJJVFlfQVBQQVJNT1IgaXMgbm90IHNldAojIENPTkZJR19J
TUEgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9TRUNVUklUWV9EQUM9eQpDT05GSUdfREVGQVVM
VF9TRUNVUklUWT0iIgpDT05GSUdfQ1JZUFRPPXkKCiMKIyBDcnlwdG8gY29yZSBvciBoZWxwZXIK
IwpDT05GSUdfQ1JZUFRPX0FMR0FQST15CkNPTkZJR19DUllQVE9fQUxHQVBJMj15CkNPTkZJR19D
UllQVE9fSEFTSD15CkNPTkZJR19DUllQVE9fSEFTSDI9eQojIENPTkZJR19DUllQVE9fTUFOQUdF
UiBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19NQU5BR0VSMiBpcyBub3Qgc2V0CiMgQ09ORklH
X0NSWVBUT19HRjEyOE1VTCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19OVUxMIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ1JZUFRPX1BDUllQVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19DUllQ
VEQgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQVVUSEVOQyBpcyBub3Qgc2V0CiMgQ09ORklH
X0NSWVBUT19URVNUIGlzIG5vdCBzZXQKCiMKIyBBdXRoZW50aWNhdGVkIEVuY3J5cHRpb24gd2l0
aCBBc3NvY2lhdGVkIERhdGEKIwojIENPTkZJR19DUllQVE9fQ0NNIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1JZUFRPX0dDTSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TRVFJViBpcyBub3Qgc2V0
CgojCiMgQmxvY2sgbW9kZXMKIwojIENPTkZJR19DUllQVE9fQ0JDIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1JZUFRPX0NUUiBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19DVFMgaXMgbm90IHNldAoj
IENPTkZJR19DUllQVE9fRUNCIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0xSVyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NSWVBUT19QQ0JDIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1hUUyBp
cyBub3Qgc2V0CgojCiMgSGFzaCBtb2RlcwojCiMgQ09ORklHX0NSWVBUT19ITUFDIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ1JZUFRPX1hDQkMgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fVk1BQyBp
cyBub3Qgc2V0CgojCiMgRGlnZXN0CiMKQ09ORklHX0NSWVBUT19DUkMzMkM9eQojIENPTkZJR19D
UllQVE9fR0hBU0ggaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fTUQ0IGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX01ENSBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fTUlDSEFFTF9NSUM9eQoj
IENPTkZJR19DUllQVE9fUk1EMTI4IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1JNRDE2MCBp
cyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19STUQyNTYgaXMgbm90IHNldAojIENPTkZJR19DUllQ
VE9fUk1EMzIwIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NIQTEgaXMgbm90IHNldAojIENP
TkZJR19DUllQVE9fU0hBMjU2IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NIQTUxMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19UR1IxOTIgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9f
V1A1MTIgaXMgbm90IHNldAoKIwojIENpcGhlcnMKIwpDT05GSUdfQ1JZUFRPX0FFUz1tCiMgQ09O
RklHX0NSWVBUT19BTlVCSVMgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX0FSQzQ9bQojIENPTkZJ
R19DUllQVE9fQkxPV0ZJU0ggaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQ0FNRUxMSUEgaXMg
bm90IHNldAojIENPTkZJR19DUllQVE9fQ0FTVDUgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9f
Q0FTVDYgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fREVTIGlzIG5vdCBzZXQKIyBDT05GSUdf
Q1JZUFRPX0ZDUllQVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19LSEFaQUQgaXMgbm90IHNl
dAojIENPTkZJR19DUllQVE9fU0FMU0EyMCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TRUVE
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NFUlBFTlQgaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fVEVBIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1RXT0ZJU0ggaXMgbm90IHNldAoK
IwojIENvbXByZXNzaW9uCiMKQ09ORklHX0NSWVBUT19ERUZMQVRFPXkKIyBDT05GSUdfQ1JZUFRP
X1pMSUIgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX0xaTz15CgojCiMgUmFuZG9tIE51bWJlciBH
ZW5lcmF0aW9uCiMKIyBDT05GSUdfQ1JZUFRPX0FOU0lfQ1BSTkcgaXMgbm90IHNldAojIENPTkZJ
R19DUllQVE9fVVNFUl9BUElfSEFTSCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19VU0VSX0FQ
SV9TS0NJUEhFUiBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fSFc9eQojIENPTkZJR19DUllQVE9f
REVWX09NQVBfU0hBTSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19ERVZfT01BUF9BRVMgaXMg
bm90IHNldApDT05GSUdfQklOQVJZX1BSSU5URj15CgojCiMgTGlicmFyeSByb3V0aW5lcwojCkNP
TkZJR19CSVRSRVZFUlNFPXkKQ09ORklHX0NSQ19DQ0lUVD15CkNPTkZJR19DUkMxNj15CkNPTkZJ
R19DUkNfVDEwRElGPXkKQ09ORklHX0NSQ19JVFVfVD15CkNPTkZJR19DUkMzMj15CkNPTkZJR19D
UkM3PXkKQ09ORklHX0xJQkNSQzMyQz15CkNPTkZJR19aTElCX0lORkxBVEU9eQpDT05GSUdfWkxJ
Ql9ERUZMQVRFPXkKQ09ORklHX0xaT19DT01QUkVTUz15CkNPTkZJR19MWk9fREVDT01QUkVTUz15
CiMgQ09ORklHX1haX0RFQyBpcyBub3Qgc2V0CiMgQ09ORklHX1haX0RFQ19CQ0ogaXMgbm90IHNl
dApDT05GSUdfREVDT01QUkVTU19HWklQPXkKQ09ORklHX0hBU19JT01FTT15CkNPTkZJR19IQVNf
SU9QT1JUPXkKQ09ORklHX0hBU19ETUE9eQpDT05GSUdfQ1BVX1JNQVA9eQpDT05GSUdfTkxBVFRS
PXkKQ09ORklHX0dFTkVSSUNfQVRPTUlDNjQ9eQpDT05GSUdfQVZFUkFHRT15Cg==

--_003_45EE9921DD12714AB1D7B7B9D2FE208B0230256D48BFdbde03entti_--
