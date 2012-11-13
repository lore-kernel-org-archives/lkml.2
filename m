Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2KMJke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:40:34 -0500
Received: from mail.agmk.net ([91.192.224.71]:57126 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab2KMJk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:40:26 -0500
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, arekm@pld-linux.org,
        baggins@pld-linux.org
Subject: Re: [3.6.6] panic on reboot / khungtaskd blocked? (WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule)
Date: Tue, 13 Nov 2012 10:40:16 +0100
Message-ID: <2413953.H7iie8v1th@pawels>
User-Agent: KMail/4.9.1 (Linux/3.6.6; KDE/4.9.2; x86_64; ; )
In-Reply-To: <3023364.Bjpo0brdul@pawels>
References: <56378024.A3Kec8xZj0@pawels> <1539324.MIArxLN8tE@pawels> <3023364.Bjpo0brdul@pawels>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1877929.JKyKaAmsY1"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1877929.JKyKaAmsY1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Monday 12 of November 2012 13:33:39 Pawe=C5=82 Sikora wrote:
> On Monday 12 of November 2012 11:22:47 Pawe=C5=82 Sikora wrote:
> > On Monday 12 of November 2012 15:40:31 Michael Wang wrote:
> > > On 11/12/2012 03:16 PM, Pawe=C5=82 Sikora wrote:
> > > > On Monday 12 of November 2012 11:04:12 Michael Wang wrote:
> > > >> On 11/09/2012 09:48 PM, Pawe=C5=82 Sikora wrote:
> > > >>> Hi,
> > > >>>
> > > >>> during playing with new ups i've caught an nice oops on reboo=
t:
> > > >>>
> > > >>> http://imgbin.org/index.php?page=3Dimage&id=3D10253
> > > >>>
> > > >>> probably the upstream is also affected.
> > > >>
> > > >> Hi, Pawe=C5=82
> > > >>
> > > >> Are you using a clean 3.6.6 without any modify?
> > > >=20
> > > > yes, pure 3.6.6 form git tree with modular config.
> > > >=20
> > > >> Looks like some threads has set itself to be UNINTERRUPTIBLE w=
ith out
> > > >> any design on switch itself back later(or the time is too long=
), are you
> > > >> accidentally using some bad designed module?
> > > >=20
> > > > hmm, hard to say. mostly all modules are loaded automatically b=
y kernel.
> > >=20
> > > Could you please provide the whole dmesg in text? your picture lo=
st the
> > > print info of the hung task.
> >=20
> > i've grabbed the console via rs232 but there's no more info (see at=
tached txt).
>=20
> hmm, i have one observation.
>=20
> during rc.shutdown there're messages on console like this: Cannot sta=
t file /proc/$pid/fd/1: Connection timed out
> afaics this file descriptor points to vnc log file on a remote machin=
e, e.g.:
>=20
> # ps aux|grep xfwm4
> eda       1748  0.0  0.0 320220 11224 ?        S    13:08   0:00 xfwm=
4=20
>=20
> # readlink -m /proc/1748/fd/1
> /remote/dragon/ahome/eda/.vnc/odra:11.log
>=20
> # mount|grep ahome
> dragon:/home/users/ on /remote/dragon/ahome type nfs (rw,relatime,ver=
s=3D3,rsize=3D262144,wsize=3D262144,namlen=3D255,soft,proto=3Dtcp,timeo=
=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D10.0.2.121,mountvers=3D3,mount=
port=3D45251,mountproto=3Dudp,local_lock=3Dnone,addr=3D10.0.2.121)
>=20
>=20
> so, probably during `killall5 -TERM/-KILL` on shutdown stage somethin=
g sometimes go wrong
> and these processes (xfce4/vncserver) survive the signal and hang on =
the nfs i/o.
>=20

ok, now i have full sysrq+w backtraces from shutdown process. i hope i'=
ll help you.

BR,
Pawe=C5=82.

--nextPart1877929.JKyKaAmsY1
Content-Disposition: inline; filename="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; name="dmesg.txt"

=0DINIT: Switching to runlevel: 6=0D
=0DINIT: Sending processes the TERM signal=0D
=1B[m=0F=1B[315m=1B[m=0F=1B[32mResource Manager: =1B[m=0F=1B[315mEnteri=
ng runlevel number............................=1B[m=0F=1B[36m[=1B[m=0F=1B=
[32m 6 =1B[m=0F=1B[36m]=1B[m=0F=1B[315m
Stopping automounter service.......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Setting terminals to default values................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping mdadm service.............................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping Samba SMB/CIFS Server service.............................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping Samba NetBIOS Name Server service.........................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping cronie crond service......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping NIS client service........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping S.M.A.R.T. Daemon service.................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping block device availability:................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Unmounting NFS filesystems.........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Unmounting NFS filesystems.........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping Name [  750.301818] nfsd: last server has exited, flushing exp=
ort cache
Switch Cache Daemon service..........................=1B[68G=1B[m=0F=1B=
[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315m=1B[68G=1B[m=0F=
=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315m
Saving random seed.................................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B=
[m=0F=1B[315m
Stopping NFS daemon service........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping NFS mountd service........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping NFS exportfs service......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping RPC idmapd service........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping syslog-ng service.........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping D-BUS Message bus service.................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping rpcbind service...........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping OpenSSH service...........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Shutting down interface eth0.......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Shutting down interface eth1.......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping UPS daemon service........................................Netw=
ork UPS Tools upsd 2.6.4-Unversioned directory
Stopping UPS drivers...............................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Stopping UPSmon service............................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Flushing all chains................................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Removing user defined chains.......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Resetting built-in chains to the default ACCEPT policy.............=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Flushing all chains................................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Removing user defined chains.......................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Resetting built-in chains to the default ACCEPT policy.............=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
Stopping irqbalance service........................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Sending all processes the TERM signal..............................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
[  756.051725] SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-=
tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) =
saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-=
tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-=
task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z)=20
Sending all processes the KILL signal..............................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Turning off swap...................................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
Unmounting file systems............................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
[  762.410195] SysRq : Show Blocked State
[  762.432662]   task                        PC stack   pid father
[  762.468056] Xvnc            D ffff88080fcd3b40     0  1657      1 0x=
00000002
[  762.510255]  ffff880c0834bb98 0000000000000046 ffff880c07980dc0 ffff=
880c0834bfd8
[  762.554629]  ffff880c0834bfd8 ffff880c0834bfd8 ffff880809259b80 ffff=
880c07980dc0
[  762.599005]  ffff880c0834bb98 ffff880c07980dc0 ffff88080fcd43a0 0000=
000000000002
[  762.643381] Call Trace:
[  762.657971]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  762.690250]  [<ffffffff814a6064>] schedule+0x24/0x70
[  762.719885]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  762.751077]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  762.782790]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  762.815019]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  762.851402]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  762.885189]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  762.924167]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  762.962108]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  762.995376]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  763.035390]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  763.075414]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  763.111322]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  763.141479]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  763.177340]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  763.208015]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  763.241800]  [<ffffffff81055735>] exit_files+0x45/0x50
[  763.272476]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  763.302630]  [<ffffffff8112add8>] ? do_munmap+0x328/0x400
[  763.334860]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  763.367090]  [<ffffffff81056712>] sys_exit_group+0x12/0x20
[  763.399840]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  763.435702] vncconfig       D ffff88080fc53b40     0  1662      1 0x=
00000002
[  763.477899]  ffff880c08c7d9c8 0000000000000046 ffff880c07982940 ffff=
880c08c7dfd8
[  763.522273]  ffff880c08c7dfd8 ffff880c08c7dfd8 ffff8808096e9b80 ffff=
880c07982940
[  763.566648]  ffff880c08c7d9c8 ffff880c07982940 ffff88080fc543a0 0000=
000000000002
[  763.611023] Call Trace:
[  763.625610]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  763.657839]  [<ffffffff814a6064>] schedule+0x24/0x70
[  763.687476]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  763.718668]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  763.750379]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  763.782610]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  763.818992]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  763.852780]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  763.891759]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  763.929697]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  763.962966]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  764.002983]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  764.043001]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  764.078862]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  764.109019]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  764.144878]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  764.175552]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  764.209340]  [<ffffffff81055735>] exit_files+0x45/0x50
[  764.240015]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  764.270169]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  764.304476]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  764.338783]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  764.371013]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  764.408433]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  764.439107]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  764.472375]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  764.502530]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  764.536317]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  764.566991] sh              D ffff88080fcd3b40     0  1665      1 0x=
00000006
[  764.609185]  ffff880806e559c8 0000000000000046 ffff8808096e2260 ffff=
880806e55fd8
[  764.653559]  ffff880806e55fd8 ffff880806e55fd8 ffff880409c6e720 ffff=
8808096e2260
[  764.697936]  ffff880806e559c8 ffff8808096e2260 ffff88080fcd43a0 0000=
000000000002
[  764.742311] Call Trace:
[  764.756897]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  764.789128]  [<ffffffff814a6064>] schedule+0x24/0x70
[  764.818762]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  764.849955]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  764.881666]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  764.913896]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  764.950280]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  764.984066]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  765.023044]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  765.060985]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  765.094253]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  765.134269]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  765.174289]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  765.210200]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  765.240359]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  765.276269]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  765.306945]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  765.340732]  [<ffffffff81055735>] exit_files+0x45/0x50
[  765.371404]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  765.401560]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  765.433789]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  765.471212]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  765.501883]  [<ffffffff8104d00b>] ? __mmdrop+0x5b/0x90
[  765.532558]  [<ffffffff811284ef>] ? do_mlock_pages+0x11f/0x150
[  765.567382]  [<ffffffff814a595e>] ? __schedule+0x2ce/0x6f0
[  765.600133]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  765.633919]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  765.664594] xfce4-session   D ffff880c0fc13b40     0  1671   1665 0x=
00000002
[  765.706788]  ffff8808073cd9c8 0000000000000046 ffff8808096e1b80 ffff=
8808073cdfd8
[  765.751164]  ffff8808073cdfd8 ffff8808073cdfd8 ffff880c0660b700 ffff=
8808096e1b80
[  765.795537]  ffff8808073cd9c8 ffff8808096e1b80 ffff880c0fc143a0 0000=
000000000002
[  765.839915] Call Trace:
[  765.854499]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  765.886730]  [<ffffffff814a6064>] schedule+0x24/0x70
[  765.916366]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  765.947559]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  765.979271]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  766.011499]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  766.047882]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  766.081670]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  766.120649]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  766.158589]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  766.191857]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  766.231873]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  766.271891]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  766.307752]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  766.337910]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  766.373821]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  766.404495]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  766.438282]  [<ffffffff81055735>] exit_files+0x45/0x50
[  766.468955]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  766.499110]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  766.533418]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  766.569281]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  766.601511]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  766.638931]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  766.669608]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  766.701318]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  766.731471]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  766.763183]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  766.794894]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  766.828681]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  766.859356] xfwm4           D ffff88080fc93b40     0  1683      1 0x=
00000004
[  766.901549]  ffff881007b5fa38 0000000000000086 ffff881008c63700 ffff=
881007b5ffd8
[  766.945926]  ffff881007b5ffd8 ffff881007b5ffd8 ffff8808096e8dc0 ffff=
881008c63700
[  766.990301]  ffff881007b5fa38 ffff881008c63700 ffff88080fc943a0 0000=
000000000002
[  767.034676] Call Trace:
[  767.049262]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  767.081492]  [<ffffffff814a6064>] schedule+0x24/0x70
[  767.111128]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  767.142321]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  767.174032]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  767.206262]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  767.240051]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  767.279028]  [<ffffffff810fe78c>] grab_cache_page_write_begin+0xac/0=
xf0
[  767.318528]  [<ffffffffa04f4c7b>] nfs_write_begin+0x5b/0x1f0 [nfs]
[  767.355426]  [<ffffffff810fd546>] generic_file_buffered_write+0x116/=
0x280
[  767.395962]  [<ffffffff810ff245>] __generic_file_aio_write+0x1c5/0x3=
c0
[  767.434940]  [<ffffffff814a4f9a>] ? __mutex_lock_slowpath+0x20a/0x2b=
0
[  767.473398]  [<ffffffff810ff4ba>] generic_file_aio_write+0x7a/0xf0
[  767.510303]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  767.546735]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  767.578966]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  767.609637]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  767.639792]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  767.675656] xfce4-panel     D ffff88080fc53b40     0  1687      1 0x=
00000004
[  767.717850]  ffff8804097ebc88 0000000000000082 ffff880409a9a260 ffff=
8804097ebfd8
[  767.762226]  ffff8804097ebfd8 ffff8804097ebfd8 ffff880806921b80 ffff=
880409a9a260
[  767.806599]  ffff8804097ebc78 ffff880809e49b30 ffff880409a9a260 ffff=
880809e49b34
[  767.850975] Call Trace:
[  767.865560]  [<ffffffff814a6064>] schedule+0x24/0x70
[  767.895196]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  767.933136]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  767.970559]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  768.001230]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  768.038135]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  768.074516]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  768.106747]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  768.137418]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  768.167573]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  768.203437] Thunar          D ffff880c0fc93b40     0  1689      1 0x=
00000002
[  768.245630]  ffff8808074479c8 0000000000000046 ffff88080965a940 ffff=
880807447fd8
[  768.290007]  ffff880807447fd8 ffff880807447fd8 ffff8808096e4ba0 ffff=
88080965a940
[  768.334382]  ffff8808074479c8 ffff88080965a940 ffff880c0fc943a0 0000=
000000000002
[  768.378758] Call Trace:
[  768.393344]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  768.425575]  [<ffffffff814a6064>] schedule+0x24/0x70
[  768.455210]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  768.486401]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  768.518114]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  768.550344]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  768.586727]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  768.620514]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  768.659493]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  768.697433]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  768.730700]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  768.770716]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  768.810734]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  768.846595]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  768.876753]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  768.912612]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  768.943286]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  768.977074]  [<ffffffff81055735>] exit_files+0x45/0x50
[  769.007748]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  769.037902]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  769.070132]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  769.107553]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  769.138228]  [<ffffffff8138e0e7>] ? sys_recvfrom+0x127/0x170
[  769.172015]  [<ffffffff811284ef>] ? do_mlock_pages+0x11f/0x150
[  769.206841]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  769.240628]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  769.271302] xfdesktop       D ffff880c0fcd3b40     0  1691      1 0x=
00000004
[  769.313495]  ffff88100777dc88 0000000000000086 ffff881008c64ba0 ffff=
88100777dfd8
[  769.357870]  ffff88100777dfd8 ffff88100777dfd8 ffff880409c9a260 ffff=
881008c64ba0
[  769.402245]  ffff88100777dc78 ffff880809e49b30 ffff881008c64ba0 ffff=
880809e49b34
[  769.446622] Call Trace:
[  769.461207]  [<ffffffff814a6064>] schedule+0x24/0x70
[  769.490843]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  769.528784]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  769.566205]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  769.596877]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  769.633782]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  769.670213]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  769.702445]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  769.733116]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  769.763270]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  769.799134] xfsettingsd     D ffff880c0fc53b40     0  1699      1 0x=
00000004
[  769.841330]  ffff8808092a3c88 0000000000000086 ffff8808096e44c0 ffff=
8808092a3fd8
[  769.885704]  ffff8808092a3fd8 ffff8808092a3fd8 ffff880c082d0000 ffff=
8808096e44c0
[  769.930079]  ffff8808092a3c78 ffff880809e49b30 ffff8808096e44c0 ffff=
880809e49b34
[  769.974455] Call Trace:
[  769.989041]  [<ffffffff814a6064>] schedule+0x24/0x70
[  770.018677]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  770.056617]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  770.094036]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  770.124711]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  770.161616]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  770.198047]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  770.230277]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  770.260951]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  770.291105]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  770.326968] panel-6-systray D ffff88080fc53b40     0  1729   1687 0x=
00000002
[  770.369163]  ffff880806dd19c8 0000000000000046 ffff8808096ea260 ffff=
880806dd1fd8
[  770.413539]  ffff880806dd1fd8 ffff880806dd1fd8 ffff88080a0b74e0 ffff=
8808096ea260
[  770.457914]  ffff880806dd19c8 ffff8808096ea260 ffff88080fc543a0 0000=
000000000002
[  770.502289] Call Trace:
[  770.516875]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  770.549105]  [<ffffffff814a6064>] schedule+0x24/0x70
[  770.578740]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  770.609932]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  770.641644]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  770.673876]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  770.710259]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  770.744046]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  770.783023]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  770.820963]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  770.854230]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  770.894248]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  770.934265]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  770.970127]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  771.000283]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  771.036144]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  771.066818]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  771.100605]  [<ffffffff81055735>] exit_files+0x45/0x50
[  771.131279]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  771.161433]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  771.195741]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  771.231603]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  771.263835]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  771.265540] ------------[ cut here ]------------
[  771.265548] WARNING: at fs/dcache.c:2628 prepend_path+0x1bb/0x1d0()
[  771.265549] Hardware name: H8DGU
[  771.265550] Root dentry has weird name <>
[  771.265601] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generi=
c powernow_k8 freq_table mperf kvm_amd kvm joydev igb amd64_edac_mod ev=
dev pcspkr edac_core edac_mce_amd microcode i2c_piix4 hid_generic dca p=
tp k10temp pps_core hwmon atiixp ide_core i2c_core processor button ext=
3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata scsi_m=
od usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  771.265603] Pid: 7811, comm: fuser Not tainted 3.6.6-dirty #16
[  771.265604] Call Trace:
[  771.265613]  [<ffffffff810500da>] warn_slowpath_common+0x7a/0xb0
[  771.265616]  [<ffffffff810501b1>] warn_slowpath_fmt+0x41/0x50
[  771.265618]  [<ffffffff811717db>] prepend_path+0x1bb/0x1d0
[  771.265623]  [<ffffffff8125df01>] ? bstr_printf+0x371/0x3d0
[  771.265625]  [<ffffffff81171847>] path_with_deleted+0x57/0xa0
[  771.265628]  [<ffffffff8117221d>] d_path+0x9d/0xd0
[  771.265632]  [<ffffffff8117d94c>] seq_path+0x4c/0xc0
[  771.265635]  [<ffffffff811b8125>] show_map_vma+0x145/0x270
[  771.265637]  [<ffffffff811b8477>] show_map+0x27/0x80
[  771.265639]  [<ffffffff811b84ee>] show_pid_map+0xe/0x10
[  771.265641]  [<ffffffff8117d780>] seq_read+0x230/0x3b0
[  771.265644]  [<ffffffff8115ce74>] vfs_read+0xa4/0x180
[  771.265646]  [<ffffffff8115cf95>] sys_read+0x45/0x90
[  771.265650]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  771.265651] ---[ end trace 728fc338d1c79275 ]---
[  772.330559]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  772.361230]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  772.394500]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  772.424655]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  772.458441]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  772.489115] panel-2-actions D ffff88080fc13b40     0  1731   1687 0x=
00000002
[  772.531308]  ffff881007c099c8 0000000000000046 ffff8810091ee720 ffff=
881007c09fd8
[  772.575683]  ffff881007c09fd8 ffff881007c09fd8 ffff880c07986040 ffff=
8810091ee720
[  772.620059]  ffff881007c099c8 ffff8810091ee720 ffff88080fc143a0 0000=
000000000002
[  772.664433] Call Trace:
[  772.679022]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  772.711250]  [<ffffffff814a6064>] schedule+0x24/0x70
[  772.740886]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  772.772078]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  772.803790]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  772.836023]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  772.872404]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  772.906193]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  772.945169]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  772.983109]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  773.016379]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  773.056395]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  773.096413]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  773.132324]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  773.162483]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  773.198393]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  773.229068]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  773.262857]  [<ffffffff81055735>] exit_files+0x45/0x50
[  773.293530]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  773.323685]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  773.357991]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  773.393856]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  773.426086]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  773.463504]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  773.494179]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  773.527448]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  773.557602]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  773.591388]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  773.622062] wish            D ffff88040fcd3b40     0  1957      1 0x=
00000002
[  773.664256]  ffff880806de59c8 0000000000000046 ffff8808096906e0 ffff=
880806de5fd8
[  773.708632]  ffff880806de5fd8 ffff880806de5fd8 ffff880409d0c4c0 ffff=
8808096906e0
[  773.753006]  0000000000000000 ffff8808096906e0 ffff880806de5a70 0000=
000000000082
[  773.797383] Call Trace:
[  773.811983]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  773.858782]  [<ffffffff814a6064>] schedule+0x24/0x70
[  773.888425]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  773.929526]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  773.961761]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  774.008570]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  774.045990]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  774.084974]  [<ffffffffa043d008>] __rpc_wait_for_completion_task+0x2=
8/0x30 [sunrpc]
[  774.130749]  [<ffffffffa052e908>] nfs4_do_close+0x1b8/0x210 [nfsv4]
[  774.168221]  [<ffffffffa05371cb>] __nfs4_close+0xdb/0x180 [nfsv4]
[  774.204655]  [<ffffffffa05372a3>] nfs4_close_sync+0x13/0x20 [nfsv4]
[  774.242075]  [<ffffffffa0528d35>] nfs4_close_context+0x25/0x30 [nfsv=
4]
[  774.281055]  [<ffffffffa04f5cc8>] __put_nfs_open_context+0xa8/0x100 =
[nfs]
[  774.321642]  [<ffffffffa04f78a7>] nfs_release+0x97/0xb0 [nfs]
[  774.356000]  [<ffffffffa04f44d0>] nfs_file_release+0x20/0x30 [nfs]
[  774.392948]  [<ffffffff8115dc87>] __fput+0xe7/0x230
[  774.422066]  [<ffffffff8115ddd9>] ____fput+0x9/0x10
[  774.451181]  [<ffffffff8106fa63>] task_work_run+0x63/0x80
[  774.483414]  [<ffffffff810562e2>] do_exit+0x872/0x8e0
[  774.513568]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  774.547873]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  774.583739]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  774.615967]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  774.653388]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  774.684062]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  774.717332]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  774.747485]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  774.781272]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  774.811949] fuser           D ffff88101fc53b40     0  7986   7811 0x=
00000000
[  774.854138]  ffff880806a4b988 0000000000000086 ffff880809695960 ffff=
880806a4bfd8
[  774.898515]  ffff880806a4bfd8 ffff880806a4bfd8 ffff880409c6f4e0 ffff=
880809695960
[  774.942889]  0000000000000000 ffff880809695960 ffff880806a4ba30 0000=
000000000082
[  774.987267] Call Trace:
[  775.001859]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  775.048668]  [<ffffffff814a6064>] schedule+0x24/0x70
[  775.078307]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  775.119408]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  775.151644]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  775.191711]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  775.238521]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  775.275943]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  775.314925]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  775.352397]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  775.389869]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  775.427861]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  775.463776]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  775.500211]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  775.537162]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  775.581328]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  775.619791]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  775.660377]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  775.699405]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  775.737345]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  775.777878]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  775.810626]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  775.841298]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  775.874050]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  775.906799]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  775.940066]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  775.974894]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  776.009199]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  776.040392]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  776.071585]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  776.101221]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  776.132414]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  776.164124]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  776.199987] fuser           D ffff880c0fc53b40     0  7994   7811 0x=
00000000
[  776.242182]  ffff881007f67988 ffff880c0923b480 ffff881007f67948 ffff=
ffff81253743
[  776.286557]  ffff881007f67958 ffffffff81253743 0000000000000000 0000=
00000000000b
[  776.330932]  ffff881007f67a48 ffffffff81088823 0000000000000001 0000=
000000013b40
[  776.375307] Call Trace:
[  776.389897]  [<ffffffff81253743>] ? cpumask_next_and+0x23/0x40
[  776.424721]  [<ffffffff81253743>] ? cpumask_next_and+0x23/0x40
[  776.459545]  [<ffffffff81088823>] ? update_sd_lb_stats+0x113/0x610
[  776.496447]  [<ffffffff81088d51>] ? find_busiest_group+0x31/0x490
[  776.532830]  [<ffffffff81089296>] ? load_balance+0xe6/0x790
[  776.566097]  [<ffffffff81084e75>] ? sched_clock_cpu+0xc5/0x120
[  776.600923]  [<ffffffff81089d10>] ? idle_balance+0xe0/0x130
[  776.634193]  [<ffffffff814a6064>] schedule+0x24/0x70
[  776.663827]  [<ffffffff81056022>] do_exit+0x5b2/0x8e0
[  776.693981]  [<ffffffff81169581>] ? path_lookupat+0xc1/0x740
[  776.727770]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  776.760000]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  776.797422]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  776.828095]  [<ffffffff8116c86c>] ? user_path_at+0xc/0x10
[  776.860324]  [<ffffffff81161670>] ? vfs_fstatat+0x30/0x70
[  776.892555]  [<ffffffff811616e6>] ? vfs_stat+0x16/0x20
[  776.923228]  [<ffffffff811618b5>] ? sys_newstat+0x15/0x30
[  776.955459]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  776.989248]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  777.019920] fuser           D ffff880c0fc53b40     0  7995   7811 0x=
00000000
[  777.062113]  ffff881007a5d988 0000000000000082 ffff880fc6d6b020 ffff=
881007a5dfd8
[  777.106489]  ffff881007a5dfd8 ffff881007a5dfd8 ffff880409c994a0 ffff=
880fc6d6b020
[  777.150864]  0000000000000000 ffff880fc6d6b020 ffff881007a5da30 0000=
000000000082
[  777.195239] Call Trace:
[  777.209832]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  777.256642]  [<ffffffff814a6064>] schedule+0x24/0x70
[  777.286282]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  777.327384]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  777.359618]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  777.399685]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  777.446496]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  777.483917]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  777.522898]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  777.560369]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  777.597791]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  777.635783]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  777.671697]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  777.708080]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  777.745031]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  777.789198]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  777.827660]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  777.868248]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  777.907277]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  777.945266]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  777.985799]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  778.018549]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  778.049222]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  778.081971]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  778.114722]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  778.147989]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  778.182817]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  778.217122]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  778.248315]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  778.279507]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  778.309144]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  778.340335]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  778.372046]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
Cannot stat file /proc/1683/fd/1: Connection timed out
Cannot stat file /proc/1683/fd/2: Connection timed out
Cannot stat file /proc/1687/fd/1: Connection timed out
Cannot stat file[  781.280831] ------------[ cut here ]------------
 /proc/1687/fd/2[  781.312886] WARNING: at fs/dcache.c:2628 prepend_pat=
