Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab1KDNpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:45:44 -0400
Received: from nm7.bullet.mail.bf1.yahoo.com ([98.139.212.166]:38162 "HELO
	nm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932417Ab1KDNpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:45:40 -0400
X-Yahoo-Newman-Id: 891428.89629.bm@smtp103.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: g_d7rO4VM1nJHvXzQebIylKmGMCmyj8H9kbWZOGKzDcLhjQ
 6NorGnOGB3qXq.GgND.9V3dyre7u25XjbIAZkL8qGeF8hsqkc40h.oCReiU1
 TG2NjcktTqTjQKPqATSi7lKdw8eaFPReS6mqS34zKuj36JzyxNkHCAlqBpb8
 ufU0vxPBt1zdcREkaTl2uGQi_UXLVwSoL7As0J8RCWqHzRx5fFW7UwQhtbnA
 9mW1njZpaHT7hM3box1ykKps6wZ5q0GCNX1VX5GxG4xGA_UCMVOnRrWj_IAJ
 K9k7Wq87xyVN5ir4Y8FCyKIxQtw29a.KqgvAqo6kjpTWDFWuYmOxE8hoLcvV
 dzyAd70e7qRkt.Dksx4gC7beEPhn0ESytuR1QWVpJH5luFlfhg4fHPqH36xl
 hoEta6izMIItnpwrW4QSFPkRiYA--
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Fri, 4 Nov 2011 08:44:17 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111104134347.GA2480@zeus>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
 <20111102160208.GA6657@zeus>
 <20111102163109.GA29430@core.coreip.homeip.net>
 <20111103155956.GG4417@google.com>
 <20111103184559.GA3295@zeus>
 <20111103213959.GP4417@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20111103213959.GP4417@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 03, 2011 at 02:39:59PM -0700, Tejun Heo wrote:
> 
> This is missing all stack traces.  Can you please turn on
> FRAME_POINTER and adjust log level such that all stack dumps are
> included too?

Hi Tejun.

Sorry about that. My syslogd was sending things to different files and
being unfamiliar with sysrq-t output I thought I was sending it all.

Here's a new sysrq-t snapshot I took about 30 seconds after a bad resume.
Please let me know if I am still missing something you've asked for. 

Hope this sheds some light on what is going on.

~ Andy


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="tejun.txt"

SysRq : Show State
  task                PC stack   pid father
init            S f53c3ad0  5380     1      0 0x00000000
 f5c35ab8 00000086 c183e0b4 f53c3ad0 f5c35ad0 c183e0b4 00000000 f5c35a68
 c11f5f74 f5c35ab8 f5c38000 f5c35a70 c104e0c6 f5c38000 00000066 f5c35ad0
 f5c35aa0 00000296 004c4b3e 00000000 f5c35ad0 00000292 00000000 00000296
Call Trace:
 [<c11f5f74>] ? timerqueue_add+0x54/0xb0
 [<c104e0c6>] ? enqueue_hrtimer+0x1e/0x4d
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d7eb>] schedule_hrtimeout_range_clock+0xab/0x110
 [<c104de53>] ? update_rmtp+0x62/0x62
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e3c2a>] do_select+0x556/0x665
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
 [<c10f5d0e>] ? __find_get_block+0x59/0x140
 [<c10a4297>] ? find_get_page+0x1d/0x88
 [<c10f5e27>] ? __getblk+0x32/0x33d
 [<c11430a2>] ? do_get_write_access+0x25c/0x36c
 [<c1128ae5>] ? __ext3_get_inode_loc+0xa7/0x2a7
 [<c1135a19>] ? __ext3_journal_dirty_metadata+0x19/0x3f
 [<c104b126>] ? wake_up_bit+0x5e/0x62
 [<c1026eed>] ? update_curr+0x164/0x24d
 [<c1030480>] ? dequeue_task_fair+0x180/0x255
 [<c10dd2fa>] ? __follow_mount_rcu+0x3b/0xb5
 [<c10dda39>] ? do_lookup+0x184/0x233
 [<c11998fe>] ? security_inode_exec_permission+0x1d/0x24
 [<c10dda39>] ? do_lookup+0x184/0x233
 [<c10e44c0>] core_sys_select+0x135/0x217
 [<c10de003>] ? putname+0x25/0x33
 [<c10de003>] ? putname+0x25/0x33
 [<c10e1402>] ? user_path_at+0x3f/0x62
 [<c11f9c47>] ? copy_to_user+0x2e/0x119
 [<c10d8cad>] ? cp_new_stat64+0xde/0xf0
 [<c1053354>] ? ktime_get_ts+0xb5/0xd8
 [<c10e4727>] sys_select+0x2c/0xb3
 [<c1593813>] sysenter_do_call+0x12/0x22
kthreadd        S 00000000  7172     2      0 0x00000000
 f5c41fcc 00000046 00000000 00000000 00000000 00800711 f4a0bf08 f5c41f7c
 f5c41fcc f5c41fcc f5c38c50 8854d338 00000057 f5c38c50 00000000 00000000
 00000000 c104ad92 f4a0bf08 00000000 00000000 0000007b 0000007b 00000000
Call Trace:
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593db8>] ? common_interrupt+0x38/0x38
 [<c104ad8c>] kthreadd+0xaa/0xb0
 [<c104ace2>] ? kthread_worker_fn+0xf7/0xf7
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
ksoftirqd/0     S 00000060  7576     3      2 0x00000000
 f5c43fa8 00000046 de370bf1 00000060 de462780 00000060 de462780 f5c43f58
 de370bf1 f5c43fa8 f5c398a0 00000020 00000008 f5c398a0 00000246 00000286
 00000046 00000000 f5c43fa8 c10381bb f5c398a0 00000000 f5c43fa8 00000000
Call Trace:
 [<c10381bb>] ? __do_softirq+0xc3/0x187
 [<c102007b>] ? gup_huge_pmd+0x4f/0xba
 [<c1038310>] run_ksoftirqd+0x91/0xb7
 [<c103827f>] ? __do_softirq+0x187/0x187
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:0     S 00000000  6552     5      2 0x00000000
 f5c4bf88 00000046 00000296 00000000 00000000 f51fa300 00000246 f5c4bf38
 c1050c1f f5c4bf88 f5c3b140 a26a3b4e 00000057 f5c3b140 f5c07380 00000286
 f51fa308 f51fa308 f51fa308 f5c07380 f5c4bf88 c10464da f5c4bf64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
rcu_kthread     S 00000202  7444     6      2 0x00000000
 f5c4df90 00000046 00000000 00000202 c193f600 00021039 f5c4df44 f5c4df40
 c158d121 f5c4df90 f5c3bd90 b48ecaf9 00000063 f5c3bd90 00000286 00000000
 00200200 00021039 c193f600 c103e185 f5c3bd90 ffffffff ffffffff 00000000
Call Trace:
 [<c158d121>] ? schedule_timeout+0x101/0x211
 [<c103e185>] ? sys_gettid+0x13/0x13
 [<c1084869>] rcu_kthread+0x4e/0xaf
 [<c104b12a>] ? wake_up_bit+0x62/0x62
 [<c108481b>] ? rcu_process_callbacks+0x4f/0x4f
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
watchdog/0      S c15983e0  7732     7      2 0x00000000
 f5c4ffac 00000046 c183e0b4 c15983e0 c1840140 4365d43c 0000011a f5c4ff5c
 c104fd22 f5c4ffac f5c3c9e0 a1bfb89e 00000065 f5c3c9e0 00000000 ffffffff
 ffffffff a1bf83e9 00000065 a1bf83e9 00000065 00000000 00000001 00000000
Call Trace:
 [<c104fd22>] ? T.334+0xe/0x1a6
 [<c104ffc3>] ? sched_clock_cpu+0x7c/0xcf
 [<c10819f9>] ? watchdog_enable+0x15e/0x15e
 [<c10819f9>] ? watchdog_enable+0x15e/0x15e
 [<c10819f9>] ? watchdog_enable+0x15e/0x15e
 [<c1081a7f>] watchdog+0x86/0xb1
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
cpuset          S f5c55f58  7696     8      2 0x00000000
 f5c55f84 00000046 0112a880 f5c55f58 c102a472 00000000 0112a365 f5c55f34
 00000000 f5c55f84 f5c3d630 0112a365 00000000 f5c3d630 00000000 00000000
 010b438f 00000000 00000000 00000000 c1598420 f5c3d630 00000000 f5c55f6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
khelper         S f5c57f58  7696     9      2 0x00000000
 f5c57f84 00000046 0112a880 f5c57f58 c102a472 00000000 0112a365 f5c57f34
 00000000 f5c57f84 f5c3e280 0112a365 00000000 f5c3e280 00000000 00000000
 0129c584 00000000 00000000 00000000 c1598420 f5c3e280 00000000 f5c57f6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:1     S 00000000  5800    10      2 0x00000000
 f5c5bf88 00000046 00000296 00000000 00000000 f4bff000 00000246 f5c5bf38
 c1050c1f f5c5bf88 f5c3eed0 017a4d6b 00000001 f5c3eed0 f5c07780 00000286
 f4bff008 f4bff008 f4bff008 f5c07780 f5c5bf88 c10464da f5c5bfbc 00000086
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
netns           S f5c69f58  7696    13      2 0x00000000
 f5c69f84 00000046 0112a880 f5c69f58 c102a472 00000000 0112a365 f5c69f34
 00000000 f5c69f84 f5c618a0 0112a365 00000000 f5c618a0 00000000 00000000
 01854b63 00000000 00000000 00000000 c1598420 f5c618a0 00000000 f5c69f6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
sync_supers     S f5cbdfbc  7712   227      2 0x00000000
 f5cbdfb0 00000046 f5c3eed0 f5cbdfbc c158c95a f5cbdf50 c1831400 f5cbdf60
 00000000 f5cbdfb0 f5cc0000 7079df72 0000005c f5cc0000 01b9ea4a 00000000
 f5cc0000 f5c35f28 f5c35f64 00000000 f5cbdf80 c102fb31 f5cbdfa8 c10265f3
Call Trace:
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c102fb31>] ? default_wake_function+0xb/0xd
 [<c10265f3>] ? __wake_up_common+0x40/0x63
 [<c10b761e>] ? bdi_sched_wait+0xc/0xc
 [<c10b763e>] bdi_sync_supers+0x20/0x35
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
bdi-default     S f5cbfe70  7392   229      2 0x00000000
 f5cbfedc 00000046 00000001 f5cbfe70 c1029e3c f5cc251c c183ae60 f5cbfe8c
 c103015e f5cbfedc f5cc18a0 d432dc83 00000057 f5cc18a0 f5cbfea8 00030222
 d842a1c5 f5cc18a0 d842a1c5 f5cc18a0 f4a5c9e0 f5cbff30 c158c95a ae763538
Call Trace:
 [<c1029e3c>] ? __dequeue_entity+0x31/0x35
 [<c103015e>] ? set_next_entity+0xad/0xc1
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c158d11a>] schedule_timeout+0xfa/0x211
 [<c103e185>] ? sys_gettid+0x13/0x13
 [<c10b8040>] bdi_forker_thread+0x163/0x37f
 [<c10f131f>] ? wb_do_writeback+0x1aa/0x1aa
 [<c10b7edd>] ? bdi_debug_stats_show+0x12a/0x12a
 [<c10b7edd>] ? bdi_debug_stats_show+0x12a/0x12a
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kblockd         S f5cbbf58  7660   231      2 0x00000000
 f5cbbf84 00000046 0112a880 f5cbbf58 c102a472 00000000 01bf7999 f5cbbf34
 00000000 f5cbbf84 f5cc3140 01bf7084 00000000 f5cc3140 00000000 00000000
 1b30fb4e 00000000 00000000 00000000 c1598420 f5cc3140 00000000 f5cbbf6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
