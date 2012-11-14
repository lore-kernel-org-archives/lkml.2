Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab2KNVK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:10:59 -0500
Received: from mail.agmk.net ([91.192.224.71]:56752 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab2KNVK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:10:57 -0500
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, arekm@pld-linux.org,
        baggins@pld-linux.org
Subject: Re: [3.6.6] panic on reboot / khungtaskd blocked? (WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule)
Date: Wed, 14 Nov 2012 22:10:46 +0100
Message-ID: <1984533.1jAeFKDqSR@localhost>
User-Agent: KMail/4.9.1 (Linux/3.7.0-rc5; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50A302C9.2060800@linux.vnet.ibm.com>
References: <56378024.A3Kec8xZj0@pawels> <2413953.H7iie8v1th@pawels> <50A302C9.2060800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart19608413.JhNHYpAaty"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart19608413.JhNHYpAaty
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Wednesday 14 of November 2012 10:32:41 Michael Wang wrote:
> On 11/13/2012 05:40 PM, Pawe=C5=82 Sikora wrote:
> > On Monday 12 of November 2012 13:33:39 Pawe=C5=82 Sikora wrote:
> >> On Monday 12 of November 2012 11:22:47 Pawe=C5=82 Sikora wrote:
> >>> On Monday 12 of November 2012 15:40:31 Michael Wang wrote:
> >>>> On 11/12/2012 03:16 PM, Pawe=C5=82 Sikora wrote:
> >>>>> On Monday 12 of November 2012 11:04:12 Michael Wang wrote:
> >>>>>> On 11/09/2012 09:48 PM, Pawe=C5=82 Sikora wrote:
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> during playing with new ups i've caught an nice oops on reboo=
t:
> >>>>>>>
> >>>>>>> http://imgbin.org/index.php?page=3Dimage&id=3D10253
> >>>>>>>
> >>>>>>> probably the upstream is also affected.
> >>>>>>
> >>>>>> Hi, Pawe=C5=82
> >>>>>>
> >>>>>> Are you using a clean 3.6.6 without any modify?
> >>>>>
> >>>>> yes, pure 3.6.6 form git tree with modular config.
> >>>>>
> >>>>>> Looks like some threads has set itself to be UNINTERRUPTIBLE w=
ith out
> >>>>>> any design on switch itself back later(or the time is too long=
), are you
> >>>>>> accidentally using some bad designed module?
> >>>>>
> >>>>> hmm, hard to say. mostly all modules are loaded automatically b=
y kernel.
> >>>>
> >>>> Could you please provide the whole dmesg in text? your picture l=
ost the
> >>>> print info of the hung task.
> >>>
> >>> i've grabbed the console via rs232 but there's no more info (see =
attached txt).
> >>
> >> hmm, i have one observation.
> >>
> >> during rc.shutdown there're messages on console like this: Cannot =
stat file /proc/$pid/fd/1: Connection timed out
> >> afaics this file descriptor points to vnc log file on a remote mac=
hine, e.g.:
> >>
> >> # ps aux|grep xfwm4
> >> eda       1748  0.0  0.0 320220 11224 ?        S    13:08   0:00 x=
fwm4=20
> >>
> >> # readlink -m /proc/1748/fd/1
> >> /remote/dragon/ahome/eda/.vnc/odra:11.log
> >>
> >> # mount|grep ahome
> >> dragon:/home/users/ on /remote/dragon/ahome type nfs (rw,relatime,=
vers=3D3,rsize=3D262144,wsize=3D262144,namlen=3D255,soft,proto=3Dtcp,ti=
meo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D10.0.2.121,mountvers=3D3,mo=
untport=3D45251,mountproto=3Dudp,local_lock=3Dnone,addr=3D10.0.2.121)
> >>
> >>
> >> so, probably during `killall5 -TERM/-KILL` on shutdown stage somet=
hing sometimes go wrong
> >> and these processes (xfce4/vncserver) survive the signal and hang =
on the nfs i/o.
> >>
> >=20
> > ok, now i have full sysrq+w backtraces from shutdown process. i hop=
e i'll help you.
>=20
> This can only tell us what's the task in UNINTERRUPTABLE state, but w=
ith
> out time info, we can't find out which one is the hung task...

attaching backtraces reported by khungtaskd during reboot sequence.

--nextPart19608413.JhNHYpAaty
Content-Disposition: inline; filename="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; name="dmesg.txt"

Please stand by while rebooting the system.........................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
=0DINIT: no more processes left in this runlevel=0D
[  848.178329] INFO: task Xvnc:1983 blocked for more than 120 seconds.
[  848.215849] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
[  848.262754] Xvnc            D ffff88080fc53b40     0  1983      1 0x=
00000002
[  848.305187]  ffff880c0600bb98 0000000000000046 ffff880c09703de0 ffff=
880c0600bfd8
[  848.349904]  ffff880c0600bfd8 ffff880c0600bfd8 ffff880409c6d960 ffff=
880c09703de0
[  848.394576]  ffff880c0600bb98 ffff880c09703de0 ffff88080fc543a0 0000=
000000000002
[  848.439197] Call Trace:
[  848.453824]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  848.486161]  [<ffffffff814a6064>] schedule+0x24/0x70
[  848.515906]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  848.547208]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  848.578989]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  848.611328]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  848.647785]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  848.681689]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  848.720800]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  848.758860]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  848.792249]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  848.832392]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  848.872550]  [<ffffffffa0504379>] nfs_file_fsync+0x39/0x90 [nfs]
[  848.908524]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  848.938797]  [<ffffffffa0504a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  848.974776]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  849.005569]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  849.039467]  [<ffffffff81055735>] exit_files+0x45/0x50
[  849.070257]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  849.100517]  [<ffffffff8112add8>] ? do_munmap+0x328/0x400
[  849.132868]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  849.165209]  [<ffffffff81056712>] sys_exit_group+0x12/0x20
[  849.198078]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  849.234060] sending NMI to all CPUs:
[  849.255486] NMI backtrace for cpu 6
[  849.276384] CPU 6=20
[  849.287360] Pid: 94, comm: khungtaskd Not tainted 3.6.6-dirty #16 Su=
permicro H8DGU/H8DGU
[  849.336862] RIP: 0010:[<ffffffff81036b91>]  [<ffffffff81036b91>] def=
ault_send_IPI_mask_sequence_phys+0x61/0xf0
[  849.396771] RSP: 0018:ffff8804096b7e10  EFLAGS: 00000087
[  849.428545] RAX: 0000000000000020 RBX: 000000000000b022 RCX: 0000000=
000000020
[  849.471237] RDX: 0000000000000008 RSI: 0000000000000020 RDI: 0000000=
000000020
[  849.513932] RBP: ffff8804096b7e50 R08: ffffffff8188bb50 R09: 0000000=
000000000
[  849.556627] R10: 0000000000000000 R11: 0000000000000000 R12: fffffff=
f8188bb50
[  849.599321] R13: 0000000000000400 R14: 0000000000000282 R15: 0000000=
000000002
[  849.642015] FS:  00007ff1f7b14800(0000) GS:ffff88080fc80000(0000) kn=
lGS:00000000f66b0700
[  849.690430] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  849.724802] CR2: 00007f099a748f80 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  849.767498] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  849.810191] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  849.852886] Process khungtaskd (pid: 94, threadinfo ffff8804096b6000=
, task ffff881009c96720)
[  849.903380] Stack:
[  849.915393]  0000000000000017 0000000000000007 ffff8804096b7e70 0000=
000000002710
[  849.959855]  00000000003fff66 0000000000000078 0000000000000366 ffff=
880c09703de0
[  850.004315]  ffff8804096b7e60 ffffffff8103a7b2 ffff8804096b7e80 ffff=
ffff81036d8d
[  850.048779] Call Trace:
[  850.063395]  [<ffffffff8103a7b2>] physflat_send_IPI_all+0x12/0x20
[  850.099849]  [<ffffffff81036d8d>] arch_trigger_all_cpu_backtrace+0x4=
d/0x80
[  850.140983]  [<ffffffff810c6ea7>] watchdog+0x237/0x250
[  850.171714]  [<ffffffff810c6c70>] ? hung_task_panic+0x20/0x20
[  850.206088]  [<ffffffff810727ce>] kthread+0x8e/0xa0
[  850.235264]  [<ffffffff814afa04>] kernel_thread_helper+0x4/0x10
[  850.270676]  [<ffffffff81072740>] ? kthread_freezable_should_stop+0x=
70/0x70
[  850.312331]  [<ffffffff814afa00>] ? gs_change+0x13/0x13
[  850.343582] Code: c7 c3 22 b0 00 00 0f 1f 40 00 83 c2 01 be 20 00 00=
 00 4c 89 e7 48 63 d2 e8 2d de 22 00 89 c2 48 63 05 b8 60 85 00 48 39 c=
