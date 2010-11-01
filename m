Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab0KAMkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:40:07 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:57092 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab0KAMkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:40:04 -0400
Message-ID: <4CCEB51C.7010901@web.de>
Date: Mon, 01 Nov 2010 13:39:56 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Eric Paris <eparis@redhat.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG: using smp_processor_id() in preemptible arch_trigger_all_cpu_backtrace_handler
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig530381DD8DB381088D0472C6"
X-Provags-ID: V01U2FsdGVkX18veHIWvvSBi7+nlgdNbkINstZhqJ7rNhu0XhCe
	IYVxzcnuR3FzI7jzE194z6YAkQ7fEaOYg/W2+ChXzUCU1WJa+N
	bh2pJXYOU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig530381DD8DB381088D0472C6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

I was getting this BUG while running into a GPF:

BUG: using smp_processor_id() in preemptible [00000000] code: qemu-system=
-x86/2248
caller is arch_trigger_all_cpu_backtrace_handler+0x1d/0xf7
Pid: 2248, comm: qemu-system-x86 Not tainted 2.6.36+ #12
Call Trace:
[<ffffffff81203194>] debug_smp_processor_id+0xd8/0xf4
[<ffffffff813803ab>] arch_trigger_all_cpu_backtrace_handler+0x1d/0xf7
[<ffffffff81381e64>] notifier_call_chain+0xa4/0xdb
[<ffffffff81381efe>] __atomic_notifier_call_chain+0x63/0x95
[<ffffffff81381e9b>] ? __atomic_notifier_call_chain+0x0/0x95
[<ffffffff81381cfb>] ? sub_preempt_count+0x97/0xaa
[<ffffffff8121de8c>] ? pfn_to_dma_pte+0x73/0x190
[<ffffffff81381f44>] atomic_notifier_call_chain+0x14/0x16
[<ffffffff81381f74>] notify_die+0x2e/0x30
[<ffffffff8137f498>] do_general_protection+0x121/0x142
[<ffffffff8137ec04>] ? irq_return+0x0/0xc
[<ffffffff8137ede5>] general_protection+0x25/0x30
[<ffffffff8121de8c>] ? pfn_to_dma_pte+0x73/0x190
[<ffffffff8121df5b>] ? pfn_to_dma_pte+0x142/0x190
[<ffffffff8121dfbe>] intel_iommu_iova_to_phys+0x15/0x2a
[<ffffffff812a9573>] iommu_iova_to_phys+0x13/0x15
[<ffffffffa04e91d0>] kvm_iommu_map_pages+0x77/0x194 [kvm]
[<ffffffff8111404d>] ? __vmalloc_node+0x86/0x9b
[<ffffffffa04e30e2>] __kvm_set_memory_region+0x4e5/0x787 [kvm]
[<ffffffff81081ee8>] ? mark_held_locks+0x50/0x72
[<ffffffff8137c983>] ? mutex_lock_nested+0x325/0x34d
[<ffffffffa04e33bb>] kvm_set_memory_region+0x37/0x50 [kvm]
[<ffffffffa04e4c15>] kvm_vm_ioctl_set_memory_region+0x18/0x1a [kvm]
[<ffffffffa04e4e44>] kvm_vm_ioctl+0x22d/0x3b1 [kvm]
[<ffffffff811355aa>] ? fget_light+0x17b/0x31f
[<ffffffff81143bd7>] do_vfs_ioctl+0x4c6/0x507
[<ffffffff81135732>] ? fget_light+0x303/0x31f
[<ffffffff811355aa>] ? fget_light+0x17b/0x31f
[<ffffffff8137ebb9>] ? retint_swapgs+0x13/0x1b
[<ffffffff81143c6e>] sys_ioctl+0x56/0x7c
[<ffffffff81002df2>] system_call_fastpath+0x16/0x1b

I guess this is not intended to trigger here, specifically as it showed
up first and may be misinterpreted as the core of the issue.

Jan


--------------enig530381DD8DB381088D0472C6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzOtSEACgkQitSsb3rl5xRf0QCgyRCabhCE513+t97hklkaLJ+T
tcUAoJ0gTJScQu1yBlgRakBvlRnle+98
=LHz7
-----END PGP SIGNATURE-----

--------------enig530381DD8DB381088D0472C6--