h+0x1bb/0x1d0()
: Connection tim[  781.358650] Hardware name: H8DGU
ed out
[  781.386261] Root dentry has weird name <>
[  781.414388] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generi=
c powernow_k8 freq_table mperf kvm_amd kvm joydev igb amd64_edac_mod ev=
dev pcspkr edac_core edac_mce_amd microcode i2c_piix4 hid_generic dca p=
tp k10temp pps_core hwmon atiixp ide_core i2c_core processor button ext=
3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata scsi_m=
od usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  781.818491] Pid: 7811, comm: fuser Tainted: G        W    3.6.6-dirt=
y #16
[  781.859075] Call Trace:
[  781.873718]  [<ffffffff810500da>] warn_slowpath_common+0x7a/0xb0
[  781.909632]  [<ffffffff810501b1>] warn_slowpath_fmt+0x41/0x50
[  781.943990]  [<ffffffff811717db>] prepend_path+0x1bb/0x1d0
[  781.976792]  [<ffffffff8125df01>] ? bstr_printf+0x371/0x3d0
[  782.010112]  [<ffffffff81171847>] path_with_deleted+0x57/0xa0
[  782.044469]  [<ffffffff8117221d>] d_path+0x9d/0xd0
[  782.073122]  [<ffffffff8117d94c>] seq_path+0x4c/0xc0
[  782.102808]  [<ffffffff811b8125>] show_map_vma+0x145/0x270
[  782.135606]  [<ffffffff811b8477>] show_map+0x27/0x80
[  782.165292]  [<ffffffff811b84ee>] show_pid_map+0xe/0x10
[  782.196539]  [<ffffffff8117d780>] seq_read+0x230/0x3b0
[  782.227266]  [<ffffffff8115ce74>] vfs_read+0xa4/0x180
[  782.257473]  [<ffffffff8115cf95>] sys_read+0x45/0x90
[  782.257477]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  782.257479] ---[ end trace 728fc338d1c79276 ]---
[  783.082656] SysRq : Show Blocked State
[  783.105108]   task                        PC stack   pid father
[  783.140490] Xvnc            D ffff88080fcd3b40     0  1657      1 0x=
00000002
[  783.182700]  ffff880c0834bb98 0000000000000046 ffff880c07980dc0 ffff=
880c0834bfd8
[  783.227075]  ffff880c0834bfd8 ffff880c0834bfd8 ffff880809259b80 ffff=
880c07980dc0
[  783.271451]  ffff880c0834bb98 ffff880c07980dc0 ffff88080fcd43a0 0000=
000000000002
[  783.315827] Call Trace:
[  783.330416]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  783.362642]  [<ffffffff814a6064>] schedule+0x24/0x70
[  783.392279]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  783.423471]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  783.455182]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  783.487413]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  783.523796]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  783.557584]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  783.596562]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  783.634501]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  783.667768]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  783.707785]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  783.747806]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  783.783715]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  783.813873]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  783.849733]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  783.880409]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  783.914197]  [<ffffffff81055735>] exit_files+0x45/0x50
[  783.944870]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  783.975022]  [<ffffffff8112add8>] ? do_munmap+0x328/0x400
[  784.007256]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  784.039485]  [<ffffffff81056712>] sys_exit_group+0x12/0x20
[  784.072233]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  784.108097] vncconfig       D ffff88080fc53b40     0  1662      1 0x=
00000002
[  784.150290]  ffff880c08c7d9c8 0000000000000046 ffff880c07982940 ffff=
880c08c7dfd8
[  784.194666]  ffff880c08c7dfd8 ffff880c08c7dfd8 ffff8808096e9b80 ffff=
880c07982940
[  784.239041]  ffff880c08c7d9c8 ffff880c07982940 ffff88080fc543a0 0000=
000000000002
[  784.283417] Call Trace:
[  784.298004]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  784.330235]  [<ffffffff814a6064>] schedule+0x24/0x70
[  784.359870]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  784.391063]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  784.422775]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  784.455004]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  784.491387]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  784.525174]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  784.564151]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  784.602091]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  784.635360]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  784.675376]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  784.715396]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  784.751306]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  784.781464]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  784.817324]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  784.847999]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  784.881787]  [<ffffffff81055735>] exit_files+0x45/0x50
[  784.912460]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  784.942616]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  784.976921]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  785.011228]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  785.043458]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  785.080878]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  785.111553]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  785.144820]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  785.174976]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  785.208763]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  785.239435] sh              D ffff88080fcd3b40     0  1665      1 0x=
00000006
[  785.281630]  ffff880806e559c8 0000000000000046 ffff8808096e2260 ffff=
880806e55fd8
[  785.326006]  ffff880806e55fd8 ffff880806e55fd8 ffff880409c6e720 ffff=
8808096e2260
[  785.370381]  ffff880806e559c8 ffff8808096e2260 ffff88080fcd43a0 0000=
000000000002
[  785.414756] Call Trace:
[  785.429342]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  785.461573]  [<ffffffff814a6064>] schedule+0x24/0x70
[  785.491208]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  785.522400]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  785.554112]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  785.586343]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  785.622727]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  785.656514]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  785.695490]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  785.733430]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  785.766699]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  785.806714]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  785.846734]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  785.882594]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  785.912751]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  785.948611]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  785.979287]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  786.013073]  [<ffffffff81055735>] exit_files+0x45/0x50
[  786.043746]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  786.073901]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  786.106132]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  786.143552]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  786.174226]  [<ffffffff8104d00b>] ? __mmdrop+0x5b/0x90
[  786.204900]  [<ffffffff811284ef>] ? do_mlock_pages+0x11f/0x150
[  786.239725]  [<ffffffff814a595e>] ? __schedule+0x2ce/0x6f0
[  786.272475]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  786.306261]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  786.336934] xfce4-session   D ffff880c0fc13b40     0  1671   1665 0x=
00000002
[  786.379131]  ffff8808073cd9c8 0000000000000046 ffff8808096e1b80 ffff=
8808073cdfd8
[  786.423504]  ffff8808073cdfd8 ffff8808073cdfd8 ffff880c0660b700 ffff=
8808096e1b80
[  786.467879]  ffff8808073cd9c8 ffff8808096e1b80 ffff880c0fc143a0 0000=
000000000002
[  786.512255] Call Trace:
[  786.526841]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  786.559071]  [<ffffffff814a6064>] schedule+0x24/0x70
[  786.588708]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  786.619899]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  786.651612]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  786.683844]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  786.720226]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  786.754012]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  786.792990]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  786.830931]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  786.864199]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  786.904214]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  786.944232]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  786.980095]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  787.010252]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  787.046112]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  787.076786]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  787.110574]  [<ffffffff81055735>] exit_files+0x45/0x50
[  787.141247]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  787.171402]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  787.205708]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  787.241571]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  787.273802]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  787.311224]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  787.341897]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  787.373608]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  787.403762]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  787.435475]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  787.467185]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  787.500974]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  787.531646] xfwm4           D ffff88080fc93b40     0  1683      1 0x=
00000004
[  787.573840]  ffff881007b5fa38 0000000000000086 ffff881008c63700 ffff=
881007b5ffd8
[  787.618215]  ffff881007b5ffd8 ffff881007b5ffd8 ffff8808096e8dc0 ffff=
881008c63700
[  787.662590]  ffff881007b5fa38 ffff881008c63700 ffff88080fc943a0 0000=
000000000002
[  787.706965] Call Trace:
[  787.721554]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  787.753783]  [<ffffffff814a6064>] schedule+0x24/0x70
[  787.783417]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  787.814610]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  787.846322]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  787.878553]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  787.912341]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  787.951319]  [<ffffffff810fe78c>] grab_cache_page_write_begin+0xac/0=
xf0
[  787.990819]  [<ffffffffa04f4c7b>] nfs_write_begin+0x5b/0x1f0 [nfs]
[  788.027770]  [<ffffffff810fd546>] generic_file_buffered_write+0x116/=
0x280
[  788.068305]  [<ffffffff810ff245>] __generic_file_aio_write+0x1c5/0x3=
c0
[  788.107281]  [<ffffffff814a4f9a>] ? __mutex_lock_slowpath+0x20a/0x2b=
0
[  788.145740]  [<ffffffff810ff4ba>] generic_file_aio_write+0x7a/0xf0
[  788.182643]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  788.219025]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  788.251254]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  788.281928]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  788.312081]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  788.347944] xfce4-panel     D ffff88080fc53b40     0  1687      1 0x=
00000004
[  788.390139]  ffff8804097ebc88 0000000000000082 ffff880409a9a260 ffff=
8804097ebfd8
[  788.434514]  ffff8804097ebfd8 ffff8804097ebfd8 ffff880806921b80 ffff=
880409a9a260
[  788.478890]  ffff8804097ebc78 ffff880809e49b30 ffff880409a9a260 ffff=
880809e49b34
[  788.523265] Call Trace:
[  788.537853]  [<ffffffff814a6064>] schedule+0x24/0x70
[  788.567488]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  788.605427]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  788.642849]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  788.673523]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  788.710426]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  788.746805]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  788.779037]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  788.809708]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  788.839865]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  788.875727] Thunar          D ffff880c0fc93b40     0  1689      1 0x=
00000002
[  788.917922]  ffff8808074479c8 0000000000000046 ffff88080965a940 ffff=
880807447fd8
[  788.962296]  ffff880807447fd8 ffff880807447fd8 ffff8808096e4ba0 ffff=
88080965a940
[  789.006672]  ffff8808074479c8 ffff88080965a940 ffff880c0fc943a0 0000=
000000000002
[  789.051048] Call Trace:
[  789.065633]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  789.097865]  [<ffffffff814a6064>] schedule+0x24/0x70
[  789.127499]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  789.158694]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  789.190403]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  789.222636]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  789.259017]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  789.292804]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  789.331782]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  789.369722]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  789.402992]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  789.443005]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  789.483024]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  789.518885]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  789.549043]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  789.584904]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  789.615578]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  789.649365]  [<ffffffff81055735>] exit_files+0x45/0x50
[  789.680039]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  789.710193]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  789.742422]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  789.779844]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  789.810517]  [<ffffffff8138e0e7>] ? sys_recvfrom+0x127/0x170
[  789.844305]  [<ffffffff811284ef>] ? do_mlock_pages+0x11f/0x150
[  789.879130]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  789.912919]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  789.943591] xfdesktop       D ffff880c0fcd3b40     0  1691      1 0x=
00000004
[  789.985785]  ffff88100777dc88 0000000000000086 ffff881008c64ba0 ffff=
88100777dfd8
[  790.030162]  ffff88100777dfd8 ffff88100777dfd8 ffff880409c9a260 ffff=
881008c64ba0
[  790.074537]  ffff88100777dc78 ffff880809e49b30 ffff881008c64ba0 ffff=
880809e49b34
[  790.118911] Call Trace:
[  790.133497]  [<ffffffff814a6064>] schedule+0x24/0x70
[  790.163133]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  790.201074]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  790.238494]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  790.269166]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  790.306072]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  790.342451]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  790.374683]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  790.405355]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  790.435509]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  790.471373] xfsettingsd     D ffff880c0fc53b40     0  1699      1 0x=
00000004
[  790.513566]  ffff8808092a3c88 0000000000000086 ffff8808096e44c0 ffff=
8808092a3fd8
[  790.557941]  ffff8808092a3fd8 ffff8808092a3fd8 ffff880c082d0000 ffff=
8808096e44c0
[  790.602317]  ffff8808092a3c78 ffff880809e49b30 ffff8808096e44c0 ffff=
880809e49b34
[  790.646694] Call Trace:
[  790.661281]  [<ffffffff814a6064>] schedule+0x24/0x70
[  790.690914]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  790.728854]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  790.766276]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  790.796949]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  790.833854]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  790.870234]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  790.902463]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  790.933138]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  790.963291]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  790.999155] panel-6-systray D ffff88080fc53b40     0  1729   1687 0x=
00000002
[  791.041349]  ffff880806dd19c8 0000000000000046 ffff8808096ea260 ffff=
880806dd1fd8
[  791.085725]  ffff880806dd1fd8 ffff880806dd1fd8 ffff88080a0b74e0 ffff=
8808096ea260
[  791.130099]  ffff880806dd19c8 ffff8808096ea260 ffff88080fc543a0 0000=
000000000002
[  791.174475] Call Trace:
[  791.189062]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  791.221292]  [<ffffffff814a6064>] schedule+0x24/0x70
[  791.250927]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  791.282119]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  791.313831]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  791.346062]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  791.382443]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  791.416233]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  791.455211]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  791.493149]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  791.526419]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  791.566433]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  791.606452]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  791.642314]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  791.672471]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  791.708384]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  791.739056]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  791.772845]  [<ffffffff81055735>] exit_files+0x45/0x50
[  791.803518]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  791.833671]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  791.867978]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  791.903843]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  791.936072]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  791.973493]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  792.004166]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  792.037436]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  792.067591]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  792.101378]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  792.132050] panel-2-actions D ffff88080fc13b40     0  1731   1687 0x=
00000002
[  792.174246]  ffff881007c099c8 0000000000000046 ffff8810091ee720 ffff=
881007c09fd8
[  792.218620]  ffff881007c09fd8 ffff881007c09fd8 ffff880c07986040 ffff=
8810091ee720
[  792.262995]  ffff881007c099c8 ffff8810091ee720 ffff88080fc143a0 0000=
000000000002
[  792.307372] Call Trace:
[  792.321958]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  792.354186]  [<ffffffff814a6064>] schedule+0x24/0x70
[  792.383822]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  792.415018]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  792.446727]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  792.478958]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  792.515341]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  792.549130]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  792.588106]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  792.626045]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  792.659315]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  792.664314] ------------[ cut here ]------------
[  792.664319] WARNING: at fs/dcache.c:2628 prepend_path+0x1bb/0x1d0()
[  792.664320] Hardware name: H8DGU
[  792.664321] Root dentry has weird name <>
[  792.664348] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generi=
c powernow_k8 freq_table mperf kvm_amd kvm joydev igb amd64_edac_mod ev=
dev pcspkr edac_core edac_mce_amd microcode i2c_piix4 hid_generic dca p=
tp k10temp pps_core hwmon atiixp ide_core i2c_core processor button ext=
3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata scsi_m=
od usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  792.664350] Pid: 7811, comm: fuser Tainted: G        W    3.6.6-dirt=
y #16
[  792.664351] Call Trace:
[  792.664357]  [<ffffffff810500da>] warn_slowpath_common+0x7a/0xb0
[  792.664359]  [<ffffffff810501b1>] warn_slowpath_fmt+0x41/0x50
[  792.664362]  [<ffffffff8125c16c>] ? format_decode+0xc/0x3c0
[  792.664365]  [<ffffffff811717db>] prepend_path+0x1bb/0x1d0
[  792.664367]  [<ffffffff8125df01>] ? bstr_printf+0x371/0x3d0
[  792.664369]  [<ffffffff81171847>] path_with_deleted+0x57/0xa0
[  792.664371]  [<ffffffff8117221d>] d_path+0x9d/0xd0
[  792.664374]  [<ffffffff8117d94c>] seq_path+0x4c/0xc0
[  792.664376]  [<ffffffff811b8125>] show_map_vma+0x145/0x270
[  792.664378]  [<ffffffff811b8477>] show_map+0x27/0x80
[  792.664380]  [<ffffffff811b84ee>] show_pid_map+0xe/0x10
[  792.664382]  [<ffffffff8117d780>] seq_read+0x230/0x3b0
[  792.664384]  [<ffffffff8115ce74>] vfs_read+0xa4/0x180
[  792.664386]  [<ffffffff8115cf95>] sys_read+0x45/0x90
[  792.664388]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  792.664389] ---[ end trace 728fc338d1c79277 ]---
[  793.767610]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  793.807629]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  793.843542]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  793.873700]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  793.909611]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  793.940284]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  793.974072]  [<ffffffff81055735>] exit_files+0x45/0x50
[  794.004745]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  794.034902]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  794.069207]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  794.105071]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  794.137300]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  794.174723]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  794.205394]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  794.238664]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  794.268817]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  794.302605]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  794.333280] wish            D ffff88040fcd3b40     0  1957      1 0x=
00000002
[  794.375472]  ffff880806de59c8 0000000000000046 ffff8808096906e0 ffff=
880806de5fd8
[  794.419849]  ffff880806de5fd8 ffff880806de5fd8 ffff880409d0c4c0 ffff=
8808096906e0
[  794.464223]  0000000000000000 ffff8808096906e0 ffff880806de5a70 0000=
000000000082
[  794.508598] Call Trace:
[  794.523194]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  794.569999]  [<ffffffff814a6064>] schedule+0x24/0x70
[  794.599641]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  794.640741]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  794.672976]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  794.719787]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  794.757208]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  794.796189]  [<ffffffffa043d008>] __rpc_wait_for_completion_task+0x2=
8/0x30 [sunrpc]
[  794.841965]  [<ffffffffa052e908>] nfs4_do_close+0x1b8/0x210 [nfsv4]
[  794.879437]  [<ffffffffa05371cb>] __nfs4_close+0xdb/0x180 [nfsv4]
[  794.915820]  [<ffffffffa05372a3>] nfs4_close_sync+0x13/0x20 [nfsv4]
[  794.953289]  [<ffffffffa0528d35>] nfs4_close_context+0x25/0x30 [nfsv=
4]
[  794.992269]  [<ffffffffa04f5cc8>] __put_nfs_open_context+0xa8/0x100 =
[nfs]
[  795.032806]  [<ffffffffa04f78a7>] nfs_release+0x97/0xb0 [nfs]
[  795.067163]  [<ffffffffa04f44d0>] nfs_file_release+0x20/0x30 [nfs]
[  795.104061]  [<ffffffff8115dc87>] __fput+0xe7/0x230
[  795.133179]  [<ffffffff8115ddd9>] ____fput+0x9/0x10
[  795.162294]  [<ffffffff8106fa63>] task_work_run+0x63/0x80
[  795.194526]  [<ffffffff810562e2>] do_exit+0x872/0x8e0
[  795.224679]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  795.258985]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  795.294850]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  795.327080]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  795.364503]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  795.395175]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  795.428443]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  795.458596]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  795.492385]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  795.523061] fuser           D ffff88101fc53b40     0  7986   7811 0x=
00000000
[  795.565251]  ffff880806a4b988 0000000000000086 ffff880809695960 ffff=
880806a4bfd8
[  795.609627]  ffff880806a4bfd8 ffff880806a4bfd8 ffff880409c6f4e0 ffff=
880809695960
[  795.654003]  0000000000000000 ffff880809695960 ffff880806a4ba30 0000=
000000000082
[  795.698377] Call Trace:
[  795.712971]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  795.759778]  [<ffffffff814a6064>] schedule+0x24/0x70
[  795.789421]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  795.830521]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  795.862755]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  795.902825]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  795.949634]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  795.987055]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  796.026037]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  796.063508]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  796.100983]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  796.138974]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  796.174889]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  796.211323]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  796.248273]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  796.292439]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  796.330903]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  796.371489]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  796.410517]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  796.448458]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  796.489042]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  796.521791]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  796.552465]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  796.585213]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  796.617961]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  796.651231]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  796.686057]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  796.720364]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  796.751556]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  796.782750]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  796.812385]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  796.843578]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  796.875289]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  796.911150] fuser           D ffff880c0fc53b40     0  7995   7811 0x=
00000000
[  796.953346]  ffff881007a5d988 0000000000000082 ffff880fc6d6b020 ffff=
881007a5dfd8
[  796.997720]  ffff881007a5dfd8 ffff881007a5dfd8 ffff880409c994a0 ffff=
880fc6d6b020
[  797.042096]  0000000000000000 ffff880fc6d6b020 ffff881007a5da30 0000=
000000000082
[  797.086470] Call Trace:
[  797.101064]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  797.147872]  [<ffffffff814a6064>] schedule+0x24/0x70
[  797.177513]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  797.218615]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  797.250850]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  797.290917]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  797.337728]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  797.375147]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  797.414130]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  797.451602]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  797.489076]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  797.527067]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  797.562982]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  797.599417]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  797.636366]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  797.680533]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  797.718995]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  797.759582]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  797.798611]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  797.836552]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  797.877135]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  797.909884]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  797.940557]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  797.973306]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  798.006057]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  798.039324]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  798.074151]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  798.108456]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  798.139651]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  798.170842]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  798.200478]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  798.231670]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  798.263381]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  798.299245] fuser           D ffff880c0fc53b40     0  8008   7811 0x=
00000000
[  798.341439]  ffff88100701d988 0000000000000082 ffff880fc6d686e0 ffff=
88100701dfd8
[  798.385815]  ffff88100701dfd8 ffff88100701dfd8 ffff880409c994a0 ffff=
880fc6d686e0
[  798.430190]  0000000000000000 ffff880fc6d686e0 ffff88100701da30 0000=
000000000082
[  798.474564] Call Trace:
[  798.489156]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  798.535965]  [<ffffffff814a6064>] schedule+0x24/0x70
[  798.565607]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  798.606709]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  798.638943]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  798.679011]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  798.725820]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  798.763241]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  798.802224]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  798.839695]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  798.877170]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  798.915160]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  798.951075]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  798.987509]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  799.024460]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  799.068626]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  799.107090]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  799.147676]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  799.186705]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  799.224697]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  799.265280]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  799.298029]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  799.328702]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  799.361451]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  799.394201]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  799.427470]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  799.462296]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  799.496603]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  799.527796]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  799.558988]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  799.588623]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  799.619815]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  799.651528]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  799.687391] fuser           D ffff88101fc53b40     0  8026   7811 0x=
00000000
[  799.729584]  ffff880807983988 0000000000000086 ffff880809693700 ffff=
880807983fd8
[  799.773959]  ffff880807983fd8 ffff880807983fd8 ffff880409c6f4e0 ffff=
880809693700
[  799.818334]  0000000000000000 ffff880809693700 ffff880807983a30 0000=
000000000082
[  799.862710] Call Trace:
[  799.877303]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  799.924110]  [<ffffffff814a6064>] schedule+0x24/0x70
[  799.953751]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  799.994854]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  800.027088]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  800.067157]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  800.113967]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  800.151386]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  800.190368]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  800.227841]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  800.265315]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  800.303307]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  800.339220]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  800.375655]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  800.412606]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  800.456773]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  800.495235]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  800.535820]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  800.574798]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  800.612790]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  800.653373]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  800.686123]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  800.716796]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  800.749545]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  800.782296]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  800.815565]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  800.850390]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  800.884697]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  800.915888]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  800.947083]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  800.976718]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  801.007909]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  801.039620]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
Cannot stat file /proc/1691/fd/1: Connection timed out
Cannot stat file /proc/1691/fd/2: Connection timed out
Cannot stat file /proc/1699/fd/1: Connection timed out
Cannot stat file /proc/1699/fd/2: Connection timed out
Unmounting file systems............................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
Cannot stat file /proc/1683/fd/1: Connection timed out
Cannot stat file[  819.865107] ------------[ cut here ]------------
 /proc/1683/fd/2[  819.899360] WARNING: at fs/dcache.c:2628 prepend_pat=
