Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1BOHod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 02:44:33 -0500
Received: from ns2.q-leap.de ([88.79.172.217]:51484 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1BOHoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 02:44:30 -0500
Message-ID: <4D5A2EDB.8060603@q-leap.com>
Date: Tue, 15 Feb 2011 08:44:27 +0100
From: Peter Kruse <pk@q-leap.com>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
References: <4D53FE43.8030106@q-leap.com> <alpine.DEB.2.00.1102141046170.26158@router.home>
In-Reply-To: <alpine.DEB.2.00.1102141046170.26158@router.home>
Content-Type: multipart/mixed;
 boundary="------------030305040705020508040607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030305040705020508040607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christoph,

thanks for your response

Christoph Lameter wrote:
> On Thu, 10 Feb 2011, Peter Kruse wrote:
> 
>> today one of our servers went berserk and produced literally 353
>> page allocation failures in 7 minutes until it was reset
>> (sysrq was still working).  I attach one of them as an example.
>> The failures happened for different processes ranging from
>> sshd, top, java, tclsh, ypserv, smbd, portmap, kswapd to Xvnc4.
>> I already reported about an incidence with this server here:
>> https://lkml.org/lkml/2011/1/19/145
> 
> Atomic allocations are failing there? gfpmask = 0x20?
> 
>> we have set vm.min_free_kbytes = 2097152 but the problem
>> obviously did not go away.
> 
> 2GB of reserves? How much memory does your system have?

48GB

> 
>> Please anybody, what is the cause of these failures?
> 
> Could you post the entire messages from the kernel log? We need the OOM
> info to figure out more about the problem.
> 

I attach one of the call traces, or would it be better if I send the
kern.log (about 6MB)?

Best regards,

   Peter

--------------030305040705020508040607
Content-Type: text/plain;
 name="calltrace1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="calltrace1"

Feb 10 11:59:49 beosrv1-t kernel: [1968909.359343] ssh: page allocation failure. order:1, mode:0x20
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359363] Pid: 12985, comm: ssh Not tainted 2.6.32.23-ql-server-14 #1
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359381] Call Trace:
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359390]  <IRQ>  [<ffffffff81071f46>] __alloc_pages_nodemask+0x5ca/0x600
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359422]  [<ffffffff8109428b>] kmem_getpages+0x5c/0x127
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359439]  [<ffffffff81094475>] fallback_alloc+0x11f/0x195
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359455]  [<ffffffff81094614>] ____cache_alloc_node+0x129/0x138
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359473]  [<ffffffff81094fdd>] kmem_cache_alloc+0xd1/0xfe
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359492]  [<ffffffff8133c2f9>] sk_prot_alloc+0x2c/0xcd
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359508]  [<ffffffff8133c427>] sk_clone+0x1b/0x24b
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359525]  [<ffffffff81369ce2>] inet_csk_clone+0x13/0x81
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359545]  [<ffffffff8137d698>] tcp_create_openreq_child+0x1d/0x39c
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359564]  [<ffffffff8137c309>] tcp_v4_syn_recv_sock+0x57/0x1bc
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359581]  [<ffffffff8137d50f>] tcp_check_req+0x210/0x37c
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359600]  [<ffffffffa0154423>] ? ipv4_confirm+0x161/0x179 [nf_conntrack_ipv4]
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359620]  [<ffffffff8137ba63>] tcp_v4_do_rcv+0xc1/0x1d7
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359637]  [<ffffffff8137c021>] tcp_v4_rcv+0x4a8/0x739
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359654]  [<ffffffff8135ba27>] ? nf_hook_slow+0x63/0xc3
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359671]  [<ffffffff81361bb0>] ? ip_local_deliver_finish+0x0/0x1d0
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359705]  [<ffffffff81361ca8>] ip_local_deliver_finish+0xf8/0x1d0
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359739]  [<ffffffff81361df2>] ip_local_deliver+0x72/0x7a
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359771]  [<ffffffff813618ac>] ip_rcv_finish+0x33c/0x356
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359803]  [<ffffffff81361b79>] ip_rcv+0x2b3/0x2ea
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359836]  [<ffffffff813a2861>] ? packet_rcv_spkt+0x10f/0x11a
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359869]  [<ffffffff8134660a>] netif_receive_skb+0x2cb/0x2ed
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359902]  [<ffffffff81346767>] napi_skb_finish+0x28/0x40
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359934]  [<ffffffff81346ba5>] napi_gro_receive+0x2a/0x2f
Feb 10 11:59:49 beosrv1-t kernel: [1968909.359974]  [<ffffffffa001669d>] igb_poll+0x507/0x86a [igb]
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360008]  [<ffffffffa0015ef8>] ? igb_clean_tx_irq+0x1dd/0x47b [igb]
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360043]  [<ffffffff81346cb6>] net_rx_action+0xa7/0x178
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360076]  [<ffffffff8103bd21>] __do_softirq+0x96/0x119
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360109]  [<ffffffff8100bf5c>] call_softirq+0x1c/0x28
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360141]  [<ffffffff8100d9e7>] do_softirq+0x33/0x6b
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360172]  [<ffffffff8103b844>] irq_exit+0x36/0x38
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360202]  [<ffffffff8100d0e9>] do_IRQ+0xa3/0xba
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360233]  [<ffffffff8100b7d3>] ret_from_intr+0x0/0xa
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360263]  <EOI>  [<ffffffffa00f046f>] ? xfs_reclaim_inode_shrink+0xc3/0x112 [xfs]
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360360]  [<ffffffffa00f0451>] ? xfs_reclaim_inode_shrink+0xa5/0x112 [xfs]
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360421]  [<ffffffffa00f04bd>] ? xfs_reclaim_inode_shrink+0x111/0x112 [xfs]
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360473]  [<ffffffff810770fc>] ? shrink_slab+0xd2/0x154
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360505]  [<ffffffff81077e00>] ? try_to_free_pages+0x221/0x31c
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360538]  [<ffffffff81074f4a>] ? isolate_pages_global+0x0/0x1f0
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360572]  [<ffffffff81071d79>] ? __alloc_pages_nodemask+0x3fd/0x600
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360607]  [<ffffffff8109428b>] ? kmem_getpages+0x5c/0x127
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360639]  [<ffffffff81094475>] ? fallback_alloc+0x11f/0x195
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360671]  [<ffffffff81094614>] ? ____cache_alloc_node+0x129/0x138
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360706]  [<ffffffff810a9055>] ? pollwake+0x0/0x5b
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360737]  [<ffffffff810946bf>] ? kmem_cache_alloc_node+0x9c/0xc7
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360770]  [<ffffffff8109472d>] ? __kmalloc_node+0x43/0x45
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360803]  [<ffffffff81340625>] ? __alloc_skb+0x6b/0x164
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360834]  [<ffffffff8133bcc1>] ? sock_alloc_send_pskb+0xdd/0x31c
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360868]  [<ffffffff8133bf10>] ? sock_alloc_send_skb+0x10/0x12
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360901]  [<ffffffff8139e4c2>] ? unix_stream_sendmsg+0x180/0x312
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360936]  [<ffffffff81338270>] ? sock_aio_write+0x109/0x122
Feb 10 11:59:49 beosrv1-t kernel: [1968909.360969]  [<ffffffff8100b7ce>] ? common_interrupt+0xe/0x13
Feb 10 11:59:49 beosrv1-t kernel: [1968909.361002]  [<ffffffff8109a41a>] ? do_sync_write+0xe7/0x12d
Feb 10 11:59:49 beosrv1-t kernel: [1968909.361036]  [<ffffffff81049208>] ? autoremove_wake_function+0x0/0x38
Feb 10 11:59:49 beosrv1-t kernel: [1968909.361070]  [<ffffffff8100b7ce>] ? common_intreclaimable:78357
Feb 10 11:59:49 beosrv1-t kernel: [1968911.211168]  mapped:11679 shmem:26799 pagetables:13497 bounce:0
Feb 10 11:59:49 beosrv1-t kernel: [1968911.211322] Node 0 DMA free:15572kB min:632kB low:788kB high:948kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:14960kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Feb 10 11:59:49 beosrv1-t kernel: [1968911.211505] lowmem_reserve[]: 0 2991 24201 24201
Feb 10 11:59:49 beosrv1-t kernel: [1968911.211545] Node 0 DMA32 free:219668kB min:129476kB low:161844kB high:194212kB active_anon:14216kB inactive_anon:115952kB active_file:74252kB inactive_file:1170312kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3063520kB mlocked:0kB dirty:0kB writeback:0kB mapped:676kB shmem:20kB slab_reclaimable:1026120kB slab_unreclaimable:73808kB kernel_stack:1160kB pagetables:1660kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 10 11:59:49 beosrv1-t kernel: [1968911.211739] lowmem_reserve[]: 0 0 21210 21210
Feb 10 11:59:49 beosrv1-t kernel: [1968911.211777] Node 0 Normal free:965164kB min:917952kB low:1147440kB high:1376928kB active_anon:2742680kB inactive_anon:293184kB active_file:4801512kB inactive_file:11129708kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:21719040kB mlocked:0kB dirty:600kB writeback:0kB mapped:26356kB shmem:4896kB slab_reclaimable:1780208kB slab_unreclaimable:199576kB kernel_stack:1576kB pagetables:22956kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 10 11:59:49 beosrv1-t kernel: [1968911.211990] lowmem_reserve[]: 0 0 0 0
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212027] Node 1 Normal free:1104084kB min:1049088kB low:1311360kB high:1573632kB active_anon:1736816kB inactive_anon:232580kB active_file:4800152kB inactive_file:16498268kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:24821760kB mlocked:0kB dirty:840kB writeback:0kB mapped:19684kB shmem:102280kB slab_reclaimable:295228kB slab_unreclaimable:40044kB kernel_stack:2880kB pagetables:29372kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212239] lowmem_reserve[]: 0 0 0 0
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212276] Node 0 DMA: 1*4kB 2*8kB 2*16kB 1*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15572kB
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212363] Node 0 DMA32: 52481*4kB 280*8kB 115*16kB 41*32kB 10*64kB 5*128kB 2*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 219668kB
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212452] Node 0 Normal: 230307*4kB 4373*8kB 81*16kB 3*32kB 4*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 1*4096kB = 965412kB
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212541] Node 1 Normal: 262151*4kB 5886*8kB 46*16kB 5*32kB 3*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 1*4096kB = 1104332kB
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212630] 9651977 total pagecache pages
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212658] 6684 pages in swap cache
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212685] Swap cache stats: add 198950, delete 192266, find 172190568/172202914
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212735] Free swap  = 41892212kB
Feb 10 11:59:49 beosrv1-t kernel: [1968911.212761] Total swap = 41943032kB
Feb 10 11:59:49 beosrv1-t kernel: [1968911.509010] 12582896 pages RAM
Feb 10 11:59:49 beosrv1-t kernel: [1968911.509038] 193198 pages reserved
Feb 10 11:59:49 beosrv1-t kernel: [1968911.509063] 727898 pages shared
Feb 10 11:59:49 beosrv1-t kernel: [1968911.509089] 11272895 pages non-shared

--------------030305040705020508040607--
