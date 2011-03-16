Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1CPNFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:05:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1CPNFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:05:07 -0400
Date: Wed, 16 Mar 2011 09:05:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS - the first pile
Message-ID: <20110316130504.GA30866@infradead.org>
References: <20110315213248.GL22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315213248.GL22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This blows up on xfstests 005 for me:

005 0s ...
[   25.075985] ------------[ cut here ]------------
[   25.076043] kernel BUG at /home/hch/work/linux-2.6/fs/dcache.c:440!
[   25.076043] invalid opcode: 0000 [#1] SMP 
[   25.076043] last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/virtio1/block/vdb/removable
[   25.076043] Modules linked in:
[   25.076043] 
[   25.076043] Pid: 6263, comm: touch Not tainted 2.6.38+ #77 Bochs Bochs
[   25.076043] EIP: 0060:[<c021d36e>] EFLAGS: 00010246 CPU: 0
[   25.076043] EIP is at dput+0x22e/0x240
[   25.076043] EAX: 00000000 EBX: f54b9f14 ECX: 00000000 EDX: 00005959
[   25.076043] ESI: ffffffd8 EDI: ffffffd8 EBP: f5361e84 ESP: f5361e68
[   25.076043]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   25.076043] Process touch (pid: 6263, ti=f5360000 task=f59c23f0 task.ti=f5360000)
[   25.076043] Stack:
[   25.076043]  0000000c f54b9f14 f5361eec f54b9f60 f5361eb8 ffffffd8 ffffffd8 f5361e90
[   25.076043]  c02129ce f5361eec f5361ed8 c0215702 f644d000 f5361ec8 f5361f78 f644d000
[   25.076043]  f59c23f0 f5361f00 f59c23f0 c04c0aa0 f5a18180 f54b9f14 f5a18180 f54b9f14
[   25.076043] Call Trace:
[   25.076043]  [<c02129ce>] path_put+0xe/0x20
[   25.076043]  [<c0215702>] path_openat+0x1d2/0x310
[   25.076043]  [<c04c0aa0>] ? xfs_vn_put_link+0x0/0x20
[   25.076043]  [<c0215920>] do_filp_open+0x30/0x80
[   25.076043]  [<c02205cc>] ? alloc_fd+0x6c/0xf0
[   25.076043]  [<c0213171>] ? getname_flags+0x61/0xe0
[   25.076043]  [<c020915b>] do_sys_open+0xeb/0x1c0
[   25.076043]  [<c0209299>] sys_open+0x29/0x40
[   25.076043]  [<c08f62b9>] syscall_call+0x7/0xb
[   25.076043] Code: 89 72 04 89 53 60 8d 50 7c 89 53 64 89 70 7c 8b 43 54 83 80 84 00 00 00 01 83 05 a8 32 c4 c0 01 fe 05 00 4c c3 c0 e9 8b fe ff ff <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 