ata_sff         S f5cf1f58  7660   318      2 0x00000000
 f5cf1f84 00000046 0112a880 f5cf1f58 c102a472 00000000 05c33ed1 f5cf1f34
 00000000 f5cf1f84 f5c624f0 05c3366b 00000000 f5c624f0 00000000 00000000
 25a917a5 00000000 00000000 00000000 c1598420 f5c624f0 00000000 f5cf1f6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
khubd           S c13f0020  5880   328      2 0x00000000
 f5cfff00 00000046 5d353134 c13f0020 00013a10 f4a51310 00000004 f5cffeb0
 f5cffec0 f5cfff00 f5cc24f0 d432e7f3 00000057 f5cc24f0 c1865650 f5204000
 f5cffec8 c158c4d9 c17a45c0 f5cffed4 f5cffeec c133525b c17a45c0 c1770eab
Call Trace:
 [<c13f0020>] ? usb_free_coherent+0xc/0x27
 [<c158c4d9>] ? printk+0x28/0x2a
 [<c133525b>] ? __dev_printk+0x38/0x72
 [<c13f3d1b>] hub_thread+0xdd4/0x10a8
 [<c1020002>] ? __virt_addr_valid+0x3e/0x68
 [<c104b12a>] ? wake_up_bit+0x62/0x62
 [<c13f2f47>] ? hub_disconnect+0xa1/0xa1
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
md              S f5ce1f58  7660   335      2 0x00000000
 f5ce1f84 00000046 0112a880 f5ce1f58 c102a472 00000000 05d280a2 f5ce1f34
 00000000 f5ce1f84 f5c649e0 05d27744 00000000 f5c649e0 00000000 00000000
 27b15239 00000000 00000000 00000000 c1598420 f5c649e0 00000000 f5ce1f6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
cfg80211        S f5cfdf58  7660   345      2 0x00000000
 f5cfdf84 00000046 0112a880 f5cfdf58 c102a472 00000000 05e79665 f5cfdf34
 00000000 f5cfdf84 f5d03d90 05e04da8 00000000 f5d03d90 00000000 00000000
 28e36376 00000000 00000000 00000000 c1598420 f5d03d90 00000000 f5cfdf6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/0:1     S f5d09f20  6860   346      2 0x00000000
 f5d09f88 00000046 00000720 f5d09f20 c122308c f4a7d400 f5f18400 f5d09f38
 f5d09f50 f5d09f88 f5d049e0 00000007 00000000 f5d049e0 c1228a68 00000000
 00000002 f5f18594 f5f18594 f5ca66c0 f5d09f88 c10464da f5d09f64 c104694b
Call Trace:
 [<c122308c>] ? get_color+0x1a/0x100
 [<c1228a68>] ? bit_putcs+0x41e/0x41e
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1223172>] ? get_color+0x100/0x100
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
rpciod          S f5ce5f58  7660   444      2 0x00000000
 f5ce5f84 00000046 0112a880 f5ce5f58 c102a472 00000000 0a23fc4a f5ce5f34
 00000000 f5ce5f84 f5c60000 0a23ecf5 00000000 f5c60000 00000000 00000000
 347d944e 00000000 00000000 00000000 c1598420 f5c60000 00000000 f5ce5f6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
khungtaskd      S 00000000  7564   461      2 0x00000000
 f5d0bf1c 00000046 00000000 00000000 00000000 367e65f4 f4a118a0 f5d0becc
 00000000 f5d0bf1c f5d024f0 ae063402 00000054 f5d024f0 f5d0bf0c c1030550
 00000000 00000000 00000001 f5c38034 c183ae60 00000001 f5d0befc c1029e3c
Call Trace:
 [<c1030550>] ? dequeue_task_fair+0x250/0x255
 [<c1029e3c>] ? __dequeue_entity+0x31/0x35
 [<c103015e>] ? set_next_entity+0xad/0xc1
 [<c158d11a>] schedule_timeout+0xfa/0x211
 [<c103e185>] ? sys_gettid+0x13/0x13
 [<c158d271>] schedule_timeout_interruptible+0x14/0x23
 [<c108145b>] watchdog+0x3a/0x1ba
 [<c1081421>] ? hung_task_panic+0x11/0x11
 [<c1081421>] ? hung_task_panic+0x11/0x11
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kswapd0         S f5d25ea8  7444   467      2 0x00000000
 f5d25f08 00000046 f5cc24f0 f5d25ea8 f5d25ee4 f5d25ef8 c193f600 f5d25eb8
 f5d25ec4 f5d25f08 f5d018a0 11d9adb8 00000000 f5d018a0 00000000 00000002
 f5d25edc c10a73a0 00000002 00000000 0003bc9c c1874f20 00000002 f5d25f08
Call Trace:
 [<c10a73a0>] ? zone_watermark_ok_safe+0x35/0x3c
 [<c10aeadb>] ? sleeping_prematurely+0xb2/0xe5
 [<c10b197e>] kswapd+0x848/0x909
 [<c1026cee>] ? check_preempt_curr+0x6d/0x7e
 [<c104b12a>] ? wake_up_bit+0x62/0x62
 [<c10b1136>] ? mem_cgroup_shrink_node_zone+0xdd/0xdd
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
fsnotify_mark   S 00000000  7668   532      2 0x00000000
 f5de3f84 00000046 f5cc3d90 00000000 00000000 f5c38000 f5c3bd90 f5de3f34
 00030222 f5de3f84 f5cc3d90 297d5c40 00000007 f5cc3d90 f5de3fbc 00000282
 f51d4b88 f5c05c00 f6fa0a80 f5de3f74 c10ce522 c110067e f6fa4420 f53a1120
Call Trace:
 [<c10ce522>] ? kmem_cache_free+0x98/0xc6
 [<c110067e>] ? inotify_free_mark+0xf/0x11
 [<c110067e>] ? inotify_free_mark+0xf/0x11
 [<c10ff297>] fsnotify_mark_destroy+0xbd/0xed
 [<c104b12a>] ? wake_up_bit+0x62/0x62
 [<c10ff1da>] ? fsnotify_duplicate_mark+0x21/0x21
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
nfsiod          S f5f05f58  7660   544      2 0x00000000
 f5f05f84 00000046 0112a880 f5f05f58 c102a472 00000000 0c1c22e8 f5f05f34
 00000000 f5f05f84 f5d03140 0c1c1955 00000000 f5d03140 00000000 00000000
 406b4d3e 00000000 00000000 00000000 c1598420 f5d03140 00000000 f5f05f6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
crypto          S f5f1bf58  7660   549      2 0x00000000
 f5f1bf84 00000046 0112a880 f5f1bf58 c102a472 00000000 0c245561 f5f1bf34
 00000000 f5f1bf84 f5d06280 0c244ef5 00000000 f5d06280 00000000 00000000
 410460d1 00000000 00000000 00000000 c1598420 f5d06280 00000000 f5f1bf6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
ttm_swap        S f5f15f58  7660   628      2 0x00000000
 f5f15f84 00000046 0112a880 f5f15f58 c102a472 00000000 15e6af05 f5f15f34
 00000000 f5f15f84 f5c63d90 15e69fdf 00000000 f5c63d90 00000000 00000000
 4f4e984b 00000000 00000000 00000000 c1598420 f5c63d90 00000000 f5f15f6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/0:2     S 000ec000  7144   768      2 0x00000000
 f578df88 00000046 c18528a0 000ec000 f578df3c 00000004 00000000 f578df38
 00000000 f578df88 f5c60c50 c970c873 00000054 f5c60c50 00000000 f57801c0
 c183dd00 f578df50 c1852918 f57801c0 f578df88 c10464da f578df64 c104694b
Call Trace:
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1268348>] ? do_blank_screen+0x1ee/0x1ee
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kpsmoused       S f5725f58  7660   776      2 0x00000000
 f5725f84 00000046 0112a880 f5725f58 c102a472 00000000 83a41e53 f5725f34
 00000000 f5725f84 f5c66ed0 83a41658 00000000 f5c66ed0 00000000 00000000
 698ff881 00000000 00000000 00000000 c1598420 f5c66ed0 00000000 f5725f6c
Call Trace:
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c102df09>] ? T.1453+0x48/0x54
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046c11>] rescuer_thread+0x1cc/0x20c
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c1046a45>] ? idle_worker_timeout+0x58/0x58
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kjournald       S 00000059  6524   834      2 0x00000000
 f578ff78 00000046 00000000 00000059 2d0ecba3 00000059 f53e9e40 f578ff28
 f57c5a94 f578ff78 f57b0000 f578ff18 f578ff20 f57b0000 00000000 3234382e
 5d333330 f57c0020 f578ff60 c10265f3 00000744 00000001 00000003 f57c5a40
Call Trace:
 [<c10265f3>] ? __wake_up_common+0x40/0x63
 [<c1146c6d>] kjournald+0x20a/0x337
 [<c104b12a>] ? wake_up_bit+0x62/0x62
 [<c1146a63>] ? commit_timeout+0xa/0xa
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
udevd           S f500de68  6192   866      1 0x00000000
 f500decc 00000086 f53cf2f0 f500de68 0000000a f500deb4 f500deb0 f500de7c
 f500de74 f500decc f57b5630 d7724d1c 00000057 f57b5630 00000040 00000000
 00000000 bf9bc4a0 f500deb8 00000000 f500dea8 00000001 00000000 00000000
Call Trace:
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c11018c1>] ? ep_send_events_proc+0x5c/0xf6
 [<c1101f19>] ? ep_scan_ready_list+0xed/0x108
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c11021dc>] sys_epoll_wait+0x297/0x2fa
 [<c1468b03>] ? sys_recv+0x36/0x38
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c1593813>] sysenter_do_call+0x12/0x22
pccardd         S f5309f24  7344  1052      2 0x00000000
 f5309f84 00000046 f5d018a0 f5309f24 f5309f30 f5309f74 f5148c50 f5309f34
 00000056 f5309f84 f5148c50 d432fc14 00000057 f5148c50 00200200 fffb8eff
 c193f600 c103e185 f5148c50 ffffffff ffffffff 00000000 00000000 00000000
Call Trace:
 [<c103e185>] ? sys_gettid+0x13/0x13
 [<f8366d9e>] pccardd+0x1df/0x33c [pcmcia_core]
 [<f8366bbf>] ? pcmcia_register_socket+0x2b5/0x2b5 [pcmcia_core]
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
pccardd         S f5079f24  7344  1054      2 0x00000000
 f5079f84 00000046 f5148c50 f5079f24 f5079f30 f5079f74 f514bd90 f5079f34
 00000056 f5079f84 f514bd90 d432ff6e 00000057 f514bd90 c1026cee f514a4f0
 00000000 00000292 f5079f6c 00000292 ffffffff 00000000 00000001 01000000
Call Trace:
 [<c1026cee>] ? check_preempt_curr+0x6d/0x7e
 [<f8366d9e>] pccardd+0x1df/0x33c [pcmcia_core]
 [<f8366bbf>] ? pcmcia_register_socket+0x2b5/0x2b5 [pcmcia_core]
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
flush-3:0       S 00000000  6432  1118      2 0x00000000
 f52e3f84 00000046 000003f3 00000000 00000000 00000000 f52e3f24 f52e3f34
 0000000d f52e3f84 f5176280 c10aac6f 0000000d f5176280 00000000 f52e3f84
 c10f1217 00000000 00000000 f5729b64 f5729b04 c103e185 000018e0 00000000
Call Trace:
 [<c10aac6f>] ? global_dirty_limits+0x23/0xb8
 [<c10f1217>] ? wb_do_writeback+0xa2/0x1aa
 [<c103e185>] ? sys_gettid+0x13/0x13
 [<c10f1430>] bdi_writeback_thread+0x111/0x1ca
 [<c10f131f>] ? wb_do_writeback+0x1aa/0x1aa
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
syslogd         S 00000000  6164  1169      1 0x00000000
 f57e1ab8 00000086 00000002 00000000 00000000 01280000 c1831400 f57e1a68
 f57c5a00 f57e1ab8 f51749e0 d8afc9e1 00000057 f51749e0 c19ece40 f57e1aac
 c1128ae5 f5a412b0 f5a19930 f5896000 f57e1aa0 c1135a19 f57e1a98 f5a19930
