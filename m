Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab0CYD3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 23:29:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:38957 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0CYD3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 23:29:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xdDz8+jSCswrfD8+59qXsyHq+JNzR7MDQUblePDUy2NyDiCib9XYx638TcNKCT9G0I
         2NLgyXcxlAORnDLkFC3rOfskAW148HJM59L6uMMoXjQ5TcaCfMkI1mfHBf6ZsBx9p41Z
         in28yt5GPvJ/2+URE/Uk07HXxp/Sz0Q36NDNM=
MIME-Version: 1.0
In-Reply-To: <03ca01cacb92$195adf50$0400a8c0@dcccs>
References: <03ca01cacb92$195adf50$0400a8c0@dcccs>
Date: Thu, 25 Mar 2010 11:29:25 +0800
Message-ID: <2375c9f91003242029p1efbbea1v8e313e460b118f14@mail.gmail.com>
Subject: Re: Somebody take a look please! (some kind of kernel bug?)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ing linux-mm)

2010/3/25 Janos Haar <janos.haar@netcenter.hu>:
> Dear developers,
>
> This is one of my productive servers, wich suddenly starts to freeze (crash)
> some weeks before.
> I have done all what i can, (i think) please somebody give to me some
> suggestion:
>
> Mar 24 19:22:28 alfa kernel: BUG: Bad page map in process httpd pte:2bf1e025
> pmd:1535b5067
> Mar 24 19:22:28 alfa kernel: page:ffffea0000f1b250 flags:4000000000000404
> count:1 mapcount:-1 mapping:(null) index:0
> Mar 24 19:22:28 alfa kernel: addr:00000037b4008000 vm_flags:08000875
> anon_vma:(null) mapping:ffff88022b5d25a8 index:8
> Mar 24 19:22:28 alfa kernel: vma->vm_ops->fault: filemap_fault+0x0/0x34d
> Mar 24 19:22:28 alfa kernel: vma->vm_file->f_op->mmap:
> xfs_file_mmap+0x0/0x33
> Mar 24 19:22:28 alfa kernel: Pid: 7512, comm: httpd Not tainted 2.6.32.10 #2
> Mar 24 19:22:28 alfa kernel: Call Trace:
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810c2ea3>] print_bad_pte+0x210/0x229
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810c3c98>] unmap_vmas+0x44b/0x787
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810c81d5>] exit_mmap+0xb0/0x133
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81041f83>] mmput+0x48/0xb9
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810463b0>] exit_mm+0x105/0x110
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81371287>] ?
> tty_audit_exit+0x28/0x85
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810477a0>] do_exit+0x1e9/0x6d2
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81053c37>] ?
> __dequeue_signal+0xf1/0x127
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81047d00>] do_group_exit+0x77/0xa1
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810560f7>]
> get_signal_to_deliver+0x32c/0x37f
> Mar 24 19:22:28 alfa kernel:  [<ffffffff8100a484>]
> do_notify_resume+0x90/0x740
> Mar 24 19:22:28 alfa kernel:  [<ffffffff8102724b>] ?
> __bad_area_nosemaphore+0x178/0x1a2
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810272b9>] ? __bad_area+0x44/0x4d
> Mar 24 19:22:28 alfa kernel:  [<ffffffff8100bba2>] retint_signal+0x46/0x84
> Mar 24 19:22:28 alfa kernel: Disabling lock debugging due to kernel taint
> Mar 24 19:22:28 alfa kernel: swap_free: Bad swap file entry 6c800000
> Mar 24 19:22:28 alfa kernel: BUG: Bad page map in process httpd
> pte:d900000000 pmd:1535b5067
> Mar 24 19:22:28 alfa kernel: addr:00000037b400a000 vm_flags:08000875
> anon_vma:(null) mapping:ffff88022b5d25a8 index:a
> Mar 24 19:22:28 alfa kernel: vma->vm_ops->fault: filemap_fault+0x0/0x34d
> Mar 24 19:22:28 alfa kernel: vma->vm_file->f_op->mmap:
> xfs_file_mmap+0x0/0x33
> Mar 24 19:22:28 alfa kernel: Pid: 7512, comm: httpd Tainted: G    B
> 2.6.32.10 #2
> Mar 24 19:22:28 alfa kernel: Call Trace:
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81044551>] ? add_taint+0x32/0x3e
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810c2ea3>] print_bad_pte+0x210/0x229
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810c3d47>] unmap_vmas+0x4fa/0x787
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810c81d5>] exit_mmap+0xb0/0x133
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81041f83>] mmput+0x48/0xb9
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810463b0>] exit_mm+0x105/0x110
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81371287>] ?
> tty_audit_exit+0x28/0x85
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810477a0>] do_exit+0x1e9/0x6d2
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81053c37>] ?
> __dequeue_signal+0xf1/0x127
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81047d00>] do_group_exit+0x77/0xa1
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810560f7>]
> get_signal_to_deliver+0x32c/0x37f
> Mar 24 19:22:28 alfa kernel:  [<ffffffff8100a484>]
> do_notify_resume+0x90/0x740
> Mar 24 19:22:28 alfa kernel:  [<ffffffff8102724b>] ?
> __bad_area_nosemaphore+0x178/0x1a2
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810272b9>] ? __bad_area+0x44/0x4d
> Mar 24 19:22:28 alfa kernel:  [<ffffffff8100bba2>] retint_signal+0x46/0x84
> Mar 24 19:22:28 alfa kernel: BUG: Bad page map in process httpd pte:2bfe8025
> pmd:1535b5067
> Mar 24 19:22:28 alfa kernel: page:ffffea0000f1f7c0 flags:4000000000000404
> count:1 mapcount:-1 mapping:(null) index:0
> Mar 24 19:22:28 alfa kernel: addr:00000037b400c000 vm_flags:08000875
> anon_vma:(null) mapping:ffff88022b5d25a8 index:c
> Mar 24 19:22:28 alfa kernel: vma->vm_ops->fault: filemap_fault+0x0/0x34d
> Mar 24 19:22:28 alfa kernel: vma->vm_file->f_op->mmap:
> xfs_file_mmap+0x0/0x33
> Mar 24 19:22:28 alfa kernel: Pid: 7512, comm: httpd Tainted: G    B
> 2.6.32.10 #2
> Mar 24 19:22:28 alfa kernel: Call Trace:
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81044551>] ? add_taint+0x32/0x3e
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810c2ea3>] print_bad_pte+0x210/0x229
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810c3c98>] unmap_vmas+0x44b/0x787
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810c81d5>] exit_mmap+0xb0/0x133
> Mar 24 19:22:28 alfa kernel:  [<ffffffff81041f83>] mmput+0x48/0xb9
> Mar 24 19:22:28 alfa kernel:  [<ffffffff810463b0>] exit_mm+0x105/0x110
> .....
>
> The entire log is here:
> http://download.netcenter.hu/bughunt/20100324/messages
>
> The actual kernel is 2.6.32.10, but the crash-series started @ 2.6.28.10.
>
> I have forwarded the tasks to another server, removed this from the room,
> and the hw survived memtest86 in >7 days continously + i have tested the
> HDDs one by one with badblocks -vvw, all is good.
> For me looks like this is not a hw problem.
>
> Somebody have any idea?
>
> Thanks a lot,
> Janos Haar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
