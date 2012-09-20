Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2ITGJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:09:09 -0400
Received: from tee.schottelius.org ([77.109.138.222]:46138 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969Ab2ITGJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:09:05 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2012 02:09:03 EDT
Date: Thu, 20 Sep 2012 08:02:02 +0200
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Out of memory on 3.5 kernels
Message-ID: <20120920060202.GB10758@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.5.4-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

for some time the slab usage is quite high (~3.2 GiB) and whenever I try
to do a backup with ccollect (which is using rsync), a lot of processes
(like chromium) are being killed over night.

I'm running 3.5.4 on a Mac Book Air 4,2, dmesg attached.
This did not happen before ~2 weeks ago, thus I suspect the update from
3.4.2 to 3.5.3 and 3.5.4 to be responsible.

Is this a known bug or only hitting me?

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[52757.432482] 57533 pages reserved
[52757.432484] 31123 pages shared
[52757.432485] 940478 pages non-shared
[52757.432486] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[52757.432493] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[52757.432496] [  207]     0   207    71456     4072   0       0             0 systemd-journal
[52757.432500] [  331]     0   331     1056       45   1       0             0 acpid
[52757.432502] [  332]     0   332     3303      186   3       0             0 crond
[52757.432505] [  334]     0   334    10502      140   1     -17         -1000 sshd
[52757.432507] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[52757.432509] [  341]     0   341     6512       70   1       0             0 systemd-logind
[52757.432512] [  349]     0   349    15747      115   3       0             0 login
[52757.432515] [  356]     0   356     2031       30   0       0             0 agetty
[52757.432517] [  357]     0   357     2031       30   2       0             0 agetty
[52757.432520] [  358]     0   358     2031       30   2       0             0 agetty
[52757.432522] [  359]     0   359     2031       32   0       0             0 agetty
[52757.432524] [  360]     0   360     2031       30   0       0             0 agetty
[52757.432527] [  418]     0   418     3092       58   2       0             0 master
[52757.432529] [  421]    73   421    16374      300   1       0             0 qmgr
[52757.432532] [  433]  1000   433     3423      101   3       0             0 restart-x
[52757.432534] [  444]  1000   444     3423      109   2       0             0 startx
[52757.432537] [  461]  1000   461     3966       36   3       0             0 xinit
[52757.432539] [  462]  1000   462    57250     3012   3       0             0 X
[52757.432541] [  483]  1000   483    13495      394   1       0             0 i3
[52757.432543] [  490]  1000   490     6062       86   3       0             0 unclutter
[52757.432546] [  493]  1000   493     6004       58   3       0             0 dispad
[52757.432548] [  494]  1000   494    31745     6821   1       0             0 urxvtd
[52757.432551] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[52757.432554] [  508]  1000   508     8156      420   2       0             0 zsh
[52757.432556] [  515]     0   515     8482       80   0       0             0 sudo
[52757.432558] [  516]     0   516     6933      235   0       0             0 zsh
[52757.432560] [  530]     0   530     7404      156   1       0             0 wpa_supplicant
[52757.432563] [  585]     0   585     2136       38   0       0             0 dhcpcd
[52757.432565] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[52757.432568] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[52757.432570] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[52757.432573] [ 1312]  1000  1312    14878      696   3       0             0 mutt
[52757.432575] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[52757.432577] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[52757.432580] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[52757.432582] [ 1359]     0  1359     8481       78   3       0             0 sudo
[52757.432585] [ 1360]     0  1360     6933      237   3       0             0 zsh
[52757.432587] [12547]  1000 12547     8729      484   3       0             0 zsh
[52757.432589] [12784]  1000 12784     8156      421   3       0             0 zsh
[52757.432592] [24189]  1000 24189     8156      421   1       0             0 zsh
[52757.432594] [30766]  1000 30766     8156      421   0       0             0 zsh
[52757.432596] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[52757.432599] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[52757.432602] [ 5518]  1000  5518    90770     1574   2       0             0 kded4
[52757.432605] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[52757.432607] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[52757.432610] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[52757.432612] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[52757.432614] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[52757.432617] [ 8065]  1000  8065     6531      321   0       0             0 i3bar
[52757.432619] [ 8066]  1000  8066     7809      207   1       0             0 i3status
[52757.432622] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[52757.432624] [ 8708]     0  8708     2776      120   2       0             0 wpa_cli
[52757.432626] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[52757.432628] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[52757.432631] [ 8776]     0  8776    51901      335   0       0             0 colord
[52757.432634] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[52757.432636] [10002]  1000 10002     8290      403   0       0             0 vim
[52757.432639] [10733]  1000 10733     8156      421   2       0             0 zsh
[52757.432641] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[52757.432644] [10749]  1000 10749     8156      421   2       0             0 zsh
[52757.432646] [10758]  1000 10758    15099      901   1       0             0 mutt
[52757.432649] [10786]  1000 10786     8970      255   0       0             0 ssh
[52757.432651] [10788]  1000 10788     8970      198   0       0             0 ssh
[52757.432654] [10790]  1000 10790     8970      234   0       0             0 ssh
[52757.432656] [15290]  1000 15290     9005      216   0       0             0 ssh
[52757.432659] [15483]     0 15483     5899      125   1       0             0 vpnc
[52757.432661] [15633]  1000 15633     8740      474   2       0             0 zsh
[52757.432663] [16517]  1000 16517     8156      421   2       0             0 zsh
[52757.432666] [16542]  1000 16542     8156      420   0       0             0 zsh
[52757.432668] [16555]  1000 16555     8267      407   0       0             0 vim
[52757.432671] [16569]  1000 16569    21607      140   0       0             0 i3lock
[52757.432674] [ 4043]    73  4043    16331      302   1       0             0 pickup
[52757.432677] [ 4573]     0  4573     3637     1511   1       0             0 atop
[52757.432679] [ 5626]     0  5626     9170      388   1       0             0 crond
[52757.432682] [ 5628]  1000  5628     2937      213   1       0             0 sh
[52757.432684] [ 5631]  1000  5631   171780    11366   1       0             0 offlineimap
[52757.432687] Out of memory: Kill process 5631 (offlineimap) score 11 or sacrifice child
[52757.432690] Killed process 5631 (offlineimap) total-vm:687120kB, anon-rss:44692kB, file-rss:772kB
[52757.491028] offlineimap: page allocation failure: order:0, mode:0x201da
[52757.491034] Pid: 5631, comm: offlineimap Tainted: G        W    3.5.4-1-ARCH #1
[52757.491044] Call Trace:
[52757.491051]  [<ffffffff8111c44b>] warn_alloc_failed+0xeb/0x140
[52757.491054]  [<ffffffff8111f320>] ? drain_pages+0xa0/0xa0
[52757.491057]  [<ffffffff8111fa36>] __alloc_pages_nodemask+0x6a6/0x900
[52757.491061]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[52757.491063]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[52757.491065]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[52757.491069]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[52757.491071]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[52757.491074]  [<ffffffff8118c50c>] ? core_sys_select+0x21c/0x320
[52757.491077]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[52757.491080]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[52757.491083]  [<ffffffff8147ca19>] ? __schedule+0x439/0x920
[52757.491086]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[52757.491089]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[52757.491092]  [<ffffffff810adc92>] ? sys_futex+0x102/0x190
[52757.491094]  [<ffffffff8118c6d6>] ? sys_select+0xc6/0x110
[52757.491096]  [<ffffffff8147e765>] page_fault+0x25/0x30
[52757.491098] Mem-Info:
[52757.491099] Node 0 DMA per-cpu:
[52757.491101] CPU    0: hi:    0, btch:   1 usd:   0
[52757.491102] CPU    1: hi:    0, btch:   1 usd:   0
[52757.491103] CPU    2: hi:    0, btch:   1 usd:   0
[52757.491104] CPU    3: hi:    0, btch:   1 usd:   0
[52757.491105] Node 0 DMA32 per-cpu:
[52757.491107] CPU    0: hi:  186, btch:  31 usd:   0
[52757.491108] CPU    1: hi:  186, btch:  31 usd:   0
[52757.491109] CPU    2: hi:  186, btch:  31 usd:   0
[52757.491110] CPU    3: hi:  186, btch:  31 usd:   0
[52757.491111] Node 0 Normal per-cpu:
[52757.491112] CPU    0: hi:  186, btch:  31 usd:   0
[52757.491113] CPU    1: hi:  186, btch:  31 usd:   0
[52757.491114] CPU    2: hi:  186, btch:  31 usd:   0
[52757.491116] CPU    3: hi:  186, btch:  31 usd:   0
[52757.491119] active_anon:77733 inactive_anon:16076 isolated_anon:0
[52757.491119]  active_file:0 inactive_file:277 isolated_file:0
[52757.491119]  unevictable:1514 dirty:0 writeback:0 unstable:0
[52757.491119]  free:22534 slab_reclaimable:845002 slab_unreclaimable:5776
[52757.491119]  mapped:2896 shmem:47386 pagetables:2422 bounce:0
[52757.491121] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[52757.491125] lowmem_reserve[]: 0 2137 3899 3899
[52757.491128] Node 0 DMA32 free:43892kB min:36900kB low:46124kB high:55348kB active_anon:70476kB inactive_anon:2656kB active_file:0kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1120kB shmem:26740kB slab_reclaimable:2057096kB slab_unreclaimable:1816kB kernel_stack:176kB pagetables:2520kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:134 all_unreclaimable? no
[52757.491132] lowmem_reserve[]: 0 0 1762 1762
[52757.491134] Node 0 Normal free:30404kB min:30416kB low:38020kB high:45624kB active_anon:240456kB inactive_anon:61648kB active_file:0kB inactive_file:1180kB unevictable:5244kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5244kB dirty:0kB writeback:0kB mapped:10464kB shmem:162804kB slab_reclaimable:1322848kB slab_unreclaimable:21288kB kernel_stack:1224kB pagetables:7168kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[52757.491138] lowmem_reserve[]: 0 0 0 0
[52757.491141] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[52757.491147] Node 0 DMA32: 640*4kB 2151*8kB 1241*16kB 13*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44200kB
[52757.491153] Node 0 Normal: 2660*4kB 740*8kB 653*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30528kB
[52757.491159] 48547 total pagecache pages
[52757.491160] 0 pages in swap cache
[52757.491161] Swap cache stats: add 0, delete 0, find 0/0
[52757.491162] Free swap  = 0kB
[52757.491163] Total swap = 0kB
[52757.499797] 1048048 pages RAM
[52757.499799] 57533 pages reserved
[52757.499800] 31143 pages shared
[52757.499801] 940503 pages non-shared
[52874.119416] offlineimap invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[52874.119419] offlineimap cpuset=/ mems_allowed=0
[52874.119421] Pid: 5961, comm: offlineimap Tainted: G        W    3.5.4-1-ARCH #1
[52874.119422] Call Trace:
[52874.119428]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[52874.119431]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[52874.119435]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[52874.119439]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[52874.119442]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[52874.119444]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[52874.119447]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[52874.119450]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[52874.119452]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[52874.119454]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[52874.119457]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[52874.119459]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[52874.119462]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[52874.119464]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[52874.119468]  [<ffffffff812056e4>] ? security_file_permission+0x94/0xb0
[52874.119471]  [<ffffffff81178c41>] ? rw_verify_area+0x61/0xf0
[52874.119473]  [<ffffffff8147e765>] page_fault+0x25/0x30
[52874.119474] Mem-Info:
[52874.119475] Node 0 DMA per-cpu:
[52874.119477] CPU    0: hi:    0, btch:   1 usd:   0
[52874.119478] CPU    1: hi:    0, btch:   1 usd:   0
[52874.119479] CPU    2: hi:    0, btch:   1 usd:   0
[52874.119480] CPU    3: hi:    0, btch:   1 usd:   0
[52874.119481] Node 0 DMA32 per-cpu:
[52874.119483] CPU    0: hi:  186, btch:  31 usd:   0
[52874.119484] CPU    1: hi:  186, btch:  31 usd:   0
[52874.119485] CPU    2: hi:  186, btch:  31 usd:   0
[52874.119486] CPU    3: hi:  186, btch:  31 usd:   0
[52874.119487] Node 0 Normal per-cpu:
[52874.119488] CPU    0: hi:  186, btch:  31 usd:   0
[52874.119489] CPU    1: hi:  186, btch:  31 usd:   0
[52874.119490] CPU    2: hi:  186, btch:  31 usd:   0
[52874.119491] CPU    3: hi:  186, btch:  31 usd:   0
[52874.119494] active_anon:77530 inactive_anon:16067 isolated_anon:0
[52874.119494]  active_file:78 inactive_file:326 isolated_file:0
[52874.119494]  unevictable:1549 dirty:0 writeback:14 unstable:0
[52874.119494]  free:22507 slab_reclaimable:845090 slab_unreclaimable:5790
[52874.119494]  mapped:2941 shmem:47397 pagetables:2426 bounce:0
[52874.119496] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[52874.119499] lowmem_reserve[]: 0 2137 3899 3899
[52874.119502] Node 0 DMA32 free:43888kB min:36900kB low:46124kB high:55348kB active_anon:70824kB inactive_anon:2624kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1124kB shmem:26716kB slab_reclaimable:2057128kB slab_unreclaimable:1824kB kernel_stack:176kB pagetables:2516kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:152 all_unreclaimable? yes
[52874.119505] lowmem_reserve[]: 0 0 1762 1762
[52874.119508] Node 0 Normal free:30300kB min:30416kB low:38020kB high:45624kB active_anon:239296kB inactive_anon:61644kB active_file:312kB inactive_file:1300kB unevictable:5384kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5384kB dirty:0kB writeback:56kB mapped:10640kB shmem:162872kB slab_reclaimable:1323168kB slab_unreclaimable:21336kB kernel_stack:1216kB pagetables:7188kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:16578 all_unreclaimable? yes
[52874.119511] lowmem_reserve[]: 0 0 0 0
[52874.119513] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[52874.119519] Node 0 DMA32: 644*4kB 2136*8kB 1234*16kB 8*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43888kB
[52874.119524] Node 0 Normal: 2725*4kB 721*8kB 662*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30780kB
[52874.119530] 48699 total pagecache pages
[52874.119531] 0 pages in swap cache
[52874.119532] Swap cache stats: add 0, delete 0, find 0/0
[52874.119532] Free swap  = 0kB
[52874.119533] Total swap = 0kB
[52874.128158] 1048048 pages RAM
[52874.128161] 57533 pages reserved
[52874.128162] 31169 pages shared
[52874.128163] 940488 pages non-shared
[52874.128164] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[52874.128171] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[52874.128174] [  207]     0   207    71456     4084   2       0             0 systemd-journal
[52874.128177] [  331]     0   331     1056       45   1       0             0 acpid
[52874.128179] [  332]     0   332     3303      186   2       0             0 crond
[52874.128182] [  334]     0   334    10502      140   1     -17         -1000 sshd
[52874.128185] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[52874.128187] [  341]     0   341     6512       70   1       0             0 systemd-logind
[52874.128190] [  349]     0   349    15747      115   3       0             0 login
[52874.128192] [  356]     0   356     2031       30   0       0             0 agetty
[52874.128195] [  357]     0   357     2031       30   2       0             0 agetty
[52874.128197] [  358]     0   358     2031       30   2       0             0 agetty
[52874.128199] [  359]     0   359     2031       32   0       0             0 agetty
[52874.128202] [  360]     0   360     2031       30   0       0             0 agetty
[52874.128204] [  418]     0   418     3092       75   1       0             0 master
[52874.128207] [  421]    73   421    16374      249   0       0             0 qmgr
[52874.128209] [  433]  1000   433     3423      101   3       0             0 restart-x
[52874.128212] [  444]  1000   444     3423      109   2       0             0 startx
[52874.128214] [  461]  1000   461     3966       36   3       0             0 xinit
[52874.128217] [  462]  1000   462    57250     3010   3       0             0 X
[52874.128219] [  483]  1000   483    13495      393   1       0             0 i3
[52874.128222] [  490]  1000   490     6062       72   3       0             0 unclutter
[52874.128224] [  493]  1000   493     6004       62   1       0             0 dispad
[52874.128226] [  494]  1000   494    31745     6818   1       0             0 urxvtd
[52874.128229] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[52874.128231] [  508]  1000   508     8156      420   2       0             0 zsh
[52874.128234] [  515]     0   515     8482       80   0       0             0 sudo
[52874.128236] [  516]     0   516     6933      235   0       0             0 zsh
[52874.128239] [  530]     0   530     7404      156   2       0             0 wpa_supplicant
[52874.128241] [  585]     0   585     2136       38   0       0             0 dhcpcd
[52874.128244] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[52874.128246] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[52874.128249] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[52874.128252] [ 1312]  1000  1312    14878      736   3       0             0 mutt
[52874.128254] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[52874.128257] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[52874.128259] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[52874.128262] [ 1359]     0  1359     8481       78   3       0             0 sudo
[52874.128264] [ 1360]     0  1360     6933      237   3       0             0 zsh
[52874.128267] [12547]  1000 12547     8729      484   3       0             0 zsh
[52874.128269] [12784]  1000 12784     8156      421   3       0             0 zsh
[52874.128272] [24189]  1000 24189     8156      421   1       0             0 zsh
[52874.128274] [30766]  1000 30766     8156      421   0       0             0 zsh
[52874.128277] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[52874.128279] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[52874.128281] [ 5518]  1000  5518    90770     1572   3       0             0 kded4
[52874.128284] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[52874.128286] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[52874.128289] [ 5534]     0  5534    46649      203   1     -13          -900 polkitd
[52874.128291] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[52874.128294] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[52874.128296] [ 8065]  1000  8065     6531      296   3       0             0 i3bar
[52874.128299] [ 8066]  1000  8066     7809      199   1       0             0 i3status
[52874.128301] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[52874.128303] [ 8708]     0  8708     2776      120   3       0             0 wpa_cli
[52874.128306] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[52874.128308] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[52874.128311] [ 8776]     0  8776    51901      335   0       0             0 colord
[52874.128313] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[52874.128316] [10002]  1000 10002     8290      403   0       0             0 vim
[52874.128319] [10733]  1000 10733     8156      421   2       0             0 zsh
[52874.128322] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[52874.128324] [10749]  1000 10749     8156      421   2       0             0 zsh
[52874.128326] [10758]  1000 10758    15099      885   3       0             0 mutt
[52874.128329] [10786]  1000 10786     8970      271   1       0             0 ssh
[52874.128331] [10788]  1000 10788     8970      198   0       0             0 ssh
[52874.128334] [10790]  1000 10790     8970      252   0       0             0 ssh
[52874.128336] [15290]  1000 15290     9005      216   0       0             0 ssh
[52874.128339] [15483]     0 15483     5899      132   1       0             0 vpnc
[52874.128341] [15633]  1000 15633     8740      474   2       0             0 zsh
[52874.128344] [16517]  1000 16517     8156      421   2       0             0 zsh
[52874.128346] [16542]  1000 16542     8156      420   0       0             0 zsh
[52874.128349] [16555]  1000 16555     8267      407   0       0             0 vim
[52874.128351] [16569]  1000 16569    21607      139   1       0             0 i3lock
[52874.128354] [ 4043]    73  4043    16331      268   0       0             0 pickup
[52874.128357] [ 4573]     0  4573     3672     1546   1       0             0 atop
[52874.128360] [ 5794]     0  5794     9170      388   1       0             0 crond
[52874.128362] [ 5797]  1000  5797     2937      204   2       0             0 sh
[52874.128365] [ 5799]  1000  5799   171782    11212   1       0             0 offlineimap
[52874.128367] Out of memory: Kill process 5799 (offlineimap) score 11 or sacrifice child
[52874.128371] Killed process 5799 (offlineimap) total-vm:687128kB, anon-rss:43908kB, file-rss:940kB
[52874.129572] kded4 invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[52874.129575] kded4 cpuset=/ mems_allowed=0
[52874.129578] Pid: 5518, comm: kded4 Tainted: G        W    3.5.4-1-ARCH #1
[52874.129580] Call Trace:
[52874.129586]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[52874.129591]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[52874.129595]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[52874.129600]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[52874.129605]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[52874.129608]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[52874.129611]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[52874.129615]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[52874.129618]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[52874.129622]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[52874.129626]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[52874.129629]  [<ffffffff8136ef95>] ? sock_update_classid+0x65/0x90
[52874.129633]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[52874.129636]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[52874.129638]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[52874.129641]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[52874.129644]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[52874.129646]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[52874.129651]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[52874.129653]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[52874.129656]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[52874.129660]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[52874.129663]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[52874.129665]  [<ffffffff8147e765>] page_fault+0x25/0x30
[52874.129667] Mem-Info:
[52874.129668] Node 0 DMA per-cpu:
[52874.129671] CPU    0: hi:    0, btch:   1 usd:   0
[52874.129673] CPU    1: hi:    0, btch:   1 usd:   0
[52874.129675] CPU    2: hi:    0, btch:   1 usd:   0
[52874.129677] CPU    3: hi:    0, btch:   1 usd:   0
[52874.129678] Node 0 DMA32 per-cpu:
[52874.129680] CPU    0: hi:  186, btch:  31 usd:   0
[52874.129682] CPU    1: hi:  186, btch:  31 usd:   0
[52874.129684] CPU    2: hi:  186, btch:  31 usd:   0
[52874.129686] CPU    3: hi:  186, btch:  31 usd:   0
[52874.129687] Node 0 Normal per-cpu:
[52874.129690] CPU    0: hi:  186, btch:  31 usd:   0
[52874.129692] CPU    1: hi:  186, btch:  31 usd: 126
[52874.129693] CPU    2: hi:  186, btch:  31 usd:   0
[52874.129695] CPU    3: hi:  186, btch:  31 usd:   0
[52874.129700] active_anon:77530 inactive_anon:16067 isolated_anon:0
[52874.129700]  active_file:78 inactive_file:221 isolated_file:32
[52874.129700]  unevictable:1549 dirty:0 writeback:14 unstable:0
[52874.129700]  free:22507 slab_reclaimable:845090 slab_unreclaimable:5790
[52874.129700]  mapped:2941 shmem:47397 pagetables:2426 bounce:0
[52874.129704] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[52874.129710] lowmem_reserve[]: 0 2137 3899 3899
[52874.129714] Node 0 DMA32 free:43888kB min:36900kB low:46124kB high:55348kB active_anon:70824kB inactive_anon:2624kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1124kB shmem:26716kB slab_reclaimable:2057128kB slab_unreclaimable:1824kB kernel_stack:176kB pagetables:2516kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:300 all_unreclaimable? yes
[52874.129721] lowmem_reserve[]: 0 0 1762 1762
[52874.129724] Node 0 Normal free:30300kB min:30416kB low:38020kB high:45624kB active_anon:239296kB inactive_anon:61644kB active_file:312kB inactive_file:880kB unevictable:5384kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5384kB dirty:0kB writeback:56kB mapped:10640kB shmem:162872kB slab_reclaimable:1323168kB slab_unreclaimable:21336kB kernel_stack:1216kB pagetables:7188kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:18946 all_unreclaimable? yes
[52874.129731] lowmem_reserve[]: 0 0 0 0
[52874.129734] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[52874.129744] Node 0 DMA32: 644*4kB 2136*8kB 1234*16kB 8*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43888kB
[52874.129753] Node 0 Normal: 2725*4kB 721*8kB 662*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30780kB
[52874.129763] 48561 total pagecache pages
[52874.129764] 0 pages in swap cache
[52874.129766] Swap cache stats: add 0, delete 0, find 0/0
[52874.129768] Free swap  = 0kB
[52874.129769] Total swap = 0kB
[52874.138657] 1048048 pages RAM
[52874.138659] 57533 pages reserved
[52874.138660] 30998 pages shared
[52874.138661] 932913 pages non-shared
[52874.138662] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[52874.138667] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[52874.138669] [  207]     0   207    71456     4096   0       0             0 systemd-journal
[52874.138672] [  331]     0   331     1056       45   1       0             0 acpid
[52874.138674] [  332]     0   332     3303      186   2       0             0 crond
[52874.138676] [  334]     0   334    10502      140   1     -17         -1000 sshd
[52874.138677] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[52874.138679] [  341]     0   341     6512       70   1       0             0 systemd-logind
[52874.138682] [  349]     0   349    15747      115   3       0             0 login
[52874.138684] [  356]     0   356     2031       30   0       0             0 agetty
[52874.138685] [  357]     0   357     2031       30   2       0             0 agetty
[52874.138687] [  358]     0   358     2031       30   2       0             0 agetty
[52874.138689] [  359]     0   359     2031       32   0       0             0 agetty
[52874.138691] [  360]     0   360     2031       30   0       0             0 agetty
[52874.138692] [  418]     0   418     3092       75   1       0             0 master
[52874.138694] [  421]    73   421    16374      249   0       0             0 qmgr
[52874.138696] [  433]  1000   433     3423      101   3       0             0 restart-x
[52874.138698] [  444]  1000   444     3423      109   2       0             0 startx
[52874.138699] [  461]  1000   461     3966       36   3       0             0 xinit
[52874.138701] [  462]  1000   462    57250     3010   3       0             0 X
[52874.138703] [  483]  1000   483    13495      393   1       0             0 i3
[52874.138705] [  490]  1000   490     6062       72   3       0             0 unclutter
[52874.138706] [  493]  1000   493     6004       62   1       0             0 dispad
[52874.138708] [  494]  1000   494    31745     6818   1       0             0 urxvtd
[52874.138710] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[52874.138712] [  508]  1000   508     8156      420   2       0             0 zsh
[52874.138713] [  515]     0   515     8482       80   0       0             0 sudo
[52874.138715] [  516]     0   516     6933      235   0       0             0 zsh
[52874.138717] [  530]     0   530     7404      156   2       0             0 wpa_supplicant
[52874.138719] [  585]     0   585     2136       38   0       0             0 dhcpcd
[52874.138720] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[52874.138722] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[52874.138724] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[52874.138726] [ 1312]  1000  1312    14878      736   3       0             0 mutt
[52874.138728] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[52874.138729] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[52874.138731] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[52874.138733] [ 1359]     0  1359     8481       78   3       0             0 sudo
[52874.138735] [ 1360]     0  1360     6933      237   3       0             0 zsh
[52874.138736] [12547]  1000 12547     8729      484   3       0             0 zsh
[52874.138738] [12784]  1000 12784     8156      421   3       0             0 zsh
[52874.138740] [24189]  1000 24189     8156      421   1       0             0 zsh
[52874.138741] [30766]  1000 30766     8156      421   0       0             0 zsh
[52874.138743] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[52874.138745] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[52874.138747] [ 5518]  1000  5518    90770     1572   3       0             0 kded4
[52874.138749] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[52874.138750] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[52874.138752] [ 5534]     0  5534    46649      203   1     -13          -900 polkitd
[52874.138754] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[52874.138756] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[52874.138757] [ 8065]  1000  8065     6531      296   3       0             0 i3bar
[52874.138759] [ 8066]  1000  8066     7809      199   1       0             0 i3status
[52874.138761] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[52874.138762] [ 8708]     0  8708     2776      120   3       0             0 wpa_cli
[52874.138764] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[52874.138766] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[52874.138768] [ 8776]     0  8776    51901      335   0       0             0 colord
[52874.138769] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[52874.138771] [10002]  1000 10002     8290      403   0       0             0 vim
[52874.138774] [10733]  1000 10733     8156      421   2       0             0 zsh
[52874.138775] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[52874.138777] [10749]  1000 10749     8156      421   2       0             0 zsh
[52874.138779] [10758]  1000 10758    15099      885   3       0             0 mutt
[52874.138780] [10786]  1000 10786     8970      271   1       0             0 ssh
[52874.138782] [10788]  1000 10788     8970      198   0       0             0 ssh
[52874.138784] [10790]  1000 10790     8970      252   0       0             0 ssh
[52874.138786] [15290]  1000 15290     9005      216   0       0             0 ssh
[52874.138788] [15483]     0 15483     5899      132   1       0             0 vpnc
[52874.138789] [15633]  1000 15633     8740      474   2       0             0 zsh
[52874.138791] [16517]  1000 16517     8156      421   2       0             0 zsh
[52874.138793] [16542]  1000 16542     8156      420   0       0             0 zsh
[52874.138795] [16555]  1000 16555     8267      407   0       0             0 vim
[52874.138797] [16569]  1000 16569    21607      139   1       0             0 i3lock
[52874.138800] [ 4043]    73  4043    16331      268   0       0             0 pickup
[52874.138802] [ 4573]     0  4573     3672     1546   1       0             0 atop
[52874.138803] [ 5794]     0  5794     9170      388   1       0             0 crond
[52874.138805] [ 5797]  1000  5797     2937      204   2       0             0 sh
[52874.138807] Out of memory: Kill process 5961 (offlineimap) score 11 or sacrifice child
[52993.654038] dispad invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[52993.654042] dispad cpuset=/ mems_allowed=0
[52993.654044] Pid: 493, comm: dispad Tainted: G        W    3.5.4-1-ARCH #1
[52993.654045] Call Trace:
[52993.654051]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[52993.654055]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[52993.654059]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[52993.654063]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[52993.654067]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[52993.654069]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[52993.654072]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[52993.654076]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[52993.654078]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[52993.654080]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[52993.654084]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[52993.654086]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[52993.654089]  [<ffffffff8117952a>] ? do_sync_readv_writev+0xda/0x120
[52993.654092]  [<ffffffff8147ca19>] ? __schedule+0x439/0x920
[52993.654094]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[52993.654097]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[52993.654101]  [<ffffffff81078eb0>] ? update_rmtp+0x70/0x70
[52993.654103]  [<ffffffff8147e765>] page_fault+0x25/0x30
[52993.654104] Mem-Info:
[52993.654105] Node 0 DMA per-cpu:
[52993.654107] CPU    0: hi:    0, btch:   1 usd:   0
[52993.654108] CPU    1: hi:    0, btch:   1 usd:   0
[52993.654110] CPU    2: hi:    0, btch:   1 usd:   0
[52993.654111] CPU    3: hi:    0, btch:   1 usd:   0
[52993.654112] Node 0 DMA32 per-cpu:
[52993.654113] CPU    0: hi:  186, btch:  31 usd:   0
[52993.654115] CPU    1: hi:  186, btch:  31 usd:   0
[52993.654116] CPU    2: hi:  186, btch:  31 usd:   0
[52993.654117] CPU    3: hi:  186, btch:  31 usd:   0
[52993.654118] Node 0 Normal per-cpu:
[52993.654119] CPU    0: hi:  186, btch:  31 usd:  24
[52993.654120] CPU    1: hi:  186, btch:  31 usd:   0
[52993.654122] CPU    2: hi:  186, btch:  31 usd: 183
[52993.654123] CPU    3: hi:  186, btch:  31 usd:   0
[52993.654126] active_anon:77623 inactive_anon:16070 isolated_anon:0
[52993.654126]  active_file:82 inactive_file:0 isolated_file:32
[52993.654126]  unevictable:1549 dirty:0 writeback:17 unstable:0
[52993.654126]  free:22513 slab_reclaimable:845058 slab_unreclaimable:5780
[52993.654126]  mapped:2979 shmem:47432 pagetables:2422 bounce:0
[52993.654128] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[52993.654132] lowmem_reserve[]: 0 2137 3899 3899
[52993.654135] Node 0 DMA32 free:43904kB min:36900kB low:46124kB high:55348kB active_anon:70652kB inactive_anon:2616kB active_file:140kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:4kB mapped:1148kB shmem:26716kB slab_reclaimable:2057064kB slab_unreclaimable:1816kB kernel_stack:168kB pagetables:2512kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:229 all_unreclaimable? yes
[52993.654139] lowmem_reserve[]: 0 0 1762 1762
[52993.654141] Node 0 Normal free:30552kB min:30416kB low:38020kB high:45624kB active_anon:239840kB inactive_anon:61664kB active_file:188kB inactive_file:76kB unevictable:5384kB isolated(anon):0kB isolated(file):128kB present:1804320kB mlocked:5384kB dirty:0kB writeback:64kB mapped:10768kB shmem:163012kB slab_reclaimable:1323104kB slab_unreclaimable:21304kB kernel_stack:1232kB pagetables:7176kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[52993.654146] lowmem_reserve[]: 0 0 0 0
[52993.654149] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[52993.654156] Node 0 DMA32: 666*4kB 2135*8kB 1239*16kB 11*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44144kB
[52993.654162] Node 0 Normal: 2656*4kB 726*8kB 685*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30912kB
[52993.654168] 48440 total pagecache pages
[52993.654169] 0 pages in swap cache
[52993.654170] Swap cache stats: add 0, delete 0, find 0/0
[52993.654171] Free swap  = 0kB
[52993.654172] Total swap = 0kB
[52993.662695] 1048048 pages RAM
[52993.662699] 57533 pages reserved
[52993.662700] 31135 pages shared
[52993.662701] 940208 pages non-shared
[52993.662703] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[52993.662710] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[52993.662713] [  207]     0   207    71456     4054   1       0             0 systemd-journal
[52993.662716] [  331]     0   331     1056       45   1       0             0 acpid
[52993.662719] [  332]     0   332     3303      186   3       0             0 crond
[52993.662721] [  334]     0   334    10502      140   1     -17         -1000 sshd
[52993.662724] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[52993.662726] [  341]     0   341     6512       70   1       0             0 systemd-logind
[52993.662729] [  349]     0   349    15747      115   3       0             0 login
[52993.662731] [  356]     0   356     2031       30   0       0             0 agetty
[52993.662733] [  357]     0   357     2031       30   2       0             0 agetty
[52993.662736] [  358]     0   358     2031       30   2       0             0 agetty
[52993.662738] [  359]     0   359     2031       32   0       0             0 agetty
[52993.662741] [  360]     0   360     2031       30   0       0             0 agetty
[52993.662743] [  418]     0   418     3092       65   3       0             0 master
[52993.662746] [  421]    73   421    16374      258   3       0             0 qmgr
[52993.662749] [  433]  1000   433     3423      101   3       0             0 restart-x
[52993.662752] [  444]  1000   444     3423      109   2       0             0 startx
[52993.662754] [  461]  1000   461     3966       36   3       0             0 xinit
[52993.662757] [  462]  1000   462    57250     3021   1       0             0 X
[52993.662760] [  483]  1000   483    13495      393   0       0             0 i3
[52993.662763] [  490]  1000   490     6062       80   1       0             0 unclutter
[52993.662765] [  493]  1000   493     6004       62   3       0             0 dispad
[52993.662768] [  494]  1000   494    31745     6817   1       0             0 urxvtd
[52993.662770] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[52993.662772] [  508]  1000   508     8156      420   2       0             0 zsh
[52993.662775] [  515]     0   515     8482       80   0       0             0 sudo
[52993.662777] [  516]     0   516     6933      235   0       0             0 zsh
[52993.662779] [  530]     0   530     7404      156   3       0             0 wpa_supplicant
[52993.662782] [  585]     0   585     2136       38   0       0             0 dhcpcd
[52993.662784] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[52993.662786] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[52993.662789] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[52993.662791] [ 1312]  1000  1312    14878      736   3       0             0 mutt
[52993.662794] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[52993.662796] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[52993.662798] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[52993.662801] [ 1359]     0  1359     8481       78   3       0             0 sudo
[52993.662803] [ 1360]     0  1360     6933      237   3       0             0 zsh
[52993.662805] [12547]  1000 12547     8729      484   3       0             0 zsh
[52993.662807] [12784]  1000 12784     8156      421   3       0             0 zsh
[52993.662808] [24189]  1000 24189     8156      421   1       0             0 zsh
[52993.662810] [30766]  1000 30766     8156      421   0       0             0 zsh
[52993.662812] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[52993.662814] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[52993.662815] [ 5518]  1000  5518    90770     1566   1       0             0 kded4
[52993.662817] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[52993.662819] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[52993.662821] [ 5534]     0  5534    46649      205   3     -13          -900 polkitd
[52993.662822] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[52993.662824] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[52993.662826] [ 8065]  1000  8065     6531      317   2       0             0 i3bar
[52993.662828] [ 8066]  1000  8066     7809      227   3       0             0 i3status
[52993.662829] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[52993.662831] [ 8708]     0  8708     2776      122   1       0             0 wpa_cli
[52993.662833] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[52993.662834] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[52993.662836] [ 8776]     0  8776    51901      335   0       0             0 colord
[52993.662838] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[52993.662840] [10002]  1000 10002     8290      403   0       0             0 vim
[52993.662842] [10733]  1000 10733     8156      421   2       0             0 zsh
[52993.662844] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[52993.662845] [10749]  1000 10749     8156      421   2       0             0 zsh
[52993.662847] [10758]  1000 10758    15099      885   3       0             0 mutt
[52993.662849] [10786]  1000 10786     8970      286   0       0             0 ssh
[52993.662850] [10788]  1000 10788     8970      198   0       0             0 ssh
[52993.662852] [10790]  1000 10790     8970      270   0       0             0 ssh
[52993.662854] [15290]  1000 15290     9005      228   0       0             0 ssh
[52993.662856] [15483]     0 15483     5899      154   3       0             0 vpnc
[52993.662858] [15633]  1000 15633     8740      474   2       0             0 zsh
[52993.662860] [16517]  1000 16517     8156      421   2       0             0 zsh
[52993.662861] [16542]  1000 16542     8156      420   0       0             0 zsh
[52993.662863] [16555]  1000 16555     8267      407   0       0             0 vim
[52993.662865] [16569]  1000 16569    21607      139   0       0             0 i3lock
[52993.662867] [ 4043]    73  4043    16331      294   1       0             0 pickup
[52993.662869] [ 4573]     0  4573     3672     1546   1       0             0 atop
[52993.662871] [ 5971]     0  5971     9170      388   0       0             0 crond
[52993.662873] [ 5974]  1000  5974     2937      213   1       0             0 sh
[52993.662875] [ 5976]  1000  5976   155397    11182   0       0             0 offlineimap
[52993.662877] Out of memory: Kill process 5976 (offlineimap) score 11 or sacrifice child
[52993.662879] Killed process 5976 (offlineimap) total-vm:621588kB, anon-rss:44160kB, file-rss:568kB
[52994.155030] X invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[52994.155039] X cpuset=/ mems_allowed=0
[52994.155046] Pid: 462, comm: X Tainted: G        W    3.5.4-1-ARCH #1
[52994.155049] Call Trace:
[52994.155064]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[52994.155075]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[52994.155085]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[52994.155096]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[52994.155107]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[52994.155114]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[52994.155124]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[52994.155134]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[52994.155141]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[52994.155148]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[52994.155157]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[52994.155165]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[52994.155174]  [<ffffffff810643ff>] ? recalc_sigpending+0x1f/0x60
[52994.155181]  [<ffffffff81064b51>] ? dequeue_signal+0x41/0x180
[52994.155189]  [<ffffffff810643ff>] ? recalc_sigpending+0x1f/0x60
[52994.155197]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[52994.155205]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[52994.155214]  [<ffffffff8101f8cf>] ? restore_i387_xstate+0x1af/0x260
[52994.155224]  [<ffffffff810140f0>] ? restore_sigcontext+0x120/0x160
[52994.155231]  [<ffffffff81014e50>] ? sys_rt_sigreturn+0xb0/0xc0
[52994.155237]  [<ffffffff8147e765>] page_fault+0x25/0x30
[52994.155241] Mem-Info:
[52994.155244] Node 0 DMA per-cpu:
[52994.155251] CPU    0: hi:    0, btch:   1 usd:   0
[52994.155255] CPU    1: hi:    0, btch:   1 usd:   0
[52994.155258] CPU    2: hi:    0, btch:   1 usd:   0
[52994.155262] CPU    3: hi:    0, btch:   1 usd:   0
[52994.155264] Node 0 DMA32 per-cpu:
[52994.155272] CPU    0: hi:  186, btch:  31 usd:   0
[52994.155277] CPU    1: hi:  186, btch:  31 usd:  39
[52994.155281] CPU    2: hi:  186, btch:  31 usd:  11
[52994.155286] CPU    3: hi:  186, btch:  31 usd:  30
[52994.155290] Node 0 Normal per-cpu:
[52994.155298] CPU    0: hi:  186, btch:  31 usd:   0
[52994.155304] CPU    1: hi:  186, btch:  31 usd:  65
[52994.155310] CPU    2: hi:  186, btch:  31 usd:  30
[52994.155316] CPU    3: hi:  186, btch:  31 usd:   1
[52994.155331] active_anon:77635 inactive_anon:16063 isolated_anon:0
[52994.155331]  active_file:11 inactive_file:11 isolated_file:0
[52994.155331]  unevictable:1549 dirty:0 writeback:19 unstable:0
[52994.155331]  free:22492 slab_reclaimable:845058 slab_unreclaimable:5780
[52994.155331]  mapped:2921 shmem:47435 pagetables:2422 bounce:0
[52994.155341] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[52994.155362] lowmem_reserve[]: 0 2137 3899 3899
[52994.155365] Node 0 DMA32 free:43772kB min:36900kB low:46124kB high:55348kB active_anon:70652kB inactive_anon:2616kB active_file:0kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1148kB shmem:26716kB slab_reclaimable:2057064kB slab_unreclaimable:1816kB kernel_stack:168kB pagetables:2512kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:179 all_unreclaimable? yes
[52994.155371] lowmem_reserve[]: 0 0 1762 1762
[52994.155374] Node 0 Normal free:30356kB min:30416kB low:38020kB high:45624kB active_anon:239888kB inactive_anon:61636kB active_file:44kB inactive_file:88kB unevictable:5384kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5384kB dirty:0kB writeback:76kB mapped:10536kB shmem:163024kB slab_reclaimable:1323104kB slab_unreclaimable:21304kB kernel_stack:1184kB pagetables:7176kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:385 all_unreclaimable? yes
[52994.155380] lowmem_reserve[]: 0 0 0 0
[52994.155383] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[52994.155392] Node 0 DMA32: 628*4kB 2128*8kB 1233*16kB 5*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43648kB
[52994.155400] Node 0 Normal: 2629*4kB 719*8kB 675*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30588kB
[52994.155408] 48393 total pagecache pages
[52994.155409] 0 pages in swap cache
[52994.155411] Swap cache stats: add 0, delete 0, find 0/0
[52994.155412] Free swap  = 0kB
[52994.155413] Total swap = 0kB
[52994.167250] 1048048 pages RAM
[52994.167253] 57533 pages reserved
[52994.167254] 31124 pages shared
[52994.167255] 940388 pages non-shared
[52994.167257] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[52994.167264] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[52994.167268] [  207]     0   207    71456     4042   2       0             0 systemd-journal
[52994.167273] [  331]     0   331     1056       45   1       0             0 acpid
[52994.167276] [  332]     0   332     3303      186   3       0             0 crond
[52994.167279] [  334]     0   334    10502      140   1     -17         -1000 sshd
[52994.167281] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[52994.167284] [  341]     0   341     6512       70   1       0             0 systemd-logind
[52994.167286] [  349]     0   349    15747      115   3       0             0 login
[52994.167289] [  356]     0   356     2031       30   0       0             0 agetty
[52994.167291] [  357]     0   357     2031       30   2       0             0 agetty
[52994.167294] [  358]     0   358     2031       30   2       0             0 agetty
[52994.167296] [  359]     0   359     2031       32   0       0             0 agetty
[52994.167298] [  360]     0   360     2031       30   0       0             0 agetty
[52994.167301] [  418]     0   418     3092       65   3       0             0 master
[52994.167303] [  421]    73   421    16374      258   3       0             0 qmgr
[52994.167306] [  433]  1000   433     3423      101   3       0             0 restart-x
[52994.167308] [  444]  1000   444     3423      109   2       0             0 startx
[52994.167310] [  461]  1000   461     3966       36   3       0             0 xinit
[52994.167313] [  462]  1000   462    57250     3014   2       0             0 X
[52994.167315] [  483]  1000   483    13495      393   0       0             0 i3
[52994.167317] [  490]  1000   490     6062       72   1       0             0 unclutter
[52994.167320] [  493]  1000   493     6004       58   1       0             0 dispad
[52994.167322] [  494]  1000   494    31745     6825   3       0             0 urxvtd
[52994.167325] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[52994.167327] [  508]  1000   508     8156      420   2       0             0 zsh
[52994.167329] [  515]     0   515     8482       80   0       0             0 sudo
[52994.167332] [  516]     0   516     6933      235   0       0             0 zsh
[52994.167335] [  530]     0   530     7404      156   3       0             0 wpa_supplicant
[52994.167338] [  585]     0   585     2136       38   0       0             0 dhcpcd
[52994.167340] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[52994.167343] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[52994.167345] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[52994.167348] [ 1312]  1000  1312    14878      736   3       0             0 mutt
[52994.167350] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[52994.167353] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[52994.167355] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[52994.167358] [ 1359]     0  1359     8481       78   3       0             0 sudo
[52994.167360] [ 1360]     0  1360     6933      237   3       0             0 zsh
[52994.167363] [12547]  1000 12547     8729      484   3       0             0 zsh
[52994.167365] [12784]  1000 12784     8156      421   3       0             0 zsh
[52994.167367] [24189]  1000 24189     8156      421   1       0             0 zsh
[52994.167369] [30766]  1000 30766     8156      421   0       0             0 zsh
[52994.167372] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[52994.167374] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[52994.167376] [ 5518]  1000  5518    90770     1560   3       0             0 kded4
[52994.167379] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[52994.167381] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[52994.167383] [ 5534]     0  5534    46649      203   3     -13          -900 polkitd
[52994.167385] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[52994.167388] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[52994.167390] [ 8065]  1000  8065     6531      317   2       0             0 i3bar
[52994.167392] [ 8066]  1000  8066     7809      227   3       0             0 i3status
[52994.167395] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[52994.167397] [ 8708]     0  8708     2776      122   1       0             0 wpa_cli
[52994.167399] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[52994.167401] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[52994.167404] [ 8776]     0  8776    51901      335   0       0             0 colord
[52994.167406] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[52994.167408] [10002]  1000 10002     8290      403   0       0             0 vim
[52994.167412] [10733]  1000 10733     8156      421   2       0             0 zsh
[52994.167414] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[52994.167416] [10749]  1000 10749     8156      421   2       0             0 zsh
[52994.167418] [10758]  1000 10758    15099      885   3       0             0 mutt
[52994.167421] [10786]  1000 10786     8970      286   0       0             0 ssh
[52994.167423] [10788]  1000 10788     8970      198   0       0             0 ssh
[52994.167425] [10790]  1000 10790     8970      270   0       0             0 ssh
[52994.167428] [15290]  1000 15290     9005      228   0       0             0 ssh
[52994.167430] [15483]     0 15483     5899      154   3       0             0 vpnc
[52994.167433] [15633]  1000 15633     8740      474   2       0             0 zsh
[52994.167435] [16517]  1000 16517     8156      421   2       0             0 zsh
[52994.167437] [16542]  1000 16542     8156      420   0       0             0 zsh
[52994.167440] [16555]  1000 16555     8267      407   0       0             0 vim
[52994.167442] [16569]  1000 16569    21607      139   0       0             0 i3lock
[52994.167445] [ 4043]    73  4043    16331      294   1       0             0 pickup
[52994.167447] [ 4573]     0  4573     3672     1546   1       0             0 atop
[52994.167450] [ 5971]     0  5971     9170      388   0       0             0 crond
[52994.167452] [ 5974]  1000  5974     2937      213   1       0             0 sh
[52994.167455] [ 6132]  1000  5976   155397    11270   0       0             0 offlineimap
[52994.167457] Out of memory: Kill process 6132 (offlineimap) score 11 or sacrifice child
[52994.167460] Killed process 6132 (offlineimap) total-vm:621588kB, anon-rss:44204kB, file-rss:876kB
[52994.167557] offlineimap: page allocation failure: order:0, mode:0x150
[52994.167560] Pid: 6132, comm: offlineimap Tainted: G        W    3.5.4-1-ARCH #1
[52994.167561] Call Trace:
[52994.167568]  [<ffffffff8111c44b>] warn_alloc_failed+0xeb/0x140
[52994.167571]  [<ffffffff8111fa36>] __alloc_pages_nodemask+0x6a6/0x900
[52994.167575]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[52994.167591]  [<ffffffffa01b8990>] ? metapage_get_blocks+0xa0/0xa0 [jfs]
[52994.167594]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[52994.167599]  [<ffffffffa01b8990>] ? metapage_get_blocks+0xa0/0xa0 [jfs]
[52994.167601]  [<ffffffff81117b7b>] do_read_cache_page+0x4b/0x170
[52994.167603]  [<ffffffff81117cec>] read_cache_page_async+0x1c/0x20
[52994.167605]  [<ffffffff81117cfe>] read_cache_page+0xe/0x20
[52994.167610]  [<ffffffffa01b937c>] __get_metapage+0x1ac/0x590 [jfs]
[52994.167618]  [<ffffffffa00d9a9a>] ? scsi_pool_alloc_command+0x4a/0x80 [scsi_mod]
[52994.167623]  [<ffffffffa01a4026>] xtSearch+0x206/0x5a0 [jfs]
[52994.167627]  [<ffffffffa01a5732>] xtLookup+0x92/0x180 [jfs]
[52994.167630]  [<ffffffff810814c9>] ? finish_task_switch+0x49/0xe0
[52994.167634]  [<ffffffff8147ca19>] ? __schedule+0x439/0x920
[52994.167636]  [<ffffffff81117367>] ? unlock_page+0x27/0x30
[52994.167640]  [<ffffffffa01b9333>] ? __get_metapage+0x163/0x590 [jfs]
[52994.167645]  [<ffffffffa01b146e>] read_index_page+0x2e/0x70 [jfs]
[52994.167649]  [<ffffffffa01b1b12>] add_index+0x212/0x650 [jfs]
[52994.167652]  [<ffffffff811172e0>] ? __lock_page+0x70/0x70
[52994.167655]  [<ffffffff8147ab5e>] ? __wait_on_bit+0x7e/0x90
[52994.167659]  [<ffffffffa01b248c>] dtInsertEntry.isra.5+0x10c/0x4e0 [jfs]
[52994.167662]  [<ffffffff811648ec>] ? kfree+0x2c/0x150
[52994.167666]  [<ffffffffa01b5c27>] dtInsert+0x167/0x240 [jfs]
[52994.167670]  [<ffffffffa01a1bc2>] jfs_create+0x252/0x340 [jfs]
[52994.167673]  [<ffffffff81070001>] ? __cancel_work_timer+0x71/0x130
[52994.167676]  [<ffffffff81190ba7>] ? __d_lookup+0xa7/0x180
[52994.167678]  [<ffffffff811905bc>] ? __d_alloc+0x14c/0x180
[52994.167681]  [<ffffffff8120542c>] ? security_inode_permission+0x1c/0x30
[52994.167684]  [<ffffffff81185d24>] vfs_create+0xb4/0x120
[52994.167686]  [<ffffffff811881e9>] do_last+0x939/0xa90
[52994.167689]  [<ffffffff81188569>] path_openat+0xd9/0x400
[52994.167692]  [<ffffffff811889b1>] do_filp_open+0x41/0xa0
[52994.167695]  [<ffffffff81195426>] ? alloc_fd+0xd6/0x120
[52994.167698]  [<ffffffff811782c6>] do_sys_open+0xf6/0x1e0
[52994.167700]  [<ffffffff811783d1>] sys_open+0x21/0x30
[52994.167703]  [<ffffffff814853ed>] system_call_fastpath+0x1a/0x1f
[52994.167704] Mem-Info:
[52994.167705] Node 0 DMA per-cpu:
[52994.167708] CPU    0: hi:    0, btch:   1 usd:   0
[52994.167709] CPU    1: hi:    0, btch:   1 usd:   0
[52994.167710] CPU    2: hi:    0, btch:   1 usd:   0
[52994.167711] CPU    3: hi:    0, btch:   1 usd:   0
[52994.167712] Node 0 DMA32 per-cpu:
[52994.167714] CPU    0: hi:  186, btch:  31 usd:   1
[52994.167715] CPU    1: hi:  186, btch:  31 usd:  73
[52994.167716] CPU    2: hi:  186, btch:  31 usd:  11
[52994.167717] CPU    3: hi:  186, btch:  31 usd:  30
[52994.167718] Node 0 Normal per-cpu:
[52994.167719] CPU    0: hi:  186, btch:  31 usd:  11
[52994.167729] CPU    1: hi:  186, btch:  31 usd:  89
[52994.167732] CPU    2: hi:  186, btch:  31 usd:  30
[52994.167734] CPU    3: hi:  186, btch:  31 usd:   1
[52994.167741] active_anon:77635 inactive_anon:16063 isolated_anon:0
[52994.167741]  active_file:11 inactive_file:11 isolated_file:0
[52994.167741]  unevictable:1549 dirty:0 writeback:19 unstable:0
[52994.167741]  free:22492 slab_reclaimable:845058 slab_unreclaimable:5780
[52994.167741]  mapped:2921 shmem:47435 pagetables:2422 bounce:0
[52994.167745] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[52994.167753] lowmem_reserve[]: 0 2137 3899 3899
[52994.167758] Node 0 DMA32 free:43772kB min:36900kB low:46124kB high:55348kB active_anon:70652kB inactive_anon:2616kB active_file:0kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1148kB shmem:26716kB slab_reclaimable:2057064kB slab_unreclaimable:1816kB kernel_stack:168kB pagetables:2512kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:220 all_unreclaimable? yes
[52994.167767] lowmem_reserve[]: 0 0 1762 1762
[52994.167772] Node 0 Normal free:30356kB min:30416kB low:38020kB high:45624kB active_anon:239888kB inactive_anon:61636kB active_file:44kB inactive_file:88kB unevictable:5384kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5384kB dirty:0kB writeback:76kB mapped:10536kB shmem:163024kB slab_reclaimable:1323104kB slab_unreclaimable:21304kB kernel_stack:1184kB pagetables:7176kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:467 all_unreclaimable? yes
[52994.167780] lowmem_reserve[]: 0 0 0 0
[52994.167785] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[52994.167797] Node 0 DMA32: 628*4kB 2128*8kB 1233*16kB 5*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43648kB
[52994.167809] Node 0 Normal: 2629*4kB 719*8kB 675*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30588kB
[52994.167821] 48347 total pagecache pages
[52994.167823] 0 pages in swap cache
[52994.167826] Swap cache stats: add 0, delete 0, find 0/0
[52994.167827] Free swap  = 0kB
[52994.167829] Total swap = 0kB
[52994.179337] 1048048 pages RAM
[52994.179339] 57533 pages reserved
[52994.179340] 31066 pages shared
[52994.179341] 940387 pages non-shared
[53112.232321] offlineimap invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[53112.232326] offlineimap cpuset=/ mems_allowed=0
[53112.232330] Pid: 6148, comm: offlineimap Tainted: G        W    3.5.4-1-ARCH #1
[53112.232332] Call Trace:
[53112.232340]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[53112.232346]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[53112.232351]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[53112.232357]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[53112.232362]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[53112.232366]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[53112.232371]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[53112.232376]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[53112.232379]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[53112.232383]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[53112.232388]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[53112.232392]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[53112.232396]  [<ffffffff8118c50c>] ? core_sys_select+0x21c/0x320
[53112.232400]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[53112.232405]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[53112.232409]  [<ffffffff8147ca19>] ? __schedule+0x439/0x920
[53112.232413]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[53112.232417]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[53112.232420]  [<ffffffff8118b74e>] ? poll_select_copy_remaining+0xee/0x140
[53112.232424]  [<ffffffff8118c6d6>] ? sys_select+0xc6/0x110
[53112.232427]  [<ffffffff8147e765>] page_fault+0x25/0x30
[53112.232429] Mem-Info:
[53112.232430] Node 0 DMA per-cpu:
[53112.232434] CPU    0: hi:    0, btch:   1 usd:   0
[53112.232436] CPU    1: hi:    0, btch:   1 usd:   0
[53112.232437] CPU    2: hi:    0, btch:   1 usd:   0
[53112.232439] CPU    3: hi:    0, btch:   1 usd:   0
[53112.232440] Node 0 DMA32 per-cpu:
[53112.232442] CPU    0: hi:  186, btch:  31 usd:   0
[53112.232444] CPU    1: hi:  186, btch:  31 usd:   0
[53112.232445] CPU    2: hi:  186, btch:  31 usd:   0
[53112.232446] CPU    3: hi:  186, btch:  31 usd:   4
[53112.232447] Node 0 Normal per-cpu:
[53112.232448] CPU    0: hi:  186, btch:  31 usd:   0
[53112.232449] CPU    1: hi:  186, btch:  31 usd:  13
[53112.232450] CPU    2: hi:  186, btch:  31 usd:   0
[53112.232452] CPU    3: hi:  186, btch:  31 usd: 168
[53112.232464] active_anon:77752 inactive_anon:16064 isolated_anon:0
[53112.232464]  active_file:57 inactive_file:28 isolated_file:0
[53112.232464]  unevictable:1549 dirty:0 writeback:0 unstable:0
[53112.232464]  free:22501 slab_reclaimable:845050 slab_unreclaimable:5775
[53112.232464]  mapped:3028 shmem:47460 pagetables:2426 bounce:0
[53112.232468] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[53112.232475] lowmem_reserve[]: 0 2137 3899 3899
[53112.232480] Node 0 DMA32 free:43728kB min:36900kB low:46124kB high:55348kB active_anon:70816kB inactive_anon:2616kB active_file:0kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1184kB shmem:26716kB slab_reclaimable:2057064kB slab_unreclaimable:1808kB kernel_stack:176kB pagetables:2524kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:23 all_unreclaimable? yes
[53112.232488] lowmem_reserve[]: 0 0 1762 1762
[53112.232492] Node 0 Normal free:30436kB min:30416kB low:38020kB high:45624kB active_anon:240192kB inactive_anon:61640kB active_file:228kB inactive_file:112kB unevictable:5384kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5384kB dirty:0kB writeback:0kB mapped:10928kB shmem:163124kB slab_reclaimable:1323072kB slab_unreclaimable:21292kB kernel_stack:1240kB pagetables:7180kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[53112.232500] lowmem_reserve[]: 0 0 0 0
[53112.232504] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[53112.232516] Node 0 DMA32: 635*4kB 2131*8kB 1243*16kB 8*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43956kB
[53112.232527] Node 0 Normal: 2745*4kB 787*8kB 605*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30476kB
[53112.232538] 48467 total pagecache pages
[53112.232539] 0 pages in swap cache
[53112.232542] Swap cache stats: add 0, delete 0, find 0/0
[53112.232543] Free swap  = 0kB
[53112.232545] Total swap = 0kB
[53112.245394] 1048048 pages RAM
[53112.245397] 57533 pages reserved
[53112.245398] 31186 pages shared
[53112.245399] 940348 pages non-shared
[53112.245401] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[53112.245407] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[53112.245410] [  207]     0   207    71456     4105   0       0             0 systemd-journal
[53112.245413] [  331]     0   331     1056       45   1       0             0 acpid
[53112.245416] [  332]     0   332     3303      186   3       0             0 crond
[53112.245418] [  334]     0   334    10502      140   1     -17         -1000 sshd
[53112.245421] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[53112.245423] [  341]     0   341     6512       70   1       0             0 systemd-logind
[53112.245425] [  349]     0   349    15747      115   3       0             0 login
[53112.245427] [  356]     0   356     2031       30   0       0             0 agetty
[53112.245430] [  357]     0   357     2031       30   2       0             0 agetty
[53112.245432] [  358]     0   358     2031       30   2       0             0 agetty
[53112.245434] [  359]     0   359     2031       32   0       0             0 agetty
[53112.245438] [  360]     0   360     2031       30   0       0             0 agetty
[53112.245440] [  418]     0   418     3092       59   1       0             0 master
[53112.245442] [  421]    73   421    16374      269   2       0             0 qmgr
[53112.245445] [  433]  1000   433     3423      101   3       0             0 restart-x
[53112.245447] [  444]  1000   444     3423      109   2       0             0 startx
[53112.245449] [  461]  1000   461     3966       36   3       0             0 xinit
[53112.245452] [  462]  1000   462    57250     2998   3       0             0 X
[53112.245455] [  483]  1000   483    13495      393   1       0             0 i3
[53112.245458] [  490]  1000   490     6062       72   0       0             0 unclutter
[53112.245460] [  493]  1000   493     6004       58   2       0             0 dispad
[53112.245463] [  494]  1000   494    31745     6822   3       0             0 urxvtd
[53112.245465] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[53112.245468] [  508]  1000   508     8156      420   2       0             0 zsh
[53112.245470] [  515]     0   515     8482       80   0       0             0 sudo
[53112.245473] [  516]     0   516     6933      235   0       0             0 zsh
[53112.245475] [  530]     0   530     7404      156   1       0             0 wpa_supplicant
[53112.245478] [  585]     0   585     2136       38   0       0             0 dhcpcd
[53112.245480] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[53112.245482] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[53112.245485] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[53112.245487] [ 1312]  1000  1312    14878      736   3       0             0 mutt
[53112.245490] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[53112.245492] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[53112.245495] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[53112.245497] [ 1359]     0  1359     8481       78   3       0             0 sudo
[53112.245499] [ 1360]     0  1360     6933      237   3       0             0 zsh
[53112.245502] [12547]  1000 12547     8729      484   3       0             0 zsh
[53112.245505] [12784]  1000 12784     8156      421   3       0             0 zsh
[53112.245507] [24189]  1000 24189     8156      421   1       0             0 zsh
[53112.245510] [30766]  1000 30766     8156      421   0       0             0 zsh
[53112.245512] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[53112.245514] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[53112.245517] [ 5518]  1000  5518    90770     1560   1       0             0 kded4
[53112.245520] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[53112.245522] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[53112.245525] [ 5534]     0  5534    46649      203   3     -13          -900 polkitd
[53112.245528] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[53112.245533] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[53112.245536] [ 8065]  1000  8065     6531      292   1       0             0 i3bar
[53112.245538] [ 8066]  1000  8066     7809      219   2       0             0 i3status
[53112.245540] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[53112.245543] [ 8708]     0  8708     2776      120   3       0             0 wpa_cli
[53112.245545] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[53112.245547] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[53112.245550] [ 8776]     0  8776    51901      335   0       0             0 colord
[53112.245552] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[53112.245555] [10002]  1000 10002     8290      403   0       0             0 vim
[53112.245559] [10733]  1000 10733     8156      421   2       0             0 zsh
[53112.245561] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[53112.245563] [10749]  1000 10749     8156      421   2       0             0 zsh
[53112.245566] [10758]  1000 10758    15099      885   3       0             0 mutt
[53112.245568] [10786]  1000 10786     8970      302   0       0             0 ssh
[53112.245571] [10788]  1000 10788     8970      198   0       0             0 ssh
[53112.245574] [10790]  1000 10790     8970      288   0       0             0 ssh
[53112.245576] [15290]  1000 15290     9005      216   0       0             0 ssh
[53112.245579] [15483]     0 15483     5899      153   1       0             0 vpnc
[53112.245582] [15633]  1000 15633     8740      474   2       0             0 zsh
[53112.245584] [16517]  1000 16517     8156      421   2       0             0 zsh
[53112.245587] [16542]  1000 16542     8156      420   0       0             0 zsh
[53112.245589] [16555]  1000 16555     8267      407   0       0             0 vim
[53112.245592] [16569]  1000 16569    21607      139   0       0             0 i3lock
[53112.245595] [ 4043]    73  4043    16331      260   2       0             0 pickup
[53112.245597] [ 4573]     0  4573     3672     1546   1       0             0 atop
[53112.245600] [ 6143]     0  6143     9170      388   0       0             0 crond
[53112.245603] [ 6146]  1000  6146     2937      204   1       0             0 sh
[53112.245605] [ 6148]  1000  6148   171790    11334   1       0             0 offlineimap
[53112.245608] Out of memory: Kill process 6148 (offlineimap) score 11 or sacrifice child
[53112.245611] Killed process 6148 (offlineimap) total-vm:687160kB, anon-rss:44576kB, file-rss:760kB
[53227.754039] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[53227.754043] urxvtd cpuset=/ mems_allowed=0
[53227.754045] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[53227.754046] Call Trace:
[53227.754051]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[53227.754056]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[53227.754059]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[53227.754063]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[53227.754067]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[53227.754069]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[53227.754072]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[53227.754075]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[53227.754077]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[53227.754079]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[53227.754082]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[53227.754085]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[53227.754087]  [<ffffffff8147cfd9>] ? preempt_schedule+0x49/0x70
[53227.754090]  [<ffffffff8107066d>] ? queue_work+0x5d/0x70
[53227.754092]  [<ffffffff81070698>] ? schedule_work+0x18/0x20
[53227.754095]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[53227.754097]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[53227.754102]  [<ffffffff81179168>] ? vfs_read+0x138/0x180
[53227.754104]  [<ffffffff8147e765>] page_fault+0x25/0x30
[53227.754105] Mem-Info:
[53227.754106] Node 0 DMA per-cpu:
[53227.754108] CPU    0: hi:    0, btch:   1 usd:   0
[53227.754109] CPU    1: hi:    0, btch:   1 usd:   0
[53227.754110] CPU    2: hi:    0, btch:   1 usd:   0
[53227.754111] CPU    3: hi:    0, btch:   1 usd:   0
[53227.754111] Node 0 DMA32 per-cpu:
[53227.754113] CPU    0: hi:  186, btch:  31 usd:  50
[53227.754114] CPU    1: hi:  186, btch:  31 usd:   0
[53227.754115] CPU    2: hi:  186, btch:  31 usd:   0
[53227.754116] CPU    3: hi:  186, btch:  31 usd:   0
[53227.754117] Node 0 Normal per-cpu:
[53227.754118] CPU    0: hi:  186, btch:  31 usd: 212
[53227.754119] CPU    1: hi:  186, btch:  31 usd: 145
[53227.754120] CPU    2: hi:  186, btch:  31 usd:  30
[53227.754121] CPU    3: hi:  186, btch:  31 usd:   0
[53227.754124] active_anon:77575 inactive_anon:16060 isolated_anon:0
[53227.754124]  active_file:0 inactive_file:57 isolated_file:49
[53227.754124]  unevictable:1549 dirty:0 writeback:3 unstable:0
[53227.754124]  free:22543 slab_reclaimable:845038 slab_unreclaimable:5781
[53227.754124]  mapped:2990 shmem:47470 pagetables:2426 bounce:0
[53227.754126] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[53227.754130] lowmem_reserve[]: 0 2137 3899 3899
[53227.754132] Node 0 DMA32 free:43944kB min:36900kB low:46124kB high:55348kB active_anon:70524kB inactive_anon:2612kB active_file:0kB inactive_file:216kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:8kB mapped:1196kB shmem:26716kB slab_reclaimable:2057064kB slab_unreclaimable:1808kB kernel_stack:176kB pagetables:2488kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:536 all_unreclaimable? yes
[53227.754136] lowmem_reserve[]: 0 0 1762 1762
[53227.754138] Node 0 Normal free:30388kB min:30416kB low:38020kB high:45624kB active_anon:239776kB inactive_anon:61628kB active_file:0kB inactive_file:12kB unevictable:5384kB isolated(anon):0kB isolated(file):196kB present:1804320kB mlocked:5384kB dirty:0kB writeback:4kB mapped:10764kB shmem:163164kB slab_reclaimable:1323024kB slab_unreclaimable:21316kB kernel_stack:1248kB pagetables:7216kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:544 all_unreclaimable? yes
[53227.754142] lowmem_reserve[]: 0 0 0 0
[53227.754144] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[53227.754150] Node 0 DMA32: 656*4kB 2139*8kB 1236*16kB 9*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43960kB
[53227.754155] Node 0 Normal: 2622*4kB 735*8kB 658*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30416kB
[53227.754160] 48465 total pagecache pages
[53227.754161] 0 pages in swap cache
[53227.754162] Swap cache stats: add 0, delete 0, find 0/0
[53227.754163] Free swap  = 0kB
[53227.754164] Total swap = 0kB
[53227.762655] 1048048 pages RAM
[53227.762657] 57533 pages reserved
[53227.762659] 31206 pages shared
[53227.762660] 940063 pages non-shared
[53227.762661] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[53227.762670] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[53227.762673] [  207]     0   207    71456     4132   0       0             0 systemd-journal
[53227.762676] [  331]     0   331     1056       45   1       0             0 acpid
[53227.762679] [  332]     0   332     3303      186   0       0             0 crond
[53227.762682] [  334]     0   334    10502      140   1     -17         -1000 sshd
[53227.762685] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[53227.762688] [  341]     0   341     6512       70   1       0             0 systemd-logind
[53227.762690] [  349]     0   349    15747      115   3       0             0 login
[53227.762693] [  356]     0   356     2031       30   0       0             0 agetty
[53227.762695] [  357]     0   357     2031       30   2       0             0 agetty
[53227.762698] [  358]     0   358     2031       30   2       0             0 agetty
[53227.762701] [  359]     0   359     2031       32   0       0             0 agetty
[53227.762704] [  360]     0   360     2031       30   0       0             0 agetty
[53227.762706] [  418]     0   418     3092       59   1       0             0 master
[53227.762708] [  421]    73   421    16374      278   0       0             0 qmgr
[53227.762710] [  433]  1000   433     3423      101   3       0             0 restart-x
[53227.762711] [  444]  1000   444     3423      109   2       0             0 startx
[53227.762713] [  461]  1000   461     3966       36   3       0             0 xinit
[53227.762715] [  462]  1000   462    57250     3024   3       0             0 X
[53227.762717] [  483]  1000   483    13495      396   1       0             0 i3
[53227.762718] [  490]  1000   490     6062       72   0       0             0 unclutter
[53227.762720] [  493]  1000   493     6004       58   0       0             0 dispad
[53227.762722] [  494]  1000   494    31745     6840   2       0             0 urxvtd
[53227.762723] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[53227.762725] [  508]  1000   508     8156      420   2       0             0 zsh
[53227.762727] [  515]     0   515     8482       80   0       0             0 sudo
[53227.762729] [  516]     0   516     6933      235   0       0             0 zsh
[53227.762730] [  530]     0   530     7404      156   1       0             0 wpa_supplicant
[53227.762732] [  585]     0   585     2136       38   0       0             0 dhcpcd
[53227.762734] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[53227.762735] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[53227.762737] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[53227.762739] [ 1312]  1000  1312    14878      736   3       0             0 mutt
[53227.762741] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[53227.762742] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[53227.762744] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[53227.762746] [ 1359]     0  1359     8481       78   3       0             0 sudo
[53227.762748] [ 1360]     0  1360     6933      237   3       0             0 zsh
[53227.762749] [12547]  1000 12547     8729      484   3       0             0 zsh
[53227.762751] [12784]  1000 12784     8156      421   3       0             0 zsh
[53227.762753] [24189]  1000 24189     8156      421   1       0             0 zsh
[53227.762754] [30766]  1000 30766     8156      421   0       0             0 zsh
[53227.762756] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[53227.762758] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[53227.762760] [ 5518]  1000  5518    90770     1572   3       0             0 kded4
[53227.762762] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[53227.762763] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[53227.762765] [ 5534]     0  5534    46649      203   1     -13          -900 polkitd
[53227.762767] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[53227.762769] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[53227.762770] [ 8065]  1000  8065     6531      301   3       0             0 i3bar
[53227.762772] [ 8066]  1000  8066     7809      180   1       0             0 i3status
[53227.762774] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[53227.762775] [ 8708]     0  8708     2776      124   3       0             0 wpa_cli
[53227.762777] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[53227.762779] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[53227.762781] [ 8776]     0  8776    51901      335   0       0             0 colord
[53227.762782] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[53227.762784] [10002]  1000 10002     8290      403   0       0             0 vim
[53227.762786] [10733]  1000 10733     8156      421   2       0             0 zsh
[53227.762788] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[53227.762790] [10749]  1000 10749     8156      421   2       0             0 zsh
[53227.762791] [10758]  1000 10758    15099      885   3       0             0 mutt
[53227.762793] [10786]  1000 10786     8970      253   0       0             0 ssh
[53227.762795] [10788]  1000 10788     8970      198   0       0             0 ssh
[53227.762797] [10790]  1000 10790     8970      240   0       0             0 ssh
[53227.762799] [15290]  1000 15290     9005      217   0       0             0 ssh
[53227.762801] [15483]     0 15483     5899      139   1       0             0 vpnc
[53227.762802] [15633]  1000 15633     8740      474   2       0             0 zsh
[53227.762804] [16517]  1000 16517     8156      421   2       0             0 zsh
[53227.762806] [16542]  1000 16542     8156      420   0       0             0 zsh
[53227.762808] [16555]  1000 16555     8267      407   0       0             0 vim
[53227.762810] [16569]  1000 16569    21607      139   1       0             0 i3lock
[53227.762812] [ 4043]    73  4043    16331      287   0       0             0 pickup
[53227.762814] [ 4573]     0  4573     3672     1546   1       0             0 atop
[53227.762816] [ 6312]     0  6312     9170      388   0       0             0 crond
[53227.762818] [ 6314]  1000  6314     2937      201   1       0             0 sh
[53227.762820] [ 6317]  1000  6317   155410    10957   0       0             0 offlineimap
[53227.762822] Out of memory: Kill process 6317 (offlineimap) score 11 or sacrifice child
[53227.762824] Killed process 6317 (offlineimap) total-vm:621640kB, anon-rss:43736kB, file-rss:92kB
[53354.707524] vpnc invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[53354.707528] vpnc cpuset=/ mems_allowed=0
[53354.707531] Pid: 15483, comm: vpnc Tainted: G        W    3.5.4-1-ARCH #1
[53354.707533] Call Trace:
[53354.707540]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[53354.707544]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[53354.707548]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[53354.707560]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[53354.707565]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[53354.707568]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[53354.707573]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[53354.707577]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[53354.707581]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[53354.707584]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[53354.707588]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[53354.707592]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[53354.707595]  [<ffffffff8101bf13>] ? native_sched_clock+0x13/0x80
[53354.707598]  [<ffffffff8101bf89>] ? sched_clock+0x9/0x10
[53354.707601]  [<ffffffff81089375>] ? sched_clock_cpu+0xc5/0x120
[53354.707605]  [<ffffffff8108347b>] ? update_rq_clock+0x3b/0x120
[53354.707609]  [<ffffffff810851c6>] ? task_sched_runtime+0x56/0xa0
[53354.707612]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[53354.707616]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[53354.707620]  [<ffffffff810771b7>] ? thread_group_cputime+0xa7/0xc0
[53354.707624]  [<ffffffff81085864>] ? thread_group_times+0x44/0xb0
[53354.707627]  [<ffffffff8106a3d4>] ? do_sys_times+0xa4/0xc0
[53354.707630]  [<ffffffff8147e765>] page_fault+0x25/0x30
[53354.707632] Mem-Info:
[53354.707633] Node 0 DMA per-cpu:
[53354.707636] CPU    0: hi:    0, btch:   1 usd:   0
[53354.707638] CPU    1: hi:    0, btch:   1 usd:   0
[53354.707640] CPU    2: hi:    0, btch:   1 usd:   0
[53354.707641] CPU    3: hi:    0, btch:   1 usd:   0
[53354.707642] Node 0 DMA32 per-cpu:
[53354.707645] CPU    0: hi:  186, btch:  31 usd:   0
[53354.707647] CPU    1: hi:  186, btch:  31 usd:   0
[53354.707648] CPU    2: hi:  186, btch:  31 usd:   0
[53354.707650] CPU    3: hi:  186, btch:  31 usd:   0
[53354.707651] Node 0 Normal per-cpu:
[53354.707653] CPU    0: hi:  186, btch:  31 usd:   0
[53354.707655] CPU    1: hi:  186, btch:  31 usd:   0
[53354.707657] CPU    2: hi:  186, btch:  31 usd:   0
[53354.707658] CPU    3: hi:  186, btch:  31 usd:   0
[53354.707663] active_anon:77594 inactive_anon:16058 isolated_anon:0
[53354.707663]  active_file:10 inactive_file:271 isolated_file:0
[53354.707663]  unevictable:1549 dirty:0 writeback:0 unstable:0
[53354.707663]  free:22493 slab_reclaimable:845038 slab_unreclaimable:5796
[53354.707663]  mapped:3015 shmem:47485 pagetables:2424 bounce:0
[53354.707666] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[53354.707672] lowmem_reserve[]: 0 2137 3899 3899
[53354.707676] Node 0 DMA32 free:43760kB min:36900kB low:46124kB high:55348kB active_anon:70440kB inactive_anon:2608kB active_file:0kB inactive_file:16kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1200kB shmem:26716kB slab_reclaimable:2057064kB slab_unreclaimable:1812kB kernel_stack:176kB pagetables:2512kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:4018 all_unreclaimable? yes
[53354.707682] lowmem_reserve[]: 0 0 1762 1762
[53354.707685] Node 0 Normal free:30372kB min:30416kB low:38020kB high:45624kB active_anon:239936kB inactive_anon:61624kB active_file:40kB inactive_file:1068kB unevictable:5384kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5384kB dirty:0kB writeback:0kB mapped:10860kB shmem:163224kB slab_reclaimable:1323024kB slab_unreclaimable:21372kB kernel_stack:1240kB pagetables:7184kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:15848 all_unreclaimable? yes
[53354.707691] lowmem_reserve[]: 0 0 0 0
[53354.707694] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[53354.707703] Node 0 DMA32: 637*4kB 2138*8kB 1245*16kB 12*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44116kB
[53354.707712] Node 0 Normal: 2654*4kB 713*8kB 682*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30752kB
[53354.707720] 48778 total pagecache pages
[53354.707722] 0 pages in swap cache
[53354.707723] Swap cache stats: add 0, delete 0, find 0/0
[53354.707725] Free swap  = 0kB
[53354.707726] Total swap = 0kB
[53354.719412] 1048048 pages RAM
[53354.719414] 57533 pages reserved
[53354.719415] 31161 pages shared
[53354.719415] 940420 pages non-shared
[53354.719417] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[53354.719422] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[53354.719424] [  207]     0   207    71456     4148   1       0             0 systemd-journal
[53354.719435] [  331]     0   331     1056       45   1       0             0 acpid
[53354.719438] [  332]     0   332     3303      186   3       0             0 crond
[53354.719440] [  334]     0   334    10502      140   1     -17         -1000 sshd
[53354.719443] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[53354.719446] [  341]     0   341     6512       70   1       0             0 systemd-logind
[53354.719448] [  349]     0   349    15747      115   3       0             0 login
[53354.719450] [  356]     0   356     2031       30   0       0             0 agetty
[53354.719453] [  357]     0   357     2031       30   2       0             0 agetty
[53354.719455] [  358]     0   358     2031       30   2       0             0 agetty
[53354.719457] [  359]     0   359     2031       32   0       0             0 agetty
[53354.719460] [  360]     0   360     2031       30   0       0             0 agetty
[53354.719462] [  418]     0   418     3092       75   3       0             0 master
[53354.719465] [  421]    73   421    16374      289   0       0             0 qmgr
[53354.719468] [  433]  1000   433     3423      101   3       0             0 restart-x
[53354.719470] [  444]  1000   444     3423      109   2       0             0 startx
[53354.719472] [  461]  1000   461     3966       36   3       0             0 xinit
[53354.719475] [  462]  1000   462    57250     3006   2       0             0 X
[53354.719477] [  483]  1000   483    13495      393   1       0             0 i3
[53354.719480] [  490]  1000   490     6062       72   3       0             0 unclutter
[53354.719482] [  493]  1000   493     6004       58   2       0             0 dispad
[53354.719485] [  494]  1000   494    31745     6798   3       0             0 urxvtd
[53354.719487] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[53354.719490] [  508]  1000   508     8156      420   2       0             0 zsh
[53354.719492] [  515]     0   515     8482       80   0       0             0 sudo
[53354.719495] [  516]     0   516     6933      235   0       0             0 zsh
[53354.719497] [  530]     0   530     7404      156   3       0             0 wpa_supplicant
[53354.719499] [  585]     0   585     2136       38   0       0             0 dhcpcd
[53354.719502] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[53354.719504] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[53354.719507] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[53354.719509] [ 1312]  1000  1312    14878      736   3       0             0 mutt
[53354.719511] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[53354.719514] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[53354.719516] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[53354.719519] [ 1359]     0  1359     8481       78   3       0             0 sudo
[53354.719521] [ 1360]     0  1360     6933      237   3       0             0 zsh
[53354.719524] [12547]  1000 12547     8729      484   3       0             0 zsh
[53354.719526] [12784]  1000 12784     8156      421   3       0             0 zsh
[53354.719528] [24189]  1000 24189     8156      421   1       0             0 zsh
[53354.719531] [30766]  1000 30766     8156      421   0       0             0 zsh
[53354.719533] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[53354.719536] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[53354.719538] [ 5518]  1000  5518    90770     1560   3       0             0 kded4
[53354.719540] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[53354.719543] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[53354.719545] [ 5534]     0  5534    46649      203   1     -13          -900 polkitd
[53354.719548] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[53354.719550] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[53354.719552] [ 8065]  1000  8065     6531      292   1       0             0 i3bar
[53354.719555] [ 8066]  1000  8066     7809      212   1       0             0 i3status
[53354.719557] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[53354.719559] [ 8708]     0  8708     2776      120   1       0             0 wpa_cli
[53354.719562] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[53354.719564] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[53354.719567] [ 8776]     0  8776    51901      335   0       0             0 colord
[53354.719569] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[53354.719571] [10002]  1000 10002     8290      403   0       0             0 vim
[53354.719575] [10733]  1000 10733     8156      421   2       0             0 zsh
[53354.719577] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[53354.719579] [10749]  1000 10749     8156      421   2       0             0 zsh
[53354.719582] [10758]  1000 10758    15099      885   3       0             0 mutt
[53354.719584] [10786]  1000 10786     8970      268   0       0             0 ssh
[53354.719587] [10788]  1000 10788     8970      198   0       0             0 ssh
[53354.719589] [10790]  1000 10790     8970      258   0       0             0 ssh
[53354.719592] [15290]  1000 15290     9005      216   0       0             0 ssh
[53354.719594] [15483]     0 15483     5899      165   0       0             0 vpnc
[53354.719597] [15633]  1000 15633     8740      474   2       0             0 zsh
[53354.719599] [16517]  1000 16517     8156      421   2       0             0 zsh
[53354.719601] [16542]  1000 16542     8156      420   0       0             0 zsh
[53354.719604] [16555]  1000 16555     8267      407   0       0             0 vim
[53354.719606] [16569]  1000 16569    21607      139   1       0             0 i3lock
[53354.719610] [ 4043]    73  4043    16331      253   1       0             0 pickup
[53354.719612] [ 4573]     0  4573     3672     1546   1       0             0 atop
[53354.719615] [ 6483]     0  6483     9170      388   0       0             0 crond
[53354.719618] [ 6486]  1000  6486     2937      211   1       0             0 sh
[53354.719620] [ 6488]  1000  6488   155406    11071   2       0             0 offlineimap
[53354.719622] Out of memory: Kill process 6488 (offlineimap) score 11 or sacrifice child
[53354.719626] Killed process 6488 (offlineimap) total-vm:621624kB, anon-rss:43752kB, file-rss:532kB
[53354.720785] vpnc invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[53354.720788] vpnc cpuset=/ mems_allowed=0
[53354.720791] Pid: 15483, comm: vpnc Tainted: G        W    3.5.4-1-ARCH #1
[53354.720793] Call Trace:
[53354.720799]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[53354.720804]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[53354.720808]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[53354.720813]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[53354.720818]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[53354.720821]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[53354.720825]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[53354.720829]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[53354.720832]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[53354.720835]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[53354.720839]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[53354.720843]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[53354.720846]  [<ffffffff8101bf13>] ? native_sched_clock+0x13/0x80
[53354.720849]  [<ffffffff8101bf89>] ? sched_clock+0x9/0x10
[53354.720852]  [<ffffffff81089375>] ? sched_clock_cpu+0xc5/0x120
[53354.720856]  [<ffffffff8108347b>] ? update_rq_clock+0x3b/0x120
[53354.720859]  [<ffffffff810851c6>] ? task_sched_runtime+0x56/0xa0
[53354.720863]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[53354.720867]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[53354.720870]  [<ffffffff810771b7>] ? thread_group_cputime+0xa7/0xc0
[53354.720874]  [<ffffffff81085864>] ? thread_group_times+0x44/0xb0
[53354.720877]  [<ffffffff8106a3d4>] ? do_sys_times+0xa4/0xc0
[53354.720880]  [<ffffffff8147e765>] page_fault+0x25/0x30
[53354.720882] Mem-Info:
[53354.720883] Node 0 DMA per-cpu:
[53354.720886] CPU    0: hi:    0, btch:   1 usd:   0
[53354.720888] CPU    1: hi:    0, btch:   1 usd:   0
[53354.720889] CPU    2: hi:    0, btch:   1 usd:   0
[53354.720891] CPU    3: hi:    0, btch:   1 usd:   0
[53354.720892] Node 0 DMA32 per-cpu:
[53354.720895] CPU    0: hi:  186, btch:  31 usd:   0
[53354.720896] CPU    1: hi:  186, btch:  31 usd:   0
[53354.720898] CPU    2: hi:  186, btch:  31 usd:   0
[53354.720899] CPU    3: hi:  186, btch:  31 usd:   0
[53354.720900] Node 0 Normal per-cpu:
[53354.720902] CPU    0: hi:  186, btch:  31 usd:   0
[53354.720904] CPU    1: hi:  186, btch:  31 usd:   0
[53354.720906] CPU    2: hi:  186, btch:  31 usd:   0
[53354.720907] CPU    3: hi:  186, btch:  31 usd:   0
[53354.720912] active_anon:77594 inactive_anon:16058 isolated_anon:0
[53354.720912]  active_file:10 inactive_file:271 isolated_file:0
[53354.720912]  unevictable:1549 dirty:0 writeback:0 unstable:0
[53354.720912]  free:22493 slab_reclaimable:845038 slab_unreclaimable:5796
[53354.720912]  mapped:3015 shmem:47485 pagetables:2424 bounce:0
[53354.720915] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[53354.720920] lowmem_reserve[]: 0 2137 3899 3899
[53354.720924] Node 0 DMA32 free:43760kB min:36900kB low:46124kB high:55348kB active_anon:70440kB inactive_anon:2608kB active_file:0kB inactive_file:16kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1200kB shmem:26716kB slab_reclaimable:2057064kB slab_unreclaimable:1812kB kernel_stack:176kB pagetables:2512kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:4306 all_unreclaimable? yes
[53354.720930] lowmem_reserve[]: 0 0 1762 1762
[53354.720933] Node 0 Normal free:30372kB min:30416kB low:38020kB high:45624kB active_anon:239936kB inactive_anon:61624kB active_file:40kB inactive_file:1068kB unevictable:5384kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5384kB dirty:0kB writeback:0kB mapped:10860kB shmem:163224kB slab_reclaimable:1323024kB slab_unreclaimable:21372kB kernel_stack:1240kB pagetables:7184kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:16136 all_unreclaimable? yes
[53354.720938] lowmem_reserve[]: 0 0 0 0
[53354.720941] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[53354.720950] Node 0 DMA32: 637*4kB 2138*8kB 1245*16kB 12*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44116kB
[53354.720958] Node 0 Normal: 2654*4kB 713*8kB 682*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30752kB
[53354.720966] 48778 total pagecache pages
[53354.720967] 0 pages in swap cache
[53354.720969] Swap cache stats: add 0, delete 0, find 0/0
[53354.720970] Free swap  = 0kB
[53354.720971] Total swap = 0kB
[53354.731070] 1048048 pages RAM
[53354.731073] 57533 pages reserved
[53354.731074] 31163 pages shared
[53354.731075] 940353 pages non-shared
[53354.731076] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[53354.731082] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[53354.731085] [  207]     0   207    71456     4148   3       0             0 systemd-journal
[53354.731088] [  331]     0   331     1056       45   1       0             0 acpid
[53354.731091] [  332]     0   332     3303      186   3       0             0 crond
[53354.731093] [  334]     0   334    10502      140   1     -17         -1000 sshd
[53354.731094] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[53354.731096] [  341]     0   341     6512       70   1       0             0 systemd-logind
[53354.731098] [  349]     0   349    15747      115   3       0             0 login
[53354.731099] [  356]     0   356     2031       30   0       0             0 agetty
[53354.731101] [  357]     0   357     2031       30   2       0             0 agetty
[53354.731102] [  358]     0   358     2031       30   2       0             0 agetty
[53354.731104] [  359]     0   359     2031       32   0       0             0 agetty
[53354.731106] [  360]     0   360     2031       30   0       0             0 agetty
[53354.731107] [  418]     0   418     3092       75   3       0             0 master
[53354.731109] [  421]    73   421    16374      289   0       0             0 qmgr
[53354.731111] [  433]  1000   433     3423      101   3       0             0 restart-x
[53354.731112] [  444]  1000   444     3423      109   2       0             0 startx
[53354.731114] [  461]  1000   461     3966       36   3       0             0 xinit
[53354.731115] [  462]  1000   462    57250     3006   1       0             0 X
[53354.731117] [  483]  1000   483    13495      393   1       0             0 i3
[53354.731119] [  490]  1000   490     6062       72   3       0             0 unclutter
[53354.731120] [  493]  1000   493     6004       58   2       0             0 dispad
[53354.731122] [  494]  1000   494    31745     6798   3       0             0 urxvtd
[53354.731123] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[53354.731125] [  508]  1000   508     8156      420   2       0             0 zsh
[53354.731127] [  515]     0   515     8482       80   0       0             0 sudo
[53354.731128] [  516]     0   516     6933      235   0       0             0 zsh
[53354.731130] [  530]     0   530     7404      156   3       0             0 wpa_supplicant
[53354.731131] [  585]     0   585     2136       38   0       0             0 dhcpcd
[53354.731133] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[53354.731134] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[53354.731136] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[53354.731138] [ 1312]  1000  1312    14878      736   3       0             0 mutt
[53354.731139] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[53354.731141] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[53354.731142] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[53354.731144] [ 1359]     0  1359     8481       78   3       0             0 sudo
[53354.731146] [ 1360]     0  1360     6933      237   3       0             0 zsh
[53354.731147] [12547]  1000 12547     8729      484   3       0             0 zsh
[53354.731149] [12784]  1000 12784     8156      421   3       0             0 zsh
[53354.731150] [24189]  1000 24189     8156      421   1       0             0 zsh
[53354.731152] [30766]  1000 30766     8156      421   0       0             0 zsh
[53354.731154] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[53354.731155] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[53354.731157] [ 5518]  1000  5518    90770     1560   3       0             0 kded4
[53354.731159] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[53354.731160] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[53354.731162] [ 5534]     0  5534    46649      203   1     -13          -900 polkitd
[53354.731163] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[53354.731165] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[53354.731167] [ 8065]  1000  8065     6531      292   1       0             0 i3bar
[53354.731168] [ 8066]  1000  8066     7809      212   3       0             0 i3status
[53354.731170] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[53354.731171] [ 8708]     0  8708     2776      120   1       0             0 wpa_cli
[53354.731173] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[53354.731174] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[53354.731176] [ 8776]     0  8776    51901      335   0       0             0 colord
[53354.731178] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[53354.731179] [10002]  1000 10002     8290      403   0       0             0 vim
[53354.731182] [10733]  1000 10733     8156      421   2       0             0 zsh
[53354.731183] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[53354.731185] [10749]  1000 10749     8156      421   2       0             0 zsh
[53354.731186] [10758]  1000 10758    15099      885   3       0             0 mutt
[53354.731188] [10786]  1000 10786     8970      268   0       0             0 ssh
[53354.731189] [10788]  1000 10788     8970      198   0       0             0 ssh
[53354.731191] [10790]  1000 10790     8970      258   0       0             0 ssh
[53354.731193] [15290]  1000 15290     9005      216   0       0             0 ssh
[53354.731194] [15483]     0 15483     5899      165   2       0             0 vpnc
[53354.731196] [15633]  1000 15633     8740      474   2       0             0 zsh
[53354.731198] [16517]  1000 16517     8156      421   2       0             0 zsh
[53354.731199] [16542]  1000 16542     8156      420   0       0             0 zsh
[53354.731201] [16555]  1000 16555     8267      407   0       0             0 vim
[53354.731203] [16569]  1000 16569    21607      139   1       0             0 i3lock
[53354.731205] [ 4043]    73  4043    16331      253   1       0             0 pickup
[53354.731207] [ 4573]     0  4573     3672     1546   1       0             0 atop
[53354.731209] [ 6483]     0  6483     9170      388   0       0             0 crond
[53354.731210] [ 6486]  1000  6486     2937      211   1       0             0 sh
[53354.731212] [ 6523]  1000  6488   155406    11198   2       0             0 offlineimap
[53354.731213] Out of memory: Kill process 6523 (offlineimap) score 11 or sacrifice child
[53354.731216] Killed process 6523 (offlineimap) total-vm:621624kB, anon-rss:43824kB, file-rss:968kB
[53469.613850] kded4 invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[53469.613853] kded4 cpuset=/ mems_allowed=0
[53469.613855] Pid: 5518, comm: kded4 Tainted: G        W    3.5.4-1-ARCH #1
[53469.613856] Call Trace:
[53469.613862]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[53469.613866]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[53469.613870]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[53469.613874]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[53469.613878]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[53469.613880]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[53469.613883]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[53469.613886]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[53469.613889]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[53469.613891]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[53469.613894]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[53469.613897]  [<ffffffff8136ef95>] ? sock_update_classid+0x65/0x90
[53469.613900]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[53469.613902]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[53469.613904]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[53469.613907]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[53469.613908]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[53469.613911]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[53469.613913]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[53469.613915]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[53469.613917]  [<ffffffff8147e765>] page_fault+0x25/0x30
[53469.613919] Mem-Info:
[53469.613920] Node 0 DMA per-cpu:
[53469.613922] CPU    0: hi:    0, btch:   1 usd:   0
[53469.613923] CPU    1: hi:    0, btch:   1 usd:   0
[53469.613924] CPU    2: hi:    0, btch:   1 usd:   0
[53469.613925] CPU    3: hi:    0, btch:   1 usd:   0
[53469.613926] Node 0 DMA32 per-cpu:
[53469.613928] CPU    0: hi:  186, btch:  31 usd:   0
[53469.613929] CPU    1: hi:  186, btch:  31 usd:   0
[53469.613930] CPU    2: hi:  186, btch:  31 usd:   0
[53469.613931] CPU    3: hi:  186, btch:  31 usd:   0
[53469.613932] Node 0 Normal per-cpu:
[53469.613934] CPU    0: hi:  186, btch:  31 usd:  48
[53469.613935] CPU    1: hi:  186, btch:  31 usd:   0
[53469.613936] CPU    2: hi:  186, btch:  31 usd:   0
[53469.613937] CPU    3: hi:  186, btch:  31 usd:   0
[53469.613940] active_anon:77624 inactive_anon:16062 isolated_anon:0
[53469.613940]  active_file:0 inactive_file:210 isolated_file:0
[53469.613940]  unevictable:1683 dirty:0 writeback:0 unstable:0
[53469.613940]  free:22516 slab_reclaimable:845038 slab_unreclaimable:5770
[53469.613940]  mapped:2987 shmem:47511 pagetables:2424 bounce:0
[53469.613942] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[53469.613947] lowmem_reserve[]: 0 2137 3899 3899
[53469.613949] Node 0 DMA32 free:43888kB min:36900kB low:46124kB high:55348kB active_anon:70808kB inactive_anon:2616kB active_file:0kB inactive_file:8kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1180kB shmem:26728kB slab_reclaimable:2057048kB slab_unreclaimable:1808kB kernel_stack:176kB pagetables:2512kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:229 all_unreclaimable? yes
[53469.613954] lowmem_reserve[]: 0 0 1762 1762
[53469.613956] Node 0 Normal free:30336kB min:30416kB low:38020kB high:45624kB active_anon:239688kB inactive_anon:61632kB active_file:0kB inactive_file:832kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:10768kB shmem:163316kB slab_reclaimable:1323040kB slab_unreclaimable:21272kB kernel_stack:1224kB pagetables:7184kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1489 all_unreclaimable? yes
[53469.613960] lowmem_reserve[]: 0 0 0 0
[53469.613962] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[53469.613969] Node 0 DMA32: 632*4kB 2134*8kB 1244*16kB 13*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44016kB
[53469.613975] Node 0 Normal: 2683*4kB 704*8kB 682*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30796kB
[53469.613980] 48610 total pagecache pages
[53469.613981] 0 pages in swap cache
[53469.613983] Swap cache stats: add 0, delete 0, find 0/0
[53469.613983] Free swap  = 0kB
[53469.613984] Total swap = 0kB
[53469.622349] 1048048 pages RAM
[53469.622352] 57533 pages reserved
[53469.622353] 31173 pages shared
[53469.622355] 940316 pages non-shared
[53469.622356] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[53469.622363] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[53469.622365] [  207]     0   207    71456     4129   3       0             0 systemd-journal
[53469.622369] [  331]     0   331     1056       45   1       0             0 acpid
[53469.622371] [  332]     0   332     3303      190   3       0             0 crond
[53469.622374] [  334]     0   334    10502      140   1     -17         -1000 sshd
[53469.622377] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[53469.622380] [  341]     0   341     6512       70   1       0             0 systemd-logind
[53469.622382] [  349]     0   349    15747      115   3       0             0 login
[53469.622385] [  356]     0   356     2031       30   0       0             0 agetty
[53469.622388] [  357]     0   357     2031       30   2       0             0 agetty
[53469.622391] [  358]     0   358     2031       30   2       0             0 agetty
[53469.622393] [  359]     0   359     2031       32   0       0             0 agetty
[53469.622396] [  360]     0   360     2031       30   0       0             0 agetty
[53469.622399] [  418]     0   418     3092       58   1       0             0 master
[53469.622402] [  421]    73   421    16374      300   0       0             0 qmgr
[53469.622405] [  433]  1000   433     3423      101   3       0             0 restart-x
[53469.622408] [  444]  1000   444     3423      109   2       0             0 startx
[53469.622410] [  461]  1000   461     3966       36   3       0             0 xinit
[53469.622413] [  462]  1000   462    57250     3011   3       0             0 X
[53469.622416] [  483]  1000   483    13495      393   0       0             0 i3
[53469.622419] [  490]  1000   490     6062       72   0       0             0 unclutter
[53469.622422] [  493]  1000   493     6004       58   3       0             0 dispad
[53469.622424] [  494]  1000   494    31745     6798   1       0             0 urxvtd
[53469.622427] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[53469.622429] [  508]  1000   508     8156      420   2       0             0 zsh
[53469.622432] [  515]     0   515     8482       80   0       0             0 sudo
[53469.622434] [  516]     0   516     6933      235   0       0             0 zsh
[53469.622436] [  530]     0   530     7404      156   2       0             0 wpa_supplicant
[53469.622438] [  585]     0   585     2136       38   0       0             0 dhcpcd
[53469.622441] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[53469.622443] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[53469.622445] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[53469.622448] [ 1312]  1000  1312    14878      717   2       0             0 mutt
[53469.622450] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[53469.622452] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[53469.622454] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[53469.622457] [ 1359]     0  1359     8481       78   3       0             0 sudo
[53469.622459] [ 1360]     0  1360     6933      237   3       0             0 zsh
[53469.622461] [12547]  1000 12547     8729      484   3       0             0 zsh
[53469.622463] [12784]  1000 12784     8156      421   3       0             0 zsh
[53469.622465] [24189]  1000 24189     8156      421   1       0             0 zsh
[53469.622468] [30766]  1000 30766     8156      421   0       0             0 zsh
[53469.622470] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[53469.622472] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[53469.622475] [ 5518]  1000  5518    90770     1560   1       0             0 kded4
[53469.622477] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[53469.622479] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[53469.622482] [ 5534]     0  5534    46649      203   1     -13          -900 polkitd
[53469.622484] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[53469.622486] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[53469.622488] [ 8065]  1000  8065     6531      297   1       0             0 i3bar
[53469.622491] [ 8066]  1000  8066     7809      212   2       0             0 i3status
[53469.622493] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[53469.622495] [ 8708]     0  8708     2776      126   1       0             0 wpa_cli
[53469.622497] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[53469.622500] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[53469.622502] [ 8776]     0  8776    51901      335   0       0             0 colord
[53469.622504] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[53469.622507] [10002]  1000 10002     8290      403   0       0             0 vim
[53469.622510] [10733]  1000 10733     8156      421   2       0             0 zsh
[53469.622512] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[53469.622514] [10749]  1000 10749     8156      421   2       0             0 zsh
[53469.622516] [10758]  1000 10758    15099      929   1       0             0 mutt
[53469.622519] [10786]  1000 10786     8970      283   0       0             0 ssh
[53469.622521] [10788]  1000 10788     8970      198   0       0             0 ssh
[53469.622523] [10790]  1000 10790     8970      276   0       0             0 ssh
[53469.622525] [15290]  1000 15290     9005      216   0       0             0 ssh
[53469.622528] [15483]     0 15483     5899      157   3       0             0 vpnc
[53469.622530] [15633]  1000 15633     8740      474   2       0             0 zsh
[53469.622532] [16517]  1000 16517     8156      421   2       0             0 zsh
[53469.622535] [16542]  1000 16542     8156      420   0       0             0 zsh
[53469.622537] [16555]  1000 16555     8267      407   0       0             0 vim
[53469.622539] [16569]  1000 16569    21607      139   0       0             0 i3lock
[53469.622542] [ 4043]    73  4043    16331      279   1       0             0 pickup
[53469.622545] [ 4573]     0  4573     3806     1677   1       0             0 atop
[53469.622547] [ 6652]     0  6652     9170      388   1       0             0 crond
[53469.622549] [ 6655]  1000  6655     2937      211   2       0             0 sh
[53469.622552] [ 6657]  1000  6657   155397    11132   2       0             0 offlineimap
[53469.622554] Out of memory: Kill process 6657 (offlineimap) score 11 or sacrifice child
[53469.622557] Killed process 6657 (offlineimap) total-vm:621588kB, anon-rss:43784kB, file-rss:744kB
[53589.915394] unclutter invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[53589.915398] unclutter cpuset=/ mems_allowed=0
[53589.915400] Pid: 490, comm: unclutter Tainted: G        W    3.5.4-1-ARCH #1
[53589.915401] Call Trace:
[53589.915407]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[53589.915412]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[53589.915415]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[53589.915420]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[53589.915424]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[53589.915426]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[53589.915429]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[53589.915433]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[53589.915435]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[53589.915438]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[53589.915441]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[53589.915444]  [<ffffffff8108bfc2>] ? dequeue_entity+0xb2/0x210
[53589.915447]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[53589.915449]  [<ffffffff8147ca19>] ? __schedule+0x439/0x920
[53589.915453]  [<ffffffff81078d59>] ? enqueue_hrtimer+0x29/0xc0
[53589.915455]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[53589.915458]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[53589.915461]  [<ffffffff81079532>] ? hrtimer_cancel+0x22/0x30
[53589.915463]  [<ffffffff8147bc54>] ? do_nanosleep+0xa4/0xd0
[53589.915466]  [<ffffffff8107a127>] ? hrtimer_nanosleep+0xa7/0x150
[53589.915468]  [<ffffffff81078eb0>] ? update_rmtp+0x70/0x70
[53589.915470]  [<ffffffff81079a54>] ? hrtimer_start_range_ns+0x14/0x20
[53589.915473]  [<ffffffff8147e765>] page_fault+0x25/0x30
[53589.915474] Mem-Info:
[53589.915475] Node 0 DMA per-cpu:
[53589.915477] CPU    0: hi:    0, btch:   1 usd:   0
[53589.915478] CPU    1: hi:    0, btch:   1 usd:   0
[53589.915480] CPU    2: hi:    0, btch:   1 usd:   0
[53589.915481] CPU    3: hi:    0, btch:   1 usd:   0
[53589.915482] Node 0 DMA32 per-cpu:
[53589.915483] CPU    0: hi:  186, btch:  31 usd:   0
[53589.915485] CPU    1: hi:  186, btch:  31 usd:   0
[53589.915486] CPU    2: hi:  186, btch:  31 usd:   0
[53589.915487] CPU    3: hi:  186, btch:  31 usd:   0
[53589.915488] Node 0 Normal per-cpu:
[53589.915489] CPU    0: hi:  186, btch:  31 usd: 125
[53589.915490] CPU    1: hi:  186, btch:  31 usd:   0
[53589.915492] CPU    2: hi:  186, btch:  31 usd:  18
[53589.915493] CPU    3: hi:  186, btch:  31 usd:   0
[53589.915496] active_anon:77623 inactive_anon:16059 isolated_anon:0
[53589.915496]  active_file:0 inactive_file:0 isolated_file:26
[53589.915496]  unevictable:1683 dirty:0 writeback:0 unstable:0
[53589.915496]  free:22517 slab_reclaimable:845030 slab_unreclaimable:5744
[53589.915496]  mapped:3033 shmem:47526 pagetables:2422 bounce:0
[53589.915498] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[53589.915502] lowmem_reserve[]: 0 2137 3899 3899
[53589.915505] Node 0 DMA32 free:43828kB min:36900kB low:46124kB high:55348kB active_anon:71032kB inactive_anon:2604kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1192kB shmem:26716kB slab_reclaimable:2057048kB slab_unreclaimable:1808kB kernel_stack:176kB pagetables:2488kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:84 all_unreclaimable? yes
[53589.915509] lowmem_reserve[]: 0 0 1762 1762
[53589.915511] Node 0 Normal free:30400kB min:30416kB low:38020kB high:45624kB active_anon:239460kB inactive_anon:61632kB active_file:0kB inactive_file:0kB unevictable:5920kB isolated(anon):0kB isolated(file):104kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:10940kB shmem:163388kB slab_reclaimable:1323008kB slab_unreclaimable:21168kB kernel_stack:1232kB pagetables:7200kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:426 all_unreclaimable? yes
[53589.915516] lowmem_reserve[]: 0 0 0 0
[53589.915518] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[53589.915524] Node 0 DMA32: 637*4kB 2128*8kB 1234*16kB 13*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43828kB
[53589.915530] Node 0 Normal: 2699*4kB 719*8kB 664*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30692kB
[53589.915536] 48404 total pagecache pages
[53589.915537] 0 pages in swap cache
[53589.915538] Swap cache stats: add 0, delete 0, find 0/0
[53589.915539] Free swap  = 0kB
[53589.915540] Total swap = 0kB
[53589.923945] 1048048 pages RAM
[53589.923948] 57533 pages reserved
[53589.923949] 31169 pages shared
[53589.923950] 940313 pages non-shared
[53589.923951] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[53589.923958] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[53589.923961] [  207]     0   207    71456     4144   1       0             0 systemd-journal
[53589.923964] [  331]     0   331     1056       45   1       0             0 acpid
[53589.923967] [  332]     0   332     3303      190   3       0             0 crond
[53589.923969] [  334]     0   334    10502      140   1     -17         -1000 sshd
[53589.923972] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[53589.923974] [  341]     0   341     6512       70   1       0             0 systemd-logind
[53589.923977] [  349]     0   349    15747      115   3       0             0 login
[53589.923979] [  356]     0   356     2031       30   0       0             0 agetty
[53589.923982] [  357]     0   357     2031       30   2       0             0 agetty
[53589.923984] [  358]     0   358     2031       30   2       0             0 agetty
[53589.923987] [  359]     0   359     2031       32   0       0             0 agetty
[53589.923989] [  360]     0   360     2031       30   0       0             0 agetty
[53589.923991] [  418]     0   418     3092       75   2       0             0 master
[53589.923993] [  421]    73   421    16374      249   0       0             0 qmgr
[53589.923996] [  433]  1000   433     3423      101   3       0             0 restart-x
[53589.923998] [  444]  1000   444     3423      109   2       0             0 startx
[53589.924001] [  461]  1000   461     3966       36   3       0             0 xinit
[53589.924003] [  462]  1000   462    57250     3006   2       0             0 X
[53589.924005] [  483]  1000   483    13495      393   1       0             0 i3
[53589.924008] [  490]  1000   490     6062       72   3       0             0 unclutter
[53589.924010] [  493]  1000   493     6004       58   1       0             0 dispad
[53589.924012] [  494]  1000   494    31745     6824   1       0             0 urxvtd
[53589.924015] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[53589.924017] [  508]  1000   508     8156      420   2       0             0 zsh
[53589.924020] [  515]     0   515     8482       80   0       0             0 sudo
[53589.924022] [  516]     0   516     6933      235   0       0             0 zsh
[53589.924025] [  530]     0   530     7404      159   1       0             0 wpa_supplicant
[53589.924027] [  585]     0   585     2136       38   0       0             0 dhcpcd
[53589.924030] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[53589.924032] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[53589.924034] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[53589.924037] [ 1312]  1000  1312    14878      717   2       0             0 mutt
[53589.924039] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[53589.924041] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[53589.924044] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[53589.924046] [ 1359]     0  1359     8481       78   3       0             0 sudo
[53589.924048] [ 1360]     0  1360     6933      237   3       0             0 zsh
[53589.924051] [12547]  1000 12547     8729      484   3       0             0 zsh
[53589.924053] [12784]  1000 12784     8156      421   3       0             0 zsh
[53589.924055] [24189]  1000 24189     8156      421   1       0             0 zsh
[53589.924058] [30766]  1000 30766     8156      421   0       0             0 zsh
[53589.924060] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[53589.924063] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[53589.924065] [ 5518]  1000  5518    90770     1584   2       0             0 kded4
[53589.924067] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[53589.924070] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[53589.924072] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[53589.924075] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[53589.924077] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[53589.924079] [ 8065]  1000  8065     6531      336   3       0             0 i3bar
[53589.924082] [ 8066]  1000  8066     7809      189   1       0             0 i3status
[53589.924084] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[53589.924086] [ 8708]     0  8708     2776      120   0       0             0 wpa_cli
[53589.924089] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[53589.924091] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[53589.924093] [ 8776]     0  8776    51901      335   0       0             0 colord
[53589.924096] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[53589.924098] [10002]  1000 10002     8290      403   0       0             0 vim
[53589.924102] [10733]  1000 10733     8156      421   2       0             0 zsh
[53589.924105] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[53589.924107] [10749]  1000 10749     8156      421   2       0             0 zsh
[53589.924110] [10758]  1000 10758    15099      929   1       0             0 mutt
[53589.924112] [10786]  1000 10786     8970      299   0       0             0 ssh
[53589.924114] [10788]  1000 10788     8970      198   0       0             0 ssh
[53589.924116] [10790]  1000 10790     8970      232   0       0             0 ssh
[53589.924119] [15290]  1000 15290     9005      229   0       0             0 ssh
[53589.924122] [15483]     0 15483     5899      156   3       0             0 vpnc
[53589.924124] [15633]  1000 15633     8740      474   2       0             0 zsh
[53589.924126] [16517]  1000 16517     8156      421   2       0             0 zsh
[53589.924129] [16542]  1000 16542     8156      420   0       0             0 zsh
[53589.924131] [16555]  1000 16555     8267      407   0       0             0 vim
[53589.924134] [16569]  1000 16569    21607      139   0       0             0 i3lock
[53589.924137] [ 4043]    73  4043    16331      307   1       0             0 pickup
[53589.924144] [ 4573]     0  4573     3806     1677   1       0             0 atop
[53589.924147] [ 6822]     0  6822     9170      388   2       0             0 crond
[53589.924150] [ 6825]  1000  6825     2937      212   1       0             0 sh
[53589.924152] [ 6827]  1000  6827   171780    11092   1       0             0 offlineimap
[53589.924154] Out of memory: Kill process 6827 (offlineimap) score 11 or sacrifice child
[53589.924158] Killed process 6827 (offlineimap) total-vm:687120kB, anon-rss:43568kB, file-rss:800kB
[53589.927754] systemd-journal invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[53589.927756] systemd-journal cpuset=/ mems_allowed=0
[53589.927758] Pid: 207, comm: systemd-journal Tainted: G        W    3.5.4-1-ARCH #1
[53589.927759] Call Trace:
[53589.927765]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[53589.927769]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[53589.927772]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[53589.927777]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[53589.927780]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[53589.927783]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[53589.927786]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[53589.927789]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[53589.927791]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[53589.927794]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[53589.927797]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[53589.927799]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[53589.927802]  [<ffffffff8147ba8e>] ? __mutex_lock_slowpath+0x24e/0x340
[53589.927805]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[53589.927808]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[53589.927811]  [<ffffffff811bcf94>] ? ep_poll+0x134/0x360
[53589.927814]  [<ffffffff81086f70>] ? try_to_wake_up+0x2f0/0x2f0
[53589.927817]  [<ffffffff8147e765>] page_fault+0x25/0x30
[53589.927818] Mem-Info:
[53589.927819] Node 0 DMA per-cpu:
[53589.927821] CPU    0: hi:    0, btch:   1 usd:   0
[53589.927822] CPU    1: hi:    0, btch:   1 usd:   0
[53589.927823] CPU    2: hi:    0, btch:   1 usd:   0
[53589.927824] CPU    3: hi:    0, btch:   1 usd:   0
[53589.927825] Node 0 DMA32 per-cpu:
[53589.927827] CPU    0: hi:  186, btch:  31 usd:   0
[53589.927828] CPU    1: hi:  186, btch:  31 usd:   0
[53589.927829] CPU    2: hi:  186, btch:  31 usd:   0
[53589.927831] CPU    3: hi:  186, btch:  31 usd:   0
[53589.927831] Node 0 Normal per-cpu:
[53589.927833] CPU    0: hi:  186, btch:  31 usd: 125
[53589.927834] CPU    1: hi:  186, btch:  31 usd:   0
[53589.927835] CPU    2: hi:  186, btch:  31 usd:  18
[53589.927837] CPU    3: hi:  186, btch:  31 usd:   0
[53589.927840] active_anon:77623 inactive_anon:16059 isolated_anon:0
[53589.927840]  active_file:0 inactive_file:0 isolated_file:26
[53589.927840]  unevictable:1683 dirty:0 writeback:0 unstable:0
[53589.927840]  free:22517 slab_reclaimable:845030 slab_unreclaimable:5744
[53589.927840]  mapped:3033 shmem:47526 pagetables:2422 bounce:0
[53589.927842] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[53589.927846] lowmem_reserve[]: 0 2137 3899 3899
[53589.927849] Node 0 DMA32 free:43828kB min:36900kB low:46124kB high:55348kB active_anon:71032kB inactive_anon:2604kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1192kB shmem:26716kB slab_reclaimable:2057048kB slab_unreclaimable:1808kB kernel_stack:176kB pagetables:2488kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1278 all_unreclaimable? yes
[53589.927853] lowmem_reserve[]: 0 0 1762 1762
[53589.927855] Node 0 Normal free:30400kB min:30416kB low:38020kB high:45624kB active_anon:239460kB inactive_anon:61632kB active_file:0kB inactive_file:0kB unevictable:5920kB isolated(anon):0kB isolated(file):104kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:10940kB shmem:163388kB slab_reclaimable:1323008kB slab_unreclaimable:21168kB kernel_stack:1232kB pagetables:7200kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:17142 all_unreclaimable? yes
[53589.927859] lowmem_reserve[]: 0 0 0 0
[53589.927862] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[53589.927868] Node 0 DMA32: 637*4kB 2128*8kB 1234*16kB 13*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43828kB
[53589.927874] Node 0 Normal: 2699*4kB 719*8kB 664*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30692kB
[53589.927880] 48404 total pagecache pages
[53589.927881] 0 pages in swap cache
[53589.927882] Swap cache stats: add 0, delete 0, find 0/0
[53589.927883] Free swap  = 0kB
[53589.927884] Total swap = 0kB
[53589.936382] 1048048 pages RAM
[53589.936384] 57533 pages reserved
[53589.936385] 31175 pages shared
[53589.936386] 940328 pages non-shared
[53589.936387] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[53589.936392] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[53589.936394] [  207]     0   207    71456     4144   1       0             0 systemd-journal
[53589.936396] [  331]     0   331     1056       45   1       0             0 acpid
[53589.936398] [  332]     0   332     3303      190   3       0             0 crond
[53589.936400] [  334]     0   334    10502      140   1     -17         -1000 sshd
[53589.936402] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[53589.936404] [  341]     0   341     6512       70   1       0             0 systemd-logind
[53589.936406] [  349]     0   349    15747      115   3       0             0 login
[53589.936407] [  356]     0   356     2031       30   0       0             0 agetty
[53589.936409] [  357]     0   357     2031       30   2       0             0 agetty
[53589.936411] [  358]     0   358     2031       30   2       0             0 agetty
[53589.936412] [  359]     0   359     2031       32   0       0             0 agetty
[53589.936414] [  360]     0   360     2031       30   0       0             0 agetty
[53589.936416] [  418]     0   418     3092       75   2       0             0 master
[53589.936418] [  421]    73   421    16374      249   0       0             0 qmgr
[53589.936420] [  433]  1000   433     3423      101   3       0             0 restart-x
[53589.936422] [  444]  1000   444     3423      109   2       0             0 startx
[53589.936423] [  461]  1000   461     3966       36   3       0             0 xinit
[53589.936425] [  462]  1000   462    57250     3006   2       0             0 X
[53589.936427] [  483]  1000   483    13495      393   1       0             0 i3
[53589.936429] [  490]  1000   490     6062       72   3       0             0 unclutter
[53589.936430] [  493]  1000   493     6004       58   1       0             0 dispad
[53589.936432] [  494]  1000   494    31745     6824   1       0             0 urxvtd
[53589.936434] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[53589.936436] [  508]  1000   508     8156      420   2       0             0 zsh
[53589.936438] [  515]     0   515     8482       80   0       0             0 sudo
[53589.936439] [  516]     0   516     6933      235   0       0             0 zsh
[53589.936441] [  530]     0   530     7404      159   1       0             0 wpa_supplicant
[53589.936443] [  585]     0   585     2136       38   0       0             0 dhcpcd
[53589.936445] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[53589.936446] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[53589.936448] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[53589.936450] [ 1312]  1000  1312    14878      717   2       0             0 mutt
[53589.936452] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[53589.936454] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[53589.936455] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[53589.936457] [ 1359]     0  1359     8481       78   3       0             0 sudo
[53589.936459] [ 1360]     0  1360     6933      237   3       0             0 zsh
[53589.936461] [12547]  1000 12547     8729      484   3       0             0 zsh
[53589.936463] [12784]  1000 12784     8156      421   3       0             0 zsh
[53589.936465] [24189]  1000 24189     8156      421   1       0             0 zsh
[53589.936467] [30766]  1000 30766     8156      421   0       0             0 zsh
[53589.936469] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[53589.936471] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[53589.936472] [ 5518]  1000  5518    90770     1584   2       0             0 kded4
[53589.936474] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[53589.936476] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[53589.936478] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[53589.936480] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[53589.936481] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[53589.936483] [ 8065]  1000  8065     6531      336   3       0             0 i3bar
[53589.936485] [ 8066]  1000  8066     7809      189   1       0             0 i3status
[53589.936487] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[53589.936488] [ 8708]     0  8708     2776      120   0       0             0 wpa_cli
[53589.936490] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[53589.936492] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[53589.936494] [ 8776]     0  8776    51901      335   0       0             0 colord
[53589.936495] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[53589.936497] [10002]  1000 10002     8290      403   0       0             0 vim
[53589.936500] [10733]  1000 10733     8156      421   2       0             0 zsh
[53589.936502] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[53589.936503] [10749]  1000 10749     8156      421   2       0             0 zsh
[53589.936505] [10758]  1000 10758    15099      929   1       0             0 mutt
[53589.936507] [10786]  1000 10786     8970      299   0       0             0 ssh
[53589.936508] [10788]  1000 10788     8970      198   0       0             0 ssh
[53589.936510] [10790]  1000 10790     8970      232   0       0             0 ssh
[53589.936512] [15290]  1000 15290     9005      229   0       0             0 ssh
[53589.936514] [15483]     0 15483     5899      156   3       0             0 vpnc
[53589.936515] [15633]  1000 15633     8740      474   2       0             0 zsh
[53589.936517] [16517]  1000 16517     8156      421   2       0             0 zsh
[53589.936519] [16542]  1000 16542     8156      420   0       0             0 zsh
[53589.936521] [16555]  1000 16555     8267      407   0       0             0 vim
[53589.936523] [16569]  1000 16569    21607      139   0       0             0 i3lock
[53589.936525] [ 4043]    73  4043    16331      307   1       0             0 pickup
[53589.936527] [ 4573]     0  4573     3806     1677   1       0             0 atop
[53589.936529] [ 6822]     0  6822     9170      388   2       0             0 crond
[53589.936531] [ 6825]  1000  6825     2937      212   1       0             0 sh
[53589.936533] [ 6981]  1000  6827   171780    11216   1       0             0 offlineimap
[53589.936535] Out of memory: Kill process 6981 (offlineimap) score 11 or sacrifice child
[53589.936537] Killed process 6981 (offlineimap) total-vm:687120kB, anon-rss:43824kB, file-rss:1040kB
[53713.091667] offlineimap invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[53713.091672] offlineimap cpuset=/ mems_allowed=0
[53713.091674] Pid: 7031, comm: offlineimap Tainted: G        W    3.5.4-1-ARCH #1
[53713.091676] Call Trace:
[53713.091683]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[53713.091687]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[53713.091692]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[53713.091697]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[53713.091701]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[53713.091704]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[53713.091708]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[53713.091713]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[53713.091716]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[53713.091719]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[53713.091722]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[53713.091726]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[53713.091730]  [<ffffffff81086fc0>] ? wake_up_state+0x10/0x20
[53713.091734]  [<ffffffff810aaa7b>] ? wake_futex+0x3b/0x60
[53713.091737]  [<ffffffff810ab759>] ? futex_wake+0x109/0x130
[53713.091740]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[53713.091744]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[53713.091748]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[53713.091752]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[53713.091755]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[53713.091758]  [<ffffffff8147e765>] page_fault+0x25/0x30
[53713.091760] Mem-Info:
[53713.091761] Node 0 DMA per-cpu:
[53713.091764] CPU    0: hi:    0, btch:   1 usd:   0
[53713.091766] CPU    1: hi:    0, btch:   1 usd:   0
[53713.091767] CPU    2: hi:    0, btch:   1 usd:   0
[53713.091769] CPU    3: hi:    0, btch:   1 usd:   0
[53713.091770] Node 0 DMA32 per-cpu:
[53713.091772] CPU    0: hi:  186, btch:  31 usd:   0
[53713.091774] CPU    1: hi:  186, btch:  31 usd:   0
[53713.091776] CPU    2: hi:  186, btch:  31 usd:   0
[53713.091777] CPU    3: hi:  186, btch:  31 usd:   0
[53713.091778] Node 0 Normal per-cpu:
[53713.091781] CPU    0: hi:  186, btch:  31 usd:   0
[53713.091783] CPU    1: hi:  186, btch:  31 usd: 130
[53713.091784] CPU    2: hi:  186, btch:  31 usd:   0
[53713.091786] CPU    3: hi:  186, btch:  31 usd:  22
[53713.091791] active_anon:77357 inactive_anon:16058 isolated_anon:0
[53713.091791]  active_file:70 inactive_file:286 isolated_file:0
[53713.091791]  unevictable:1683 dirty:0 writeback:4 unstable:0
[53713.091791]  free:22548 slab_reclaimable:845030 slab_unreclaimable:5743
[53713.091791]  mapped:3143 shmem:47556 pagetables:2427 bounce:0
[53713.091794] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[53713.091799] lowmem_reserve[]: 0 2137 3899 3899
[53713.091803] Node 0 DMA32 free:43864kB min:36900kB low:46124kB high:55348kB active_anon:70884kB inactive_anon:2604kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1188kB shmem:26716kB slab_reclaimable:2057048kB slab_unreclaimable:1820kB kernel_stack:176kB pagetables:2484kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:53 all_unreclaimable? yes
[53713.091809] lowmem_reserve[]: 0 0 1762 1762
[53713.091812] Node 0 Normal free:30488kB min:30416kB low:38020kB high:45624kB active_anon:238544kB inactive_anon:61628kB active_file:280kB inactive_file:1140kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:16kB mapped:11384kB shmem:163508kB slab_reclaimable:1323008kB slab_unreclaimable:21152kB kernel_stack:1232kB pagetables:7224kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:292 all_unreclaimable? no
[53713.091818] lowmem_reserve[]: 0 0 0 0
[53713.091821] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[53713.091830] Node 0 DMA32: 647*4kB 2132*8kB 1240*16kB 12*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43964kB
[53713.091838] Node 0 Normal: 2700*4kB 758*8kB 646*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30720kB
[53713.091846] 48808 total pagecache pages
[53713.091847] 0 pages in swap cache
[53713.091849] Swap cache stats: add 0, delete 0, find 0/0
[53713.091850] Free swap  = 0kB
[53713.091851] Total swap = 0kB
[53713.103453] 1048048 pages RAM
[53713.103455] 57533 pages reserved
[53713.103456] 31339 pages shared
[53713.103457] 940233 pages non-shared
[53713.103459] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[53713.103466] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[53713.103469] [  207]     0   207    71456     4179   1       0             0 systemd-journal
[53713.103472] [  331]     0   331     1056       45   1       0             0 acpid
[53713.103475] [  332]     0   332     3303      190   3       0             0 crond
[53713.103477] [  334]     0   334    10502      140   1     -17         -1000 sshd
[53713.103480] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[53713.103483] [  341]     0   341     6512       70   1       0             0 systemd-logind
[53713.103485] [  349]     0   349    15747      115   3       0             0 login
[53713.103488] [  356]     0   356     2031       30   0       0             0 agetty
[53713.103490] [  357]     0   357     2031       30   2       0             0 agetty
[53713.103492] [  358]     0   358     2031       30   2       0             0 agetty
[53713.103495] [  359]     0   359     2031       32   0       0             0 agetty
[53713.103497] [  360]     0   360     2031       30   0       0             0 agetty
[53713.103500] [  418]     0   418     3092       75   0       0             0 master
[53713.103502] [  421]    73   421    16374      258   1       0             0 qmgr
[53713.103505] [  433]  1000   433     3423      101   3       0             0 restart-x
[53713.103507] [  444]  1000   444     3423      109   2       0             0 startx
[53713.103510] [  461]  1000   461     3966       36   3       0             0 xinit
[53713.103512] [  462]  1000   462    57250     3046   1       0             0 X
[53713.103514] [  483]  1000   483    13495      398   1       0             0 i3
[53713.103517] [  490]  1000   490     6062       72   1       0             0 unclutter
[53713.103519] [  493]  1000   493     6004       58   1       0             0 dispad
[53713.103522] [  494]  1000   494    31745     6822   3       0             0 urxvtd
[53713.103524] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[53713.103527] [  508]  1000   508     8156      420   2       0             0 zsh
[53713.103529] [  515]     0   515     8482       80   0       0             0 sudo
[53713.103532] [  516]     0   516     6933      235   0       0             0 zsh
[53713.103534] [  530]     0   530     7404      161   1       0             0 wpa_supplicant
[53713.103536] [  585]     0   585     2136       38   0       0             0 dhcpcd
[53713.103539] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[53713.103541] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[53713.103544] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[53713.103546] [ 1312]  1000  1312    14878      717   2       0             0 mutt
[53713.103549] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[53713.103551] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[53713.103554] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[53713.103556] [ 1359]     0  1359     8481       78   3       0             0 sudo
[53713.103559] [ 1360]     0  1360     6933      237   3       0             0 zsh
[53713.103561] [12547]  1000 12547     8729      484   3       0             0 zsh
[53713.103563] [12784]  1000 12784     8156      421   3       0             0 zsh
[53713.103566] [24189]  1000 24189     8156      421   1       0             0 zsh
[53713.103568] [30766]  1000 30766     8156      421   0       0             0 zsh
[53713.103571] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[53713.103573] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[53713.103576] [ 5518]  1000  5518    90770     1597   1       0             0 kded4
[53713.103578] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[53713.103581] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[53713.103583] [ 5534]     0  5534    46649      203   3     -13          -900 polkitd
[53713.103585] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[53713.103588] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[53713.103590] [ 8065]  1000  8065     6531      337   3       0             0 i3bar
[53713.103593] [ 8066]  1000  8066     7809      197   1       0             0 i3status
[53713.103595] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[53713.103597] [ 8708]     0  8708     2776      120   3       0             0 wpa_cli
[53713.103600] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[53713.103602] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[53713.103605] [ 8776]     0  8776    51901      335   0       0             0 colord
[53713.103607] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[53713.103610] [10002]  1000 10002     8290      403   0       0             0 vim
[53713.103613] [10733]  1000 10733     8156      421   2       0             0 zsh
[53713.103615] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[53713.103618] [10749]  1000 10749     8156      421   2       0             0 zsh
[53713.103620] [10758]  1000 10758    15099      929   1       0             0 mutt
[53713.103623] [10786]  1000 10786     8970      250   0       0             0 ssh
[53713.103625] [10788]  1000 10788     8970      198   0       0             0 ssh
[53713.103627] [10790]  1000 10790     8970      246   0       0             0 ssh
[53713.103630] [15290]  1000 15290     9005      216   0       0             0 ssh
[53713.103633] [15483]     0 15483     5899      142   3       0             0 vpnc
[53713.103635] [15633]  1000 15633     8740      474   2       0             0 zsh
[53713.103638] [16517]  1000 16517     8156      421   2       0             0 zsh
[53713.103640] [16542]  1000 16542     8156      420   0       0             0 zsh
[53713.103642] [16555]  1000 16555     8267      407   0       0             0 vim
[53713.103645] [16569]  1000 16569    21607      139   1       0             0 i3lock
[53713.103648] [ 4043]    73  4043    16331      273   1       0             0 pickup
[53713.103651] [ 4573]     0  4573     3806     1677   1       0             0 atop
[53713.103654] [ 6991]     0  6991     9170      388   1       0             0 crond
[53713.103656] [ 6994]  1000  6994     2937      212   3       0             0 sh
[53713.103659] [ 6996]  1000  6996   171780    10765   1       0             0 offlineimap
[53713.103661] Out of memory: Kill process 6996 (offlineimap) score 10 or sacrifice child
[53713.103664] Killed process 6996 (offlineimap) total-vm:687120kB, anon-rss:42540kB, file-rss:520kB
[53823.276438] kded4 invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[53823.276442] kded4 cpuset=/ mems_allowed=0
[53823.276444] Pid: 5518, comm: kded4 Tainted: G        W    3.5.4-1-ARCH #1
[53823.276445] Call Trace:
[53823.276451]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[53823.276455]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[53823.276458]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[53823.276460]  [<ffffffff8105e351>] ? has_capability_noaudit+0x1/0x20
[53823.276465]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[53823.276469]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[53823.276471]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[53823.276474]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[53823.276477]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[53823.276480]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[53823.276482]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[53823.276485]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[53823.276488]  [<ffffffff8136ef95>] ? sock_update_classid+0x65/0x90
[53823.276491]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[53823.276493]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[53823.276495]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[53823.276497]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[53823.276499]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[53823.276502]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[53823.276504]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[53823.276506]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[53823.276508]  [<ffffffff8147e765>] page_fault+0x25/0x30
[53823.276510] Mem-Info:
[53823.276511] Node 0 DMA per-cpu:
[53823.276513] CPU    0: hi:    0, btch:   1 usd:   0
[53823.276514] CPU    1: hi:    0, btch:   1 usd:   0
[53823.276515] CPU    2: hi:    0, btch:   1 usd:   0
[53823.276517] CPU    3: hi:    0, btch:   1 usd:   0
[53823.276517] Node 0 DMA32 per-cpu:
[53823.276519] CPU    0: hi:  186, btch:  31 usd:   0
[53823.276520] CPU    1: hi:  186, btch:  31 usd:   0
[53823.276522] CPU    2: hi:  186, btch:  31 usd:   0
[53823.276523] CPU    3: hi:  186, btch:  31 usd:   0
[53823.276523] Node 0 Normal per-cpu:
[53823.276525] CPU    0: hi:  186, btch:  31 usd: 110
[53823.276526] CPU    1: hi:  186, btch:  31 usd:   0
[53823.276527] CPU    2: hi:  186, btch:  31 usd:   0
[53823.276528] CPU    3: hi:  186, btch:  31 usd: 139
[53823.276532] active_anon:77370 inactive_anon:16054 isolated_anon:0
[53823.276532]  active_file:100 inactive_file:165 isolated_file:0
[53823.276532]  unevictable:1683 dirty:0 writeback:5 unstable:0
[53823.276532]  free:22525 slab_reclaimable:845030 slab_unreclaimable:5755
[53823.276532]  mapped:3147 shmem:47566 pagetables:2425 bounce:0
[53823.276534] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[53823.276538] lowmem_reserve[]: 0 2137 3899 3899
[53823.276540] Node 0 DMA32 free:43896kB min:36900kB low:46124kB high:55348kB active_anon:70916kB inactive_anon:2604kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1200kB shmem:26716kB slab_reclaimable:2057048kB slab_unreclaimable:1820kB kernel_stack:176kB pagetables:2520kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:164 all_unreclaimable? yes
[53823.276544] lowmem_reserve[]: 0 0 1762 1762
[53823.276547] Node 0 Normal free:30364kB min:30416kB low:38020kB high:45624kB active_anon:238564kB inactive_anon:61612kB active_file:400kB inactive_file:656kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:20kB mapped:11388kB shmem:163548kB slab_reclaimable:1323008kB slab_unreclaimable:21200kB kernel_stack:1232kB pagetables:7180kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:2733 all_unreclaimable? yes
[53823.276551] lowmem_reserve[]: 0 0 0 0
[53823.276553] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[53823.276560] Node 0 DMA32: 628*4kB 2127*8kB 1239*16kB 12*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43896kB
[53823.276566] Node 0 Normal: 2644*4kB 716*8kB 676*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30640kB
[53823.276572] 48743 total pagecache pages
[53823.276573] 0 pages in swap cache
[53823.276574] Swap cache stats: add 0, delete 0, find 0/0
[53823.276575] Free swap  = 0kB
[53823.276576] Total swap = 0kB
[53823.284957] 1048048 pages RAM
[53823.284960] 57533 pages reserved
[53823.284961] 31422 pages shared
[53823.284962] 940073 pages non-shared
[53823.284964] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[53823.284970] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[53823.284973] [  207]     0   207    71456     4228   1       0             0 systemd-journal
[53823.284976] [  331]     0   331     1056       45   1       0             0 acpid
[53823.284979] [  332]     0   332     3303      190   2       0             0 crond
[53823.284981] [  334]     0   334    10502      140   1     -17         -1000 sshd
[53823.284984] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[53823.284987] [  341]     0   341     6512       70   1       0             0 systemd-logind
[53823.284989] [  349]     0   349    15747      115   3       0             0 login
[53823.284991] [  356]     0   356     2031       30   0       0             0 agetty
[53823.284994] [  357]     0   357     2031       30   2       0             0 agetty
[53823.284996] [  358]     0   358     2031       30   2       0             0 agetty
[53823.284998] [  359]     0   359     2031       32   0       0             0 agetty
[53823.285000] [  360]     0   360     2031       30   0       0             0 agetty
[53823.285003] [  418]     0   418     3092       58   1       0             0 master
[53823.285005] [  421]    73   421    16374      269   3       0             0 qmgr
[53823.285008] [  433]  1000   433     3423      101   3       0             0 restart-x
[53823.285010] [  444]  1000   444     3423      109   2       0             0 startx
[53823.285013] [  461]  1000   461     3966       36   3       0             0 xinit
[53823.285015] [  462]  1000   462    57250     3040   1       0             0 X
[53823.285017] [  483]  1000   483    13495      393   0       0             0 i3
[53823.285020] [  490]  1000   490     6062       72   0       0             0 unclutter
[53823.285022] [  493]  1000   493     6004       65   3       0             0 dispad
[53823.285024] [  494]  1000   494    31745     6854   1       0             0 urxvtd
[53823.285026] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[53823.285029] [  508]  1000   508     8156      420   2       0             0 zsh
[53823.285031] [  515]     0   515     8482       80   0       0             0 sudo
[53823.285033] [  516]     0   516     6933      235   0       0             0 zsh
[53823.285036] [  530]     0   530     7404      184   2       0             0 wpa_supplicant
[53823.285038] [  585]     0   585     2136       38   0       0             0 dhcpcd
[53823.285041] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[53823.285043] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[53823.285045] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[53823.285048] [ 1312]  1000  1312    14878      717   2       0             0 mutt
[53823.285050] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[53823.285053] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[53823.285055] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[53823.285057] [ 1359]     0  1359     8481       78   3       0             0 sudo
[53823.285060] [ 1360]     0  1360     6933      237   3       0             0 zsh
[53823.285062] [12547]  1000 12547     8729      484   3       0             0 zsh
[53823.285064] [12784]  1000 12784     8156      421   3       0             0 zsh
[53823.285066] [24189]  1000 24189     8156      421   1       0             0 zsh
[53823.285069] [30766]  1000 30766     8156      421   0       0             0 zsh
[53823.285071] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[53823.285074] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[53823.285076] [ 5518]  1000  5518    90770     1602   3       0             0 kded4
[53823.285078] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[53823.285080] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[53823.285083] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[53823.285085] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[53823.285087] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[53823.285090] [ 8065]  1000  8065     6531      319   1       0             0 i3bar
[53823.285092] [ 8066]  1000  8066     7809      225   2       0             0 i3status
[53823.285095] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[53823.285097] [ 8708]     0  8708     2776      120   3       0             0 wpa_cli
[53823.285100] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[53823.285102] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[53823.285104] [ 8776]     0  8776    51901      335   0       0             0 colord
[53823.285106] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[53823.285109] [10002]  1000 10002     8290      403   0       0             0 vim
[53823.285113] [10733]  1000 10733     8156      421   2       0             0 zsh
[53823.285115] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[53823.285117] [10749]  1000 10749     8156      421   2       0             0 zsh
[53823.285120] [10758]  1000 10758    15099      929   1       0             0 mutt
[53823.285122] [10786]  1000 10786     8970      266   1       0             0 ssh
[53823.285124] [10788]  1000 10788     8970      198   0       0             0 ssh
[53823.285127] [10790]  1000 10790     8970      264   0       0             0 ssh
[53823.285129] [15290]  1000 15290     9005      217   0       0             0 ssh
[53823.285132] [15483]     0 15483     5899      154   3       0             0 vpnc
[53823.285134] [15633]  1000 15633     8740      474   2       0             0 zsh
[53823.285137] [16517]  1000 16517     8156      421   2       0             0 zsh
[53823.285139] [16542]  1000 16542     8156      420   0       0             0 zsh
[53823.285141] [16555]  1000 16555     8267      407   0       0             0 vim
[53823.285143] [16569]  1000 16569    21607      139   0       0             0 i3lock
[53823.285146] [ 4043]    73  4043    16331      299   2       0             0 pickup
[53823.285149] [ 4573]     0  4573     3806     1677   1       0             0 atop
[53823.285152] [ 7138]     0  7138     9170      388   1       0             0 crond
[53823.285154] [ 7140]  1000  7140     2937      207   2       0             0 sh
[53823.285157] [ 7143]  1000  7143   171779    10810   1       0             0 offlineimap
[53823.285159] Out of memory: Kill process 7143 (offlineimap) score 10 or sacrifice child
[53823.285162] Killed process 7143 (offlineimap) total-vm:687116kB, anon-rss:42536kB, file-rss:704kB
[53944.527227] offlineimap invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[53944.527231] offlineimap cpuset=/ mems_allowed=0
[53944.527233] Pid: 7447, comm: offlineimap Tainted: G        W    3.5.4-1-ARCH #1
[53944.527235] Call Trace:
[53944.527241]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[53944.527245]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[53944.527249]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[53944.527253]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[53944.527257]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[53944.527260]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[53944.527263]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[53944.527266]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[53944.527269]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[53944.527271]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[53944.527274]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[53944.527277]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[53944.527280]  [<ffffffff81047c61>] ? native_flush_tlb_others+0xe1/0x120
[53944.527283]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[53944.527286]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[53944.527288]  [<ffffffff811477e5>] ? sys_mprotect+0x1e5/0x270
[53944.527290]  [<ffffffff8147e765>] page_fault+0x25/0x30
[53944.527292] Mem-Info:
[53944.527293] Node 0 DMA per-cpu:
[53944.527295] CPU    0: hi:    0, btch:   1 usd:   0
[53944.527296] CPU    1: hi:    0, btch:   1 usd:   0
[53944.527297] CPU    2: hi:    0, btch:   1 usd:   0
[53944.527298] CPU    3: hi:    0, btch:   1 usd:   0
[53944.527299] Node 0 DMA32 per-cpu:
[53944.527301] CPU    0: hi:  186, btch:  31 usd:   0
[53944.527302] CPU    1: hi:  186, btch:  31 usd: 114
[53944.527303] CPU    2: hi:  186, btch:  31 usd:  30
[53944.527305] CPU    3: hi:  186, btch:  31 usd:   0
[53944.527305] Node 0 Normal per-cpu:
[53944.527307] CPU    0: hi:  186, btch:  31 usd:   0
[53944.527308] CPU    1: hi:  186, btch:  31 usd: 118
[53944.527309] CPU    2: hi:  186, btch:  31 usd:   0
[53944.527310] CPU    3: hi:  186, btch:  31 usd:   0
[53944.527314] active_anon:77647 inactive_anon:16062 isolated_anon:0
[53944.527314]  active_file:116 inactive_file:46 isolated_file:0
[53944.527314]  unevictable:1683 dirty:0 writeback:20 unstable:0
[53944.527314]  free:22490 slab_reclaimable:845030 slab_unreclaimable:5748
[53944.527314]  mapped:3028 shmem:47588 pagetables:2425 bounce:0
[53944.527316] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[53944.527320] lowmem_reserve[]: 0 2137 3899 3899
[53944.527323] Node 0 DMA32 free:43760kB min:36900kB low:46124kB high:55348kB active_anon:70508kB inactive_anon:2604kB active_file:72kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:8kB mapped:1128kB shmem:26720kB slab_reclaimable:2057048kB slab_unreclaimable:1824kB kernel_stack:176kB pagetables:2528kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1220 all_unreclaimable? yes
[53944.527327] lowmem_reserve[]: 0 0 1762 1762
[53944.527329] Node 0 Normal free:30360kB min:30416kB low:38020kB high:45624kB active_anon:240080kB inactive_anon:61644kB active_file:392kB inactive_file:200kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:72kB mapped:10984kB shmem:163632kB slab_reclaimable:1323008kB slab_unreclaimable:21168kB kernel_stack:1240kB pagetables:7172kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:7373 all_unreclaimable? yes
[53944.527333] lowmem_reserve[]: 0 0 0 0
[53944.527336] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[53944.527342] Node 0 DMA32: 625*4kB 2126*8kB 1233*16kB 10*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43652kB
[53944.527348] Node 0 Normal: 2712*4kB 724*8kB 646*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30496kB
[53944.527354] 48563 total pagecache pages
[53944.527356] 0 pages in swap cache
[53944.527357] Swap cache stats: add 0, delete 0, find 0/0
[53944.527358] Free swap  = 0kB
[53944.527358] Total swap = 0kB
[53944.537500] 1048048 pages RAM
[53944.537503] 57533 pages reserved
[53944.537506] 31385 pages shared
[53944.537507] 940160 pages non-shared
[53944.537509] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[53944.537515] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[53944.537518] [  207]     0   207    71456     4237   2       0             0 systemd-journal
[53944.537521] [  331]     0   331     1056       45   1       0             0 acpid
[53944.537524] [  332]     0   332     3303      190   0       0             0 crond
[53944.537527] [  334]     0   334    10502      140   1     -17         -1000 sshd
[53944.537530] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[53944.537532] [  341]     0   341     6512       70   1       0             0 systemd-logind
[53944.537534] [  349]     0   349    15747      115   3       0             0 login
[53944.537537] [  356]     0   356     2031       30   0       0             0 agetty
[53944.537539] [  357]     0   357     2031       30   2       0             0 agetty
[53944.537541] [  358]     0   358     2031       30   2       0             0 agetty
[53944.537544] [  359]     0   359     2031       32   0       0             0 agetty
[53944.537547] [  360]     0   360     2031       30   0       0             0 agetty
[53944.537549] [  418]     0   418     3092       75   0       0             0 master
[53944.537552] [  421]    73   421    16374      278   3       0             0 qmgr
[53944.537555] [  433]  1000   433     3423      101   3       0             0 restart-x
[53944.537557] [  444]  1000   444     3423      109   2       0             0 startx
[53944.537559] [  461]  1000   461     3966       36   3       0             0 xinit
[53944.537562] [  462]  1000   462    57250     3011   1       0             0 X
[53944.537565] [  483]  1000   483    13495      393   1       0             0 i3
[53944.537567] [  490]  1000   490     6062       72   0       0             0 unclutter
[53944.537570] [  493]  1000   493     6004       58   1       0             0 dispad
[53944.537572] [  494]  1000   494    31745     6819   2       0             0 urxvtd
[53944.537574] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[53944.537577] [  508]  1000   508     8156      420   2       0             0 zsh
[53944.537579] [  515]     0   515     8482       80   0       0             0 sudo
[53944.537581] [  516]     0   516     6933      235   0       0             0 zsh
[53944.537584] [  530]     0   530     7404      156   1       0             0 wpa_supplicant
[53944.537586] [  585]     0   585     2136       38   0       0             0 dhcpcd
[53944.537588] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[53944.537590] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[53944.537593] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[53944.537595] [ 1312]  1000  1312    14878      717   2       0             0 mutt
[53944.537598] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[53944.537600] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[53944.537603] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[53944.537605] [ 1359]     0  1359     8481       78   3       0             0 sudo
[53944.537607] [ 1360]     0  1360     6933      237   3       0             0 zsh
[53944.537610] [12547]  1000 12547     8729      484   3       0             0 zsh
[53944.537612] [12784]  1000 12784     8156      421   3       0             0 zsh
[53944.537614] [24189]  1000 24189     8156      421   1       0             0 zsh
[53944.537617] [30766]  1000 30766     8156      421   0       0             0 zsh
[53944.537619] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[53944.537621] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[53944.537624] [ 5518]  1000  5518    90770     1578   1       0             0 kded4
[53944.537626] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[53944.537628] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[53944.537631] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[53944.537633] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[53944.537635] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[53944.537638] [ 8065]  1000  8065     6531      322   3       0             0 i3bar
[53944.537640] [ 8066]  1000  8066     7809      221   3       0             0 i3status
[53944.537642] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[53944.537645] [ 8708]     0  8708     2776      128   2       0             0 wpa_cli
[53944.537647] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[53944.537650] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[53944.537652] [ 8776]     0  8776    51901      335   0       0             0 colord
[53944.537655] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[53944.537657] [10002]  1000 10002     8290      403   0       0             0 vim
[53944.537660] [10733]  1000 10733     8156      421   2       0             0 zsh
[53944.537662] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[53944.537664] [10749]  1000 10749     8156      421   2       0             0 zsh
[53944.537667] [10758]  1000 10758    15099      929   1       0             0 mutt
[53944.537669] [10786]  1000 10786     8970      281   0       0             0 ssh
[53944.537671] [10788]  1000 10788     8970      198   0       0             0 ssh
[53944.537674] [10790]  1000 10790     8970      282   0       0             0 ssh
[53944.537676] [15290]  1000 15290     9005      216   0       0             0 ssh
[53944.537679] [15483]     0 15483     5899      139   3       0             0 vpnc
[53944.537682] [15633]  1000 15633     8740      474   2       0             0 zsh
[53944.537684] [16517]  1000 16517     8156      421   2       0             0 zsh
[53944.537687] [16542]  1000 16542     8156      420   0       0             0 zsh
[53944.537689] [16555]  1000 16555     8267      407   0       0             0 vim
[53944.537692] [16569]  1000 16569    21607      139   1       0             0 i3lock
[53944.537695] [ 4043]    73  4043    16331      265   0       0             0 pickup
[53944.537697] [ 4573]     0  4573     3806     1677   1       0             0 atop
[53944.537700] [ 7287]     0  7287     9170      388   1       0             0 crond
[53944.537703] [ 7289]  1000  7289     2937      200   1       0             0 sh
[53944.537705] [ 7292]  1000  7292   155407    11060   3       0             0 offlineimap
[53944.537707] Out of memory: Kill process 7292 (offlineimap) score 11 or sacrifice child
[53944.537711] Killed process 7292 (offlineimap) total-vm:621628kB, anon-rss:43572kB, file-rss:668kB
[54061.005169] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54061.005173] urxvtd cpuset=/ mems_allowed=0
[54061.005175] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[54061.005177] Call Trace:
[54061.005182]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54061.005186]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54061.005190]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54061.005194]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54061.005198]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54061.005200]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54061.005203]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54061.005207]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54061.005209]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54061.005211]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54061.005214]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54061.005217]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54061.005220]  [<ffffffff81079380>] ? lock_hrtimer_base.isra.22+0x30/0x60
[54061.005222]  [<ffffffff81079486>] ? hrtimer_try_to_cancel+0x86/0x110
[54061.005225]  [<ffffffff81079532>] ? hrtimer_cancel+0x22/0x30
[54061.005227]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54061.005230]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54061.005233]  [<ffffffff811bd101>] ? ep_poll+0x2a1/0x360
[54061.005236]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[54061.005239]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[54061.005241]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54061.005243] Mem-Info:
[54061.005244] Node 0 DMA per-cpu:
[54061.005246] CPU    0: hi:    0, btch:   1 usd:   0
[54061.005247] CPU    1: hi:    0, btch:   1 usd:   0
[54061.005248] CPU    2: hi:    0, btch:   1 usd:   0
[54061.005249] CPU    3: hi:    0, btch:   1 usd:   0
[54061.005250] Node 0 DMA32 per-cpu:
[54061.005252] CPU    0: hi:  186, btch:  31 usd:  12
[54061.005253] CPU    1: hi:  186, btch:  31 usd:  18
[54061.005254] CPU    2: hi:  186, btch:  31 usd:   0
[54061.005255] CPU    3: hi:  186, btch:  31 usd:  30
[54061.005256] Node 0 Normal per-cpu:
[54061.005258] CPU    0: hi:  186, btch:  31 usd:   0
[54061.005259] CPU    1: hi:  186, btch:  31 usd:   0
[54061.005260] CPU    2: hi:  186, btch:  31 usd:   0
[54061.005261] CPU    3: hi:  186, btch:  31 usd:  15
[54061.005264] active_anon:77407 inactive_anon:16057 isolated_anon:0
[54061.005264]  active_file:99 inactive_file:208 isolated_file:37
[54061.005264]  unevictable:1683 dirty:0 writeback:8 unstable:0
[54061.005264]  free:22482 slab_reclaimable:845075 slab_unreclaimable:5762
[54061.005264]  mapped:3095 shmem:47599 pagetables:2425 bounce:0
[54061.005266] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54061.005270] lowmem_reserve[]: 0 2137 3899 3899
[54061.005273] Node 0 DMA32 free:43720kB min:36900kB low:46124kB high:55348kB active_anon:70252kB inactive_anon:2604kB active_file:100kB inactive_file:84kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:4kB mapped:1436kB shmem:26716kB slab_reclaimable:2057048kB slab_unreclaimable:1808kB kernel_stack:176kB pagetables:2504kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1026 all_unreclaimable? yes
[54061.005277] lowmem_reserve[]: 0 0 1762 1762
[54061.005280] Node 0 Normal free:30368kB min:30416kB low:38020kB high:45624kB active_anon:239376kB inactive_anon:61624kB active_file:296kB inactive_file:748kB unevictable:5920kB isolated(anon):0kB isolated(file):148kB present:1804320kB mlocked:5920kB dirty:0kB writeback:28kB mapped:10944kB shmem:163680kB slab_reclaimable:1323188kB slab_unreclaimable:21240kB kernel_stack:1240kB pagetables:7196kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:2126 all_unreclaimable? yes
[54061.005284] lowmem_reserve[]: 0 0 0 0
[54061.005286] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54061.005293] Node 0 DMA32: 636*4kB 2132*8kB 1237*16kB 4*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43616kB
[54061.005298] Node 0 Normal: 2816*4kB 812*8kB 586*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30656kB
[54061.005304] 49029 total pagecache pages
[54061.005306] 0 pages in swap cache
[54061.005307] Swap cache stats: add 0, delete 0, find 0/0
[54061.005308] Free swap  = 0kB
[54061.005308] Total swap = 0kB
[54061.013622] 1048048 pages RAM
[54061.013624] 57533 pages reserved
[54061.013625] 31512 pages shared
[54061.013626] 940255 pages non-shared
[54061.013627] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54061.013634] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54061.013637] [  207]     0   207    71456     4285   1       0             0 systemd-journal
[54061.013640] [  331]     0   331     1056       45   1       0             0 acpid
[54061.013642] [  332]     0   332     3303      190   0       0             0 crond
[54061.013645] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54061.013648] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54061.013650] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54061.013653] [  349]     0   349    15747      115   3       0             0 login
[54061.013655] [  356]     0   356     2031       30   0       0             0 agetty
[54061.013657] [  357]     0   357     2031       30   2       0             0 agetty
[54061.013660] [  358]     0   358     2031       30   2       0             0 agetty
[54061.013662] [  359]     0   359     2031       32   0       0             0 agetty
[54061.013665] [  360]     0   360     2031       30   0       0             0 agetty
[54061.013667] [  418]     0   418     3092       75   0       0             0 master
[54061.013669] [  421]    73   421    16374      289   3       0             0 qmgr
[54061.013672] [  433]  1000   433     3423      101   3       0             0 restart-x
[54061.013674] [  444]  1000   444     3423      109   2       0             0 startx
[54061.013676] [  461]  1000   461     3966       36   3       0             0 xinit
[54061.013679] [  462]  1000   462    57250     3028   1       0             0 X
[54061.013681] [  483]  1000   483    13495      393   1       0             0 i3
[54061.013684] [  490]  1000   490     6062       72   0       0             0 unclutter
[54061.013686] [  493]  1000   493     6004       70   3       0             0 dispad
[54061.013688] [  494]  1000   494    31745     6851   3       0             0 urxvtd
[54061.013690] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54061.013693] [  508]  1000   508     8156      420   2       0             0 zsh
[54061.013695] [  515]     0   515     8482       80   0       0             0 sudo
[54061.013697] [  516]     0   516     6933      235   0       0             0 zsh
[54061.013700] [  530]     0   530     7404      164   1       0             0 wpa_supplicant
[54061.013702] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54061.013704] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54061.013707] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54061.013709] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54061.013711] [ 1312]  1000  1312    14878      698   3       0             0 mutt
[54061.013714] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54061.013716] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[54061.013718] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54061.013721] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54061.013723] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54061.013726] [12547]  1000 12547     8729      484   3       0             0 zsh
[54061.013728] [12784]  1000 12784     8156      421   3       0             0 zsh
[54061.013730] [24189]  1000 24189     8156      421   1       0             0 zsh
[54061.013732] [30766]  1000 30766     8156      421   0       0             0 zsh
[54061.013735] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54061.013738] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54061.013740] [ 5518]  1000  5518    90770     1572   1       0             0 kded4
[54061.013743] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[54061.013745] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54061.013747] [ 5534]     0  5534    46649      203   0     -13          -900 polkitd
[54061.013749] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[54061.013752] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54061.013754] [ 8065]  1000  8065     6531      304   1       0             0 i3bar
[54061.013757] [ 8066]  1000  8066     7809      206   1       0             0 i3status
[54061.013759] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54061.013761] [ 8708]     0  8708     2776      120   3       0             0 wpa_cli
[54061.013763] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54061.013766] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54061.013769] [ 8776]     0  8776    51901      335   0       0             0 colord
[54061.013771] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54061.013773] [10002]  1000 10002     8290      403   0       0             0 vim
[54061.013777] [10733]  1000 10733     8156      421   2       0             0 zsh
[54061.013779] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54061.013781] [10749]  1000 10749     8156      421   2       0             0 zsh
[54061.013784] [10758]  1000 10758    15099      910   1       0             0 mutt
[54061.013786] [10786]  1000 10786     8970      296   0       0             0 ssh
[54061.013788] [10788]  1000 10788     8970      198   0       0             0 ssh
[54061.013790] [10790]  1000 10790     8970      234   0       0             0 ssh
[54061.013793] [15290]  1000 15290     9005      216   0       0             0 ssh
[54061.013795] [15483]     0 15483     5899      170   3       0             0 vpnc
[54061.013798] [15633]  1000 15633     8740      474   2       0             0 zsh
[54061.013800] [16517]  1000 16517     8156      421   2       0             0 zsh
[54061.013802] [16542]  1000 16542     8156      420   0       0             0 zsh
[54061.013804] [16555]  1000 16555     8267      407   0       0             0 vim
[54061.013807] [16569]  1000 16569    21607      139   1       0             0 i3lock
[54061.013810] [ 4043]    73  4043    16331      291   1       0             0 pickup
[54061.013812] [ 4573]     0  4573     3806     1680   3       0             0 atop
[54061.013816] [ 7456]     0  7456     9170      388   1       0             0 crond
[54061.013818] [ 7458]  1000  7458     2937      199   3       0             0 sh
[54061.013820] [ 7461]  1000  7461   171780    10803   2       0             0 offlineimap
[54061.013823] Out of memory: Kill process 7461 (offlineimap) score 10 or sacrifice child
[54061.013826] Killed process 7461 (offlineimap) total-vm:687120kB, anon-rss:42560kB, file-rss:652kB
[54184.920869] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54184.920873] urxvtd cpuset=/ mems_allowed=0
[54184.920877] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[54184.920878] Call Trace:
[54184.920885]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54184.920891]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54184.920896]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54184.920899]  [<ffffffff8105e2f0>] ? has_capability+0x20/0x20
[54184.920904]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54184.920909]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54184.920913]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54184.920917]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54184.920922]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54184.920925]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54184.920928]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54184.920933]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54184.920936]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54184.920940]  [<ffffffff81079380>] ? lock_hrtimer_base.isra.22+0x30/0x60
[54184.920944]  [<ffffffff81079486>] ? hrtimer_try_to_cancel+0x86/0x110
[54184.920947]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54184.920952]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54184.920956]  [<ffffffff8147ca19>] ? __schedule+0x439/0x920
[54184.920960]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[54184.920964]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[54184.920967]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54184.920969] Mem-Info:
[54184.920970] Node 0 DMA per-cpu:
[54184.920974] CPU    0: hi:    0, btch:   1 usd:   0
[54184.920975] CPU    1: hi:    0, btch:   1 usd:   0
[54184.920977] CPU    2: hi:    0, btch:   1 usd:   0
[54184.920979] CPU    3: hi:    0, btch:   1 usd:   0
[54184.920980] Node 0 DMA32 per-cpu:
[54184.920983] CPU    0: hi:  186, btch:  31 usd:   0
[54184.920985] CPU    1: hi:  186, btch:  31 usd:   0
[54184.920987] CPU    2: hi:  186, btch:  31 usd:   0
[54184.920989] CPU    3: hi:  186, btch:  31 usd:   1
[54184.920990] Node 0 Normal per-cpu:
[54184.920992] CPU    0: hi:  186, btch:  31 usd:   5
[54184.920994] CPU    1: hi:  186, btch:  31 usd:  58
[54184.920996] CPU    2: hi:  186, btch:  31 usd:   0
[54184.920998] CPU    3: hi:  186, btch:  31 usd:  77
[54184.921003] active_anon:77645 inactive_anon:16062 isolated_anon:0
[54184.921003]  active_file:0 inactive_file:0 isolated_file:15
[54184.921003]  unevictable:1683 dirty:14 writeback:0 unstable:0
[54184.921003]  free:22491 slab_reclaimable:845051 slab_unreclaimable:5764
[54184.921003]  mapped:3063 shmem:47617 pagetables:2426 bounce:0
[54184.921006] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54184.921013] lowmem_reserve[]: 0 2137 3899 3899
[54184.921017] Node 0 DMA32 free:43712kB min:36900kB low:46124kB high:55348kB active_anon:70808kB inactive_anon:2620kB active_file:24kB inactive_file:52kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:4kB writeback:0kB mapped:1332kB shmem:26732kB slab_reclaimable:2057048kB slab_unreclaimable:1808kB kernel_stack:168kB pagetables:2468kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:313 all_unreclaimable? yes
[54184.921024] lowmem_reserve[]: 0 0 1762 1762
[54184.921027] Node 0 Normal free:30412kB min:30416kB low:38020kB high:45624kB active_anon:239772kB inactive_anon:61628kB active_file:0kB inactive_file:0kB unevictable:5920kB isolated(anon):0kB isolated(file):60kB present:1804320kB mlocked:5920kB dirty:52kB writeback:0kB mapped:10920kB shmem:163736kB slab_reclaimable:1323092kB slab_unreclaimable:21248kB kernel_stack:1240kB pagetables:7236kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:660 all_unreclaimable? yes
[54184.921034] lowmem_reserve[]: 0 0 0 0
[54184.921038] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54184.921048] Node 0 DMA32: 673*4kB 2131*8kB 1245*16kB 7*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43980kB
[54184.921057] Node 0 Normal: 2680*4kB 816*8kB 612*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30560kB
[54184.921068] 48513 total pagecache pages
[54184.921069] 0 pages in swap cache
[54184.921071] Swap cache stats: add 0, delete 0, find 0/0
[54184.921072] Free swap  = 0kB
[54184.921073] Total swap = 0kB
[54184.933780] 1048048 pages RAM
[54184.933782] 57533 pages reserved
[54184.933784] 31387 pages shared
[54184.933785] 940249 pages non-shared
[54184.933787] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54184.933793] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54184.933795] [  207]     0   207    71456     4305   0       0             0 systemd-journal
[54184.933799] [  331]     0   331     1056       45   1       0             0 acpid
[54184.933801] [  332]     0   332     3303      190   1       0             0 crond
[54184.933804] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54184.933806] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54184.933809] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54184.933811] [  349]     0   349    15747      115   3       0             0 login
[54184.933813] [  356]     0   356     2031       30   0       0             0 agetty
[54184.933816] [  357]     0   357     2031       30   2       0             0 agetty
[54184.933818] [  358]     0   358     2031       30   2       0             0 agetty
[54184.933821] [  359]     0   359     2031       32   0       0             0 agetty
[54184.933823] [  360]     0   360     2031       30   0       0             0 agetty
[54184.933825] [  418]     0   418     3092       74   3       0             0 master
[54184.933828] [  421]    73   421    16374      300   3       0             0 qmgr
[54184.933830] [  433]  1000   433     3423      101   3       0             0 restart-x
[54184.933833] [  444]  1000   444     3423      109   2       0             0 startx
[54184.933836] [  461]  1000   461     3966       36   3       0             0 xinit
[54184.933839] [  462]  1000   462    57250     3011   1       0             0 X
[54184.933841] [  483]  1000   483    13495      393   0       0             0 i3
[54184.933843] [  490]  1000   490     6062       72   0       0             0 unclutter
[54184.933846] [  493]  1000   493     6004       76   2       0             0 dispad
[54184.933853] [  494]  1000   494    31745     6798   1       0             0 urxvtd
[54184.933855] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54184.933858] [  508]  1000   508     8156      420   2       0             0 zsh
[54184.933860] [  515]     0   515     8482       80   0       0             0 sudo
[54184.933863] [  516]     0   516     6933      235   0       0             0 zsh
[54184.933865] [  530]     0   530     7404      176   3       0             0 wpa_supplicant
[54184.933867] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54184.933869] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54184.933872] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54184.933874] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54184.933877] [ 1312]  1000  1312    14878      698   3       0             0 mutt
[54184.933879] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54184.933882] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[54184.933884] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54184.933887] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54184.933889] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54184.933892] [12547]  1000 12547     8729      484   3       0             0 zsh
[54184.933894] [12784]  1000 12784     8156      421   3       0             0 zsh
[54184.933897] [24189]  1000 24189     8156      421   1       0             0 zsh
[54184.933899] [30766]  1000 30766     8156      421   0       0             0 zsh
[54184.933902] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54184.933904] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54184.933907] [ 5518]  1000  5518    90770     1585   1       0             0 kded4
[54184.933909] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[54184.933911] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54184.933914] [ 5534]     0  5534    46649      203   3     -13          -900 polkitd
[54184.933916] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[54184.933919] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54184.933921] [ 8065]  1000  8065     6531      321   2       0             0 i3bar
[54184.933923] [ 8066]  1000  8066     7809      219   1       0             0 i3status
[54184.933926] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54184.933928] [ 8708]     0  8708     2776      136   1       0             0 wpa_cli
[54184.933931] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54184.933933] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54184.933935] [ 8776]     0  8776    51901      335   0       0             0 colord
[54184.933937] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54184.933940] [10002]  1000 10002     8290      403   0       0             0 vim
[54184.933943] [10733]  1000 10733     8156      421   2       0             0 zsh
[54184.933946] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54184.933949] [10749]  1000 10749     8156      421   2       0             0 zsh
[54184.933951] [10758]  1000 10758    15099      910   1       0             0 mutt
[54184.933953] [10786]  1000 10786     8970      247   1       0             0 ssh
[54184.933956] [10788]  1000 10788     8970      198   0       0             0 ssh
[54184.933958] [10790]  1000 10790     8970      252   0       0             0 ssh
[54184.933961] [15290]  1000 15290     9005      230   0       0             0 ssh
[54184.933964] [15483]     0 15483     5899      124   3       0             0 vpnc
[54184.933966] [15633]  1000 15633     8740      474   2       0             0 zsh
[54184.933968] [16517]  1000 16517     8156      421   2       0             0 zsh
[54184.933970] [16542]  1000 16542     8156      420   0       0             0 zsh
[54184.933973] [16555]  1000 16555     8267      407   0       0             0 vim
[54184.933975] [16569]  1000 16569    21607      139   0       0             0 i3lock
[54184.933978] [ 4043]    73  4043    16331      257   1       0             0 pickup
[54184.933981] [ 4573]     0  4573     3806     1680   3       0             0 atop
[54184.933984] [ 7595]     0  7595     9170      388   1       0             0 crond
[54184.933986] [ 7597]  1000  7597     2937      210   2       0             0 sh
[54184.933989] [ 7600]  1000  7600   171803    11093   3       0             0 offlineimap
[54184.933991] Out of memory: Kill process 7600 (offlineimap) score 11 or sacrifice child
[54184.933995] Killed process 7600 (offlineimap) total-vm:687212kB, anon-rss:43644kB, file-rss:728kB
[54184.937433] systemd-journal invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54184.937436] systemd-journal cpuset=/ mems_allowed=0
[54184.937438] Pid: 207, comm: systemd-journal Tainted: G        W    3.5.4-1-ARCH #1
[54184.937439] Call Trace:
[54184.937445]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54184.937449]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54184.937453]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54184.937457]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54184.937461]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54184.937463]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54184.937466]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54184.937470]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54184.937472]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54184.937475]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54184.937478]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54184.937480]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54184.937483]  [<ffffffff8147ba8e>] ? __mutex_lock_slowpath+0x24e/0x340
[54184.937486]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54184.937489]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54184.937492]  [<ffffffff811bcf94>] ? ep_poll+0x134/0x360
[54184.937496]  [<ffffffff81086f70>] ? try_to_wake_up+0x2f0/0x2f0
[54184.937498]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54184.937499] Mem-Info:
[54184.937500] Node 0 DMA per-cpu:
[54184.937502] CPU    0: hi:    0, btch:   1 usd:   0
[54184.937504] CPU    1: hi:    0, btch:   1 usd:   0
[54184.937505] CPU    2: hi:    0, btch:   1 usd:   0
[54184.937506] CPU    3: hi:    0, btch:   1 usd:   0
[54184.937507] Node 0 DMA32 per-cpu:
[54184.937508] CPU    0: hi:  186, btch:  31 usd:   0
[54184.937510] CPU    1: hi:  186, btch:  31 usd:   0
[54184.937511] CPU    2: hi:  186, btch:  31 usd:   0
[54184.937512] CPU    3: hi:  186, btch:  31 usd:   1
[54184.937513] Node 0 Normal per-cpu:
[54184.937514] CPU    0: hi:  186, btch:  31 usd:   5
[54184.937516] CPU    1: hi:  186, btch:  31 usd:  58
[54184.937517] CPU    2: hi:  186, btch:  31 usd:   0
[54184.937518] CPU    3: hi:  186, btch:  31 usd:  81
[54184.937521] active_anon:77645 inactive_anon:16062 isolated_anon:0
[54184.937521]  active_file:0 inactive_file:0 isolated_file:15
[54184.937521]  unevictable:1683 dirty:14 writeback:0 unstable:0
[54184.937521]  free:22491 slab_reclaimable:845051 slab_unreclaimable:5764
[54184.937521]  mapped:3063 shmem:47617 pagetables:2426 bounce:0
[54184.937523] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54184.937527] lowmem_reserve[]: 0 2137 3899 3899
[54184.937530] Node 0 DMA32 free:43712kB min:36900kB low:46124kB high:55348kB active_anon:70808kB inactive_anon:2620kB active_file:24kB inactive_file:52kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:4kB writeback:0kB mapped:1332kB shmem:26732kB slab_reclaimable:2057048kB slab_unreclaimable:1808kB kernel_stack:168kB pagetables:2468kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1891 all_unreclaimable? yes
[54184.937534] lowmem_reserve[]: 0 0 1762 1762
[54184.937536] Node 0 Normal free:30412kB min:30416kB low:38020kB high:45624kB active_anon:239772kB inactive_anon:61628kB active_file:0kB inactive_file:0kB unevictable:5920kB isolated(anon):0kB isolated(file):60kB present:1804320kB mlocked:5920kB dirty:52kB writeback:0kB mapped:10920kB shmem:163736kB slab_reclaimable:1323092kB slab_unreclaimable:21248kB kernel_stack:1240kB pagetables:7236kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:24396 all_unreclaimable? yes
[54184.937540] lowmem_reserve[]: 0 0 0 0
[54184.937543] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54184.937549] Node 0 DMA32: 673*4kB 2131*8kB 1245*16kB 7*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43980kB
[54184.937555] Node 0 Normal: 2680*4kB 816*8kB 612*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30560kB
[54184.937561] 48513 total pagecache pages
[54184.937562] 0 pages in swap cache
[54184.937564] Swap cache stats: add 0, delete 0, find 0/0
[54184.937564] Free swap  = 0kB
[54184.937565] Total swap = 0kB
[54184.945862] 1048048 pages RAM
[54184.945864] 57533 pages reserved
[54184.945864] 31387 pages shared
[54184.945865] 940249 pages non-shared
[54184.945867] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54184.945872] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54184.945874] [  207]     0   207    71456     4305   0       0             0 systemd-journal
[54184.945877] [  331]     0   331     1056       45   1       0             0 acpid
[54184.945878] [  332]     0   332     3303      190   1       0             0 crond
[54184.945880] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54184.945882] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54184.945884] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54184.945885] [  349]     0   349    15747      115   3       0             0 login
[54184.945887] [  356]     0   356     2031       30   0       0             0 agetty
[54184.945889] [  357]     0   357     2031       30   2       0             0 agetty
[54184.945891] [  358]     0   358     2031       30   2       0             0 agetty
[54184.945892] [  359]     0   359     2031       32   0       0             0 agetty
[54184.945894] [  360]     0   360     2031       30   0       0             0 agetty
[54184.945896] [  418]     0   418     3092       74   3       0             0 master
[54184.945898] [  421]    73   421    16374      300   3       0             0 qmgr
[54184.945900] [  433]  1000   433     3423      101   3       0             0 restart-x
[54184.945901] [  444]  1000   444     3423      109   2       0             0 startx
[54184.945903] [  461]  1000   461     3966       36   3       0             0 xinit
[54184.945905] [  462]  1000   462    57250     3011   1       0             0 X
[54184.945907] [  483]  1000   483    13495      393   0       0             0 i3
[54184.945908] [  490]  1000   490     6062       72   0       0             0 unclutter
[54184.945910] [  493]  1000   493     6004       76   2       0             0 dispad
[54184.945912] [  494]  1000   494    31745     6798   1       0             0 urxvtd
[54184.945914] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54184.945915] [  508]  1000   508     8156      420   2       0             0 zsh
[54184.945917] [  515]     0   515     8482       80   0       0             0 sudo
[54184.945919] [  516]     0   516     6933      235   0       0             0 zsh
[54184.945920] [  530]     0   530     7404      176   3       0             0 wpa_supplicant
[54184.945922] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54184.945924] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54184.945926] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54184.945928] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54184.945929] [ 1312]  1000  1312    14878      698   3       0             0 mutt
[54184.945931] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54184.945933] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[54184.945935] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54184.945936] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54184.945938] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54184.945940] [12547]  1000 12547     8729      484   3       0             0 zsh
[54184.945942] [12784]  1000 12784     8156      421   3       0             0 zsh
[54184.945943] [24189]  1000 24189     8156      421   1       0             0 zsh
[54184.945945] [30766]  1000 30766     8156      421   0       0             0 zsh
[54184.945947] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54184.945949] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54184.945951] [ 5518]  1000  5518    90770     1585   1       0             0 kded4
[54184.945952] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[54184.945954] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54184.945956] [ 5534]     0  5534    46649      203   3     -13          -900 polkitd
[54184.945958] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[54184.945959] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54184.945961] [ 8065]  1000  8065     6531      321   2       0             0 i3bar
[54184.945963] [ 8066]  1000  8066     7809      219   1       0             0 i3status
[54184.945965] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54184.945966] [ 8708]     0  8708     2776      136   1       0             0 wpa_cli
[54184.945968] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54184.945970] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54184.945971] [ 8776]     0  8776    51901      335   0       0             0 colord
[54184.945973] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54184.945975] [10002]  1000 10002     8290      403   0       0             0 vim
[54184.945977] [10733]  1000 10733     8156      421   2       0             0 zsh
[54184.945979] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54184.945981] [10749]  1000 10749     8156      421   2       0             0 zsh
[54184.945983] [10758]  1000 10758    15099      910   1       0             0 mutt
[54184.945984] [10786]  1000 10786     8970      247   1       0             0 ssh
[54184.945986] [10788]  1000 10788     8970      198   0       0             0 ssh
[54184.945988] [10790]  1000 10790     8970      252   0       0             0 ssh
[54184.945990] [15290]  1000 15290     9005      230   0       0             0 ssh
[54184.945992] [15483]     0 15483     5899      124   3       0             0 vpnc
[54184.945993] [15633]  1000 15633     8740      474   2       0             0 zsh
[54184.945995] [16517]  1000 16517     8156      421   2       0             0 zsh
[54184.945997] [16542]  1000 16542     8156      420   0       0             0 zsh
[54184.945999] [16555]  1000 16555     8267      407   0       0             0 vim
[54184.946001] [16569]  1000 16569    21607      139   0       0             0 i3lock
[54184.946003] [ 4043]    73  4043    16331      257   1       0             0 pickup
[54184.946005] [ 4573]     0  4573     3806     1680   3       0             0 atop
[54184.946007] [ 7595]     0  7595     9170      388   1       0             0 crond
[54184.946009] [ 7597]  1000  7597     2937      210   2       0             0 sh
[54184.946011] [ 7755]  1000  7600   171803    11181   2       0             0 offlineimap
[54184.946013] Out of memory: Kill process 7755 (offlineimap) score 11 or sacrifice child
[54184.946015] Killed process 7755 (offlineimap) total-vm:687212kB, anon-rss:43692kB, file-rss:1032kB
[54301.894964] kded4 invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54301.894980] kded4 cpuset=/ mems_allowed=0
[54301.894984] Pid: 5518, comm: kded4 Tainted: G        W    3.5.4-1-ARCH #1
[54301.894986] Call Trace:
[54301.894993]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54301.894999]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54301.895004]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54301.895010]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54301.895015]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54301.895018]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54301.895023]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54301.895027]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54301.895030]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54301.895034]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54301.895038]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54301.895043]  [<ffffffff8136ef95>] ? sock_update_classid+0x65/0x90
[54301.895047]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54301.895050]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[54301.895053]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[54301.895056]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[54301.895059]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54301.895061]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[54301.895066]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54301.895068]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[54301.895071]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[54301.895075]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[54301.895078]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[54301.895081]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54301.895083] Mem-Info:
[54301.895085] Node 0 DMA per-cpu:
[54301.895088] CPU    0: hi:    0, btch:   1 usd:   0
[54301.895090] CPU    1: hi:    0, btch:   1 usd:   0
[54301.895092] CPU    2: hi:    0, btch:   1 usd:   0
[54301.895094] CPU    3: hi:    0, btch:   1 usd:   0
[54301.895095] Node 0 DMA32 per-cpu:
[54301.895098] CPU    0: hi:  186, btch:  31 usd:   0
[54301.895100] CPU    1: hi:  186, btch:  31 usd:  30
[54301.895102] CPU    2: hi:  186, btch:  31 usd:   0
[54301.895103] CPU    3: hi:  186, btch:  31 usd:  31
[54301.895104] Node 0 Normal per-cpu:
[54301.895107] CPU    0: hi:  186, btch:  31 usd:   7
[54301.895108] CPU    1: hi:  186, btch:  31 usd:  39
[54301.895110] CPU    2: hi:  186, btch:  31 usd:  50
[54301.895112] CPU    3: hi:  186, btch:  31 usd: 127
[54301.895117] active_anon:76566 inactive_anon:16051 isolated_anon:0
[54301.895117]  active_file:125 inactive_file:997 isolated_file:0
[54301.895117]  unevictable:1683 dirty:10 writeback:1 unstable:0
[54301.895117]  free:22511 slab_reclaimable:845043 slab_unreclaimable:5753
[54301.895117]  mapped:3347 shmem:47634 pagetables:2419 bounce:0
[54301.895121] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54301.895127] lowmem_reserve[]: 0 2137 3899 3899
[54301.895132] Node 0 DMA32 free:43772kB min:36900kB low:46124kB high:55348kB active_anon:70880kB inactive_anon:2612kB active_file:4kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1272kB shmem:26732kB slab_reclaimable:2057048kB slab_unreclaimable:1808kB kernel_stack:168kB pagetables:2448kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:202 all_unreclaimable? yes
[54301.895138] lowmem_reserve[]: 0 0 1762 1762
[54301.895141] Node 0 Normal free:30432kB min:30416kB low:38020kB high:45624kB active_anon:235384kB inactive_anon:61592kB active_file:496kB inactive_file:3988kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:40kB writeback:4kB mapped:12116kB shmem:163804kB slab_reclaimable:1323060kB slab_unreclaimable:21204kB kernel_stack:1224kB pagetables:7228kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:5 all_unreclaimable? no
[54301.895146] lowmem_reserve[]: 0 0 0 0
[54301.895148] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54301.895154] Node 0 DMA32: 644*4kB 2130*8kB 1234*16kB 6*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43648kB
[54301.895160] Node 0 Normal: 2676*4kB 784*8kB 621*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30432kB
[54301.895166] 49673 total pagecache pages
[54301.895167] 0 pages in swap cache
[54301.895169] Swap cache stats: add 0, delete 0, find 0/0
[54301.895169] Free swap  = 0kB
[54301.895170] Total swap = 0kB
[54301.903503] 1048048 pages RAM
[54301.903506] 57533 pages reserved
[54301.903506] 31670 pages shared
[54301.903507] 939898 pages non-shared
[54301.903509] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54301.903514] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54301.903516] [  207]     0   207    71438     4295   3       0             0 systemd-journal
[54301.903519] [  331]     0   331     1056       45   1       0             0 acpid
[54301.903521] [  332]     0   332     3303      190   3       0             0 crond
[54301.903523] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54301.903525] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54301.903526] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54301.903528] [  349]     0   349    15747      115   3       0             0 login
[54301.903530] [  356]     0   356     2031       30   0       0             0 agetty
[54301.903532] [  357]     0   357     2031       30   2       0             0 agetty
[54301.903533] [  358]     0   358     2031       30   2       0             0 agetty
[54301.903535] [  359]     0   359     2031       32   0       0             0 agetty
[54301.903537] [  360]     0   360     2031       30   0       0             0 agetty
[54301.903538] [  418]     0   418     3092       75   3       0             0 master
[54301.903540] [  421]    73   421    16374      249   1       0             0 qmgr
[54301.903542] [  433]  1000   433     3423      101   3       0             0 restart-x
[54301.903544] [  444]  1000   444     3423      109   2       0             0 startx
[54301.903546] [  461]  1000   461     3966       36   3       0             0 xinit
[54301.903548] [  462]  1000   462    57250     3017   2       0             0 X
[54301.903550] [  483]  1000   483    13495      393   1       0             0 i3
[54301.903552] [  490]  1000   490     6062       72   0       0             0 unclutter
[54301.903553] [  493]  1000   493     6004       60   2       0             0 dispad
[54301.903555] [  494]  1000   494    31745     6805   2       0             0 urxvtd
[54301.903557] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54301.903558] [  508]  1000   508     8156      420   2       0             0 zsh
[54301.903560] [  515]     0   515     8482       80   0       0             0 sudo
[54301.903562] [  516]     0   516     6933      235   0       0             0 zsh
[54301.903564] [  530]     0   530     7404      156   2       0             0 wpa_supplicant
[54301.903565] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54301.903567] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54301.903569] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54301.903571] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54301.903573] [ 1312]  1000  1312    14878      698   3       0             0 mutt
[54301.903574] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54301.903576] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[54301.903578] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54301.903580] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54301.903581] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54301.903583] [12547]  1000 12547     8729      484   3       0             0 zsh
[54301.903585] [12784]  1000 12784     8156      421   3       0             0 zsh
[54301.903587] [24189]  1000 24189     8156      421   1       0             0 zsh
[54301.903588] [30766]  1000 30766     8156      421   0       0             0 zsh
[54301.903590] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54301.903592] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54301.903594] [ 5518]  1000  5518    90770     1587   1       0             0 kded4
[54301.903596] [ 5525]  1000  5525   238394     2464   2       0             0 knotify4
[54301.903597] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54301.903599] [ 5534]     0  5534    46649      203   3     -13          -900 polkitd
[54301.903601] [ 5556]     0  5556    48360      302   3       0             0 udisks-daemon
[54301.903602] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54301.903604] [ 8065]  1000  8065     6531      328   2       0             0 i3bar
[54301.903606] [ 8066]  1000  8066     7809      225   1       0             0 i3status
[54301.903608] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54301.903609] [ 8708]     0  8708     2776      122   0       0             0 wpa_cli
[54301.903611] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54301.903613] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54301.903614] [ 8776]     0  8776    51901      335   0       0             0 colord
[54301.903616] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54301.903618] [10002]  1000 10002     8290      403   0       0             0 vim
[54301.903620] [10733]  1000 10733     8156      421   2       0             0 zsh
[54301.903622] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54301.903624] [10749]  1000 10749     8156      421   2       0             0 zsh
[54301.903625] [10758]  1000 10758    15099      910   1       0             0 mutt
[54301.903627] [10786]  1000 10786     8970      263   0       0             0 ssh
[54301.903629] [10788]  1000 10788     8970      198   0       0             0 ssh
[54301.903630] [10790]  1000 10790     8970      270   0       0             0 ssh
[54301.903633] [15290]  1000 15290     9005      216   0       0             0 ssh
[54301.903635] [15483]     0 15483     5899      157   1       0             0 vpnc
[54301.903636] [15633]  1000 15633     8740      474   2       0             0 zsh
[54301.903638] [16517]  1000 16517     8156      421   2       0             0 zsh
[54301.903640] [16542]  1000 16542     8156      420   0       0             0 zsh
[54301.903642] [16555]  1000 16555     8267      407   0       0             0 vim
[54301.903643] [16569]  1000 16569    21607      139   1       0             0 i3lock
[54301.903646] [ 4043]    73  4043    16331      284   3       0             0 pickup
[54301.903647] [ 4573]     0  4573     3806     1680   3       0             0 atop
[54301.903650] [ 7764]     0  7764     9170      388   2       0             0 crond
[54301.903652] [ 7767]  1000  7767     2937      212   2       0             0 sh
[54301.903653] [ 7769]  1000  7769   155427    10015   1       0             0 offlineimap
[54301.903655] Out of memory: Kill process 7769 (offlineimap) score 10 or sacrifice child
[54301.903658] Killed process 7769 (offlineimap) total-vm:621708kB, anon-rss:38844kB, file-rss:1216kB
[54425.605767] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54425.605771] urxvtd cpuset=/ mems_allowed=0
[54425.605773] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[54425.605775] Call Trace:
[54425.605781]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54425.605786]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54425.605790]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54425.605795]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54425.605799]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54425.605802]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54425.605805]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54425.605809]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54425.605812]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54425.605815]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54425.605818]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54425.605822]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54425.605825]  [<ffffffff81079380>] ? lock_hrtimer_base.isra.22+0x30/0x60
[54425.605828]  [<ffffffff81079486>] ? hrtimer_try_to_cancel+0x86/0x110
[54425.605831]  [<ffffffff81079532>] ? hrtimer_cancel+0x22/0x30
[54425.605834]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54425.605838]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54425.605842]  [<ffffffff811bd101>] ? ep_poll+0x2a1/0x360
[54425.605845]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[54425.605849]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[54425.605851]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54425.605853] Mem-Info:
[54425.605854] Node 0 DMA per-cpu:
[54425.605857] CPU    0: hi:    0, btch:   1 usd:   0
[54425.605858] CPU    1: hi:    0, btch:   1 usd:   0
[54425.605860] CPU    2: hi:    0, btch:   1 usd:   0
[54425.605861] CPU    3: hi:    0, btch:   1 usd:   0
[54425.605862] Node 0 DMA32 per-cpu:
[54425.605865] CPU    0: hi:  186, btch:  31 usd:   0
[54425.605867] CPU    1: hi:  186, btch:  31 usd:   0
[54425.605869] CPU    2: hi:  186, btch:  31 usd:   0
[54425.605870] CPU    3: hi:  186, btch:  31 usd:   0
[54425.605871] Node 0 Normal per-cpu:
[54425.605873] CPU    0: hi:  186, btch:  31 usd:   0
[54425.605874] CPU    1: hi:  186, btch:  31 usd:   0
[54425.605876] CPU    2: hi:  186, btch:  31 usd:   0
[54425.605877] CPU    3: hi:  186, btch:  31 usd:   0
[54425.605880] active_anon:77766 inactive_anon:16049 isolated_anon:0
[54425.605880]  active_file:0 inactive_file:0 isolated_file:0
[54425.605880]  unevictable:1683 dirty:0 writeback:0 unstable:0
[54425.605880]  free:22537 slab_reclaimable:845018 slab_unreclaimable:5774
[54425.605880]  mapped:3128 shmem:47649 pagetables:2421 bounce:0
[54425.605882] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54425.605886] lowmem_reserve[]: 0 2137 3899 3899
[54425.605889] Node 0 DMA32 free:43900kB min:36900kB low:46124kB high:55348kB active_anon:70760kB inactive_anon:2596kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1280kB shmem:26716kB slab_reclaimable:2056972kB slab_unreclaimable:1808kB kernel_stack:168kB pagetables:2524kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:424 all_unreclaimable? yes
[54425.605893] lowmem_reserve[]: 0 0 1762 1762
[54425.605896] Node 0 Normal free:30408kB min:30416kB low:38020kB high:45624kB active_anon:240304kB inactive_anon:61600kB active_file:0kB inactive_file:0kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:11232kB shmem:163880kB slab_reclaimable:1323036kB slab_unreclaimable:21288kB kernel_stack:1240kB pagetables:7160kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:6936 all_unreclaimable? yes
[54425.605900] lowmem_reserve[]: 0 0 0 0
[54425.605902] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54425.605909] Node 0 DMA32: 650*4kB 2147*8kB 1241*16kB 10*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44112kB
[54425.605914] Node 0 Normal: 2680*4kB 709*8kB 673*16kB 3*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30776kB
[54425.605921] 48492 total pagecache pages
[54425.605922] 0 pages in swap cache
[54425.605923] Swap cache stats: add 0, delete 0, find 0/0
[54425.605924] Free swap  = 0kB
[54425.605925] Total swap = 0kB
[54425.614438] 1048048 pages RAM
[54425.614441] 57533 pages reserved
[54425.614442] 31430 pages shared
[54425.614443] 940265 pages non-shared
[54425.614445] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54425.614451] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54425.614454] [  207]     0   207    71438     4354   3       0             0 systemd-journal
[54425.614457] [  331]     0   331     1056       45   1       0             0 acpid
[54425.614460] [  332]     0   332     3303      190   2       0             0 crond
[54425.614462] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54425.614465] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54425.614467] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54425.614469] [  349]     0   349    15747      115   3       0             0 login
[54425.614472] [  356]     0   356     2031       30   0       0             0 agetty
[54425.614474] [  357]     0   357     2031       30   2       0             0 agetty
[54425.614476] [  358]     0   358     2031       30   2       0             0 agetty
[54425.614478] [  359]     0   359     2031       32   0       0             0 agetty
[54425.614481] [  360]     0   360     2031       30   0       0             0 agetty
[54425.614483] [  418]     0   418     3092       77   0       0             0 master
[54425.614485] [  421]    73   421    16374      258   0       0             0 qmgr
[54425.614488] [  433]  1000   433     3423      101   3       0             0 restart-x
[54425.614490] [  444]  1000   444     3423      109   2       0             0 startx
[54425.614492] [  461]  1000   461     3966       36   3       0             0 xinit
[54425.614494] [  462]  1000   462    57250     3019   3       0             0 X
[54425.614497] [  483]  1000   483    13495      393   0       0             0 i3
[54425.614499] [  490]  1000   490     6062       72   3       0             0 unclutter
[54425.614501] [  493]  1000   493     6004       58   1       0             0 dispad
[54425.614503] [  494]  1000   494    31745     6798   1       0             0 urxvtd
[54425.614506] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54425.614508] [  508]  1000   508     8156      420   2       0             0 zsh
[54425.614510] [  515]     0   515     8482       80   0       0             0 sudo
[54425.614512] [  516]     0   516     6933      235   0       0             0 zsh
[54425.614515] [  530]     0   530     7404      163   1       0             0 wpa_supplicant
[54425.614517] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54425.614519] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54425.614522] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54425.614524] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54425.614526] [ 1312]  1000  1312    14878      698   3       0             0 mutt
[54425.614529] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54425.614531] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[54425.614533] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54425.614535] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54425.614538] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54425.614540] [12547]  1000 12547     8729      484   3       0             0 zsh
[54425.614542] [12784]  1000 12784     8156      421   3       0             0 zsh
[54425.614545] [24189]  1000 24189     8156      421   1       0             0 zsh
[54425.614547] [30766]  1000 30766     8156      421   0       0             0 zsh
[54425.614549] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54425.614552] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54425.614554] [ 5518]  1000  5518    90770     1560   1       0             0 kded4
[54425.614556] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[54425.614558] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54425.614560] [ 5534]     0  5534    46649      203   0     -13          -900 polkitd
[54425.614563] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[54425.614565] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54425.614567] [ 8065]  1000  8065     6531      292   2       0             0 i3bar
[54425.614570] [ 8066]  1000  8066     7809      222   1       0             0 i3status
[54425.614572] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54425.614574] [ 8708]     0  8708     2776      152   3       0             0 wpa_cli
[54425.614576] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54425.614579] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54425.614581] [ 8776]     0  8776    51901      335   0       0             0 colord
[54425.614583] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54425.614586] [10002]  1000 10002     8290      403   0       0             0 vim
[54425.614589] [10733]  1000 10733     8156      421   2       0             0 zsh
[54425.614591] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54425.614593] [10749]  1000 10749     8156      421   2       0             0 zsh
[54425.614596] [10758]  1000 10758    15099      910   1       0             0 mutt
[54425.614598] [10786]  1000 10786     8970      278   0       0             0 ssh
[54425.614600] [10788]  1000 10788     8970      198   0       0             0 ssh
[54425.614602] [10790]  1000 10790     8970      288   1       0             0 ssh
[54425.614605] [15290]  1000 15290     9005      218   0       0             0 ssh
[54425.614607] [15483]     0 15483     5899      136   0       0             0 vpnc
[54425.614609] [15633]  1000 15633     8740      474   2       0             0 zsh
[54425.614611] [16517]  1000 16517     8156      421   2       0             0 zsh
[54425.614614] [16542]  1000 16542     8156      420   0       0             0 zsh
[54425.614616] [16555]  1000 16555     8267      407   0       0             0 vim
[54425.614618] [16569]  1000 16569    21607      142   1       0             0 i3lock
[54425.614621] [ 4043]    73  4043    16331      250   0       0             0 pickup
[54425.614623] [ 4573]     0  4573     3806     1680   3       0             0 atop
[54425.614627] [ 7903]     0  7903     9170      388   3       0             0 crond
[54425.614629] [ 7906]  1000  7906     2937      209   1       0             0 sh
[54425.614631] [ 7908]  1000  7908   155429    11049   1       0             0 offlineimap
[54425.614633] Out of memory: Kill process 7908 (offlineimap) score 11 or sacrifice child
[54425.614636] Killed process 7908 (offlineimap) total-vm:621716kB, anon-rss:43740kB, file-rss:456kB
[54425.615954] systemd-journal invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54425.615957] systemd-journal cpuset=/ mems_allowed=0
[54425.615960] Pid: 207, comm: systemd-journal Tainted: G        W    3.5.4-1-ARCH #1
[54425.615961] Call Trace:
[54425.615967]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54425.615972]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54425.615976]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54425.615980]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54425.615985]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54425.615988]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54425.615991]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54425.615995]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54425.615998]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54425.616000]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54425.616004]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54425.616008]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54425.616011]  [<ffffffff8147ba8e>] ? __mutex_lock_slowpath+0x24e/0x340
[54425.616014]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54425.616018]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54425.616022]  [<ffffffff811bcf94>] ? ep_poll+0x134/0x360
[54425.616026]  [<ffffffff81086f70>] ? try_to_wake_up+0x2f0/0x2f0
[54425.616028]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54425.616030] Mem-Info:
[54425.616031] Node 0 DMA per-cpu:
[54425.616034] CPU    0: hi:    0, btch:   1 usd:   0
[54425.616035] CPU    1: hi:    0, btch:   1 usd:   0
[54425.616037] CPU    2: hi:    0, btch:   1 usd:   0
[54425.616038] CPU    3: hi:    0, btch:   1 usd:   0
[54425.616039] Node 0 DMA32 per-cpu:
[54425.616041] CPU    0: hi:  186, btch:  31 usd:   0
[54425.616043] CPU    1: hi:  186, btch:  31 usd:   0
[54425.616044] CPU    2: hi:  186, btch:  31 usd:   0
[54425.616046] CPU    3: hi:  186, btch:  31 usd:   0
[54425.616047] Node 0 Normal per-cpu:
[54425.616049] CPU    0: hi:  186, btch:  31 usd:   0
[54425.616050] CPU    1: hi:  186, btch:  31 usd:   0
[54425.616052] CPU    2: hi:  186, btch:  31 usd:   0
[54425.616053] CPU    3: hi:  186, btch:  31 usd:   0
[54425.616057] active_anon:77766 inactive_anon:16049 isolated_anon:0
[54425.616057]  active_file:0 inactive_file:0 isolated_file:0
[54425.616057]  unevictable:1683 dirty:0 writeback:0 unstable:0
[54425.616057]  free:22537 slab_reclaimable:845018 slab_unreclaimable:5774
[54425.616057]  mapped:3128 shmem:47649 pagetables:2421 bounce:0
[54425.616060] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54425.616065] lowmem_reserve[]: 0 2137 3899 3899
[54425.616069] Node 0 DMA32 free:43900kB min:36900kB low:46124kB high:55348kB active_anon:70760kB inactive_anon:2596kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1280kB shmem:26716kB slab_reclaimable:2056972kB slab_unreclaimable:1808kB kernel_stack:168kB pagetables:2524kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:860 all_unreclaimable? yes
[54425.616074] lowmem_reserve[]: 0 0 1762 1762
[54425.616077] Node 0 Normal free:30408kB min:30416kB low:38020kB high:45624kB active_anon:240304kB inactive_anon:61600kB active_file:0kB inactive_file:0kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:11232kB shmem:163880kB slab_reclaimable:1323036kB slab_unreclaimable:21288kB kernel_stack:1240kB pagetables:7160kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:13686 all_unreclaimable? yes
[54425.616082] lowmem_reserve[]: 0 0 0 0
[54425.616085] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54425.616093] Node 0 DMA32: 650*4kB 2147*8kB 1241*16kB 10*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44112kB
[54425.616101] Node 0 Normal: 2680*4kB 709*8kB 673*16kB 3*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30776kB
[54425.616109] 48492 total pagecache pages
[54425.616110] 0 pages in swap cache
[54425.616111] Swap cache stats: add 0, delete 0, find 0/0
[54425.616112] Free swap  = 0kB
[54425.616114] Total swap = 0kB
[54425.624863] 1048048 pages RAM
[54425.624865] 57533 pages reserved
[54425.624865] 31435 pages shared
[54425.624866] 940204 pages non-shared
[54425.624868] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54425.624873] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54425.624875] [  207]     0   207    71438     4354   3       0             0 systemd-journal
[54425.624877] [  331]     0   331     1056       45   1       0             0 acpid
[54425.624879] [  332]     0   332     3303      190   2       0             0 crond
[54425.624881] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54425.624883] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54425.624885] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54425.624887] [  349]     0   349    15747      115   3       0             0 login
[54425.624888] [  356]     0   356     2031       30   0       0             0 agetty
[54425.624890] [  357]     0   357     2031       30   2       0             0 agetty
[54425.624892] [  358]     0   358     2031       30   2       0             0 agetty
[54425.624894] [  359]     0   359     2031       32   0       0             0 agetty
[54425.624895] [  360]     0   360     2031       30   0       0             0 agetty
[54425.624897] [  418]     0   418     3092       77   0       0             0 master
[54425.624899] [  421]    73   421    16374      258   0       0             0 qmgr
[54425.624901] [  433]  1000   433     3423      101   3       0             0 restart-x
[54425.624903] [  444]  1000   444     3423      109   2       0             0 startx
[54425.624904] [  461]  1000   461     3966       36   3       0             0 xinit
[54425.624906] [  462]  1000   462    57250     3019   1       0             0 X
[54425.624908] [  483]  1000   483    13495      393   0       0             0 i3
[54425.624910] [  490]  1000   490     6062       72   3       0             0 unclutter
[54425.624912] [  493]  1000   493     6004       58   1       0             0 dispad
[54425.624913] [  494]  1000   494    31745     6798   1       0             0 urxvtd
[54425.624915] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54425.624917] [  508]  1000   508     8156      420   2       0             0 zsh
[54425.624918] [  515]     0   515     8482       80   0       0             0 sudo
[54425.624920] [  516]     0   516     6933      235   0       0             0 zsh
[54425.624922] [  530]     0   530     7404      163   1       0             0 wpa_supplicant
[54425.624924] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54425.624926] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54425.624927] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54425.624929] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54425.624931] [ 1312]  1000  1312    14878      698   3       0             0 mutt
[54425.624933] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54425.624935] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[54425.624936] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54425.624938] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54425.624940] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54425.624942] [12547]  1000 12547     8729      484   3       0             0 zsh
[54425.624944] [12784]  1000 12784     8156      421   3       0             0 zsh
[54425.624945] [24189]  1000 24189     8156      421   1       0             0 zsh
[54425.624947] [30766]  1000 30766     8156      421   0       0             0 zsh
[54425.624949] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54425.624950] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54425.624952] [ 5518]  1000  5518    90770     1560   1       0             0 kded4
[54425.624954] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[54425.624956] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54425.624957] [ 5534]     0  5534    46649      203   0     -13          -900 polkitd
[54425.624959] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[54425.624961] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54425.624963] [ 8065]  1000  8065     6531      292   2       0             0 i3bar
[54425.624964] [ 8066]  1000  8066     7809      222   1       0             0 i3status
[54425.624966] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54425.624968] [ 8708]     0  8708     2776      152   3       0             0 wpa_cli
[54425.624969] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54425.624971] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54425.624973] [ 8776]     0  8776    51901      335   0       0             0 colord
[54425.624975] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54425.624976] [10002]  1000 10002     8290      403   0       0             0 vim
[54425.624979] [10733]  1000 10733     8156      421   2       0             0 zsh
[54425.624981] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54425.624982] [10749]  1000 10749     8156      421   2       0             0 zsh
[54425.624984] [10758]  1000 10758    15099      910   1       0             0 mutt
[54425.624986] [10786]  1000 10786     8970      278   0       0             0 ssh
[54425.624988] [10788]  1000 10788     8970      198   0       0             0 ssh
[54425.624989] [10790]  1000 10790     8970      288   1       0             0 ssh
[54425.624991] [15290]  1000 15290     9005      218   0       0             0 ssh
[54425.624993] [15483]     0 15483     5899      136   0       0             0 vpnc
[54425.624995] [15633]  1000 15633     8740      474   2       0             0 zsh
[54425.624996] [16517]  1000 16517     8156      421   2       0             0 zsh
[54425.624998] [16542]  1000 16542     8156      420   0       0             0 zsh
[54425.625000] [16555]  1000 16555     8267      407   0       0             0 vim
[54425.625002] [16569]  1000 16569    21607      142   1       0             0 i3lock
[54425.625004] [ 4043]    73  4043    16331      250   0       0             0 pickup
[54425.625006] [ 4573]     0  4573     3806     1680   3       0             0 atop
[54425.625009] [ 7903]     0  7903     9170      388   3       0             0 crond
[54425.625010] [ 7906]  1000  7906     2937      209   1       0             0 sh
[54425.625012] [ 8062]  1000  7908   155429    11223   0       0             0 offlineimap
[54425.625014] Out of memory: Kill process 8062 (offlineimap) score 11 or sacrifice child
[54425.625016] Killed process 8062 (offlineimap) total-vm:621716kB, anon-rss:43808kB, file-rss:1084kB
[54542.569576] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54542.569581] urxvtd cpuset=/ mems_allowed=0
[54542.569584] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[54542.569586] Call Trace:
[54542.569593]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54542.569598]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54542.569603]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54542.569608]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54542.569613]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54542.569617]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54542.569621]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54542.569625]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54542.569629]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54542.569632]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54542.569636]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54542.569640]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54542.569644]  [<ffffffff812f3388>] ? put_ldisc+0x58/0xc0
[54542.569647]  [<ffffffff812f33fe>] ? tty_ldisc_deref+0xe/0x10
[54542.569651]  [<ffffffff812eb75d>] ? tty_poll+0x9d/0xa0
[54542.569654]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54542.569659]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54542.569664]  [<ffffffff811bcf94>] ? ep_poll+0x134/0x360
[54542.569667]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[54542.569671]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[54542.569674]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54542.569676] Mem-Info:
[54542.569677] Node 0 DMA per-cpu:
[54542.569680] CPU    0: hi:    0, btch:   1 usd:   0
[54542.569682] CPU    1: hi:    0, btch:   1 usd:   0
[54542.569684] CPU    2: hi:    0, btch:   1 usd:   0
[54542.569686] CPU    3: hi:    0, btch:   1 usd:   0
[54542.569687] Node 0 DMA32 per-cpu:
[54542.569690] CPU    0: hi:  186, btch:  31 usd:   0
[54542.569692] CPU    1: hi:  186, btch:  31 usd:   0
[54542.569693] CPU    2: hi:  186, btch:  31 usd:   0
[54542.569695] CPU    3: hi:  186, btch:  31 usd:   0
[54542.569696] Node 0 Normal per-cpu:
[54542.569699] CPU    0: hi:  186, btch:  31 usd:   0
[54542.569701] CPU    1: hi:  186, btch:  31 usd:  30
[54542.569702] CPU    2: hi:  186, btch:  31 usd:   0
[54542.569704] CPU    3: hi:  186, btch:  31 usd:  73
[54542.569709] active_anon:77757 inactive_anon:16049 isolated_anon:0
[54542.569709]  active_file:7 inactive_file:47 isolated_file:0
[54542.569709]  unevictable:1683 dirty:0 writeback:0 unstable:0
[54542.569709]  free:22522 slab_reclaimable:845018 slab_unreclaimable:5764
[54542.569709]  mapped:3148 shmem:47675 pagetables:2424 bounce:0
[54542.569712] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54542.569718] lowmem_reserve[]: 0 2137 3899 3899
[54542.569723] Node 0 DMA32 free:43944kB min:36900kB low:46124kB high:55348kB active_anon:70568kB inactive_anon:2608kB active_file:16kB inactive_file:96kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1352kB shmem:26732kB slab_reclaimable:2056972kB slab_unreclaimable:1828kB kernel_stack:176kB pagetables:2480kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:3853 all_unreclaimable? yes
[54542.569729] lowmem_reserve[]: 0 0 1762 1762
[54542.569733] Node 0 Normal free:30304kB min:30416kB low:38020kB high:45624kB active_anon:240460kB inactive_anon:61588kB active_file:12kB inactive_file:92kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:11240kB shmem:163968kB slab_reclaimable:1323036kB slab_unreclaimable:21228kB kernel_stack:1240kB pagetables:7216kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:3842 all_unreclaimable? yes
[54542.569739] lowmem_reserve[]: 0 0 0 0
[54542.569743] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54542.569752] Node 0 DMA32: 664*4kB 2139*8kB 1242*16kB 12*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44120kB
[54542.569762] Node 0 Normal: 2701*4kB 768*8kB 624*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30452kB
[54542.569771] 48680 total pagecache pages
[54542.569772] 0 pages in swap cache
[54542.569774] Swap cache stats: add 0, delete 0, find 0/0
[54542.569775] Free swap  = 0kB
[54542.569777] Total swap = 0kB
[54542.581592] 1048048 pages RAM
[54542.581595] 57533 pages reserved
[54542.581597] 31544 pages shared
[54542.581598] 940160 pages non-shared
[54542.581599] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54542.581607] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54542.581610] [  207]     0   207    71438     4395   0       0             0 systemd-journal
[54542.581613] [  331]     0   331     1056       45   1       0             0 acpid
[54542.581615] [  332]     0   332     3303      190   1       0             0 crond
[54542.581618] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54542.581620] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54542.581623] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54542.581625] [  349]     0   349    15747      115   3       0             0 login
[54542.581628] [  356]     0   356     2031       30   0       0             0 agetty
[54542.581630] [  357]     0   357     2031       30   2       0             0 agetty
[54542.581633] [  358]     0   358     2031       30   2       0             0 agetty
[54542.581635] [  359]     0   359     2031       32   0       0             0 agetty
[54542.581637] [  360]     0   360     2031       30   0       0             0 agetty
[54542.581639] [  418]     0   418     3092       81   0       0             0 master
[54542.581642] [  421]    73   421    16374      269   1       0             0 qmgr
[54542.581645] [  433]  1000   433     3423      101   3       0             0 restart-x
[54542.581647] [  444]  1000   444     3423      109   2       0             0 startx
[54542.581650] [  461]  1000   461     3966       36   3       0             0 xinit
[54542.581653] [  462]  1000   462    57250     2981   3       0             0 X
[54542.581655] [  483]  1000   483    13495      393   0       0             0 i3
[54542.581658] [  490]  1000   490     6062       75   0       0             0 unclutter
[54542.581661] [  493]  1000   493     6004       70   2       0             0 dispad
[54542.581663] [  494]  1000   494    31745     6817   1       0             0 urxvtd
[54542.581666] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54542.581669] [  508]  1000   508     8156      420   2       0             0 zsh
[54542.581672] [  515]     0   515     8482       80   0       0             0 sudo
[54542.581675] [  516]     0   516     6933      235   0       0             0 zsh
[54542.581678] [  530]     0   530     7404      188   3       0             0 wpa_supplicant
[54542.581681] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54542.581685] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54542.581688] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54542.581691] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54542.581695] [ 1312]  1000  1312    14878      698   3       0             0 mutt
[54542.581698] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54542.581701] [ 1339]  1000  1339    16616     2409   2       0             0 mutt
[54542.581703] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54542.581705] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54542.581708] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54542.581710] [12547]  1000 12547     8729      484   3       0             0 zsh
[54542.581712] [12784]  1000 12784     8156      421   3       0             0 zsh
[54542.581715] [24189]  1000 24189     8156      421   1       0             0 zsh
[54542.581718] [30766]  1000 30766     8156      421   0       0             0 zsh
[54542.581720] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54542.581723] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54542.581725] [ 5518]  1000  5518    90770     1570   1       0             0 kded4
[54542.581728] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[54542.581730] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54542.581733] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[54542.581736] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[54542.581738] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54542.581741] [ 8065]  1000  8065     6531      325   2       0             0 i3bar
[54542.581744] [ 8066]  1000  8066     7809      204   1       0             0 i3status
[54542.581746] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54542.581750] [ 8708]     0  8708     2776      131   1       0             0 wpa_cli
[54542.581753] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54542.581756] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54542.581760] [ 8776]     0  8776    51901      335   0       0             0 colord
[54542.581763] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54542.581766] [10002]  1000 10002     8290      403   0       0             0 vim
[54542.581770] [10733]  1000 10733     8156      421   2       0             0 zsh
[54542.581773] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54542.581775] [10749]  1000 10749     8156      421   2       0             0 zsh
[54542.581778] [10758]  1000 10758    15099      910   1       0             0 mutt
[54542.581781] [10786]  1000 10786     8970      294   0       0             0 ssh
[54542.581785] [10788]  1000 10788     8970      198   0       0             0 ssh
[54542.581788] [10790]  1000 10790     8970      240   0       0             0 ssh
[54542.581791] [15290]  1000 15290     9005      216   0       0             0 ssh
[54542.581795] [15483]     0 15483     5899      121   2       0             0 vpnc
[54542.581798] [15633]  1000 15633     8740      474   2       0             0 zsh
[54542.581802] [16517]  1000 16517     8156      421   2       0             0 zsh
[54542.581805] [16542]  1000 16542     8156      420   0       0             0 zsh
[54542.581808] [16555]  1000 16555     8267      407   0       0             0 vim
[54542.581811] [16569]  1000 16569    21607      139   0       0             0 i3lock
[54542.581815] [ 4043]    73  4043    16331      278   0       0             0 pickup
[54542.581818] [ 4573]     0  4573     3806     1680   3       0             0 atop
[54542.581822] [ 8076]     0  8076     9170      388   1       0             0 crond
[54542.581825] [ 8078]  1000  8078     2937      211   1       0             0 sh
[54542.581828] [ 8081]  1000  8081   171801    10998   1       0             0 offlineimap
[54542.581830] Out of memory: Kill process 8081 (offlineimap) score 11 or sacrifice child
[54542.581834] Killed process 8081 (offlineimap) total-vm:687204kB, anon-rss:43540kB, file-rss:452kB
[54542.583663] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54542.583666] urxvtd cpuset=/ mems_allowed=0
[54542.583669] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[54542.583671] Call Trace:
[54542.583677]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54542.583682]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54542.583686]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54542.583690]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54542.583695]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54542.583698]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54542.583702]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54542.583706]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54542.583709]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54542.583711]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54542.583716]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54542.583720]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54542.583723]  [<ffffffff812f3388>] ? put_ldisc+0x58/0xc0
[54542.583726]  [<ffffffff812f33fe>] ? tty_ldisc_deref+0xe/0x10
[54542.583729]  [<ffffffff812eb75d>] ? tty_poll+0x9d/0xa0
[54542.583732]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54542.583736]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54542.583740]  [<ffffffff811bcf94>] ? ep_poll+0x134/0x360
[54542.583743]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[54542.583746]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[54542.583749]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54542.583751] Mem-Info:
[54542.583752] Node 0 DMA per-cpu:
[54542.583754] CPU    0: hi:    0, btch:   1 usd:   0
[54542.583756] CPU    1: hi:    0, btch:   1 usd:   0
[54542.583757] CPU    2: hi:    0, btch:   1 usd:   0
[54542.583760] CPU    3: hi:    0, btch:   1 usd:   0
[54542.583761] Node 0 DMA32 per-cpu:
[54542.583763] CPU    0: hi:  186, btch:  31 usd:   0
[54542.583765] CPU    1: hi:  186, btch:  31 usd:   0
[54542.583766] CPU    2: hi:  186, btch:  31 usd:   0
[54542.583768] CPU    3: hi:  186, btch:  31 usd:  50
[54542.583768] Node 0 Normal per-cpu:
[54542.583771] CPU    0: hi:  186, btch:  31 usd:   0
[54542.583772] CPU    1: hi:  186, btch:  31 usd:  30
[54542.583774] CPU    2: hi:  186, btch:  31 usd:   0
[54542.583775] CPU    3: hi:  186, btch:  31 usd: 131
[54542.583780] active_anon:77757 inactive_anon:16049 isolated_anon:0
[54542.583780]  active_file:7 inactive_file:26 isolated_file:0
[54542.583780]  unevictable:1683 dirty:0 writeback:0 unstable:0
[54542.583780]  free:22522 slab_reclaimable:845018 slab_unreclaimable:5764
[54542.583780]  mapped:3148 shmem:47675 pagetables:2424 bounce:0
[54542.583783] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54542.583789] lowmem_reserve[]: 0 2137 3899 3899
[54542.583792] Node 0 DMA32 free:43944kB min:36900kB low:46124kB high:55348kB active_anon:70568kB inactive_anon:2608kB active_file:16kB inactive_file:96kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1352kB shmem:26732kB slab_reclaimable:2056972kB slab_unreclaimable:1828kB kernel_stack:176kB pagetables:2480kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:15755 all_unreclaimable? yes
[54542.583798] lowmem_reserve[]: 0 0 1762 1762
[54542.583801] Node 0 Normal free:30304kB min:30416kB low:38020kB high:45624kB active_anon:240460kB inactive_anon:61588kB active_file:12kB inactive_file:8kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:11240kB shmem:163968kB slab_reclaimable:1323036kB slab_unreclaimable:21228kB kernel_stack:1240kB pagetables:7216kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:18310 all_unreclaimable? yes
[54542.583807] lowmem_reserve[]: 0 0 0 0
[54542.583810] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54542.583818] Node 0 DMA32: 664*4kB 2139*8kB 1242*16kB 12*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44120kB
[54542.583826] Node 0 Normal: 2701*4kB 768*8kB 624*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30452kB
[54542.583833] 48579 total pagecache pages
[54542.583835] 0 pages in swap cache
[54542.583836] Swap cache stats: add 0, delete 0, find 0/0
[54542.583837] Free swap  = 0kB
[54542.583838] Total swap = 0kB
[54542.602280] 1048048 pages RAM
[54542.602286] 57533 pages reserved
[54542.602288] 31493 pages shared
[54542.602291] 940189 pages non-shared
[54542.602294] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54542.602308] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54542.602315] [  207]     0   207    71438     4395   0       0             0 systemd-journal
[54542.602322] [  331]     0   331     1056       45   1       0             0 acpid
[54542.602328] [  332]     0   332     3303      190   1       0             0 crond
[54542.602333] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54542.602339] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54542.602344] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54542.602358] [  349]     0   349    15747      115   3       0             0 login
[54542.602360] [  356]     0   356     2031       30   0       0             0 agetty
[54542.602362] [  357]     0   357     2031       30   2       0             0 agetty
[54542.602364] [  358]     0   358     2031       30   2       0             0 agetty
[54542.602365] [  359]     0   359     2031       32   0       0             0 agetty
[54542.602367] [  360]     0   360     2031       30   0       0             0 agetty
[54542.602369] [  418]     0   418     3092       81   0       0             0 master
[54542.602371] [  421]    73   421    16374      269   1       0             0 qmgr
[54542.602373] [  433]  1000   433     3423      101   3       0             0 restart-x
[54542.602375] [  444]  1000   444     3423      109   2       0             0 startx
[54542.602376] [  461]  1000   461     3966       36   3       0             0 xinit
[54542.602378] [  462]  1000   462    57250     2981   3       0             0 X
[54542.602380] [  483]  1000   483    13495      393   0       0             0 i3
[54542.602382] [  490]  1000   490     6062       75   0       0             0 unclutter
[54542.602384] [  493]  1000   493     6004       70   0       0             0 dispad
[54542.602385] [  494]  1000   494    31745     6798   1       0             0 urxvtd
[54542.602387] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54542.602389] [  508]  1000   508     8156      420   2       0             0 zsh
[54542.602391] [  515]     0   515     8482       80   0       0             0 sudo
[54542.602392] [  516]     0   516     6933      235   0       0             0 zsh
[54542.602394] [  530]     0   530     7404      188   3       0             0 wpa_supplicant
[54542.602396] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54542.602398] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54542.602399] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54542.602401] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54542.602403] [ 1312]  1000  1312    14878      698   3       0             0 mutt
[54542.602405] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54542.602407] [ 1339]  1000  1339    16616     2409   2       0             0 mutt
[54542.602409] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54542.602410] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54542.602412] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54542.602414] [12547]  1000 12547     8729      484   3       0             0 zsh
[54542.602416] [12784]  1000 12784     8156      421   3       0             0 zsh
[54542.602417] [24189]  1000 24189     8156      421   1       0             0 zsh
[54542.602419] [30766]  1000 30766     8156      421   0       0             0 zsh
[54542.602421] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54542.602423] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54542.602425] [ 5518]  1000  5518    90770     1570   1       0             0 kded4
[54542.602426] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[54542.602428] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54542.602430] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[54542.602432] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[54542.602433] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54542.602435] [ 8065]  1000  8065     6531      325   2       0             0 i3bar
[54542.602437] [ 8066]  1000  8066     7809      204   1       0             0 i3status
[54542.602439] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54542.602440] [ 8708]     0  8708     2776      131   1       0             0 wpa_cli
[54542.602442] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54542.602444] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54542.602446] [ 8776]     0  8776    51901      335   0       0             0 colord
[54542.602448] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54542.602449] [10002]  1000 10002     8290      403   0       0             0 vim
[54542.602452] [10733]  1000 10733     8156      421   2       0             0 zsh
[54542.602454] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54542.602455] [10749]  1000 10749     8156      421   2       0             0 zsh
[54542.602457] [10758]  1000 10758    15099      910   1       0             0 mutt
[54542.602459] [10786]  1000 10786     8970      294   0       0             0 ssh
[54542.602460] [10788]  1000 10788     8970      198   0       0             0 ssh
[54542.602462] [10790]  1000 10790     8970      240   0       0             0 ssh
[54542.602464] [15290]  1000 15290     9005      216   0       0             0 ssh
[54542.602466] [15483]     0 15483     5899      171   0       0             0 vpnc
[54542.602468] [15633]  1000 15633     8740      474   2       0             0 zsh
[54542.602470] [16517]  1000 16517     8156      421   2       0             0 zsh
[54542.602472] [16542]  1000 16542     8156      420   0       0             0 zsh
[54542.602473] [16555]  1000 16555     8267      407   0       0             0 vim
[54542.602475] [16569]  1000 16569    21607      139   0       0             0 i3lock
[54542.602478] [ 4043]    73  4043    16331      278   0       0             0 pickup
[54542.602479] [ 4573]     0  4573     3806     1680   3       0             0 atop
[54542.602482] [ 8076]     0  8076     9170      388   1       0             0 crond
[54542.602484] [ 8078]  1000  8078     2937      211   1       0             0 sh
[54542.602486] Out of memory: Kill process 8237 (offlineimap) score 11 or sacrifice child
[54668.741943] offlineimap invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54668.741946] offlineimap cpuset=/ mems_allowed=0
[54668.741948] Pid: 8405, comm: offlineimap Tainted: G        W    3.5.4-1-ARCH #1
[54668.741949] Call Trace:
[54668.741955]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54668.741959]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54668.741962]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54668.741967]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54668.741970]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54668.741973]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54668.741976]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54668.741979]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54668.741982]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54668.741984]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54668.741987]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54668.741990]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54668.741993]  [<ffffffff81086fc0>] ? wake_up_state+0x10/0x20
[54668.741996]  [<ffffffff810aaa7b>] ? wake_futex+0x3b/0x60
[54668.741998]  [<ffffffff810ab759>] ? futex_wake+0x109/0x130
[54668.742000]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54668.742004]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54668.742006]  [<ffffffff810adc92>] ? sys_futex+0x102/0x190
[54668.742008]  [<ffffffff811477e5>] ? sys_mprotect+0x1e5/0x270
[54668.742010]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54668.742011] Mem-Info:
[54668.742012] Node 0 DMA per-cpu:
[54668.742014] CPU    0: hi:    0, btch:   1 usd:   0
[54668.742016] CPU    1: hi:    0, btch:   1 usd:   0
[54668.742017] CPU    2: hi:    0, btch:   1 usd:   0
[54668.742018] CPU    3: hi:    0, btch:   1 usd:   0
[54668.742019] Node 0 DMA32 per-cpu:
[54668.742020] CPU    0: hi:  186, btch:  31 usd:   0
[54668.742022] CPU    1: hi:  186, btch:  31 usd:   0
[54668.742023] CPU    2: hi:  186, btch:  31 usd:   0
[54668.742024] CPU    3: hi:  186, btch:  31 usd:   0
[54668.742025] Node 0 Normal per-cpu:
[54668.742026] CPU    0: hi:  186, btch:  31 usd:  17
[54668.742028] CPU    1: hi:  186, btch:  31 usd:  30
[54668.742029] CPU    2: hi:  186, btch:  31 usd:  27
[54668.742030] CPU    3: hi:  186, btch:  31 usd:   4
[54668.742033] active_anon:77844 inactive_anon:16050 isolated_anon:0
[54668.742033]  active_file:0 inactive_file:0 isolated_file:0
[54668.742033]  unevictable:1683 dirty:0 writeback:9 unstable:0
[54668.742033]  free:22511 slab_reclaimable:845021 slab_unreclaimable:5759
[54668.742033]  mapped:3204 shmem:47704 pagetables:2421 bounce:0
[54668.742035] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54668.742039] lowmem_reserve[]: 0 2137 3899 3899
[54668.742042] Node 0 DMA32 free:43884kB min:36900kB low:46124kB high:55348kB active_anon:70800kB inactive_anon:2596kB active_file:12kB inactive_file:12kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:4kB mapped:1364kB shmem:26716kB slab_reclaimable:2056972kB slab_unreclaimable:1820kB kernel_stack:168kB pagetables:2488kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:49 all_unreclaimable? yes
[54668.742046] lowmem_reserve[]: 0 0 1762 1762
[54668.742049] Node 0 Normal free:30320kB min:30416kB low:38020kB high:45624kB active_anon:240576kB inactive_anon:61604kB active_file:0kB inactive_file:0kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:32kB mapped:11452kB shmem:164100kB slab_reclaimable:1323048kB slab_unreclaimable:21216kB kernel_stack:1248kB pagetables:7196kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:415 all_unreclaimable? yes
[54668.742053] lowmem_reserve[]: 0 0 0 0
[54668.742055] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54668.742062] Node 0 DMA32: 631*4kB 2152*8kB 1240*16kB 10*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44060kB
[54668.742068] Node 0 Normal: 2732*4kB 772*8kB 621*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30560kB
[54668.742074] 48608 total pagecache pages
[54668.742075] 0 pages in swap cache
[54668.742076] Swap cache stats: add 0, delete 0, find 0/0
[54668.742077] Free swap  = 0kB
[54668.742077] Total swap = 0kB
[54668.751644] 1048048 pages RAM
[54668.751646] 57533 pages reserved
[54668.751647] 31551 pages shared
[54668.751648] 940145 pages non-shared
[54668.751650] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54668.751657] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54668.751660] [  207]     0   207    71438     4451   3       0             0 systemd-journal
[54668.751665] [  331]     0   331     1056       45   1       0             0 acpid
[54668.751667] [  332]     0   332     3303      190   3       0             0 crond
[54668.751670] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54668.751672] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54668.751674] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54668.751677] [  349]     0   349    15747      115   3       0             0 login
[54668.751679] [  356]     0   356     2031       30   0       0             0 agetty
[54668.751681] [  357]     0   357     2031       30   2       0             0 agetty
[54668.751684] [  358]     0   358     2031       30   2       0             0 agetty
[54668.751687] [  359]     0   359     2031       32   0       0             0 agetty
[54668.751689] [  360]     0   360     2031       30   0       0             0 agetty
[54668.751692] [  418]     0   418     3092       63   3       0             0 master
[54668.751694] [  421]    73   421    16374      262   1       0             0 qmgr
[54668.751697] [  433]  1000   433     3423      101   3       0             0 restart-x
[54668.751699] [  444]  1000   444     3423      109   2       0             0 startx
[54668.751702] [  461]  1000   461     3966       36   3       0             0 xinit
[54668.751705] [  462]  1000   462    57250     3023   2       0             0 X
[54668.751707] [  483]  1000   483    13495      393   1       0             0 i3
[54668.751709] [  490]  1000   490     6062       72   0       0             0 unclutter
[54668.751711] [  493]  1000   493     6004       58   1       0             0 dispad
[54668.751713] [  494]  1000   494    31745     6809   1       0             0 urxvtd
[54668.751715] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54668.751717] [  508]  1000   508     8156      420   2       0             0 zsh
[54668.751720] [  515]     0   515     8482       80   0       0             0 sudo
[54668.751723] [  516]     0   516     6933      235   0       0             0 zsh
[54668.751725] [  530]     0   530     7404      156   2       0             0 wpa_supplicant
[54668.751728] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54668.751730] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54668.751732] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54668.751734] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54668.751736] [ 1312]  1000  1312    14878      725   3       0             0 mutt
[54668.751739] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54668.751742] [ 1339]  1000  1339    16616     2409   2       0             0 mutt
[54668.751745] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54668.751747] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54668.751750] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54668.751753] [12547]  1000 12547     8729      484   3       0             0 zsh
[54668.751756] [12784]  1000 12784     8156      421   3       0             0 zsh
[54668.751758] [24189]  1000 24189     8156      421   1       0             0 zsh
[54668.751761] [30766]  1000 30766     8156      421   0       0             0 zsh
[54668.751763] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54668.751766] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54668.751768] [ 5518]  1000  5518    90770     1575   3       0             0 kded4
[54668.751771] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[54668.751773] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54668.751774] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[54668.751776] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[54668.751778] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54668.751780] [ 8065]  1000  8065     6531      292   2       0             0 i3bar
[54668.751782] [ 8066]  1000  8066     7809      212   2       0             0 i3status
[54668.751783] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54668.751785] [ 8708]     0  8708     2776      120   1       0             0 wpa_cli
[54668.751787] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54668.751789] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54668.751790] [ 8776]     0  8776    51901      335   0       0             0 colord
[54668.751792] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54668.751794] [10002]  1000 10002     8290      403   0       0             0 vim
[54668.751796] [10733]  1000 10733     8156      421   2       0             0 zsh
[54668.751798] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54668.751800] [10749]  1000 10749     8156      421   2       0             0 zsh
[54668.751802] [10758]  1000 10758    15099      891   1       0             0 mutt
[54668.751803] [10786]  1000 10786     8970      306   0       0             0 ssh
[54668.751805] [10788]  1000 10788     8970      198   0       0             0 ssh
[54668.751807] [10790]  1000 10790     8970      256   0       0             0 ssh
[54668.751809] [15290]  1000 15290     9005      216   0       0             0 ssh
[54668.751811] [15483]     0 15483     5899      147   1       0             0 vpnc
[54668.751813] [15633]  1000 15633     8740      474   2       0             0 zsh
[54668.751814] [16517]  1000 16517     8156      421   2       0             0 zsh
[54668.751816] [16542]  1000 16542     8156      420   0       0             0 zsh
[54668.751818] [16555]  1000 16555     8267      407   0       0             0 vim
[54668.751819] [16569]  1000 16569    21607      139   1       0             0 i3lock
[54668.751822] [ 4043]    73  4043    16331      304   0       0             0 pickup
[54668.751823] [ 4573]     0  4573     3806     1680   1       0             0 atop
[54668.751826] [ 8246]     0  8246     9170      388   1       0             0 crond
[54668.751828] [ 8249]  1000  8249     2937      211   2       0             0 sh
[54668.751830] [ 8250]  1000  8250   171800    11048   2       0             0 offlineimap
[54668.751831] Out of memory: Kill process 8250 (offlineimap) score 11 or sacrifice child
[54668.751834] Killed process 8250 (offlineimap) total-vm:687200kB, anon-rss:43820kB, file-rss:372kB
[54782.873146] wpa_supplicant invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54782.873151] wpa_supplicant cpuset=/ mems_allowed=0
[54782.873155] Pid: 530, comm: wpa_supplicant Tainted: G        W    3.5.4-1-ARCH #1
[54782.873156] Call Trace:
[54782.873163]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54782.873169]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54782.873174]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54782.873179]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54782.873184]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54782.873187]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54782.873191]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54782.873195]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54782.873198]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54782.873201]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54782.873205]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54782.873209]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54782.873212]  [<ffffffff8118bbc1>] ? do_select+0x1/0x730
[54782.873216]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54782.873220]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54782.873223]  [<ffffffff8118c6d6>] ? sys_select+0xc6/0x110
[54782.873226]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54782.873228] Mem-Info:
[54782.873229] Node 0 DMA per-cpu:
[54782.873232] CPU    0: hi:    0, btch:   1 usd:   0
[54782.873234] CPU    1: hi:    0, btch:   1 usd:   0
[54782.873236] CPU    2: hi:    0, btch:   1 usd:   0
[54782.873237] CPU    3: hi:    0, btch:   1 usd:   0
[54782.873238] Node 0 DMA32 per-cpu:
[54782.873241] CPU    0: hi:  186, btch:  31 usd:   0
[54782.873243] CPU    1: hi:  186, btch:  31 usd:   0
[54782.873245] CPU    2: hi:  186, btch:  31 usd:   0
[54782.873246] CPU    3: hi:  186, btch:  31 usd:   0
[54782.873247] Node 0 Normal per-cpu:
[54782.873250] CPU    0: hi:  186, btch:  31 usd:   0
[54782.873251] CPU    1: hi:  186, btch:  31 usd:  48
[54782.873253] CPU    2: hi:  186, btch:  31 usd:   0
[54782.873255] CPU    3: hi:  186, btch:  31 usd:   0
[54782.873259] active_anon:77660 inactive_anon:16046 isolated_anon:0
[54782.873259]  active_file:114 inactive_file:101 isolated_file:0
[54782.873259]  unevictable:1683 dirty:15 writeback:0 unstable:0
[54782.873259]  free:22522 slab_reclaimable:844997 slab_unreclaimable:5763
[54782.873259]  mapped:3282 shmem:47714 pagetables:2422 bounce:0
[54782.873262] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54782.873268] lowmem_reserve[]: 0 2137 3899 3899
[54782.873271] Node 0 DMA32 free:43896kB min:36900kB low:46124kB high:55348kB active_anon:71040kB inactive_anon:2596kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:1368kB shmem:26716kB slab_reclaimable:2056972kB slab_unreclaimable:1820kB kernel_stack:168kB pagetables:2476kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1774 all_unreclaimable? yes
[54782.873278] lowmem_reserve[]: 0 0 1762 1762
[54782.873282] Node 0 Normal free:30352kB min:30416kB low:38020kB high:45624kB active_anon:239600kB inactive_anon:61588kB active_file:316kB inactive_file:400kB unevictable:5920kB isolated(anon):0kB isolated(file):128kB present:1804320kB mlocked:5920kB dirty:60kB writeback:0kB mapped:11760kB shmem:164140kB slab_reclaimable:1322952kB slab_unreclaimable:21232kB kernel_stack:1224kB pagetables:7212kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:21875 all_unreclaimable? yes
[54782.873288] lowmem_reserve[]: 0 0 0 0
[54782.873291] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54782.873299] Node 0 DMA32: 648*4kB 2131*8kB 1236*16kB 10*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43896kB
[54782.873308] Node 0 Normal: 2692*4kB 790*8kB 625*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30608kB
[54782.873316] 48830 total pagecache pages
[54782.873318] 0 pages in swap cache
[54782.873319] Swap cache stats: add 0, delete 0, find 0/0
[54782.873320] Free swap  = 0kB
[54782.873321] Total swap = 0kB
[54782.883575] 1048048 pages RAM
[54782.883577] 57533 pages reserved
[54782.883577] 31722 pages shared
[54782.883578] 940064 pages non-shared
[54782.883579] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54782.883586] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54782.883588] [  207]     0   207    71438     4452   3       0             0 systemd-journal
[54782.883591] [  331]     0   331     1056       45   1       0             0 acpid
[54782.883593] [  332]     0   332     3303      190   0       0             0 crond
[54782.883595] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54782.883597] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54782.883599] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54782.883601] [  349]     0   349    15747      115   3       0             0 login
[54782.883603] [  356]     0   356     2031       30   0       0             0 agetty
[54782.883604] [  357]     0   357     2031       30   2       0             0 agetty
[54782.883606] [  358]     0   358     2031       30   2       0             0 agetty
[54782.883608] [  359]     0   359     2031       32   0       0             0 agetty
[54782.883610] [  360]     0   360     2031       30   0       0             0 agetty
[54782.883611] [  418]     0   418     3092       59   0       0             0 master
[54782.883613] [  421]    73   421    16374      271   1       0             0 qmgr
[54782.883615] [  433]  1000   433     3423      101   3       0             0 restart-x
[54782.883617] [  444]  1000   444     3423      109   2       0             0 startx
[54782.883618] [  461]  1000   461     3966       36   3       0             0 xinit
[54782.883620] [  462]  1000   462    57250     3029   3       0             0 X
[54782.883622] [  483]  1000   483    13495      393   1       0             0 i3
[54782.883624] [  490]  1000   490     6062       79   0       0             0 unclutter
[54782.883625] [  493]  1000   493     6004       58   1       0             0 dispad
[54782.883627] [  494]  1000   494    31745     6798   3       0             0 urxvtd
[54782.883629] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54782.883630] [  508]  1000   508     8156      420   2       0             0 zsh
[54782.883632] [  515]     0   515     8482       80   0       0             0 sudo
[54782.883634] [  516]     0   516     6933      235   0       0             0 zsh
[54782.883636] [  530]     0   530     7404      161   2       0             0 wpa_supplicant
[54782.883637] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54782.883639] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54782.883641] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54782.883643] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54782.883645] [ 1312]  1000  1312    14878      725   3       0             0 mutt
[54782.883646] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54782.883648] [ 1339]  1000  1339    16616     2409   2       0             0 mutt
[54782.883650] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54782.883652] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54782.883653] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54782.883655] [12547]  1000 12547     8729      484   3       0             0 zsh
[54782.883657] [12784]  1000 12784     8156      421   3       0             0 zsh
[54782.883659] [24189]  1000 24189     8156      421   1       0             0 zsh
[54782.883660] [30766]  1000 30766     8156      421   0       0             0 zsh
[54782.883662] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54782.883664] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54782.883666] [ 5518]  1000  5518    90770     1582   2       0             0 kded4
[54782.883667] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[54782.883669] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54782.883671] [ 5534]     0  5534    46649      203   0     -13          -900 polkitd
[54782.883673] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[54782.883674] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54782.883676] [ 8065]  1000  8065     6531      304   2       0             0 i3bar
[54782.883678] [ 8066]  1000  8066     7809      226   1       0             0 i3status
[54782.883680] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54782.883681] [ 8708]     0  8708     2776      133   1       0             0 wpa_cli
[54782.883683] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54782.883685] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54782.883687] [ 8776]     0  8776    51901      335   0       0             0 colord
[54782.883688] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54782.883690] [10002]  1000 10002     8290      403   0       0             0 vim
[54782.883693] [10733]  1000 10733     8156      421   2       0             0 zsh
[54782.883694] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54782.883696] [10749]  1000 10749     8156      421   2       0             0 zsh
[54782.883698] [10758]  1000 10758    15099      891   1       0             0 mutt
[54782.883699] [10786]  1000 10786     8970      257   0       0             0 ssh
[54782.883701] [10788]  1000 10788     8970      198   0       0             0 ssh
[54782.883703] [10790]  1000 10790     8970      274   0       0             0 ssh
[54782.883705] [15290]  1000 15290     9005      227   0       0             0 ssh
[54782.883707] [15483]     0 15483     5899      154   3       0             0 vpnc
[54782.883708] [15633]  1000 15633     8740      474   2       0             0 zsh
[54782.883710] [16517]  1000 16517     8156      421   2       0             0 zsh
[54782.883712] [16542]  1000 16542     8156      420   0       0             0 zsh
[54782.883713] [16555]  1000 16555     8267      407   0       0             0 vim
[54782.883715] [16569]  1000 16569    21607      139   1       0             0 i3lock
[54782.883717] [ 4043]    73  4043    16331      270   0       0             0 pickup
[54782.883719] [ 4573]     0  4573     3806     1680   1       0             0 atop
[54782.883722] [ 8415]     0  8415     9170      388   1       0             0 crond
[54782.883724] [ 8418]  1000  8418     2937      207   1       0             0 sh
[54782.883725] [ 8420]  1000  8420   171789    11043   1       0             0 offlineimap
[54782.883727] Out of memory: Kill process 8420 (offlineimap) score 11 or sacrifice child
[54782.883730] Killed process 8420 (offlineimap) total-vm:687156kB, anon-rss:43188kB, file-rss:984kB
[54782.932195] systemd-journald[207]: Data hash table of /run/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (33019 of 44024 items, 12869632 file size, 389 bytes per hash table item), suggesting rotation.
[54782.932200] systemd-journald[207]: Journal header limits reached or header out-of-date, rotating.
[54782.932203] systemd-journald[207]: Rotating...
[54782.932294] systemd-journald[207]: Reserving 44024 entries in hash table.
[54782.933356] systemd-journald[207]: Vacuuming...
[54904.659342] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54904.659346] urxvtd cpuset=/ mems_allowed=0
[54904.659349] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[54904.659350] Call Trace:
[54904.659356]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54904.659360]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54904.659363]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54904.659368]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54904.659371]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54904.659374]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54904.659377]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54904.659380]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54904.659382]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54904.659385]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54904.659388]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54904.659391]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54904.659394]  [<ffffffff81079380>] ? lock_hrtimer_base.isra.22+0x30/0x60
[54904.659396]  [<ffffffff81079486>] ? hrtimer_try_to_cancel+0x86/0x110
[54904.659398]  [<ffffffff81079532>] ? hrtimer_cancel+0x22/0x30
[54904.659401]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54904.659404]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54904.659407]  [<ffffffff811bd101>] ? ep_poll+0x2a1/0x360
[54904.659410]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[54904.659413]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[54904.659415]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54904.659416] Mem-Info:
[54904.659417] Node 0 DMA per-cpu:
[54904.659419] CPU    0: hi:    0, btch:   1 usd:   0
[54904.659421] CPU    1: hi:    0, btch:   1 usd:   0
[54904.659422] CPU    2: hi:    0, btch:   1 usd:   0
[54904.659423] CPU    3: hi:    0, btch:   1 usd:   0
[54904.659424] Node 0 DMA32 per-cpu:
[54904.659425] CPU    0: hi:  186, btch:  31 usd:   0
[54904.659427] CPU    1: hi:  186, btch:  31 usd:   0
[54904.659428] CPU    2: hi:  186, btch:  31 usd:   0
[54904.659429] CPU    3: hi:  186, btch:  31 usd:   0
[54904.659429] Node 0 Normal per-cpu:
[54904.659431] CPU    0: hi:  186, btch:  31 usd:   0
[54904.659432] CPU    1: hi:  186, btch:  31 usd:   0
[54904.659433] CPU    2: hi:  186, btch:  31 usd:   0
[54904.659434] CPU    3: hi:  186, btch:  31 usd:   0
[54904.659438] active_anon:77719 inactive_anon:16164 isolated_anon:0
[54904.659438]  active_file:40 inactive_file:31 isolated_file:0
[54904.659438]  unevictable:1683 dirty:0 writeback:6 unstable:0
[54904.659438]  free:22517 slab_reclaimable:844989 slab_unreclaimable:5776
[54904.659438]  mapped:1103 shmem:47909 pagetables:2298 bounce:0
[54904.659440] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54904.659444] lowmem_reserve[]: 0 2137 3899 3899
[54904.659446] Node 0 DMA32 free:43892kB min:36900kB low:46124kB high:55348kB active_anon:70996kB inactive_anon:2588kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:100kB shmem:26716kB slab_reclaimable:2056972kB slab_unreclaimable:1820kB kernel_stack:176kB pagetables:2444kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:15 all_unreclaimable? yes
[54904.659451] lowmem_reserve[]: 0 0 1762 1762
[54904.659453] Node 0 Normal free:30336kB min:30416kB low:38020kB high:45624kB active_anon:239880kB inactive_anon:62068kB active_file:160kB inactive_file:120kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:24kB mapped:4312kB shmem:164920kB slab_reclaimable:1322920kB slab_unreclaimable:21284kB kernel_stack:1232kB pagetables:6748kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:995 all_unreclaimable? yes
[54904.659457] lowmem_reserve[]: 0 0 0 0
[54904.659459] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54904.659466] Node 0 DMA32: 658*4kB 2132*8kB 1236*16kB 9*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43976kB
[54904.659471] Node 0 Normal: 2799*4kB 802*8kB 597*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30684kB
[54904.659477] 48823 total pagecache pages
[54904.659478] 0 pages in swap cache
[54904.659479] Swap cache stats: add 0, delete 0, find 0/0
[54904.659480] Free swap  = 0kB
[54904.659481] Total swap = 0kB
[54904.668041] 1048048 pages RAM
[54904.668043] 57533 pages reserved
[54904.668044] 27503 pages shared
[54904.668045] 942252 pages non-shared
[54904.668047] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54904.668053] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54904.668056] [  207]     0   207     8866      383   3       0             0 systemd-journal
[54904.668060] [  331]     0   331     1056       45   1       0             0 acpid
[54904.668062] [  332]     0   332     3303      190   0       0             0 crond
[54904.668065] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54904.668068] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54904.668071] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54904.668074] [  349]     0   349    15747      115   3       0             0 login
[54904.668076] [  356]     0   356     2031       30   0       0             0 agetty
[54904.668078] [  357]     0   357     2031       30   2       0             0 agetty
[54904.668081] [  358]     0   358     2031       30   2       0             0 agetty
[54904.668083] [  359]     0   359     2031       32   0       0             0 agetty
[54904.668086] [  360]     0   360     2031       30   0       0             0 agetty
[54904.668088] [  418]     0   418     3092       65   3       0             0 master
[54904.668090] [  421]    73   421    16374      281   0       0             0 qmgr
[54904.668093] [  433]  1000   433     3423      101   3       0             0 restart-x
[54904.668095] [  444]  1000   444     3423      109   2       0             0 startx
[54904.668098] [  461]  1000   461     3966       36   3       0             0 xinit
[54904.668100] [  462]  1000   462    57250     3019   3       0             0 X
[54904.668103] [  483]  1000   483    13495      393   1       0             0 i3
[54904.668105] [  490]  1000   490     6062       72   0       0             0 unclutter
[54904.668107] [  493]  1000   493     6004       60   1       0             0 dispad
[54904.668109] [  494]  1000   494    31745     6807   1       0             0 urxvtd
[54904.668112] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54904.668114] [  508]  1000   508     8156      420   2       0             0 zsh
[54904.668116] [  515]     0   515     8482       80   0       0             0 sudo
[54904.668119] [  516]     0   516     6933      235   0       0             0 zsh
[54904.668121] [  530]     0   530     7404      167   1       0             0 wpa_supplicant
[54904.668124] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54904.668126] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54904.668128] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54904.668130] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54904.668133] [ 1312]  1000  1312    14878      725   3       0             0 mutt
[54904.668135] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54904.668137] [ 1339]  1000  1339    16616     2409   2       0             0 mutt
[54904.668140] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54904.668142] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54904.668145] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54904.668147] [12547]  1000 12547     8729      484   3       0             0 zsh
[54904.668149] [12784]  1000 12784     8156      421   3       0             0 zsh
[54904.668152] [24189]  1000 24189     8156      421   1       0             0 zsh
[54904.668154] [30766]  1000 30766     8156      421   0       0             0 zsh
[54904.668156] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54904.668159] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54904.668161] [ 5518]  1000  5518    90770     1560   1       0             0 kded4
[54904.668164] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[54904.668167] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54904.668169] [ 5534]     0  5534    46649      205   2     -13          -900 polkitd
[54904.668172] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[54904.668174] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54904.668176] [ 8065]  1000  8065     6531      320   3       0             0 i3bar
[54904.668179] [ 8066]  1000  8066     7809      189   1       0             0 i3status
[54904.668181] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54904.668183] [ 8708]     0  8708     2776      120   0       0             0 wpa_cli
[54904.668186] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54904.668188] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54904.668190] [ 8776]     0  8776    51901      335   0       0             0 colord
[54904.668192] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54904.668195] [10002]  1000 10002     8290      403   0       0             0 vim
[54904.668198] [10733]  1000 10733     8156      421   2       0             0 zsh
[54904.668200] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54904.668202] [10749]  1000 10749     8156      421   2       0             0 zsh
[54904.668205] [10758]  1000 10758    15099      891   1       0             0 mutt
[54904.668207] [10786]  1000 10786     8970      272   0       0             0 ssh
[54904.668209] [10788]  1000 10788     8970      198   0       0             0 ssh
[54904.668212] [10790]  1000 10790     8970      292   0       0             0 ssh
[54904.668215] [15290]  1000 15290     9005      216   1       0             0 ssh
[54904.668217] [15483]     0 15483     5899      121   3       0             0 vpnc
[54904.668220] [15633]  1000 15633     8740      474   2       0             0 zsh
[54904.668222] [16517]  1000 16517     8156      421   2       0             0 zsh
[54904.668224] [16542]  1000 16542     8156      420   0       0             0 zsh
[54904.668226] [16555]  1000 16555     8267      407   0       0             0 vim
[54904.668229] [16569]  1000 16569    21607      139   1       0             0 i3lock
[54904.668231] [ 4043]    73  4043    16331      296   2       0             0 pickup
[54904.668234] [ 4573]     0  4573     3806     1680   1       0             0 atop
[54904.668237] [ 8586]     0  8586     9170      388   0       0             0 crond
[54904.668239] [ 8588]  1000  8588     2937      211   1       0             0 sh
[54904.668242] [ 8590]  1000  8590   171790    10937   0       0             0 offlineimap
[54904.668244] Out of memory: Kill process 8590 (offlineimap) score 11 or sacrifice child
[54904.668247] Killed process 8590 (offlineimap) total-vm:687160kB, anon-rss:42988kB, file-rss:760kB
[54904.669503] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[54904.669506] urxvtd cpuset=/ mems_allowed=0
[54904.669509] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[54904.669510] Call Trace:
[54904.669517]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[54904.669522]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[54904.669526]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[54904.669531]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[54904.669536]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[54904.669539]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[54904.669543]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[54904.669547]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[54904.669550]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[54904.669553]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[54904.669557]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[54904.669560]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[54904.669564]  [<ffffffff81079380>] ? lock_hrtimer_base.isra.22+0x30/0x60
[54904.669567]  [<ffffffff81079486>] ? hrtimer_try_to_cancel+0x86/0x110
[54904.669570]  [<ffffffff81079532>] ? hrtimer_cancel+0x22/0x30
[54904.669573]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[54904.669577]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[54904.669581]  [<ffffffff811bd101>] ? ep_poll+0x2a1/0x360
[54904.669585]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[54904.669589]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[54904.669592]  [<ffffffff8147e765>] page_fault+0x25/0x30
[54904.669593] Mem-Info:
[54904.669594] Node 0 DMA per-cpu:
[54904.669597] CPU    0: hi:    0, btch:   1 usd:   0
[54904.669599] CPU    1: hi:    0, btch:   1 usd:   0
[54904.669600] CPU    2: hi:    0, btch:   1 usd:   0
[54904.669602] CPU    3: hi:    0, btch:   1 usd:   0
[54904.669603] Node 0 DMA32 per-cpu:
[54904.669605] CPU    0: hi:  186, btch:  31 usd:   0
[54904.669607] CPU    1: hi:  186, btch:  31 usd:   0
[54904.669608] CPU    2: hi:  186, btch:  31 usd:   0
[54904.669610] CPU    3: hi:  186, btch:  31 usd:   0
[54904.669611] Node 0 Normal per-cpu:
[54904.669613] CPU    0: hi:  186, btch:  31 usd:  35
[54904.669615] CPU    1: hi:  186, btch:  31 usd:   0
[54904.669616] CPU    2: hi:  186, btch:  31 usd:   5
[54904.669618] CPU    3: hi:  186, btch:  31 usd:   0
[54904.669622] active_anon:77719 inactive_anon:16164 isolated_anon:0
[54904.669622]  active_file:40 inactive_file:134 isolated_file:0
[54904.669622]  unevictable:1683 dirty:0 writeback:6 unstable:0
[54904.669622]  free:22517 slab_reclaimable:844989 slab_unreclaimable:5776
[54904.669622]  mapped:1149 shmem:47909 pagetables:2298 bounce:0
[54904.669625] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[54904.669631] lowmem_reserve[]: 0 2137 3899 3899
[54904.669635] Node 0 DMA32 free:43892kB min:36900kB low:46124kB high:55348kB active_anon:70996kB inactive_anon:2588kB active_file:0kB inactive_file:4kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:100kB shmem:26716kB slab_reclaimable:2056972kB slab_unreclaimable:1820kB kernel_stack:176kB pagetables:2444kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1023 all_unreclaimable? yes
[54904.669640] lowmem_reserve[]: 0 0 1762 1762
[54904.669643] Node 0 Normal free:30336kB min:30416kB low:38020kB high:45624kB active_anon:239880kB inactive_anon:62068kB active_file:160kB inactive_file:532kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:24kB mapped:4496kB shmem:164920kB slab_reclaimable:1322920kB slab_unreclaimable:21284kB kernel_stack:1232kB pagetables:6748kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:17123 all_unreclaimable? yes
[54904.669649] lowmem_reserve[]: 0 0 0 0
[54904.669653] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[54904.669662] Node 0 DMA32: 658*4kB 2132*8kB 1236*16kB 9*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43976kB
[54904.669671] Node 0 Normal: 2799*4kB 802*8kB 597*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30684kB
[54904.669679] 48961 total pagecache pages
[54904.669681] 0 pages in swap cache
[54904.669682] Swap cache stats: add 0, delete 0, find 0/0
[54904.669683] Free swap  = 0kB
[54904.669684] Total swap = 0kB
[54904.678225] 1048048 pages RAM
[54904.678228] 57533 pages reserved
[54904.678229] 27513 pages shared
[54904.678229] 942107 pages non-shared
[54904.678231] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[54904.678236] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[54904.678238] [  207]     0   207     8866      383   0       0             0 systemd-journal
[54904.678241] [  331]     0   331     1056       45   1       0             0 acpid
[54904.678242] [  332]     0   332     3303      190   0       0             0 crond
[54904.678244] [  334]     0   334    10502      140   1     -17         -1000 sshd
[54904.678246] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[54904.678248] [  341]     0   341     6512       70   1       0             0 systemd-logind
[54904.678250] [  349]     0   349    15747      115   3       0             0 login
[54904.678251] [  356]     0   356     2031       30   0       0             0 agetty
[54904.678253] [  357]     0   357     2031       30   2       0             0 agetty
[54904.678255] [  358]     0   358     2031       30   2       0             0 agetty
[54904.678257] [  359]     0   359     2031       32   0       0             0 agetty
[54904.678258] [  360]     0   360     2031       30   0       0             0 agetty
[54904.678260] [  418]     0   418     3092       65   3       0             0 master
[54904.678262] [  421]    73   421    16374      281   0       0             0 qmgr
[54904.678264] [  433]  1000   433     3423      101   3       0             0 restart-x
[54904.678265] [  444]  1000   444     3423      109   2       0             0 startx
[54904.678267] [  461]  1000   461     3966       36   3       0             0 xinit
[54904.678269] [  462]  1000   462    57250     3019   1       0             0 X
[54904.678271] [  483]  1000   483    13495      393   1       0             0 i3
[54904.678272] [  490]  1000   490     6062       72   0       0             0 unclutter
[54904.678274] [  493]  1000   493     6004       60   1       0             0 dispad
[54904.678276] [  494]  1000   494    31745     6807   3       0             0 urxvtd
[54904.678277] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[54904.678279] [  508]  1000   508     8156      420   2       0             0 zsh
[54904.678281] [  515]     0   515     8482       80   0       0             0 sudo
[54904.678283] [  516]     0   516     6933      235   0       0             0 zsh
[54904.678284] [  530]     0   530     7404      167   1       0             0 wpa_supplicant
[54904.678286] [  585]     0   585     2136       38   0       0             0 dhcpcd
[54904.678288] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[54904.678290] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[54904.678291] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[54904.678293] [ 1312]  1000  1312    14878      725   3       0             0 mutt
[54904.678295] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[54904.678297] [ 1339]  1000  1339    16616     2409   2       0             0 mutt
[54904.678299] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[54904.678300] [ 1359]     0  1359     8481       78   3       0             0 sudo
[54904.678302] [ 1360]     0  1360     6933      237   3       0             0 zsh
[54904.678304] [12547]  1000 12547     8729      484   3       0             0 zsh
[54904.678306] [12784]  1000 12784     8156      421   3       0             0 zsh
[54904.678307] [24189]  1000 24189     8156      421   1       0             0 zsh
[54904.678309] [30766]  1000 30766     8156      421   0       0             0 zsh
[54904.678311] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[54904.678313] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[54904.678314] [ 5518]  1000  5518    90770     1560   1       0             0 kded4
[54904.678316] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[54904.678318] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[54904.678320] [ 5534]     0  5534    46649      205   0     -13          -900 polkitd
[54904.678321] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[54904.678323] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[54904.678325] [ 8065]  1000  8065     6531      320   3       0             0 i3bar
[54904.678327] [ 8066]  1000  8066     7809      189   1       0             0 i3status
[54904.678328] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[54904.678330] [ 8708]     0  8708     2776      120   0       0             0 wpa_cli
[54904.678332] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[54904.678333] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[54904.678335] [ 8776]     0  8776    51901      335   0       0             0 colord
[54904.678337] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[54904.678339] [10002]  1000 10002     8290      403   0       0             0 vim
[54904.678341] [10733]  1000 10733     8156      421   2       0             0 zsh
[54904.678343] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[54904.678344] [10749]  1000 10749     8156      421   2       0             0 zsh
[54904.678346] [10758]  1000 10758    15099      891   1       0             0 mutt
[54904.678348] [10786]  1000 10786     8970      272   0       0             0 ssh
[54904.678350] [10788]  1000 10788     8970      198   0       0             0 ssh
[54904.678351] [10790]  1000 10790     8970      292   0       0             0 ssh
[54904.678353] [15290]  1000 15290     9005      216   1       0             0 ssh
[54904.678355] [15483]     0 15483     5899      121   3       0             0 vpnc
[54904.678357] [15633]  1000 15633     8740      474   2       0             0 zsh
[54904.678359] [16517]  1000 16517     8156      421   2       0             0 zsh
[54904.678361] [16542]  1000 16542     8156      420   0       0             0 zsh
[54904.678362] [16555]  1000 16555     8267      407   0       0             0 vim
[54904.678372] [16569]  1000 16569    21607      139   1       0             0 i3lock
[54904.678374] [ 4043]    73  4043    16331      296   2       0             0 pickup
[54904.678375] [ 4573]     0  4573     3806     1680   1       0             0 atop
[54904.678378] [ 8586]     0  8586     9170      388   0       0             0 crond
[54904.678380] [ 8588]  1000  8588     2937      211   1       0             0 sh
[54904.678381] [ 8746]  1000  8590   171790    11028   0       0             0 offlineimap
[54904.678383] Out of memory: Kill process 8746 (offlineimap) score 11 or sacrifice child
[54904.678385] Killed process 8746 (offlineimap) total-vm:687160kB, anon-rss:43036kB, file-rss:1076kB
[55020.895791] kded4 invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[55020.895796] kded4 cpuset=/ mems_allowed=0
[55020.895799] Pid: 5518, comm: kded4 Tainted: G        W    3.5.4-1-ARCH #1
[55020.895801] Call Trace:
[55020.895808]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[55020.895813]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[55020.895818]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[55020.895824]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[55020.895828]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[55020.895833]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[55020.895837]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[55020.895842]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[55020.895845]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[55020.895849]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[55020.895853]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[55020.895856]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[55020.895860]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55020.895863]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55020.895867]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[55020.895870]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55020.895875]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[55020.895878]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55020.895881]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[55020.895884]  [<ffffffff8147e765>] page_fault+0x25/0x30
[55020.895886] Mem-Info:
[55020.895888] Node 0 DMA per-cpu:
[55020.895891] CPU    0: hi:    0, btch:   1 usd:   0
[55020.895893] CPU    1: hi:    0, btch:   1 usd:   0
[55020.895895] CPU    2: hi:    0, btch:   1 usd:   0
[55020.895896] CPU    3: hi:    0, btch:   1 usd:   0
[55020.895898] Node 0 DMA32 per-cpu:
[55020.895900] CPU    0: hi:  186, btch:  31 usd:   0
[55020.895902] CPU    1: hi:  186, btch:  31 usd:   0
[55020.895904] CPU    2: hi:  186, btch:  31 usd:   0
[55020.895906] CPU    3: hi:  186, btch:  31 usd:   0
[55020.895907] Node 0 Normal per-cpu:
[55020.895910] CPU    0: hi:  186, btch:  31 usd:   0
[55020.895911] CPU    1: hi:  186, btch:  31 usd: 180
[55020.895914] CPU    2: hi:  186, btch:  31 usd:   0
[55020.895916] CPU    3: hi:  186, btch:  31 usd:  30
[55020.895921] active_anon:77548 inactive_anon:16197 isolated_anon:0
[55020.895921]  active_file:32 inactive_file:100 isolated_file:0
[55020.895921]  unevictable:1683 dirty:0 writeback:0 unstable:0
[55020.895921]  free:22573 slab_reclaimable:844981 slab_unreclaimable:5762
[55020.895921]  mapped:1161 shmem:47942 pagetables:2309 bounce:0
[55020.895924] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[55020.895928] lowmem_reserve[]: 0 2137 3899 3899
[55020.895931] Node 0 DMA32 free:43896kB min:36900kB low:46124kB high:55348kB active_anon:70720kB inactive_anon:2588kB active_file:4kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:100kB shmem:26716kB slab_reclaimable:2056972kB slab_unreclaimable:1816kB kernel_stack:176kB pagetables:2444kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:383 all_unreclaimable? yes
[55020.895936] lowmem_reserve[]: 0 0 1762 1762
[55020.895938] Node 0 Normal free:30556kB min:30416kB low:38020kB high:45624kB active_anon:239472kB inactive_anon:62200kB active_file:124kB inactive_file:436kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:4544kB shmem:165052kB slab_reclaimable:1322888kB slab_unreclaimable:21232kB kernel_stack:1232kB pagetables:6792kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[55020.895942] lowmem_reserve[]: 0 0 0 0
[55020.895944] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[55020.895950] Node 0 DMA32: 653*4kB 2135*8kB 1247*16kB 8*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43996kB
[55020.895956] Node 0 Normal: 2802*4kB 804*8kB 592*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30632kB
[55020.895962] 49070 total pagecache pages
[55020.895963] 0 pages in swap cache
[55020.895964] Swap cache stats: add 0, delete 0, find 0/0
[55020.895965] Free swap  = 0kB
[55020.895966] Total swap = 0kB
[55020.904229] 1048048 pages RAM
[55020.904232] 57533 pages reserved
[55020.904233] 27915 pages shared
[55020.904234] 942095 pages non-shared
[55020.904235] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[55020.904242] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[55020.904245] [  207]     0   207    16012      824   1       0             0 systemd-journal
[55020.904248] [  331]     0   331     1056       45   1       0             0 acpid
[55020.904250] [  332]     0   332     3303      190   3       0             0 crond
[55020.904253] [  334]     0   334    10502      140   1     -17         -1000 sshd
[55020.904256] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[55020.904259] [  341]     0   341     6512       70   1       0             0 systemd-logind
[55020.904262] [  349]     0   349    15747      115   3       0             0 login
[55020.904265] [  356]     0   356     2031       30   0       0             0 agetty
[55020.904267] [  357]     0   357     2031       30   2       0             0 agetty
[55020.904270] [  358]     0   358     2031       30   2       0             0 agetty
[55020.904273] [  359]     0   359     2031       32   0       0             0 agetty
[55020.904275] [  360]     0   360     2031       30   0       0             0 agetty
[55020.904278] [  418]     0   418     3092       62   1       0             0 master
[55020.904281] [  421]    73   421    16374      292   1       0             0 qmgr
[55020.904284] [  433]  1000   433     3423      101   3       0             0 restart-x
[55020.904287] [  444]  1000   444     3423      109   2       0             0 startx
[55020.904290] [  461]  1000   461     3966       36   3       0             0 xinit
[55020.904292] [  462]  1000   462    57250     3026   2       0             0 X
[55020.904295] [  483]  1000   483    13495      393   0       0             0 i3
[55020.904297] [  490]  1000   490     6062       72   1       0             0 unclutter
[55020.904300] [  493]  1000   493     6004       62   3       0             0 dispad
[55020.904303] [  494]  1000   494    31745     6816   2       0             0 urxvtd
[55020.904306] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[55020.904309] [  508]  1000   508     8156      420   2       0             0 zsh
[55020.904312] [  515]     0   515     8482       80   0       0             0 sudo
[55020.904314] [  516]     0   516     6933      235   0       0             0 zsh
[55020.904317] [  530]     0   530     7404      181   1       0             0 wpa_supplicant
[55020.904320] [  585]     0   585     2136       38   0       0             0 dhcpcd
[55020.904323] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[55020.904325] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[55020.904328] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[55020.904331] [ 1312]  1000  1312    14878      725   3       0             0 mutt
[55020.904334] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[55020.904337] [ 1339]  1000  1339    16616     2409   2       0             0 mutt
[55020.904339] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[55020.904341] [ 1359]     0  1359     8481       78   3       0             0 sudo
[55020.904344] [ 1360]     0  1360     6933      237   3       0             0 zsh
[55020.904347] [12547]  1000 12547     8729      484   3       0             0 zsh
[55020.904349] [12784]  1000 12784     8156      421   3       0             0 zsh
[55020.904352] [24189]  1000 24189     8156      421   1       0             0 zsh
[55020.904354] [30766]  1000 30766     8156      421   0       0             0 zsh
[55020.904356] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[55020.904358] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[55020.904361] [ 5518]  1000  5518    90770     1560   3       0             0 kded4
[55020.904364] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[55020.904366] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[55020.904369] [ 5534]     0  5534    46649      203   3     -13          -900 polkitd
[55020.904372] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[55020.904375] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[55020.904378] [ 8065]  1000  8065     6531      302   1       0             0 i3bar
[55020.904380] [ 8066]  1000  8066     7809      224   2       0             0 i3status
[55020.904383] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[55020.904385] [ 8708]     0  8708     2776      141   2       0             0 wpa_cli
[55020.904387] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[55020.904390] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[55020.904392] [ 8776]     0  8776    51901      335   0       0             0 colord
[55020.904394] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[55020.904397] [10002]  1000 10002     8290      403   0       0             0 vim
[55020.904400] [10733]  1000 10733     8156      421   2       0             0 zsh
[55020.904402] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[55020.904405] [10749]  1000 10749     8156      421   2       0             0 zsh
[55020.904407] [10758]  1000 10758    15099      891   1       0             0 mutt
[55020.904409] [10786]  1000 10786     8970      286   0       0             0 ssh
[55020.904411] [10788]  1000 10788     8970      198   0       0             0 ssh
[55020.904414] [10790]  1000 10790     8970      244   0       0             0 ssh
[55020.904417] [15290]  1000 15290     9005      216   0       0             0 ssh
[55020.904419] [15483]     0 15483     5899      125   3       0             0 vpnc
[55020.904422] [15633]  1000 15633     8740      474   2       0             0 zsh
[55020.904425] [16517]  1000 16517     8156      421   2       0             0 zsh
[55020.904428] [16542]  1000 16542     8156      420   0       0             0 zsh
[55020.904431] [16555]  1000 16555     8267      407   0       0             0 vim
[55020.904434] [16569]  1000 16569    21607      139   1       0             0 i3lock
[55020.904437] [ 4043]    73  4043    16331      262   0       0             0 pickup
[55020.904440] [ 4573]     0  4573     3806     1680   1       0             0 atop
[55020.904443] [ 8755]     0  8755     9170      388   0       0             0 crond
[55020.904446] [ 8759]  1000  8759     2937      211   1       0             0 sh
[55020.904449] [ 8761]  1000  8761   171779    10658   0       0             0 offlineimap
[55020.904452] Out of memory: Kill process 8761 (offlineimap) score 10 or sacrifice child
[55020.904456] Killed process 8761 (offlineimap) total-vm:687116kB, anon-rss:42308kB, file-rss:324kB
[55145.684582] kded4 invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[55145.684586] kded4 cpuset=/ mems_allowed=0
[55145.684589] Pid: 5518, comm: kded4 Tainted: G        W    3.5.4-1-ARCH #1
[55145.684591] Call Trace:
[55145.684598]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[55145.684603]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[55145.684608]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[55145.684613]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[55145.684618]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[55145.684622]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[55145.684626]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[55145.684631]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[55145.684634]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[55145.684637]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[55145.684642]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[55145.684646]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[55145.684650]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55145.684653]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55145.684656]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[55145.684659]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55145.684663]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[55145.684666]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55145.684670]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[55145.684673]  [<ffffffff8147e765>] page_fault+0x25/0x30
[55145.684675] Mem-Info:
[55145.684676] Node 0 DMA per-cpu:
[55145.684679] CPU    0: hi:    0, btch:   1 usd:   0
[55145.684683] CPU    1: hi:    0, btch:   1 usd:   0
[55145.684685] CPU    2: hi:    0, btch:   1 usd:   0
[55145.684687] CPU    3: hi:    0, btch:   1 usd:   0
[55145.684688] Node 0 DMA32 per-cpu:
[55145.684691] CPU    0: hi:  186, btch:  31 usd:   0
[55145.684693] CPU    1: hi:  186, btch:  31 usd:   0
[55145.684695] CPU    2: hi:  186, btch:  31 usd:   0
[55145.684696] CPU    3: hi:  186, btch:  31 usd:   0
[55145.684698] Node 0 Normal per-cpu:
[55145.684700] CPU    0: hi:  186, btch:  31 usd:   0
[55145.684702] CPU    1: hi:  186, btch:  31 usd:  61
[55145.684704] CPU    2: hi:  186, btch:  31 usd:   0
[55145.684706] CPU    3: hi:  186, btch:  31 usd:   0
[55145.684710] active_anon:77678 inactive_anon:16219 isolated_anon:0
[55145.684710]  active_file:27 inactive_file:66 isolated_file:0
[55145.684710]  unevictable:1683 dirty:1 writeback:0 unstable:0
[55145.684710]  free:22513 slab_reclaimable:844981 slab_unreclaimable:5761
[55145.684710]  mapped:1181 shmem:47966 pagetables:2321 bounce:0
[55145.684714] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[55145.684720] lowmem_reserve[]: 0 2137 3899 3899
[55145.684724] Node 0 DMA32 free:43904kB min:36900kB low:46124kB high:55348kB active_anon:70824kB inactive_anon:2588kB active_file:4kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:4kB writeback:0kB mapped:100kB shmem:26716kB slab_reclaimable:2056972kB slab_unreclaimable:1808kB kernel_stack:176kB pagetables:2444kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:235 all_unreclaimable? yes
[55145.684731] lowmem_reserve[]: 0 0 1762 1762
[55145.684734] Node 0 Normal free:30308kB min:30416kB low:38020kB high:45624kB active_anon:239888kB inactive_anon:62288kB active_file:104kB inactive_file:264kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:4624kB shmem:165148kB slab_reclaimable:1322888kB slab_unreclaimable:21236kB kernel_stack:1224kB pagetables:6840kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1423 all_unreclaimable? yes
[55145.684741] lowmem_reserve[]: 0 0 0 0
[55145.684744] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[55145.684754] Node 0 DMA32: 657*4kB 2140*8kB 1245*16kB 12*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44148kB
[55145.684763] Node 0 Normal: 2709*4kB 749*8kB 650*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30748kB
[55145.684772] 48903 total pagecache pages
[55145.684774] 0 pages in swap cache
[55145.684776] Swap cache stats: add 0, delete 0, find 0/0
[55145.684777] Free swap  = 0kB
[55145.684778] Total swap = 0kB
[55145.695892] 1048048 pages RAM
[55145.695895] 57533 pages reserved
[55145.695896] 28234 pages shared
[55145.695897] 942060 pages non-shared
[55145.695898] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[55145.695906] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[55145.695910] [  207]     0   207    20694     1084   0       0             0 systemd-journal
[55145.695914] [  331]     0   331     1056       45   1       0             0 acpid
[55145.695916] [  332]     0   332     3303      190   3       0             0 crond
[55145.695918] [  334]     0   334    10502      140   1     -17         -1000 sshd
[55145.695921] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[55145.695923] [  341]     0   341     6512       70   1       0             0 systemd-logind
[55145.695926] [  349]     0   349    15747      115   3       0             0 login
[55145.695929] [  356]     0   356     2031       30   0       0             0 agetty
[55145.695932] [  357]     0   357     2031       30   2       0             0 agetty
[55145.695935] [  358]     0   358     2031       30   2       0             0 agetty
[55145.695937] [  359]     0   359     2031       32   0       0             0 agetty
[55145.695940] [  360]     0   360     2031       30   0       0             0 agetty
[55145.695942] [  418]     0   418     3092       68   0       0             0 master
[55145.695945] [  421]    73   421    16374      303   3       0             0 qmgr
[55145.695947] [  433]  1000   433     3423      101   3       0             0 restart-x
[55145.695950] [  444]  1000   444     3423      109   2       0             0 startx
[55145.695953] [  461]  1000   461     3966       36   3       0             0 xinit
[55145.695955] [  462]  1000   462    57250     3014   0       0             0 X
[55145.695957] [  483]  1000   483    13495      393   1       0             0 i3
[55145.695960] [  490]  1000   490     6062       72   0       0             0 unclutter
[55145.695962] [  493]  1000   493     6004       58   1       0             0 dispad
[55145.695964] [  494]  1000   494    31745     6798   2       0             0 urxvtd
[55145.695967] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[55145.695969] [  508]  1000   508     8156      420   2       0             0 zsh
[55145.695972] [  515]     0   515     8482       80   0       0             0 sudo
[55145.695974] [  516]     0   516     6933      235   0       0             0 zsh
[55145.695977] [  530]     0   530     7404      187   1       0             0 wpa_supplicant
[55145.695979] [  585]     0   585     2136       38   0       0             0 dhcpcd
[55145.695981] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[55145.695984] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[55145.695986] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[55145.695989] [ 1312]  1000  1312    14878      725   3       0             0 mutt
[55145.695991] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[55145.695994] [ 1339]  1000  1339    16616     2409   2       0             0 mutt
[55145.695997] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[55145.695999] [ 1359]     0  1359     8481       78   3       0             0 sudo
[55145.696003] [ 1360]     0  1360     6933      237   3       0             0 zsh
[55145.696005] [12547]  1000 12547     8729      484   3       0             0 zsh
[55145.696009] [12784]  1000 12784     8156      421   3       0             0 zsh
[55145.696012] [24189]  1000 24189     8156      421   1       0             0 zsh
[55145.696015] [30766]  1000 30766     8156      421   0       0             0 zsh
[55145.696018] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[55145.696020] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[55145.696023] [ 5518]  1000  5518    90770     1574   3       0             0 kded4
[55145.696026] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[55145.696028] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[55145.696031] [ 5534]     0  5534    46649      203   1     -13          -900 polkitd
[55145.696035] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[55145.696037] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[55145.696040] [ 8065]  1000  8065     6531      316   3       0             0 i3bar
[55145.696044] [ 8066]  1000  8066     7809      185   1       0             0 i3status
[55145.696047] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[55145.696050] [ 8708]     0  8708     2776      120   3       0             0 wpa_cli
[55145.696053] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[55145.696056] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[55145.696059] [ 8776]     0  8776    51901      335   0       0             0 colord
[55145.696062] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[55145.696065] [10002]  1000 10002     8290      403   0       0             0 vim
[55145.696068] [10733]  1000 10733     8156      421   2       0             0 zsh
[55145.696071] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[55145.696073] [10749]  1000 10749     8156      421   2       0             0 zsh
[55145.696076] [10758]  1000 10758    15099      891   1       0             0 mutt
[55145.696079] [10786]  1000 10786     8970      302   0       0             0 ssh
[55145.696082] [10788]  1000 10788     8970      198   0       0             0 ssh
[55145.696084] [10790]  1000 10790     8970      262   0       0             0 ssh
[55145.696087] [15290]  1000 15290     9005      216   0       0             0 ssh
[55145.696091] [15483]     0 15483     5899      159   1       0             0 vpnc
[55145.696093] [15633]  1000 15633     8740      474   2       0             0 zsh
[55145.696096] [16517]  1000 16517     8156      421   2       0             0 zsh
[55145.696099] [16542]  1000 16542     8156      420   0       0             0 zsh
[55145.696102] [16555]  1000 16555     8267      407   0       0             0 vim
[55145.696106] [16569]  1000 16569    21607      139   1       0             0 i3lock
[55145.696109] [ 4043]    73  4043    16331      289   1       0             0 pickup
[55145.696113] [ 4573]     0  4573     3806     1680   1       0             0 atop
[55145.696117] [ 8900]     0  8900     9170      388   2       0             0 crond
[55145.696120] [ 8903]  1000  8903     2937      210   2       0             0 sh
[55145.696124] [ 8905]  1000  8905   171782    10753   0       0             0 offlineimap
[55145.696126] Out of memory: Kill process 8905 (offlineimap) score 10 or sacrifice child
[55145.696130] Killed process 8905 (offlineimap) total-vm:687128kB, anon-rss:42620kB, file-rss:392kB
[55145.697462] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[55145.697466] urxvtd cpuset=/ mems_allowed=0
[55145.697469] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[55145.697470] Call Trace:
[55145.697477]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[55145.697481]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[55145.697485]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[55145.697490]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[55145.697495]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[55145.697498]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[55145.697501]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[55145.697505]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[55145.697508]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[55145.697511]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[55145.697515]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[55145.697518]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[55145.697523]  [<ffffffff81079380>] ? lock_hrtimer_base.isra.22+0x30/0x60
[55145.697526]  [<ffffffff81079486>] ? hrtimer_try_to_cancel+0x86/0x110
[55145.697528]  [<ffffffff81079532>] ? hrtimer_cancel+0x22/0x30
[55145.697531]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[55145.697536]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[55145.697540]  [<ffffffff811bd101>] ? ep_poll+0x2a1/0x360
[55145.697543]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[55145.697546]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[55145.697549]  [<ffffffff8147e765>] page_fault+0x25/0x30
[55145.697551] Mem-Info:
[55145.697552] Node 0 DMA per-cpu:
[55145.697555] CPU    0: hi:    0, btch:   1 usd:   0
[55145.697557] CPU    1: hi:    0, btch:   1 usd:   0
[55145.697558] CPU    2: hi:    0, btch:   1 usd:   0
[55145.697560] CPU    3: hi:    0, btch:   1 usd:   0
[55145.697561] Node 0 DMA32 per-cpu:
[55145.697563] CPU    0: hi:  186, btch:  31 usd:   0
[55145.697565] CPU    1: hi:  186, btch:  31 usd:   0
[55145.697566] CPU    2: hi:  186, btch:  31 usd:   0
[55145.697568] CPU    3: hi:  186, btch:  31 usd:   0
[55145.697569] Node 0 Normal per-cpu:
[55145.697572] CPU    0: hi:  186, btch:  31 usd:  17
[55145.697573] CPU    1: hi:  186, btch:  31 usd: 157
[55145.697575] CPU    2: hi:  186, btch:  31 usd:   0
[55145.697577] CPU    3: hi:  186, btch:  31 usd:   0
[55145.697583] active_anon:77678 inactive_anon:16219 isolated_anon:0
[55145.697583]  active_file:27 inactive_file:10 isolated_file:0
[55145.697583]  unevictable:1683 dirty:1 writeback:0 unstable:0
[55145.697583]  free:22513 slab_reclaimable:844981 slab_unreclaimable:5761
[55145.697583]  mapped:1181 shmem:47966 pagetables:2321 bounce:0
[55145.697586] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[55145.697590] lowmem_reserve[]: 0 2137 3899 3899
[55145.697593] Node 0 DMA32 free:43904kB min:36900kB low:46124kB high:55348kB active_anon:70824kB inactive_anon:2588kB active_file:4kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:4kB writeback:0kB mapped:100kB shmem:26716kB slab_reclaimable:2056972kB slab_unreclaimable:1808kB kernel_stack:176kB pagetables:2444kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:719 all_unreclaimable? yes
[55145.697597] lowmem_reserve[]: 0 0 1762 1762
[55145.697600] Node 0 Normal free:30308kB min:30416kB low:38020kB high:45624kB active_anon:239888kB inactive_anon:62288kB active_file:104kB inactive_file:40kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:4624kB shmem:165148kB slab_reclaimable:1322888kB slab_unreclaimable:21236kB kernel_stack:1224kB pagetables:6840kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:9696 all_unreclaimable? yes
[55145.697604] lowmem_reserve[]: 0 0 0 0
[55145.697606] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[55145.697612] Node 0 DMA32: 657*4kB 2140*8kB 1245*16kB 12*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44148kB
[55145.697618] Node 0 Normal: 2709*4kB 749*8kB 650*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30748kB
[55145.697624] 48811 total pagecache pages
[55145.697625] 0 pages in swap cache
[55145.697627] Swap cache stats: add 0, delete 0, find 0/0
[55145.697627] Free swap  = 0kB
[55145.697628] Total swap = 0kB
[55145.709157] 1048048 pages RAM
[55145.709160] 57533 pages reserved
[55145.709161] 28235 pages shared
[55145.709162] 942178 pages non-shared
[55145.709164] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[55145.709170] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[55145.709172] [  207]     0   207    20694     1080   3       0             0 systemd-journal
[55145.709175] [  331]     0   331     1056       45   1       0             0 acpid
[55145.709177] [  332]     0   332     3303      190   3       0             0 crond
[55145.709180] [  334]     0   334    10502      140   1     -17         -1000 sshd
[55145.709183] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[55145.709185] [  341]     0   341     6512       70   1       0             0 systemd-logind
[55145.709188] [  349]     0   349    15747      115   3       0             0 login
[55145.709190] [  356]     0   356     2031       30   0       0             0 agetty
[55145.709193] [  357]     0   357     2031       30   2       0             0 agetty
[55145.709196] [  358]     0   358     2031       30   2       0             0 agetty
[55145.709198] [  359]     0   359     2031       32   0       0             0 agetty
[55145.709201] [  360]     0   360     2031       30   0       0             0 agetty
[55145.709203] [  418]     0   418     3092       68   0       0             0 master
[55145.709206] [  421]    73   421    16374      303   3       0             0 qmgr
[55145.709209] [  433]  1000   433     3423      101   3       0             0 restart-x
[55145.709211] [  444]  1000   444     3423      109   2       0             0 startx
[55145.709214] [  461]  1000   461     3966       36   3       0             0 xinit
[55145.709216] [  462]  1000   462    57250     3013   0       0             0 X
[55145.709219] [  483]  1000   483    13495      393   1       0             0 i3
[55145.709222] [  490]  1000   490     6062       72   0       0             0 unclutter
[55145.709225] [  493]  1000   493     6004       58   1       0             0 dispad
[55145.709228] [  494]  1000   494    31745     6798   2       0             0 urxvtd
[55145.709230] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[55145.709233] [  508]  1000   508     8156      420   2       0             0 zsh
[55145.709236] [  515]     0   515     8482       80   0       0             0 sudo
[55145.709239] [  516]     0   516     6933      235   0       0             0 zsh
[55145.709242] [  530]     0   530     7404      187   1       0             0 wpa_supplicant
[55145.709245] [  585]     0   585     2136       38   0       0             0 dhcpcd
[55145.709248] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[55145.709251] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[55145.709253] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[55145.709256] [ 1312]  1000  1312    14878      725   3       0             0 mutt
[55145.709259] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[55145.709262] [ 1339]  1000  1339    16616     2409   2       0             0 mutt
[55145.709265] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[55145.709268] [ 1359]     0  1359     8481       78   3       0             0 sudo
[55145.709271] [ 1360]     0  1360     6933      237   3       0             0 zsh
[55145.709274] [12547]  1000 12547     8729      484   3       0             0 zsh
[55145.709276] [12784]  1000 12784     8156      421   3       0             0 zsh
[55145.709279] [24189]  1000 24189     8156      421   1       0             0 zsh
[55145.709282] [30766]  1000 30766     8156      421   0       0             0 zsh
[55145.709284] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[55145.709287] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[55145.709290] [ 5518]  1000  5518    90770     1561   1       0             0 kded4
[55145.709293] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[55145.709295] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[55145.709298] [ 5534]     0  5534    46649      203   1     -13          -900 polkitd
[55145.709301] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[55145.709304] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[55145.709306] [ 8065]  1000  8065     6531      316   3       0             0 i3bar
[55145.709309] [ 8066]  1000  8066     7809      185   1       0             0 i3status
[55145.709312] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[55145.709314] [ 8708]     0  8708     2776      120   3       0             0 wpa_cli
[55145.709317] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[55145.709319] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[55145.709322] [ 8776]     0  8776    51901      335   0       0             0 colord
[55145.709325] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[55145.709327] [10002]  1000 10002     8290      403   0       0             0 vim
[55145.709331] [10733]  1000 10733     8156      421   2       0             0 zsh
[55145.709344] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[55145.709351] [10749]  1000 10749     8156      421   2       0             0 zsh
[55145.709358] [10758]  1000 10758    15099      891   1       0             0 mutt
[55145.709365] [10786]  1000 10786     8970      302   0       0             0 ssh
[55145.709372] [10788]  1000 10788     8970      198   0       0             0 ssh
[55145.709379] [10790]  1000 10790     8970      262   0       0             0 ssh
[55145.709387] [15290]  1000 15290     9005      216   0       0             0 ssh
[55145.709395] [15483]     0 15483     5899      159   1       0             0 vpnc
[55145.709401] [15633]  1000 15633     8740      474   2       0             0 zsh
[55145.709408] [16517]  1000 16517     8156      421   2       0             0 zsh
[55145.709415] [16542]  1000 16542     8156      420   0       0             0 zsh
[55145.709422] [16555]  1000 16555     8267      407   0       0             0 vim
[55145.709429] [16569]  1000 16569    21607      139   1       0             0 i3lock
[55145.709437] [ 4043]    73  4043    16331      289   1       0             0 pickup
[55145.709445] [ 4573]     0  4573     3806     1680   1       0             0 atop
[55145.709453] [ 8900]     0  8900     9170      388   2       0             0 crond
[55145.709460] [ 8903]  1000  8903     2937      210   2       0             0 sh
[55145.709467] [ 8939]  1000  8905   171782    10986   2       0             0 offlineimap
[55145.709474] Out of memory: Kill process 8939 (offlineimap) score 11 or sacrifice child
[55145.709481] Killed process 8939 (offlineimap) total-vm:687128kB, anon-rss:42864kB, file-rss:1080kB
[55357.579932] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[55357.579936] urxvtd cpuset=/ mems_allowed=0
[55357.579939] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[55357.579941] Call Trace:
[55357.579947]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[55357.579952]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[55357.579957]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[55357.579962]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[55357.579966]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[55357.579970]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[55357.579974]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[55357.579978]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[55357.579982]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[55357.579985]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[55357.579989]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[55357.579992]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[55357.579996]  [<ffffffff81079380>] ? lock_hrtimer_base.isra.22+0x30/0x60
[55357.579999]  [<ffffffff81079486>] ? hrtimer_try_to_cancel+0x86/0x110
[55357.580002]  [<ffffffff81079532>] ? hrtimer_cancel+0x22/0x30
[55357.580005]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[55357.580009]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[55357.580013]  [<ffffffff811bd101>] ? ep_poll+0x2a1/0x360
[55357.580017]  [<ffffffff81086f70>] ? try_to_wake_up+0x2f0/0x2f0
[55357.580020]  [<ffffffff8147e765>] page_fault+0x25/0x30
[55357.580022] Mem-Info:
[55357.580023] Node 0 DMA per-cpu:
[55357.580026] CPU    0: hi:    0, btch:   1 usd:   0
[55357.580027] CPU    1: hi:    0, btch:   1 usd:   0
[55357.580029] CPU    2: hi:    0, btch:   1 usd:   0
[55357.580030] CPU    3: hi:    0, btch:   1 usd:   0
[55357.580032] Node 0 DMA32 per-cpu:
[55357.580034] CPU    0: hi:  186, btch:  31 usd:   1
[55357.580036] CPU    1: hi:  186, btch:  31 usd:   0
[55357.580038] CPU    2: hi:  186, btch:  31 usd:   0
[55357.580040] CPU    3: hi:  186, btch:  31 usd:   0
[55357.580041] Node 0 Normal per-cpu:
[55357.580044] CPU    0: hi:  186, btch:  31 usd:  10
[55357.580045] CPU    1: hi:  186, btch:  31 usd:   4
[55357.580047] CPU    2: hi:  186, btch:  31 usd:  60
[55357.580048] CPU    3: hi:  186, btch:  31 usd:  58
[55357.580052] active_anon:77517 inactive_anon:16219 isolated_anon:0
[55357.580052]  active_file:41 inactive_file:30 isolated_file:36
[55357.580052]  unevictable:1683 dirty:0 writeback:11 unstable:0
[55357.580052]  free:22533 slab_reclaimable:845025 slab_unreclaimable:5779
[55357.580052]  mapped:1178 shmem:47995 pagetables:2414 bounce:0
[55357.580055] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[55357.580060] lowmem_reserve[]: 0 2137 3899 3899
[55357.580064] Node 0 DMA32 free:43928kB min:36900kB low:46124kB high:55348kB active_anon:70672kB inactive_anon:2588kB active_file:0kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:8kB mapped:104kB shmem:26716kB slab_reclaimable:2057084kB slab_unreclaimable:1820kB kernel_stack:176kB pagetables:2492kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:58753 all_unreclaimable? yes
[55357.580070] lowmem_reserve[]: 0 0 1762 1762
[55357.580074] Node 0 Normal free:30364kB min:30416kB low:38020kB high:45624kB active_anon:239396kB inactive_anon:62288kB active_file:176kB inactive_file:124kB unevictable:5920kB isolated(anon):0kB isolated(file):144kB present:1804320kB mlocked:5920kB dirty:0kB writeback:36kB mapped:4608kB shmem:165264kB slab_reclaimable:1322952kB slab_unreclaimable:21296kB kernel_stack:1304kB pagetables:7164kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:167590 all_unreclaimable? yes
[55357.580079] lowmem_reserve[]: 0 0 0 0
[55357.580082] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[55357.580091] Node 0 DMA32: 644*4kB 2142*8kB 1236*16kB 12*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44096kB
[55357.580100] Node 0 Normal: 2801*4kB 800*8kB 591*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30580kB
[55357.580109] 48884 total pagecache pages
[55357.580110] 0 pages in swap cache
[55357.580111] Swap cache stats: add 0, delete 0, find 0/0
[55357.580112] Free swap  = 0kB
[55357.580114] Total swap = 0kB
[55357.591955] 1048048 pages RAM
[55357.591957] 57533 pages reserved
[55357.591959] 29250 pages shared
[55357.591960] 942060 pages non-shared
[55357.591962] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[55357.591968] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[55357.591970] [  207]     0   207    22550     1395   3       0             0 systemd-journal
[55357.591974] [  331]     0   331     1056       45   1       0             0 acpid
[55357.591976] [  332]     0   332     3303      188   3       0             0 crond
[55357.591979] [  334]     0   334    10502      140   1     -17         -1000 sshd
[55357.591981] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[55357.591984] [  341]     0   341     6512       70   1       0             0 systemd-logind
[55357.591986] [  349]     0   349    15747      115   3       0             0 login
[55357.591988] [  356]     0   356     2031       30   0       0             0 agetty
[55357.591990] [  357]     0   357     2031       30   2       0             0 agetty
[55357.591993] [  358]     0   358     2031       30   2       0             0 agetty
[55357.591995] [  359]     0   359     2031       32   0       0             0 agetty
[55357.591997] [  360]     0   360     2031       30   0       0             0 agetty
[55357.591999] [  418]     0   418     3092       74   0       0             0 master
[55357.592002] [  421]    73   421    16374      252   1       0             0 qmgr
[55357.592004] [  433]  1000   433     3423      101   3       0             0 restart-x
[55357.592006] [  444]  1000   444     3423      109   2       0             0 startx
[55357.592009] [  461]  1000   461     3966       36   3       0             0 xinit
[55357.592011] [  462]  1000   462    57250     3017   0       0             0 X
[55357.592013] [  483]  1000   483    13495      393   0       0             0 i3
[55357.592016] [  490]  1000   490     6062       87   1       0             0 unclutter
[55357.592018] [  493]  1000   493     6004       58   1       0             0 dispad
[55357.592020] [  494]  1000   494    31745     6798   1       0             0 urxvtd
[55357.592022] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[55357.592025] [  508]  1000   508     8156      420   2       0             0 zsh
[55357.592027] [  515]     0   515     8482       80   0       0             0 sudo
[55357.592029] [  516]     0   516     6933      235   0       0             0 zsh
[55357.592031] [  530]     0   530     7404      172   1       0             0 wpa_supplicant
[55357.592034] [  585]     0   585     2136       38   0       0             0 dhcpcd
[55357.592036] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[55357.592038] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[55357.592040] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[55357.592043] [ 1312]  1000  1312    14878      706   1       0             0 mutt
[55357.592045] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[55357.592047] [ 1339]  1000  1339    16616     2409   2       0             0 mutt
[55357.592050] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[55357.592052] [ 1359]     0  1359     8481       78   3       0             0 sudo
[55357.592054] [ 1360]     0  1360     6933      237   3       0             0 zsh
[55357.592056] [12547]  1000 12547     8729      484   3       0             0 zsh
[55357.592059] [12784]  1000 12784     8156      421   3       0             0 zsh
[55357.592061] [24189]  1000 24189     8156      421   1       0             0 zsh
[55357.592063] [30766]  1000 30766     8156      421   0       0             0 zsh
[55357.592066] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[55357.592068] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[55357.592070] [ 5518]  1000  5518    90770     1563   1       0             0 kded4
[55357.592072] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[55357.592075] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[55357.592077] [ 5534]     0  5534    46649      203   3     -13          -900 polkitd
[55357.592079] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[55357.592082] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[55357.592084] [ 8065]  1000  8065     6531      298   1       0             0 i3bar
[55357.592086] [ 8066]  1000  8066     7809      217   1       0             0 i3status
[55357.592088] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[55357.592091] [ 8708]     0  8708     2776      120   2       0             0 wpa_cli
[55357.592093] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[55357.592095] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[55357.592097] [ 8776]     0  8776    51901      335   0       0             0 colord
[55357.592099] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[55357.592102] [10002]  1000 10002     8290      403   0       0             0 vim
[55357.592105] [10733]  1000 10733     8156      421   2       0             0 zsh
[55357.592107] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[55357.592109] [10749]  1000 10749     8156      421   2       0             0 zsh
[55357.592111] [10758]  1000 10758    15099      885   1       0             0 mutt
[55357.592114] [10786]  1000 10786     8970      302   1       0             0 ssh
[55357.592116] [10788]  1000 10788     8970      198   0       0             0 ssh
[55357.592118] [10790]  1000 10790     8970      264   1       0             0 ssh
[55357.592120] [15290]  1000 15290     9005      216   0       0             0 ssh
[55357.592123] [15483]     0 15483     5899      133   1       0             0 vpnc
[55357.592125] [15633]  1000 15633     8740      474   2       0             0 zsh
[55357.592127] [16517]  1000 16517     8156      421   2       0             0 zsh
[55357.592130] [16542]  1000 16542     8156      420   0       0             0 zsh
[55357.592132] [16555]  1000 16555     8267      407   0       0             0 vim
[55357.592134] [16569]  1000 16569    21607      139   1       0             0 i3lock
[55357.592137] [ 4043]    73  4043    16331      255   2       0             0 pickup
[55357.592139] [ 4573]     0  4573     3806     1680   1       0             0 atop
[55357.592143] [ 9076]     0  9076     9170      388   1       0             0 crond
[55357.592145] [ 9079]  1000  9079     2937      211   2       0             0 sh
[55357.592147] [ 9081]  1000  9081   155202     7777   0       0             0 offlineimap
[55357.592149] [ 9188]     0  9188     9170      388   0       0             0 crond
[55357.592152] [ 9191]  1000  9191     2937      213   1       0             0 sh
[55357.592154] [ 9193]  1000  9193   153959     2751   0       0             0 offlineimap
[55357.592156] Out of memory: Kill process 9081 (offlineimap) score 7 or sacrifice child
[55357.592159] Killed process 9081 (offlineimap) total-vm:620808kB, anon-rss:30508kB, file-rss:600kB
[55397.369183] X invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[55397.369187] X cpuset=/ mems_allowed=0
[55397.369191] Pid: 462, comm: X Tainted: G        W    3.5.4-1-ARCH #1
[55397.369192] Call Trace:
[55397.369199]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[55397.369204]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[55397.369209]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[55397.369214]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[55397.369220]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[55397.369223]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[55397.369227]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[55397.369232]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[55397.369235]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[55397.369238]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[55397.369243]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[55397.369246]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[55397.369250]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55397.369254]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[55397.369259]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[55397.369264]  [<ffffffff812056e4>] ? security_file_permission+0x94/0xb0
[55397.369269]  [<ffffffff81179168>] ? vfs_read+0x138/0x180
[55397.369273]  [<ffffffff8147e765>] page_fault+0x25/0x30
[55397.369275] Mem-Info:
[55397.369276] Node 0 DMA per-cpu:
[55397.369280] CPU    0: hi:    0, btch:   1 usd:   0
[55397.369281] CPU    1: hi:    0, btch:   1 usd:   0
[55397.369283] CPU    2: hi:    0, btch:   1 usd:   0
[55397.369285] CPU    3: hi:    0, btch:   1 usd:   0
[55397.369287] Node 0 DMA32 per-cpu:
[55397.369289] CPU    0: hi:  186, btch:  31 usd: 108
[55397.369291] CPU    1: hi:  186, btch:  31 usd:   0
[55397.369293] CPU    2: hi:  186, btch:  31 usd:   0
[55397.369294] CPU    3: hi:  186, btch:  31 usd:   0
[55397.369295] Node 0 Normal per-cpu:
[55397.369298] CPU    0: hi:  186, btch:  31 usd: 134
[55397.369299] CPU    1: hi:  186, btch:  31 usd:   0
[55397.369301] CPU    2: hi:  186, btch:  31 usd:   0
[55397.369303] CPU    3: hi:  186, btch:  31 usd:  30
[55397.369307] active_anon:77478 inactive_anon:16229 isolated_anon:0
[55397.369307]  active_file:10 inactive_file:7 isolated_file:0
[55397.369307]  unevictable:1683 dirty:0 writeback:0 unstable:0
[55397.369307]  free:22533 slab_reclaimable:845009 slab_unreclaimable:5752
[55397.369307]  mapped:1252 shmem:48018 pagetables:2422 bounce:0
[55397.369310] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[55397.369316] lowmem_reserve[]: 0 2137 3899 3899
[55397.369320] Node 0 DMA32 free:43932kB min:36900kB low:46124kB high:55348kB active_anon:70536kB inactive_anon:2588kB active_file:28kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:128kB shmem:26716kB slab_reclaimable:2057084kB slab_unreclaimable:1808kB kernel_stack:168kB pagetables:2424kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:2016 all_unreclaimable? yes
[55397.369328] lowmem_reserve[]: 0 0 1762 1762
[55397.369331] Node 0 Normal free:30360kB min:30416kB low:38020kB high:45624kB active_anon:239376kB inactive_anon:62328kB active_file:12kB inactive_file:80kB unevictable:5920kB isolated(anon):0kB isolated(file):128kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:4880kB shmem:165356kB slab_reclaimable:1322888kB slab_unreclaimable:21200kB kernel_stack:1256kB pagetables:7264kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:28991 all_unreclaimable? yes
[55397.369338] lowmem_reserve[]: 0 0 0 0
[55397.369341] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[55397.369350] Node 0 DMA32: 660*4kB 2137*8kB 1232*16kB 9*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43896kB
[55397.369363] Node 0 Normal: 2721*4kB 785*8kB 612*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30476kB
[55397.369376] 48926 total pagecache pages
[55397.369378] 0 pages in swap cache
[55397.369380] Swap cache stats: add 0, delete 0, find 0/0
[55397.369381] Free swap  = 0kB
[55397.369383] Total swap = 0kB
[55397.380791] 1048048 pages RAM
[55397.380794] 57533 pages reserved
[55397.380796] 29349 pages shared
[55397.380797] 941966 pages non-shared
[55397.380800] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[55397.380807] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[55397.380811] [  207]     0   207    23509     1631   1       0             0 systemd-journal
[55397.380815] [  331]     0   331     1056       45   1       0             0 acpid
[55397.380818] [  332]     0   332     3303      186   1       0             0 crond
[55397.380822] [  334]     0   334    10502      140   1     -17         -1000 sshd
[55397.380827] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[55397.380831] [  341]     0   341     6512       70   1       0             0 systemd-logind
[55397.380834] [  349]     0   349    15747      115   3       0             0 login
[55397.380838] [  356]     0   356     2031       30   0       0             0 agetty
[55397.380842] [  357]     0   357     2031       30   2       0             0 agetty
[55397.380846] [  358]     0   358     2031       30   2       0             0 agetty
[55397.380857] [  359]     0   359     2031       32   0       0             0 agetty
[55397.380860] [  360]     0   360     2031       30   0       0             0 agetty
[55397.380863] [  418]     0   418     3092       83   3       0             0 master
[55397.380865] [  421]    73   421    16374      261   0       0             0 qmgr
[55397.380868] [  433]  1000   433     3423      101   3       0             0 restart-x
[55397.380871] [  444]  1000   444     3423      109   2       0             0 startx
[55397.380874] [  461]  1000   461     3966       36   3       0             0 xinit
[55397.380876] [  462]  1000   462    57250     2997   3       0             0 X
[55397.380879] [  483]  1000   483    13495      393   1       0             0 i3
[55397.380882] [  490]  1000   490     6062       72   3       0             0 unclutter
[55397.380885] [  493]  1000   493     6004       58   1       0             0 dispad
[55397.380888] [  494]  1000   494    31745     6809   3       0             0 urxvtd
[55397.380891] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[55397.380893] [  508]  1000   508     8156      420   2       0             0 zsh
[55397.380896] [  515]     0   515     8482       80   0       0             0 sudo
[55397.380899] [  516]     0   516     6933      235   0       0             0 zsh
[55397.380901] [  530]     0   530     7404      179   1       0             0 wpa_supplicant
[55397.380904] [  585]     0   585     2136       38   0       0             0 dhcpcd
[55397.380907] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[55397.380910] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[55397.380913] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[55397.380916] [ 1312]  1000  1312    14878      706   1       0             0 mutt
[55397.380918] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[55397.380921] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[55397.380924] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[55397.380927] [ 1359]     0  1359     8481       78   3       0             0 sudo
[55397.380929] [ 1360]     0  1360     6933      237   3       0             0 zsh
[55397.380932] [12547]  1000 12547     8729      484   3       0             0 zsh
[55397.380935] [12784]  1000 12784     8156      421   3       0             0 zsh
[55397.380937] [24189]  1000 24189     8156      421   1       0             0 zsh
[55397.380940] [30766]  1000 30766     8156      421   0       0             0 zsh
[55397.380942] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[55397.380944] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[55397.380947] [ 5518]  1000  5518    90770     1560   3       0             0 kded4
[55397.380949] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[55397.380951] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[55397.380954] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[55397.380956] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[55397.380958] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[55397.380961] [ 8065]  1000  8065     6531      310   3       0             0 i3bar
[55397.380963] [ 8066]  1000  8066     7809      210   2       0             0 i3status
[55397.380966] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[55397.380968] [ 8708]     0  8708     2776      135   3       0             0 wpa_cli
[55397.380970] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[55397.380972] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[55397.380974] [ 8776]     0  8776    51901      335   0       0             0 colord
[55397.380975] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[55397.380977] [10002]  1000 10002     8290      403   0       0             0 vim
[55397.380980] [10733]  1000 10733     8156      421   2       0             0 zsh
[55397.380982] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[55397.380983] [10749]  1000 10749     8156      421   2       0             0 zsh
[55397.380985] [10758]  1000 10758    15099      885   1       0             0 mutt
[55397.380987] [10786]  1000 10786     8970      255   1       0             0 ssh
[55397.380988] [10788]  1000 10788     8970      198   0       0             0 ssh
[55397.380990] [10790]  1000 10790     8970      264   1       0             0 ssh
[55397.380992] [15290]  1000 15290     9005      216   0       0             0 ssh
[55397.380994] [15483]     0 15483     5899      121   1       0             0 vpnc
[55397.380996] [15633]  1000 15633     8740      474   2       0             0 zsh
[55397.380997] [16517]  1000 16517     8156      421   2       0             0 zsh
[55397.380999] [16542]  1000 16542     8156      420   0       0             0 zsh
[55397.381001] [16555]  1000 16555     8267      407   0       0             0 vim
[55397.381003] [16569]  1000 16569    21607      139   1       0             0 i3lock
[55397.381005] [ 4043]    73  4043    16331      281   2       0             0 pickup
[55397.381007] [ 4573]     0  4573     3806     1680   1       0             0 atop
[55397.381009] [ 9188]     0  9188     9170      388   0       0             0 crond
[55397.381011] [ 9191]  1000  9191     2937      213   1       0             0 sh
[55397.381013] [ 9193]  1000  9193   155591     9946   3       0             0 offlineimap
[55397.381015] [ 9210]    73  9210    16363      371   0       0             0 cleanup
[55397.381016] [ 9213]    73  9213    16332      374   2       0             0 trivial-rewrite
[55397.381018] [ 9214]     0  9214    16353      427   1       0             0 local
[55397.381020] Out of memory: Kill process 9193 (offlineimap) score 10 or sacrifice child
[55397.381023] Killed process 9193 (offlineimap) total-vm:622364kB, anon-rss:39148kB, file-rss:636kB
[55535.214996] kded4 invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[55535.215000] kded4 cpuset=/ mems_allowed=0
[55535.215003] Pid: 5518, comm: kded4 Tainted: G        W    3.5.4-1-ARCH #1
[55535.215005] Call Trace:
[55535.215011]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[55535.215016]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[55535.215020]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[55535.215025]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[55535.215029]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[55535.215032]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[55535.215036]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[55535.215040]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[55535.215042]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[55535.215045]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[55535.215049]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[55535.215052]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[55535.215055]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55535.215057]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55535.215060]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[55535.215062]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55535.215067]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[55535.215069]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55535.215072]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[55535.215075]  [<ffffffff8147e765>] page_fault+0x25/0x30
[55535.215076] Mem-Info:
[55535.215077] Node 0 DMA per-cpu:
[55535.215080] CPU    0: hi:    0, btch:   1 usd:   0
[55535.215082] CPU    1: hi:    0, btch:   1 usd:   0
[55535.215083] CPU    2: hi:    0, btch:   1 usd:   0
[55535.215084] CPU    3: hi:    0, btch:   1 usd:   0
[55535.215085] Node 0 DMA32 per-cpu:
[55535.215088] CPU    0: hi:  186, btch:  31 usd:   0
[55535.215089] CPU    1: hi:  186, btch:  31 usd:  26
[55535.215091] CPU    2: hi:  186, btch:  31 usd:   0
[55535.215092] CPU    3: hi:  186, btch:  31 usd:   0
[55535.215093] Node 0 Normal per-cpu:
[55535.215095] CPU    0: hi:  186, btch:  31 usd: 102
[55535.215097] CPU    1: hi:  186, btch:  31 usd:  64
[55535.215098] CPU    2: hi:  186, btch:  31 usd:   0
[55535.215100] CPU    3: hi:  186, btch:  31 usd:   0
[55535.215104] active_anon:77130 inactive_anon:16233 isolated_anon:0
[55535.215104]  active_file:114 inactive_file:294 isolated_file:0
[55535.215104]  unevictable:1683 dirty:1 writeback:5 unstable:0
[55535.215104]  free:22545 slab_reclaimable:845001 slab_unreclaimable:5759
[55535.215104]  mapped:1357 shmem:48045 pagetables:2377 bounce:0
[55535.215106] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[55535.215111] lowmem_reserve[]: 0 2137 3899 3899
[55535.215114] Node 0 DMA32 free:43940kB min:36900kB low:46124kB high:55348kB active_anon:70408kB inactive_anon:2588kB active_file:4kB inactive_file:132kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:4kB writeback:4kB mapped:108kB shmem:26716kB slab_reclaimable:2057084kB slab_unreclaimable:1808kB kernel_stack:192kB pagetables:2464kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:619 all_unreclaimable? yes
[55535.215120] lowmem_reserve[]: 0 0 1762 1762
[55535.215123] Node 0 Normal free:30400kB min:30416kB low:38020kB high:45624kB active_anon:238112kB inactive_anon:62344kB active_file:452kB inactive_file:1044kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:16kB mapped:5320kB shmem:165464kB slab_reclaimable:1322856kB slab_unreclaimable:21228kB kernel_stack:1240kB pagetables:7044kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:2848 all_unreclaimable? yes
[55535.215128] lowmem_reserve[]: 0 0 0 0
[55535.215131] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[55535.215138] Node 0 DMA32: 634*4kB 2142*8kB 1229*16kB 12*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43880kB
[55535.215146] Node 0 Normal: 2701*4kB 782*8kB 632*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30692kB
[55535.215153] 49430 total pagecache pages
[55535.215154] 0 pages in swap cache
[55535.215156] Swap cache stats: add 0, delete 0, find 0/0
[55535.215157] Free swap  = 0kB
[55535.215158] Total swap = 0kB
[55535.224697] 1048048 pages RAM
[55535.224700] 57533 pages reserved
[55535.224701] 29665 pages shared
[55535.224702] 941739 pages non-shared
[55535.224703] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[55535.224710] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[55535.224713] [  207]     0   207    24916     1794   0       0             0 systemd-journal
[55535.224716] [  331]     0   331     1056       45   1       0             0 acpid
[55535.224718] [  332]     0   332     3303      189   3       0             0 crond
[55535.224721] [  334]     0   334    10502      140   1     -17         -1000 sshd
[55535.224724] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[55535.224727] [  341]     0   341     6512       70   1       0             0 systemd-logind
[55535.224729] [  349]     0   349    15747      115   3       0             0 login
[55535.224732] [  356]     0   356     2031       30   0       0             0 agetty
[55535.224735] [  357]     0   357     2031       30   2       0             0 agetty
[55535.224737] [  358]     0   358     2031       30   2       0             0 agetty
[55535.224740] [  359]     0   359     2031       32   0       0             0 agetty
[55535.224742] [  360]     0   360     2031       30   0       0             0 agetty
[55535.224744] [  418]     0   418     3092       68   0       0             0 master
[55535.224747] [  421]    73   421    16374      301   2       0             0 qmgr
[55535.224749] [  433]  1000   433     3423      101   3       0             0 restart-x
[55535.224752] [  444]  1000   444     3423      109   2       0             0 startx
[55535.224755] [  461]  1000   461     3966       36   3       0             0 xinit
[55535.224758] [  462]  1000   462    57250     3022   1       0             0 X
[55535.224760] [  483]  1000   483    13495      393   1       0             0 i3
[55535.224763] [  490]  1000   490     6062       72   0       0             0 unclutter
[55535.224766] [  493]  1000   493     6004       83   3       0             0 dispad
[55535.224769] [  494]  1000   494    31745     6812   0       0             0 urxvtd
[55535.224771] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[55535.224774] [  508]  1000   508     8156      420   2       0             0 zsh
[55535.224777] [  515]     0   515     8482       80   0       0             0 sudo
[55535.224780] [  516]     0   516     6933      235   0       0             0 zsh
[55535.224783] [  530]     0   530     7404      156   3       0             0 wpa_supplicant
[55535.224785] [  585]     0   585     2136       38   0       0             0 dhcpcd
[55535.224788] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[55535.224790] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[55535.224793] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[55535.224795] [ 1312]  1000  1312    14878      706   1       0             0 mutt
[55535.224798] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[55535.224800] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[55535.224803] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[55535.224805] [ 1359]     0  1359     8481       78   3       0             0 sudo
[55535.224807] [ 1360]     0  1360     6933      237   3       0             0 zsh
[55535.224810] [12547]  1000 12547     8729      484   3       0             0 zsh
[55535.224812] [12784]  1000 12784     8156      421   3       0             0 zsh
[55535.224814] [24189]  1000 24189     8156      421   1       0             0 zsh
[55535.224816] [30766]  1000 30766     8156      421   0       0             0 zsh
[55535.224819] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[55535.224822] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[55535.224824] [ 5518]  1000  5518    90770     1611   2       0             0 kded4
[55535.224827] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[55535.224830] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[55535.224832] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[55535.224834] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[55535.224837] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[55535.224839] [ 8065]  1000  8065     6531      311   1       0             0 i3bar
[55535.224841] [ 8066]  1000  8066     7809      222   1       0             0 i3status
[55535.224844] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[55535.224847] [ 8708]     0  8708     2776      146   1       0             0 wpa_cli
[55535.224849] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[55535.224852] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[55535.224855] [ 8776]     0  8776    51901      335   0       0             0 colord
[55535.224858] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[55535.224861] [10002]  1000 10002     8290      403   0       0             0 vim
[55535.224864] [10733]  1000 10733     8156      421   2       0             0 zsh
[55535.224867] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[55535.224869] [10749]  1000 10749     8156      421   2       0             0 zsh
[55535.224871] [10758]  1000 10758    15099      885   1       0             0 mutt
[55535.224874] [10786]  1000 10786     8970      266   0       0             0 ssh
[55535.224876] [10788]  1000 10788     8970      198   0       0             0 ssh
[55535.224878] [10790]  1000 10790     8970      270   0       0             0 ssh
[55535.224880] [15290]  1000 15290     9005      216   1       0             0 ssh
[55535.224882] [15483]     0 15483     5899      135   1       0             0 vpnc
[55535.224884] [15633]  1000 15633     8740      474   2       0             0 zsh
[55535.224886] [16517]  1000 16517     8156      421   2       0             0 zsh
[55535.224888] [16542]  1000 16542     8156      420   0       0             0 zsh
[55535.224897] [16555]  1000 16555     8267      407   0       0             0 vim
[55535.224899] [16569]  1000 16569    21607      144   1       0             0 i3lock
[55535.224901] [ 4043]    73  4043    16331      298   1       0             0 pickup
[55535.224902] [ 4573]     0  4573     3806     1680   1       0             0 atop
[55535.224905] [ 9320]     0  9320     9170      388   1       0             0 crond
[55535.224906] [ 9323]  1000  9323     2937      211   2       0             0 sh
[55535.224908] [ 9325]  1000  9325   171780     9906   3       0             0 offlineimap
[55535.224909] [ 9469]     0  9469     9170      387   0       0             0 crond
[55535.224911] [ 9471]  1000  9471     2937      225   2       0             0 sh
[55535.224912] [ 9472]  1000  9472     4878      295   3       0             0 fetchmail
[55535.224914] Out of memory: Kill process 9325 (offlineimap) score 10 or sacrifice child
[55535.224917] Killed process 9325 (offlineimap) total-vm:687120kB, anon-rss:39332kB, file-rss:292kB
[55535.331785] kded4 invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[55535.331789] kded4 cpuset=/ mems_allowed=0
[55535.331791] Pid: 5518, comm: kded4 Tainted: G        W    3.5.4-1-ARCH #1
[55535.331792] Call Trace:
[55535.331798]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[55535.331803]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[55535.331806]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[55535.331811]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[55535.331815]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[55535.331817]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[55535.331820]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[55535.331824]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[55535.331826]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[55535.331828]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[55535.331832]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[55535.331834]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[55535.331837]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55535.331839]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55535.331841]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[55535.331843]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55535.331846]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[55535.331848]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[55535.331850]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[55535.331852]  [<ffffffff8147e765>] page_fault+0x25/0x30
[55535.331854] Mem-Info:
[55535.331855] Node 0 DMA per-cpu:
[55535.331857] CPU    0: hi:    0, btch:   1 usd:   0
[55535.331858] CPU    1: hi:    0, btch:   1 usd:   0
[55535.331859] CPU    2: hi:    0, btch:   1 usd:   0
[55535.331860] CPU    3: hi:    0, btch:   1 usd:   0
[55535.331861] Node 0 DMA32 per-cpu:
[55535.331863] CPU    0: hi:  186, btch:  31 usd:   0
[55535.331864] CPU    1: hi:  186, btch:  31 usd:   0
[55535.331865] CPU    2: hi:  186, btch:  31 usd:   0
[55535.331866] CPU    3: hi:  186, btch:  31 usd:   0
[55535.331867] Node 0 Normal per-cpu:
[55535.331869] CPU    0: hi:  186, btch:  31 usd:   0
[55535.331870] CPU    1: hi:  186, btch:  31 usd:  31
[55535.331871] CPU    2: hi:  186, btch:  31 usd:   0
[55535.331872] CPU    3: hi:  186, btch:  31 usd:   0
[55535.331875] active_anon:77130 inactive_anon:16233 isolated_anon:0
[55535.331875]  active_file:90 inactive_file:475 isolated_file:0
[55535.331875]  unevictable:1683 dirty:1 writeback:5 unstable:0
[55535.331875]  free:22509 slab_reclaimable:845001 slab_unreclaimable:5759
[55535.331875]  mapped:1311 shmem:48045 pagetables:2377 bounce:0
[55535.331877] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[55535.331881] lowmem_reserve[]: 0 2137 3899 3899
[55535.331884] Node 0 DMA32 free:43832kB min:36900kB low:46124kB high:55348kB active_anon:70408kB inactive_anon:2588kB active_file:4kB inactive_file:96kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:4kB writeback:4kB mapped:108kB shmem:26716kB slab_reclaimable:2057084kB slab_unreclaimable:1808kB kernel_stack:192kB pagetables:2464kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:310 all_unreclaimable? yes
[55535.331888] lowmem_reserve[]: 0 0 1762 1762
[55535.331891] Node 0 Normal free:30364kB min:30416kB low:38020kB high:45624kB active_anon:238112kB inactive_anon:62344kB active_file:356kB inactive_file:1804kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:16kB mapped:5136kB shmem:165464kB slab_reclaimable:1322856kB slab_unreclaimable:21228kB kernel_stack:1240kB pagetables:7044kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:3496 all_unreclaimable? yes
[55535.331895] lowmem_reserve[]: 0 0 0 0
[55535.331897] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[55535.331904] Node 0 DMA32: 642*4kB 2137*8kB 1239*16kB 15*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44128kB
[55535.331909] Node 0 Normal: 2700*4kB 773*8kB 635*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30664kB
[55535.331915] 49513 total pagecache pages
[55535.331916] 0 pages in swap cache
[55535.331918] Swap cache stats: add 0, delete 0, find 0/0
[55535.331918] Free swap  = 0kB
[55535.331919] Total swap = 0kB
[55535.341929] 1048048 pages RAM
[55535.341931] 57533 pages reserved
[55535.341932] 29715 pages shared
[55535.341933] 941775 pages non-shared
[55535.341935] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[55535.341942] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[55535.341945] [  207]     0   207    26018     1912   3       0             0 systemd-journal
[55535.341948] [  331]     0   331     1056       45   1       0             0 acpid
[55535.341951] [  332]     0   332     3303      189   3       0             0 crond
[55535.341955] [  334]     0   334    10502      140   1     -17         -1000 sshd
[55535.341957] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[55535.341959] [  341]     0   341     6512       70   1       0             0 systemd-logind
[55535.341961] [  349]     0   349    15747      115   3       0             0 login
[55535.341962] [  356]     0   356     2031       30   0       0             0 agetty
[55535.341964] [  357]     0   357     2031       30   2       0             0 agetty
[55535.341966] [  358]     0   358     2031       30   2       0             0 agetty
[55535.341968] [  359]     0   359     2031       32   0       0             0 agetty
[55535.341970] [  360]     0   360     2031       30   0       0             0 agetty
[55535.341971] [  418]     0   418     3092       68   0       0             0 master
[55535.341973] [  421]    73   421    16374      301   2       0             0 qmgr
[55535.341975] [  433]  1000   433     3423      101   3       0             0 restart-x
[55535.341977] [  444]  1000   444     3423      109   2       0             0 startx
[55535.341979] [  461]  1000   461     3966       36   3       0             0 xinit
[55535.341980] [  462]  1000   462    57250     2997   1       0             0 X
[55535.341982] [  483]  1000   483    13495      393   1       0             0 i3
[55535.341984] [  490]  1000   490     6062       72   0       0             0 unclutter
[55535.341985] [  493]  1000   493     6004       71   1       0             0 dispad
[55535.341987] [  494]  1000   494    31745     6810   1       0             0 urxvtd
[55535.341989] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[55535.341991] [  508]  1000   508     8156      420   2       0             0 zsh
[55535.341993] [  515]     0   515     8482       80   0       0             0 sudo
[55535.341994] [  516]     0   516     6933      235   0       0             0 zsh
[55535.341996] [  530]     0   530     7404      156   3       0             0 wpa_supplicant
[55535.341998] [  585]     0   585     2136       38   0       0             0 dhcpcd
[55535.342000] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[55535.342001] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[55535.342003] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[55535.342005] [ 1312]  1000  1312    14878      706   1       0             0 mutt
[55535.342007] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[55535.342009] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[55535.342011] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[55535.342013] [ 1359]     0  1359     8481       78   3       0             0 sudo
[55535.342014] [ 1360]     0  1360     6933      237   3       0             0 zsh
[55535.342016] [12547]  1000 12547     8729      484   3       0             0 zsh
[55535.342018] [12784]  1000 12784     8156      421   3       0             0 zsh
[55535.342020] [24189]  1000 24189     8156      421   1       0             0 zsh
[55535.342021] [30766]  1000 30766     8156      421   0       0             0 zsh
[55535.342023] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[55535.342025] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[55535.342026] [ 5518]  1000  5518    90770     1580   2       0             0 kded4
[55535.342028] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[55535.342030] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[55535.342031] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[55535.342033] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[55535.342035] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[55535.342037] [ 8065]  1000  8065     6531      311   1       0             0 i3bar
[55535.342038] [ 8066]  1000  8066     7809      222   1       0             0 i3status
[55535.342040] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[55535.342042] [ 8708]     0  8708     2776      146   1       0             0 wpa_cli
[55535.342043] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[55535.342045] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[55535.342047] [ 8776]     0  8776    51901      335   0       0             0 colord
[55535.342048] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[55535.342050] [10002]  1000 10002     8290      403   0       0             0 vim
[55535.342053] [10733]  1000 10733     8156      421   2       0             0 zsh
[55535.342054] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[55535.342056] [10749]  1000 10749     8156      421   2       0             0 zsh
[55535.342058] [10758]  1000 10758    15099      885   1       0             0 mutt
[55535.342059] [10786]  1000 10786     8970      266   0       0             0 ssh
[55535.342061] [10788]  1000 10788     8970      198   0       0             0 ssh
[55535.342063] [10790]  1000 10790     8970      270   0       0             0 ssh
[55535.342065] [15290]  1000 15290     9005      216   1       0             0 ssh
[55535.342067] [15483]     0 15483     5899      135   1       0             0 vpnc
[55535.342069] [15633]  1000 15633     8740      474   2       0             0 zsh
[55535.342071] [16517]  1000 16517     8156      421   2       0             0 zsh
[55535.342072] [16542]  1000 16542     8156      420   0       0             0 zsh
[55535.342074] [16555]  1000 16555     8267      407   0       0             0 vim
[55535.342076] [16569]  1000 16569    21607      144   1       0             0 i3lock
[55535.342078] [ 4043]    73  4043    16331      298   1       0             0 pickup
[55535.342080] [ 4573]     0  4573     3806     1680   1       0             0 atop
[55535.342082] [ 9320]     0  9320     9170      388   1       0             0 crond
[55535.342084] [ 9323]  1000  9323     2937      211   2       0             0 sh
[55535.342086] [ 9468]  1000  9325   171780    10066   2       0             0 offlineimap
[55535.342088] [ 9469]     0  9469     9170      387   0       0             0 crond
[55535.342090] [ 9471]  1000  9471     2937      225   2       0             0 sh
[55535.342091] [ 9472]  1000  9472     4878      265   3       0             0 fetchmail
[55535.342093] Out of memory: Kill process 9468 (offlineimap) score 10 or sacrifice child
[55535.342095] Killed process 9468 (offlineimap) total-vm:687120kB, anon-rss:39388kB, file-rss:876kB
[55633.768474] urxvtd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[55633.768478] urxvtd cpuset=/ mems_allowed=0
[55633.768480] Pid: 494, comm: urxvtd Tainted: G        W    3.5.4-1-ARCH #1
[55633.768481] Call Trace:
[55633.768487]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[55633.768491]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[55633.768495]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[55633.768499]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[55633.768503]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[55633.768505]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[55633.768508]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[55633.768512]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[55633.768514]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[55633.768516]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[55633.768519]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[55633.768522]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[55633.768525]  [<ffffffff81079380>] ? lock_hrtimer_base.isra.22+0x30/0x60
[55633.768527]  [<ffffffff81079486>] ? hrtimer_try_to_cancel+0x86/0x110
[55633.768530]  [<ffffffff81079532>] ? hrtimer_cancel+0x22/0x30
[55633.768532]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[55633.768535]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[55633.768538]  [<ffffffff811bd101>] ? ep_poll+0x2a1/0x360
[55633.768541]  [<ffffffff8101b9d9>] ? read_tsc+0x9/0x20
[55633.768544]  [<ffffffff810a16a0>] ? ktime_get_ts+0xb0/0xf0
[55633.768546]  [<ffffffff8147e765>] page_fault+0x25/0x30
[55633.768547] Mem-Info:
[55633.768549] Node 0 DMA per-cpu:
[55633.768551] CPU    0: hi:    0, btch:   1 usd:   0
[55633.768552] CPU    1: hi:    0, btch:   1 usd:   0
[55633.768553] CPU    2: hi:    0, btch:   1 usd:   0
[55633.768554] CPU    3: hi:    0, btch:   1 usd:   0
[55633.768555] Node 0 DMA32 per-cpu:
[55633.768557] CPU    0: hi:  186, btch:  31 usd:   0
[55633.768558] CPU    1: hi:  186, btch:  31 usd:   0
[55633.768559] CPU    2: hi:  186, btch:  31 usd:   0
[55633.768560] CPU    3: hi:  186, btch:  31 usd:   0
[55633.768561] Node 0 Normal per-cpu:
[55633.768562] CPU    0: hi:  186, btch:  31 usd:  48
[55633.768563] CPU    1: hi:  186, btch:  31 usd:  15
[55633.768565] CPU    2: hi:  186, btch:  31 usd:   0
[55633.768566] CPU    3: hi:  186, btch:  31 usd:   0
[55633.768569] active_anon:77468 inactive_anon:16241 isolated_anon:0
[55633.768569]  active_file:48 inactive_file:12 isolated_file:0
[55633.768569]  unevictable:1683 dirty:0 writeback:0 unstable:0
[55633.768569]  free:22498 slab_reclaimable:845001 slab_unreclaimable:5741
[55633.768569]  mapped:1350 shmem:48084 pagetables:2435 bounce:0
[55633.768571] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[55633.768575] lowmem_reserve[]: 0 2137 3899 3899
[55633.768578] Node 0 DMA32 free:43816kB min:36900kB low:46124kB high:55348kB active_anon:70560kB inactive_anon:2588kB active_file:104kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:384kB shmem:26716kB slab_reclaimable:2057084kB slab_unreclaimable:1808kB kernel_stack:176kB pagetables:2420kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:304 all_unreclaimable? yes
[55633.768582] lowmem_reserve[]: 0 0 1762 1762
[55633.768584] Node 0 Normal free:30336kB min:30416kB low:38020kB high:45624kB active_anon:239312kB inactive_anon:62376kB active_file:88kB inactive_file:104kB unevictable:5920kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5920kB dirty:0kB writeback:0kB mapped:5016kB shmem:165620kB slab_reclaimable:1322856kB slab_unreclaimable:21156kB kernel_stack:1256kB pagetables:7320kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:360 all_unreclaimable? yes
[55633.768588] lowmem_reserve[]: 0 0 0 0
[55633.768591] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[55633.768597] Node 0 DMA32: 666*4kB 2141*8kB 1242*16kB 11*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44112kB
[55633.768603] Node 0 Normal: 2696*4kB 832*8kB 600*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30560kB
[55633.768608] 49094 total pagecache pages
[55633.768609] 0 pages in swap cache
[55633.768611] Swap cache stats: add 0, delete 0, find 0/0
[55633.768612] Free swap  = 0kB
[55633.768612] Total swap = 0kB
[55633.776797] 1048048 pages RAM
[55633.776800] 57533 pages reserved
[55633.776801] 29767 pages shared
[55633.776802] 942048 pages non-shared
[55633.776803] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[55633.776810] [  203]     0   203     6531      246   0     -17         -1000 systemd-udevd
[55633.776813] [  207]     0   207    27234     2015   3       0             0 systemd-journal
[55633.776816] [  331]     0   331     1056       45   1       0             0 acpid
[55633.776819] [  332]     0   332     3303      189   3       0             0 crond
[55633.776821] [  334]     0   334    10502      140   1     -17         -1000 sshd
[55633.776824] [  340]    81   340     4408      135   0     -13          -900 dbus-daemon
[55633.776826] [  341]     0   341     6512       70   1       0             0 systemd-logind
[55633.776829] [  349]     0   349    15747      115   3       0             0 login
[55633.776832] [  356]     0   356     2031       30   0       0             0 agetty
[55633.776834] [  357]     0   357     2031       30   2       0             0 agetty
[55633.776837] [  358]     0   358     2031       30   2       0             0 agetty
[55633.776840] [  359]     0   359     2031       32   0       0             0 agetty
[55633.776843] [  360]     0   360     2031       30   0       0             0 agetty
[55633.776846] [  418]     0   418     3092       79   0       0             0 master
[55633.776851] [  421]    73   421    16374      250   0       0             0 qmgr
[55633.776855] [  433]  1000   433     3423      101   3       0             0 restart-x
[55633.776858] [  444]  1000   444     3423      109   2       0             0 startx
[55633.776861] [  461]  1000   461     3966       36   3       0             0 xinit
[55633.776865] [  462]  1000   462    57250     3025   2       0             0 X
[55633.776868] [  483]  1000   483    13495      393   1       0             0 i3
[55633.776872] [  490]  1000   490     6062       72   0       0             0 unclutter
[55633.776875] [  493]  1000   493     6004       58   3       0             0 dispad
[55633.776879] [  494]  1000   494    31745     6842   1       0             0 urxvtd
[55633.776882] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[55633.776885] [  508]  1000   508     8156      420   2       0             0 zsh
[55633.776887] [  515]     0   515     8482       80   0       0             0 sudo
[55633.776890] [  516]     0   516     6933      235   0       0             0 zsh
[55633.776892] [  530]     0   530     7404      172   2       0             0 wpa_supplicant
[55633.776894] [  585]     0   585     2136       38   0       0             0 dhcpcd
[55633.776897] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[55633.776899] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[55633.776902] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[55633.776905] [ 1312]  1000  1312    14878      706   1       0             0 mutt
[55633.776908] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[55633.776910] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[55633.776913] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[55633.776916] [ 1359]     0  1359     8481       78   3       0             0 sudo
[55633.776919] [ 1360]     0  1360     6933      237   3       0             0 zsh
[55633.776921] [12547]  1000 12547     8729      484   3       0             0 zsh
[55633.776924] [12784]  1000 12784     8156      421   3       0             0 zsh
[55633.776927] [24189]  1000 24189     8156      421   1       0             0 zsh
[55633.776929] [30766]  1000 30766     8156      421   0       0             0 zsh
[55633.776932] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[55633.776935] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[55633.776937] [ 5518]  1000  5518    90770     1560   2       0             0 kded4
[55633.776940] [ 5525]  1000  5525   238394     2492   3       0             0 knotify4
[55633.776942] [ 5529]     0  5529    54766      810   1       0             0 upowerd
[55633.776945] [ 5534]     0  5534    46649      203   1     -13          -900 polkitd
[55633.776948] [ 5556]     0  5556    48360      302   1       0             0 udisks-daemon
[55633.776949] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[55633.776951] [ 8065]  1000  8065     6531      293   1       0             0 i3bar
[55633.776953] [ 8066]  1000  8066     7809      205   1       0             0 i3status
[55633.776955] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[55633.776956] [ 8708]     0  8708     2776      125   1       0             0 wpa_cli
[55633.776958] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[55633.776960] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[55633.776961] [ 8776]     0  8776    51901      335   0       0             0 colord
[55633.776963] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[55633.776965] [10002]  1000 10002     8290      403   0       0             0 vim
[55633.776968] [10733]  1000 10733     8156      421   2       0             0 zsh
[55633.776969] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[55633.776971] [10749]  1000 10749     8156      421   2       0             0 zsh
[55633.776973] [10758]  1000 10758    15099      885   1       0             0 mutt
[55633.776974] [10786]  1000 10786     8970      278   1       0             0 ssh
[55633.776976] [10788]  1000 10788     8970      198   0       0             0 ssh
[55633.776978] [10790]  1000 10790     8970      288   0       0             0 ssh
[55633.776980] [15290]  1000 15290     9005      216   0       0             0 ssh
[55633.776981] [15483]     0 15483     5899      143   3       0             0 vpnc
[55633.776983] [15633]  1000 15633     8740      474   2       0             0 zsh
[55633.776985] [16517]  1000 16517     8156      421   2       0             0 zsh
[55633.776986] [16542]  1000 16542     8156      420   0       0             0 zsh
[55633.776988] [16555]  1000 16555     8267      407   0       0             0 vim
[55633.776990] [16569]  1000 16569    21607      139   1       0             0 i3lock
[55633.776992] [ 4043]    73  4043    16331      264   2       0             0 pickup
[55633.776994] [ 4573]     0  4573     3806     1680   1       0             0 atop
[55633.776997] [ 9475]    73  9475    16363      370   2       0             0 cleanup
[55633.776998] [ 9476]    73  9476    16332      373   1       0             0 trivial-rewrite
[55633.777000] [ 9477]     0  9477    16353      426   3       0             0 local
[55633.777002] [ 9478]     0  9478     9170      388   3       0             0 crond
[55633.777004] [ 9481]  1000  9481     2937      199   1       0             0 sh
[55633.777005] [ 9483]  1000  9483   155589     9884   1       0             0 offlineimap
[55633.777007] Out of memory: Kill process 9483 (offlineimap) score 10 or sacrifice child
[55633.777010] Killed process 9483 (offlineimap) total-vm:622356kB, anon-rss:39132kB, file-rss:404kB
[69228.714354] chromium invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[69228.714360] chromium cpuset=/ mems_allowed=0
[69228.714363] Pid: 14621, comm: chromium Tainted: G        W    3.5.4-1-ARCH #1
[69228.714365] Call Trace:
[69228.714372]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[69228.714377]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[69228.714382]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[69228.714388]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[69228.714393]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[69228.714396]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[69228.714400]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[69228.714405]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[69228.714409]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[69228.714412]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[69228.714416]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[69228.714420]  [<ffffffff8113d325>] ? do_wp_page+0x3e5/0x850
[69228.714423]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[69228.714428]  [<ffffffff811646c8>] ? kmem_cache_alloc+0x118/0x150
[69228.714432]  [<ffffffff81164720>] ? kmem_cache_free+0x20/0x120
[69228.714435]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[69228.714439]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[69228.714443]  [<ffffffff8117db0a>] ? sys_newstat+0x2a/0x40
[69228.714446]  [<ffffffff8147e765>] page_fault+0x25/0x30
[69228.714448] Mem-Info:
[69228.714449] Node 0 DMA per-cpu:
[69228.714453] CPU    0: hi:    0, btch:   1 usd:   0
[69228.714455] CPU    1: hi:    0, btch:   1 usd:   0
[69228.714456] CPU    2: hi:    0, btch:   1 usd:   0
[69228.714458] CPU    3: hi:    0, btch:   1 usd:   0
[69228.714459] Node 0 DMA32 per-cpu:
[69228.714462] CPU    0: hi:  186, btch:  31 usd:   0
[69228.714464] CPU    1: hi:  186, btch:  31 usd:  30
[69228.714466] CPU    2: hi:  186, btch:  31 usd:   0
[69228.714468] CPU    3: hi:  186, btch:  31 usd:  30
[69228.714469] Node 0 Normal per-cpu:
[69228.714472] CPU    0: hi:  186, btch:  31 usd:   0
[69228.714473] CPU    1: hi:  186, btch:  31 usd:  31
[69228.714475] CPU    2: hi:  186, btch:  31 usd:   0
[69228.714477] CPU    3: hi:  186, btch:  31 usd:   0
[69228.714482] active_anon:68895 inactive_anon:24102 isolated_anon:0
[69228.714482]  active_file:14 inactive_file:34 isolated_file:0
[69228.714482]  unevictable:1647 dirty:0 writeback:0 unstable:0
[69228.714482]  free:22512 slab_reclaimable:845184 slab_unreclaimable:5714
[69228.714482]  mapped:1450 shmem:46894 pagetables:2925 bounce:0
[69228.714486] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[69228.714492] lowmem_reserve[]: 0 2137 3899 3899
[69228.714496] Node 0 DMA32 free:43860kB min:36900kB low:46124kB high:55348kB active_anon:67108kB inactive_anon:5876kB active_file:4kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:108kB shmem:26004kB slab_reclaimable:2056884kB slab_unreclaimable:1748kB kernel_stack:168kB pagetables:2876kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:356 all_unreclaimable? yes
[69228.714502] lowmem_reserve[]: 0 0 1762 1762
[69228.714506] Node 0 Normal free:30348kB min:30416kB low:38020kB high:45624kB active_anon:208472kB inactive_anon:90532kB active_file:52kB inactive_file:192kB unevictable:5776kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5776kB dirty:0kB writeback:0kB mapped:5692kB shmem:161572kB slab_reclaimable:1323788kB slab_unreclaimable:21108kB kernel_stack:1368kB pagetables:8824kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1766 all_unreclaimable? yes
[69228.714513] lowmem_reserve[]: 0 0 0 0
[69228.714517] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[69228.714526] Node 0 DMA32: 768*4kB 1954*8kB 1269*16kB 20*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43872kB
[69228.714535] Node 0 Normal: 2130*4kB 1016*8kB 507*16kB 64*32kB 4*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30520kB
[69228.714545] 47952 total pagecache pages
[69228.714546] 0 pages in swap cache
[69228.714548] Swap cache stats: add 0, delete 0, find 0/0
[69228.714549] Free swap  = 0kB
[69228.714550] Total swap = 0kB
[69228.726923] 1048048 pages RAM
[69228.726927] 57533 pages reserved
[69228.726928] 61528 pages shared
[69228.726929] 916863 pages non-shared
[69228.726931] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[69228.726938] [  203]     0   203     6531      319   1     -17         -1000 systemd-udevd
[69228.726941] [  207]     0   207    42746     5320   3       0             0 systemd-journal
[69228.726945] [  331]     0   331     1056       81   2       0             0 acpid
[69228.726947] [  332]     0   332     3303      189   3       0             0 crond
[69228.726950] [  334]     0   334    10502      140   1     -17         -1000 sshd
[69228.726952] [  340]    81   340     4408      174   3     -13          -900 dbus-daemon
[69228.726955] [  341]     0   341     6512       70   1       0             0 systemd-logind
[69228.726957] [  349]     0   349    15747      115   3       0             0 login
[69228.726960] [  356]     0   356     2031       30   0       0             0 agetty
[69228.726962] [  357]     0   357     2031       30   2       0             0 agetty
[69228.726964] [  358]     0   358     2031       30   2       0             0 agetty
[69228.726967] [  359]     0   359     2031       32   0       0             0 agetty
[69228.726969] [  360]     0   360     2031       30   0       0             0 agetty
[69228.726972] [  418]     0   418     3092       58   3       0             0 master
[69228.726974] [  421]    73   421    16374      262   1       0             0 qmgr
[69228.726977] [  433]  1000   433     3423      101   3       0             0 restart-x
[69228.726980] [  444]  1000   444     3423      109   2       0             0 startx
[69228.726982] [  461]  1000   461     3966       36   3       0             0 xinit
[69228.726985] [  462]  1000   462    56946     3153   2       0             0 X
[69228.726988] [  483]  1000   483    13495      464   3       0             0 i3
[69228.726990] [  490]  1000   490     6062       72   0       0             0 unclutter
[69228.726992] [  493]  1000   493     6004       58   1       0             0 dispad
[69228.726995] [  494]  1000   494    31745     6875   2       0             0 urxvtd
[69228.726997] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[69228.727000] [  508]  1000   508     8156      420   2       0             0 zsh
[69228.727003] [  515]     0   515     8482       80   0       0             0 sudo
[69228.727005] [  516]     0   516     6933      282   1       0             0 zsh
[69228.727007] [  530]     0   530     7404      156   1       0             0 wpa_supplicant
[69228.727010] [  585]     0   585     2136       88   3       0             0 dhcpcd
[69228.727012] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[69228.727014] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[69228.727017] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[69228.727020] [ 1312]  1000  1312    14878      695   3       0             0 mutt
[69228.727022] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[69228.727025] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[69228.727027] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[69228.727029] [ 1359]     0  1359     8481       78   3       0             0 sudo
[69228.727032] [ 1360]     0  1360     6933      309   0       0             0 zsh
[69228.727035] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[69228.727038] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[69228.727040] [ 5518]  1000  5518    90770     1585   3       0             0 kded4
[69228.727042] [ 5525]  1000  5525   238394     2503   3       0             0 knotify4
[69228.727045] [ 5529]     0  5529    54766      826   3       0             0 upowerd
[69228.727047] [ 5534]     0  5534    46649      203   3     -13          -900 polkitd
[69228.727050] [ 5556]     0  5556    48360      279   1       0             0 udisks-daemon
[69228.727052] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[69228.727055] [ 8065]  1000  8065     6531      305   3       0             0 i3bar
[69228.727057] [ 8066]  1000  8066     7841      235   1       0             0 i3status
[69228.727060] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[69228.727062] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[69228.727064] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[69228.727067] [ 8776]     0  8776    51901      335   1       0             0 colord
[69228.727069] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[69228.727072] [10002]  1000 10002     8290      403   0       0             0 vim
[69228.727075] [10733]  1000 10733     8156      421   2       0             0 zsh
[69228.727077] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[69228.727080] [10749]  1000 10749     8156      421   2       0             0 zsh
[69228.727082] [10758]  1000 10758    15099      949   1       0             0 mutt
[69228.727084] [10786]  1000 10786     8970      247   0       0             0 ssh
[69228.727086] [10788]  1000 10788     8970      198   0       0             0 ssh
[69228.727089] [10790]  1000 10790     8970      262   0       0             0 ssh
[69228.727092] [15290]  1000 15290     9005      223   0       0             0 ssh
[69228.727095] [15633]  1000 15633     8752      609   1       0             0 zsh
[69228.727097] [16517]  1000 16517     8156      421   2       0             0 zsh
[69228.727099] [16542]  1000 16542     8156      497   2       0             0 zsh
[69228.727102] [ 4573]     0  4573     3774     1648   1       0             0 atop
[69228.727105] [14183]    73 14183    16331      359   1       0             0 pickup
[69228.727108] [14591]     0 14591     4424      502   1       0             0 man
[69228.727111] [14602]     0 14602     2749      200   1       0             0 less
[69228.727114] [14615]  1000 14615     5163      267   3       0             0 zsh
[69228.727116] [14621]  1000 14621   119475    10436   3       0             0 chromium
[69228.727118] [14623]  1000 14623    64813     1217   1       0             0 chromium
[69228.727120] [14624]  1000 14624     1588      137   2       0             0 chromium-sandbo
[69228.727123] [14625]  1000 14625    69787     1297   1       0             0 chromium
[69228.727126] [14627]  1000 14627    34743      445   2       0             0 nacl_helper_boo
[69228.727128] [14630]  1000 14630    69787     1144   3       0             0 chromium
[69228.727131] [14651]  1000 14651   214032     1540   1       4           300 chromium
[69228.727133] [14659]  1000 14659   119475    10038   1       0             0 Chrome_FileThre
[69228.727135] Out of memory: Kill process 14651 (chromium) score 301 or sacrifice child
[69228.727138] Killed process 14651 (chromium) total-vm:856128kB, anon-rss:5848kB, file-rss:312kB
[69228.837234] X invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[69228.837238] X cpuset=/ mems_allowed=0
[69228.837240] Pid: 462, comm: X Tainted: G        W    3.5.4-1-ARCH #1
[69228.837241] Call Trace:
[69228.837247]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[69228.837251]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[69228.837255]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[69228.837259]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[69228.837263]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[69228.837265]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[69228.837268]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[69228.837271]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[69228.837273]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[69228.837275]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[69228.837279]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[69228.837281]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[69228.837283]  [<ffffffff810643ff>] ? recalc_sigpending+0x1f/0x60
[69228.837285]  [<ffffffff81064b51>] ? dequeue_signal+0x41/0x180
[69228.837287]  [<ffffffff810643ff>] ? recalc_sigpending+0x1f/0x60
[69228.837290]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[69228.837293]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[69228.837296]  [<ffffffff8101f45a>] ? check_for_xstate+0x3a/0xa0
[69228.837298]  [<ffffffff8101f8cf>] ? restore_i387_xstate+0x1af/0x260
[69228.837301]  [<ffffffff810140f0>] ? restore_sigcontext+0x120/0x160
[69228.837303]  [<ffffffff81014e50>] ? sys_rt_sigreturn+0xb0/0xc0
[69228.837305]  [<ffffffff8147e765>] page_fault+0x25/0x30
[69228.837306] Mem-Info:
[69228.837307] Node 0 DMA per-cpu:
[69228.837309] CPU    0: hi:    0, btch:   1 usd:   0
[69228.837310] CPU    1: hi:    0, btch:   1 usd:   0
[69228.837311] CPU    2: hi:    0, btch:   1 usd:   0
[69228.837312] CPU    3: hi:    0, btch:   1 usd:   0
[69228.837313] Node 0 DMA32 per-cpu:
[69228.837315] CPU    0: hi:  186, btch:  31 usd:   0
[69228.837316] CPU    1: hi:  186, btch:  31 usd:  32
[69228.837317] CPU    2: hi:  186, btch:  31 usd:   0
[69228.837318] CPU    3: hi:  186, btch:  31 usd:   0
[69228.837318] Node 0 Normal per-cpu:
[69228.837320] CPU    0: hi:  186, btch:  31 usd:   0
[69228.837321] CPU    1: hi:  186, btch:  31 usd:  90
[69228.837322] CPU    2: hi:  186, btch:  31 usd:   0
[69228.837323] CPU    3: hi:  186, btch:  31 usd:   0
[69228.837326] active_anon:68468 inactive_anon:24102 isolated_anon:0
[69228.837326]  active_file:73 inactive_file:445 isolated_file:0
[69228.837326]  unevictable:1647 dirty:0 writeback:0 unstable:0
[69228.837326]  free:22520 slab_reclaimable:845184 slab_unreclaimable:5714
[69228.837326]  mapped:1588 shmem:46894 pagetables:2824 bounce:0
[69228.837328] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[69228.837331] lowmem_reserve[]: 0 2137 3899 3899
[69228.837334] Node 0 DMA32 free:43832kB min:36900kB low:46124kB high:55348kB active_anon:66516kB inactive_anon:5876kB active_file:4kB inactive_file:824kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:108kB shmem:26004kB slab_reclaimable:2056884kB slab_unreclaimable:1748kB kernel_stack:168kB pagetables:2656kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1414 all_unreclaimable? yes
[69228.837338] lowmem_reserve[]: 0 0 1762 1762
[69228.837340] Node 0 Normal free:30408kB min:30416kB low:38020kB high:45624kB active_anon:207356kB inactive_anon:90532kB active_file:288kB inactive_file:956kB unevictable:5776kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5776kB dirty:0kB writeback:0kB mapped:6244kB shmem:161572kB slab_reclaimable:1323788kB slab_unreclaimable:21108kB kernel_stack:1368kB pagetables:8640kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:2123 all_unreclaimable? yes
[69228.837343] lowmem_reserve[]: 0 0 0 0
[69228.837346] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[69228.837351] Node 0 DMA32: 828*4kB 1954*8kB 1270*16kB 20*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44128kB
[69228.837357] Node 0 Normal: 2203*4kB 1002*8kB 507*16kB 64*32kB 4*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30700kB
[69228.837362] 48393 total pagecache pages
[69228.837363] 0 pages in swap cache
[69228.837364] Swap cache stats: add 0, delete 0, find 0/0
[69228.837365] Free swap  = 0kB
[69228.837365] Total swap = 0kB
[69228.848795] 1048048 pages RAM
[69228.848798] 57533 pages reserved
[69228.848800] 59487 pages shared
[69228.848801] 916356 pages non-shared
[69228.848802] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[69228.848810] [  203]     0   203     6531      319   1     -17         -1000 systemd-udevd
[69228.848812] [  207]     0   207    43721     4365   3       0             0 systemd-journal
[69228.848816] [  331]     0   331     1056       81   2       0             0 acpid
[69228.848818] [  332]     0   332     3303      189   3       0             0 crond
[69228.848822] [  334]     0   334    10502      140   1     -17         -1000 sshd
[69228.848824] [  340]    81   340     4408      174   3     -13          -900 dbus-daemon
[69228.848826] [  341]     0   341     6512       70   1       0             0 systemd-logind
[69228.848829] [  349]     0   349    15747      115   3       0             0 login
[69228.848832] [  356]     0   356     2031       30   0       0             0 agetty
[69228.848834] [  357]     0   357     2031       30   2       0             0 agetty
[69228.848837] [  358]     0   358     2031       30   2       0             0 agetty
[69228.848839] [  359]     0   359     2031       32   0       0             0 agetty
[69228.848841] [  360]     0   360     2031       30   0       0             0 agetty
[69228.848844] [  418]     0   418     3092       58   3       0             0 master
[69228.848847] [  421]    73   421    16374      262   1       0             0 qmgr
[69228.848850] [  433]  1000   433     3423      101   3       0             0 restart-x
[69228.848852] [  444]  1000   444     3423      109   2       0             0 startx
[69228.848855] [  461]  1000   461     3966       36   3       0             0 xinit
[69228.848857] [  462]  1000   462    56946     3148   2       0             0 X
[69228.848859] [  483]  1000   483    13495      464   3       0             0 i3
[69228.848861] [  490]  1000   490     6062       72   0       0             0 unclutter
[69228.848864] [  493]  1000   493     6004       58   1       0             0 dispad
[69228.848866] [  494]  1000   494    31745     6873   1       0             0 urxvtd
[69228.848868] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[69228.848871] [  508]  1000   508     8156      420   2       0             0 zsh
[69228.848874] [  515]     0   515     8482       80   0       0             0 sudo
[69228.848876] [  516]     0   516     6933      282   1       0             0 zsh
[69228.848879] [  530]     0   530     7404      156   1       0             0 wpa_supplicant
[69228.848881] [  585]     0   585     2136       88   3       0             0 dhcpcd
[69228.848883] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[69228.848886] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[69228.848888] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[69228.848891] [ 1312]  1000  1312    14878      695   3       0             0 mutt
[69228.848894] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[69228.848898] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[69228.848901] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[69228.848904] [ 1359]     0  1359     8481       78   3       0             0 sudo
[69228.848906] [ 1360]     0  1360     6933      309   0       0             0 zsh
[69228.848909] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[69228.848912] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[69228.848914] [ 5518]  1000  5518    90770     1584   3       0             0 kded4
[69228.848917] [ 5525]  1000  5525   238394     2503   3       0             0 knotify4
[69228.848920] [ 5529]     0  5529    54766      826   3       0             0 upowerd
[69228.848923] [ 5534]     0  5534    46649      203   3     -13          -900 polkitd
[69228.848927] [ 5556]     0  5556    48360      279   1       0             0 udisks-daemon
[69228.848930] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[69228.848934] [ 8065]  1000  8065     6531      305   3       0             0 i3bar
[69228.848937] [ 8066]  1000  8066     7841      235   1       0             0 i3status
[69228.848940] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[69228.848943] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[69228.848945] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[69228.848948] [ 8776]     0  8776    51901      335   1       0             0 colord
[69228.848951] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[69228.848955] [10002]  1000 10002     8290      403   0       0             0 vim
[69228.848958] [10733]  1000 10733     8156      421   2       0             0 zsh
[69228.848961] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[69228.848964] [10749]  1000 10749     8156      421   2       0             0 zsh
[69228.848967] [10758]  1000 10758    15099      949   1       0             0 mutt
[69228.848970] [10786]  1000 10786     8970      247   0       0             0 ssh
[69228.848973] [10788]  1000 10788     8970      198   0       0             0 ssh
[69228.848976] [10790]  1000 10790     8970      262   0       0             0 ssh
[69228.848979] [15290]  1000 15290     9005      223   0       0             0 ssh
[69228.848982] [15633]  1000 15633     8752      609   1       0             0 zsh
[69228.848986] [16517]  1000 16517     8156      421   2       0             0 zsh
[69228.848988] [16542]  1000 16542     8156      497   2       0             0 zsh
[69228.848992] [ 4573]     0  4573     3774     1648   1       0             0 atop
[69228.848995] [14183]    73 14183    16331      359   1       0             0 pickup
[69228.848999] [14591]     0 14591     4424      502   1       0             0 man
[69228.849002] [14602]     0 14602     2749      200   1       0             0 less
[69228.849005] [14615]  1000 14615     5163      267   3       0             0 zsh
[69228.849008] [14621]  1000 14621   119475    10499   1       0             0 chromium
[69228.849011] [14623]  1000 14623    64813     1217   1       0             0 chromium
[69228.849014] [14624]  1000 14624     1588      137   2       0             0 chromium-sandbo
[69228.849017] [14625]  1000 14625    69787     1297   1       0             0 chromium
[69228.849020] [14627]  1000 14627    34743      445   2       0             0 nacl_helper_boo
[69228.849023] [14630]  1000 14630    69787     1141   3       0             0 chromium
[69228.849026] [14659]  1000 14659   119475    10048   3       0             0 Chrome_FileThre
[69228.849029] Out of memory: Kill process 14621 (chromium) score 10 or sacrifice child
[69228.849036] Killed process 14659 (Chrome_FileThre) total-vm:477900kB, anon-rss:40152kB, file-rss:40kB
[69233.905270] chromium invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=4, oom_score_adj=300
[69233.905275] chromium cpuset=/ mems_allowed=0
[69233.905278] Pid: 14660, comm: chromium Tainted: G        W    3.5.4-1-ARCH #1
[69233.905279] Call Trace:
[69233.905287]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[69233.905292]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[69233.905297]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[69233.905302]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[69233.905307]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[69233.905311]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[69233.905315]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[69233.905320]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[69233.905323]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[69233.905326]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[69233.905331]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[69233.905335]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[69233.905339]  [<ffffffff81311f60>] ? extract_buf+0xc0/0x190
[69233.905342]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[69233.905346]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[69233.905351]  [<ffffffff811646c8>] ? kmem_cache_alloc+0x118/0x150
[69233.905355]  [<ffffffff810dc9f7>] ? call_rcu+0x17/0x20
[69233.905360]  [<ffffffff8107bedf>] ? __put_cred+0x3f/0x50
[69233.905364]  [<ffffffff81177ac8>] ? sys_faccessat+0x168/0x1c0
[69233.905367]  [<ffffffff8147e765>] page_fault+0x25/0x30
[69233.905369] Mem-Info:
[69233.905370] Node 0 DMA per-cpu:
[69233.905373] CPU    0: hi:    0, btch:   1 usd:   0
[69233.905375] CPU    1: hi:    0, btch:   1 usd:   0
[69233.905377] CPU    2: hi:    0, btch:   1 usd:   0
[69233.905379] CPU    3: hi:    0, btch:   1 usd:   0
[69233.905380] Node 0 DMA32 per-cpu:
[69233.905383] CPU    0: hi:  186, btch:  31 usd:   1
[69233.905385] CPU    1: hi:  186, btch:  31 usd: 174
[69233.905387] CPU    2: hi:  186, btch:  31 usd:  30
[69233.905389] CPU    3: hi:  186, btch:  31 usd:   0
[69233.905390] Node 0 Normal per-cpu:
[69233.905392] CPU    0: hi:  186, btch:  31 usd:   3
[69233.905394] CPU    1: hi:  186, btch:  31 usd: 163
[69233.905396] CPU    2: hi:  186, btch:  31 usd:   2
[69233.905398] CPU    3: hi:  186, btch:  31 usd:  53
[69233.905403] active_anon:68043 inactive_anon:24091 isolated_anon:0
[69233.905403]  active_file:328 inactive_file:513 isolated_file:41
[69233.905403]  unevictable:1647 dirty:1 writeback:0 unstable:0
[69233.905403]  free:22500 slab_reclaimable:845126 slab_unreclaimable:5700
[69233.905403]  mapped:1871 shmem:46906 pagetables:2759 bounce:0
[69233.905406] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[69233.905412] lowmem_reserve[]: 0 2137 3899 3899
[69233.905416] Node 0 DMA32 free:43812kB min:36900kB low:46124kB high:55348kB active_anon:66568kB inactive_anon:5920kB active_file:36kB inactive_file:0kB unevictable:812kB isolated(anon):0kB isolated(file):164kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:300kB shmem:26048kB slab_reclaimable:2056880kB slab_unreclaimable:1756kB kernel_stack:160kB pagetables:2660kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1947 all_unreclaimable? yes
[69233.905423] lowmem_reserve[]: 0 0 1762 1762
[69233.905427] Node 0 Normal free:30348kB min:30416kB low:38020kB high:45624kB active_anon:205604kB inactive_anon:90444kB active_file:1276kB inactive_file:2096kB unevictable:5776kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5776kB dirty:4kB writeback:0kB mapped:7184kB shmem:161576kB slab_reclaimable:1323560kB slab_unreclaimable:21044kB kernel_stack:1344kB pagetables:8376kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:8458 all_unreclaimable? yes
[69233.905433] lowmem_reserve[]: 0 0 0 0
[69233.905436] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[69233.905446] Node 0 DMA32: 896*4kB 1928*8kB 1263*16kB 20*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 44080kB
[69233.905455] Node 0 Normal: 2227*4kB 1013*8kB 535*16kB 42*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30436kB
[69233.905465] 48733 total pagecache pages
[69233.905466] 0 pages in swap cache
[69233.905468] Swap cache stats: add 0, delete 0, find 0/0
[69233.905470] Free swap  = 0kB
[69233.905471] Total swap = 0kB
[69233.918956] 1048048 pages RAM
[69233.918959] 57533 pages reserved
[69233.918960] 50645 pages shared
[69233.918962] 924712 pages non-shared
[69233.918963] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[69233.918971] [  203]     0   203     6531      319   1     -17         -1000 systemd-udevd
[69233.918974] [  207]     0   207    44621     3847   1       0             0 systemd-journal
[69233.918978] [  331]     0   331     1056       71   3       0             0 acpid
[69233.918981] [  332]     0   332     3303      189   3       0             0 crond
[69233.918984] [  334]     0   334    10502      140   1     -17         -1000 sshd
[69233.918987] [  340]    81   340     4408      174   3     -13          -900 dbus-daemon
[69233.918990] [  341]     0   341     6512       70   1       0             0 systemd-logind
[69233.918993] [  349]     0   349    15747      115   3       0             0 login
[69233.918996] [  356]     0   356     2031       30   0       0             0 agetty
[69233.918999] [  357]     0   357     2031       30   2       0             0 agetty
[69233.919002] [  358]     0   358     2031       30   2       0             0 agetty
[69233.919004] [  359]     0   359     2031       32   0       0             0 agetty
[69233.919007] [  360]     0   360     2031       30   0       0             0 agetty
[69233.919010] [  418]     0   418     3092       58   3       0             0 master
[69233.919013] [  421]    73   421    16374      262   1       0             0 qmgr
[69233.919016] [  433]  1000   433     3423      101   3       0             0 restart-x
[69233.919019] [  444]  1000   444     3423      109   2       0             0 startx
[69233.919022] [  461]  1000   461     3966       36   3       0             0 xinit
[69233.919025] [  462]  1000   462    56946     3197   1       0             0 X
[69233.919028] [  483]  1000   483    13495      464   3       0             0 i3
[69233.919030] [  490]  1000   490     6062       72   0       0             0 unclutter
[69233.919033] [  493]  1000   493     6004       62   2       0             0 dispad
[69233.919036] [  494]  1000   494    31745     6882   3       0             0 urxvtd
[69233.919039] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[69233.919042] [  508]  1000   508     8156      420   2       0             0 zsh
[69233.919045] [  515]     0   515     8482       80   0       0             0 sudo
[69233.919048] [  516]     0   516     6933      282   1       0             0 zsh
[69233.919050] [  530]     0   530     7404      156   1       0             0 wpa_supplicant
[69233.919053] [  585]     0   585     2136       88   3       0             0 dhcpcd
[69233.919056] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[69233.919059] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[69233.919062] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[69233.919065] [ 1312]  1000  1312    14878      695   3       0             0 mutt
[69233.919067] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[69233.919071] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[69233.919073] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[69233.919076] [ 1359]     0  1359     8481       78   3       0             0 sudo
[69233.919079] [ 1360]     0  1360     6933      275   3       0             0 zsh
[69233.919082] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[69233.919085] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[69233.919088] [ 5518]  1000  5518    90770     1637   1       0             0 kded4
[69233.919090] [ 5525]  1000  5525   238394     2503   3       0             0 knotify4
[69233.919093] [ 5529]     0  5529    54766      826   3       0             0 upowerd
[69233.919096] [ 5534]     0  5534    46649      229   2     -13          -900 polkitd
[69233.919099] [ 5556]     0  5556    48360      279   1       0             0 udisks-daemon
[69233.919101] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[69233.919104] [ 8065]  1000  8065     6531      332   3       0             0 i3bar
[69233.919107] [ 8066]  1000  8066     7841      260   1       0             0 i3status
[69233.919110] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[69233.919113] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[69233.919116] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[69233.919119] [ 8776]     0  8776    51901      335   1       0             0 colord
[69233.919121] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[69233.919124] [10002]  1000 10002     8290      403   0       0             0 vim
[69233.919128] [10733]  1000 10733     8156      421   2       0             0 zsh
[69233.919130] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[69233.919134] [10749]  1000 10749     8156      421   2       0             0 zsh
[69233.919136] [10758]  1000 10758    15099      949   1       0             0 mutt
[69233.919139] [10786]  1000 10786     8970      247   0       0             0 ssh
[69233.919142] [10788]  1000 10788     8970      198   0       0             0 ssh
[69233.919144] [10790]  1000 10790     8970      262   0       0             0 ssh
[69233.919147] [15290]  1000 15290     9005      223   0       0             0 ssh
[69233.919151] [15633]  1000 15633     8752      609   1       0             0 zsh
[69233.919154] [16517]  1000 16517     8156      421   2       0             0 zsh
[69233.919156] [16542]  1000 16542     8156      497   2       0             0 zsh
[69233.919160] [ 4573]     0  4573     3774     1648   1       0             0 atop
[69233.919163] [14183]    73 14183    16331      359   1       0             0 pickup
[69233.919167] [14615]  1000 14615     5163      267   3       0             0 zsh
[69233.919169] [14621]  1000 14621   119475    11114   0       0             0 chromium
[69233.919172] [14623]  1000 14623    64813     1227   1       0             0 chromium
[69233.919175] [14624]  1000 14624     1588      137   2       0             0 chromium-sandbo
[69233.919178] [14625]  1000 14625    69787     1297   1       0             0 chromium
[69233.919181] [14627]  1000 14627    34743      445   2       0             0 nacl_helper_boo
[69233.919184] [14630]  1000 14630    69787     1156   3       0             0 chromium
[69233.919187] [14660]  1000 14660    69787     1317   1       4           300 chromium
[69233.919190] [14664]  1000 14664    26628       72   2       0             0 exe
[69233.919192] Out of memory: Kill process 14660 (chromium) score 301 or sacrifice child
[69233.919195] Killed process 14660 (chromium) total-vm:279148kB, anon-rss:4528kB, file-rss:740kB
[69238.765206] kded4 invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[69238.765210] kded4 cpuset=/ mems_allowed=0
[69238.765213] Pid: 5518, comm: kded4 Tainted: G        W    3.5.4-1-ARCH #1
[69238.765214] Call Trace:
[69238.765219]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[69238.765224]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[69238.765227]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[69238.765232]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[69238.765235]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[69238.765238]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[69238.765241]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[69238.765244]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[69238.765247]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[69238.765249]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[69238.765252]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[69238.765255]  [<ffffffff8136ef95>] ? sock_update_classid+0x65/0x90
[69238.765258]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[69238.765260]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[69238.765262]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[69238.765265]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[69238.765266]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[69238.765270]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[69238.765272]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[69238.765274]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[69238.765276]  [<ffffffff8147e765>] page_fault+0x25/0x30
[69238.765277] Mem-Info:
[69238.765279] Node 0 DMA per-cpu:
[69238.765281] CPU    0: hi:    0, btch:   1 usd:   0
[69238.765282] CPU    1: hi:    0, btch:   1 usd:   0
[69238.765283] CPU    2: hi:    0, btch:   1 usd:   0
[69238.765285] CPU    3: hi:    0, btch:   1 usd:   0
[69238.765285] Node 0 DMA32 per-cpu:
[69238.765287] CPU    0: hi:  186, btch:  31 usd:   9
[69238.765288] CPU    1: hi:  186, btch:  31 usd:  24
[69238.765289] CPU    2: hi:  186, btch:  31 usd:  20
[69238.765290] CPU    3: hi:  186, btch:  31 usd:  30
[69238.765291] Node 0 Normal per-cpu:
[69238.765293] CPU    0: hi:  186, btch:  31 usd:  31
[69238.765294] CPU    1: hi:  186, btch:  31 usd: 135
[69238.765295] CPU    2: hi:  186, btch:  31 usd:  65
[69238.765296] CPU    3: hi:  186, btch:  31 usd:  31
[69238.765300] active_anon:68318 inactive_anon:24094 isolated_anon:0
[69238.765300]  active_file:123 inactive_file:542 isolated_file:0
[69238.765300]  unevictable:1647 dirty:0 writeback:0 unstable:0
[69238.765300]  free:22502 slab_reclaimable:845122 slab_unreclaimable:5707
[69238.765300]  mapped:1613 shmem:46922 pagetables:2737 bounce:0
[69238.765302] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[69238.765306] lowmem_reserve[]: 0 2137 3899 3899
[69238.765309] Node 0 DMA32 free:43836kB min:36900kB low:46124kB high:55348kB active_anon:66708kB inactive_anon:5920kB active_file:8kB inactive_file:140kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:136kB shmem:26048kB slab_reclaimable:2056864kB slab_unreclaimable:1756kB kernel_stack:160kB pagetables:2608kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:611 all_unreclaimable? yes
[69238.765313] lowmem_reserve[]: 0 0 1762 1762
[69238.765315] Node 0 Normal free:30332kB min:30416kB low:38020kB high:45624kB active_anon:206564kB inactive_anon:90456kB active_file:484kB inactive_file:2028kB unevictable:5776kB isolated(anon):0kB isolated(file):0kB present:1804320kB mlocked:5776kB dirty:0kB writeback:0kB mapped:6316kB shmem:161640kB slab_reclaimable:1323560kB slab_unreclaimable:21072kB kernel_stack:1344kB pagetables:8340kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:4111 all_unreclaimable? yes
[69238.765319] lowmem_reserve[]: 0 0 0 0
[69238.765321] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[69238.765328] Node 0 DMA32: 843*4kB 1939*8kB 1265*16kB 20*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43988kB
[69238.765334] Node 0 Normal: 2226*4kB 1009*8kB 544*16kB 39*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30448kB
[69238.765340] 48668 total pagecache pages
[69238.765341] 0 pages in swap cache
[69238.765342] Swap cache stats: add 0, delete 0, find 0/0
[69238.765343] Free swap  = 0kB
[69238.765343] Total swap = 0kB
[69238.774519] 1048048 pages RAM
[69238.774522] 57533 pages reserved
[69238.774523] 48619 pages shared
[69238.774525] 924951 pages non-shared
[69238.774526] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[69238.774534] [  203]     0   203     6531      319   1     -17         -1000 systemd-udevd
[69238.774536] [  207]     0   207    45506     3166   1       0             0 systemd-journal
[69238.774540] [  331]     0   331     1056      101   3       0             0 acpid
[69238.774542] [  332]     0   332     3303      189   3       0             0 crond
[69238.774545] [  334]     0   334    10502      140   1     -17         -1000 sshd
[69238.774547] [  340]    81   340     4408      174   3     -13          -900 dbus-daemon
[69238.774550] [  341]     0   341     6512       70   1       0             0 systemd-logind
[69238.774552] [  349]     0   349    15747      115   3       0             0 login
[69238.774555] [  356]     0   356     2031       30   0       0             0 agetty
[69238.774557] [  357]     0   357     2031       30   2       0             0 agetty
[69238.774559] [  358]     0   358     2031       30   2       0             0 agetty
[69238.774562] [  359]     0   359     2031       32   0       0             0 agetty
[69238.774565] [  360]     0   360     2031       30   0       0             0 agetty
[69238.774567] [  418]     0   418     3092       58   3       0             0 master
[69238.774570] [  421]    73   421    16374      262   1       0             0 qmgr
[69238.774573] [  433]  1000   433     3423      101   3       0             0 restart-x
[69238.774576] [  444]  1000   444     3423      109   2       0             0 startx
[69238.774578] [  461]  1000   461     3966       36   3       0             0 xinit
[69238.774581] [  462]  1000   462    56946     3198   1       0             0 X
[69238.774583] [  483]  1000   483    13495      440   3       0             0 i3
[69238.774586] [  490]  1000   490     6062       79   1       0             0 unclutter
[69238.774589] [  493]  1000   493     6004       58   3       0             0 dispad
[69238.774592] [  494]  1000   494    31745     6910   2       0             0 urxvtd
[69238.774594] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[69238.774597] [  508]  1000   508     8156      420   2       0             0 zsh
[69238.774599] [  515]     0   515     8482       80   0       0             0 sudo
[69238.774602] [  516]     0   516     6933      282   1       0             0 zsh
[69238.774605] [  530]     0   530     7404      156   1       0             0 wpa_supplicant
[69238.774607] [  585]     0   585     2136       88   3       0             0 dhcpcd
[69238.774610] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[69238.774613] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[69238.774615] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[69238.774618] [ 1312]  1000  1312    14878      695   3       0             0 mutt
[69238.774621] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[69238.774624] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[69238.774627] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[69238.774630] [ 1359]     0  1359     8481       78   3       0             0 sudo
[69238.774633] [ 1360]     0  1360     6933      309   1       0             0 zsh
[69238.774636] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[69238.774640] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[69238.774642] [ 5518]  1000  5518    90770     1622   3       0             0 kded4
[69238.774645] [ 5525]  1000  5525   238394     2503   3       0             0 knotify4
[69238.774648] [ 5529]     0  5529    54766      826   3       0             0 upowerd
[69238.774650] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[69238.774651] [ 5556]     0  5556    48360      279   1       0             0 udisks-daemon
[69238.774653] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[69238.774655] [ 8065]  1000  8065     6531      292   3       0             0 i3bar
[69238.774657] [ 8066]  1000  8066     7841      238   1       0             0 i3status
[69238.774659] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[69238.774660] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[69238.774662] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[69238.774664] [ 8776]     0  8776    51901      335   1       0             0 colord
[69238.774666] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[69238.774667] [10002]  1000 10002     8290      403   0       0             0 vim
[69238.774670] [10733]  1000 10733     8156      421   2       0             0 zsh
[69238.774672] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[69238.774673] [10749]  1000 10749     8156      421   2       0             0 zsh
[69238.774675] [10758]  1000 10758    15099      949   1       0             0 mutt
[69238.774677] [10786]  1000 10786     8970      247   0       0             0 ssh
[69238.774678] [10788]  1000 10788     8970      198   0       0             0 ssh
[69238.774681] [10790]  1000 10790     8970      262   0       0             0 ssh
[69238.774683] [15290]  1000 15290     9005      216   1       0             0 ssh
[69238.774685] [15633]  1000 15633     8752      609   1       0             0 zsh
[69238.774687] [16517]  1000 16517     8156      421   2       0             0 zsh
[69238.774688] [16542]  1000 16542     8156      497   2       0             0 zsh
[69238.774690] [ 4573]     0  4573     3774     1648   1       0             0 atop
[69238.774692] [14183]    73 14183    16331      359   1       0             0 pickup
[69238.774695] [14615]  1000 14615     5163      267   3       0             0 zsh
[69238.774697] [14621]  1000 14621   119475    11062   1       0             0 chromium
[69238.774698] [14623]  1000 14623    64813     1206   1       0             0 chromium
[69238.774700] [14624]  1000 14624     1588      137   2       0             0 chromium-sandbo
[69238.774702] [14625]  1000 14625    69787     1297   1       0             0 chromium
[69238.774704] [14627]  1000 14627    34743      445   2       0             0 nacl_helper_boo
[69238.774705] [14630]  1000 14630    69787     1149   1       0             0 chromium
[69238.774707] [14664]  1000 14664    63919      284   1       0             0 exe
[69238.774709] Out of memory: Kill process 14621 (chromium) score 11 or sacrifice child
[69238.774714] Killed process 14623 (chromium) total-vm:259252kB, anon-rss:4440kB, file-rss:384kB
[69243.271301] NSS SSL Thread invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[69243.271305] NSS SSL Thread cpuset=/ mems_allowed=0
[69243.271307] Pid: 14647, comm: NSS SSL Thread Tainted: G        W    3.5.4-1-ARCH #1
[69243.271309] Call Trace:
[69243.271315]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[69243.271319]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[69243.271323]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[69243.271327]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[69243.271331]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[69243.271334]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[69243.271338]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[69243.271352]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[69243.271356]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[69243.271359]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[69243.271364]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[69243.271368]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[69243.271373]  [<ffffffff8147d362>] ? preempt_schedule_irq+0x52/0x80
[69243.271376]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[69243.271381]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[69243.271386]  [<ffffffff810adc92>] ? sys_futex+0x102/0x190
[69243.271389]  [<ffffffff8147e765>] page_fault+0x25/0x30
[69243.271391] Mem-Info:
[69243.271392] Node 0 DMA per-cpu:
[69243.271395] CPU    0: hi:    0, btch:   1 usd:   0
[69243.271396] CPU    1: hi:    0, btch:   1 usd:   0
[69243.271398] CPU    2: hi:    0, btch:   1 usd:   0
[69243.271399] CPU    3: hi:    0, btch:   1 usd:   0
[69243.271401] Node 0 DMA32 per-cpu:
[69243.271404] CPU    0: hi:  186, btch:  31 usd:   0
[69243.271405] CPU    1: hi:  186, btch:  31 usd:   1
[69243.271407] CPU    2: hi:  186, btch:  31 usd:  68
[69243.271409] CPU    3: hi:  186, btch:  31 usd:  30
[69243.271411] Node 0 Normal per-cpu:
[69243.271414] CPU    0: hi:  186, btch:  31 usd:   0
[69243.271416] CPU    1: hi:  186, btch:  31 usd:  30
[69243.271419] CPU    2: hi:  186, btch:  31 usd: 172
[69243.271421] CPU    3: hi:  186, btch:  31 usd:   0
[69243.271426] active_anon:68864 inactive_anon:24138 isolated_anon:0
[69243.271426]  active_file:68 inactive_file:51 isolated_file:32
[69243.271426]  unevictable:1647 dirty:0 writeback:0 unstable:0
[69243.271426]  free:22507 slab_reclaimable:845122 slab_unreclaimable:5691
[69243.271426]  mapped:1520 shmem:46986 pagetables:2648 bounce:0
[69243.271430] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[69243.271437] lowmem_reserve[]: 0 2137 3899 3899
[69243.271442] Node 0 DMA32 free:43848kB min:36900kB low:46124kB high:55348kB active_anon:67172kB inactive_anon:5920kB active_file:8kB inactive_file:148kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:0kB shmem:26048kB slab_reclaimable:2056864kB slab_unreclaimable:1756kB kernel_stack:160kB pagetables:2616kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:331 all_unreclaimable? yes
[69243.271449] lowmem_reserve[]: 0 0 1762 1762
[69243.271453] Node 0 Normal free:30464kB min:30416kB low:38020kB high:45624kB active_anon:208284kB inactive_anon:90632kB active_file:264kB inactive_file:56kB unevictable:5776kB isolated(anon):0kB isolated(file):128kB present:1804320kB mlocked:5776kB dirty:0kB writeback:0kB mapped:6128kB shmem:161896kB slab_reclaimable:1323560kB slab_unreclaimable:21008kB kernel_stack:1352kB pagetables:7976kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[69243.271459] lowmem_reserve[]: 0 0 0 0
[69243.271463] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[69243.271473] Node 0 DMA32: 803*4kB 1922*8kB 1261*16kB 20*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43628kB
[69243.271482] Node 0 Normal: 2298*4kB 1053*8kB 553*16kB 22*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30688kB
[69243.271490] 47992 total pagecache pages
[69243.271492] 0 pages in swap cache
[69243.271493] Swap cache stats: add 0, delete 0, find 0/0
[69243.271495] Free swap  = 0kB
[69243.271496] Total swap = 0kB
[69243.283248] 1048048 pages RAM
[69243.283250] 57533 pages reserved
[69243.283251] 46968 pages shared
[69243.283252] 926300 pages non-shared
[69243.283254] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[69243.283261] [  203]     0   203     6531      319   1     -17         -1000 systemd-udevd
[69243.283265] [  207]     0   207    46959     2600   1       0             0 systemd-journal
[69243.283268] [  331]     0   331     1056       71   3       0             0 acpid
[69243.283271] [  332]     0   332     3303      189   3       0             0 crond
[69243.283274] [  334]     0   334    10502      140   1     -17         -1000 sshd
[69243.283277] [  340]    81   340     4408      174   3     -13          -900 dbus-daemon
[69243.283279] [  341]     0   341     6512       70   1       0             0 systemd-logind
[69243.283282] [  349]     0   349    15747      115   3       0             0 login
[69243.283285] [  356]     0   356     2031       30   0       0             0 agetty
[69243.283288] [  357]     0   357     2031       30   2       0             0 agetty
[69243.283290] [  358]     0   358     2031       30   2       0             0 agetty
[69243.283292] [  359]     0   359     2031       32   0       0             0 agetty
[69243.283295] [  360]     0   360     2031       30   0       0             0 agetty
[69243.283298] [  418]     0   418     3092       58   3       0             0 master
[69243.283301] [  421]    73   421    16374      262   1       0             0 qmgr
[69243.283304] [  433]  1000   433     3423      101   3       0             0 restart-x
[69243.283307] [  444]  1000   444     3423      109   2       0             0 startx
[69243.283310] [  461]  1000   461     3966       36   3       0             0 xinit
[69243.283313] [  462]  1000   462    56946     3155   3       0             0 X
[69243.283316] [  483]  1000   483    13495      440   3       0             0 i3
[69243.283318] [  490]  1000   490     6062       79   1       0             0 unclutter
[69243.283321] [  493]  1000   493     6004       58   1       0             0 dispad
[69243.283324] [  494]  1000   494    31745     6859   2       0             0 urxvtd
[69243.283326] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[69243.283330] [  508]  1000   508     8156      420   2       0             0 zsh
[69243.283332] [  515]     0   515     8482       80   0       0             0 sudo
[69243.283335] [  516]     0   516     6933      282   1       0             0 zsh
[69243.283338] [  530]     0   530     7404      194   1       0             0 wpa_supplicant
[69243.283341] [  585]     0   585     2136       88   3       0             0 dhcpcd
[69243.283343] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[69243.283347] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[69243.283349] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[69243.283352] [ 1312]  1000  1312    14878      695   3       0             0 mutt
[69243.283355] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[69243.283358] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[69243.283361] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[69243.283363] [ 1359]     0  1359     8481       78   3       0             0 sudo
[69243.283366] [ 1360]     0  1360     6933      294   2       0             0 zsh
[69243.283368] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[69243.283370] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[69243.283373] [ 5518]  1000  5518    90770     1607   3       0             0 kded4
[69243.283376] [ 5525]  1000  5525   238394     2503   3       0             0 knotify4
[69243.283379] [ 5529]     0  5529    54766      826   3       0             0 upowerd
[69243.283382] [ 5534]     0  5534    46649      231   2     -13          -900 polkitd
[69243.283384] [ 5556]     0  5556    48360      279   1       0             0 udisks-daemon
[69243.283387] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[69243.283389] [ 8065]  1000  8065     6531      324   3       0             0 i3bar
[69243.283392] [ 8066]  1000  8066     7841      265   1       0             0 i3status
[69243.283394] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[69243.283396] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[69243.283399] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[69243.283401] [ 8776]     0  8776    51901      335   1       0             0 colord
[69243.283403] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[69243.283406] [10002]  1000 10002     8290      403   0       0             0 vim
[69243.283409] [10733]  1000 10733     8156      421   2       0             0 zsh
[69243.283412] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[69243.283414] [10749]  1000 10749     8156      421   2       0             0 zsh
[69243.283416] [10758]  1000 10758    15099      949   1       0             0 mutt
[69243.283419] [10786]  1000 10786     8970      247   0       0             0 ssh
[69243.283421] [10788]  1000 10788     8970      198   0       0             0 ssh
[69243.283423] [10790]  1000 10790     8970      262   0       0             0 ssh
[69243.283426] [15290]  1000 15290     9005      216   1       0             0 ssh
[69243.283428] [15633]  1000 15633     8752      609   1       0             0 zsh
[69243.283431] [16517]  1000 16517     8156      421   2       0             0 zsh
[69243.283433] [16542]  1000 16542     8156      497   2       0             0 zsh
[69243.283436] [ 4573]     0  4573     3774     1648   1       0             0 atop
[69243.283439] [14183]    73 14183    16331      359   1       0             0 pickup
[69243.283443] [14615]  1000 14615     5163      267   3       0             0 zsh
[69243.283446] [14621]  1000 14621   119475    11034   2       0             0 chromium
[69243.283449] [14624]  1000 14624     1588      137   2       0             0 chromium-sandbo
[69243.283452] [14625]  1000 14625    69787     1297   1       0             0 chromium
[69243.283455] [14627]  1000 14627    34743      445   2       0             0 nacl_helper_boo
[69243.283458] [14630]  1000 14630    69787     1149   1       0             0 chromium
[69243.283461] [14664]  1000 14664    63920      999   2       0             0 exe
[69243.283462] Out of memory: Kill process 14621 (chromium) score 11 or sacrifice child
[69243.283467] Killed process 14664 (exe) total-vm:255680kB, anon-rss:3748kB, file-rss:248kB
[69245.725232] Chrome_FileThre invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[69245.725237] Chrome_FileThre cpuset=/ mems_allowed=0
[69245.725240] Pid: 14639, comm: Chrome_FileThre Tainted: G        W    3.5.4-1-ARCH #1
[69245.725242] Call Trace:
[69245.725249]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[69245.725255]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[69245.725260]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[69245.725266]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[69245.725271]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[69245.725275]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[69245.725279]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[69245.725283]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[69245.725287]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[69245.725291]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[69245.725295]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[69245.725299]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[69245.725302]  [<ffffffff81116f8b>] ? find_get_pages_tag+0xeb/0x170
[69245.725306]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[69245.725311]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[69245.725315]  [<ffffffff8147ba8e>] ? __mutex_lock_slowpath+0x24e/0x340
[69245.725334]  [<ffffffffa01bb911>] ? jfs_flush_journal+0xc1/0x2c0 [jfs]
[69245.725338]  [<ffffffff8147b83e>] ? mutex_unlock+0xe/0x10
[69245.725344]  [<ffffffffa01a0594>] ? jfs_fsync+0xd4/0xf0 [jfs]
[69245.725348]  [<ffffffff8147e765>] page_fault+0x25/0x30
[69245.725350] Mem-Info:
[69245.725351] Node 0 DMA per-cpu:
[69245.725355] CPU    0: hi:    0, btch:   1 usd:   0
[69245.725357] CPU    1: hi:    0, btch:   1 usd:   0
[69245.725358] CPU    2: hi:    0, btch:   1 usd:   0
[69245.725360] CPU    3: hi:    0, btch:   1 usd:   0
[69245.725362] Node 0 DMA32 per-cpu:
[69245.725365] CPU    0: hi:  186, btch:  31 usd:   8
[69245.725366] CPU    1: hi:  186, btch:  31 usd:  81
[69245.725368] CPU    2: hi:  186, btch:  31 usd:   0
[69245.725370] CPU    3: hi:  186, btch:  31 usd:  27
[69245.725372] Node 0 Normal per-cpu:
[69245.725374] CPU    0: hi:  186, btch:  31 usd:  26
[69245.725376] CPU    1: hi:  186, btch:  31 usd: 161
[69245.725379] CPU    2: hi:  186, btch:  31 usd: 128
[69245.725380] CPU    3: hi:  186, btch:  31 usd:  23
[69245.725385] active_anon:68639 inactive_anon:24140 isolated_anon:0
[69245.725385]  active_file:111 inactive_file:312 isolated_file:21
[69245.725385]  unevictable:1647 dirty:0 writeback:62 unstable:0
[69245.725385]  free:22499 slab_reclaimable:845122 slab_unreclaimable:5702
[69245.725385]  mapped:1501 shmem:47002 pagetables:2700 bounce:0
[69245.725389] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[69245.725395] lowmem_reserve[]: 0 2137 3899 3899
[69245.725400] Node 0 DMA32 free:43820kB min:36900kB low:46124kB high:55348kB active_anon:67032kB inactive_anon:5928kB active_file:20kB inactive_file:96kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:132kB mapped:124kB shmem:26064kB slab_reclaimable:2056864kB slab_unreclaimable:1728kB kernel_stack:168kB pagetables:2668kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:841 all_unreclaimable? yes
[69245.725406] lowmem_reserve[]: 0 0 1762 1762
[69245.725410] Node 0 Normal free:30336kB min:30416kB low:38020kB high:45624kB active_anon:207524kB inactive_anon:90632kB active_file:424kB inactive_file:1028kB unevictable:5776kB isolated(anon):0kB isolated(file):212kB present:1804320kB mlocked:5776kB dirty:0kB writeback:116kB mapped:5880kB shmem:161944kB slab_reclaimable:1323560kB slab_unreclaimable:21080kB kernel_stack:1344kB pagetables:8132kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:2985 all_unreclaimable? yes
[69245.725417] lowmem_reserve[]: 0 0 0 0
[69245.725421] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[69245.725432] Node 0 DMA32: 837*4kB 1952*8kB 1260*16kB 20*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43988kB
[69245.725442] Node 0 Normal: 2231*4kB 1067*8kB 564*16kB 15*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30484kB
[69245.725452] 48368 total pagecache pages
[69245.725453] 0 pages in swap cache
[69245.725455] Swap cache stats: add 0, delete 0, find 0/0
[69245.725457] Free swap  = 0kB
[69245.725458] Total swap = 0kB
[69245.737324] 1048048 pages RAM
[69245.737327] 57533 pages reserved
[69245.737328] 57067 pages shared
[69245.737329] 915449 pages non-shared
[69245.737331] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[69245.737338] [  203]     0   203     6531      319   1     -17         -1000 systemd-udevd
[69245.737341] [  207]     0   207    48252     2341   1       0             0 systemd-journal
[69245.737345] [  331]     0   331     1056       71   3       0             0 acpid
[69245.737348] [  332]     0   332     3303      189   3       0             0 crond
[69245.737351] [  334]     0   334    10502      140   1     -17         -1000 sshd
[69245.737353] [  340]    81   340     4408      174   3     -13          -900 dbus-daemon
[69245.737356] [  341]     0   341     6512       70   1       0             0 systemd-logind
[69245.737359] [  349]     0   349    15747      115   3       0             0 login
[69245.737362] [  356]     0   356     2031       30   0       0             0 agetty
[69245.737364] [  357]     0   357     2031       30   2       0             0 agetty
[69245.737367] [  358]     0   358     2031       30   2       0             0 agetty
[69245.737370] [  359]     0   359     2031       32   0       0             0 agetty
[69245.737372] [  360]     0   360     2031       30   0       0             0 agetty
[69245.737375] [  418]     0   418     3092       58   3       0             0 master
[69245.737378] [  421]    73   421    16374      262   1       0             0 qmgr
[69245.737381] [  433]  1000   433     3423      101   3       0             0 restart-x
[69245.737383] [  444]  1000   444     3423      109   2       0             0 startx
[69245.737386] [  461]  1000   461     3966       36   3       0             0 xinit
[69245.737388] [  462]  1000   462    56946     3156   2       0             0 X
[69245.737390] [  483]  1000   483    13495      468   3       0             0 i3
[69245.737392] [  490]  1000   490     6062       72   3       0             0 unclutter
[69245.737395] [  493]  1000   493     6004       58   1       0             0 dispad
[69245.737398] [  494]  1000   494    31745     6881   3       0             0 urxvtd
[69245.737400] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[69245.737403] [  508]  1000   508     8156      420   2       0             0 zsh
[69245.737405] [  515]     0   515     8482       80   0       0             0 sudo
[69245.737408] [  516]     0   516     6933      282   1       0             0 zsh
[69245.737411] [  530]     0   530     7404      194   1       0             0 wpa_supplicant
[69245.737414] [  585]     0   585     2136       88   3       0             0 dhcpcd
[69245.737416] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[69245.737419] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[69245.737422] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[69245.737424] [ 1312]  1000  1312    14878      695   3       0             0 mutt
[69245.737427] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[69245.737430] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[69245.737432] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[69245.737435] [ 1359]     0  1359     8481       78   3       0             0 sudo
[69245.737438] [ 1360]     0  1360     6933      311   1       0             0 zsh
[69245.737441] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[69245.737443] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[69245.737447] [ 5518]  1000  5518    90770     1619   0       0             0 kded4
[69245.737450] [ 5525]  1000  5525   238394     2532   2       0             0 knotify4
[69245.737453] [ 5529]     0  5529    54766      826   3       0             0 upowerd
[69245.737456] [ 5534]     0  5534    46649      204   2     -13          -900 polkitd
[69245.737459] [ 5556]     0  5556    48360      279   1       0             0 udisks-daemon
[69245.737462] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[69245.737465] [ 8065]  1000  8065     6531      298   3       0             0 i3bar
[69245.737468] [ 8066]  1000  8066     7841      243   1       0             0 i3status
[69245.737471] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[69245.737474] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[69245.737476] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[69245.737479] [ 8776]     0  8776    51901      335   1       0             0 colord
[69245.737482] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[69245.737485] [10002]  1000 10002     8290      403   0       0             0 vim
[69245.737489] [10733]  1000 10733     8156      421   2       0             0 zsh
[69245.737491] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[69245.737494] [10749]  1000 10749     8156      421   2       0             0 zsh
[69245.737503] [10758]  1000 10758    15099      949   1       0             0 mutt
[69245.737506] [10786]  1000 10786     8970      247   0       0             0 ssh
[69245.737509] [10788]  1000 10788     8970      198   0       0             0 ssh
[69245.737511] [10790]  1000 10790     8970      262   0       0             0 ssh
[69245.737514] [15290]  1000 15290     9005      216   1       0             0 ssh
[69245.737517] [15633]  1000 15633     8752      609   1       0             0 zsh
[69245.737520] [16517]  1000 16517     8156      421   2       0             0 zsh
[69245.737523] [16542]  1000 16542     8156      497   2       0             0 zsh
[69245.737526] [ 4573]     0  4573     3774     1648   1       0             0 atop
[69245.737529] [14183]    73 14183    16331      359   1       0             0 pickup
[69245.737533] [14615]  1000 14615     5163      267   3       0             0 zsh
[69245.737536] [14621]  1000 14621   119475    11241   3       0             0 chromium
[69245.737539] [14624]  1000 14624     1588      137   2       0             0 chromium-sandbo
[69245.737542] [14625]  1000 14625    69787     1297   1       0             0 chromium
[69245.737544] [14627]  1000 14627    34743      445   2       0             0 nacl_helper_boo
[69245.737547] [14630]  1000 14630    69787     1149   1       0             0 chromium
[69245.737551] [14667]  1000 14667   119475    10910   2       0             0 Chrome_ProcessL
[69245.737553] Out of memory: Kill process 14621 (chromium) score 11 or sacrifice child
[69245.737559] Killed process 14667 (Chrome_ProcessL) total-vm:477900kB, anon-rss:43624kB, file-rss:16kB
[69250.702141] knotify4 invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
[69250.702145] knotify4 cpuset=/ mems_allowed=0
[69250.702147] Pid: 5525, comm: knotify4 Tainted: G        W    3.5.4-1-ARCH #1
[69250.702148] Call Trace:
[69250.702154]  [<ffffffff810c4cad>] ? cpuset_print_task_mems_allowed+0x9d/0xb0
[69250.702159]  [<ffffffff81476002>] dump_header+0x84/0x1f0
[69250.702163]  [<ffffffff8105e330>] ? has_ns_capability_noaudit+0x40/0x60
[69250.702167]  [<ffffffff812539f3>] ? ___ratelimit+0xa3/0x120
[69250.702171]  [<ffffffff8111aab7>] oom_kill_process+0x297/0x2d0
[69250.702173]  [<ffffffff8111affb>] out_of_memory+0x29b/0x3e0
[69250.702176]  [<ffffffff8111fc7f>] __alloc_pages_nodemask+0x8ef/0x900
[69250.702181]  [<ffffffff8115a8f0>] alloc_pages_current+0xb0/0x120
[69250.702183]  [<ffffffff8111786f>] __page_cache_alloc+0xaf/0xd0
[69250.702185]  [<ffffffff81119495>] filemap_fault+0x205/0x440
[69250.702190]  [<ffffffff8113bc44>] __do_fault+0x74/0x5a0
[69250.702193]  [<ffffffff8136ef4e>] ? sock_update_classid+0x1e/0x90
[69250.702196]  [<ffffffff8113ee45>] handle_pte_fault+0x95/0xaa0
[69250.702198]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[69250.702201]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[69250.702203]  [<ffffffff81140ea9>] handle_mm_fault+0x259/0x320
[69250.702205]  [<ffffffff8118b900>] ? __pollwait+0xf0/0xf0
[69250.702209]  [<ffffffff81481423>] do_page_fault+0x123/0x580
[69250.702211]  [<ffffffff8118bb9f>] ? poll_select_set_timeout+0x6f/0x90
[69250.702213]  [<ffffffff8147e765>] page_fault+0x25/0x30
[69250.702215] Mem-Info:
[69250.702216] Node 0 DMA per-cpu:
[69250.702218] CPU    0: hi:    0, btch:   1 usd:   0
[69250.702219] CPU    1: hi:    0, btch:   1 usd:   0
[69250.702221] CPU    2: hi:    0, btch:   1 usd:   0
[69250.702222] CPU    3: hi:    0, btch:   1 usd:   0
[69250.702223] Node 0 DMA32 per-cpu:
[69250.702224] CPU    0: hi:  186, btch:  31 usd:   0
[69250.702226] CPU    1: hi:  186, btch:  31 usd:  91
[69250.702227] CPU    2: hi:  186, btch:  31 usd:   0
[69250.702228] CPU    3: hi:  186, btch:  31 usd:  28
[69250.702229] Node 0 Normal per-cpu:
[69250.702231] CPU    0: hi:  186, btch:  31 usd:  99
[69250.702232] CPU    1: hi:  186, btch:  31 usd: 178
[69250.702233] CPU    2: hi:  186, btch:  31 usd:  47
[69250.702234] CPU    3: hi:  186, btch:  31 usd:  30
[69250.702238] active_anon:68276 inactive_anon:24133 isolated_anon:0
[69250.702238]  active_file:167 inactive_file:572 isolated_file:0
[69250.702238]  unevictable:1647 dirty:0 writeback:0 unstable:0
[69250.702238]  free:22500 slab_reclaimable:845122 slab_unreclaimable:5680
[69250.702238]  mapped:1665 shmem:47010 pagetables:2662 bounce:0
[69250.702240] Node 0 DMA free:15840kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15648kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:64kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[69250.702244] lowmem_reserve[]: 0 2137 3899 3899
[69250.702247] Node 0 DMA32 free:43776kB min:36900kB low:46124kB high:55348kB active_anon:66816kB inactive_anon:5892kB active_file:0kB inactive_file:388kB unevictable:812kB isolated(anon):0kB isolated(file):0kB present:2188752kB mlocked:812kB dirty:0kB writeback:0kB mapped:208kB shmem:26052kB slab_reclaimable:2056864kB slab_unreclaimable:1784kB kernel_stack:160kB pagetables:2584kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1027 all_unreclaimable? yes
[69250.702251] lowmem_reserve[]: 0 0 1762 1762
[69250.702254] Node 0 Normal free:30384kB min:30416kB low:38020kB high:45624kB active_anon:206288kB inactive_anon:90640kB active_file:684kB inactive_file:1900kB unevictable:5776kB isolated(anon):0kB isolated(file):32kB present:1804320kB mlocked:5776kB dirty:0kB writeback:0kB mapped:6452kB shmem:161988kB slab_reclaimable:1323560kB slab_unreclaimable:20936kB kernel_stack:1360kB pagetables:8064kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:4374 all_unreclaimable? yes
[69250.702258] lowmem_reserve[]: 0 0 0 0
[69250.702260] Node 0 DMA: 2*4kB 1*8kB 1*16kB 2*32kB 2*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15840kB
[69250.702266] Node 0 DMA32: 844*4kB 1917*8kB 1258*16kB 19*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 43672kB
[69250.702272] Node 0 Normal: 2302*4kB 1088*8kB 555*16kB 6*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 30504kB
[69250.702279] 48755 total pagecache pages
[69250.702280] 0 pages in swap cache
[69250.702281] Swap cache stats: add 0, delete 0, find 0/0
[69250.702282] Free swap  = 0kB
[69250.702283] Total swap = 0kB
[69250.711932] 1048048 pages RAM
[69250.711934] 57533 pages reserved
[69250.711935] 47236 pages shared
[69250.711936] 925878 pages non-shared
[69250.711938] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[69250.711945] [  203]     0   203     6531      319   1     -17         -1000 systemd-udevd
[69250.711947] [  207]     0   207    49551     2544   3       0             0 systemd-journal
[69250.711950] [  331]     0   331     1056       61   3       0             0 acpid
[69250.711953] [  332]     0   332     3303      189   3       0             0 crond
[69250.711955] [  334]     0   334    10502      140   1     -17         -1000 sshd
[69250.711958] [  340]    81   340     4408      174   3     -13          -900 dbus-daemon
[69250.711961] [  341]     0   341     6512       70   1       0             0 systemd-logind
[69250.711964] [  349]     0   349    15747      115   3       0             0 login
[69250.711966] [  356]     0   356     2031       30   0       0             0 agetty
[69250.711968] [  357]     0   357     2031       30   2       0             0 agetty
[69250.711971] [  358]     0   358     2031       30   2       0             0 agetty
[69250.711973] [  359]     0   359     2031       32   0       0             0 agetty
[69250.711976] [  360]     0   360     2031       30   0       0             0 agetty
[69250.711978] [  418]     0   418     3092       58   3       0             0 master
[69250.711981] [  421]    73   421    16374      262   1       0             0 qmgr
[69250.711984] [  433]  1000   433     3423      101   3       0             0 restart-x
[69250.711987] [  444]  1000   444     3423      109   2       0             0 startx
[69250.711989] [  461]  1000   461     3966       36   3       0             0 xinit
[69250.711992] [  462]  1000   462    56946     3156   0       0             0 X
[69250.711995] [  483]  1000   483    13495      470   3       0             0 i3
[69250.711997] [  490]  1000   490     6062       72   3       0             0 unclutter
[69250.711999] [  493]  1000   493     6004       79   0       0             0 dispad
[69250.712001] [  494]  1000   494    31745     6871   1       0             0 urxvtd
[69250.712003] [  497]  1000   497     8038      371   3       0             0 xbindkeys
[69250.712005] [  508]  1000   508     8156      420   2       0             0 zsh
[69250.712007] [  515]     0   515     8482       80   0       0             0 sudo
[69250.712009] [  516]     0   516     6933      282   1       0             0 zsh
[69250.712011] [  530]     0   530     7404      189   1       0             0 wpa_supplicant
[69250.712013] [  585]     0   585     2136       88   3       0             0 dhcpcd
[69250.712014] [  751]  1000   751     4494       52   3       0             0 dbus-launch
[69250.712016] [  752]  1000   752     4353       77   2       0             0 dbus-daemon
[69250.712018] [ 1305]  1000  1305     8156      420   0       0             0 zsh
[69250.712020] [ 1312]  1000  1312    14878      695   3       0             0 mutt
[69250.712022] [ 1332]  1000  1332     8156      420   3       0             0 zsh
[69250.712024] [ 1339]  1000  1339    16616     2406   2       0             0 mutt
[69250.712026] [ 1349]  1000  1349     8156      421   0       0             0 zsh
[69250.712027] [ 1359]     0  1359     8481       78   3       0             0 sudo
[69250.712029] [ 1360]     0  1360     6933      296   1       0             0 zsh
[69250.712031] [ 5513]  1000  5513    40312      660   0       0             0 kdeinit4
[69250.712033] [ 5515]  1000  5515    48432      679   1       0             0 klauncher
[69250.712034] [ 5518]  1000  5518    90770     1628   2       0             0 kded4
[69250.712036] [ 5525]  1000  5525   238394     2536   0       0             0 knotify4
[69250.712038] [ 5529]     0  5529    54766      826   3       0             0 upowerd
[69250.712040] [ 5534]     0  5534    46649      203   2     -13          -900 polkitd
[69250.712042] [ 5556]     0  5556    48360      350   1       0             0 udisks-daemon
[69250.712043] [ 5564]     0  5564    11353       84   2       0             0 udisks-daemon
[69250.712045] [ 8065]  1000  8065     6531      330   1       0             0 i3bar
[69250.712047] [ 8066]  1000  8066     7841      265   2       0             0 i3status
[69250.712048] [ 8146]  1000  8146     8726      481   1       0             0 zsh
[69250.712050] [ 8758]  1000  8758     8774      512   3       0             0 zsh
[69250.712052] [ 8775]     0  8775    17693      475   2       0             0 cupsd
[69250.712054] [ 8776]     0  8776    51902      393   0       0             0 colord
[69250.712055] [ 8779]     0  8779   123543     1366   0       0             0 colord-sane
[69250.712057] [10002]  1000 10002     8290      403   0       0             0 vim
[69250.712060] [10733]  1000 10733     8156      421   2       0             0 zsh
[69250.712062] [10741]  1000 10741     3423      104   1       0             0 ressh.sh
[69250.712064] [10749]  1000 10749     8156      421   2       0             0 zsh
[69250.712065] [10758]  1000 10758    15099      949   1       0             0 mutt
[69250.712067] [10786]  1000 10786     8970      247   0       0             0 ssh
[69250.712069] [10788]  1000 10788     8970      198   0       0             0 ssh
[69250.712071] [10790]  1000 10790     8970      262   0       0             0 ssh
[69250.712073] [15290]  1000 15290     9005      216   1       0             0 ssh
[69250.712075] [15633]  1000 15633     8752      609   1       0             0 zsh
[69250.712077] [16517]  1000 16517     8156      421   2       0             0 zsh
[69250.712078] [16542]  1000 16542     8156      497   2       0             0 zsh
[69250.712080] [ 4573]     0  4573     3774     1648   1       0             0 atop
[69250.712083] [14183]    73 14183    16331      359   1       0             0 pickup
[69250.712086] [14615]  1000 14615     5163      267   3       0             0 zsh
[69250.712088] [14621]  1000 14621   119475    11173   0       0             0 chromium
[69250.712090] [14624]  1000 14624     1588      137   2       0             0 chromium-sandbo
[69250.712092] [14625]  1000 14625    69787     1297   1       0             0 chromium
[69250.712094] [14627]  1000 14627    34743      445   2       0             0 nacl_helper_boo
[69250.712096] [14630]  1000 14630    69787     1149   1       0             0 chromium
[69250.712098] [14668]  1000 14668    63912      207   0       0             0 exe
[69250.712100] [14669]     0 14669     3127      177   1       0             0 umount
[69250.712102] Out of memory: Kill process 14621 (chromium) score 11 or sacrifice child
[69250.712108] Killed process 14668 (exe) total-vm:255648kB, anon-rss:708kB, file-rss:120kB

--TB36FDmn/VVEgNH/--