h+0x1bb/0x1d0()
[  819.945103] Hardware name: H8DGU
: Connection tim[  819.964405] Root dentry has weird name <>
ed out
[  819.996641] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generi=
c powernow_k8 freq_table mperf kvm_amd kvm joydev igb amd64_edac_mod ev=
dev pcspkr edac_core edac_mce_amd microcode i2c_piix4 hid_generic dca p=
tp k10temp pps_core hwmon atiixp ide_core i2c_core processor button ext=
3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata scsi_m=
od usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  820.404471] Pid: 8068, comm: fuser Tainted: G        W    3.6.6-dirt=
y #16
[  820.445012] Call Trace:
[  820.459654]  [<ffffffff810500da>] warn_slowpath_common+0x7a/0xb0
[  820.495567]  [<ffffffff810501b1>] warn_slowpath_fmt+0x41/0x50
[  820.529924]  [<ffffffff811717db>] prepend_path+0x1bb/0x1d0
[  820.562728]  [<ffffffff8125df01>] ? bstr_printf+0x371/0x3d0
[  820.596049]  [<ffffffff81171847>] path_with_deleted+0x57/0xa0
[  820.630406]  [<ffffffff8117221d>] d_path+0x9d/0xd0
[  820.659057]  [<ffffffff8117d94c>] seq_path+0x4c/0xc0
[  820.688743]  [<ffffffff811b8125>] show_map_vma+0x145/0x270
[  820.721542]  [<ffffffff811b8477>] show_map+0x27/0x80
[  820.751230]  [<ffffffff811b84ee>] show_pid_map+0xe/0x10
[  820.782476]  [<ffffffff8117d780>] seq_read+0x230/0x3b0
[  820.813202]  [<ffffffff8115ce74>] vfs_read+0xa4/0x180
[  820.843408]  [<ffffffff8115cf95>] sys_read+0x45/0x90
[  820.873095]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  820.909004] ---[ end trace 728fc338d1c79278 ]---
Cannot stat file /proc/1687/fd/1: Connection timed out
Cannot stat file[  830.923284] ------------[ cut here ]------------
 /proc/1687/fd/2[  830.955346] WARNING: at fs/dcache.c:2628 prepend_pat=
