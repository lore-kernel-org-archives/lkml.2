Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0CXU6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:58:19 -0400
Received: from ns.netcenter.hu ([195.228.254.57]:36569 "EHLO mail.netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0CXU6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:58:17 -0400
X-Greylist: delayed 802 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2010 16:58:17 EDT
Message-ID: <03ca01cacb92$195adf50$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
To: <linux-kernel@vger.kernel.org>
Subject: Somebody take a look please! (some kind of kernel bug?)
Date: Wed, 24 Mar 2010 21:39:23 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3598
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear developers,

This is one of my productive servers, wich suddenly starts to freeze (crash) 
some weeks before.
I have done all what i can, (i think) please somebody give to me some 
suggestion:

Mar 24 19:22:28 alfa kernel: BUG: Bad page map in process httpd 
pte:2bf1e025 pmd:1535b5067
Mar 24 19:22:28 alfa kernel: page:ffffea0000f1b250 flags:4000000000000404 
count:1 mapcount:-1 mapping:(null) index:0
Mar 24 19:22:28 alfa kernel: addr:00000037b4008000 vm_flags:08000875 
anon_vma:(null) mapping:ffff88022b5d25a8 index:8
Mar 24 19:22:28 alfa kernel: vma->vm_ops->fault: filemap_fault+0x0/0x34d
Mar 24 19:22:28 alfa kernel: vma->vm_file->f_op->mmap: 
xfs_file_mmap+0x0/0x33
Mar 24 19:22:28 alfa kernel: Pid: 7512, comm: httpd Not tainted 2.6.32.10 #2
Mar 24 19:22:28 alfa kernel: Call Trace:
Mar 24 19:22:28 alfa kernel:  [<ffffffff810c2ea3>] print_bad_pte+0x210/0x229
Mar 24 19:22:28 alfa kernel:  [<ffffffff810c3c98>] unmap_vmas+0x44b/0x787
Mar 24 19:22:28 alfa kernel:  [<ffffffff810c81d5>] exit_mmap+0xb0/0x133
Mar 24 19:22:28 alfa kernel:  [<ffffffff81041f83>] mmput+0x48/0xb9
Mar 24 19:22:28 alfa kernel:  [<ffffffff810463b0>] exit_mm+0x105/0x110
Mar 24 19:22:28 alfa kernel:  [<ffffffff81371287>] ? 
tty_audit_exit+0x28/0x85
Mar 24 19:22:28 alfa kernel:  [<ffffffff810477a0>] do_exit+0x1e9/0x6d2
Mar 24 19:22:28 alfa kernel:  [<ffffffff81053c37>] ? 
__dequeue_signal+0xf1/0x127
Mar 24 19:22:28 alfa kernel:  [<ffffffff81047d00>] do_group_exit+0x77/0xa1
Mar 24 19:22:28 alfa kernel:  [<ffffffff810560f7>] 
get_signal_to_deliver+0x32c/0x37f
Mar 24 19:22:28 alfa kernel:  [<ffffffff8100a484>] 
do_notify_resume+0x90/0x740
Mar 24 19:22:28 alfa kernel:  [<ffffffff8102724b>] ? 
__bad_area_nosemaphore+0x178/0x1a2
Mar 24 19:22:28 alfa kernel:  [<ffffffff810272b9>] ? __bad_area+0x44/0x4d
Mar 24 19:22:28 alfa kernel:  [<ffffffff8100bba2>] retint_signal+0x46/0x84
Mar 24 19:22:28 alfa kernel: Disabling lock debugging due to kernel taint
Mar 24 19:22:28 alfa kernel: swap_free: Bad swap file entry 6c800000
Mar 24 19:22:28 alfa kernel: BUG: Bad page map in process httpd 
pte:d900000000 pmd:1535b5067
Mar 24 19:22:28 alfa kernel: addr:00000037b400a000 vm_flags:08000875 
anon_vma:(null) mapping:ffff88022b5d25a8 index:a
Mar 24 19:22:28 alfa kernel: vma->vm_ops->fault: filemap_fault+0x0/0x34d
Mar 24 19:22:28 alfa kernel: vma->vm_file->f_op->mmap: 
xfs_file_mmap+0x0/0x33
Mar 24 19:22:28 alfa kernel: Pid: 7512, comm: httpd Tainted: G    B 
2.6.32.10 #2
Mar 24 19:22:28 alfa kernel: Call Trace:
Mar 24 19:22:28 alfa kernel:  [<ffffffff81044551>] ? add_taint+0x32/0x3e
Mar 24 19:22:28 alfa kernel:  [<ffffffff810c2ea3>] print_bad_pte+0x210/0x229
Mar 24 19:22:28 alfa kernel:  [<ffffffff810c3d47>] unmap_vmas+0x4fa/0x787
Mar 24 19:22:28 alfa kernel:  [<ffffffff810c81d5>] exit_mmap+0xb0/0x133
Mar 24 19:22:28 alfa kernel:  [<ffffffff81041f83>] mmput+0x48/0xb9
Mar 24 19:22:28 alfa kernel:  [<ffffffff810463b0>] exit_mm+0x105/0x110
Mar 24 19:22:28 alfa kernel:  [<ffffffff81371287>] ? 
tty_audit_exit+0x28/0x85
Mar 24 19:22:28 alfa kernel:  [<ffffffff810477a0>] do_exit+0x1e9/0x6d2
Mar 24 19:22:28 alfa kernel:  [<ffffffff81053c37>] ? 
__dequeue_signal+0xf1/0x127
Mar 24 19:22:28 alfa kernel:  [<ffffffff81047d00>] do_group_exit+0x77/0xa1
Mar 24 19:22:28 alfa kernel:  [<ffffffff810560f7>] 
get_signal_to_deliver+0x32c/0x37f
Mar 24 19:22:28 alfa kernel:  [<ffffffff8100a484>] 
do_notify_resume+0x90/0x740
Mar 24 19:22:28 alfa kernel:  [<ffffffff8102724b>] ? 
__bad_area_nosemaphore+0x178/0x1a2
Mar 24 19:22:28 alfa kernel:  [<ffffffff810272b9>] ? __bad_area+0x44/0x4d
Mar 24 19:22:28 alfa kernel:  [<ffffffff8100bba2>] retint_signal+0x46/0x84
Mar 24 19:22:28 alfa kernel: BUG: Bad page map in process httpd 
pte:2bfe8025 pmd:1535b5067
Mar 24 19:22:28 alfa kernel: page:ffffea0000f1f7c0 flags:4000000000000404 
count:1 mapcount:-1 mapping:(null) index:0
Mar 24 19:22:28 alfa kernel: addr:00000037b400c000 vm_flags:08000875 
anon_vma:(null) mapping:ffff88022b5d25a8 index:c
Mar 24 19:22:28 alfa kernel: vma->vm_ops->fault: filemap_fault+0x0/0x34d
Mar 24 19:22:28 alfa kernel: vma->vm_file->f_op->mmap: 
xfs_file_mmap+0x0/0x33
Mar 24 19:22:28 alfa kernel: Pid: 7512, comm: httpd Tainted: G    B 
2.6.32.10 #2
Mar 24 19:22:28 alfa kernel: Call Trace:
Mar 24 19:22:28 alfa kernel:  [<ffffffff81044551>] ? add_taint+0x32/0x3e
Mar 24 19:22:28 alfa kernel:  [<ffffffff810c2ea3>] print_bad_pte+0x210/0x229
Mar 24 19:22:28 alfa kernel:  [<ffffffff810c3c98>] unmap_vmas+0x44b/0x787
Mar 24 19:22:28 alfa kernel:  [<ffffffff810c81d5>] exit_mmap+0xb0/0x133
Mar 24 19:22:28 alfa kernel:  [<ffffffff81041f83>] mmput+0x48/0xb9
Mar 24 19:22:28 alfa kernel:  [<ffffffff810463b0>] exit_mm+0x105/0x110
.....

The entire log is here:
http://download.netcenter.hu/bughunt/20100324/messages

The actual kernel is 2.6.32.10, but the crash-series started @ 2.6.28.10.

I have forwarded the tasks to another server, removed this from the room, 
and the hw survived memtest86 in >7 days continously + i have tested the 
HDDs one by one with badblocks -vvw, all is good.
For me looks like this is not a hw problem.

Somebody have any idea?

Thanks a lot,
Janos Haar 

