Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab1JGBOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 21:14:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab1JGBOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 21:14:21 -0400
Date: Fri, 7 Oct 2011 12:14:10 +1100
From: NeilBrown <neilb@suse.de>
To: =?UTF-8?B?0JLQsNC70LXRgNC40Lk=?= <paramonov@russia.ru>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
        duaneg@dghda.com
Subject: Re: BUG: spinlock lockup while performing FS operations
Message-ID: <20111007121410.53948c42@notabene.brown>
In-Reply-To: <4E8DA415.8090007@russia.ru>
References: <4E8DA415.8090007@russia.ru>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hNgepwMnoJReQeP6W6us2Op"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hNgepwMnoJReQeP6W6us2Op
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 06 Oct 2011 19:50:29 +0700 =D0=92=D0=B0=D0=BB=D0=B5=D1=80=D0=B8=D0=
=B9 <paramonov@russia.ru> wrote:

> Hi!
>=20
> Faced with this problem. There are RAID5, assembled by mdadm (/dev/md127),
> which is divided into 2 partitions (md127p1 and md127p2). In both reiserf=
s. The
> second partition is exported via NFS. Everything works, the array is inta=
ct and
> fully synchronized. SMART says disks are healthy. But when copy too many =
files
> all hangs and saves only the reset. After a reset of course runs fsck, an=
d then
> synchronize the array.
>=20
> I have a brand new computer. Sleaze is not set. Motherboard gigabyte 870-=
UD3,
> Power Supply FSP 700W, memory 16Gb Kingston, CPU Phenom II X6 1090T.
>=20
> I  reported an error  on  bugs.gentoo.org: https://bugs.gentoo.org/show_b=
ug.cgi?id=3D385047
> Was  compiling a custom kernel  with support for  debugging and  debug me=
ssages are  received.
> Duane Griffin  then  sent me  upstream.
>=20
> Now I have have BUG spinlock lockup on screen:
>=20
> Nov 26 13:34:46 localhost kernel: BUG: spinlock lockup on CPU#2, mc/7609,=
 ffff880419c37200
> Oct  4 15:55:50 localhost kernel: BUG: spinlock lockup on CPU#3, flush-9:=
127/2391, ffff880419c37200

Nov 26 ???
Why are there dates from last year in the middle of you log?  Have you
edited the log at all, or joined different bits together??


Please make sure that you provide complete logs, including where possible a
few lines before and after the bit that you think is important.

If the clock is really jumping around, then maybe that is confusing some
timing for the measuring of whether a task has 'hung' or not.

Can you get a complete trace without any sudden changes in the system time?

NeilBrown



>=20
> Full log from /var/log/messages:
>=20
> Oct  4 15:53:09 localhost kernel: INFO: rcu_preempt_state detected stalls=
 on CPUs/tasks: { 0 2} (detected by 5, t=3D60028 jiffies)