2 73 4d <48> 8b 04 d5 60 b5 88 81 41 83 ff 02 0f b7 34 03 74 54 8b 04 2=
5=20
[  850.459863] NMI backtrace for cpu 0
[  850.480765] CPU 0=20
[  850.491740] Pid: 0, comm: swapper/0 Not tainted 3.6.6-dirty #16 Supe=
rmicro H8DGU/H8DGU
[  850.540204] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  850.589762] RSP: 0018:ffffffff81801eb8  EFLAGS: 00000246
[  850.621535] RAX: 0000000000000000 RBX: ffffffff81801fd8 RCX: ffff880=
40fc00000
[  850.664231] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000082
[  850.706925] RBP: ffffffff81801eb8 R08: 0000000000000000 R09: 0000000=
000000000
[  850.749620] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000000
[  850.792313] R13: ffffffff818f42e0 R14: ffff88101ffe0a40 R15: 0000000=
000000000
[  850.835008] FS:  00007f099ac8a700(0000) GS:ffff88040fc00000(0000) kn=
lGS:00000000f5eb5700
[  850.883422] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  850.917794] CR2: 00007f099a748f80 CR3: 000000000180b000 CR4: 0000000=
0000007f0
[  850.960490] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  851.003183] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  851.045877] Process swapper/0 (pid: 0, threadinfo ffffffff81800000, =
task ffffffff81813440)
[  851.095332] Stack:
[  851.107343]  ffffffff81801ed8 ffffffff8101b33a ffffffff81801fd8 ffff=
ffff8188bb50
[  851.151807]  ffffffff81801f08 ffffffff8101bfee ffffffff81801ef8 fce8=
490891c36da2
[  851.196269]  0000000000000000 ffffffff818ea000 ffffffff81801f18 ffff=
ffff8147f609
[  851.240731] Call Trace:
[  851.255348]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  851.287639]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  851.317853]  [<ffffffff8147f609>] rest_init+0x6d/0x74
[  851.348067]  [<ffffffff818a8c30>] start_kernel+0x3bd/0x3ca
[  851.380880]  [<ffffffff818a8672>] ? repair_env_string+0x5e/0x5e
[  851.416294]  [<ffffffff818a8356>] x86_64_start_reservations+0x131/0x=
135
[  851.455868]  [<ffffffff818a845a>] x86_64_start_kernel+0x100/0x10f
[  851.492320] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  851.608602] NMI backtrace for cpu 4
[  851.629502] CPU 4=20
[  851.640480] Pid: 0, comm: swapper/4 Not tainted 3.6.6-dirty #16 Supe=
rmicro H8DGU/H8DGU
[  851.688943] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  851.738500] RSP: 0018:ffff880409c95ec8  EFLAGS: 00000246
[  851.770274] RAX: 0000000000000000 RBX: ffff880409c95fd8 RCX: ffff880=
80fc00000
[  851.812967] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  851.855661] RBP: ffff880409c95ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  851.898356] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000004
[  851.941051] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  851.983746] FS:  00007ff1f7b14800(0000) GS:ffff88080fc00000(0000) kn=
lGS:00000000f14ff700
[  852.032159] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  852.066534] CR2: 00007f21de3c6000 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  852.109228] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  852.151921] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  852.194616] Process swapper/4 (pid: 0, threadinfo ffff880409c94000, =
task ffff880409c6d280)
[  852.244070] Stack:
[  852.256083]  ffff880409c95ee8 ffffffff8101b33a ffff880409c95fd8 ffff=
ffff8188bb50
[  852.300544]  ffff880409c95f18 ffffffff8101bfee ffff880409c95f08 2a6d=
812d6eacf31c
[  852.345005]  0000000000000004 0000000000000000 ffff880409c95f48 ffff=
ffff81494971
[  852.389468] Call Trace:
[  852.404087]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  852.436378]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  852.466594]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  852.500963] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  852.617243] NMI backtrace for cpu 1
[  852.638144] CPU 1=20
[  852.649121] Pid: 0, comm: swapper/1 Not tainted 3.6.6-dirty #16 Supe=
rmicro H8DGU/H8DGU
[  852.697586] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  852.747090] RSP: 0018:ffff880409c8fec8  EFLAGS: 00000246
[  852.778864] RAX: 0000000000000000 RBX: ffff880409c8ffd8 RCX: ffff880=
40fc40000
[  852.821558] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  852.864252] RBP: ffff880409c8fec8 R08: 0000000000000000 R09: 0000000=
000000000
[  852.906947] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000001
[  852.949642] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  852.992337] FS:  00007fbb1774a7c0(0000) GS:ffff88040fc40000(0000) kn=
lGS:00000000f752e900
[  853.040750] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  853.075123] CR2: 00007f579d439000 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  853.117818] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  853.160511] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  853.203207] Process swapper/1 (pid: 0, threadinfo ffff880409c8e000, =
task ffff880409c6bde0)
[  853.252659] Stack:
[  853.264671]  ffff880409c8fee8 ffffffff8101b33a ffff880409c8ffd8 ffff=
ffff8188bb50
[  853.309134]  ffff880409c8ff18 ffffffff8101bfee ffff880409c8ff08 f785=
ee6277ffd7e8
[  853.353597]  0000000000000001 0000000000000000 ffff880409c8ff48 ffff=
ffff81494971
[  853.398060] Call Trace:
[  853.412674]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  853.444967]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  853.475183]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  853.509553] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  853.625833] NMI backtrace for cpu 5
[  853.646736] CPU 5=20
[  853.657712] Pid: 0, comm: swapper/5 Not tainted 3.6.6-dirty #16 Supe=
rmicro H8DGU/H8DGU
[  853.706176] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  853.755683] RSP: 0018:ffff880409c97ec8  EFLAGS: 00000246
[  853.787456] RAX: 0000000000000000 RBX: ffff880409c97fd8 RCX: ffff880=
80fc40000
[  853.830149] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  853.872844] RBP: ffff880409c97ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  853.915538] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000005
[  853.958231] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  854.000927] FS:  00007f099ac8a700(0000) GS:ffff88080fc40000(0000) kn=
lGS:00000000f66f6700
[  854.049340] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  854.083715] CR2: 00007f099a6e8ea2 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  854.126409] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  854.169103] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  854.211798] Process swapper/5 (pid: 0, threadinfo ffff880409c96000, =
task ffff880409c6d960)
[  854.261250] Stack:
[  854.273262]  ffff880409c97ee8 ffffffff8101b33a ffff880409c97fd8 ffff=
ffff8188bb50
[  854.317726]  ffff880409c97f18 ffffffff8101bfee ffff880409c97f08 5ea3=
fe70ec50d401
[  854.362189]  0000000000000005 0000000000000000 ffff880409c97f48 ffff=
ffff81494971
[  854.406651] Call Trace:
[  854.421267]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  854.453560]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  854.483771]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  854.518145] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  854.634423] NMI backtrace for cpu 2
[  854.655275] CPU 2=20
[  854.666250] Pid: 0, comm: swapper/2 Not tainted 3.6.6-dirty #16 Supe=
rmicro H8DGU/H8DGU
[  854.714714] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  854.764222] RSP: 0018:ffff880409c91ec8  EFLAGS: 00000246
[  854.795995] RAX: 0000000000000000 RBX: ffff880409c91fd8 RCX: ffff880=
40fc80000
[  854.838690] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  854.881383] RBP: ffff880409c91ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  854.924077] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000002
[  854.966772] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  855.009466] FS:  00007f099ac8a700(0000) GS:ffff88040fc80000(0000) kn=
lGS:00000000f1508700
[  855.057879] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  855.092254] CR2: 0000000000d6ee20 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  855.134947] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  855.177640] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  855.220336] Process swapper/2 (pid: 0, threadinfo ffff880409c90000, =
task ffff880409c6c4c0)
[  855.269789] Stack:
[  855.281803]  ffff880409c91ee8 ffffffff8101b33a ffff880409c91fd8 ffff=
ffff8188bb50
[  855.326264]  ffff880409c91f18 ffffffff8101bfee ffff880409c91f08 67ae=
bbba5654cd1d
[  855.370728]  0000000000000002 0000000000000000 ffff880409c91f48 ffff=
ffff81494971
[  855.415189] Call Trace:
[  855.429804]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  855.462097]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  855.492311]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  855.526683] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  855.642963] NMI backtrace for cpu 7
[  855.663865] CPU 7=20
[  855.674840] Pid: 0, comm: swapper/7 Not tainted 3.6.6-dirty #16 Supe=
rmicro H8DGU/H8DGU
[  855.723304] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  855.772812] RSP: 0018:ffff880409c9bec8  EFLAGS: 00000246
[  855.804585] RAX: 0000000000000000 RBX: ffff880409c9bfd8 RCX: ffff880=
80fcc0000
[  855.847280] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  855.889973] RBP: ffff880409c9bec8 R08: 0000000000000000 R09: 0000000=
000000000
[  855.932669] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000007
[  855.975360] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  856.018056] FS:  00007f7bbf8f67c0(0000) GS:ffff88080fcc0000(0000) kn=
lGS:00000000f1478700
[  856.066470] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  856.100844] CR2: 000000000171e000 CR3: 00000008090d4000 CR4: 0000000=
0000007e0
[  856.143539] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  856.186233] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  856.228926] Process swapper/7 (pid: 0, threadinfo ffff880409c9a000, =
task ffff880409c6e720)
[  856.278381] Stack:
[  856.290395]  ffff880409c9bee8 ffffffff8101b33a ffff880409c9bfd8 ffff=
ffff8188bb50
[  856.334855]  ffff880409c9bf18 ffffffff8101bfee ffff880409c9bf08 71a7=
0b983f967eb3
[  856.379317]  0000000000000007 0000000000000000 ffff880409c9bf48 ffff=
ffff81494971
[  856.423779] Call Trace:
[  856.438395]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  856.470687]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  856.500902]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  856.535275] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  856.651554] NMI backtrace for cpu 3
[  856.672458] CPU 3=20
[  856.683432] Pid: 0, comm: swapper/3 Not tainted 3.6.6-dirty #16 Supe=
rmicro H8DGU/H8DGU
[  856.731895] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  856.781403] RSP: 0018:ffff880409c93ec8  EFLAGS: 00000246
[  856.813176] RAX: 0000000000000000 RBX: ffff880409c93fd8 RCX: ffff880=
40fcc0000
[  856.855871] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  856.898565] RBP: ffff880409c93ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  856.941259] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000003
[  856.983951] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  857.026648] FS:  00007f099ac8a700(0000) GS:ffff88040fcc0000(0000) kn=
lGS:00000000f7564900
[  857.075061] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  857.109434] CR2: 0000000000da9070 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  857.152130] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  857.194822] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  857.237518] Process swapper/3 (pid: 0, threadinfo ffff880409c92000, =
task ffff880409c6cba0)
[  857.286972] Stack:
[  857.298984]  ffff880409c93ee8 ffffffff8101b33a ffff880409c93fd8 ffff=
ffff8188bb50
[  857.343445]  ffff880409c93f18 ffffffff8101bfee ffff880409c93f08 a10c=
36868b36ca32
[  857.387907]  0000000000000003 0000000000000000 ffff880409c93f48 ffff=
ffff81494971
[  857.432371] Call Trace:
[  857.446985]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  857.479278]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  857.509491]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  857.543864] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  857.660147] NMI backtrace for cpu 12
[  857.681567] CPU 12=20
[  857.693065] Pid: 0, comm: swapper/12 Not tainted 3.6.6-dirty #16 Sup=
ermicro H8DGU/H8DGU
[  857.742048] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  857.791606] RSP: 0018:ffff880409ca7ec8  EFLAGS: 00000246
[  857.823380] RAX: 0000000000000000 RBX: ffff880409ca7fd8 RCX: ffff880=
c0fc00000
[  857.866074] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  857.908768] RBP: ffff880409ca7ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  857.951460] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
00000000c
[  857.994154] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  858.036851] FS:  00007ff1f7b14800(0000) GS:ffff880c0fc00000(0000) kn=
lGS:00000000f14ca700
[  858.085265] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  858.119639] CR2: 00007f099a748f80 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  858.162332] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  858.205027] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  858.247721] Process swapper/12 (pid: 0, threadinfo ffff880409ca6000,=
 task ffff880409ca8dc0)
