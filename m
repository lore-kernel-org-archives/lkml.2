Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0FHILV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:11:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab0FHILS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:11:18 -0400
Message-ID: <4C0DFB21.7050309@redhat.com>
Date: Tue, 08 Jun 2010 11:11:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: fix rcu usage warning
References: <4C0DA7D7.5@cn.fujitsu.com>
In-Reply-To: <4C0DA7D7.5@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 05:15 AM, Xiao Guangrong wrote:
> fix:
>
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> include/linux/kvm_host.h:258 invoked rcu_dereference_check() without protection!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 1, debug_locks = 1
> 1 lock held by qemu-system-x86/3796:
>   #0:  (&vcpu->mutex){+.+.+.}, at: [<ffffffffa0217fd8>] vcpu_load+0x1a/0x66 [kvm]
>
> stack backtrace:
> Pid: 3796, comm: qemu-system-x86 Not tainted 2.6.34 #25
> Call Trace:
>   [<ffffffff81070ed1>] lockdep_rcu_dereference+0x9d/0xa5
>   [<ffffffffa0214fdf>] gfn_to_memslot_unaliased+0x65/0xa0 [kvm]
>   [<ffffffffa0216139>] gfn_to_hva+0x22/0x4c [kvm]
>   [<ffffffffa0216217>] kvm_write_guest_page+0x2a/0x7f [kvm]
>   [<ffffffffa0216286>] kvm_clear_guest_page+0x1a/0x1c [kvm]
>   [<ffffffffa0278239>] init_rmode+0x3b/0x180 [kvm_intel]
>   [<ffffffffa02786ce>] vmx_set_cr0+0x350/0x4d3 [kvm_intel]
>   [<ffffffffa02274ff>] kvm_arch_vcpu_ioctl_set_sregs+0x122/0x31a [kvm]
>   [<ffffffffa021859c>] kvm_vcpu_ioctl+0x578/0xa3d [kvm]
>   [<ffffffff8106624c>] ? cpu_clock+0x2d/0x40
>   [<ffffffff810f7d86>] ? fget_light+0x244/0x28e
>   [<ffffffff810709b9>] ? trace_hardirqs_off_caller+0x1f/0x10e
>   [<ffffffff8110501b>] vfs_ioctl+0x32/0xa6
>   [<ffffffff81105597>] do_vfs_ioctl+0x47f/0x4b8
>   [<ffffffff813ae654>] ? sub_preempt_count+0xa3/0xb7
>   [<ffffffff810f7da8>] ? fget_light+0x266/0x28e
>   [<ffffffff810f7c53>] ? fget_light+0x111/0x28e
>   [<ffffffff81105617>] sys_ioctl+0x47/0x6a
>   [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b
>
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