Call Trace:
 [<c1128ae5>] ? __ext3_get_inode_loc+0xa7/0x2a7
 [<c1135a19>] ? __ext3_journal_dirty_metadata+0x19/0x3f
 [<c10f5d0e>] ? __find_get_block+0x59/0x140
 [<c11288b4>] ? ext3_mark_iloc_dirty+0x1c2/0x34c
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c10f5e27>] ? __getblk+0x32/0x33d
 [<c10e3552>] ? __pollwait+0x59/0xb9
 [<c11430a2>] ? do_get_write_access+0x25c/0x36c
 [<c14eba78>] ? unix_dgram_poll+0x22/0x154
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e3c2a>] do_select+0x556/0x665
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
 [<c11430a2>] ? do_get_write_access+0x25c/0x36c
 [<c1128ae5>] ? __ext3_get_inode_loc+0xa7/0x2a7
 [<c1135a19>] ? __ext3_journal_dirty_metadata+0x19/0x3f
 [<c104b126>] ? wake_up_bit+0x5e/0x62
 [<c1141f59>] ? journal_stop+0x1dc/0x313
 [<c1141f59>] ? journal_stop+0x1dc/0x313
 [<c1129250>] ? ext3_dirty_inode+0x54/0xa8
 [<c1128560>] ? ext3_journal_dirty_data+0x12/0x37
 [<c10f62b7>] ? __block_commit_write+0x66/0x8b
 [<c10f0b3b>] ? __mark_inode_dirty+0x24/0x18f
 [<c10a44ea>] ? unlock_page+0x46/0x49
 [<c112b1f9>] ? ext3_ordered_write_end+0x118/0x1a8
 [<c1128585>] ? ext3_journal_dirty_data+0x37/0x37
 [<c10a3d39>] ? generic_file_buffered_write+0x15d/0x1d6
 [<c10a5ea2>] ? __generic_file_aio_write+0x1dc/0x4a7
 [<c1040506>] ? __sigqueue_free+0x2c/0x2f
 [<c1008466>] ? save_i387_fxsave+0x74/0x81
 [<c10e44c0>] core_sys_select+0x135/0x217
 [<c10083e8>] ? restore_i387_fxsave+0x71/0x7b
 [<c1008644>] ? restore_i387_xstate+0xbe/0x1dd
 [<c1036dde>] ? do_setitimer+0x159/0x182
 [<c11f9c47>] ? copy_to_user+0x2e/0x119
 [<c10e4727>] sys_select+0x2c/0xb3
 [<c1593813>] sysenter_do_call+0x12/0x22
klogd           S 0000004d  6532  1173      1 0x00000000
 f5399ef4 00000086 f5399ea4 0000004d f5939600 f5399e84 00000000 f5399ea4
 f4a18000 f5399ef4 f5170000 0001cea7 f5399e30 f5170000 00000000 00000000
 f5399f50 00000001 00000000 00000000 00000000 f5399ee0 00000000 f50d8780
Call Trace:
 [<c1034516>] do_syslog+0x392/0x3ea
 [<c1199e26>] ? security_file_permission+0x8a/0x8c
 [<c104b12a>] ? wake_up_bit+0x62/0x62
 [<c111c38c>] ? kmsg_poll+0x3b/0x3b
 [<c111c3b3>] kmsg_read+0x27/0x50
 [<c1113c4e>] proc_reg_read+0x39/0x4c
 [<c10d60cc>] vfs_read+0x89/0x14c
 [<c1113c15>] ? proc_reg_write+0x4c/0x4c
 [<c10d623d>] sys_read+0x3d/0x6b
 [<c1593813>] sysenter_do_call+0x12/0x22
inetd           S 00000000  6440  1285      1 0x00000000
 f53a9ab8 00000086 00000000 00000000 00000000 00000000 f5170000 f53a9a68
 00390020 f53a9ab8 f5d00c50 d4337f22 00000057 f5d00c50 00000002 00000000
 00000000 00e40080 f50d9098 f50d9c78 f53a9ab8 c10cdd69 c11430a2 00000002
Call Trace:
 [<c10cdd69>] ? kmem_cache_alloc+0x9d/0xf5
 [<c11430a2>] ? do_get_write_access+0x25c/0x36c
 [<c11ed958>] ? cfq_init_prio_data+0x63/0xf1
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c10cdd69>] ? kmem_cache_alloc+0x9d/0xf5
 [<c10e3552>] ? __pollwait+0x59/0xb9
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e3c2a>] do_select+0x556/0x665
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
last message repeated 3 times
 [<c10d2dd8>] ? T.941+0x3d/0x67
 [<c10d2e54>] ? mem_cgroup_charge_common+0x52/0x60
 [<c1026eed>] ? update_curr+0x164/0x24d
 [<c127048f>] ? extract_buf+0x83/0x109
 [<c1030480>] ? dequeue_task_fair+0x180/0x255
 [<c1029e3c>] ? __dequeue_entity+0x31/0x35
 [<c103015e>] ? set_next_entity+0xad/0xc1
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c10aba4a>] ? ra_submit+0x21/0x27
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c10e44c0>] core_sys_select+0x135/0x217
 [<c10a44ea>] ? unlock_page+0x46/0x49
 [<c10021c4>] ? do_signal+0x5c/0xa11
 [<c10bccd5>] ? handle_pte_fault+0x7a/0x604
 [<c10c20c2>] ? unlink_anon_vmas+0x41/0x97
 [<c10bd2da>] ? handle_mm_fault+0x7b/0xb8
 [<c1590895>] ? do_page_fault+0x191/0x3dc
 [<c10406a7>] ? do_sigaction+0x125/0x156
 [<c10bf057>] ? remove_vma+0x44/0x53
 [<c11f9c47>] ? copy_to_user+0x2e/0x119
 [<c10e4727>] sys_select+0x2c/0xb3
 [<c1002bc6>] ? do_notify_resume+0x4d/0x67
 [<c1593813>] sysenter_do_call+0x12/0x22
sshd            S 00000000  6440  1288      1 0x00000000
 f53abab8 00200086 00000000 00000000 00000000 00000000 f5d00c50 f53aba68
 00390021 f53abab8 f5d05630 d433829a 00000057 f5d05630 00000002 00000000
 00000000 00e40084 f5a4c340 f591f9a0 00000000 f53abad8 c11430a2 00000002
Call Trace:
 [<c11430a2>] ? do_get_write_access+0x25c/0x36c
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c1128ae5>] ? __ext3_get_inode_loc+0xa7/0x2a7
 [<c1135a19>] ? __ext3_journal_dirty_metadata+0x19/0x3f
 [<c10f5d0e>] ? __find_get_block+0x59/0x140
 [<c10e3552>] ? __pollwait+0x59/0xb9
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e3c2a>] do_select+0x556/0x665
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
 [<c10f5d0e>] ? __find_get_block+0x59/0x140
 [<c10f5e27>] ? __getblk+0x32/0x33d
 [<c11430a2>] ? do_get_write_access+0x25c/0x36c
 [<c1128ae5>] ? __ext3_get_inode_loc+0xa7/0x2a7
 [<c1135a19>] ? __ext3_journal_dirty_metadata+0x19/0x3f
 [<c104b126>] ? wake_up_bit+0x5e/0x62
 [<c1141f59>] ? journal_stop+0x1dc/0x313
 [<c1026eed>] ? update_curr+0x164/0x24d
 [<c1141f59>] ? journal_stop+0x1dc/0x313
 [<c11f51e6>] ? rb_erase+0x1e3/0x27a
 [<c1029e3c>] ? __dequeue_entity+0x31/0x35
 [<c103015e>] ? set_next_entity+0xad/0xc1
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c10e44c0>] core_sys_select+0x135/0x217
 [<c10a44ea>] ? unlock_page+0x46/0x49
 [<c10021c4>] ? do_signal+0x5c/0xa11
 [<c10bccd5>] ? handle_pte_fault+0x7a/0x604
 [<c10c20c2>] ? unlink_anon_vmas+0x41/0x97
 [<c10bd2da>] ? handle_mm_fault+0x7b/0xb8
 [<c1590895>] ? do_page_fault+0x191/0x3dc
 [<c10bf057>] ? remove_vma+0x44/0x53
 [<c10bf057>] ? remove_vma+0x44/0x53
 [<c10e4727>] sys_select+0x2c/0xb3
 [<c1002bc6>] ? do_notify_resume+0x4d/0x67
 [<c1593813>] sysenter_do_call+0x12/0x22
acpid           S f530e750  6072  1295      1 0x00000000
 f52e1b50 00000086 00000001 f530e750 00000000 f578a000 f5173140 f52e1b00
 ffffffff f52e1b50 f5d00000 d4dc3330 00000057 f5d00000 000000d0 00011200
 f5734180 00011210 f52e1b3c f52e1b1c c10a627b f52e1b50 c10a636b f578a228
Call Trace:
 [<c10a627b>] ? mempool_alloc_slab+0xe/0x10
 [<c10a636b>] ? mempool_alloc+0x3d/0xc5
 [<c11ef27a>] ? changed_ioprio+0x53/0x53
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c10e3552>] ? __pollwait+0x59/0xb9
 [<c11e1ee3>] ? drive_stat_acct+0xab/0x110
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e4101>] do_sys_poll+0x3c8/0x459
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
 [<c11430a2>] ? do_get_write_access+0x25c/0x36c
 [<c1128ae5>] ? __ext3_get_inode_loc+0xa7/0x2a7
 [<c1135a19>] ? __ext3_journal_dirty_metadata+0x19/0x3f
 [<c104b126>] ? wake_up_bit+0x5e/0x62
 [<c1141f59>] ? journal_stop+0x1dc/0x313
 [<c1141f59>] ? journal_stop+0x1dc/0x313
 [<c1129250>] ? ext3_dirty_inode+0x54/0xa8
 [<c1128560>] ? ext3_journal_dirty_data+0x12/0x37
 [<c10f62b7>] ? __block_commit_write+0x66/0x8b
 [<c10f0b3b>] ? __mark_inode_dirty+0x24/0x18f
 [<c10a44ea>] ? unlock_page+0x46/0x49
 [<c112b1f9>] ? ext3_ordered_write_end+0x118/0x1a8
 [<c1128585>] ? ext3_journal_dirty_data+0x37/0x37
 [<c10a3d39>] ? generic_file_buffered_write+0x15d/0x1d6
 [<c10a5ea2>] ? __generic_file_aio_write+0x1dc/0x4a7
 [<c10d598f>] ? do_sync_write+0x9b/0xc8
 [<c10d8cad>] ? cp_new_stat64+0xde/0xf0
 [<c10fe58d>] ? fsnotify+0x1a0/0x297
 [<c10d5f02>] ? vfs_write+0xea/0x14f
 [<c10d58f4>] ? do_sync_readv_writev+0xbe/0xbe
 [<c10e42ed>] sys_poll+0x5a/0xb6
 [<c1593813>] sysenter_do_call+0x12/0x22
dbus-daemon     S 00000057  6356  1303      1 0x00000000
 f53b1b50 00000086 000ee1df 00000057 00000000 c1838e60 f5c3bd90 f53b1b00
 d47b9921 f53b1b50 f5c65630 e3cd33e6 00000060 f5c65630 c1838e60 00000057
 c183e0d8 f53b1b1c c105815e 00000000 00000057 f53b1b68 c104e50b f53b1b44