[  858.297695] Stack:
[  858.309708]  ffff880409ca7ee8 ffffffff8101b33a ffff880409ca7fd8 ffff=
ffff8188bb50
[  858.354170]  ffff880409ca7f18 ffffffff8101bfee ffff880409ca7f08 11fa=
63abb048bac6
[  858.398632]  000000000000000c 0000000000000000 ffff880409ca7f48 ffff=
ffff81494971
[  858.443094] Call Trace:
[  858.457712]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  858.490054]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  858.520269]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  858.554639] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  858.670919] NMI backtrace for cpu 8
[  858.691823] CPU 8=20
[  858.702798] Pid: 0, comm: swapper/8 Not tainted 3.6.6-dirty #16 Supe=
rmicro H8DGU/H8DGU
[  858.751262] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  858.800819] RSP: 0018:ffff880409c9dec8  EFLAGS: 00000246
[  858.832594] RAX: 0000000000000000 RBX: ffff880409c9dfd8 RCX: ffff881=
01fc00000
[  858.875288] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  858.917981] RBP: ffff880409c9dec8 R08: 0000000000000000 R09: 0000000=
000000000
[  858.960677] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000008
[  859.003370] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  859.046066] FS:  00007f3267d9a700(0000) GS:ffff88101fc00000(0000) kn=
lGS:00000000f150d700
[  859.094480] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  859.128853] CR2: 00007f234a66b000 CR3: 0000001008e3c000 CR4: 0000000=
0000007e0
[  859.171548] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  859.214241] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  859.256936] Process swapper/8 (pid: 0, threadinfo ffff880409c9c000, =
task ffff880409c6ee00)
[  859.306388] Stack:
[  859.318401]  ffff880409c9dee8 ffffffff8101b33a ffff880409c9dfd8 ffff=
ffff8188bb50
[  859.362864]  ffff880409c9df18 ffffffff8101bfee ffff880409c9df08 3cf7=
a838b217e5f7
[  859.407326]  0000000000000008 0000000000000000 ffff880409c9df48 ffff=
ffff81494971
[  859.451788] Call Trace:
[  859.466406]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  859.498696]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  859.528913]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  859.563283] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  859.679563] NMI backtrace for cpu 9
[  859.700464] CPU 9=20
[  859.711440] Pid: 0, comm: swapper/9 Not tainted 3.6.6-dirty #16 Supe=
rmicro H8DGU/H8DGU
[  859.759904] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  859.809412] RSP: 0018:ffff880409ca1ec8  EFLAGS: 00000246
[  859.841185] RAX: 0000000000000000 RBX: ffff880409ca1fd8 RCX: ffff881=
01fc40000
[  859.883880] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  859.926573] RBP: ffff880409ca1ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  859.969267] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000009
[  860.011961] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  860.054655] FS:  00007f4c8af59800(0000) GS:ffff88101fc40000(0000) kn=
lGS:00000000f150d700
[  860.103069] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  860.137444] CR2: 00007f4c8a822ff0 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  860.180137] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  860.222831] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  860.265525] Process swapper/9 (pid: 0, threadinfo ffff880409ca0000, =
task ffff880409c6f4e0)
[  860.314981] Stack:
[  860.326993]  ffff880409ca1ee8 ffffffff8101b33a ffff880409ca1fd8 ffff=
ffff8188bb50
[  860.371454]  ffff880409ca1f18 ffffffff8101bfee ffff880409ca1f08 a6de=
cd2f1e05a4f8
[  860.415916]  0000000000000009 0000000000000000 ffff880409ca1f48 ffff=
ffff81494971
[  860.460379] Call Trace:
[  860.460861] Kernel panic - not syncing: hung_task: blocked tasks
[  860.460863] Pid: 94, comm: khungtaskd Not tainted 3.6.6-dirty #16
[  860.460864] Call Trace:
[  860.460868]  [<ffffffff8149d2a8>] panic+0xbc/0x1cb
[  860.460871]  [<ffffffff810c6eb5>] watchdog+0x245/0x250
[  860.460873]  [<ffffffff810c6c70>] ? hung_task_panic+0x20/0x20
[  860.460875]  [<ffffffff810727ce>] kthread+0x8e/0xa0
[  860.460877]  [<ffffffff814afa04>] kernel_thread_helper+0x4/0x10
[  860.460880]  [<ffffffff81072740>] ? kthread_freezable_should_stop+0x=
70/0x70
[  860.460882]  [<ffffffff814afa00>] ? gs_change+0x13/0x13
[  860.793252]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  860.825544]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  860.855757]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  860.890129] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  861.006411] NMI backtrace for cpu 13
[  861.027834] CPU 13=20
[  861.039328] Pid: 0, comm: swapper/13 Not tainted 3.6.6-dirty #16 Sup=
ermicro H8DGU/H8DGU
[  861.088310] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  861.137818] RSP: 0018:ffff880409cb1ec8  EFLAGS: 00000246
[  861.169592] RAX: 0000000000000000 RBX: ffff880409cb1fd8 RCX: ffff880=
c0fc40000
[  861.212285] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  861.254981] RBP: ffff880409cb1ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  861.297673] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
00000000d
[  861.340368] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  861.383063] FS:  00007f747e47f700(0000) GS:ffff880c0fc40000(0000) kn=
lGS:00000000f66a4700
[  861.431476] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  861.465850] CR2: 00007f747df7e000 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  861.508544] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  861.537562] Shutting down cpus with NMI
[  861.548335] ------------[ cut here ]------------
[  861.548338] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_re=
schedule+0x53/0x60()
[  861.548338] Hardware name: H8DGU
[  861.548384] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi pata_atiixp ide_pci_generic powernow_=
k8 freq_table mperf kvm_amd kvm igb joydev microcode evdev hid_generic =
sp5100_tco pcspkr dca k10temp amd64_edac_mod edac_core edac_mce_amd hwm=
on atiixp button ide_core i2c_piix4 ptp pps_core i2c_core processor ext=
3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata scsi_m=
od usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  861.548386] Pid: 94, comm: khungtaskd Not tainted 3.6.6-dirty #16
[  861.548386] Call Trace:
[  861.548391]  <IRQ>  [<ffffffff810500da>] warn_slowpath_common+0x7a/0=
xb0
[  861.548393]  [<ffffffff81050125>] warn_slowpath_null+0x15/0x20
[  861.548395]  [<ffffffff81034d73>] native_smp_send_reschedule+0x53/0x=
60
[  861.548399]  [<ffffffff81089fcc>] trigger_load_balance+0x17c/0x220
[  861.548403]  [<ffffffff81081ae4>] scheduler_tick+0x104/0x140
[  861.548408]  [<ffffffff810611d7>] update_process_times+0x67/0x80
[  861.548411]  [<ffffffff8109e579>] tick_sched_timer+0x69/0xe0
[  861.548414]  [<ffffffff810769ce>] __run_hrtimer+0x6e/0x1c0
[  861.548416]  [<ffffffff8109e510>] ? tick_nohz_handler+0x100/0x100
[  861.548418]  [<ffffffff81058a15>] ? __do_softirq+0x115/0x1f0
[  861.548421]  [<ffffffff810772af>] hrtimer_interrupt+0xef/0x220
[  861.548423]  [<ffffffff814afafc>] ? call_softirq+0x1c/0x30
[  861.548426]  [<ffffffff81035b34>] smp_apic_timer_interrupt+0x64/0xa0=