> Oct  4 15:53:15 localhost kernel: INFO: rcu_bh_state detected stalls on C=
PUs/tasks: { 0 2 3} (detected by 5, t=3D60025 jiffies)
> Oct  4 15:55:25 localhost kernel: INFO: task sync_supers:151 blocked for =
more than 120 seconds.
> Oct  4 15:55:25 localhost kernel: "echo 0>  /proc/sys/kernel/hung_task_ti=
meout_secs" disables this message.
> Oct  4 15:55:25 localhost kernel: sync_supers     D 0000000000000000     =
0   151      2 0x00000000
> Oct  4 15:55:25 localhost kernel: ffff88042dba5740 0000000000000046 fffff=
fff81493e95 0000000000000008
> Oct  4 15:55:25 localhost kernel: ffff88042dba8000 00000000000001ec 00000=
00000010b40 ffff88042dba8000
> Oct  4 15:55:25 localhost kernel: 0000000000010b40 ffff88042dba5fd8 ffff8=
8042dba4000 0000000000004000
> Oct  4 15:55:25 localhost kernel: Call Trace:
> Oct  4 15:55:25 localhost kernel: [<ffffffff81493e95>] ? schedule+0x695/0=
xa10
> Oct  4 15:55:25 localhost kernel: [<ffffffff8107b462>] ? mark_held_locks+=
0x72/0xa0
> Oct  4 15:55:25 localhost kernel: [<ffffffff8103fa41>] ? get_parent_ip+0x=
11/0x50
> Oct  4 15:55:25 localhost kernel: [<ffffffff8138de22>] get_active_stripe+=
0x312/0x6f0
> Oct  4 15:55:25 localhost kernel: [<ffffffff8103e7f0>] ? try_to_wake_up+0=
x2d0/0x2d0
> Oct  4 15:55:25 localhost kernel: [<ffffffff81391bb8>] make_request+0x1a8=
/0x720
> Oct  4 15:55:25 localhost kernel: [<ffffffff81064430>] ? wake_up_bit+0x40=
/0x40
> Oct  4 15:55:25 localhost kernel: [<ffffffff8139c6be>] md_make_request+0x=
16e/0x2f0
> Oct  4 15:55:25 localhost kernel: [<ffffffff8139c5a8>] ? md_make_request+=
0x58/0x2f0
> Oct  4 15:55:25 localhost kernel: [<ffffffff810fcbb3>] ? kmem_cache_alloc=
+0x33/0xc0
> Oct  4 15:55:25 localhost kernel: [<ffffffff81242dac>] generic_make_reque=
st+0x14c/0x2f0
> Oct  4 15:55:25 localhost kernel: [<ffffffff81242fb1>] submit_bio+0x61/0x=
d0
> Oct  4 15:55:25 localhost kernel: [<ffffffff81131e26>] submit_bh+0xe6/0x1=
20
> Oct  4 15:55:25 localhost kernel: [<ffffffff81192c8b>] write_ordered_chun=
k+0x5b/0x90
> Oct  4 15:55:25 localhost kernel: [<ffffffff81192bfc>] add_to_chunk+0x4c/=
0x80
> Oct  4 15:55:25 localhost kernel: [<ffffffff81192c30>] ? add_to_chunk+0x8=
0/0x80
> Oct  4 15:55:25 localhost kernel: [<ffffffff8119407d>] write_ordered_buff=
ers.clone.31+0x8d/0x2a0
> Oct  4 15:55:25 localhost kernel: [<ffffffff8107b60d>] ? trace_hardirqs_o=
n+0xd/0x10
> Oct  4 15:55:25 localhost kernel: [<ffffffff8119444f>] flush_commit_list+=
0x1bf/0x6e0
> Oct  4 15:55:25 localhost kernel: [<ffffffff811984d4>] do_journal_end.clo=
ne.34+0xdb4/0xf20
> Oct  4 15:55:25 localhost kernel: [<ffffffff810d4b90>] ? bdi_sched_wait+0=
x10/0x10
> Oct  4 15:55:25 localhost kernel: [<ffffffff81198f54>] journal_end_sync+0=
x64/0x70
> Oct  4 15:55:25 localhost kernel: [<ffffffff81186178>] reiserfs_sync_fs+0=
x58/0x70
> Oct  4 15:55:25 localhost kernel: [<ffffffff8149608f>] ? down_read+0x2f/0=
x50
> Oct  4 15:55:25 localhost kernel: [<ffffffff8118619e>] reiserfs_write_sup=
er+0xe/0x10
> Oct  4 15:55:25 localhost kernel: [<ffffffff81109cca>] sync_supers+0xfa/0=
x100
> Oct  4 15:55:25 localhost kernel: [<ffffffff810d4bd1>] bdi_sync_supers+0x=
41/0x60
> Oct  4 15:55:25 localhost kernel: [<ffffffff810d4b90>] ? bdi_sched_wait+0=
x10/0x10
> Oct  4 15:55:25 localhost kernel: [<ffffffff81063f36>] kthread+0x96/0xa0
> Oct  4 15:55:25 localhost kernel: [<ffffffff81499194>] kernel_thread_help=
er+0x4/0x10
> Oct  4 15:55:25 localhost kernel: [<ffffffff810368b0>] ? finish_task_swit=
ch+0x80/0x110
> Oct  4 15:55:25 localhost kernel: [<ffffffff814978c4>] ? retint_restore_a=
rgs+0xe/0xe
> Oct  4 15:55:25 localhost kernel: [<ffffffff81063ea0>] ? __init_kthread_w=
orker+0x70/0x70
> Oct  4 15:55:25 localhost kernel: [<ffffffff81499190>] ? gs_change+0xb/0xb
> Oct  4 15:55:25 localhost kernel: 2 locks held by sync_supers/151:
> Oct  4 15:55:25 localhost kernel: #0:  (&type->s_umount_key#18){+++++.}, =
at: [<ffffffff81109c53>] sync_supers+0x83/0x100
> Oct  4 15:55:25 localhost kernel: #1:  (&jl->j_commit_mutex){+.+...}, at:=
 [<ffffffff811943c8>] flush_commit_list+0x138/0x6e0