h+0x1bb/0x1d0()
: Connection tim[  831.001116] Hardware name: H8DGU
[  831.028727] Root dentry has weird name <>
ed out
[  831.052699] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generi=
c powernow_k8 freq_table mperf kvm_amd kvm joydev igb amd64_edac_mod ev=
dev pcspkr edac_core edac_mce_amd microcode i2c_piix4 hid_generic dca p=
tp k10temp pps_core hwmon atiixp ide_core i2c_core processor button ext=
3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata scsi_m=
od usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  831.456957] Pid: 8068, comm: fuser Tainted: G        W    3.6.6-dirt=
y #16
[  831.497493] Call Trace:
[  831.512081]  [<ffffffff810500da>] warn_slowpath_common+0x7a/0xb0
[  831.547994]  [<ffffffff810501b1>] warn_slowpath_fmt+0x41/0x50
[  831.582301]  [<ffffffff811717db>] prepend_path+0x1bb/0x1d0
[  831.615104]  [<ffffffff8125df01>] ? bstr_printf+0x371/0x3d0
[  831.648423]  [<ffffffff81171847>] path_with_deleted+0x57/0xa0
[  831.682780]  [<ffffffff8117221d>] d_path+0x9d/0xd0
[  831.711386]  [<ffffffff8117d94c>] seq_path+0x4c/0xc0
[  831.741066]  [<ffffffff811b8125>] show_map_vma+0x145/0x270
[  831.773870]  [<ffffffff811b8477>] show_map+0x27/0x80
[  831.803554]  [<ffffffff811b84ee>] show_pid_map+0xe/0x10
[  831.834748]  [<ffffffff8117d780>] seq_read+0x230/0x3b0
[  831.865474]  [<ffffffff8115ce74>] vfs_read+0xa4/0x180
[  831.895678]  [<ffffffff8115cf95>] sys_read+0x45/0x90
[  831.925316]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  831.961227] ---[ end trace 728fc338d1c79279 ]---
Cannot stat file /proc/1691/fd/1: Connection timed out
Cannot stat file[  841.975811] ------------[ cut here ]------------
 /proc/1691/fd/2[  842.006746] WARNING: at fs/dcache.c:2628 prepend_pat=