[  861.548428]  [<ffffffff814af40a>] apic_timer_interrupt+0x6a/0x70
[  861.548430]  <EOI>  [<ffffffff8149d373>] ? panic+0x187/0x1cb
[  861.548433]  [<ffffffff810c6eb5>] watchdog+0x245/0x250
[  861.548435]  [<ffffffff810c6c70>] ? hung_task_panic+0x20/0x20
[  861.548437]  [<ffffffff810727ce>] kthread+0x8e/0xa0
[  861.548440]  [<ffffffff814afa04>] kernel_thread_helper+0x4/0x10
[  861.548442]  [<ffffffff81072740>] ? kthread_freezable_should_stop+0x=
70/0x70
[  861.548444]  [<ffffffff814afa00>] ? gs_change+0x13/0x13
[  861.548445] ---[ end trace 4a85d404c32ab0c8 ]---
[  862.879854] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  862.922549] Process swapper/13 (pid: 0, threadinfo ffff880409cb0000,=
 task ffff880409ca94a0)
[  862.972521] Stack:
[  862.984534]  ffff880409cb1ee8 ffffffff8101b33a ffff880409cb1fd8 ffff=
ffff8188bb50
[  863.028998]  ffff880409cb1f18 ffffffff8101bfee ffff880409cb1f08 7ac9=
17725c85a4e0
[  863.073459]  000000000000000d 0000000000000000 ffff880409cb1f48 ffff=
ffff81494971
[  863.117920] Call Trace:
[  863.132537]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  863.164829]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  863.195044]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  863.229415] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  863.345694] NMI backtrace for cpu 10
[  863.367066] CPU 10=20
[  863.378562] Pid: 0, comm: swapper/10 Tainted: G        W    3.6.6-di=
rty #16 Supermicro H8DGU/H8DGU
[  863.433264] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  863.482773] RSP: 0018:ffff880409ca3ec8  EFLAGS: 00000246
[  863.514546] RAX: 0000000000000000 RBX: ffff880409ca3fd8 RCX: ffff881=
01fc80000
[  863.557240] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  863.599933] RBP: ffff880409ca3ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  863.642627] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
00000000a
[  863.685323] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  863.728017] FS:  00007f234a65a700(0000) GS:ffff88101fc80000(0000) kn=
lGS:00000000f151c700
[  863.776432] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  863.810804] CR2: 00007fec589980d0 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  863.853499] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  863.896194] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  863.938887] Process swapper/10 (pid: 0, threadinfo ffff880409ca2000,=
 task ffff880409ca8000)