> Oct  4 15:55:25 localhost kernel: INFO: task md127_resync:3773 blocked fo=
r more than 120 seconds.
> Oct  4 15:55:25 localhost kernel: "echo 0>  /proc/sys/kernel/hung_task_ti=
meout_secs" disables this message.
> Oct  4 15:55:25 localhost kernel: md127_resync    D 0000000000000000     =
0  3773      2 0x00000000
> Oct  4 15:55:25 localhost kernel: ffff88041880fbb0 0000000000000046 fffff=
fff81493e95 0000000000000000
> Oct  4 15:55:25 localhost kernel: 0000000000000000 ffff88041822e158 00000=
00000010b40 ffff88042d935b20
> Oct  4 15:55:25 localhost kernel: 0000000000010b40 ffff88041880ffd8 ffff8=
8041880e000 0000000000004000
> Oct  4 15:55:25 localhost kernel: Call Trace:
> Oct  4 15:55:25 localhost kernel: [<ffffffff81493e95>] ? schedule+0x695/0=
xa10
> Oct  4 15:55:25 localhost kernel: [<ffffffff8103fa41>] ? get_parent_ip+0x=
11/0x50
> Oct  4 15:55:25 localhost kernel: [<ffffffff81494742>] schedule_timeout+0=
x152/0x220
> Oct  4 15:55:25 localhost kernel: [<ffffffff81053490>] ? run_timer_softir=
q+0x2c0/0x2c0
> Oct  4 15:55:25 localhost kernel: [<ffffffff81494829>] schedule_timeout_u=
ninterruptible+0x19/0x20
> Oct  4 15:55:25 localhost kernel: [<ffffffff81053d58>] msleep+0x18/0x20
> Oct  4 15:55:25 localhost kernel: [<ffffffff8139dc7c>] md_do_sync+0x93c/0=
xd60
> Oct  4 15:55:25 localhost kernel: [<ffffffff8149743b>] ? _raw_spin_unlock=
_irq+0x2b/0x60
> Oct  4 15:55:25 localhost kernel: [<ffffffff81064430>] ? wake_up_bit+0x40=
/0x40
> Oct  4 15:55:25 localhost kernel: [<ffffffff81054676>] ? recalc_sigpendin=
g+0x16/0x40
> Oct  4 15:55:25 localhost kernel: [<ffffffff8139e3e6>] md_thread+0x116/0x=
150
> Oct  4 15:55:25 localhost kernel: [<ffffffff814974ad>] ? _raw_spin_unlock=
_irqrestore+0x3d/0x70
> Oct  4 15:55:25 localhost kernel: [<ffffffff8139e2d0>] ? md_register_thre=
ad+0x110/0x110
> Oct  4 15:55:25 localhost kernel: [<ffffffff81063f36>] kthread+0x96/0xa0
> Oct  4 15:55:25 localhost kernel: [<ffffffff81499194>] kernel_thread_help=
er+0x4/0x10
> Oct  4 15:55:25 localhost kernel: [<ffffffff810368b0>] ? finish_task_swit=
ch+0x80/0x110
> Oct  4 15:55:25 localhost kernel: [<ffffffff814978c4>] ? retint_restore_a=
rgs+0xe/0xe
> Oct  4 15:55:25 localhost kernel: [<ffffffff81063ea0>] ? __init_kthread_w=
orker+0x70/0x70
> Oct  4 15:55:25 localhost kernel: [<ffffffff81499190>] ? gs_change+0xb/0xb
> Oct  4 15:55:25 localhost kernel: no locks held by md127_resync/3773.
> Oct  4 15:55:25 localhost kernel: INFO: task mc:7609 blocked for more tha=
n 120 seconds.
> Oct  4 15:55:25 localhost kernel: "echo 0>  /proc/sys/kernel/hung_task_ti=
meout_secs" disables this message.
> Oct  4 15:55:25 localhost kernel: mc              D 00000000000213da     =
0  7609   7603 0x00000000
> Oct  4 15:55:25 localhost kernel: 0000000091827364 ffff880418bb9af0 ffff8=
80418bb9af0 ffff880418bb9b00
> Oct  4 15:55:25 localhost kernel: ffff880418bb9b00 ffffffff00000000 00000=
00000000087 0000000000521e7f
> Oct  4 15:55:25 localhost kernel: 00000000000000ca 00000000000000cb 00000=
00000000133 ffff880418bb9bd8
> Oct  4 15:55:25 localhost kernel: Call Trace:
> Oct  4 15:55:25 localhost kernel: [<ffffffff8117b5a8>] ? reiserfs_readpag=
es+0x18/0x20
> Oct  4 15:55:25 localhost kernel: [<ffffffff810c75ad>] ? __do_page_cache_=
readahead+0x20d/0x2c0
> Oct  4 15:55:25 localhost kernel: [<ffffffff810c7455>] ? __do_page_cache_=
readahead+0xb5/0x2c0
> Oct  4 15:55:25 localhost kernel: [<ffffffff812cc920>] ? fbcon_decor_curs=
or+0x150/0x1e0
> Oct  4 15:55:25 localhost kernel: [<ffffffff810c798c>] ? ra_submit+0x1c/0=
x20
> Oct  4 15:55:25 localhost kernel: [<ffffffff810c7a96>] ? ondemand_readahe=
ad+0x106/0x2b0
> Oct  4 15:55:25 localhost kernel: [<ffffffff810c7d0c>] ? page_cache_sync_=
readahead+0x2c/0x40
> Oct  4 15:55:25 localhost kernel: [<ffffffff810be8d8>] ? generic_file_aio=
_read+0x428/0x770
> Oct  4 15:55:25 localhost kernel: [<ffffffff811064c2>] ? do_sync_read+0xd=
2/0x110
> Oct  4 15:55:25 localhost kernel: [<ffffffff8123266c>] ? security_file_pe=
rmission+0x8c/0xa0
> Oct  4 15:55:25 localhost kernel: [<ffffffff81106c33>] ? vfs_read+0xc3/0x=
170
> Oct  4 15:55:25 localhost kernel: [<ffffffff81106d2c>] ? sys_read+0x4c/0x=
90
> Oct  4 15:55:25 localhost kernel: [<ffffffff8149803b>] ? system_call_fast=
path+0x16/0x1b
> Oct  4 15:55:25 localhost kernel: 1 lock held by mc/7609:
> Oct  4 15:55:25 localhost kernel: #0:  (&(&conf->device_lock)->rlock){..-=
...}, at: [<ffffffff8138c862>] release_stripe+0x32/0x60
> Oct  4 15:55:25 localhost kernel: INFO: task kworker/1:2:7644 blocked for=
 more than 120 seconds.
