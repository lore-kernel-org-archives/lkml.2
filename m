Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2FLW6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:58:33 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:11546 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854Ab2FLW6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:58:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAG6Zu08Y9geI/2dsb2JhbAANN4UtsgEBAQEBAgEBAhsFVQYLCxgCAgUWCwICCQMCAQIBFi8GAQwGAgEBiAUQpwOSe4EmiXuED4EUA5J2gzSRZoFD
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="191232552"
Message-ID: <4FD7C995.8040402@teksavvy.com>
Date: Tue, 12 Jun 2012 18:58:29 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, davej@redhat.com,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: mount.nfs: cannot allocate memory
References: <4FD7C65F.80602@teksavvy.com> <4FD7C7C6.9030204@teksavvy.com>
In-Reply-To: <4FD7C7C6.9030204@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Ben Hutchings to CC: as he seems to have looked into this before.

> On 12-06-12 06:44 PM, Mark Lord wrote:
>> I've been seeing these messages on my AMD Fusion server
>> running linux-3.3.7-64bit.  Does this ring any bells for anyone else?
>> The system is NOT low on memory.
>>
>> I'm building/installing 3.4.2 now to see if it behaves any better.
>>
>> [962841.265658] mount.nfs: page allocation failure: order:4, mode:0xc0d0
>> [962841.265674] Pid: 32116, comm: mount.nfs Not tainted 3.3.7 #2
>> [962841.265680] Call Trace:
>> [962841.265700]  [<ffffffff81079363>] ? warn_alloc_failed+0x11a/0x12d
>> [962841.265713]  [<ffffffff8107b904>] ? __alloc_pages_nodemask+0x6c0/0x702
>> [962841.265725]  [<ffffffff8114fcb8>] ? timerqueue_del+0x53/0x63
>> [962841.265758]  [<ffffffff8107b9ba>] ? __get_free_pages+0x10/0x3f
>> [962841.265805]  [<ffffffffa01ea33d>] ? nfs_idmap_new+0x28/0xde [nfs]
>> [962841.265836]  [<ffffffffa01c79c9>] ? nfs4_init_client+0x74/0x12a [nfs]
>> [962841.265863]  [<ffffffffa01c6f3b>] ? nfs_get_client+0x337/0x476 [nfs]
>> [962841.265874]  [<ffffffff81087ad8>] ? pcpu_alloc+0x796/0x7ad
>> [962841.265885]  [<ffffffff810403f7>] ? should_resched+0x5/0x23
>> [962841.265913]  [<ffffffffa01c70f2>] ? nfs4_set_client+0x78/0xca [nfs]
>> [962841.265944]  [<ffffffffa01c7b5c>] ? nfs4_create_server+0xdd/0x208 [nfs]
>> [962841.265956]  [<ffffffff812c0de1>] ? _cond_resched+0x7/0x1c
>> [962841.265990]  [<ffffffffa01cfa3c>] ? nfs4_remote_mount+0x50/0x183 [nfs]
>> [962841.266007]  [<ffffffff810ab334>] ? mount_fs+0xc/0xa0
>> [962841.266020]  [<ffffffff810bd3fd>] ? vfs_kern_mount+0x61/0xcc
>> [962841.266053]  [<ffffffffa01cfc3f>] ? nfs_do_root_mount+0x89/0xaa [nfs]
>> [962841.266088]  [<ffffffffa01d0702>] ? nfs4_try_mount.isra.27+0x4c/0x9e [nfs]
>> [962841.266120]  [<ffffffffa01d1145>] ? nfs_fs_mount+0x3e9/0x5ef [nfs]
>> [962841.266131]  [<ffffffff8114b3bc>] ? ida_get_new_above+0x176/0x198
>> [962841.266147]  [<ffffffff810ab334>] ? mount_fs+0xc/0xa0
>> [962841.266159]  [<ffffffff810bd3fd>] ? vfs_kern_mount+0x61/0xcc
>> [962841.266172]  [<ffffffff810bd7f0>] ? do_kern_mount+0x49/0xd8
>> [962841.266182]  [<ffffffff810beec8>] ? do_mount+0x630/0x695
>> [962841.266191]  [<ffffffff810be80a>] ? copy_mount_options+0xc3/0x126
>> [962841.266201]  [<ffffffff810bf00f>] ? sys_mount+0x88/0xca
>> [962841.266212]  [<ffffffff812c20a2>] ? system_call_fastpath+0x16/0x1b
>> [962841.266219] Mem-Info:
>> [962841.266224] DMA per-cpu:
>> [962841.266230] CPU    0: hi:    0, btch:   1 usd:   0
>> [962841.266237] CPU    1: hi:    0, btch:   1 usd:   0
>> [962841.266242] DMA32 per-cpu:
>> [962841.266248] CPU    0: hi:  186, btch:  31 usd:   0
>> [962841.266255] CPU    1: hi:  186, btch:  31 usd:   0
>> [962841.266260] Normal per-cpu:
>> [962841.266266] CPU    0: hi:  186, btch:  31 usd:   0
>> [962841.266272] CPU    1: hi:  186, btch:  31 usd: 167
>> [962841.266289] active_anon:60865 inactive_anon:15547 isolated_anon:0
>> [962841.266293]  active_file:221296 inactive_file:1249491 isolated_file:0
>> [962841.266297]  unevictable:0 dirty:4156 writeback:0 unstable:0
>> [962841.266300]  free:47696 slab_reclaimable:325469 slab_unreclaimable:6023
>> [962841.266304]  mapped:8585 shmem:1955 pagetables:4954 bounce:0
>> [962841.266327] DMA free:15904kB min:132kB low:164kB high:196kB active_anon:0kB inactive_anon:0kB
>> active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB
>> present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB
>> slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
>> pages_scanned:0 all_unreclaimable? yes
>> [962841.266344] lowmem_reserve[]: 0 2603 7628 7628
>> [962841.266371] DMA32 free:102056kB min:23020kB low:28772kB high:34528kB active_anon:20256kB
>> inactive_anon:19164kB active_file:160472kB inactive_file:1952944kB unevictable:0kB
>> isolated(anon):0kB isolated(file):0kB present:2666288kB mlocked:0kB dirty:5804kB writeback:0kB
>> mapped:8052kB shmem:4192kB slab_reclaimable:400280kB slab_unreclaimable:3080kB kernel_stack:104kB
>> pagetables:1400kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
>> [962841.266391] lowmem_reserve[]: 0 0 5024 5024
>> [962841.266417] Normal free:72824kB min:44424kB low:55528kB high:66636kB active_anon:223204kB
>> inactive_anon:43024kB active_file:724712kB inactive_file:3045020kB unevictable:0kB
>> isolated(anon):0kB isolated(file):0kB present:5144828kB mlocked:0kB dirty:10820kB writeback:0kB
>> mapped:26288kB shmem:3628kB slab_reclaimable:901596kB slab_unreclaimable:21012kB kernel_stack:2640kB
>> pagetables:18416kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:135 all_unreclaimable? no
>> [962841.266438] lowmem_reserve[]: 0 0 0 0
>> [962841.266448] DMA: 0*4kB 0*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB
>> 3*4096kB = 15904kB
>> [962841.266475] DMA32: 18658*4kB 2005*8kB 437*16kB 112*32kB 13*64kB 0*128kB 0*256kB 0*512kB 0*1024kB
>> 0*2048kB 0*4096kB = 102080kB
>> [962841.266501] Normal: 8194*4kB 4068*8kB 395*16kB 31*32kB 3*64kB 0*128kB 0*256kB 0*512kB 0*1024kB
>> 0*2048kB 0*4096kB = 72824kB
>> [962841.266526] 1472725 total pagecache pages
>> [962841.266532] 0 pages in swap cache
>> [962841.266538] Swap cache stats: add 0, delete 0, find 0/0
>> [962841.266544] Free swap  = 7846908kB
>> [962841.266549] Total swap = 7846908kB
>> [962841.381943] 1994736 pages RAM
>> [962841.381951] 53376 pages reserved
>> [962841.381956] 1122458 pages shared
>> [962841.381961] 819713 pages non-shared
> 
> Looks like an old bug, perhaps:
> https://bugzilla.redhat.com/show_bug.cgi?id=593035
> https://bugzilla.redhat.com/show_bug.cgi?id=728003
> 
> I wonder what the underlying cause is?
> And I also wonder if the NFS code should be more clever
> about handing order-4 allocation failures.

More references:
http://www.mail-archive.com/debian-kernel@lists.debian.org/msg71281.html
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1004619
http://codemonkey.org.uk/2012/02/17/fedora-16-kernel-bugzilla-status-report-20120210-20120217/
https://lkml.org/lkml/2011/2/24/73