[  863.988860] Stack:
[  864.000874]  ffff880409ca3ee8 ffffffff8101b33a ffff880409ca3fd8 ffff=
ffff8188bb50
[  864.045336]  ffff880409ca3f18 ffffffff8101bfee ffff880409ca3f08 3021=
3da4f9a40d47
[  864.089799]  000000000000000a 0000000000000000 ffff880409ca3f48 ffff=
ffff81494971
[  864.134261] Call Trace:
[  864.148876]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  864.181168]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  864.211383]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  864.245753] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  864.362035] NMI backtrace for cpu 14
[  864.383456] CPU 14=20
[  864.394954] Pid: 0, comm: swapper/14 Tainted: G        W    3.6.6-di=
rty #16 Supermicro H8DGU/H8DGU
[  864.449657] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  864.499163] RSP: 0018:ffff880409cb3ec8  EFLAGS: 00000246
[  864.530937] RAX: 0000000000000000 RBX: ffff880409cb3fd8 RCX: ffff880=
c0fc80000
[  864.573630] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  864.616325] RBP: ffff880409cb3ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  864.659020] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
00000000e
[  864.701714] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  864.744409] FS:  00007ff1f7b14800(0000) GS:ffff880c0fc80000(0000) kn=
lGS:00000000f14ef700
[  864.792823] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  864.827196] CR2: 00007fd945056000 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  864.869888] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  864.912585] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  864.955278] Process swapper/14 (pid: 0, threadinfo ffff880409cb2000,=
 task ffff880409ca9b80)