> Oct  4 15:55:25 localhost kernel: "echo 0>  /proc/sys/kernel/hung_task_ti=
meout_secs" disables this message.
> Oct  4 15:55:25 localhost kernel: kworker/1:2     D 0000000000000000     =
0  7644      2 0x00000000
> Oct  4 15:55:25 localhost kernel: ffff88041b761c50 0000000000000046 fffff=
fff81493e95 0000000000000002
> Oct  4 15:55:25 localhost kernel: ffff88041b761c10 0000000000000046 00000=
00000010b40 ffff88041b57ad90
> Oct  4 15:55:25 localhost kernel: 0000000000010b40 ffff88041b761fd8 ffff8=
8041b760000 0000000000004000
> Oct  4 15:55:25 localhost kernel: Call Trace:
> Oct  4 15:55:25 localhost kernel: [<ffffffff81493e95>] ? schedule+0x695/0=
xa10
> Oct  4 15:55:25 localhost kernel: [<ffffffff8103d861>] ? load_balance+0xd=
1/0x830
> Oct  4 15:55:25 localhost kernel: [<ffffffff8107b462>] ? mark_held_locks+=
0x72/0xa0
> Oct  4 15:55:25 localhost kernel: [<ffffffff814959d7>] mutex_lock_nested+=
0x167/0x380
> Oct  4 15:55:25 localhost kernel: [<ffffffff811943c8>] ? flush_commit_lis=
t+0x138/0x6e0
> Oct  4 15:55:25 localhost kernel: [<ffffffff8107b5bd>] ? trace_hardirqs_o=
n_caller+0x12d/0x170
> Oct  4 15:55:25 localhost kernel: [<ffffffff811943c8>] flush_commit_list+=
0x138/0x6e0
> Oct  4 15:55:25 localhost kernel: [<ffffffff8119532a>] flush_async_commit=
s+0x5a/0x70
> Oct  4 15:55:25 localhost kernel: [<ffffffff8105cdcb>] process_one_work+0=
x18b/0x440
> Oct  4 15:55:25 localhost kernel: [<ffffffff8105cd6a>] ? process_one_work=
+0x12a/0x440
> Oct  4 15:55:25 localhost kernel: [<ffffffff811952d0>] ? get_list_bitmap+=
0xc0/0xc0
> Oct  4 15:55:25 localhost kernel: [<ffffffff8105f062>] worker_thread+0x16=
2/0x340
> Oct  4 15:55:25 localhost kernel: [<ffffffff8105ef00>] ? manage_workers.c=
lone.25+0x230/0x230
> Oct  4 15:55:25 localhost kernel: [<ffffffff8105ef00>] ? manage_workers.c=
lone.25+0x230/0x230
> Oct  4 15:55:25 localhost kernel: [<ffffffff81063f36>] kthread+0x96/0xa0
> Oct  4 15:55:25 localhost kernel: [<ffffffff81499194>] kernel_thread_help=
er+0x4/0x10
> Oct  4 15:55:25 localhost kernel: [<ffffffff810368b0>] ? finish_task_swit=
ch+0x80/0x110
> Oct  4 15:55:25 localhost kernel: [<ffffffff814978c4>] ? retint_restore_a=
rgs+0xe/0xe
> Oct  4 15:55:25 localhost kernel: [<ffffffff81063ea0>] ? __init_kthread_w=
orker+0x70/0x70
> Oct  4 15:55:25 localhost kernel: [<ffffffff81499190>] ? gs_change+0xb/0xb
> Oct  4 15:55:25 localhost kernel: 3 locks held by kworker/1:2/7644:
> Oct  4 15:55:25 localhost kernel: #0:  (reiserfs){.+.+..}, at: [<ffffffff=
8105cd6a>] process_one_work+0x12a/0x440
> Oct  4 15:55:25 localhost kernel: #1:  ((&(&journal->j_work)->work)){+.+.=
..}, at: [<ffffffff8105cd6a>] process_one_work+0x12a/0x440
> Oct  4 15:55:25 localhost kernel: #2:  (&jl->j_commit_mutex){+.+...}, at:=
 [<ffffffff811943c8>] flush_commit_list+0x138/0x6e0