Call Trace:
 [<c105815e>] ? tick_program_event+0x1b/0x21
 [<c104e50b>] ? hrtimer_interrupt+0x161/0x24c
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c1015f4b>] ? smp_apic_timer_interrupt+0x46/0x77
 [<c158e45d>] ? apic_timer_interrupt+0x31/0x38
 [<c10e3552>] ? __pollwait+0x59/0xb9
 [<c10e3552>] ? __pollwait+0x59/0xb9
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e4101>] do_sys_poll+0x3c8/0x459
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
last message repeated 4 times
 [<c11f9d5f>] ? _copy_from_user+0x2d/0x10e
 [<c147021f>] ? memcpy_fromiovec+0x3f/0x60
 [<c14ebcc1>] ? scm_destroy+0xd/0x44
 [<c14ec11e>] ? unix_stream_sendmsg+0x30c/0x31c
 [<c1468666>] ? sock_sendmsg+0xcd/0xf5
 [<c100d5f3>] ? p4_pmu_enable_all+0x36/0x44
 [<c11f9d5f>] ? _copy_from_user+0x2d/0x10e
 [<c146ff58>] ? verify_iovec+0x44/0x92
 [<c1469110>] ? sys_sendmsg+0x149/0x253
 [<c105722a>] ? clockevents_program_event+0x80/0x10a
 [<c105815e>] ? tick_program_event+0x1b/0x21
 [<c104e50b>] ? hrtimer_interrupt+0x161/0x24c
 [<c1038054>] ? irq_exit+0x2f/0x7d
 [<c1468fa4>] ? sys_recvmsg+0x36/0x59
 [<c11f9d5f>] ? _copy_from_user+0x2d/0x10e
 [<c1053354>] ? ktime_get_ts+0xb5/0xd8
 [<c10e42ed>] sys_poll+0x5a/0xb6
 [<c1049fed>] ? sys_clock_gettime+0x83/0x96
 [<c1593813>] sysenter_do_call+0x12/0x22
hald            S f5294044  6248  1308      1 0x00000000
 f53b5b50 00000086 c183e0b4 f5294044 f53b5b68 c183e0b4 00000000 f53b5b00
 c11f5f74 f53b5b50 f514e280 f53b5b08 c104e0c6 f514e280 00000067 f53b5b68
 f53b5b38 00000282 01ba796e 00000000 00000000 00000060 00000000 00000282
Call Trace:
 [<c11f5f74>] ? timerqueue_add+0x54/0xb0
 [<c104e0c6>] ? enqueue_hrtimer+0x1e/0x4d
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d7eb>] schedule_hrtimeout_range_clock+0xab/0x110
 [<c104de53>] ? update_rmtp+0x62/0x62
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e4101>] do_sys_poll+0x3c8/0x459
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
last message repeated 12 times
 [<c11f63a8>] ? put_dec+0x87/0x8f
 [<c11f9d5f>] ? _copy_from_user+0x2d/0x10e
 [<c103075c>] ? __enqueue_rt_entity+0x207/0x218
 [<c1469162>] ? sys_sendmsg+0x19b/0x253
 [<c100d5f3>] ? p4_pmu_enable_all+0x36/0x44
 [<c1015865>] ? lapic_next_event+0x16/0x1a
 [<c105722a>] ? clockevents_program_event+0x80/0x10a
 [<c105801a>] ? tick_dev_program_event+0x3c/0x135
 [<c104e171>] ? __run_hrtimer+0x7c/0x189
 [<c105815e>] ? tick_program_event+0x1b/0x21
 [<c1053354>] ? ktime_get_ts+0xb5/0xd8
 [<c10e42ed>] sys_poll+0x5a/0xb6
 [<c1593813>] sysenter_do_call+0x12/0x22
hald            S f77c5c24  7076  1310      1 0x00000000
 f53b9e50 00000086 c158c95a f77c5c24 c1874f20 c1874f20 f514e280 f53b9e00
 f53b9e04 f53b9e50 f514c9e0 d433936c 00000057 f514c9e0 f514c9e0 f514c9e0
 f51d0994 c183ae60 00000001 f53b9e2c c10424b9 f53b9efc f514cd44 f514cd44
Call Trace:
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c1590704>] ? spurious_fault+0xc3/0xc3
 [<c10dc135>] pipe_wait+0x46/0x5d
 [<c104b12a>] ? wake_up_bit+0x62/0x62
 [<c10dc8dd>] pipe_read+0x265/0x3bb
 [<c10021c4>] ? do_signal+0x5c/0xa11
 [<c10d5a57>] do_sync_read+0x9b/0xc8
 [<c10d5ae1>] ? rw_verify_area+0x5d/0x101
 [<c10d60cc>] vfs_read+0x89/0x14c
 [<c10d59bc>] ? do_sync_write+0xc8/0xc8
 [<c10d623d>] sys_read+0x3d/0x6b
 [<c1593813>] sysenter_do_call+0x12/0x22
hald-runner     S c11f5171  6424  1309   1308 0x00000000
 f53b7b50 00000086 c183e0b4 c11f5171 f5294044 c183e0b4 f514e280 f53b7b00
 c183e0b4 f53b7b50 f514d630 d4576448 00000057 f514d630 f53b7b24 c104dfa0
 f53b7b38 00000282 01304a6e 00000000 f53b7b68 00000292 c183e0ac f53b7b44
Call Trace:
 [<c11f5171>] ? rb_erase+0x16e/0x27a
 [<c104dfa0>] ? __remove_hrtimer+0x24/0x81
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c104de53>] ? update_rmtp+0x62/0x62
 [<c10e3552>] ? __pollwait+0x59/0xb9
 [<c1026eed>] ? update_curr+0x164/0x24d
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e4101>] do_sys_poll+0x3c8/0x459
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
 [<c102fb31>] ? default_wake_function+0xb/0xd
 [<c10e3601>] ? pollwake+0x4f/0x56
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c10265f3>] ? __wake_up_common+0x40/0x63
 [<c14ebcc1>] ? scm_destroy+0xd/0x44
 [<c14ec11e>] ? unix_stream_sendmsg+0x30c/0x31c
 [<c1468666>] ? sock_sendmsg+0xcd/0xf5
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c11f9d5f>] ? _copy_from_user+0x2d/0x10e
 [<c146ff58>] ? verify_iovec+0x44/0x92
 [<c1469110>] ? sys_sendmsg+0x149/0x253
 [<c104292b>] ? get_signal_to_deliver+0x87/0x3ac
 [<c10021c4>] ? do_signal+0x5c/0xa11
 [<c10bccd5>] ? handle_pte_fault+0x7a/0x604
 [<c10bd2da>] ? handle_mm_fault+0x7b/0xb8
 [<c1468fa4>] ? sys_recvmsg+0x36/0x59
 [<c11f9d5f>] ? _copy_from_user+0x2d/0x10e
 [<c146937c>] ? sys_socketcall+0xd5/0x289
 [<c10e42ed>] sys_poll+0x5a/0xb6
 [<c1593813>] sysenter_do_call+0x12/0x22
hald-addon-inpu S 02222764  6356  1344   1309 0x00000000
 f53bbb50 00000086 c105722a 02222764 00000000 000f0742 c1831400 f53bbb00
 c1838e60 f53bbb50 f57b0c50 87e6da26 00000065 f57b0c50 c104e171 00000000
 01053453 c1838e60 0000004e c183e0d8 f53bbb28 c105815e 00000000 0000004e
Call Trace:
 [<c105722a>] ? clockevents_program_event+0x80/0x10a
 [<c104e171>] ? __run_hrtimer+0x7c/0x189
 [<c105815e>] ? tick_program_event+0x1b/0x21
 [<c104e50b>] ? hrtimer_interrupt+0x161/0x24c
 [<c105815e>] ? tick_program_event+0x1b/0x21
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c1038054>] ? irq_exit+0x2f/0x7d
 [<c1015f4b>] ? smp_apic_timer_interrupt+0x46/0x77
 [<c10e3552>] ? __pollwait+0x59/0xb9
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e4101>] do_sys_poll+0x3c8/0x459
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
last message repeated 7 times
 [<c11f51e6>] ? rb_erase+0x1e3/0x27a
 [<c1029e3c>] ? __dequeue_entity+0x31/0x35
 [<c103015e>] ? set_next_entity+0xad/0xc1
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c1015865>] ? lapic_next_event+0x16/0x1a
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c100d5f3>] ? p4_pmu_enable_all+0x36/0x44
 [<c1199e26>] ? security_file_permission+0x8a/0x8c
 [<c10d5ae1>] ? rw_verify_area+0x5d/0x101
 [<c10d60cc>] ? vfs_read+0x89/0x14c
 [<c1411eb6>] ? evdev_write+0x9c/0x9c
 [<c10e42ed>] sys_poll+0x5a/0xb6
 [<c1593813>] sysenter_do_call+0x12/0x22
hald-addon-gene S 00000010  6572  1346   1309 0x00000000
 f53bfb50 00000086 c183e0b4 00000010 f5294044 c183e0b4 f57b0c50 f53bfb00
 c183e0b4 f53bfb50 f57b3d90 d433a08e 00000057 f57b3d90 f53bfb24 c104dfa0
 f53bfb38 00000282 017d783e 00000000 f53bfb68 00000292 c183e0ac f53bfb44
Call Trace:
 [<c104dfa0>] ? __remove_hrtimer+0x24/0x81
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c104de53>] ? update_rmtp+0x62/0x62
 [<c10e3552>] ? __pollwait+0x59/0xb9
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e4101>] do_sys_poll+0x3c8/0x459
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
 [<c10ce1aa>] ? __kmalloc_track_caller+0xeb/0x18d
 [<c146b6ec>] ? sock_wfree+0x3f/0x46
 [<c14ebe0a>] ? unix_destruct_scm+0xab/0xb3
 [<c146d3d5>] ? skb_release_data+0x63/0x86
 [<c146d052>] ? __kfree_skb+0x38/0x7b
 [<c14eca98>] ? scm_recv+0x2c/0x139
 [<c146d052>] ? __kfree_skb+0x38/0x7b
 [<c14ece26>] ? unix_stream_recvmsg+0x281/0x4b1
 [<c1026eed>] ? update_curr+0x164/0x24d
 [<c1030480>] ? dequeue_task_fair+0x180/0x255
 [<c1029e3c>] ? __dequeue_entity+0x31/0x35
 [<c103015e>] ? set_next_entity+0xad/0xc1
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c11f9d5f>] ? _copy_from_user+0x2d/0x10e
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c10a511b>] ? filemap_fault+0x8f/0x389
 [<c104292b>] ? get_signal_to_deliver+0x87/0x3ac
 [<c10021c4>] ? do_signal+0x5c/0xa11
 [<c10bccd5>] ? handle_pte_fault+0x7a/0x604
 [<c10d8cad>] ? cp_new_stat64+0xde/0xf0
 [<c10bd2da>] ? handle_mm_fault+0x7b/0xb8
 [<c1590895>] ? do_page_fault+0x191/0x3dc
 [<c1469364>] ? sys_socketcall+0xbd/0x289
 [<c10e4374>] do_restart_poll+0x2b/0x42
 [<c103f71e>] sys_restart_syscall+0x11/0x13
 [<c1593813>] sysenter_do_call+0x12/0x22
hald-addon-acpi S 00000001  6616  1357   1309 0x00000000
 f539bd64 00000086 f5a0ed00 00000001 f539bd20 c10dda39 f57b3d90 f539bd14
 f5880f10 f539bd64 f57b18a0 d433a490 00000057 f57b18a0 c1026eed c1026eed
 f539bdf4 f539bee3 0000000c f20c7a7c 00000003 ffffe80c ffffffff 00000056
