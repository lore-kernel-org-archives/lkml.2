Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab0ENK1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:27:52 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:34083 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812Ab0ENK1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:27:50 -0400
Date: Fri, 14 May 2010 12:27:43 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: daniel@ffwll.ch
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       j.e.van.grootheest@caiway.nl
Subject: Re: BUG: unable to handle kernel NULL pointer dereference,
 i915_gem_object_move_to_active
Message-ID: <20100514102743.GE7535@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100508180435.GB17682@viiv.ffwll.ch>
 <20100508132750.GA17682@viiv.ffwll.ch>
 <20100504225138.GX3479@localhost>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi David,

  Upon typing the first character of the password in the kdm pw mask, X hung.
  Luckily, network was still operable so I was able to catch the bug_on.

  I applied the patch against .33.3. This seems indeed to be the same bug you're
  already having reports for.

  So: me too!

  I'm somehow unable to get bugzilla to accept my mail addresses.. Can you please
  add a link to this thread on my behalf? Thank you.

  Cheers,

          Nils

Other msgs:
http://permalink.gmane.org/gmane.comp.video.dri.devel/45916
http://permalink.gmane.org/gmane.comp.video.dri.devel/45936
http://permalink.gmane.org/gmane.comp.video.dri.devel/45909
http://permalink.gmane.org/gmane.comp.video.dri.devel/45844
http://permalink.gmane.org/gmane.comp.video.dri.devel/45843

------------[ cut here ]------------
kernel BUG at drivers/gpu/drm/i915/i915_gem.c:2694!
invalid opcode: 0000 [#1] PREEMPT 
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/block/sda/uevent
Modules linked in: video1394 raw1394 dv1394 vboxnetflt vboxnetadp vboxdrv firewire_ohci firewire_core ohci1394 tg3 uhci_hcd ieee1394 libphy

Pid: 3258, comm: Xorg Not tainted 2.6.33.3 #4 Columbia                       /Extensa 5220                   
EIP: 0060:[<c1347f0d>] EFLAGS: 00213246 CPU: 0
EIP is at i915_gem_clflush_object+0x9d/0xb0
EAX: f0e5d9c0 EBX: f0e950c0 ECX: 00000001 EDX: 00000000
ESI: f0eb7f40 EDI: 00000000 EBP: 00000044 ESP: f0dbfda0
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process Xorg (pid: 3258, ti=f0dbe000 task=f19a6580 task.ti=f0dbe000)
Stack:
 f0e950c0 00000000 00000000 c1349ca7 00000001 00001000 f0eb7f40 f0e950c0
<0> 00000000 f73cf000 c134ac06 00000289 0000028a 0000028a f6c01614 c10ea294
<0> f0dd36c0 f0e950c0 f0eb7f40 f73cf000 00000000 c134b755 f73cf000 f0e950c0
Call Trace:
 [<c1349ca7>] ? i915_gem_object_set_to_cpu_domain+0x147/0x160
 [<c134ac06>] ? i915_gem_object_unbind+0x46/0x250
 [<c10ea294>] ? dput+0x84/0x130
 [<c134b755>] ? i915_gem_free_object+0x45/0x110
 [<c1330ba3>] ? drm_gem_object_free+0x23/0x50
 [<c1330b80>] ? drm_gem_object_free+0x0/0x50
 [<c129de79>] ? kref_put+0x29/0x60
 [<c1330cbf>] ? drm_gem_close_ioctl+0x9f/0xf0
 [<c132f1d0>] ? drm_ioctl+0x1f0/0x360
 [<c1330c20>] ? drm_gem_close_ioctl+0x0/0xf0
 [<c10b9d85>] ? unmap_vmas+0x445/0x650
 [<c132efe0>] ? drm_ioctl+0x0/0x360
 [<c10e6cbb>] ? vfs_ioctl+0x2b/0xa0
 [<c10e6ea9>] ? do_vfs_ioctl+0x79/0x5f0
 [<c10bc568>] ? free_pgtables+0xb8/0xf0
 [<c10bdec4>] ? unmap_region+0xd4/0x140
 [<c10bdf67>] ? remove_vma+0x37/0x50
 [<c10bee82>] ? do_munmap+0x1f2/0x2b0
 [<c10e7496>] ? sys_ioctl+0x76/0x90
 [<c1002c0c>] ? sysenter_do_call+0x12/0x22
Code: 8d c1 85 ff 74 0f 8b 17 83 c7 04 89 d8 ff d2 8b 17 85 d2 75 f3 89 e0 25 00 e0 ff ff 83 68 14 01 f6 40 08 08 75 09 8b 46 2c eb 94 <0f> 0b eb fe e8 5a 07 33 00 eb f0 90 8d b4 26 00 00 00 00 83 ec 
EIP: [<c1347f0d>] i915_gem_clflush_object+0x9d/0xb0 SS:ESP 0068:f0dbfda0
---[ end trace fa21ae323a16481c ]---
SysRq : Emergency Sync
Emergency Sync complete
SysRq : Show Memory
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  54
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd: 163
active_anon:7158 inactive_anon:0 isolated_anon:0
 active_file:63024 inactive_file:18505 isolated_file:0
 unevictable:523 dirty:8 writeback:0 unstable:0
 free:286713 slab_reclaimable:2557 slab_unreclaimable:1917
 mapped:4678 shmem:3860 pagetables:138 bounce:0
DMA free:15912kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 865 1499 1499
Normal free:573808kB min:3728kB low:4660kB high:5592kB active_anon:0kB inactive_anon:0kB active_file:237704kB inactive_file:26840kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:20kB writeback:0kB mapped:4kB shmem:0kB slab_reclaimable:10228kB slab_unreclaimable:7668kB kernel_stack:888kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 5070 5070
HighMem free:557132kB min:512kB low:1192kB high:1876kB active_anon:28632kB inactive_anon:0kB active_file:14392kB inactive_file:47180kB unevictable:2092kB isolated(anon):0kB isolated(file):0kB present:649040kB mlocked:0kB dirty:12kB writeback:0kB mapped:18708kB shmem:15440kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:552kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 2*4kB 2*8kB 1*16kB 2*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15912kB
Normal: 2*4kB 7*8kB 1*16kB 1*32kB 0*64kB 2*128kB 0*256kB 0*512kB 2*1024kB 1*2048kB 139*4096kB = 573808kB
HighMem: 827*4kB 370*8kB 49*16kB 22*32kB 16*64kB 22*128kB 27*256kB 16*512kB 4*1024kB 1*2048kB 128*4096kB = 557132kB
85912 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2931820kB
Total swap = 2931820kB
390848 pages RAM
163538 pages HighMem
7671 pages reserved
80972 pages shared
21433 pages non-shared