> Oct  4 15:55:25 localhost kernel: INFO: task flush-9:127:2391 blocked for=
 more than 120 seconds.
> Oct  4 15:55:25 localhost kernel: "echo 0>  /proc/sys/kernel/hung_task_ti=
meout_secs" disables this message.
> Oct  4 15:55:25 localhost kernel: flush-9:127     D ffffffff8112b988     =
0  2391      2 0x00000000
> Oct  4 15:55:25 localhost kernel: 0000000000000000 ffffffff81897e00 ffff8=
804184bd808 ffff880419c2c980
> Oct  4 15:55:25 localhost kernel: ffff88040367fc80 ffff88042f019800 ffff8=
80419c2c8e0 ffff880419c2c970
> Oct  4 15:55:25 localhost kernel: ffff88040367fd00 ffff88042f019868 ffff8=
8040367fcd0 ffffffff8112c4b3
> Oct  4 15:55:25 localhost kernel: Call Trace:
> Oct  4 15:55:25 localhost kernel: [<ffffffff8112c4b3>] ? writeback_inodes=
_wb+0x83/0x180
> Oct  4 15:55:25 localhost kernel: [<ffffffff8112c86b>] ? wb_writeback+0x2=
bb/0x330
> Oct  4 15:55:25 localhost kernel: [<ffffffff8103fb15>] ? sub_preempt_coun=
t+0x95/0xd0
> Oct  4 15:55:25 localhost kernel: [<ffffffff8112cb20>] ? wb_do_writeback+=
0x240/0x250
> Oct  4 15:55:25 localhost kernel: [<ffffffff8112cbc2>] ? bdi_writeback_th=
read+0x92/0x180
> Oct  4 15:55:25 localhost kernel: [<ffffffff8112cb30>] ? wb_do_writeback+=
0x250/0x250
> Oct  4 15:55:25 localhost kernel: [<ffffffff81063f36>] ? kthread+0x96/0xa0
> Oct  4 15:55:25 localhost kernel: [<ffffffff81499194>] ? kernel_thread_he=
lper+0x4/0x10
> Oct  4 15:55:25 localhost kernel: [<ffffffff810368b0>] ? finish_task_swit=
ch+0x80/0x110
> Oct  4 15:55:25 localhost kernel: [<ffffffff814978c4>] ? retint_restore_a=
rgs+0xe/0xe
> Oct  4 15:55:25 localhost kernel: [<ffffffff81063ea0>] ? __init_kthread_w=
orker+0x70/0x70
> Oct  4 15:55:25 localhost kernel: [<ffffffff81499190>] ? gs_change+0xb/0xb
> Oct  4 15:55:25 localhost kernel: 2 locks held by flush-9:127/2391:
> Oct  4 15:55:25 localhost kernel: #0:  (&type->s_umount_key#24){.+.+..}, =
at: [<ffffffff8112c52c>] writeback_inodes_wb+0xfc/0x180
> Oct  4 15:55:25 localhost kernel: #1:  (&(&conf->device_lock)->rlock){..-=
...}, at: [<ffffffff8138db45>] get_active_stripe+0x35/0x6f0
> Nov 26 13:34:46 localhost -- MARK --
> Nov 26 13:34:46 localhost kernel: BUG: spinlock lockup on CPU#2, mc/7609,=
 ffff880419c37200
> Nov 26 13:34:46 localhost kernel: Pid: 7609, comm: mc Tainted: G        W=
   3.0.4-gentoo-r1 #7
