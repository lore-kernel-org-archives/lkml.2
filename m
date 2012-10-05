Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab2JEIe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:34:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33333 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab2JEIeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:34:03 -0400
Message-ID: <506E9B77.60505@suse.cz>
Date: Fri, 05 Oct 2012 10:33:59 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: KVM: WARNING: at .. kvm_release_pfn_clean
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting this warning while running qemu-kvm 1.2.rc1 on the top of
3.6.0-next-20121001:
WARNING: at virt/kvm/kvm_main.c:1325 kvm_release_pfn_clean+0x70/0x80()
Hardware name: To Be Filled By O.E.M.
Modules linked in: nls_cp437 vfat fat dvb_usb_dib0700 dib0090 dib7000p
dib7000m dib0070 dib8000 dib3000mc dibx000_common microcode
Pid: 11848, comm: qemu-kvm Tainted: G        W
3.6.0-next-20121001_64+ #70
Call Trace:
 [<ffffffff8107f19f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8107f1fa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81004cd0>] kvm_release_pfn_clean+0x70/0x80
 [<ffffffff81027ac6>] paging64_page_fault+0x686/0x830
 [<ffffffff81024745>] ? paging64_gva_to_gpa+0x35/0x80
 [<ffffffff81021121>] kvm_mmu_page_fault+0x31/0x100
 [<ffffffff81040e81>] handle_exception+0x231/0x3d0
 [<ffffffff81041fbc>] vmx_handle_exit+0xcc/0x780
 [<ffffffff8101be44>] kvm_arch_vcpu_ioctl_run+0x444/0xf60
 [<ffffffff81017117>] ? kvm_arch_vcpu_load+0x57/0x1b0
 [<ffffffff81005302>] kvm_vcpu_ioctl+0x472/0x610
 [<ffffffff811aa36b>] ? fsnotify+0x24b/0x340
 [<ffffffff8117d609>] do_vfs_ioctl+0x99/0x580
 [<ffffffff810b620b>] ? pick_next_task_fair+0x13b/0x1a0
 [<ffffffff810b4f68>] ? __enqueue_entity+0x78/0x80
 [<ffffffff81010114>] ? kvm_on_user_return+0x64/0x70
 [<ffffffff8117db40>] sys_ioctl+0x50/0x90
 [<ffffffff816a46e2>] system_call_fastpath+0x16/0x1b

I.e. is_error_pfn(pfn) is true.

regards,
-- 
js
suse labs