h+0x1bb/0x1d0()
: Connection tim[  842.052511] Hardware name: H8DGU
ed out
[  842.080122] Root dentry has weird name <>
[  842.108248] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generi=
c powernow_k8 freq_table mperf kvm_amd kvm joydev igb amd64_edac_mod ev=
dev pcspkr edac_core edac_mce_amd microcode i2c_piix4 hid_generic dca p=
tp k10temp pps_core hwmon atiixp ide_core i2c_core processor button ext=
3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata scsi_m=
od usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  842.511514] Pid: 8068, comm: fuser Tainted: G        W    3.6.6-dirt=
y #16
[  842.552053] Call Trace:
[  842.566695]  [<ffffffff810500da>] warn_slowpath_common+0x7a/0xb0
[  842.602611]  [<ffffffff810501b1>] warn_slowpath_fmt+0x41/0x50
[  842.636970]  [<ffffffff811717db>] prepend_path+0x1bb/0x1d0
[  842.669770]  [<ffffffff8125df01>] ? bstr_printf+0x371/0x3d0
[  842.703091]  [<ffffffff81171847>] path_with_deleted+0x57/0xa0
[  842.737449]  [<ffffffff8117221d>] d_path+0x9d/0xd0
[  842.766098]  [<ffffffff8117d94c>] seq_path+0x4c/0xc0
[  842.795787]  [<ffffffff811b8125>] show_map_vma+0x145/0x270
[  842.828586]  [<ffffffff811b8477>] show_map+0x27/0x80
[  842.858274]  [<ffffffff811b84ee>] show_pid_map+0xe/0x10
[  842.889518]  [<ffffffff8117d780>] seq_read+0x230/0x3b0
[  842.920245]  [<ffffffff8115ce74>] vfs_read+0xa4/0x180
[  842.950451]  [<ffffffff8115cf95>] sys_read+0x45/0x90
[  842.980138]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  843.016049] ---[ end trace 728fc338d1c7927a ]---
Cannot stat file /proc/1699/fd/1: Connection timed out
Cannot stat file /proc/1699/fd/2: Connection timed out
Unmounting file systems............................................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[35m BUSY =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m=1B[68G=1B[m=0F=1B[36m[=1B[m=0F=1B[31m FAIL =1B[m=0F=1B[36m]=1B[m=0F=1B=
[315m
umount: /home/atest: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
umount: /dev: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
Cannot stat file /proc/1683/fd/1: Connection timed out
[  869.393696] SysRq : Show Blocked State
[  869.416134]   task                        PC stack   pid father
[  869.451527] Xvnc            D ffff88080fcd3b40     0  1657      1 0x=
00000002
[  869.493728]  ffff880c0834bb98 0000000000000046 ffff880c07980dc0 ffff=
880c0834bfd8
[  869.538101]  ffff880c0834bfd8 ffff880c0834bfd8 ffff880809259b80 ffff=
880c07980dc0
[  869.582477]  ffff880c0834bb98 ffff880c07980dc0 ffff88080fcd43a0 0000=
000000000002
[  869.626853] Call Trace:
[  869.641441]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  869.673671]  [<ffffffff814a6064>] schedule+0x24/0x70
[  869.703304]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  869.734499]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  869.766209]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  869.798439]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  869.834823]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  869.868610]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  869.907588]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  869.945528]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  869.978797]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  870.018812]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  870.058835]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  870.094742]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  870.124901]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  870.160814]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  870.191488]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  870.225275]  [<ffffffff81055735>] exit_files+0x45/0x50
[  870.255949]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  870.286102]  [<ffffffff8112add8>] ? do_munmap+0x328/0x400
[  870.318333]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  870.319988] ------------[ cut here ]------------
[  870.319997] WARNING: at fs/dcache.c:2628 prepend_path+0x1bb/0x1d0()
[  870.319998] Hardware name: H8DGU
[  870.319998] Root dentry has weird name <>
[  870.320047] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generi=
c powernow_k8 freq_table mperf kvm_amd kvm joydev igb amd64_edac_mod ev=
dev pcspkr edac_core edac_mce_amd microcode i2c_piix4 hid_generic dca p=
tp k10temp pps_core hwmon atiixp ide_core i2c_core processor button ext=
3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata scsi_m=
od usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  870.320050] Pid: 8367, comm: fuser Tainted: G        W    3.6.6-dirt=
y #16
[  870.320051] Call Trace:
[  870.320060]  [<ffffffff810500da>] warn_slowpath_common+0x7a/0xb0
[  870.320062]  [<ffffffff810501b1>] warn_slowpath_fmt+0x41/0x50
[  870.320065]  [<ffffffff811717db>] prepend_path+0x1bb/0x1d0
[  870.320069]  [<ffffffff8125df01>] ? bstr_printf+0x371/0x3d0
[  870.320072]  [<ffffffff81171847>] path_with_deleted+0x57/0xa0
[  870.320074]  [<ffffffff8117221d>] d_path+0x9d/0xd0
[  870.320078]  [<ffffffff8117d94c>] seq_path+0x4c/0xc0
[  870.320081]  [<ffffffff811b8125>] show_map_vma+0x145/0x270
[  870.320083]  [<ffffffff811b8477>] show_map+0x27/0x80
[  870.320085]  [<ffffffff811b84ee>] show_pid_map+0xe/0x10
[  870.320087]  [<ffffffff8117d780>] seq_read+0x230/0x3b0
[  870.320090]  [<ffffffff8115ce74>] vfs_read+0xa4/0x180
[  870.320092]  [<ffffffff8115cf95>] sys_read+0x45/0x90
[  870.320096]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  870.320097] ---[ end trace 728fc338d1c7927b ]---
[  871.385575]  [<ffffffff81056712>] sys_exit_group+0x12/0x20
[  871.418324]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  871.454186] vncconfig       D ffff88080fc53b40     0  1662      1 0x=
00000002
[  871.496381]  ffff880c08c7d9c8 0000000000000046 ffff880c07982940 ffff=
880c08c7dfd8
[  871.540757]  ffff880c08c7dfd8 ffff880c08c7dfd8 ffff8808096e9b80 ffff=
880c07982940
[  871.585131]  ffff880c08c7d9c8 ffff880c07982940 ffff88080fc543a0 0000=
000000000002
[  871.629506] Call Trace:
[  871.644093]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  871.676323]  [<ffffffff814a6064>] schedule+0x24/0x70
[  871.705960]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  871.737151]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  871.768864]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  871.801094]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  871.837477]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  871.871264]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  871.910241]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  871.948183]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  871.981451]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  872.021467]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  872.061485]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  872.097397]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  872.127555]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  872.163467]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  872.194141]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  872.227929]  [<ffffffff81055735>] exit_files+0x45/0x50
[  872.258601]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  872.288758]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  872.323063]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  872.357371]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  872.389600]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  872.427021]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  872.457695]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  872.490964]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  872.521118]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  872.554904]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  872.585577] sh              D ffff88080fcd3b40     0  1665      1 0x=
00000006
[  872.627772]  ffff880806e559c8 0000000000000046 ffff8808096e2260 ffff=
880806e55fd8
[  872.672147]  ffff880806e55fd8 ffff880806e55fd8 ffff880409c6e720 ffff=
8808096e2260
[  872.716521]  ffff880806e559c8 ffff8808096e2260 ffff88080fcd43a0 0000=
000000000002
[  872.760898] Call Trace:
[  872.775483]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  872.807714]  [<ffffffff814a6064>] schedule+0x24/0x70
[  872.837350]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  872.868544]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  872.900256]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  872.932485]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  872.968867]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  873.002655]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  873.041632]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  873.079574]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  873.112840]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  873.152859]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  873.192875]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  873.228736]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  873.258894]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  873.294755]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  873.325429]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  873.359216]  [<ffffffff81055735>] exit_files+0x45/0x50
[  873.389890]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  873.420044]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  873.452275]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  873.489694]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  873.520367]  [<ffffffff8104d00b>] ? __mmdrop+0x5b/0x90
[  873.551044]  [<ffffffff811284ef>] ? do_mlock_pages+0x11f/0x150
[  873.585868]  [<ffffffff814a595e>] ? __schedule+0x2ce/0x6f0
[  873.618619]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  873.652405]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  873.683076] xfce4-session   D ffff880c0fc13b40     0  1671   1665 0x=
00000002
[  873.725271]  ffff8808073cd9c8 0000000000000046 ffff8808096e1b80 ffff=
8808073cdfd8
[  873.769645]  ffff8808073cdfd8 ffff8808073cdfd8 ffff880c0660b700 ffff=
8808096e1b80
[  873.814022]  ffff8808073cd9c8 ffff8808096e1b80 ffff880c0fc143a0 0000=
000000000002
[  873.858398] Call Trace:
[  873.872986]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  873.905213]  [<ffffffff814a6064>] schedule+0x24/0x70
[  873.934849]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  873.966042]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  873.997754]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  874.029985]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  874.066368]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  874.100156]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  874.139133]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  874.177073]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  874.210340]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  874.250357]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  874.290376]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  874.326288]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  874.356444]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  874.392305]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  874.422979]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  874.456769]  [<ffffffff81055735>] exit_files+0x45/0x50
[  874.487441]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  874.517596]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  874.551902]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  874.587765]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  874.619995]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  874.657418]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  874.688090]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  874.719800]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  874.749956]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  874.781667]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  874.813379]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  874.847166]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  874.877840] xfwm4           D ffff88080fc93b40     0  1683      1 0x=
00000004
[  874.920033]  ffff881007b5fa38 0000000000000086 ffff881008c63700 ffff=
881007b5ffd8
[  874.964409]  ffff881007b5ffd8 ffff881007b5ffd8 ffff8808096e8dc0 ffff=
881008c63700
[  875.008784]  ffff881007b5fa38 ffff881008c63700 ffff88080fc943a0 0000=
000000000002
[  875.053160] Call Trace:
[  875.067746]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  875.099976]  [<ffffffff814a6064>] schedule+0x24/0x70
[  875.129613]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  875.160804]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  875.192516]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  875.224746]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  875.258535]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  875.297513]  [<ffffffff810fe78c>] grab_cache_page_write_begin+0xac/0=
xf0
[  875.337013]  [<ffffffffa04f4c7b>] nfs_write_begin+0x5b/0x1f0 [nfs]
[  875.373963]  [<ffffffff810fd546>] generic_file_buffered_write+0x116/=
0x280
[  875.414499]  [<ffffffff810ff245>] __generic_file_aio_write+0x1c5/0x3=
c0
[  875.453476]  [<ffffffff814a4f9a>] ? __mutex_lock_slowpath+0x20a/0x2b=
0
[  875.491935]  [<ffffffff810ff4ba>] generic_file_aio_write+0x7a/0xf0
[  875.528840]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  875.565270]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  875.597502]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  875.628174]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  875.658329]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  875.694191] xfce4-panel     D ffff88080fc53b40     0  1687      1 0x=
00000004
[  875.736386]  ffff8804097ebc88 0000000000000082 ffff880409a9a260 ffff=
8804097ebfd8
[  875.780760]  ffff8804097ebfd8 ffff8804097ebfd8 ffff880806921b80 ffff=
880409a9a260
[  875.825137]  ffff8804097ebc78 ffff880809e49b30 ffff880409a9a260 ffff=
880809e49b34
[  875.869511] Call Trace:
[  875.884099]  [<ffffffff814a6064>] schedule+0x24/0x70
[  875.913734]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  875.951674]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  875.989094]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  876.019767]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  876.056671]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  876.093051]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  876.125283]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  876.155956]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  876.186109]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  876.221973] Thunar          D ffff880c0fc93b40     0  1689      1 0x=
00000002
[  876.264167]  ffff8808074479c8 0000000000000046 ffff88080965a940 ffff=
880807447fd8
[  876.308542]  ffff880807447fd8 ffff880807447fd8 ffff8808096e4ba0 ffff=
88080965a940
[  876.352918]  ffff8808074479c8 ffff88080965a940 ffff880c0fc943a0 0000=
000000000002
[  876.397294] Call Trace:
[  876.411879]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  876.444111]  [<ffffffff814a6064>] schedule+0x24/0x70
[  876.473746]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  876.504938]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  876.536651]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  876.568880]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  876.605263]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  876.639051]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  876.678029]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  876.715968]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  876.749237]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  876.789253]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  876.829272]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  876.865184]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  876.895340]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  876.931201]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  876.961876]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  876.995663]  [<ffffffff81055735>] exit_files+0x45/0x50
[  877.026338]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  877.056490]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  877.088722]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  877.126143]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  877.156817]  [<ffffffff8138e0e7>] ? sys_recvfrom+0x127/0x170
[  877.190603]  [<ffffffff811284ef>] ? do_mlock_pages+0x11f/0x150
[  877.225428]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  877.259217]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  877.289890] xfdesktop       D ffff880c0fcd3b40     0  1691      1 0x=
00000004
[  877.332084]  ffff88100777dc88 0000000000000086 ffff881008c64ba0 ffff=
88100777dfd8
[  877.376459]  ffff88100777dfd8 ffff88100777dfd8 ffff880409c9a260 ffff=
881008c64ba0
[  877.420833]  ffff88100777dc78 ffff880809e49b30 ffff881008c64ba0 ffff=
880809e49b34
[  877.465208] Call Trace:
[  877.479797]  [<ffffffff814a6064>] schedule+0x24/0x70
[  877.509431]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  877.547372]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  877.584793]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  877.615466]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  877.652371]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  877.688800]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  877.721033]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  877.751704]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  877.781860]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  877.817723] xfsettingsd     D ffff880c0fc53b40     0  1699      1 0x=
00000004
[  877.859916]  ffff8808092a3c88 0000000000000086 ffff8808096e44c0 ffff=
8808092a3fd8
[  877.904291]  ffff8808092a3fd8 ffff8808092a3fd8 ffff880c082d0000 ffff=
8808096e44c0
[  877.948668]  ffff8808092a3c78 ffff880809e49b30 ffff8808096e44c0 ffff=
880809e49b34
[  877.993043] Call Trace:
[  878.007629]  [<ffffffff814a6064>] schedule+0x24/0x70
[  878.037264]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  878.075206]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  878.112626]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  878.143299]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  878.180205]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  878.216635]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  878.248867]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  878.279539]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  878.309694]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  878.345556] panel-6-systray D ffff88080fc53b40     0  1729   1687 0x=
00000002
[  878.387749]  ffff880806dd19c8 0000000000000046 ffff8808096ea260 ffff=
880806dd1fd8
[  878.432126]  ffff880806dd1fd8 ffff880806dd1fd8 ffff88080a0b74e0 ffff=
8808096ea260
[  878.476501]  ffff880806dd19c8 ffff8808096ea260 ffff88080fc543a0 0000=
000000000002
[  878.520876] Call Trace:
[  878.535462]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  878.567692]  [<ffffffff814a6064>] schedule+0x24/0x70
[  878.597328]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  878.628521]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  878.660234]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  878.692464]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  878.728846]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  878.762635]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  878.801612]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  878.839552]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  878.872821]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  878.912837]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  878.952855]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  878.988768]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  879.018925]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  879.054784]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  879.085459]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  879.119247]  [<ffffffff81055735>] exit_files+0x45/0x50
[  879.149920]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  879.180074]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  879.214381]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  879.250244]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  879.282476]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  879.319896]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  879.350568]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  879.383838]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  879.413992]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  879.447778]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  879.478454] panel-2-actions D ffff88080fc13b40     0  1731   1687 0x=
00000002
[  879.520645]  ffff881007c099c8 0000000000000046 ffff8810091ee720 ffff=
881007c09fd8
[  879.565021]  ffff881007c09fd8 ffff881007c09fd8 ffff880c07986040 ffff=
8810091ee720
[  879.609397]  ffff881007c099c8 ffff8810091ee720 ffff88080fc143a0 0000=
000000000002
[  879.653773] Call Trace:
[  879.668359]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  879.700589]  [<ffffffff814a6064>] schedule+0x24/0x70
[  879.730225]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  879.761417]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  879.793129]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  879.825361]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  879.861742]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  879.895529]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  879.934507]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  879.972448]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  880.005717]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  880.045731]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  880.085751]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  880.121664]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  880.151820]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  880.187680]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  880.218355]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  880.252144]  [<ffffffff81055735>] exit_files+0x45/0x50
[  880.282816]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  880.312971]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  880.347277]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  880.383141]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  880.415371]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  880.452793]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  880.483466]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  880.516734]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  880.546889]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  880.550621] ------------[ cut here ]------------
[  880.550627] WARNING: at fs/dcache.c:2628 prepend_path+0x1bb/0x1d0()
[  880.550628] Hardware name: H8DGU
[  880.550629] Root dentry has weird name <>
[  880.550668] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generi=
c powernow_k8 freq_table mperf kvm_amd kvm joydev igb amd64_edac_mod ev=
dev pcspkr edac_core edac_mce_amd microcode i2c_piix4 hid_generic dca p=
tp k10temp pps_core hwmon atiixp ide_core i2c_core processor button ext=
3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata scsi_m=
od usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  880.550670] Pid: 8367, comm: fuser Tainted: G        W    3.6.6-dirt=
y #16
[  880.550671] Call Trace:
[  880.550678]  [<ffffffff810500da>] warn_slowpath_common+0x7a/0xb0
[  880.550681]  [<ffffffff810501b1>] warn_slowpath_fmt+0x41/0x50
[  880.550683]  [<ffffffff811717db>] prepend_path+0x1bb/0x1d0
[  880.550686]  [<ffffffff8125df01>] ? bstr_printf+0x371/0x3d0
[  880.550689]  [<ffffffff81171847>] path_with_deleted+0x57/0xa0
[  880.550691]  [<ffffffff8117221d>] d_path+0x9d/0xd0
[  880.550694]  [<ffffffff8117d94c>] seq_path+0x4c/0xc0
[  880.550697]  [<ffffffff811b8125>] show_map_vma+0x145/0x270
[  880.550699]  [<ffffffff811b8477>] show_map+0x27/0x80
[  880.550701]  [<ffffffff811b84ee>] show_pid_map+0xe/0x10
[  880.550703]  [<ffffffff8117d780>] seq_read+0x230/0x3b0
[  880.550706]  [<ffffffff8115ce74>] vfs_read+0xa4/0x180
[  880.550707]  [<ffffffff8115cf95>] sys_read+0x45/0x90
[  880.550711]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  880.550712] ---[ end trace 728fc338d1c7927c ]---
[  881.615688]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  881.646361] wish            D ffff88040fcd3b40     0  1957      1 0x=
00000002
[  881.688552]  ffff880806de59c8 0000000000000046 ffff8808096906e0 ffff=
880806de5fd8
[  881.732929]  ffff880806de5fd8 ffff880806de5fd8 ffff880409d0c4c0 ffff=
8808096906e0
[  881.777304]  0000000000000000 ffff8808096906e0 ffff880806de5a70 0000=
000000000082
[  881.821679] Call Trace:
[  881.836277]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  881.883080]  [<ffffffff814a6064>] schedule+0x24/0x70
[  881.912722]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  881.953821]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  881.986057]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  882.032867]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  882.070289]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  882.109272]  [<ffffffffa043d008>] __rpc_wait_for_completion_task+0x2=
8/0x30 [sunrpc]
[  882.155048]  [<ffffffffa052e908>] nfs4_do_close+0x1b8/0x210 [nfsv4]
[  882.192520]  [<ffffffffa05371cb>] __nfs4_close+0xdb/0x180 [nfsv4]
[  882.228952]  [<ffffffffa05372a3>] nfs4_close_sync+0x13/0x20 [nfsv4]
[  882.266373]  [<ffffffffa0528d35>] nfs4_close_context+0x25/0x30 [nfsv=
4]
[  882.305352]  [<ffffffffa04f5cc8>] __put_nfs_open_context+0xa8/0x100 =
[nfs]
[  882.345939]  [<ffffffffa04f78a7>] nfs_release+0x97/0xb0 [nfs]
[  882.380296]  [<ffffffffa04f44d0>] nfs_file_release+0x20/0x30 [nfs]
[  882.417246]  [<ffffffff8115dc87>] __fput+0xe7/0x230
[  882.446364]  [<ffffffff8115ddd9>] ____fput+0x9/0x10
[  882.475480]  [<ffffffff8106fa63>] task_work_run+0x63/0x80
[  882.507710]  [<ffffffff810562e2>] do_exit+0x872/0x8e0
[  882.537865]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  882.572171]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  882.608035]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  882.640266]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  882.677686]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  882.708358]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  882.741629]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  882.771783]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  882.805570]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  882.836246] fuser           D ffff88080fc53b40     0  7986      1 0x=
00000000
[  882.878435]  ffff880806a4b988 0000000000000086 ffff880809695960 ffff=
880806a4bfd8
[  882.922813]  ffff880806a4bfd8 ffff880806a4bfd8 ffff880409c6d960 ffff=
880809695960
[  882.967186]  0000000000000000 ffff880809695960 ffff880806a4ba30 0000=
000000000082
[  883.011562] Call Trace:
[  883.026155]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  883.072964]  [<ffffffff814a6064>] schedule+0x24/0x70
[  883.102604]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  883.143706]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  883.175940]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  883.216010]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  883.262819]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  883.300238]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  883.339221]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  883.376694]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  883.414168]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  883.452158]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  883.488072]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  883.524507]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  883.561457]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  883.605625]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  883.644087]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  883.684673]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  883.723650]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  883.761591]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  883.802174]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  883.834924]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  883.865598]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  883.898348]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  883.931095]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  883.964365]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  883.999192]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  884.033498]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  884.064689]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  884.095881]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  884.125517]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  884.156711]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  884.188421]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  884.224284] fuser           D ffff88080fc53b40     0  7995      1 0x=
00000000
[  884.266479]  ffff881007a5d988 0000000000000082 ffff880fc6d6b020 ffff=
881007a5dfd8
[  884.310855]  ffff881007a5dfd8 ffff881007a5dfd8 ffff880409c6d960 ffff=
880fc6d6b020
[  884.355229]  0000000000000000 ffff880fc6d6b020 ffff881007a5da30 0000=
000000000082
[  884.399603] Call Trace:
[  884.414197]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  884.461006]  [<ffffffff814a6064>] schedule+0x24/0x70
[  884.490648]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  884.531747]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  884.563983]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  884.604050]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  884.650860]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  884.688282]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  884.727263]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  884.764735]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  884.802210]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  884.840200]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  884.876114]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  884.912549]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  884.949499]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  884.993668]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  885.032129]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  885.072716]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  885.111745]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  885.149736]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  885.190320]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  885.223070]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  885.253743]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  885.286493]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  885.319241]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  885.352509]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  885.387337]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  885.421641]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  885.452835]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  885.484027]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  885.513664]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  885.544855]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  885.576568]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  885.612431] fuser           D ffff880c0fc53b40     0  8008      1 0x=
00000000
[  885.654623]  ffff88100701d988 0000000000000082 ffff880fc6d686e0 ffff=
88100701dfd8
[  885.698999]  ffff88100701dfd8 ffff88100701dfd8 ffff880409c994a0 ffff=
880fc6d686e0
[  885.743375]  0000000000000000 ffff880fc6d686e0 ffff88100701da30 0000=
000000000082
[  885.787751] Call Trace:
[  885.802343]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  885.849150]  [<ffffffff814a6064>] schedule+0x24/0x70
[  885.878792]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  885.919893]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  885.952128]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  885.992196]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  886.039007]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  886.076427]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  886.115407]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  886.152829]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  886.190302]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  886.228295]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  886.264208]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  886.300643]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  886.337593]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  886.381761]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  886.420224]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  886.460809]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  886.499837]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  886.537777]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  886.578309]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  886.611060]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  886.641733]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  886.674482]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  886.707230]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  886.740500]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  886.775327]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  886.809634]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  886.840825]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  886.872017]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  886.901653]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  886.932845]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  886.964557]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  887.000420] fuser           D ffff88080fc53b40     0  8026      1 0x=
00000000
[  887.042613]  ffff880807983988 0000000000000086 ffff880809693700 ffff=
880807983fd8
[  887.086988]  ffff880807983fd8 ffff880807983fd8 ffff880409c6d960 ffff=
880809693700
[  887.131365]  0000000000000000 ffff880809693700 ffff880807983a30 0000=
000000000082
[  887.175739] Call Trace:
[  887.190332]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  887.237142]  [<ffffffff814a6064>] schedule+0x24/0x70
[  887.266782]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  887.307882]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  887.340116]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  887.380185]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  887.426997]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  887.464415]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  887.503397]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  887.540870]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  887.578344]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  887.616336]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  887.652249]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  887.688685]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  887.725634]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  887.769801]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  887.808265]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  887.848851]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  887.887880]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  887.925871]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  887.966404]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  887.999154]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  888.029826]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  888.062576]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  888.095324]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  888.128595]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  888.163420]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  888.197727]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  888.228919]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  888.260111]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  888.289746]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  888.320939]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  888.352651]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  888.388512] fuser           D ffff88080fc53b40     0  8242      1 0x=
00000000
[  888.430708]  ffff881008cdf988 0000000000000082 ffff880fc6d6a940 ffff=
881008cdffd8
[  888.475083]  ffff881008cdffd8 ffff881008cdffd8 ffff880409c6d960 ffff=
880fc6d6a940
[  888.519457]  0000000000000000 ffff880fc6d6a940 ffff881008cdfa30 0000=
000000000082
[  888.563833] Call Trace:
[  888.578427]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  888.625235]  [<ffffffff814a6064>] schedule+0x24/0x70
[  888.654877]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  888.695977]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  888.728212]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  888.768280]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  888.815089]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  888.852509]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  888.891491]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  888.928965]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  888.966438]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  889.004429]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  889.040345]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  889.076778]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  889.113728]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  889.157897]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  889.196359]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  889.236945]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  889.275974]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  889.313966]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  889.354548]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  889.387297]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  889.417971]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  889.450720]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  889.483470]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  889.516738]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  889.551565]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  889.585871]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  889.617064]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  889.648257]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  889.677891]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  889.709084]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  889.740797]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  889.776661] fuser           D ffff88080fc53b40     0  8251      1 0x=
00000000
[  889.818853]  ffff8804005a9988 0000000000000086 ffff8804068ce720 ffff=
8804005a9fd8
[  889.863227]  ffff8804005a9fd8 ffff8804005a9fd8 ffff880409c6d960 ffff=
8804068ce720
[  889.907603]  0000000000000000 ffff8804068ce720 ffff8804005a9a30 0000=
000000000082
[  889.951980] Call Trace:
[  889.966573]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  890.013380]  [<ffffffff814a6064>] schedule+0x24/0x70
[  890.043021]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  890.084122]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  890.116356]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  890.156426]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  890.203236]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  890.240655]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  890.279638]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  890.317108]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  890.354530]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  890.392525]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  890.428437]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  890.464871]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  890.501823]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  890.545991]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  890.584451]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  890.589415] ------------[ cut here ]------------
[  890.589423] WARNING: at fs/dcache.c:2628 prepend_path+0x1bb/0x1d0()
[  890.589425] Hardware name: H8DGU
[  890.589425] Root dentry has weird name <>
[  890.589472] Modules linked in: nfsv4 fuse nfsv3 nfs fscache nfsd loc=
kd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_=
sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip=
table_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filt=
er ip6_tables x_tables ext4 jbd2 crc16 raid0 dm_mod autofs4 dummy ide_c=
d_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generi=
c powernow_k8 freq_table mperf kvm_amd kvm joydev igb amd64_edac_mod ev=
dev pcspkr edac_core edac_mce_amd microcode i2c_piix4 hid_generic dca p=
tp k10temp pps_core hwmon atiixp ide_core i2c_core processor button ext=
3 jbd mbcache sd_mod crc_t10dif raid1 md_mod ahci libahci libata scsi_m=
od usbhid hid ohci_hcd ehci_hcd usbcore usb_common
[  890.589475] Pid: 8367, comm: fuser Tainted: G        W    3.6.6-dirt=
y #16
[  890.589476] Call Trace:
[  890.589485]  [<ffffffff810500da>] warn_slowpath_common+0x7a/0xb0
[  890.589488]  [<ffffffff810501b1>] warn_slowpath_fmt+0x41/0x50
[  890.589492]  [<ffffffff8125c403>] ? format_decode+0x2a3/0x3c0
[  890.589494]  [<ffffffff811717db>] prepend_path+0x1bb/0x1d0
[  890.589497]  [<ffffffff8125df01>] ? bstr_printf+0x371/0x3d0
[  890.589500]  [<ffffffff81171847>] path_with_deleted+0x57/0xa0
[  890.589502]  [<ffffffff8117221d>] d_path+0x9d/0xd0
[  890.589506]  [<ffffffff8117d94c>] seq_path+0x4c/0xc0
[  890.589509]  [<ffffffff811b8125>] show_map_vma+0x145/0x270
[  890.589511]  [<ffffffff811b8477>] show_map+0x27/0x80
[  890.589513]  [<ffffffff811b84ee>] show_pid_map+0xe/0x10
[  890.589515]  [<ffffffff8117d780>] seq_read+0x230/0x3b0
[  890.589518]  [<ffffffff8115ce74>] vfs_read+0xa4/0x180
[  890.589520]  [<ffffffff8115cf95>] sys_read+0x45/0x90
[  890.589524]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  890.589525] ---[ end trace 728fc338d1c7927d ]---
[  891.694355]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  891.733333]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  891.771324]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  891.811856]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  891.844606]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  891.875330]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  891.908081]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  891.940828]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  891.974098]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  892.008923]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  892.043230]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  892.074422]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  892.105616]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  892.135252]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  892.166444]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  892.198156]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  892.234018] fuser           D ffff88080fc53b40     0  8264      1 0x=
00000000
[  892.276211]  ffff880c0a159988 0000000000000082 ffff880c08d5b020 ffff=
880c0a159fd8
[  892.320588]  ffff880c0a159fd8 ffff880c0a159fd8 ffff880409c6d960 ffff=
880c08d5b020
[  892.364961]  0000000000000000 ffff880c08d5b020 ffff880c0a159a30 0000=
000000000082
[  892.409338] Call Trace:
[  892.423930]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  892.470740]  [<ffffffff814a6064>] schedule+0x24/0x70
[  892.500379]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  892.541480]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  892.573715]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  892.613784]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  892.660594]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  892.698014]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  892.736995]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  892.774468]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  892.811941]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  892.849934]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  892.885848]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  892.922282]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  892.959234]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  893.003401]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  893.041863]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  893.082450]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  893.121478]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  893.159418]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  893.200001]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  893.232752]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  893.263424]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  893.296174]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  893.328923]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  893.362192]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  893.397019]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  893.431323]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  893.462517]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  893.493710]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  893.523346]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  893.554538]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  893.586249]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  893.622113] fuser           D ffff880c0fc53b40     0  8280      1 0x=
00000000
[  893.664304]  ffff8808073d5988 0000000000000082 ffff880809696720 ffff=
8808073d5fd8
[  893.708681]  ffff8808073d5fd8 ffff8808073d5fd8 ffff880409c994a0 ffff=
880809696720
[  893.753055]  0000000000000000 ffff880809696720 ffff8808073d5a30 0000=
000000000082
[  893.797431] Call Trace:
[  893.812025]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  893.858834]  [<ffffffff814a6064>] schedule+0x24/0x70
[  893.888473]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  893.929574]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  893.961809]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  894.001877]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  894.048688]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  894.086108]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  894.125090]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  894.162561]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  894.200035]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  894.238027]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  894.273941]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  894.310377]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  894.347328]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  894.391494]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  894.429957]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  894.470542]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  894.509520]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  894.547511]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  894.588095]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  894.620844]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  894.651518]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  894.684268]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  894.717016]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  894.750286]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  894.785113]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  894.819418]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  894.850610]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  894.881802]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  894.911437]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  894.942632]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  894.974342]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  895.010205] fuser           D ffff88101fc53b40     0  8541   8367 0x=
00000000
[  895.052398]  ffff88040721d988 0000000000000082 ffff8804068ca940 ffff=
88040721dfd8
[  895.096775]  ffff88040721dfd8 ffff88040721dfd8 ffff880409c6f4e0 ffff=
8804068ca940
[  895.141150]  0000000000000000 ffff8804068ca940 ffff88040721da30 0000=
000000000082
[  895.185524] Call Trace:
[  895.200119]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  895.246925]  [<ffffffff814a6064>] schedule+0x24/0x70
[  895.276566]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  895.317667]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  895.349903]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  895.389972]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  895.436780]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  895.474202]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  895.513183]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  895.550654]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  895.588079]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  895.626070]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  895.661985]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  895.698418]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  895.735369]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  895.779536]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  895.817998]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  895.858584]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  895.897614]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  895.935603]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  895.976137]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  896.008886]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  896.039561]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  896.072310]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  896.105059]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  896.138326]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  896.173153]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  896.207458]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  896.238651]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  896.269844]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  896.299480]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  896.330674]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  896.362383]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  896.398248] fuser           D ffff88040fc53b40     0  8550   8367 0x=
00000000
[  896.440442]  ffff880c0832f988 0000000000000082 ffff880c08d5b700 ffff=
880c0832ffd8
[  896.484816]  ffff880c0832ffd8 ffff880c0832ffd8 ffff880409c6bde0 ffff=
880c08d5b700
[  896.529193]  0000000000000000 ffff880c08d5b700 ffff880c0832fa30 0000=
000000000082
[  896.573568] Call Trace:
[  896.588160]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  896.634969]  [<ffffffff814a6064>] schedule+0x24/0x70
[  896.664610]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  896.705709]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  896.737946]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  896.778014]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  896.824824]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  896.862243]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  896.901224]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  896.938699]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  896.976171]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  897.014163]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  897.050076]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  897.086511]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  897.123462]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  897.167628]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  897.206091]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  897.246679]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  897.285706]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  897.323645]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  897.364177]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  897.396929]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  897.427601]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  897.460350]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  897.493101]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  897.526369]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  897.561196]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  897.595500]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  897.626695]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  897.657885]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  897.687522]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  897.718713]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  897.750425]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  897.786289] fuser           D ffff880c0fc53b40     0  8563   8367 0x=
00000000
[  897.828481]  ffff881007655988 0000000000000086 ffff880fc6d6f4e0 ffff=
881007655fd8
[  897.872856]  ffff881007655fd8 ffff881007655fd8 ffff880409c994a0 ffff=
880fc6d6f4e0
[  897.917233]  0000000000000000 ffff880fc6d6f4e0 ffff881007655a30 0000=
000000000082
[  897.961610] Call Trace:
[  897.976202]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  898.023009]  [<ffffffff814a6064>] schedule+0x24/0x70
[  898.052650]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  898.093752]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  898.125987]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  898.166055]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  898.212864]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  898.250286]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  898.289265]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  898.326688]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  898.364161]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  898.402152]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  898.438066]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  898.474501]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  898.511453]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  898.555619]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  898.594081]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  898.634667]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  898.673645]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  898.711635]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  898.752168]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  898.784917]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  898.815590]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  898.848341]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  898.881088]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  898.914359]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  898.949184]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  898.983491]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  899.014684]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  899.045875]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  899.075511]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  899.106705]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  899.138416]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  899.174278] fuser           D ffff88080fc53b40     0  8579   8367 0x=
00000000
[  899.216473]  ffff880407303988 0000000000000086 ffff8804068c9b80 ffff=
880407303fd8
[  899.260848]  ffff880407303fd8 ffff880407303fd8 ffff880409c6d960 ffff=
8804068c9b80
[  899.305224]  0000000000000000 ffff8804068c9b80 ffff880407303a30 0000=
000000000082
[  899.349599] Call Trace:
[  899.364192]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  899.410999]  [<ffffffff814a6064>] schedule+0x24/0x70
[  899.440642]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  899.481741]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  899.513976]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  899.554046]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  899.600855]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  899.638275]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  899.677255]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  899.714678]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  899.752151]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  899.790144]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  899.826056]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  899.862493]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  899.899442]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  899.943610]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  899.982070]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  900.022658]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  900.061685]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  900.099627]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  900.140211]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  900.172961]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  900.203633]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  900.236384]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  900.269132]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  900.302401]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  900.337228]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  900.371532]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  900.402725]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  900.433917]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  900.463552]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  900.494746]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  900.526458]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
Cannot stat file /proc/1683/fd/2: Connection timed out
Cannot stat file /proc/1687/fd/1: Connection timed out
Cannot stat file /proc/1687/fd/2: Connection timed out
Cannot stat file /proc/1691/fd/1: Connection timed out
Cannot stat file /proc/1691/fd/2: Connection timed out
Cannot stat file /proc/1699/fd/1: Connection timed out
Cannot stat file /proc/1699/fd/2: Connection timed out
[  906.076873] md2: detected capacity change from 1739805687808 to 0
[  906.113310] md: md2 stopped.
[  906.130532] md: unbind<sda4>
[  906.161287] md: export_rdev(sda4)
[  906.181109] md: unbind<sdd4>
[  906.198378] md: export_rdev(sdd4)
[  906.218230] md: unbind<sdc4>
[  906.235493] md: export_rdev(sdc4)
[  906.255326] md: unbind<sdb4>
[  906.272595] md: export_rdev(sdb4)
Please stand by while rebooting the system.........................=1B[=
68G=1B[m=0F=1B[36m[=1B[m=0F=1B[32m DONE =1B[m=0F=1B[36m]=1B[m=0F=1B[315=
m
[  922.048389] SysRq : Show Blocked State
[  922.070840]   task                        PC stack   pid father
[  922.106234] Xvnc            D ffff88080fcd3b40     0  1657      1 0x=
00000002
[  922.148434]  ffff880c0834bb98 0000000000000046 ffff880c07980dc0 ffff=
880c0834bfd8
[  922.192807]  ffff880c0834bfd8 ffff880c0834bfd8 ffff880809259b80 ffff=
880c07980dc0
[  922.237183]  ffff880c0834bb98 ffff880c07980dc0 ffff88080fcd43a0 0000=
000000000002
[  922.281558] Call Trace:
[  922.296148]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  922.328375]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.358010]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  922.389204]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  922.420917]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.453147]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  922.489529]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  922.523317]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.562294]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  922.600235]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  922.633502]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  922.673518]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  922.713539]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  922.749450]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  922.779607]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  922.815523]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  922.815526]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  922.815529]  [<ffffffff81055735>] exit_files+0x45/0x50
[  922.815531]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  922.815534]  [<ffffffff8112add8>] ? do_munmap+0x328/0x400
[  922.815536]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  922.815539]  [<ffffffff81056712>] sys_exit_group+0x12/0x20
[  922.815541]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.815545] vncconfig       D ffff88080fc53b40     0  1662      1 0x=
00000002
[  922.815548]  ffff880c08c7d9c8 0000000000000046 ffff880c07982940 ffff=
880c08c7dfd8
[  922.815550]  ffff880c08c7dfd8 ffff880c08c7dfd8 ffff8808096e9b80 ffff=
880c07982940
[  922.815552]  ffff880c08c7d9c8 ffff880c07982940 ffff88080fc543a0 0000=
000000000002
[  922.815553] Call Trace:
[  922.815555]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  922.815557]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.815558]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  922.815560]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  922.815563]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.815565]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  922.815567]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  922.815569]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.815571]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  922.815573]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  922.815575]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  922.815577]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  922.815583]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  922.815585]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  922.815590]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  922.815592]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  922.815594]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  922.815597]  [<ffffffff81055735>] exit_files+0x45/0x50
[  922.815599]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  922.815602]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  922.815604]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  922.815607]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  922.815609]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  922.815612]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  922.815615]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  922.815617]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  922.815620]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  922.815622]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  922.815625] sh              D ffff88080fcd3b40     0  1665      1 0x=
00000006
[  922.815627]  ffff880806e559c8 0000000000000046 ffff8808096e2260 ffff=
880806e55fd8
[  922.815630]  ffff880806e55fd8 ffff880806e55fd8 ffff880409c6e720 ffff=
8808096e2260
[  922.815632]  ffff880806e559c8 ffff8808096e2260 ffff88080fcd43a0 0000=
000000000002
[  922.815632] Call Trace:
[  922.815635]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  922.815636]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.815638]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  922.815640]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  922.815642]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.815644]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  922.815646]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  922.815648]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.815650]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  922.815652]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  922.815654]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  922.815657]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  922.815662]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  922.815664]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  922.815669]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  922.815671]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  922.815673]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  922.815676]  [<ffffffff81055735>] exit_files+0x45/0x50
[  922.815678]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  922.815681]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  922.815683]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  922.815685]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  922.815687]  [<ffffffff8104d00b>] ? __mmdrop+0x5b/0x90
[  922.815690]  [<ffffffff811284ef>] ? do_mlock_pages+0x11f/0x150
[  922.815692]  [<ffffffff814a595e>] ? __schedule+0x2ce/0x6f0
[  922.815694]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  922.815696]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  922.815699] xfce4-session   D ffff880c0fc13b40     0  1671   1665 0x=
00000002
[  922.815702]  ffff8808073cd9c8 0000000000000046 ffff8808096e1b80 ffff=
8808073cdfd8
[  922.815704]  ffff8808073cdfd8 ffff8808073cdfd8 ffff880c0660b700 ffff=
8808096e1b80
[  922.815706]  ffff8808073cd9c8 ffff8808096e1b80 ffff880c0fc143a0 0000=
000000000002
[  922.815707] Call Trace:
[  922.815709]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  922.815710]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.815712]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  922.815714]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  922.815716]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.815718]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  922.815720]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  922.815722]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.815724]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  922.815727]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  922.815729]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  922.815731]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  922.815736]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  922.815738]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  922.815743]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  922.815745]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  922.815747]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  922.815750]  [<ffffffff81055735>] exit_files+0x45/0x50
[  922.815752]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  922.815755]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  922.815756]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  922.815759]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  922.815761]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  922.815763]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  922.815766]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  922.815768]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  922.815769]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  922.815771]  [<ffffffff8116f580>] ? __pollwait+0xf0/0xf0
[  922.815774]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  922.815775]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  922.815779] xfwm4           D ffff88080fc93b40     0  1683      1 0x=
00000004
[  922.815781]  ffff881007b5fa38 0000000000000086 ffff881008c63700 ffff=
881007b5ffd8
[  922.815784]  ffff881007b5ffd8 ffff881007b5ffd8 ffff8808096e8dc0 ffff=
881008c63700
[  922.815786]  ffff881007b5fa38 ffff881008c63700 ffff88080fc943a0 0000=
000000000002
[  922.815786] Call Trace:
[  922.815788]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  922.815790]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.815792]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  922.815794]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  922.815796]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.815798]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  922.815800]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.815803]  [<ffffffff810fe78c>] grab_cache_page_write_begin+0xac/0=
xf0
[  922.815808]  [<ffffffffa04f4c7b>] nfs_write_begin+0x5b/0x1f0 [nfs]
[  922.815810]  [<ffffffff810fd546>] generic_file_buffered_write+0x116/=
0x280
[  922.815813]  [<ffffffff810ff245>] __generic_file_aio_write+0x1c5/0x3=
c0
[  922.815815]  [<ffffffff814a4f9a>] ? __mutex_lock_slowpath+0x20a/0x2b=
0
[  922.815818]  [<ffffffff810ff4ba>] generic_file_aio_write+0x7a/0xf0
[  922.815824]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  922.815826]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  922.815828]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  922.815830]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  922.815832]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.815835] xfce4-panel     D ffff88080fc53b40     0  1687      1 0x=
00000004
[  922.815837]  ffff8804097ebc88 0000000000000082 ffff880409a9a260 ffff=
8804097ebfd8
[  922.815839]  ffff8804097ebfd8 ffff8804097ebfd8 ffff880806921b80 ffff=
880409a9a260
[  922.815842]  ffff8804097ebc78 ffff880809e49b30 ffff880409a9a260 ffff=
880809e49b34
[  922.815842] Call Trace:
[  922.815844]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.815846]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  922.815849]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  922.815851]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  922.815853]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  922.815859]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  922.815860]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  922.815863]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  922.815865]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  922.815867]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.815870] Thunar          D ffff880c0fc93b40     0  1689      1 0x=
00000002
[  922.815872]  ffff8808074479c8 0000000000000046 ffff88080965a940 ffff=
880807447fd8
[  922.815874]  ffff880807447fd8 ffff880807447fd8 ffff8808096e4ba0 ffff=
88080965a940
[  922.815877]  ffff8808074479c8 ffff88080965a940 ffff880c0fc943a0 0000=
000000000002
[  922.815877] Call Trace:
[  922.815879]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  922.815881]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.815883]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  922.815884]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  922.815887]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.815889]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  922.815891]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  922.815893]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.815895]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  922.815897]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  922.815899]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  922.815901]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  922.815907]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  922.815909]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  922.815914]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  922.815915]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  922.815918]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  922.815920]  [<ffffffff81055735>] exit_files+0x45/0x50
[  922.815923]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  922.815925]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  922.815927]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  922.815930]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  922.815932]  [<ffffffff8138e0e7>] ? sys_recvfrom+0x127/0x170
[  922.815934]  [<ffffffff811284ef>] ? do_mlock_pages+0x11f/0x150
[  922.815937]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  922.815938]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  922.815942] xfdesktop       D ffff880c0fcd3b40     0  1691      1 0x=
00000004
[  922.815944]  ffff88100777dc88 0000000000000086 ffff881008c64ba0 ffff=
88100777dfd8
[  922.815947]  ffff88100777dfd8 ffff88100777dfd8 ffff880409c9a260 ffff=
881008c64ba0
[  922.815949]  ffff88100777dc78 ffff880809e49b30 ffff881008c64ba0 ffff=
880809e49b34
[  922.815949] Call Trace:
[  922.815951]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.815953]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  922.815955]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  922.815958]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  922.815960]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  922.815966]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  922.815968]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  922.815970]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  922.815972]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  922.815974]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.815977] xfsettingsd     D ffff880c0fc53b40     0  1699      1 0x=
00000004
[  922.815979]  ffff8808092a3c88 0000000000000086 ffff8808096e44c0 ffff=
8808092a3fd8
[  922.815982]  ffff8808092a3fd8 ffff8808092a3fd8 ffff880c082d0000 ffff=
8808096e44c0
[  922.815984]  ffff8808092a3c78 ffff880809e49b30 ffff8808096e44c0 ffff=
880809e49b34
[  922.815984] Call Trace:
[  922.815986]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.815988]  [<ffffffff814a62f9>] schedule_preempt_disabled+0x9/0x10=