> Nov 26 13:34:46 localhost kernel: Call Trace:
> Nov 26 13:34:46 localhost kernel:<IRQ>   [<ffffffff81267866>] do_raw_spin=
_lock+0x156/0x170
> Nov 26 13:34:46 localhost kernel: [<ffffffff81496cc9>] _raw_spin_lock_irq=
save+0x49/0x60
> Nov 26 13:34:46 localhost kernel: [<ffffffff8138c862>] ? release_stripe+0=
x32/0x60
> Nov 26 13:34:46 localhost kernel: [<ffffffff814974ad>] ? _raw_spin_unlock=
_irqrestore+0x3d/0x70
> Nov 26 13:34:46 localhost kernel: [<ffffffff8138c862>] release_stripe+0x3=
2/0x60
> Nov 26 13:34:46 localhost kernel: [<ffffffff8138e80f>] raid5_end_write_re=
quest+0xcf/0x120
> Nov 26 13:34:46 localhost kernel: [<ffffffff81136318>] bio_endio+0x18/0x30
> Nov 26 13:34:46 localhost syslog-ng[6446]: Log statistics; processed=3D'c=
enter(received)=3D0', processed=3D'center(queued)=3D0', processed=3D'source=
(src)=3D999', processed=3D'destination(console_all)=3D999', processed=3D'de=
stination(messages)=3D999', processed=3D'global(payload_reallocs)=3D0', pro=
cessed=3D'global(sdata_updates)=3D0', processed=3D'src.internal(src#1)=3D2'=
, stamp=3D'src.internal(src#1)=3D2584593286', processed=3D'global(msg_clone=
s)=3D0'
> Nov 26 13:36:43 localhost kernel: [<ffffffff812444fb>] req_bio_endio.clon=
e.39+0x8b/0xd0
> Nov 26 13:36:43 localhost kernel: [<ffffffff81244633>] blk_update_request=
+0xf3/0x500
> Nov 26 13:36:43 localhost kernel: [<ffffffff81244869>] ? blk_update_reque=
st+0x329/0x500
> Nov 26 13:36:43 localhost kernel: [<ffffffff8132f765>] ? ata_scsi_qc_comp=
lete+0x65/0x460
> Nov 26 13:36:43 localhost kernel: [<ffffffff81244a6f>] blk_update_bidi_re=
quest+0x2f/0x90
> Nov 26 13:36:43 localhost kernel: [<ffffffff81244c3a>] blk_end_bidi_reque=
st+0x2a/0x80
> Nov 26 13:36:43 localhost kernel: [<ffffffff81244ccb>] blk_end_request+0x=
b/0x10
> Nov 26 13:36:43 localhost kernel: [<ffffffff81319ab7>] scsi_io_completion=
+0x97/0x5d0
> Nov 26 13:36:43 localhost kernel: [<ffffffff813124c2>] scsi_finish_comman=
d+0xb2/0xe0
> Nov 26 13:36:43 localhost kernel: [<ffffffff813198ad>] scsi_softirq_done+=
0x9d/0x130
> Oct  4 15:55:50 localhost kernel: [<ffffffff81249b4d>] blk_done_softirq+0=
x7d/0x90
> Oct  4 15:55:50 localhost kernel: [<ffffffff8104cbf8>] __do_softirq+0xa8/=
0x140
> Oct  4 15:55:50 localhost kernel: [<ffffffff8149928c>] call_softirq+0x1c/=
0x30
> Oct  4 15:55:50 localhost kernel: [<ffffffff810047b5>] do_softirq+0x85/0x=
c0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8104cf9e>] irq_exit+0x9e/0xc0
> Oct  4 15:55:50 localhost kernel: [<ffffffff810043d1>] do_IRQ+0x61/0xd0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81497813>] common_interrupt+0=
x13/0x13
> Oct  4 15:55:50 localhost kernel:<EOI>   [<ffffffff81497441>] ? _raw_spin=
_unlock_irq+0x31/0x60
> Oct  4 15:55:50 localhost kernel: [<ffffffff8149743b>] ? _raw_spin_unlock=
_irq+0x2b/0x60
> Oct  4 15:55:50 localhost kernel: [<ffffffff8131958e>] scsi_request_fn+0x=
34e/0x400
> Oct  4 15:55:50 localhost kernel: [<ffffffff812424a9>] __blk_run_queue+0x=
19/0x20
> Oct  4 15:55:50 localhost kernel: [<ffffffff812537b5>] cfq_insert_request=
+0x345/0x4d0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81241a56>] __elv_add_request+=
0x126/0x1e0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81245880>] blk_flush_plug_lis=
t+0x1b0/0x200
> Oct  4 15:55:50 localhost kernel: [<ffffffff81493c32>] schedule+0x432/0xa=
10
> Oct  4 15:55:50 localhost kernel: [<ffffffff8103fa41>] ? get_parent_ip+0x=
11/0x50
> Oct  4 15:55:50 localhost kernel: [<ffffffff8103fb15>] ? sub_preempt_coun=
t+0x95/0xd0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8138de22>] get_active_stripe+=
0x312/0x6f0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8103e7f0>] ? try_to_wake_up+0=
x2d0/0x2d0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81391bb8>] make_request+0x1a8=
/0x720
> Oct  4 15:55:50 localhost kernel: [<ffffffff81064430>] ? wake_up_bit+0x40=
/0x40
> Oct  4 15:55:50 localhost kernel: [<ffffffff8139c6be>] md_make_request+0x=
16e/0x2f0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8139c5a8>] ? md_make_request+=
0x58/0x2f0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81242dac>] generic_make_reque=
st+0x14c/0x2f0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8113741a>] ? bvec_alloc_bs+0x=
6a/0x100
> Oct  4 15:55:50 localhost kernel: [<ffffffff81242fb1>] submit_bio+0x61/0x=
d0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8113c3f7>] do_mpage_readpage+=
0x317/0x650
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c8c46>] ? __lru_cache_add+=
0x76/0xc0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8113c89c>] mpage_readpages+0x=
fc/0x150
> Oct  4 15:55:50 localhost kernel: [<ffffffff8117d7a0>] ? restart_transact=
ion+0xb0/0xb0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8117d7a0>] ? restart_transact=
ion+0xb0/0xb0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8117b5a8>] reiserfs_readpages=
+0x18/0x20
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c75ad>] __do_page_cache_re=
adahead+0x20d/0x2c0
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c7455>] ? __do_page_cache_=
readahead+0xb5/0x2c0
> Oct  4 15:55:50 localhost kernel: [<ffffffff812cc920>] ? fbcon_decor_curs=
or+0x150/0x1e0
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c798c>] ra_submit+0x1c/0x20
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c7a96>] ondemand_readahead=
+0x106/0x2b0
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c7d0c>] page_cache_sync_re=
adahead+0x2c/0x40
> Oct  4 15:55:50 localhost kernel: [<ffffffff810be8d8>] generic_file_aio_r=
ead+0x428/0x770
> Oct  4 15:55:50 localhost kernel: [<ffffffff811064c2>] do_sync_read+0xd2/=
0x110
> Oct  4 15:55:50 localhost kernel: [<ffffffff8123266c>] ? security_file_pe=
rmission+0x8c/0xa0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81106c33>] vfs_read+0xc3/0x170
> Oct  4 15:55:50 localhost kernel: [<ffffffff81106d2c>] sys_read+0x4c/0x90
> Oct  4 15:55:50 localhost kernel: [<ffffffff8149803b>] system_call_fastpa=
th+0x16/0x1b
> Oct  4 15:55:50 localhost kernel: BUG: spinlock lockup on CPU#3, flush-9:=
127/2391, ffff880419c37200
> Oct  4 15:55:50 localhost kernel: Pid: 2391, comm: flush-9:127 Tainted: G=
        W   3.0.4-gentoo-r1 #7
