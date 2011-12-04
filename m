Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1LDDg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 22:36:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34709 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1LDDgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 22:36:55 -0500
MIME-Version: 1.0
In-Reply-To: <20111130140754.6662.qmail@science.horizon.com>
References: <20111130140754.6662.qmail@science.horizon.com>
Date: Sun, 4 Dec 2011 11:36:53 +0800
Message-ID: <CAJd=RBDUyH9BygNQghnjNPr8tf0jCLY2c8scfu_sKZ5goFfPqg@mail.gmail.com>
Subject: Re: v3.2-rc2: kernel BUG at mm/migrate.c:578
From: Hillf Danton <dhillf@gmail.com>
To: George Spelvin <linux@horizon.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello George

On Wed, Nov 30, 2011 at 10:07 PM, George Spelvin <linux@horizon.com> wrote:
> I just noticed the last one, but the preceding warnings were close enough I figured they might be relevant.
>
> Kernel is stock 3.2.0-rc2.
>
> Prcessor is 1st gen Core i3, 4G RAM, 64-bit kernel.  Userspace is 32-bit Debian/unstable.
[...]
>
> [1118868.292556] ------------[ cut here ]------------
> [1118868.292589] kernel BUG at mm/migrate.c:578!
> [1118868.292612] invalid opcode: 0000 [#1] SMP
> [1118868.292640] CPU 2
> [1118868.292652] Modules linked in: battery nfsd exportfs nfs lockd auth_rpcgss nfs_acl sunrpc fuse loop ftdi_sio usbserial r8169
> [1118868.292746]
> [1118868.292758] Pid: 3387, comm: firefox-bin Tainted: G        W    3.2.0-rc2 #40 Gigabyte Technology Co., Ltd. H55M-UD2H/H55M-UD2H
> [1118868.292818] RIP: 0010:[<ffffffff8109ece2>]  [<ffffffff8109ece2>] move_to_new_page+0x21/0x1b8
> [1118868.292868] RSP: 0000:ffff880105c25a38  EFLAGS: 00010246
> [1118868.292895] RAX: 0000000000000000 RBX: ffffea00000dd940 RCX: 0000000000000001
> [1118868.292929] RDX: 0000000000000001 RSI: ffffea00000dd940 RDI: ffffea0001c763c0
> [1118868.292964] RBP: ffffea0001c763c0 R08: ffffea00000de280 R09: 000000000000000a
> [1118868.292999] R10: ffffea0001a08100 R11: ffffea0001a08100 R12: 0000000000000000
> [1118868.293033] R13: 0000000000000001 R14: 0000000000000001 R15: ffff880105c25be8
> [1118868.293068] FS:  0000000000000000(0000) GS:ffff880117d00000(0063) knlGS:00000000f742f6e0
> [1118868.293106] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [1118868.293134] CR2: 000000006c000000 CR3: 00000001116a4000 CR4: 00000000000006e0
> [1118868.293169] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [1118868.293203] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [1118868.293237] Process firefox-bin (pid: 3387, threadinfo ffff880105c24000, task ffff880110bb0ca0)
> [1118868.293278] Stack:
> [1118868.293291]  ffff880117d0d870 ffffea00000dd940 0000000000000003 0000000000000000
> [1118868.293334]  0000000000000001 0000000000000001 ffffea00000dd940 0000000000000003
> [1118868.293377]  0000000000000000 0000000000000001 0000000000000001 ffffffff8109f145
> [1118868.293420] Call Trace:
> [1118868.293436]  [<ffffffff8109f145>] ? migrate_pages+0x1e3/0x335
> [1118868.293466]  [<ffffffff81099ef3>] ? pfn_valid.part.3+0x32/0x32
> [1118868.293496]  [<ffffffff8109a5b7>] ? compact_zone+0x3f1/0x5bf
> [1118868.293526]  [<ffffffff8100738f>] ? read_tsc+0x5/0x14
> [1118868.293552]  [<ffffffff8109a8a6>] ? try_to_compact_pages+0x121/0x17e
> [1118868.293585]  [<ffffffff81077f6b>] ? __alloc_pages_direct_compact+0xaa/0x161
> [1118868.293619]  [<ffffffff8107868f>] ? __alloc_pages_nodemask+0x66d/0x6cc
> [1118868.293653]  [<ffffffff8108ff77>] ? anon_vma_prepare+0x1e/0x126
> [1118868.293683]  [<ffffffff810a1b5a>] ? do_huge_pmd_anonymous_page+0xa4/0x227
> [1118868.293718]  [<ffffffff8101b13e>] ? do_page_fault+0x288/0x2ce
> [1118868.293749]  [<ffffffff8108cef4>] ? mmap_region+0x353/0x44a
> [1118868.293780]  [<ffffffff81333def>] ? page_fault+0x1f/0x30
> [1118868.293806] Code: 44 24 08 48 83 c4 18 5b 5d c3 41 56 41 88 ce 41 55 41 89 d5 41 54 55 48 89 fd 53 48 89 f3 48 83 ec 30 e8 03 f8 ff ff 85 c0 75 02 <0f> 0b 48 8b 43 10 48 89 45 10 48 8b 43 08 48 89 45 08 48 8b 03
> [1118868.294066] RIP  [<ffffffff8109ece2>] move_to_new_page+0x21/0x1b8
> [1118868.294099]  RSP <ffff880105c25a38>
> [1118868.358440] ---[ end trace ceac60930a99a4ce ]---
> --

The following diff is prepared for spotting/catching the triggered bug,
would you please take another try with it included?

Thanks

Hillf
---

--- a/mm/compaction.c	Thu Nov 24 20:23:28 2011
+++ b/mm/compaction.c	Sun Dec  4 11:31:03 2011
@@ -322,6 +322,19 @@ static isolate_migrate_t isolate_migrate
 		if (PageBuddy(page))
 			continue;

+		if (!PageLRU(page))
+			continue;
+
+		/*
+		 * PageLRU is set, and lru_lock excludes isolation,
+		 * splitting and collapsing (collapsing has already
+		 * happened if PageLRU is set).
+		 */
+		if (PageTransHuge(page)) {
+			low_pfn += (1 << compound_order(page)) - 1;
+			continue;
+		}
+
 		/*
 		 * For async migration, also only scan in MOVABLE blocks. Async
 		 * migration is optimistic to see if the minimum amount of work
@@ -333,19 +346,6 @@ static isolate_migrate_t isolate_migrate
 			low_pfn += pageblock_nr_pages;
 			low_pfn = ALIGN(low_pfn, pageblock_nr_pages) - 1;
 			last_pageblock_nr = pageblock_nr;
-			continue;
-		}
-
-		if (!PageLRU(page))
-			continue;
-
-		/*
-		 * PageLRU is set, and lru_lock excludes isolation,
-		 * splitting and collapsing (collapsing has already
-		 * happened if PageLRU is set).
-		 */
-		if (PageTransHuge(page)) {
-			low_pfn += (1 << compound_order(page)) - 1;
 			continue;
 		}