[  865.005253] Stack:
[  865.017266]  ffff880409cb3ee8 ffffffff8101b33a ffff880409cb3fd8 ffff=
ffff8188bb50
[  865.061727]  ffff880409cb3f18 ffffffff8101bfee ffff880409cb3f08 0b1e=
43a076898cad
[  865.106188]  000000000000000e 0000000000000000 ffff880409cb3f48 ffff=
ffff81494971
[  865.150651] Call Trace:
[  865.165268]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  865.197560]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  865.227774]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  865.262146] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  865.378426] NMI backtrace for cpu 11
[  865.399849] CPU 11=20
[  865.411343] Pid: 0, comm: swapper/11 Tainted: G        W    3.6.6-di=
rty #16 Supermicro H8DGU/H8DGU
[  865.466049] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  865.515555] RSP: 0018:ffff880409ca5ec8  EFLAGS: 00000246
[  865.547329] RAX: 0000000000000000 RBX: ffff880409ca5fd8 RCX: ffff881=
01fcc0000
[  865.590023] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  865.632716] RBP: ffff880409ca5ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  865.675409] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
00000000b
[  865.718103] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  865.760798] FS:  00007f234a65a700(0000) GS:ffff88101fcc0000(0000) kn=
lGS:00000000f152c700
[  865.809214] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  865.843587] CR2: 00007f234a17de90 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  865.886281] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  865.928976] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  865.971670] Process swapper/11 (pid: 0, threadinfo ffff880409ca4000,=
 task ffff880409ca86e0)