Call Trace:
 [<c10dda39>] ? do_lookup+0x184/0x233
 [<c1026eed>] ? update_curr+0x164/0x24d
 [<c1026eed>] ? update_curr+0x164/0x24d
 [<c158d15d>] schedule_timeout+0x13d/0x211
 [<c1029e3c>] ? __dequeue_entity+0x31/0x35
 [<c103015e>] ? set_next_entity+0xad/0xc1
 [<c14ecf14>] unix_stream_recvmsg+0x36f/0x4b1
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c104b12a>] ? wake_up_bit+0x62/0x62
 [<c1467036>] sock_aio_read+0x14a/0x16d
 [<c10d5a57>] do_sync_read+0x9b/0xc8
 [<c10d5ae1>] ? rw_verify_area+0x5d/0x101
 [<c10d617e>] vfs_read+0x13b/0x14c
 [<c10d623d>] sys_read+0x3d/0x6b
 [<c1593813>] sysenter_do_call+0x12/0x22
crond           S f4a1a000  6556  1365      1 0x00000000
 f53b3ef0 00000086 c183e0b4 f4a1a000 f53b3f40 c183e0b4 00000000 f53b3ea0
 c11f5f74 f53b3ef0 f57b6ed0 556da3fa 00000065 f57b6ed0 00000066 f53b3f40
 f53b3ed8 00000282 0000c350 00000000 f53b3ec0 00000001 00000000 00000282
Call Trace:
 [<c11f5f74>] ? timerqueue_add+0x54/0xb0
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d8f3>] do_nanosleep+0x81/0xab
 [<c104ebb3>] hrtimer_nanosleep+0x9c/0x11e
 [<c104de53>] ? update_rmtp+0x62/0x62
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c104ec8c>] sys_nanosleep+0x57/0x5b
 [<c1593813>] sysenter_do_call+0x12/0x22
atd             S f53c1fb4  6532  1367      1 0x00000000
 f53c1f28 00000086 c183e0b4 f53c1fb4 f53c1f54 c183e0b4 00000000 f53c1ed8
 c11f5f74 f53c1f28 f57b6280 d433abd7 00000057 f57b6280 0000034d f53c1f54
 f53c1f10 00000296 00000000 00000000 f57b65e4 00000292 00000000 00000296
Call Trace:
 [<c11f5f74>] ? timerqueue_add+0x54/0xb0
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d8f3>] do_nanosleep+0x81/0xab
 [<c158d95c>] hrtimer_nanosleep_restart+0x3f/0x7a
 [<c104de53>] ? update_rmtp+0x62/0x62
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c103f71e>] sys_restart_syscall+0x11/0x13
 [<c1593813>] sysenter_do_call+0x12/0x22
sendmail        S f53c3ad0  6244  1370      1 0x00000000
 f53c3ab8 00200086 c183e0b4 f53c3ad0 f53c3ad0 c183e0b4 00000000 f53c3a68
 c11f5f74 f53c3ab8 f57b3140 ded80853 00000064 f57b3140 00000066 f53c3ad0
 f53c3aa0 00200296 004c4b3e 00000000 f53c3ad0 00200292 00000000 00200296
Call Trace:
 [<c11f5f74>] ? timerqueue_add+0x54/0xb0
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d7eb>] schedule_hrtimeout_range_clock+0xab/0x110
 [<c104de53>] ? update_rmtp+0x62/0x62
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e3c2a>] do_select+0x556/0x665
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
 [<c127048f>] ? extract_buf+0x83/0x109
 [<c1026eed>] ? update_curr+0x164/0x24d
 [<c10cdcf0>] ? kmem_cache_alloc+0x24/0xf5
 [<c10cdde8>] ? kmem_cache_alloc_trace+0x27/0xf0
 [<c10e7b52>] ? inode_init_always+0xef/0x183
 [<c11f63a8>] ? put_dec+0x87/0x8f
 [<c11f6702>] ? number+0x352/0x366
 [<c1119e0a>] ? devinfo_show+0x22/0x68
 [<c1113984>] ? proc_reg_open+0x61/0xe1
 [<c1199c8c>] ? security_dentry_open+0x65/0x67
 [<c10e44c0>] core_sys_select+0x135/0x217
 [<c10ec9ed>] ? seq_printf+0x27/0x4a
 [<c1119f8b>] ? loadavg_proc_show+0xb0/0xc2
 [<c10fe76b>] ? __fsnotify_inode_delete+0x8/0xd
 [<c111372b>] ? proc_destroy_inode+0x10/0x12
 [<c10e7a4c>] ? destroy_inode+0x26/0x3d
 [<c10e7dc5>] ? evict+0x9a/0xff
 [<c10e4e8b>] ? d_free+0x37/0x49
 [<c10e6c24>] ? dput+0x107/0x1b3
 [<c10b6592>] ? kzfree+0x22/0x25
 [<c1053354>] ? ktime_get_ts+0xb5/0xd8
 [<c10e4727>] sys_select+0x2c/0xb3
 [<c1593813>] sysenter_do_call+0x12/0x22
sendmail        S f50ea000  6176  1373      1 0x00000000
 f53cdfa4 00200086 080950d1 f50ea000 f53cdfac c1590895 f57b3140 f53cdf54
 f57b4c10 f53cdfa4 f57b49e0 d433b2f3 00000057 f57b49e0 00000008 00000004
 00000005 00000000 00000000 bf950b68 bf950b94 00000000 f53cdf9c f53cdf8c
Call Trace:
 [<c1590895>] ? do_page_fault+0x191/0x3dc
 [<c1001eaf>] ? restore_sigcontext+0xc1/0xd9
 [<c10402ce>] sys_pause+0x13/0x1a
 [<c1593813>] sysenter_do_call+0x12/0x22
udevd           S f53bde8c  6592  1379    866 0x00000000
 f53bdecc 00000086 f53bdd84 f53bde8c bf9bb92c 00000000 09c71835 f53bde7c
 f53bdeb4 f53bdecc f5cc5630 d758b9ec 00000057 f5cc5630 00000000 f53bdf48
 c14687bd bf9bc1d4 00000000 00000000 f53bdea8 00000001 00000000 00000000
Call Trace:
 [<c14687bd>] ? sys_sendto+0xf8/0x132
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c1102ab2>] ? signalfd_poll+0x63/0x6d
 [<c11018c1>] ? ep_send_events_proc+0x5c/0xf6
 [<c1101f19>] ? ep_scan_ready_list+0xed/0x108
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c11021dc>] sys_epoll_wait+0x297/0x2fa
 [<c146882d>] ? sys_send+0x36/0x38
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c10bfe18>] ? sys_munmap+0x3a/0x41
 [<c1593813>] sysenter_do_call+0x12/0x22
udevd           S f5cc49e0  6924  1380    866 0x00000000
 f53d1ecc 00000086 00000000 f5cc49e0 f53d1e64 f53d1fb4 ffffffff f53d1e7c
 f53d1eb8 f53d1ecc f5cc49e0 d433bb4d 00000057 f5cc49e0 f52ffe18 f53d1ec4
 f5cc4c94 f53d1f7c f53d1fb4 f5cc49e0 f5cc49e0 77c33025 f5cc4d44 f500b180
Call Trace:
 [<c10021c4>] ? do_signal+0x5c/0xa11
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c11018c1>] ? ep_send_events_proc+0x5c/0xf6
 [<c10bd2da>] ? handle_mm_fault+0x7b/0xb8
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c11021dc>] sys_epoll_wait+0x297/0x2fa
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c1593813>] sysenter_do_call+0x12/0x22
vnstatd         S 00000000  6288  1423      1 0x00000000
 f4801ef0 00000086 c183e0b4 00000000 f4801f40 c183e0b4 00000000 f4801ea0
 c11f5f74 f4801ef0 f5175630 a2be3f8d 00000064 f5175630 00000065 f4801f40
 f4801ed8 00000282 0000c350 00000000 f4801ec4 c10ac018 00000000 00000282
Call Trace:
 [<c11f5f74>] ? timerqueue_add+0x54/0xb0
 [<c10ac018>] ? __put_single_page+0x14/0x17
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d8f3>] do_nanosleep+0x81/0xab
 [<c104ebb3>] hrtimer_nanosleep+0x9c/0x11e
 [<c104de53>] ? update_rmtp+0x62/0x62
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c104ec8c>] sys_nanosleep+0x57/0x5b
 [<c1593813>] sysenter_do_call+0x12/0x22
auditd          S f5170c50  6584  1429      1 0x00000000
 f4805ecc 00000086 c183e0b4 f5170c50 f4805ee4 c183e0b4 00000000 f4805e7c
 c11f5f74 f4805ecc f5170c50 d433bf54 00000057 f5170c50 00000065 f4805ee4
 f4805eb4 00000292 038f9b16 00000000 f5170c50 00000292 00000000 00000292
Call Trace:
 [<c11f5f74>] ? timerqueue_add+0x54/0xb0
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d7eb>] schedule_hrtimeout_range_clock+0xab/0x110
 [<c104de53>] ? update_rmtp+0x62/0x62
 [<c104eb11>] ? hrtimer_start_range_ns+0x21/0x27
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c11021dc>] sys_epoll_wait+0x297/0x2fa
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c1593813>] sysenter_do_call+0x12/0x22
auditd          S c1029e3c  6248  1430      1 0x00000000
 f4807e04 00000086 f4807d94 c1029e3c f514802c c183ae60 f4807db0 f4807db4
 0007ba34 f4807e04 f5176ed0 d433bf54 00000057 f5176ed0 00030222 86cb0d60
 f5176ed0 86cb0d60 f5176ed0 f5170c50 f4807e54 c158c95a 00000003 00000000
Call Trace:
 [<c1029e3c>] ? __dequeue_entity+0x31/0x35
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c10594d8>] futex_wait_queue_me+0xac/0xc8
 [<c1059efc>] ? futex_wait_setup+0x32/0x98
 [<c105a0be>] futex_wait+0x15c/0x22c
 [<c10021c4>] ? do_signal+0x5c/0xa11
 [<c105a29c>] ? futex_wake+0xc7/0xe0
 [<c11f9c47>] ? copy_to_user+0x2e/0x119
 [<c105b0b4>] do_futex+0xd6/0x827
 [<c10f51d8>] ? sys_fstatfs+0x22/0x28
 [<c105b869>] sys_futex+0x64/0xfb
 [<c1593813>] sysenter_do_call+0x12/0x22
kauditd         S f480bf2c  7476  1432      2 0x00000000
 f480bf8c 00000046 f5176280 f480bf2c f480bf30 f480bf7c f5c66280 f480bf3c
 f51db000 f480bf8c f5c66280 d4336124 00000057 f5c66280 f6f9de20 f5071500
 00004401 c146d052 00004482 f5071300 00000000 00000001 00000003 c183fd00
Call Trace:
 [<c146d052>] ? __kfree_skb+0x38/0x7b
 [<c106fdd7>] kauditd_thread+0x103/0x126
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c106fcd4>] ? audit_printk_skb+0x5b/0x5b
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
bash            S f504e100  5800  1615      1 0x00000080
 f480df1c 00000086 f5148364 f504e100 f480deac c119919e f480df1c f480decc
 00000000 f480df1c f5148000 d433bf54 00000057 f5148000 fffb9dbc f5396088
 f53e6034 74529065 c183ae60 d8cf2c78 f5cc6efc f514802c f53e6000 f5148364
Call Trace:
 [<c119919e>] ? security_task_wait+0xf/0x11
 [<c1254bd7>] ? tty_check_change+0xa4/0xa4
 [<c1035c41>] do_wait+0x1aa/0x1ee
 [<c1035ced>] sys_wait4+0x68/0xb1
 [<c10347ca>] ? get_files_struct+0x11/0x11
 [<c1035d5d>] sys_waitpid+0x27/0x29
 [<c1593813>] sysenter_do_call+0x12/0x22