> Oct  4 15:55:50 localhost kernel: Call Trace:
> Oct  4 15:55:50 localhost kernel: [<ffffffff81267866>] do_raw_spin_lock+0=
x156/0x170
> Oct  4 15:55:50 localhost kernel: [<ffffffff81496c74>] _raw_spin_lock_irq=
+0x44/0x50
> Oct  4 15:55:50 localhost kernel: [<ffffffff8138db45>] ? get_active_strip=
e+0x35/0x6f0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8138db45>] get_active_stripe+=
0x35/0x6f0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8107b462>] ? mark_held_locks+=
0x72/0xa0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8103fa41>] ? get_parent_ip+0x=
11/0x50
> Oct  4 15:55:50 localhost kernel: [<ffffffff8103fb15>] ? sub_preempt_coun=
t+0x95/0xd0
> Oct  4 15:55:50 localhost kernel: [<ffffffff814974ad>] ? _raw_spin_unlock=
_irqrestore+0x3d/0x70
> Oct  4 15:55:50 localhost kernel: [<ffffffff810646cb>] ? prepare_to_wait+=
0x5b/0x90
> Oct  4 15:55:50 localhost kernel: [<ffffffff81391bb8>] make_request+0x1a8=
/0x720
> Oct  4 15:55:50 localhost kernel: [<ffffffff81064430>] ? wake_up_bit+0x40=
/0x40
> Oct  4 15:55:50 localhost kernel: [<ffffffff8139c6be>] md_make_request+0x=
16e/0x2f0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8139c5a8>] ? md_make_request+=
0x58/0x2f0
> Oct  4 15:55:50 localhost kernel: [<ffffffff810fcbb3>] ? kmem_cache_alloc=
+0x33/0xc0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81242dac>] generic_make_reque=
st+0x14c/0x2f0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81242fb1>] submit_bio+0x61/0x=
d0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81131e26>] submit_bh+0xe6/0x1=
20
> Oct  4 15:55:50 localhost kernel: [<ffffffff811352c7>] __block_write_full=
_page+0x1f7/0x370
> Oct  4 15:55:50 localhost kernel: [<ffffffff81133db0>] ? block_read_full_=
page+0x3b0/0x3b0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81138040>] ? I_BDEV+0x10/0x10
> Oct  4 15:55:50 localhost kernel: [<ffffffff81138040>] ? I_BDEV+0x10/0x10
> Oct  4 15:55:50 localhost kernel: [<ffffffff8113552e>] block_write_full_p=
age_endio+0xee/0x130
> Oct  4 15:55:50 localhost kernel: [<ffffffff8107b462>] ? mark_held_locks+=
0x72/0xa0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81135580>] block_write_full_p=
age+0x10/0x20
> Oct  4 15:55:50 localhost kernel: [<ffffffff81138ef3>] blkdev_writepage+0=
x13/0x20
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c5925>] __writepage+0x15/0=
x50
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c60a1>] write_cache_pages+=
0x1f1/0x420
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c5910>] ? set_page_dirty+0=
x70/0x70
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c6318>] generic_writepages=
+0x48/0x60
> Oct  4 15:55:50 localhost kernel: [<ffffffff810c71ff>] do_writepages+0x1f=
/0x40
> Oct  4 15:55:50 localhost kernel: [<ffffffff8112b5a9>] writeback_single_i=
node+0xf9/0x260
> Oct  4 15:55:50 localhost kernel: [<ffffffff8112b988>] writeback_sb_inode=
s+0xe8/0x1c0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8112c4b3>] writeback_inodes_w=
b+0x83/0x180
> Oct  4 15:55:50 localhost kernel: [<ffffffff8112c86b>] wb_writeback+0x2bb=
/0x330
> Oct  4 15:55:50 localhost kernel: [<ffffffff8103fb15>] ? sub_preempt_coun=
t+0x95/0xd0
> Oct  4 15:55:50 localhost kernel: [<ffffffff8112cb20>] wb_do_writeback+0x=
240/0x250
> Oct  4 15:55:50 localhost kernel: [<ffffffff8112cbc2>] bdi_writeback_thre=
ad+0x92/0x180
> Oct  4 15:55:50 localhost kernel: [<ffffffff8112cb30>] ? wb_do_writeback+=
0x250/0x250
> Oct  4 15:55:50 localhost kernel: [<ffffffff81063f36>] kthread+0x96/0xa0
> Oct  4 15:55:50 localhost kernel: [<ffffffff81499194>] kernel_thread_help=
er+0x4/0x10
> Oct  4 15:55:50 localhost kernel: [<ffffffff810368b0>] ? finish_task_swit=
ch+0x80/0x110
> Oct  4 15:55:50 localhost kernel: [<ffffffff814978c4>] ? retint_restore_a=
rgs+0xe/0xe
> Oct  4 15:55:50 localhost kernel: [<ffffffff81063ea0>] ? __init_kthread_w=
orker+0x70/0x70
> Oct  4 15:55:50 localhost kernel: [<ffffffff81499190>] ? gs_change+0xb/0xb
>=20
> Why  date  a failure  to  report?What next?
> Thanks.
>=20
> ---
> ParamonovValery.