[  922.815990]  [<ffffffff814a4ead>] __mutex_lock_slowpath+0x11d/0x2b0
[  922.815993]  [<ffffffff814a5059>] mutex_lock+0x19/0x30
[  922.815995]  [<ffffffff810ff4a6>] generic_file_aio_write+0x66/0xf0
[  922.816001]  [<ffffffffa04f5193>] nfs_file_write+0xa3/0x190 [nfs]
[  922.816003]  [<ffffffff8115c497>] do_sync_write+0xa7/0xe0
[  922.816005]  [<ffffffff8115ccf7>] vfs_write+0xa7/0x180
[  922.816007]  [<ffffffff8115d025>] sys_write+0x45/0x90
[  922.816009]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.816012] panel-6-systray D ffff88080fc53b40     0  1729   1687 0x=
00000002
[  922.816014]  ffff880806dd19c8 0000000000000046 ffff8808096ea260 ffff=
880806dd1fd8
[  922.816016]  ffff880806dd1fd8 ffff880806dd1fd8 ffff88080a0b74e0 ffff=
8808096ea260
[  922.816019]  ffff880806dd19c8 ffff8808096ea260 ffff88080fc543a0 0000=
000000000002
[  922.816019] Call Trace:
[  922.816021]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  922.816023]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.816024]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  922.816026]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  922.816029]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.816031]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  922.816032]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  922.816035]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.816037]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  922.816039]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  922.816041]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  922.816043]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  922.816048]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  922.816051]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  922.816056]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  922.816057]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  922.816060]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  922.816062]  [<ffffffff81055735>] exit_files+0x45/0x50
[  922.816065]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  922.816067]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  922.816069]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  922.816071]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  922.816073]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  922.816076]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  922.816078]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  922.816080]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  922.816082]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  922.816084]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  922.816087] panel-2-actions D ffff88080fc13b40     0  1731   1687 0x=
00000002
[  922.816089]  ffff881007c099c8 0000000000000046 ffff8810091ee720 ffff=
881007c09fd8
[  922.816092]  ffff881007c09fd8 ffff881007c09fd8 ffff880c07986040 ffff=
8810091ee720
[  922.816094]  ffff881007c099c8 ffff8810091ee720 ffff88080fc143a0 0000=
000000000002
[  922.816094] Call Trace:
[  922.816097]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  922.816098]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.816100]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  922.816102]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  922.816104]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.816106]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  922.816108]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  922.816110]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.816112]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  922.816114]  [<ffffffff811091ac>] ? do_writepages+0x1c/0x40
[  922.816117]  [<ffffffff810fee61>] ? __filemap_fdatawrite_range+0x51/=
0x60
[  922.816119]  [<ffffffff810feed5>] filemap_write_and_wait_range+0x65/=
0x70
[  922.816124]  [<ffffffffa04f4379>] nfs_file_fsync+0x39/0x90 [nfs]
[  922.816126]  [<ffffffff81189716>] vfs_fsync+0x26/0x40
[  922.816131]  [<ffffffffa04f4a7e>] nfs_file_flush+0x6e/0x90 [nfs]
[  922.816133]  [<ffffffff8115ab4a>] filp_close+0x3a/0x90
[  922.816135]  [<ffffffff81055634>] put_files_struct+0x94/0xf0
[  922.816138]  [<ffffffff81055735>] exit_files+0x45/0x50
[  922.816140]  [<ffffffff81055bec>] do_exit+0x17c/0x8e0
[  922.816142]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  922.816144]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  922.816147]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  922.816149]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  922.816151]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  922.816153]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  922.816155]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  922.816157]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  922.816159]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  922.816163] wish            D ffff88040fcd3b40     0  1957      1 0x=
00000002
[  922.816165]  ffff880806de59c8 0000000000000046 ffff8808096906e0 ffff=
880806de5fd8
[  922.816167]  ffff880806de5fd8 ffff880806de5fd8 ffff880409d0c4c0 ffff=
8808096906e0
[  922.816170]  0000000000000000 ffff8808096906e0 ffff880806de5a70 0000=
000000000082
[  922.816170] Call Trace:
[  922.816183]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816185]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.816192]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.816195]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.816203]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816205]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.816207]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.816215]  [<ffffffffa043d008>] __rpc_wait_for_completion_task+0x2=
8/0x30 [sunrpc]
[  922.816221]  [<ffffffffa052e908>] nfs4_do_close+0x1b8/0x210 [nfsv4]
[  922.816227]  [<ffffffffa05371cb>] __nfs4_close+0xdb/0x180 [nfsv4]
[  922.816232]  [<ffffffffa05372a3>] nfs4_close_sync+0x13/0x20 [nfsv4]
[  922.816235]  [<ffffffffa0528d35>] nfs4_close_context+0x25/0x30 [nfsv=
4]
[  922.816241]  [<ffffffffa04f5cc8>] __put_nfs_open_context+0xa8/0x100 =
[nfs]
[  922.816247]  [<ffffffffa04f78a7>] nfs_release+0x97/0xb0 [nfs]
[  922.816252]  [<ffffffffa04f44d0>] nfs_file_release+0x20/0x30 [nfs]
[  922.816254]  [<ffffffff8115dc87>] __fput+0xe7/0x230
[  922.816256]  [<ffffffff8115ddd9>] ____fput+0x9/0x10
[  922.816258]  [<ffffffff8106fa63>] task_work_run+0x63/0x80
[  922.816260]  [<ffffffff810562e2>] do_exit+0x872/0x8e0
[  922.816263]  [<ffffffff810620e8>] ? __sigqueue_free+0x38/0x40
[  922.816265]  [<ffffffff81062760>] ? __dequeue_signal+0x110/0x1e0
[  922.816268]  [<ffffffff8105669a>] do_group_exit+0x3a/0xa0
[  922.816270]  [<ffffffff81064e25>] get_signal_to_deliver+0x1c5/0x600
[  922.816272]  [<ffffffff8101327a>] do_signal+0x3a/0x610
[  922.816274]  [<ffffffff8138e0aa>] ? sys_recvfrom+0xea/0x170
[  922.816276]  [<ffffffff8115ddd9>] ? ____fput+0x9/0x10
[  922.816278]  [<ffffffff810138f0>] do_notify_resume+0x80/0xc0
[  922.816280]  [<ffffffff814aec32>] int_signal+0x12/0x17
[  922.816285] fuser           D ffff88080fc53b40     0  7986      1 0x=
00000000
[  922.816288]  ffff880806a4b988 0000000000000086 ffff880809695960 ffff=
880806a4bfd8
[  922.816290]  ffff880806a4bfd8 ffff880806a4bfd8 ffff880409c6d960 ffff=
880809695960
[  922.816292]  0000000000000000 ffff880809695960 ffff880806a4ba30 0000=
000000000082
[  922.816293] Call Trace:
[  922.816301]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816303]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.816310]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.816312]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.816319]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.816327]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816329]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.816332]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.816338]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.816344]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.816351]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.816359]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.816366]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.816372]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.816376]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.816378]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.816384]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.816390]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.816395]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.816400]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.816402]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.816405]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.816407]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.816409]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.816411]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.816413]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.816416]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.816418]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.816420]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.816422]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.816424]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.816427]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.816429]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.816431] fuser           D ffff88080fc53b40     0  7995      1 0x=
00000000
[  922.816433]  ffff881007a5d988 0000000000000082 ffff880fc6d6b020 ffff=
881007a5dfd8
[  922.816436]  ffff881007a5dfd8 ffff881007a5dfd8 ffff880409c6d960 ffff=
880fc6d6b020
[  922.816438]  0000000000000000 ffff880fc6d6b020 ffff881007a5da30 0000=
000000000082
[  922.816438] Call Trace:
[  922.816446]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816448]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.816456]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.816458]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.816465]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.816472]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816475]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.816477]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.816483]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.816489]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.816497]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.816504]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.816511]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.816517]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.816520]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.816523]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.816529]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.816534]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.816539]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.816544]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.816546]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.816549]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.816550]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.816553]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.816554]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.816556]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.816559]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.816561]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.816563]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.816565]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.816567]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.816569]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.816571]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.816574] fuser           D ffff880c0fc53b40     0  8008      1 0x=
00000000
[  922.816576]  ffff88100701d988 0000000000000082 ffff880fc6d686e0 ffff=
88100701dfd8
[  922.816578]  ffff88100701dfd8 ffff88100701dfd8 ffff880409c994a0 ffff=
880fc6d686e0
[  922.816581]  0000000000000000 ffff880fc6d686e0 ffff88100701da30 0000=
000000000082
[  922.816581] Call Trace:
[  922.816589]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816591]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.816598]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.816601]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.816607]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.816615]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816617]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.816619]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.816626]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.816632]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.816639]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.816647]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.816653]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.816659]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.816663]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.816665]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.816671]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.816677]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.816682]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.816687]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.816689]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.816691]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.816693]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.816695]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.816697]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.816699]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.816701]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.816703]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.816705]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.816707]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.816709]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.816711]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.816713]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.816716] fuser           D ffff88080fc53b40     0  8026      1 0x=
00000000
[  922.816719]  ffff880807983988 0000000000000086 ffff880809693700 ffff=
880807983fd8
[  922.816721]  ffff880807983fd8 ffff880807983fd8 ffff880409c6d960 ffff=
880809693700
[  922.816723]  0000000000000000 ffff880809693700 ffff880807983a30 0000=
000000000082
[  922.816724] Call Trace:
[  922.816732]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816733]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.816741]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.816743]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.816750]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.816757]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816760]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.816762]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.816768]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.816774]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.816782]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.816789]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.816796]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.816802]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.816805]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.816808]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.816814]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.816820]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.816824]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.816829]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.816831]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.816834]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.816835]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.816838]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.816839]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.816841]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.816844]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.816846]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.816848]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.816850]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.816852]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.816854]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.816856]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.816859] fuser           D ffff88080fc53b40     0  8242      1 0x=
00000000
[  922.816861]  ffff881008cdf988 0000000000000082 ffff880fc6d6a940 ffff=
881008cdffd8
[  922.816864]  ffff881008cdffd8 ffff881008cdffd8 ffff880409c6d960 ffff=
880fc6d6a940
[  922.816866]  0000000000000000 ffff880fc6d6a940 ffff881008cdfa30 0000=
000000000082
[  922.816866] Call Trace:
[  922.816874]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816876]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.816883]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.816886]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.816892]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.816900]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.816902]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.816905]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.816911]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.816917]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.816924]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.816932]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.816938]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.816945]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.816948]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.816950]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.816956]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.816962]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.816967]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.816972]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.816974]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.816976]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.816978]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.816980]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.816982]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.816984]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.816986]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.816988]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.816990]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.816992]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.816994]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.816997]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.816999]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.817001] fuser           D ffff88080fc53b40     0  8251      1 0x=
00000000
[  922.817004]  ffff8804005a9988 0000000000000086 ffff8804068ce720 ffff=
8804005a9fd8
[  922.817006]  ffff8804005a9fd8 ffff8804005a9fd8 ffff880409c6d960 ffff=
8804068ce720
[  922.817009]  0000000000000000 ffff8804068ce720 ffff8804005a9a30 0000=
000000000082
[  922.817009] Call Trace:
[  922.817017]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817019]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.817026]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.817029]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.817035]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.817042]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817045]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.817047]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.817053]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817060]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817067]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.817075]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.817081]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.817088]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.817090]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.817093]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.817099]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.817105]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.817110]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.817115]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.817117]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.817119]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.817121]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.817123]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.817125]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.817126]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.817129]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.817131]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.817133]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.817135]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.817137]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.817139]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.817141]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.817144] fuser           D ffff88080fc53b40     0  8264      1 0x=
00000000
[  922.817146]  ffff880c0a159988 0000000000000082 ffff880c08d5b020 ffff=
880c0a159fd8
[  922.817149]  ffff880c0a159fd8 ffff880c0a159fd8 ffff880409c6d960 ffff=
880c08d5b020
[  922.817151]  0000000000000000 ffff880c08d5b020 ffff880c0a159a30 0000=
000000000082
[  922.817151] Call Trace:
[  922.817159]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817161]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.817168]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.817171]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.817177]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.817185]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817187]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.817190]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.817196]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817202]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817209]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.817217]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.817224]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.817230]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.817233]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.817235]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.817241]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.817247]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.817252]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.817257]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.817259]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.817261]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.817263]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.817265]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.817267]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.817269]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.817271]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.817273]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.817275]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.817277]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.817279]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.817282]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.817284]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.817287] fuser           D ffff88080fc53b40     0  8280      1 0x=
00000000
[  922.817289]  ffff8808073d5988 0000000000000082 ffff880809696720 ffff=
8808073d5fd8
[  922.817291]  ffff8808073d5fd8 ffff8808073d5fd8 ffff880409c6d960 ffff=
880809696720
[  922.817294]  0000000000000000 ffff880809696720 ffff8808073d5a30 0000=
000000000082
[  922.817294] Call Trace:
[  922.817302]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817304]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.817311]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.817313]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.817320]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.817327]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817330]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.817332]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.817338]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817344]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817352]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.817360]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.817366]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.817372]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.817375]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.817378]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.817384]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.817390]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.817394]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.817399]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.817402]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.817404]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.817406]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.817408]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.817409]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.817411]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.817414]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.817416]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.817418]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.817420]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.817422]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.817424]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.817426]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.817429] fuser           D ffff88101fc53b40     0  8541      1 0x=
00000000
[  922.817431]  ffff88040721d988 0000000000000082 ffff8804068ca940 ffff=
88040721dfd8
[  922.817434]  ffff88040721dfd8 ffff88040721dfd8 ffff880409c6f4e0 ffff=
8804068ca940
[  922.817436]  0000000000000000 ffff8804068ca940 ffff88040721da30 0000=
000000000082
[  922.817436] Call Trace:
[  922.817444]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817446]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.817453]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.817456]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.817462]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.817470]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817472]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.817474]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.817481]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817487]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817494]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.817502]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.817508]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.817514]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.817517]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.817520]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.817526]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.817532]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.817536]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.817541]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.817543]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.817546]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.817547]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.817550]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.817551]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.817553]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.817556]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.817557]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.817559]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.817562]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.817564]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.817566]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.817568]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.817571] fuser           D ffff88040fc53b40     0  8550      1 0x=
00000000
[  922.817573]  ffff880c0832f988 0000000000000082 ffff880c08d5b700 ffff=
880c0832ffd8
[  922.817575]  ffff880c0832ffd8 ffff880c0832ffd8 ffff880409c6bde0 ffff=
880c08d5b700
[  922.817577]  0000000000000000 ffff880c08d5b700 ffff880c0832fa30 0000=
000000000082
[  922.817578] Call Trace:
[  922.817586]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817588]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.817595]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.817597]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.817604]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.817611]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817614]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.817616]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.817622]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817628]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817636]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.817643]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.817650]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.817656]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.817659]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.817662]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.817668]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.817673]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.817678]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.817683]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.817685]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.817688]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.817689]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.817692]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.817693]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.817695]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.817697]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.817699]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.817701]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.817704]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.817706]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.817708]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.817710]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.817713] fuser           D ffff880c0fc53b40     0  8563      1 0x=
00000000
[  922.817715]  ffff881007655988 0000000000000086 ffff880fc6d6f4e0 ffff=
881007655fd8
[  922.817717]  ffff881007655fd8 ffff881007655fd8 ffff880409c994a0 ffff=
880fc6d6f4e0
[  922.817720]  0000000000000000 ffff880fc6d6f4e0 ffff881007655a30 0000=
000000000082
[  922.817720] Call Trace:
[  922.817728]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817730]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.817737]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.817740]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.817746]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.817754]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817756]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.817758]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.817765]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817771]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817778]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.817786]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.817792]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.817799]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.817802]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.817804]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.817811]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.817816]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.817821]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.817826]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.817828]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.817831]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.817832]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.817834]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.817836]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.817838]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.817841]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.817842]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.817845]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.817847]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.817849]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.817851]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.817853]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.817856] fuser           D ffff88080fc53b40     0  8579      1 0x=
00000000
[  922.817858]  ffff880407303988 0000000000000086 ffff8804068c9b80 ffff=
880407303fd8
[  922.817860]  ffff880407303fd8 ffff880407303fd8 ffff880409c6d960 ffff=
8804068c9b80
[  922.817863]  0000000000000000 ffff8804068c9b80 ffff880407303a30 0000=
000000000082
[  922.817863] Call Trace:
[  922.817871]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817873]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.817880]  [<ffffffffa043d044>] rpc_wait_bit_killable+0x34/0x80 [s=
unrpc]
[  922.817882]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.817889]  [<ffffffffa0437fb7>] ? xprt_release_xprt+0x57/0x60 [sun=
rpc]
[  922.817896]  [<ffffffffa043d010>] ? __rpc_wait_for_completion_task+0=
x30/0x30 [sunrpc]
[  922.817899]  [<ffffffff814a4487>] out_of_line_wait_on_bit+0x77/0x90
[  922.817901]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.817907]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817913]  [<ffffffffa04361e0>] ? call_connect+0x40/0x40 [sunrpc]
[  922.817921]  [<ffffffffa043e465>] __rpc_execute+0x105/0x290 [sunrpc]=

