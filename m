Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab0DUOgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:36:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48098 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab0DUOgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:36:33 -0400
Date: Wed, 21 Apr 2010 07:36:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [BUG] kvm: dereference srcu-protected pointer without
 srcu_read_lock() held
Message-ID: <20100421143630.GC2563@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BCC2543.7050104@cn.fujitsu.com>
 <4BCC295D.1040807@cn.fujitsu.com>
 <4BCC2B9D.8050008@redhat.com>
 <20100420014504.GB17981@amt.cnet>
 <4BCD49C9.8090604@cn.fujitsu.com>
 <20100420222108.GM2628@linux.vnet.ibm.com>
 <4BCEB492.1020902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCEB492.1020902@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 11:17:22AM +0300, Avi Kivity wrote:
> On 04/21/2010 01:21 AM, Paul E. McKenney wrote:
> >
> >>Subject: [PATCH] kvm: add missing srcu_read_lock()
> >>
> >>I got this dmesg due to srcu_read_lock() is missing in
> >>kvm_mmu_notifier_release().
> >>
> >>===================================================
> >>[ INFO: suspicious rcu_dereference_check() usage. ]
> >>---------------------------------------------------
> >>arch/x86/kvm/x86.h:72 invoked rcu_dereference_check() without protection!
> >>
> >>other info that might help us debug this:
> >>
> >>
> >>rcu_scheduler_active = 1, debug_locks = 0
> >>2 locks held by qemu-system-x86/3100:
> >>  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff810d73dc>] __mmu_notifier_release+0x38/0xdf
> >>  #1:  (&(&kvm->mmu_lock)->rlock){+.+...}, at: [<ffffffffa0130a6a>] kvm_mmu_zap_all+0x21/0x5e [kvm]
> >>
> >>stack backtrace:
> >>Pid: 3100, comm: qemu-system-x86 Not tainted 2.6.34-rc3-22949-gbc8a97a-dirty #2
> >>Call Trace:
> >>  [<ffffffff8106afd9>] lockdep_rcu_dereference+0xaa/0xb3
> >>  [<ffffffffa0123a89>] unalias_gfn+0x56/0xab [kvm]
> >>  [<ffffffffa0119600>] gfn_to_memslot+0x16/0x25 [kvm]
> >>  [<ffffffffa012ffca>] gfn_to_rmap+0x17/0x6e [kvm]
> >>  [<ffffffffa01300c1>] rmap_remove+0xa0/0x19d [kvm]
> >>  [<ffffffffa0130649>] kvm_mmu_zap_page+0x109/0x34d [kvm]
> >>  [<ffffffffa0130a7e>] kvm_mmu_zap_all+0x35/0x5e [kvm]
> >>  [<ffffffffa0122870>] kvm_arch_flush_shadow+0x16/0x22 [kvm]
> >>  [<ffffffffa01189e0>] kvm_mmu_notifier_release+0x15/0x17 [kvm]
> >>  [<ffffffff810d742c>] __mmu_notifier_release+0x88/0xdf
> >>  [<ffffffff810d73dc>] ? __mmu_notifier_release+0x38/0xdf
> >>  [<ffffffff81040848>] ? exit_mm+0xe0/0x115
> >>  [<ffffffff810c2cb0>] exit_mmap+0x2c/0x17e
> >>  [<ffffffff8103c472>] mmput+0x2d/0xd4
> >>  [<ffffffff81040870>] exit_mm+0x108/0x115
> >>[...]
> >Queued, thank you, Lai!
> 
> Paul, I'd like to merge this via the kvm tree.

Very good, I have removed both of these kvm patches.  They are yours!  ;-)

							Thanx, Paul