agetty          S f4809e04  6748  1616      1 0x00000080
 f4809e64 00000086 f5148000 f4809e04 00000004 f4809e54 f514a4f0 f4809e14
 00000056 f4809e64 f514a4f0 d433bf54 00000057 f514a4f0 f4809e2c c10424b9
 f4809efc f514a854 f514a854 0804c300 f4809e64 c104261d f4809e98 c158d15d
Call Trace:
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c158d15d>] ? schedule_timeout+0x13d/0x211
 [<c158d15d>] schedule_timeout+0x13d/0x211
 [<c1045e91>] ? start_flush_work+0x14/0xd6
 [<c1046ec9>] ? flush_work+0x13/0x2c
 [<c1257c26>] n_tty_read+0x35d/0x641
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c1253a03>] tty_read+0x71/0x9e
 [<c12578c9>] ? n_tty_open+0x79/0x79
 [<c10d60cc>] vfs_read+0x89/0x14c
 [<c1253992>] ? tty_del_file+0x31/0x31
 [<c10d623d>] sys_read+0x3d/0x6b
 [<c1593813>] sysenter_do_call+0x12/0x22
agetty          S f4803e04  6728  1617      1 0x00000080
 f4803e64 00000086 f514a4f0 f4803e04 00000000 f4803e54 f514eed0 f4803e14
 00000056 f4803e64 f514eed0 d433bf54 00000057 f514eed0 f4803e2c c10424b9
 f4803efc f514f234 f514f234 0804c300 f4803e64 c104261d 00d3abbf c183ae20
Call Trace:
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c158d15d>] schedule_timeout+0x13d/0x211
 [<c1045e91>] ? start_flush_work+0x14/0xd6
 [<c1046ec9>] ? flush_work+0x13/0x2c
 [<c1257c26>] n_tty_read+0x35d/0x641
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c1253a03>] tty_read+0x71/0x9e
 [<c12578c9>] ? n_tty_open+0x79/0x79
 [<c10d60cc>] vfs_read+0x89/0x14c
 [<c1253992>] ? tty_del_file+0x31/0x31
 [<c10d623d>] sys_read+0x3d/0x6b
 [<c1593813>] sysenter_do_call+0x12/0x22
agetty          S f53f3e04  6748  1618      1 0x00000080
 f53f3e64 00000086 f514eed0 f53f3e04 00000000 f53f3e54 f514b140 f53f3e14
 00000056 f53f3e64 f514b140 d433bf54 00000057 f514b140 f53f3e2c c10424b9
 f53f3efc f514b4a4 f514b4a4 0804c300 f53f3e64 c104261d 00d3ae56 c183ae20
Call Trace:
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c158d15d>] schedule_timeout+0x13d/0x211
 [<c1045e91>] ? start_flush_work+0x14/0xd6
 [<c1046ec9>] ? flush_work+0x13/0x2c
 [<c1257c26>] n_tty_read+0x35d/0x641
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c1253a03>] tty_read+0x71/0x9e
 [<c12578c9>] ? n_tty_open+0x79/0x79
 [<c10d60cc>] vfs_read+0x89/0x14c
 [<c1253992>] ? tty_del_file+0x31/0x31
 [<c10d623d>] sys_read+0x3d/0x6b
 [<c1593813>] sysenter_do_call+0x12/0x22
agetty          S f53f5e04  6244  1619      1 0x00000080
 f53f5e64 00000086 f514b140 f53f5e04 00000000 f53f5e54 f51498a0 f53f5e14
 00000056 f53f5e64 f51498a0 d433bf54 00000057 f51498a0 f53f5e2c c10424b9
 f53f5efc f5149c04 f5149c04 0804c300 f53f5e64 c104261d 00d3d8f6 c183ae20
Call Trace:
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c158d15d>] schedule_timeout+0x13d/0x211
 [<c1045e91>] ? start_flush_work+0x14/0xd6
 [<c1046ec9>] ? flush_work+0x13/0x2c
 [<c1257c26>] n_tty_read+0x35d/0x641
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c1253a03>] tty_read+0x71/0x9e
 [<c12578c9>] ? n_tty_open+0x79/0x79
 [<c10d60cc>] vfs_read+0x89/0x14c
 [<c1253992>] ? tty_del_file+0x31/0x31
 [<c10d623d>] sys_read+0x3d/0x6b
 [<c1593813>] sysenter_do_call+0x12/0x22
agetty          S f4965e04  6404  1620      1 0x00000080
 f4965e64 00000086 f51498a0 f4965e04 00000000 f4965e54 f57b24f0 f4965e14
 00000056 f4965e64 f57b24f0 d433bf54 00000057 f57b24f0 f4965e2c c10424b9
 f4965efc f57b2854 f57b2854 0804c300 f4965e64 c104261d 00d3feb8 c183ae20
Call Trace:
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c158d15d>] schedule_timeout+0x13d/0x211
 [<c1045e91>] ? start_flush_work+0x14/0xd6
 [<c1046ec9>] ? flush_work+0x13/0x2c
 [<c1257c26>] n_tty_read+0x35d/0x641
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c1253a03>] tty_read+0x71/0x9e
 [<c12578c9>] ? n_tty_open+0x79/0x79
 [<c10d60cc>] vfs_read+0x89/0x14c
 [<c1253992>] ? tty_del_file+0x31/0x31
 [<c10d623d>] sys_read+0x3d/0x6b
 [<c1593813>] sysenter_do_call+0x12/0x22
startx          S f5ddb180  6392  1635   1615 0x00000080
 f49bbf1c 00000086 f5cc7234 f5ddb180 f49bbeac c119919e f49bbf1c f49bbecc
 00000000 f49bbf1c f5cc6ed0 d433bf54 00000057 f5cc6ed0 fffb9e3c f499c084
 f53e6234 74497065 c183ae60 ecc4532b f5173dbc f5cc6efc f53e6200 f5cc7234
Call Trace:
 [<c119919e>] ? security_task_wait+0xf/0x11
 [<c10bd2da>] ? handle_mm_fault+0x7b/0xb8
 [<c1035c41>] do_wait+0x1aa/0x1ee
 [<c1035ced>] sys_wait4+0x68/0xb1
 [<c10347ca>] ? get_files_struct+0x11/0x11
 [<c1035d5d>] sys_waitpid+0x27/0x29
 [<c1593813>] sysenter_do_call+0x12/0x22
xinit           S f4999f9c  6592  1651   1635 0x00000080
 f4999f34 00000086 b7621ff4 f4999f9c f4999ec4 c119919e f4999f34 f4999ee4
 00000000 f4999f34 f5173d90 d433bf54 00000057 f5173d90 00000000 f5173178
 c183ae20 f51740f4 90bccc61 f51718cc f5173dbc f5173d90 f4999f28 14f4e2c9
Call Trace:
 [<c119919e>] ? security_task_wait+0xf/0x11
 [<c158cefa>] ? wait_for_common+0x80/0xeb
 [<c1035c41>] do_wait+0x1aa/0x1ee
 [<c1035ced>] sys_wait4+0x68/0xb1
 [<c10347ca>] ? get_files_struct+0x11/0x11
 [<c1593813>] sysenter_do_call+0x12/0x22
X               S f499b944  5800  1652   1651 0x00400080
 f499b9a8 00003086 00000000 f499b944 c100d4a4 00000000 00000000 f499b958
 00000000 f499b9a8 f5173140 d7857c56 00000057 f5173140 d8b69880 00000057
 00000001 00000000 f499b9b4 c104dd89 000f4240 00000000 00000000 f499ba68
Call Trace:
 [<c100d4a4>] ? x86_pmu_enable+0x1c9/0x239
 [<c104dd89>] ? hrtimer_forward+0x159/0x18c
 [<c1291301>] ttm_bo_wait_unreserved+0x5f/0x106
 [<c104b12a>] ? wake_up_bit+0x62/0x62
 [<c129145f>] ttm_bo_reserve_locked+0xb7/0xe1
 [<c1292c27>] ttm_bo_reserve+0x26/0x95
 [<c12c3c97>] radeon_crtc_do_set_base+0xbd/0x6d2
 [<c1038054>] ? irq_exit+0x2f/0x7d
 [<c1015f4b>] ? smp_apic_timer_interrupt+0x46/0x77
 [<c158e45d>] ? apic_timer_interrupt+0x31/0x38
 [<c12c42e7>] radeon_crtc_set_base+0x1b/0x1d
 [<c12c430d>] radeon_crtc_mode_set+0x24/0xdd7
 [<c12c3961>] ? radeon_crtc_dpms+0x161/0x34d
 [<c1279c57>] drm_crtc_helper_set_mode+0x32c/0x48b
 [<c1279e2f>] drm_helper_resume_force_mode+0x79/0x23e
 [<c12ace10>] radeon_gpu_reset+0x84/0x98
 [<c12c0838>] radeon_fence_wait+0x2d1/0x311
 [<c104b12a>] ? wake_up_bit+0x62/0x62
 [<c12c0e37>] radeon_sync_obj_wait+0xc/0xe
 [<c12908be>] ttm_bo_wait+0xa1/0x108
 [<c12d6e7b>] radeon_gem_wait_idle_ioctl+0x76/0xc4
 [<c127e62e>] drm_ioctl+0x1c2/0x42c
 [<c12d6e05>] ? radeon_gem_set_tiling_ioctl+0x8e/0x8e
 [<c127e46c>] ? drm_version+0x8a/0x8a
 [<c10e288e>] do_vfs_ioctl+0x79/0x54b
 [<c10d5f02>] ? vfs_write+0xea/0x14f
 [<c10e2dcb>] sys_ioctl+0x6b/0x70
 [<c1593813>] sysenter_do_call+0x12/0x22
xterm           S f49c9aa0  5800  1660   1651 0x00000080
 f49c9ab8 00000086 00000000 f49c9aa0 c158d15d ffffffff f4a124f0 f49c9a68
 448db3e0 f49c9ab8 f51718a0 d6a88ced 00000057 f51718a0 00000000 00000003
 00000001 f5173174 00000000 c183dd00 f49c9ae8 00000000 f49c9a90 c102fb4e
Call Trace:
 [<c158d15d>] ? schedule_timeout+0x13d/0x211
 [<c102fb4e>] ? wake_up_process+0xf/0x11
 [<c158cefa>] ? wait_for_common+0x80/0xeb
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c125a383>] ? put_ldisc+0x3f/0x85
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e3c2a>] do_select+0x556/0x665
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
last message repeated 2 times
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c146a5bf>] ? sock_alloc_send_pskb+0x16d/0x293
 [<c10ce1db>] ? __kmalloc_track_caller+0x11c/0x18d
 [<c146a5bf>] ? sock_alloc_send_pskb+0x16d/0x293
 [<c146dc60>] ? __alloc_skb+0x53/0xf8
 [<c146a5bf>] ? sock_alloc_send_pskb+0x16d/0x293
 [<c11f9d5f>] ? _copy_from_user+0x2d/0x10e
 [<c14ecb61>] ? scm_recv+0xf5/0x139
 [<c14ebcc1>] ? scm_destroy+0xd/0x44
 [<c14ec11e>] ? unix_stream_sendmsg+0x30c/0x31c
 [<c14ece26>] ? unix_stream_recvmsg+0x281/0x4b1
 [<c10e44c0>] core_sys_select+0x135/0x217
 [<c10d5a57>] ? do_sync_read+0x9b/0xc8
 [<c10d5ae1>] ? rw_verify_area+0x5d/0x101
 [<c1253a0d>] ? tty_read+0x7b/0x9e
 [<c10e4727>] sys_select+0x2c/0xb3
 [<c1593813>] sysenter_do_call+0x12/0x22
twm             S 0000004b  5800  1665   1660 0x00000080
 f49d1b50 00000086 c1838e60 0000004b c183e0d8 f49d1aec f51718a0 f49d1b00
 0000004b f49d1b50 f5cc0c50 d433bf54 00000057 f5cc0c50 dea68c3b 0000004b
 00000000 dea68c3b 0000004b deb5bec0 0000004b 00000046 f49d0000 00000000