[  922.817928]  [<ffffffffa043e8eb>] rpc_execute+0x3b/0x80 [sunrpc]
[  922.817935]  [<ffffffffa0436feb>] rpc_run_task+0x6b/0x90 [sunrpc]
[  922.817941]  [<ffffffffa043710e>] rpc_call_sync+0x3e/0x70 [sunrpc]
[  922.817944]  [<ffffffffa04da460>] nfs3_rpc_wrapper.constprop.8+0x60/=
0xb0 [nfsv3]
[  922.817946]  [<ffffffffa04dae89>] nfs3_proc_getattr+0x39/0x40 [nfsv3=
]
[  922.817952]  [<ffffffffa04f7943>] __nfs_revalidate_inode+0x83/0x120 =
[nfs]
[  922.817958]  [<ffffffffa04f7a4e>] nfs_revalidate_inode+0x6e/0xa0 [nf=
s]
[  922.817963]  [<ffffffffa04f12e8>] nfs_check_verifier+0x58/0x80 [nfs]=

[  922.817968]  [<ffffffffa04f3eab>] nfs_lookup_revalidate+0x2cb/0x370 =
[nfs]
[  922.817970]  [<ffffffff81167ffe>] complete_walk+0xbe/0x100
[  922.817972]  [<ffffffff81166e7d>] ? path_put+0x1d/0x30
[  922.817974]  [<ffffffff81169526>] path_lookupat+0x66/0x740
[  922.817976]  [<ffffffff81169c2c>] do_path_lookup+0x2c/0xc0
[  922.817978]  [<ffffffff811671fe>] ? getname_flags+0x4e/0xf0
[  922.817980]  [<ffffffff8116c818>] user_path_at_empty+0x58/0xa0
[  922.817982]  [<ffffffff814aa62c>] ? do_page_fault+0x1bc/0x4b0
[  922.817984]  [<ffffffff8116c86c>] user_path_at+0xc/0x10
[  922.817986]  [<ffffffff81161670>] vfs_fstatat+0x30/0x70
[  922.817988]  [<ffffffff811616e6>] vfs_stat+0x16/0x20
[  922.817990]  [<ffffffff811618b5>] sys_newstat+0x15/0x30
[  922.817993]  [<ffffffff814a72a5>] ? page_fault+0x25/0x30
[  922.817994]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  922.817997] reboot          D ffff88101fc93b40     0  8711      1 0x=
00000000
[  922.818000]  ffff881007533c98 0000000000000086 ffff880fc6c12260 ffff=
881007533fd8
[  922.818002]  ffff881007533fd8 ffff881007533fd8 ffff880409c98000 ffff=
880fc6c12260
[  922.818004]  ffff881007533c98 ffff880fc6c12260 ffff88101fc943a0 0000=
000000000002
[  922.818004] Call Trace:
[  922.818007]  [<ffffffff810fd790>] ? __lock_page+0x70/0x70
[  922.818008]  [<ffffffff814a6064>] schedule+0x24/0x70
[  922.818010]  [<ffffffff814a613a>] io_schedule+0x8a/0xd0
[  922.818012]  [<ffffffff810fd799>] sleep_on_page+0x9/0x10
[  922.818014]  [<ffffffff814a43d8>] __wait_on_bit+0x58/0x90
[  922.818016]  [<ffffffff810fe1a1>] ? find_get_pages_tag+0xd1/0x180
[  922.818018]  [<ffffffff810fd8b8>] wait_on_page_bit+0x78/0x80
[  922.818021]  [<ffffffff81073130>] ? autoremove_wake_function+0x40/0x=
40
[  922.818023]  [<ffffffff810fddf9>] filemap_fdatawait_range+0xf9/0x190=

