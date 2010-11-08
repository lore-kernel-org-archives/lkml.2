Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0KHJXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 04:23:16 -0500
Received: from smtp-out-089.synserver.de ([212.40.180.89]:1081 "EHLO
	smtp-out-086.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753894Ab0KHJXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:23:16 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 18151
Date: Mon, 8 Nov 2010 10:18:49 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [kvm.git & 2.6.37-rc1] KVM deadlock with CONFIG_PREEMPT host
Message-ID: <20101108091849.GC3975@arch.trippelsdorf.de>
References: <4CD7BD00.2020703@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD7BD00.2020703@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:04:00AM +0100, Jan Kiszka wrote:
> Hi,
> 
> I'm seeing lock-ups of the QEMU process on kvm.git as well as current
> upstream kernels. This is a backtrace of the hanging VCPU thread:
> 
> [<ffffffff810a27bc>] __stop_cpus+0x184/0x1a7
> [<ffffffff810a286f>] try_stop_cpus+0x40/0x59
> [<ffffffff8103a30c>] synchronize_sched_expedited+0x84/0x9d
> [<ffffffff810715a3>] __synchronize_srcu+0x33/0x72
> [<ffffffff810715f7>] synchronize_srcu_expedited+0x15/0x17
> [<ffffffffa06602ae>] __kvm_set_memory_region+0x6a3/0x782 [kvm]
> [<ffffffffa06603c4>] kvm_set_memory_region+0x37/0x50 [kvm]
> [<ffffffffa0661c30>] kvm_vm_ioctl_set_memory_region+0x18/0x1a [kvm]
> [<ffffffffa0661e5f>] kvm_vm_ioctl+0x22d/0x3b1 [kvm]
> [<ffffffff81143c26>] do_vfs_ioctl+0x5a1/0x5e2
> [<ffffffff81143cbd>] sys_ioctl+0x56/0x79
> [<ffffffff81002df2>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> This issue disappears when disabling CONFIG_PREEMPT on the host.
> According to some rough bisecting, it was imported into kvm.git with
> merge 146d3bb06b. Given that RCU is involved, I also tried
> force-enabling non-preemptible CONFIG_TREE_RCU again, but that made no
> difference as long as PREEMPT is on.
> 
> Can anyone confirm this or does someone have an idea what goes wrong? Of
> course, .config will be provided if required.

This patch should help (,it fixes the problem in my case):
http://article.gmane.org/gmane.linux.kernel/1058018
-- 
Markus