--Sig_/hNgepwMnoJReQeP6W6us2Op
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTo5SYjnsnt1WYoG5AQJzEg//U+whEzbYI3IK2l1Zc13dfY32LHXFertr
NBdpgW1I0kd4XblaJVVAG3XnpmXU1oxdL1SAUxrSO095YNOiTy9DRqipgUbIkC6g
G1SmMtzowXkLwnTnww0eAGxOAFe0lyEgcEOgOZR8SQMAILSuOW/0yQ7nf0V6ehXV
L4iWVh5VJceQqtj6xR2WrihTiGVLIao9/Ud4GTDW6905kzoo8DzZKuvnn4BYfIH8
dDhAPI0Li4ly1nSSoZp8aPaVsVJhZ3oZt4p/VfhqtL822+wzOR4jbzfl1ZSR+Vbo
yaSMrhLfjlEo1224wAF3/tRXKopwRtIJcvOwdg8vCugCtcgTKfxX4MJdEKye9TkT
1pYR4dQacwlI+wzIiAD3s1waXXuQ5K6F2NpkrxpxntUjaU9DINxGd83pp1S1BZJg
PpvRAoHJz6TiAcuZl3lZMoj9JumWF9sHhZYdUQesFJevhWYqAFcLuD8tHSEP9wHq
1ezQ3nosG2SgfqcwdvY5154I61ffjD1IptFDvEBdUrBfvI9nVK7vr/QG9G+u+F8I
/D0RMvCuGpQVQqwn/GfcOYtKuHkdP8nxtaYeki2r4n1LDWPCK6JzYXMK+7C/SZcK
YcAAd1ahB0PLuA0Mtc61O7owSyrimW8BoIW4qqJ+zDnRLQjNJcN7fMqJDl0XeSSH
xXUWzRwuujA=
=Y9i4
-----END PGP SIGNATURE-----

--Sig_/hNgepwMnoJReQeP6W6us2Op--