Call Trace:
 [<c1038054>] ? irq_exit+0x2f/0x7d
 [<c1015f4b>] ? smp_apic_timer_interrupt+0x46/0x77
 [<c104e50b>] ? hrtimer_interrupt+0x161/0x24c
 [<c158d839>] schedule_hrtimeout_range_clock+0xf9/0x110
 [<c104af67>] ? add_wait_queue+0x1d/0x21
 [<c10e3552>] ? __pollwait+0x59/0xb9
 [<c158d862>] schedule_hrtimeout_range+0x12/0x14
 [<c10e346d>] poll_schedule_timeout+0x28/0x3f
 [<c10e4101>] do_sys_poll+0x3c8/0x459
 [<c10e34f9>] ? poll_freewait+0x5a/0x5a
 [<c10e35b2>] ? __pollwait+0xb9/0xb9
 [<c109ad9a>] ? perf_pmu_enable+0x1a/0x21
 [<c102a472>] ? enqueue_task_fair+0x4d4/0x5ae
 [<c146a5bf>] ? sock_alloc_send_pskb+0x16d/0x293
 [<c10ce1db>] ? __kmalloc_track_caller+0x11c/0x18d
 [<c1026eed>] ? update_curr+0x164/0x24d
 [<c146a5bf>] ? sock_alloc_send_pskb+0x16d/0x293
 [<c1030550>] ? dequeue_task_fair+0x250/0x255
 [<c1029e3c>] ? __dequeue_entity+0x31/0x35
 [<c103015e>] ? set_next_entity+0xad/0xc1
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c10424b9>] ? __dequeue_signal+0x13/0xfe
 [<c104261d>] ? dequeue_signal+0x79/0x136
 [<c104292b>] ? get_signal_to_deliver+0x87/0x3ac
 [<c10021c4>] ? do_signal+0x5c/0xa11
 [<c10d5a57>] ? do_sync_read+0x9b/0xc8
 [<c10d5ae1>] ? rw_verify_area+0x5d/0x101
 [<c10e4374>] do_restart_poll+0x2b/0x42
 [<c103f71e>] sys_restart_syscall+0x11/0x13
 [<c1593813>] sysenter_do_call+0x12/0x22
bash            S f49dc580  6548  1670   1660 0x00000080
 f4a05f1c 00000086 f4a10364 f49dc580 f4a05eac c119919e f4a05f1c f4a05ecc
 00000000 f4a05f1c f4a10000 d433bf54 00000057 f4a10000 fffb9a2c f49f2090
 f49ef434 72d7d065 c183ae60 58f1783d f4a1251c f4a1002c f49ef400 f4a10364
Call Trace:
 [<c119919e>] ? security_task_wait+0xf/0x11
 [<c1254bd7>] ? tty_check_change+0xa4/0xa4
 [<c1035c41>] do_wait+0x1aa/0x1ee
 [<c1035ced>] sys_wait4+0x68/0xb1
 [<c10347ca>] ? get_files_struct+0x11/0x11
 [<c1035d5d>] sys_waitpid+0x27/0x29
 [<c1593813>] sysenter_do_call+0x12/0x22
kworker/0:0     S 00000004  7076  1720      2 0x00000080
 f49d3f88 00000046 c12798cd 00000004 f49d3f3c 00000004 00000000 f49d3f38
 00000000 f49d3f88 f4a118a0 00000000 00000246 f4a118a0 00000000 f50f5e40
 c183dd00 f49d3f50 c1852918 f50f5e40 f49d3f88 c10464da f49d3fbc f4a118a0
Call Trace:
 [<c12798cd>] ? output_poll_execute+0x143/0x17b
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c1268348>] ? do_blank_screen+0x1ee/0x1ee
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
bash            S 7f1c0300  5728  1723   1670 0x00000080
 f4a39e64 00000086 00008a31 7f1c0300 01000415 1a131100 170f1200 f4a39e14
 00009600 f4a39e64 f4a124f0 d6b49857 00000057 f4a124f0 f4a39e6c c1259d29
 c183ae20 c183ae60 f4a124f0 c1598420 c183ae20 c1598420 f4a39e48 c1026cee
Call Trace:
 [<c1259d29>] ? tty_mode_ioctl+0x2e4/0x3d7
 [<c1026cee>] ? check_preempt_curr+0x6d/0x7e
 [<c158d15d>] schedule_timeout+0x13d/0x211
 [<c102fb31>] ? default_wake_function+0xb/0xd
 [<c10265f3>] ? __wake_up_common+0x40/0x63
 [<c1045e91>] ? start_flush_work+0x14/0xd6
 [<c1046ec9>] ? flush_work+0x13/0x2c
 [<c1257c26>] n_tty_read+0x35d/0x641
 [<c125bb9b>] ? pty_write+0x54/0x59
 [<c102fb26>] ? try_to_wake_up+0xfe/0xfe
 [<c1253a03>] tty_read+0x71/0x9e
 [<c12578c9>] ? n_tty_open+0x79/0x79
 [<c10d60cc>] vfs_read+0x89/0x14c
 [<c11f9c47>] ? copy_to_user+0x2e/0x119
 [<c1253992>] ? tty_del_file+0x31/0x31
 [<c10d623d>] sys_read+0x3d/0x6b
 [<c1593813>] sysenter_do_call+0x12/0x22
