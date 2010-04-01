Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0DABGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:06:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:4929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100Ab0DABGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:06:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,344,1267430400"; 
   d="scan'208";a="554004694"
Subject: Re: BUG: null pointer deref in dmar_ir_support
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Jan.Grossmann@kielnet.net" <Jan.Grossmann@kielnet.net>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Woodhouse, David" <david.woodhouse@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "Han, Weidong" <weidong.han@intel.com>,
       "Song, Youquan" <youquan.song@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <4BB395B0.6090007@kielnet.net>
References: <4BAD1676.9090704@kielnet.net>
	 <1270057394.2866.9.camel@sbs-t61.sc.intel.com>
	 <4BB395B0.6090007@kielnet.net>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 31 Mar 2010 18:04:47 -0700
Message-Id: <1270083887.7835.78.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Problem is in the x86 portion of the code, so copying x86 folks for
their attention]

On Wed, 2010-03-31 at 11:34 -0700, Jan.Grossmann@kielnet.net wrote:
> >> [    0.144012] BUG: unable to handle kernel NULL pointer dereference at 
> >> 0000000000000025
> >> [    0.148000] IP: [<ffffffff81199c96>] dmar_ir_support+0xb/0x14
> >> [    0.148000] PGD 0
> >> [    0.148000] Oops: 0000 [#1] SMP
> >> [    0.148000] last sysfs file:
> >> [    0.148000] CPU 0
> >> [    0.148000] Modules linked in:
> >> [    0.148000]
> >> [    0.148000] Pid: 1, comm: swapper Not tainted 2.6.34-rc2 #4 A8N-SLI 
> >> Premium/System Product Name
> >> [    0.148000] RIP: 0010:[<ffffffff81199c96>]  [<ffffffff81199c96>] 
> >> dmar_ir_support+0xb/0x14
> >> [    0.148000] RSP: 0018:ffff88007fbe3e30  EFLAGS: 00010046
> >> [    0.148000] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
> >> 000000000000004c
> >> [    0.148000] RDX: ffffffff81762338 RSI: 0000000000000046 RDI: 
> >> 0000000000000010
> >> [    0.148000] RBP: ffff88007fbe3e30 R08: 0000000000000002 R09: 
> >> 000000000000000a
> >> [    0.148000] R10: 0000000000000005 R11: 0000000000000000 R12: 
> >> 0000000000000010
> >> [    0.148000] R13: 0000000000000246 R14: 0000000000000000 R15: 
> >> 000000000000e850
> >> [    0.148000] FS:  0000000000000000(0000) GS:ffff880001a00000(0000) 
> >> knlGS:0000000000000000
> >> [    0.148000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >> [    0.148000] CR2: 0000000000000025 CR3: 0000000001625000 CR4: 
> >> 00000000000006f0
> >> [    0.148000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> >> 0000000000000000
> >> [    0.148000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
> >> 0000000000000400
> >> [    0.148000] Process swapper (pid: 1, threadinfo ffff88007fbe2000, 
> >> task ffff88007fbde740)
> >> [    0.148000] Stack:
> >> [    0.148000]  ffff88007fbe3e40 ffffffff816d1f01 ffff88007fbe3e50 
> >> ffffffff816b7fa6
> >> [    0.148000] <0> ffff88007fbe3ea0 ffffffff816b8095 ffff88007fbe3ec0 
> >> ffffffff8130122e
> >> [    0.148000] <0> ffff880000000008 ffff88007fbe3ed0 ffffffff8168ec20 
> >> 0000000000000200
> >> [    0.148000] Call Trace:
> >> [    0.148000]  [<ffffffff816d1f01>] intr_remapping_supported+0x12/0x45
> >> [    0.148000]  [<ffffffff816b7fa6>] enable_IR+0x9/0x5d
> >> [    0.148000]  [<ffffffff816b8095>] enable_IR_x2apic+0x9b/0x1b6
> >> [    0.148000]  [<ffffffff8130122e>] ? printk+0x3c/0x3e
> >> [    0.148000]  [<ffffffff816b81f7>] APIC_init_uniprocessor+0x47/0x105
> >> [    0.148000]  [<ffffffff816b62cf>] native_smp_prepare_cpus+0x190/0x365
> >> [    0.148000]  [<ffffffff816ab5f5>] kernel_init+0x71/0x1f0
> >> [    0.148000]  [<ffffffff810097e4>] kernel_thread_helper+0x4/0x10
> >> [    0.148000]  [<ffffffff816ab584>] ? kernel_init+0x0/0x1f0
> >> [    0.148000]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
> >> [    0.148000] Code: ff c7 06 00 00 00 00 48 8b 04 fd 80 ba 42 81 eb 0d 
> >> c7 06 02 00 00 00 48 c7 c0 e8 30 4a 81 c9 c3 48 8b 05 0e 4c 56 00 55 48 
> >> 89 e5 <0f> b6 40 25 c9 83 e0 01 c3 55 48 89 e5 e8 7c 8f 16 00 c9 c3 55
> >> [    0.148000] RIP  [<ffffffff81199c96>] dmar_ir_support+0xb/0x14
> >> [    0.148000]  RSP <ffff88007fbe3e30>
> >> [    0.148000] CR2: 0000000000000025
> >>     

Jan, Problem is that your system doesn't have proper SMP tables and we
were doing enable_IR_x2apic() twice finally leading to this panic. Can
you please check if the appended patch fixes your issue? Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: fix calling enable_IR_x2apic() twice with SMP kernel on !SMP boards

Jan Grossmann reported kernel boot panic while booting SMP kernel on his
system with a single core cpu. SMP kernels call enable_IR_x2apic() from
native_smp_prepare_cpus() and on platforms where the kernel doesn't
find SMP configuration we ended up again calling enable_IR_x2apic() from the
APIC_init_uniprocessor() call in the smp_sanity_check(). Thus leading to
kernel panic.

Don't call enable_IR_x2apic() and default_setup_apic_routing()
from APIC_init_uniprocessor() in CONFIG_SMP case.

Reported-by: Jan.Grossmann@kielnet.net
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org [2.6.32, 2.6.33]
---

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 00187f1..e5a4a1e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1640,8 +1640,10 @@ int __init APIC_init_uniprocessor(void)
 	}
 #endif
 
+#ifndef CONFIG_SMP
 	enable_IR_x2apic();
 	default_setup_apic_routing();
+#endif
 
 	verify_local_APIC();
 	connect_bsp_APIC();


