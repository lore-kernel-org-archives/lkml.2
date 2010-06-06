Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0FFQq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 12:46:27 -0400
Received: from fep28.mx.upcmail.net ([62.179.121.48]:17027 "EHLO
	fep28.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0FFQqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 12:46:25 -0400
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jun 2010 12:46:25 EDT
X-SourceIP: 77.57.188.152
Message-ID: <4C0BCC22.8010107@odi.ch>
Date: Sun, 06 Jun 2010 18:26:10 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100415 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: Bad page map 2.6.35-rc2
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=BX1z5e3lS7RAKjOkUI/uDpZ/pP4xz0N/VImyOZX9Sfk= c=1 sm=0 a=wbKXeunVgZ0A:10 a=8nJEP1OIZ-IA:10 a=YV7_vb4buy9kyXx8CR4A:9 a=qAxyZhV0nJeKf8EigggA:7 a=jv-LJLkYv0Rh-xRtOkjqrDGpp6gA:4 a=wPNLvfGTeEIA:10 a=BsVC4g7XJwGtzgUC:21 a=vc5A4OY3rWhjZrRE:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After booting ntp was consuming 100% CPU. strace gave nothing. Sending it a TERM
spew the following into syslog. Ran it through ksymoops.


Jun  6 18:08:39 mithril kernel: BUG: Bad page map in process ntpd  pte:07200720
pmd:35585067
Jun  6 18:08:39 mithril kernel: addr:b7480000 vm_flags:08000075 anon_vma:(null)
mapping:f6c76da0 index:a3
Jun  6 18:08:39 mithril kernel: vma->vm_ops->fault: filemap_fault+0x0/0x3e0
Jun  6 18:08:39 mithril kernel: vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x50
Jun  6 18:08:39 mithril kernel: Pid: 3525, comm: ntpd Not tainted 2.6.35-rc2 #5
Jun  6 18:08:39 mithril kernel: Call Trace:
Jun  6 18:08:39 mithril kernel: [<c158d9a6>] ? printk+0x18/0x1a
Jun  6 18:08:39 mithril kernel: [<c10ca345>] print_bad_pte+0x135/0x1a0
Jun  6 18:08:39 mithril kernel: [<c10ca3fd>] vm_normal_page+0x4d/0x60
Jun  6 18:08:39 mithril kernel: [<c10cae74>] unmap_vmas+0x204/0x6c0
Jun  6 18:08:39 mithril kernel: [<c10cef9c>] exit_mmap+0xcc/0x180
Jun  6 18:08:39 mithril kernel: [<c105e256>] mmput+0x36/0xd0
Jun  6 18:08:39 mithril kernel: [<c106261f>] exit_mm+0xdf/0x110
Jun  6 18:08:39 mithril kernel: [<c109fa24>] ? acct_collect+0x124/0x170
Jun  6 18:08:39 mithril kernel: [<c10645d4>] do_exit+0x604/0x6e0
Jun  6 18:08:39 mithril kernel: [<c108839b>] ? trace_hardirqs_off+0xb/0x10
Jun  6 18:08:39 mithril kernel: [<c10883fd>] ? put_lock_stats+0xd/0x30
Jun  6 18:08:39 mithril kernel: [<c10884c5>] ? lock_release_holdtime+0xa5/0x1a0
Jun  6 18:08:39 mithril kernel: [<c1591952>] ? _raw_spin_unlock_irq+0x22/0x50
Jun  6 18:08:39 mithril kernel: [<c10646e3>] do_group_exit+0x33/0x90
Jun  6 18:08:39 mithril kernel: [<c10703b2>] get_signal_to_deliver+0x2d2/0x490
Jun  6 18:08:39 mithril kernel: [<c104a520>] ? do_page_fault+0x0/0x3c0
Jun  6 18:08:39 mithril kernel: [<c1027729>] do_notify_resume+0xc9/0x880
Jun  6 18:08:39 mithril kernel: [<c158e874>] ? preempt_schedule+0x34/0x50
Jun  6 18:08:39 mithril kernel: [<c105673b>] ? get_parent_ip+0xb/0x40
Jun  6 18:08:39 mithril kernel: [<c105673b>] ? get_parent_ip+0xb/0x40
Jun  6 18:08:39 mithril kernel: [<c10883fd>] ? put_lock_stats+0xd/0x30
Jun  6 18:08:39 mithril kernel: [<c10884c5>] ? lock_release_holdtime+0xa5/0x1a0
Jun  6 18:08:39 mithril kernel: [<c107bc36>] ? up_read+0x16/0x30
Jun  6 18:08:39 mithril kernel: [<c104a71d>] ? do_page_fault+0x1fd/0x3c0
Jun  6 18:08:39 mithril kernel: [<c1066242>] ? _local_bh_enable+0x52/0xa0
Jun  6 18:08:39 mithril kernel: [<c106637f>] ? __do_softirq+0xef/0x140
Jun  6 18:08:39 mithril kernel: [<c1591a07>] ? _raw_spin_unlock+0x27/0x40
Jun  6 18:08:39 mithril kernel: [<c105673b>] ? get_parent_ip+0xb/0x40
Jun  6 18:08:39 mithril kernel: [<c1591c78>] ? restore_all_notrace+0x0/0x18
Jun  6 18:08:39 mithril kernel: [<c104a520>] ? do_page_fault+0x0/0x3c0
Jun  6 18:08:39 mithril kernel: [<c104a520>] ? do_page_fault+0x0/0x3c0
Jun  6 18:08:39 mithril kernel: [<c1591d26>] work_notifysig+0x13/0x19
Jun  6 18:08:39 mithril kernel: [<c104a520>] ? do_page_fault+0x0/0x3c0
Warning (Oops_read): Code line not seen, dumping what data is available


Trace; c158d9a6 <ar9280Modes_9280+146/12c0>
Trace; c10ca345 <hugetlb_cow+2b5/440>
Trace; c10ca3fd <hugetlb_cow+36d/440>
Trace; c10cae74 <__mmu_notifier_invalidate_range_end+44/60>
Trace; c10cef9c <__kmalloc+4c/d0>
Trace; c105e256 <vprintk+3c6/400>
Trace; c106261f <wakeup_softirqd+1f/30>
Trace; c109fa24 <perf_read+94/300>
Trace; c10645d4 <__do_proc_doulongvec_minmax+74/310>
Trace; c108839b <__symbol_put+5b/60>
Trace; c10883fd <sys_delete_module+1d/1e0>
Trace; c10884c5 <sys_delete_module+e5/1e0>
Trace; c1591952 <ar5416Common_9100+512/b98>
Trace; c10646e3 <__do_proc_doulongvec_minmax+183/310>
Trace; c10703b2 <__kernel_text_address+62/70>
Trace; c104a520 <reserve_pfn_range+90/350>
Trace; c1027729 <ptregs_execve+9/18>
Trace; c158e874 <ar9280Modes_9280+1014/12c0>
Trace; c105673b <proc_sched_show_task+e3b/13a0>
Trace; c105673b <proc_sched_show_task+e3b/13a0>
Trace; c10883fd <sys_delete_module+1d/1e0>
Trace; c10884c5 <sys_delete_module+e5/1e0>
Trace; c107bc36 <second_overflow+66/190>
Trace; c104a71d <reserve_pfn_range+28d/350>
Trace; c1066242 <sys_capset+32/170>
Trace; c106637f <sys_capset+16f/170>
Trace; c1591a07 <ar5416Common_9100+5c7/b98>
Trace; c105673b <proc_sched_show_task+e3b/13a0>
Trace; c1591c78 <ar5416Common_9100+838/b98>
Trace; c104a520 <reserve_pfn_range+90/350>
Trace; c104a520 <reserve_pfn_range+90/350>
Trace; c1591d26 <ar5416Common_9100+8e6/b98>
Trace; c104a520 <reserve_pfn_range+90/350>
