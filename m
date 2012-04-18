Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2DRC61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:58:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab2DRC60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:58:26 -0400
Date: Tue, 17 Apr 2012 22:58:22 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: avi@redhat.com
Subject: kvm_set_shared_msr using smp_processor_id() in preemptible code
Message-ID: <20120418025822.GA22660@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, avi@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see a bunch of these when I start a kvm guest using Linus' current tree.

	Dave

BUG: using smp_processor_id() in preemptible [00000000] code: qemu-kvm/22713
caller is kvm_set_shared_msr+0x32/0xa0 [kvm]
Pid: 22713, comm: qemu-kvm Not tainted 3.4.0-rc3+ #39
Call Trace:
 [<ffffffff8131fa82>] debug_smp_processor_id+0xe2/0x100
 [<ffffffffa0328ae2>] kvm_set_shared_msr+0x32/0xa0 [kvm]
 [<ffffffffa03a103b>] vmx_set_msr+0x28b/0x2d0 [kvm_intel]
 [<ffffffffa03a5f1a>] handle_wrmsr+0x4a/0x310 [kvm_intel]
 [<ffffffffa03a7638>] vmx_handle_exit+0xc8/0x6f0 [kvm_intel]
 [<ffffffffa03354f6>] kvm_arch_vcpu_ioctl_run+0x616/0x18c0 [kvm]
 [<ffffffffa0335445>] ? kvm_arch_vcpu_ioctl_run+0x565/0x18c0 [kvm]
 [<ffffffff8164dc47>] ? mutex_lock_nested+0x2c7/0x3c0
 [<ffffffffa031b5ca>] ? vcpu_load+0x1a/0xb0 [kvm]
 [<ffffffffa031bb35>] kvm_vcpu_ioctl+0x465/0x780 [kvm]
 [<ffffffff81078ef9>] ? creds_are_invalid+0x29/0x60
 [<ffffffff812aec85>] ? inode_has_perm+0x35/0xa0
 [<ffffffff811ba5e8>] do_vfs_ioctl+0x98/0x570
 [<ffffffff811bab51>] sys_ioctl+0x91/0xa0
 [<ffffffff81659692>] system_call_fastpath+0x16/0x1b

BUG: using smp_processor_id() in preemptible [00000000] code: qemu-kvm/22713
caller is user_return_notifier_register+0x2f/0x70
Pid: 22713, comm: qemu-kvm Not tainted 3.4.0-rc3+ #39
Call Trace:
 [<ffffffff8131fa82>] debug_smp_processor_id+0xe2/0x100
 [<ffffffff81134eaf>] user_return_notifier_register+0x2f/0x70
 [<ffffffffa0328b47>] kvm_set_shared_msr+0x97/0xa0 [kvm]
 [<ffffffffa03a103b>] vmx_set_msr+0x28b/0x2d0 [kvm_intel]
 [<ffffffffa03248e0>] ? kvm_enable_efer_bits+0x20/0x20 [kvm]
 [<ffffffffa03248f9>] do_set_msr+0x19/0x20 [kvm]
 [<ffffffffa032be51>] msr_io+0x101/0x220 [kvm]
 [<ffffffffa032bdcf>] ? msr_io+0x7f/0x220 [kvm]
 [<ffffffffa03307fa>] kvm_arch_vcpu_ioctl+0x30a/0x1030 [kvm]
 [<ffffffffa031b5ca>] ? vcpu_load+0x1a/0xb0 [kvm]
 [<ffffffffa03a1f45>] ? vmx_vcpu_load+0x35/0x1b0 [kvm_intel]
 [<ffffffff81083fe1>] ? get_parent_ip+0x11/0x50
 [<ffffffff8165570d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffffa031b77e>] kvm_vcpu_ioctl+0xae/0x780 [kvm]
 [<ffffffff81078ef9>] ? creds_are_invalid+0x29/0x60
 [<ffffffff812aec85>] ? inode_has_perm+0x35/0xa0
 [<ffffffff811ba5e8>] do_vfs_ioctl+0x98/0x570
 [<ffffffff811bab51>] sys_ioctl+0x91/0xa0
 [<ffffffff81659692>] system_call_fastpath+0x16/0x1b