kworker/u:2     S 00000000  6964  1744      2 0x00000080
 ed31df88 00000046 00000296 00000000 00000000 f4bff280 00000246 ed31df38
 c1050c1f ed31df88 f4a13140 b1816d44 00000057 f4a13140 f5124cc0 00000282
 f4bff288 f4bff288 f4bff288 f5124cc0 ed31df88 c10464da ed31df64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:3     S 00000000  6768  1745      2 0x00000080
 ed31ff88 00000046 00000296 00000000 00000000 f51fa7c0 00000246 ed31ff38
 c1050c1f ed31ff88 f4a149e0 a26a4315 00000057 f4a149e0 f53f0c80 00000286
 f51fa7c8 f51fa7c8 f51fa7c8 f53f0c80 ed31ff88 c10464da ed31ffbc f4a149e0
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:4     S 00000000  6404  1746      2 0x00000080
 ed321f88 00000046 00000296 00000000 00000000 f4bff080 00000246 ed321f38
 c1050c1f ed321f88 f4a10c50 a452838d 00000057 f4a10c50 f53f0e40 00000282
 f4bff088 f4bff088 f4bff088 f53f0e40 ed321f88 c10464da ed321fbc f4a10c50
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:5     S 00000000  6768  1747      2 0x00000080
 f4aaff88 00000046 00000296 00000000 00000000 f4bff140 00000246 f4aaff38
 c1050c1f f4aaff88 f4a15630 a452950f 00000057 f4a15630 f5035240 00000282
 f4bff148 f4bff148 f4bff148 f5035240 f4aaff88 c10464da f4aaff64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:6     S 00000000  6768  1748      2 0x00000080
 f4aabf88 00000046 00000296 00000000 00000000 f4bff0c0 00000246 f4aabf38
 c1050c1f f4aabf88 f4a16280 a4528dbe 00000057 f4a16280 f50357c0 00000286
 f4bff0c8 f4bff0c8 f4bff0c8 f50357c0 f4aabf88 c10464da f4aabf64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:7     S 00000000  7120  1749      2 0x00000080
 f4a95f88 00000046 00000296 00000000 00000000 f4bff100 00000246 f4a95f38
 c1050c1f f4a95f88 f4a16ed0 013eb6b5 00000001 f4a16ed0 f5035e80 00000286
 f4bff108 f4bff108 f4bff108 f5035e80 f4a95f88 c10464da f4a95f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:8     S 00000000  6864  1750      2 0x00000080
 f4a93f88 00000046 00000296 00000000 00000000 f4bff040 00000246 f4a93f38
 c1050c1f f4a93f88 f5cc6280 a26a4aa1 00000057 f5cc6280 f5035bc0 00000282
 f4bff048 f4bff048 f4bff048 f5035bc0 f4a93f88 c10464da f4a93f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:9     S 00000000  7120  1751      2 0x00000080
 f4a8ff88 00000046 00000296 00000000 00000000 f4bff240 00000246 f4a8ff38
 c1050c1f f4a8ff88 f5c3a4f0 b1816683 00000057 f5c3a4f0 f5c07340 00000282
 f4bff248 f4bff248 f4bff248 f5c07340 f4a8ff88 c10464da f4a8ff64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:10    S 00000000  7356  1752      2 0x00000080
 f4a8bf88 00000046 00000296 00000000 00000000 f4bff200 00000246 f4a8bf38
 c1050c1f f4a8bf88 f5c63140 b1815fc7 00000057 f5c63140 f50ab600 00000286
 f4bff208 f4bff208 f4bff208 f50ab600 f4a8bf88 c10464da f4a8bf64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:11    S 00000000  6356  1753      2 0x00000080
 f4a7ff88 00000046 00000296 00000000 00000000 f4bff180 00000246 f4a7ff38
 c1050c1f f4a7ff88 f51724f0 b1813911 00000057 f51724f0 f50ab8c0 00000282
 f4bff188 f4bff188 f4bff188 f50ab8c0 f4a7ff88 c10464da f4a7ff64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:12    S 00000000  7356  1754      2 0x00000080
 f4a67f88 00000046 00000296 00000000 00000000 f4bff1c0 00000246 f4a67f38
 c1050c1f f4a67f88 f5d06ed0 b1814195 00000057 f5d06ed0 f50f5980 00000286
 f4bff1c8 f4bff1c8 f4bff1c8 f50f5980 f4a67f88 c10464da f4a67f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:13    S 00000000  6552  1755      2 0x00000080
 f4a61f88 00000046 00000296 00000000 00000000 f51fa680 00000246 f4a61f38
 c1050c1f f4a61f88 f4b60000 9c65ef86 00000057 f4b60000 f50f5300 00000282
 f51fa688 f51fa688 f51fa688 f50f5300 f4a61f88 c10464da f4a61f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:14    S 00000000  7356  1756      2 0x00000080
 f4a53f88 00000046 00000296 00000000 00000000 f51faa40 00000246 f4a53f38
 c1050c1f f4a53f88 f4b60c50 9c65cf58 00000057 f4b60c50 f50f5800 00000282
 f51faa48 f51faa48 f51faa48 f50f5800 f4a53f88 c10464da f4a53f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:15    S 00000000  7136  1757      2 0x00000080
 f4a4bf88 00000046 00000296 00000000 00000000 f50aba00 00000246 f4a4bf38
 c1050c1f f4a4bf88 f4b618a0 9c64f96f 00000057 f4b618a0 f50f5100 00000286
 f50aba08 f50aba08 f50aba08 f50f5100 f4a4bf88 c10464da f4a4bf64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:16    S 00000000  7356  1758      2 0x00000080
 f4a45f88 00000046 00000296 00000000 00000000 f51facc0 00000246 f4a45f38
 c1050c1f f4a45f88 f4b624f0 9c64fbbb 00000057 f4b624f0 f53d9c80 00000286
 f51facc8 f51facc8 f51facc8 f53d9c80 f4a45f88 c10464da f4a45f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:17    S 00000000  6600  1759      2 0x00000080
 f4a3bf88 00000046 00000296 00000000 00000000 f51fac00 00000246 f4a3bf38
 c1050c1f f4a3bf88 f4b63140 9c656ee1 00000057 f4b63140 f53d9f40 00000286
 f51fac08 f51fac08 f51fac08 f53d9f40 f4a3bf88 c10464da f4a3bf64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:18    S 00000000  7356  1760      2 0x00000080
 f4a31f88 00000046 00000296 00000000 00000000 f51fa140 00000246 f4a31f38
 c1050c1f f4a31f88 f4b63d90 9c6540aa 00000057 f4b63d90 f53d9400 00000282
 f51fa148 f51fa148 f51fa148 f53d9400 f4a31f88 c10464da f4a31f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:19    S 00000000  7356  1761      2 0x00000080
 f4a23f88 00000046 00000296 00000000 00000000 f50ab240 00000246 f4a23f38
 c1050c1f f4a23f88 f4b649e0 9c657726 00000057 f4b649e0 f57c99c0 00000282
 f50ab248 f50ab248 f50ab248 f57c99c0 f4a23f88 c10464da f4a23f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:20    S 00000000  7136  1762      2 0x00000080
 f4a07f88 00000046 00000296 00000000 00000000 f51fa240 00000246 f4a07f38
 c1050c1f f4a07f88 f4b65630 9c64f776 00000057 f4b65630 f5124280 00000282
 f51fa248 f51fa248 f51fa248 f5124280 f4a07f88 c10464da f4a07f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:21    S 00000000  6356  1763      2 0x00000080
 f4a03f88 00000046 00000296 00000000 00000000 f50ec500 00000246 f4a03f38
 c1050c1f f4a03f88 f4b66280 89f9f948 00000057 f4b66280 f5124580 00000286
 f50ec508 f50ec508 f50ec508 f5124580 f4a03f88 c10464da f4a03f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:22    S 00000000  6964  1764      2 0x00000080
 f49fbf88 00000046 00000296 00000000 00000000 f50351c0 00000246 f49fbf38
 c1050c1f f49fbf88 f4b66ed0 8fefd5fc 00000057 f4b66ed0 f5124680 00000286
 f50351c8 f50351c8 f50351c8 f5124680 f49fbf88 c10464da f49fbf64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:23    S 00000000  6768  1765      2 0x00000080
 f49f5f88 00000046 00000296 00000000 00000000 f4bff440 00000246 f49f5f38
 c1050c1f f49f5f88 f4ab8000 d246586f 00000057 f4ab8000 f5124180 00000282
 f4bff448 f4bff448 f4bff448 f5124180 f49f5f88 c10464da f49f5f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:24    S 00000000  6768  1766      2 0x00000080
 f49cbf88 00000046 00000296 00000000 00000000 f4bff480 00000246 f49cbf38
 c1050c1f f49cbf88 f4ab8c50 01490187 00000001 f4ab8c50 f5124b00 00000282
 f4bff488 f4bff488 f4bff488 f5124b00 f49cbf88 c10464da f49cbf64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:25    S 00000000  6404  1767      2 0x00000080
 ecf0ff88 00000046 00000296 00000000 00000000 f5035c40 00000246 ecf0ff38
 c1050c1f ecf0ff88 f4ab98a0 9327ce97 00000057 f4ab98a0 f53f0380 00000282
 f5035c48 f5035c48 f5035c48 f53f0380 ecf0ff88 c10464da ecf0ff64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:26    S 00000000  7248  1768      2 0x00000080
 f4aa1f88 00000046 00000296 00000000 00000000 f5035400 00000246 f4aa1f38
 c1050c1f f4aa1f88 f4aba4f0 89f9f948 00000057 f4aba4f0 f53f0ec0 00000286
 f5035408 f5035408 f5035408 f53f0ec0 f4aa1f88 c10464da f4aa1f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:27    S 00000000  6568  1769      2 0x00000080
 f4aa3f88 00000046 00000296 00000000 00000000 f4bff2c0 00000246 f4aa3f38
 c1050c1f f4aa3f88 f4abb140 b18155c9 00000057 f4abb140 f50ec040 00000286
 f4bff2c8 f4bff2c8 f4bff2c8 f50ec040 f4aa3f88 c10464da f4aa3f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:28    S 00000000  6404  1770      2 0x00000080
 f4aa5f88 00000046 00000296 00000000 00000000 f57c94c0 00000246 f4aa5f38
 c1050c1f f4aa5f88 f4abbd90 a2984e4e 00000057 f4abbd90 f50ecc00 00000286
 f57c94c8 f57c94c8 f57c94c8 f50ecc00 f4aa5f88 c10464da f4aa5f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:29    S 00000000  7356  1771      2 0x00000080
 f4aa7f88 00000046 00000296 00000000 00000000 f57c9a80 00000246 f4aa7f38
 c1050c1f f4aa7f88 f4abc9e0 a2983c1a 00000057 f4abc9e0 f50ec200 00000282
 f57c9a88 f57c9a88 f57c9a88 f50ec200 f4aa7f88 c10464da f4aa7f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:30    S 00000000  7120  1772      2 0x00000080
 f4a9bf88 00000046 00000296 00000000 00000000 f50ec3c0 00000246 f4a9bf38
 c1050c1f f4a9bf88 f4abd630 94b5cbac 00000057 f4abd630 f50ec480 00000286
 f50ec3c8 f50ec3c8 f50ec3c8 f50ec480 f4a9bf88 c10464da f4a9bf64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:31    S 00000000  7356  1773      2 0x00000080
 f4a9df88 00000046 00000296 00000000 00000000 f53f08c0 00000246 f4a9df38
 c1050c1f f4a9df88 f4abe280 a298363d 00000057 f4abe280 f50ece00 00000286
 f53f08c8 f53f08c8 f53f08c8 f50ece00 f4a9df88 c10464da f4a9df64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:32    S 00000000  6768  1774      2 0x00000080
 f4a9ff88 00000046 00000296 00000000 00000000 f50ec380 00000246 f4a9ff38
 c1050c1f f4a9ff88 f4abeed0 8f0344ea 00000057 f4abeed0 f50ecd40 00000282
 f50ec388 f50ec388 f50ec388 f50ecd40 f4a9ff88 c10464da f4a9ff64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:33    S 00000000  6864  1775      2 0x00000080
 f4a85f88 00000046 00000296 00000000 00000000 f53f0900 00000246 f4a85f38
 c1050c1f f4a85f88 f4a58000 a2982d61 00000057 f4a58000 f50ec300 00000286
 f53f0908 f53f0908 f53f0908 f50ec300 f4a85f88 c10464da f4a85f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:34    S 00000000  6404  1776      2 0x00000080
 f4a87f88 00000046 00000296 00000000 00000000 f4bff300 00000246 f4a87f38
 c1050c1f f4a87f88 f4a58c50 d2463928 00000057 f4a58c50 f50ec840 00000286
 f4bff308 f4bff308 f4bff308 f50ec840 f4a87f88 c10464da f4a87f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/0:3     S 000ef000  7672  1777      2 0x00000080
 f4a2df88 00000046 c18528a0 000ef000 f4a2df3c 00000004 00000000 f4a2df38
 00000000 f4a2df88 f4a598a0 a08b84d0 00000057 f4a598a0 00000000 f50ec7c0
 c183dd00 f4a2df50 c1852918 f50ec7c0 f4a2df88 c10464da f4a2dfbc f4a598a0
Call Trace:
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c1268348>] ? do_blank_screen+0x1ee/0x1ee
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:35    S 00000000  7356  1783      2 0x00000080
 f4b41f88 00000046 00000296 00000000 00000000 f4bff340 00000246 f4b41f38
 c1050c1f f4b41f88 f4a5b140 d2464186 00000057 f4a5b140 f4bff540 00000282
 f4bff348 f4bff348 f4bff348 f4bff540 f4b41f88 c10464da f4b41f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:36    S 00000000  7356  1784      2 0x00000080
 f4a41f88 00000046 00000296 00000000 00000000 f4bff380 00000246 f4a41f38
 c1050c1f f4a41f88 f4a5bd90 d246605f 00000057 f4a5bd90 f4bff5c0 00000282
 f4bff388 f4bff388 f4bff388 f4bff5c0 f4a41f88 c10464da f4a41f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:37    S 00000000  7356  1785      2 0x00000080
 f4a2ff88 00000046 00000296 00000000 00000000 f4bff3c0 00000246 f4a2ff38
 c1050c1f f4a2ff88 f4a5a4f0 d24647bd 00000057 f4a5a4f0 f4bff640 00000286
 f4bff3c8 f4bff3c8 f4bff3c8 f4bff640 f4a2ff88 c10464da f4a2ff64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:38    S 00000000  7356  1786      2 0x00000080
 f4a09f88 00000046 00000296 00000000 00000000 f4bff400 f5c398a0 f4a09f38
 c1050c1f f4a09f88 f4a5d630 d453d2bf 00000057 f4a5d630 f4bff6c0 00000286
 f4bff408 f4bff408 f4bff408 f4bff6c0 f4a09f88 c10464da f4a09f64 c104694b
Call Trace:
 [<c1050c1f>] ? async_run_entry_fn+0xbe/0x14f
 [<c10464da>] ? process_one_work+0x173/0x366
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1050b61>] ? async_schedule+0xf/0xf
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:39    S c183ae20  7372  1787      2 0x00000080
 f4a0bf88 00000046 c1598420 c183ae20 c1598420 f4a0bf28 c1026cee f4a0bf38
 00000000 f4a0bf88 f4a5e280 92daeea9 00000057 f4a5e280 00000001 01ffffff
 00000001 f4bff7c0 c19406e0 f4bff7c0 f4a0bf58 c102fb4e f4a0bf64 c104694b
Call Trace:
 [<c1026cee>] ? check_preempt_curr+0x6d/0x7e
 [<c102fb4e>] ? wake_up_process+0xf/0x11
 [<c104694b>] ? start_worker+0x20/0x23
 [<c1047bdc>] ? manage_workers+0x2a5/0x314
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
kworker/u:40    S 00000000  7672  1788      2 0x00000080
 f4a0df88 00000046 00000000 00000000 f4a5e280 f4a5e2ac f4a0df34 f4a0df38
 8a803bad f4a0df88 f4a5eed0 89f9f948 00000057 f4a5eed0 c158c95a f4a0df50
 c1026cee f4a0df50 c10475d6 f4a5e280 f4a0df6c 00000082 f4a0dfbc f4a5eed0
Call Trace:
 [<c158c95a>] ? schedule+0x29a/0x614
 [<c1026cee>] ? check_preempt_curr+0x6d/0x7e
 [<c10475d6>] ? wq_worker_waking_up+0xb/0x26
 [<c1047df7>] worker_thread+0x1ac/0x323
 [<c1047c4b>] ? manage_workers+0x314/0x314
 [<c104adf9>] kthread+0x67/0x69
 [<c104ad92>] ? kthreadd+0xb0/0xb0
 [<c1593dbe>] kernel_thread_helper+0x6/0xd
Sched Debug Version: v0.10, 2.6.39.4 #19
ktime                                   : 436994.538124
sched_clk                               : 436808.124081
cpu_clk                                 : 436986.131748
jiffies                                 : 136985
sched_clock_stable                      : 0

sysctl_sched
  .sysctl_sched_latency                    : 6.000000
  .sysctl_sched_min_granularity            : 0.750000
  .sysctl_sched_wakeup_granularity         : 1.000000
  .sysctl_sched_child_runs_first           : 0
  .sysctl_sched_features                   : 7279
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 2667.072 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 67740
  .nr_load_updates               : 32576
  .nr_uninterruptible            : 0
  .next_balance                  : 0.000000
  .curr->pid                     : 0
  .clock                         : 436505.393605
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 768
  .cpu_load[2]                   : 448
  .cpu_load[3]                   : 240
  .cpu_load[4]                   : 124
  .yld_count                     : 159
  .sched_switch                  : 0
  .sched_count                   : 67985
  .sched_goidle                  : 13458
  .ttwu_count                    : 4
  .ttwu_local                    : 4
  .bkl_count                     : 0

cfs_rq[0]:/
  .exec_clock                    : 18313.884391
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 17397.193868
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_spread_over                : 1709
  .nr_running                    : 0
  .load                          : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

SysRq : Emergency Sync
Emergency Sync complete

--nFreZHaLTZJo0R7j--
