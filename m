Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2JRDJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:09:40 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54006 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2JRDJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:09:33 -0400
Message-ID: <1350529642.2403.4.camel@falcor.watson.ibm.com>
Subject: Re: [ima_inode_post_setattr] kernel BUG at mm/slub.c:3479!
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 17 Oct 2012 23:07:22 -0400
In-Reply-To: <20121018024317.GA25407@localhost>
References: <20121018024317.GA25407@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101803-7606-0000-0000-000004978EAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 10:43 +0800, Fengguang Wu wrote:
> Mimi,
> 
> Although this occurs in the xen tree head, it's more likely related to
> ima_inode_post_setattr().

Under certain circumstances ima_inode_post_setattr() removes
'security.ima' without checking that it exists.  shmem doesn't seem to
like it.

Mimi

> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/for-linus-3.8
> head:   d01b193de1a961e028ee6df5ad0b34c3e56a995f
> commit: d01b193de1a961e028ee6df5ad0b34c3e56a995f [0/0] xen/acpi: Support ACPI hotplug of CPUs.
> 
> [  115.499469] Write protecting the kernel read-only data: 2752k
> [  134.707390] ------------[ cut here ]------------
> [  134.707390] kernel BUG at /c/kernel-tests/src/linux/mm/slub.c:3479!
> [  134.707390] invalid opcode: 0000 [#1] 
> [  134.707390] Pid: 1, comm: init Not tainted 3.6.0-00451-gd01b193 #2 Bochs Bochs
> [  134.707390] EIP: 0060:[<c1235dbe>] EFLAGS: 00000246 CPU: 0
> [  134.707390] EIP is at kfree+0x2be/0x490
> [  134.707390] EAX: 00000001 EBX: 00000001 ECX: 00000000 EDX: 00000000
> [  134.707390] ESI: cdeef760 EDI: cd83bdac EBP: cd83bd70 ESP: cd83bd50
> [  134.707390]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [  134.707390] CR0: 80050033 CR2: b7782000 CR3: 0f9a8000 CR4: 00000690
> [  134.707390] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  134.707390] DR6: 00000000 DR7: 00000000
> [  134.707390] Process init (pid: 1, ti=cd83a000 task=cd838000 task.ti=cd83a000)
> [  134.707390] Stack:
> [  134.707390]  00000000 cd83bd5c c1085b74 cd83bd88 c1298a5e cd83a000 ffffffc3 cd83bd90
> [  134.707390]  cd83bd88 c1298a5e cd83bd90 c1ffdf63 00000001 cd832914 cd83bd98 c1298d4a
> [  134.707390]  00000000 00000002 cd83bdac c11e0400 c995c980 cd832914 00000000 cd83bdc4
> [  134.707390] Call Trace:
> [  134.707390]  [<c1085b74>] ? irq_exit+0x74/0x180
> [  134.707390]  [<c1298a5e>] ? __simple_xattr_set+0x28e/0x360
> [  134.707390]  [<c1298a5e>] __simple_xattr_set+0x28e/0x360
> [  134.707390]  [<c1298d4a>] simple_xattr_remove+0x2a/0x40
> [  134.707390]  [<c11e0400>] shmem_removexattr+0xc0/0x120
> [  134.707390]  [<c14f11ed>] ima_inode_post_setattr+0x21d/0x250
> [  134.707390]  [<c1284316>] notify_change+0xb66/0xc40
> [  134.707390]  [<c1239c58>] do_truncate+0xf8/0x160
> [  134.707390]  [<c1261fcd>] do_last.isra.38+0xb3d/0x1a80
> [  134.707390]  [<c12632e1>] path_openat+0x3d1/0xd10
> [  134.707390]  [<c11476cb>] ? note_interrupt+0x4db/0x7f0
> [  134.707390]  [<c1263c57>] do_filp_open+0x37/0x140
> [  134.707390]  [<c123ce71>] do_sys_open+0x471/0x630
> [  134.707390]  [<c10881b6>] ? __find_resource+0x166/0x470
> [  134.707390]  [<c123d06b>] sys_open+0x3b/0x70
> [  134.707390]  [<c1de6ce1>] sysenter_do_call+0x12/0x2c
> [  134.707390] Code: 89 d0 f3 ff 8b 04 9d 8c a0 2c c2 83 c0 01 85 db 89 04 9d 8c a0 2c c2 0f 84 6a 01 00 00 83 05 a8 4b 61 c2 01 83 15 ac 4b 61 c2 00 <0f> 0b 83 05 b8 4b 61 c2 01 83 15 bc 4b 61 c2 00 83 05 30 4c 61
> [  134.707390] EIP: [<c1235dbe>] kfree+0x2be/0x490 SS:ESP 0068:cd83bd50
> 
> Thanks,
> Fengguang