[  922.818025]  [<ffffffff814a5eec>] ? wait_for_common+0xdc/0x180
[  922.818027]  [<ffffffff81082cf0>] ? try_to_wake_up+0x270/0x270
[  922.818029]  [<ffffffff810fdeaf>] filemap_fdatawait+0x1f/0x30
[  922.818031]  [<ffffffff81183d7a>] sync_inodes_sb+0x13a/0x1b0
[  922.818034]  [<ffffffff81189840>] ? fdatawrite_one_bdev+0x20/0x20
[  922.818036]  [<ffffffff81189859>] sync_inodes_one_sb+0x19/0x20
[  922.818038]  [<ffffffff81160081>] iterate_supers+0xe1/0xf0
[  922.818040]  [<ffffffff811899f0>] sys_sync+0x30/0x90
[  922.818042]  [<ffffffff814ae979>] system_call_fastpath+0x16/0x1b
[  933.547670] nfs: server dragon not responding, timed out
[  936.558252] kvm: exiting hardware virtualization
[  936.721141] sd 3:0:0:0: [sdd] Synchronizing SCSI cache
[  936.721275] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
[  936.721376] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[  936.721470] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  936.828674] Disabling non-boot CPUs ...
[  951.092224] Broke affinity for irq 22
[  951.115148] nfs: server dragon not responding, timed out
=0DINIT: no more processes left in this runlevel=0D
[  955.957150] nfs: server dragon not responding, timed out
[  960.872572] Broke affinity for irq 16
[  961.619867] Restarting system.
[  961.638138] reboot: machine restart

--nextPart1877929.JKyKaAmsY1--

