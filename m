Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab2AJUak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:30:40 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18675 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab2AJUai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:30:38 -0500
Date: Tue, 10 Jan 2012 15:28:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: tj@kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Cc: xen-devel@lists.xensource.com
Subject: Bootup regression introduced by
 7bd0b0f0da3b1ec11cbcc798eb0ef747a1184077 ("memblock: Reimplement memblock
 allocation using reverse free area iterato") in v3.3-rc0
Message-ID: <20120110202838.GA10402@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F0C9FE6.0090,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

With that patch I get this when trying to launch a 4GB xen guest:

kernel="/mnt/lab/latest/vmlinuz"
ramdisk="/mnt/lab/latest/initramfs.cpio.gz"
extra="console=hvc0 debug earlyprintk=xen" 
memory=4096
maxmem=8192
vcpus=4
on_crash="preserve"
vif = [ 'mac=00:0F:4B:00:00:68, bridge=switch' ]
vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1'

If I change the "memory" to be "4000" it or if I revert the
mention git commit it boots. This is what I get with the mentioned
git commit:

(early) [    0.000000] Initializing cgroup subsys cpuset
(early) [    0.000000] Initializing cgroup subsys cpu
(early) [    0.000000] Linux version 3.2.0-04371-g6b3da11 (konrad@phenom.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #2 SMP PREEMPT Tue Jan 10 12:47:50 EST 2012
(early) [    0.000000] Command line: console=hvc0 debug earlyprintk=xen
(early) [    0.000000] Disabled fast string operations
(early) [    0.000000] ACPI in unprivileged domain disabled
(early) [    0.000000] Released 0 pages of unused memory
(early) [    0.000000] Set 0 page(s) to 1-1 mapping
(early) [    0.000000] BIOS-provided physical RAM map:
(early) [    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
(early) [    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
(early) [    0.000000]  Xen: 0000000000100000 - 0000000200800000 (usable)
(early) [    0.000000] bootconsole [xenboot0] enabled
(early) [    0.000000] NX (Execute Disable) protection: active
(early) [    0.000000] DMI not present or invalid.
(early) [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (early) (usable)(early)  ==> (early) (reserved)(early) 
(early) [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (early) (usable)(early) 
(early) [    0.000000] No AGP bridge found
(early) [    0.000000] last_pfn = 0x200800 max_arch_pfn = 0x400000000
(early) [    0.000000] last_pfn = 0x100000 max_arch_pfn = 0x400000000
(early) [    0.000000] initial memory mapped : 0 - 0fbec000
(early) [    0.000000] Base memory trampoline at [ffff88000009b000] 9b000 size 20480
(early) [    0.000000] init_memory_mapping: 0000000000000000-0000000100000000
(early) [    0.000000]  0000000000 - 0100000000 page 4k
(early) [    0.000000] Kernel panic - not syncing: Cannot find space for the kernel page tables
(early) [    0.000000] Pid: 0, comm: swapper Not tainted 3.2.0-04371-g6b3da11 #2
(early) [    0.000000] Call Trace:
(early) [    0.000000]  [<ffffffff8163f230>] panic+0x9b/0x1c9
(early) [    0.000000]  [<ffffffff8163f39f>] ? printk+0x41/0x43
(early) [    0.000000]  [<ffffffff81621462>] init_memory_mapping+0x562/0x590
(early) [    0.000000]  [<ffffffff81af58cb>] setup_arch+0x63a/0xafb
(early) [    0.000000]  [<ffffffff8163f39f>] ? printk+0x41/0x43
(early) [    0.000000]  [<ffffffff81aefbaf>] start_kernel+0xe6/0x408
(early) [    0.000000]  [<ffffffff81aef346>] x86_64_start_reservations+0x131/0x136
(early) [    0.000000]  [<ffffffff81af2b62>] xen_start_kernel+0x60d/0x614