[  866.021642] Stack:
[  866.033657]  ffff880409ca5ee8 ffffffff8101b33a ffff880409ca5fd8 ffff=
ffff8188bb50
[  866.078119]  ffff880409ca5f18 ffffffff8101bfee ffff880409ca5f08 e1bb=
af01fd1fa00f
[  866.122580]  000000000000000b 0000000000000000 ffff880409ca5f48 ffff=
ffff81494971
[  866.167043] Call Trace:
[  866.181658]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  866.213951]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  866.244164]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  866.278538] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 8=
4=20
[  866.394816] NMI backtrace for cpu 15
[  866.416241] CPU 15=20
[  866.427736] Pid: 0, comm: swapper/15 Tainted: G        W    3.6.6-di=
rty #16 Supermicro H8DGU/H8DGU
[  866.482439] RIP: 0010:[<ffffffff8103ee56>]  [<ffffffff8103ee56>] nat=
ive_safe_halt+0x6/0x10
[  866.531946] RSP: 0018:ffff880409cb5ec8  EFLAGS: 00000246
[  866.563720] RAX: 0000000000000000 RBX: ffff880409cb5fd8 RCX: ffff880=
c0fcc0000
[  866.606413] RDX: ffffffff8182aec0 RSI: 0000000000000001 RDI: 0000000=
000000086
[  866.649108] RBP: ffff880409cb5ec8 R08: 0000000000000000 R09: 0000000=
000000000
[  866.691802] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
00000000f
[  866.734496] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000=
000000000
[  866.777190] FS:  00007ff1f7b14800(0000) GS:ffff880c0fcc0000(0000) kn=
lGS:00000000f1508700
[  866.825605] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  866.859977] CR2: 00007f077cd22090 CR3: 000000000180b000 CR4: 0000000=
0000007e0
[  866.902671] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  866.945366] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  866.988061] Process swapper/15 (pid: 0, threadinfo ffff880409cb4000,=
 task ffff880409caa260)
[  867.038035] Stack:
[  867.050048]  ffff880409cb5ee8 ffffffff8101b33a ffff880409cb5fd8 ffff=
ffff8188bb50
[  867.094511]  ffff880409cb5f18 ffffffff8101bfee ffff880409cb5f08 3ed5=
9b31c93c7740
[  867.138971]  000000000000000f 0000000000000000 ffff880409cb5f48 ffff=
ffff81494971
[  867.183435] Call Trace:
[  867.198049]  [<ffffffff8101b33a>] default_idle+0x4a/0x190
[  867.230341]  [<ffffffff8101bfee>] cpu_idle+0xfe/0x120
[  867.260557]  [<ffffffff81494971>] start_secondary+0x1d4/0x1db
[  867.294928] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00=
 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e=
5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e
--nextPart19608413.JhNHYpAaty--

