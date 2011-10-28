Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1J1OG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 10:06:56 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:39809 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab1J1OGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 10:06:52 -0400
X-Greylist: delayed 1132 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Oct 2011 10:06:51 EDT
Date: Fri, 28 Oct 2011 15:47:43 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Tejun Heo <tj@kernel.org>
Cc: Gaudenz Steinlin <gaudenz@debian.org>, linux-kernel@vger.kernel.org,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines
	(Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20111028134743.GU14392@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	Tejun Heo <tj@kernel.org>, Gaudenz Steinlin <gaudenz@debian.org>,
	linux-kernel@vger.kernel.org,
	Jameson Graef Rollins <jrollins@finestructure.net>,
	Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
	Martin Pitt <martin.pitt@ubuntu.com>
References: <20110406121920.GC4142@mtj.dyndns.org> <20110903221456.GA2877@elie> <20110904024244.GB3083@htj.dyndns.org> <87y5y37o7h.fsf@servo.factory.finestructure.net> <20110906174524.GN18425@mtj.dyndns.org> <20110907085037.GX10237@login.drsnuggles.stderr.nl> <20110911040826.GP29319@htj.dyndns.org> <87r5222l40.fsf@meteor.durcheinandertal.local.i-did-not-set--mail-host-address--so-tickle-me> <20111026182650.GL14392@login.drsnuggles.stderr.nl> <20111026222510.GK24261@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GkyPMzQoklWKZOV/"
Content-Disposition: inline
In-Reply-To: <20111026222510.GK24261@google.com>
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: Message too big, not scanned.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GkyPMzQoklWKZOV/
Content-Type: multipart/mixed; boundary="ZATCr4BkWovzAAkA"
Content-Disposition: inline


--ZATCr4BkWovzAAkA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

> > it seems this same problem also occurs with udisks-daemon, though the
> > behaviour is slightly different (it seems to hang even before
> > undocking, I _think_).
> >=20
> > Anyway, here's the dmesg output when trying to suspend:
>
> Can you please turn on CONFIG_FRAME_POINTER, trigger the problem, wait
> for some minutes and then do sysrq-t and report the dmesg output?
> This could be from DEAD state handling race currently being addressed
> in upstream.

I compiled a clean 3.1.0 kernel with FRAME_POINTER support, but haven't
been able to reproduce the problem with udisks-daemon so far. It
actually seems the problem occurs less often with 3.1.0, I initially
thought the problem was fixed.

I'm not sure if the FRAME_POINTER option actually works, though, since I
couldn't find any obvious differences in the format of the stack traces?

I have managed to trigger the problem again in scsi_id (by undocking)
and then suspending. I've attached the full output of sysrq-t (though I
think it's incomplete, syslogd didn't manage to capture it all?). The
part about scsi_id is copied below.

Here's the dmesg output during the suspend:

Oct 28 15:15:55 grubby kernel: [  168.864019] Freezing of tasks failed afte=
r 20.01 seconds (1 tasks refusing to freeze, wq_busy=3D0):
Oct 28 15:15:55 grubby kernel: [  168.864069] scsi_id         D 00000000000=
00000     0 11343   8992 0x00800004
Oct 28 15:15:55 grubby kernel: [  168.864077]  ffff880225e6f8d8 00000000000=
00082 00ff880200000000 ffff880200000000
Oct 28 15:15:55 grubby kernel: [  168.864085]  ffff88022d7ed610 ffff880225e=
6ffd8 ffff880225e6ffd8 0000000000012f40
Oct 28 15:15:55 grubby kernel: [  168.864095]  ffff88022ed59610 ffff88022d7=
ed610 ffff88020439e440 0000000100000002
Oct 28 15:15:55 grubby kernel: [  168.864098] Call Trace:
Oct 28 15:15:55 grubby kernel: [  168.864107]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:15:55 grubby kernel: [  168.864110]  [<ffffffff8134cc2c>] schedul=
e_timeout+0x2f/0xd9
Oct 28 15:15:55 grubby kernel: [  168.864117]  [<ffffffff8104302a>] ? __con=
d_resched+0x23/0x2f
Oct 28 15:15:55 grubby kernel: [  168.864120]  [<ffffffff8134c832>] wait_fo=
r_common+0x9e/0x115
Oct 28 15:15:55 grubby kernel: [  168.864122]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:15:55 grubby kernel: [  168.864125]  [<ffffffff8134c93f>] wait_fo=
r_completion+0x18/0x1a
Oct 28 15:15:55 grubby kernel: [  168.864130]  [<ffffffff8105d659>] flush_w=
ork+0x29/0x2f
Oct 28 15:15:55 grubby kernel: [  168.864133]  [<ffffffff8105c8ff>] ? do_wo=
rk_for_cpu+0x24/0x24
Oct 28 15:15:55 grubby kernel: [  168.864136]  [<ffffffff8105d9e5>] flush_d=
elayed_work+0x3a/0x3e
Oct 28 15:15:55 grubby kernel: [  168.864142]  [<ffffffff811a0156>] disk_cl=
ear_events+0x8f/0xf5
Oct 28 15:15:55 grubby kernel: [  168.864169]  [<ffffffff81125280>] check_d=
isk_change+0x29/0x5c
Oct 28 15:15:55 grubby kernel: [  168.864176]  [<ffffffffa009feb1>] cdrom_o=
pen+0x44/0x4b2 [cdrom]
Oct 28 15:15:55 grubby kernel: [  168.864181]  [<ffffffff811aba78>] ? kobje=
ct_get+0x18/0x20
Oct 28 15:15:55 grubby kernel: [  168.864186]  [<ffffffff8124a895>] ? get_d=
evice+0x14/0x1a
Oct 28 15:15:55 grubby kernel: [  168.864191]  [<ffffffffa00bb86b>] sr_bloc=
k_open+0x90/0xb7 [sr_mod]
Oct 28 15:15:55 grubby kernel: [  168.864194]  [<ffffffff8112610b>] __blkde=
v_get+0xe2/0x398
Oct 28 15:15:55 grubby kernel: [  168.864197]  [<ffffffff8112667c>] ? blkde=
v_get+0x2bb/0x2bb
Oct 28 15:15:55 grubby kernel: [  168.864199]  [<ffffffff8112658d>] blkdev_=
get+0x1cc/0x2bb
Oct 28 15:15:55 grubby kernel: [  168.864201]  [<ffffffff8112667c>] ? blkde=
v_get+0x2bb/0x2bb
Oct 28 15:15:55 grubby kernel: [  168.864203]  [<ffffffff811266de>] blkdev_=
open+0x62/0x66
Oct 28 15:15:55 grubby kernel: [  168.864209]  [<ffffffff810fbf12>] __dentr=
y_open+0x182/0x299
Oct 28 15:15:55 grubby kernel: [  168.864212]  [<ffffffff8134db64>] ? _raw_=
spin_lock+0x9/0xb
Oct 28 15:15:55 grubby kernel: [  168.864215]  [<ffffffff810fcde9>] nameida=
ta_to_filp+0x5b/0x62
Oct 28 15:15:55 grubby kernel: [  168.864219]  [<ffffffff81108e4a>] do_last=
+0x454/0x56c
Oct 28 15:15:55 grubby kernel: [  168.864221]  [<ffffffff8110905a>] path_op=
enat+0xca/0x30b
Oct 28 15:15:55 grubby kernel: [  168.864226]  [<ffffffff810d4744>] ? handl=
e_mm_fault+0x1c3/0x1d6
Oct 28 15:15:55 grubby kernel: [  168.864228]  [<ffffffff811092e9>] do_filp=
_open+0x33/0x81
Oct 28 15:15:55 grubby kernel: [  168.864233]  [<ffffffff81112584>] ? alloc=
_fd+0x6d/0x118
Oct 28 15:15:55 grubby kernel: [  168.864235]  [<ffffffff810fce59>] do_sys_=
open+0x69/0xfb
Oct 28 15:15:55 grubby kernel: [  168.864238]  [<ffffffff810fcf06>] sys_ope=
n+0x1b/0x1d
Oct 28 15:15:55 grubby kernel: [  168.864241]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:15:55 grubby kernel: [  168.864244]=20

Here's the sysrq-t output about scsi_id from a few minutes after the
suspend:
Oct 28 15:29:00 grubby kernel: [  951.018877] scsi_id         D 00000000000=
00000     0 11343   8992 0x00000004
Oct 28 15:29:00 grubby kernel: [  951.018882]  ffff880225e6f8d8 00000000000=
00082 00ff880200000000 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.018889]  ffff88022d7ed610 ffff880225e=
6ffd8 ffff880225e6ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018896]  ffff88022ed59610 ffff88022d7=
ed610 ffff88020439e440 0000000100000002
Oct 28 15:29:00 grubby kernel: [  951.018903] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018908]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018913]  [<ffffffff8134cc2c>] schedul=
e_timeout+0x2f/0xd9
Oct 28 15:29:00 grubby kernel: [  951.018919]  [<ffffffff8104302a>] ? __con=
d_resched+0x23/0x2f
Oct 28 15:29:00 grubby kernel: [  951.018925]  [<ffffffff8134c832>] wait_fo=
r_common+0x9e/0x115
Oct 28 15:29:00 grubby kernel: [  951.018930]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018936]  [<ffffffff8134c93f>] wait_fo=
r_completion+0x18/0x1a
Oct 28 15:29:00 grubby kernel: [  951.018942]  [<ffffffff8105d659>] flush_w=
ork+0x29/0x2f
Oct 28 15:29:00 grubby kernel: [  951.018947]  [<ffffffff8105c8ff>] ? do_wo=
rk_for_cpu+0x24/0x24
Oct 28 15:29:00 grubby kernel: [  951.018953]  [<ffffffff8105d9e5>] flush_d=
elayed_work+0x3a/0x3e
Oct 28 15:29:00 grubby kernel: [  951.018959]  [<ffffffff811a0156>] disk_cl=
ear_events+0x8f/0xf5
Oct 28 15:29:00 grubby kernel: [  951.018970]  [<ffffffff81125280>] check_d=
isk_change+0x29/0x5c
Oct 28 15:29:00 grubby kernel: [  951.018982]  [<ffffffffa009feb1>] cdrom_o=
pen+0x44/0x4b2 [cdrom]
Oct 28 15:29:00 grubby kernel: [  951.018988]  [<ffffffff811aba78>] ? kobje=
ct_get+0x18/0x20
Oct 28 15:29:00 grubby kernel: [  951.018994]  [<ffffffff8124a895>] ? get_d=
evice+0x14/0x1a
Oct 28 15:29:00 grubby kernel: [  951.019005]  [<ffffffffa00bb86b>] sr_bloc=
k_open+0x90/0xb7 [sr_mod]
Oct 28 15:29:00 grubby kernel: [  951.019011]  [<ffffffff8112610b>] __blkde=
v_get+0xe2/0x398
Oct 28 15:29:00 grubby kernel: [  951.019016]  [<ffffffff8112667c>] ? blkde=
v_get+0x2bb/0x2bb
Oct 28 15:29:00 grubby kernel: [  951.019021]  [<ffffffff8112658d>] blkdev_=
get+0x1cc/0x2bb
Oct 28 15:29:00 grubby kernel: [  951.019026]  [<ffffffff8112667c>] ? blkde=
v_get+0x2bb/0x2bb
Oct 28 15:29:00 grubby kernel: [  951.019031]  [<ffffffff811266de>] blkdev_=
open+0x62/0x66
Oct 28 15:29:00 grubby kernel: [  951.019036]  [<ffffffff810fbf12>] __dentr=
y_open+0x182/0x299
Oct 28 15:29:00 grubby kernel: [  951.019042]  [<ffffffff8134db64>] ? _raw_=
spin_lock+0x9/0xb
Oct 28 15:29:00 grubby kernel: [  951.019048]  [<ffffffff810fcde9>] nameida=
ta_to_filp+0x5b/0x62
Oct 28 15:29:00 grubby kernel: [  951.019054]  [<ffffffff81108e4a>] do_last=
+0x454/0x56c
Oct 28 15:29:00 grubby kernel: [  951.019060]  [<ffffffff8110905a>] path_op=
enat+0xca/0x30b
Oct 28 15:29:00 grubby kernel: [  951.019066]  [<ffffffff810d4744>] ? handl=
e_mm_fault+0x1c3/0x1d6
Oct 28 15:29:00 grubby kernel: [  951.019072]  [<ffffffff811092e9>] do_filp=
_open+0x33/0x81
Oct 28 15:29:00 grubby kernel: [  951.019078]  [<ffffffff81112584>] ? alloc=
_fd+0x6d/0x118
Oct 28 15:29:00 grubby kernel: [  951.019084]  [<ffffffff810fce59>] do_sys_=
open+0x69/0xfb
Oct 28 15:29:00 grubby kernel: [  951.019089]  [<ffffffff810fcf06>] sys_ope=
n+0x1b/0x1d
Oct 28 15:29:00 grubby kernel: [  951.019095]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b

It seems these two traces are identical. There are a number of "INFO:
task scsi_id:11343 blocked for more than 120 seconds" traces in the log
as well, which also look identical.

I hope this helps... If you need anything more, just ask.

Gr.

Matthijs

--ZATCr4BkWovzAAkA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sysreq-t.txt"
Content-Transfer-Encoding: quoted-printable

Oct 28 15:29:00 grubby kernel: >] ? __pollwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013471]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013476]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013480]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013485]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013490]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013495]  [<ffffffff81040749>] ? try_t=
o_wake_up+0x195/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.013501]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.013507]  [<ffffffff8134db64>] ? _raw_=
spin_lock+0x9/0xb
Oct 28 15:29:00 grubby kernel: [  951.013512]  [<ffffffff81038c7a>] ? task_=
rq_lock+0x49/0x82
Oct 28 15:29:00 grubby kernel: [  951.013518]  [<ffffffff8106399f>] ? threa=
d_group_cputime+0x6d/0x9d
Oct 28 15:29:00 grubby kernel: [  951.013524]  [<ffffffff8104ca29>] ? times=
pec_add_safe+0x32/0x61
Oct 28 15:29:00 grubby kernel: [  951.013529]  [<ffffffff810136d7>] ? read_=
tsc+0x9/0x19
Oct 28 15:29:00 grubby kernel: [  951.013534]  [<ffffffff8110bc92>] ? poll_=
select_set_timeout+0x61/0x75
Oct 28 15:29:00 grubby kernel: [  951.013539]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.013544]  [<ffffffff81355370>] sysente=
r_dispatch+0x7/0x2e
Oct 28 15:29:00 grubby kernel: [  951.013548] skype           S ffff88022ba=
3e480     0  5021   4054 0x00020000
Oct 28 15:29:00 grubby kernel: [  951.013554]  ffff880215697c58 00000000000=
00082 ffff880215697c08 ffffffff81038202
Oct 28 15:29:00 grubby kernel: [  951.013561]  ffff88022df40fe0 ffff8802156=
97fd8 ffff880215697fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.013567]  ffff88022df416d0 ffff88022df=
40fe0 ffff880215697c28 ffff880215697c48
Oct 28 15:29:00 grubby kernel: [  951.013574] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.013579]  [<ffffffff81038202>] ? updat=
e_cfs_shares+0xa5/0xae
Oct 28 15:29:00 grubby kernel: [  951.013585]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.013591]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.013596]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.013602]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.013608]  [<ffffffff81058609>] ? get_s=
ignal_to_deliver+0x487/0x498
Oct 28 15:29:00 grubby kernel: [  951.013614]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.013619]  [<ffffffff8100de56>] ? do_si=
gnal+0x39/0x5ed
Oct 28 15:29:00 grubby kernel: [  951.013625]  [<ffffffff81113fbd>] ? mntpu=
t_no_expire+0x27/0xd0
Oct 28 15:29:00 grubby kernel: [  951.013631]  [<ffffffff810736cd>] compat_=
sys_futex+0x126/0x135
Oct 28 15:29:00 grubby kernel: [  951.013636]  [<ffffffff813557d3>] ia32_do=
_call+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.013640] skype           S ffff88022ba=
3e480     0  5023   4054 0x00020000
Oct 28 15:29:00 grubby kernel: [  951.013646]  ffff880215585c58 00000000000=
00082 ffff880215585c08 ffffffff81038202
Oct 28 15:29:00 grubby kernel: [  951.013652]  ffff88022ca817d0 ffff8802155=
85fd8 ffff880215585fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.013659]  ffff88022df40fe0 ffff88022ca=
817d0 ffff880215585c28 ffff880215585c48
Oct 28 15:29:00 grubby kernel: [  951.013666] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.013671]  [<ffffffff81038202>] ? updat=
e_cfs_shares+0xa5/0xae
Oct 28 15:29:00 grubby kernel: [  951.013677]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.013683]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.013688]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.013694]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.013700]  [<ffffffff81058609>] ? get_s=
ignal_to_deliver+0x487/0x498
Oct 28 15:29:00 grubby kernel: [  951.013706]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.013712]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.013717]  [<ffffffff8100de56>] ? do_si=
gnal+0x39/0x5ed
Oct 28 15:29:00 grubby kernel: [  951.013723]  [<ffffffff8134c996>] ? sched=
ule+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.013728]  [<ffffffff810736cd>] compat_=
sys_futex+0x126/0x135
Oct 28 15:29:00 grubby kernel: [  951.013735]  [<ffffffff81043229>] ? sched=
ule_tail+0x22/0x67
Oct 28 15:29:00 grubby kernel: [  951.013740]  [<ffffffff813557d3>] ia32_do=
_call+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.013743] skype           S ffff88022d4=
b40c0     0  5028   4054 0x00020000
Oct 28 15:29:00 grubby kernel: [  951.013749]  ffff880213369c58 00000000000=
00082 ffff880213369c08 ffffffff81038202
Oct 28 15:29:00 grubby kernel: [  951.013756]  ffff88022df416d0 ffff8802133=
69fd8 ffff880213369fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.013763]  ffff88022d8951e0 ffff88022df=
416d0 ffff880213369c28 ffff880213369c48
Oct 28 15:29:00 grubby kernel: [  951.013769] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.013775]  [<ffffffff81038202>] ? updat=
e_cfs_shares+0xa5/0xae
Oct 28 15:29:00 grubby kernel: [  951.013781]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.013787]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.013792]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.013797]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.013803]  [<ffffffff81058609>] ? get_s=
ignal_to_deliver+0x487/0x498
Oct 28 15:29:00 grubby kernel: [  951.013809]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.013815]  [<ffffffff8100de56>] ? do_si=
gnal+0x39/0x5ed
Oct 28 15:29:00 grubby kernel: [  951.013821]  [<ffffffff810413d5>] ? threa=
d_group_times+0x36/0x94
Oct 28 15:29:00 grubby kernel: [  951.013826]  [<ffffffff8103a87e>] ? finis=
h_task_switch+0x8b/0xb6
Oct 28 15:29:00 grubby kernel: [  951.013832]  [<ffffffff810736cd>] compat_=
sys_futex+0x126/0x135
Oct 28 15:29:00 grubby kernel: [  951.013837]  [<ffffffff81081b65>] ? compa=
t_sys_times+0x90/0xbc
Oct 28 15:29:00 grubby kernel: [  951.013842]  [<ffffffff813557d3>] ia32_do=
_call+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.013845] gnome-volume-co S ffff88022cc=
56400     0  4956   4054 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.013852]  ffff880215731a48 00000000000=
00082 0000000000000400 00ffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.013859]  ffff88022c80aa30 ffff8802157=
31fd8 ffff880215731fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.013865]  ffff88022dc21890 ffff88022c8=
0aa30 0000000000000000 0000000100000001
Oct 28 15:29:00 grubby kernel: [  951.013872] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.013877]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.013883]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.013889]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.013896]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.013901]  [<ffffffff8106262d>] ? add_w=
ait_queue+0x3f/0x44
Oct 28 15:29:00 grubby kernel: [  951.013907]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.013912]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.013917]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.013922]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.013927]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013932]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013936]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013941]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013945]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013950]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013955]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013959]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013964]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.013970]  [<ffffffff811695fe>] ? secur=
ity_file_permission+0x29/0x2e
Oct 28 15:29:00 grubby kernel: [  951.013976]  [<ffffffff810fd633>] ? rw_ve=
rify_area+0xab/0xc8
Oct 28 15:29:00 grubby kernel: [  951.013981]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.013986]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.013990] bluetooth-apple S ffff88022c4=
40b80     0  4961   4054 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.013996]  ffff880213061a48 00000000000=
00086 ffff8802130619f8 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.014003]  ffff88022cae8300 ffff8802130=
61fd8 ffff880213061fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.014010]  ffff88022d76eea0 ffff88022ca=
e8300 0000000000000000 0000000000000286
Oct 28 15:29:00 grubby kernel: [  951.014016] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.014022]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.014028]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.014034]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.014040]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.014045]  [<ffffffff8106262d>] ? add_w=
ait_queue+0x3f/0x44
Oct 28 15:29:00 grubby kernel: [  951.014051]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.014056]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.014062]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.014066]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.014071]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014076]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014081]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014085]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014090]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014094]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014099]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014104]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014108]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014114]  [<ffffffff811695fe>] ? secur=
ity_file_permission+0x29/0x2e
Oct 28 15:29:00 grubby kernel: [  951.014120]  [<ffffffff810fd633>] ? rw_ve=
rify_area+0xab/0xc8
Oct 28 15:29:00 grubby kernel: [  951.014125]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.014131]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.014135] bluetooth-apple S ffff88022c7=
190c0     0  4982   4054 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.014141]  ffff880213257a48 00000000000=
00086 ffff880213257a08 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.014148]  ffff88022d8951e0 ffff8802132=
57fd8 ffff880213257fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.014155]  ffff88022ca8a3c0 ffff88022d8=
951e0 ffff880213257a28 000000018110d563
Oct 28 15:29:00 grubby kernel: [  951.014161] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.014167]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.014172]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.014178]  [<ffffffff81113fbd>] ? mntpu=
t_no_expire+0x27/0xd0
Oct 28 15:29:00 grubby kernel: [  951.014183]  [<ffffffff81114087>] ? mntpu=
t+0x21/0x23
Oct 28 15:29:00 grubby kernel: [  951.014188]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.014194]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.014200]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.014205]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.014210]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.014215]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.014220]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014225]  [<ffffffff81038d90>] ? set_n=
ext_entity+0x3a/0x5f
Oct 28 15:29:00 grubby kernel: [  951.014230]  [<ffffffff8100d009>] ? read_=
cr0+0x9/0xd
Oct 28 15:29:00 grubby kernel: [  951.014236]  [<ffffffff8100d7c9>] ? __swi=
tch_to+0x20e/0x220
Oct 28 15:29:00 grubby kernel: [  951.014241]  [<ffffffff8103a844>] ? finis=
h_task_switch+0x51/0xb6
Oct 28 15:29:00 grubby kernel: [  951.014247]  [<ffffffff8134c722>] ? __sch=
edule+0x5c5/0x5dc
Oct 28 15:29:00 grubby kernel: [  951.014252]  [<ffffffff810d1b91>] ? __do_=
fault+0x356/0x390
Oct 28 15:29:00 grubby kernel: [  951.014257]  [<ffffffff81056500>] ? __deq=
ueue_signal+0x16/0x105
Oct 28 15:29:00 grubby kernel: [  951.014262]  [<ffffffff81056457>] ? recal=
c_sigpending+0x40/0x43
Oct 28 15:29:00 grubby kernel: [  951.014267]  [<ffffffff81056693>] ? deque=
ue_signal+0xa4/0x11d
Oct 28 15:29:00 grubby kernel: [  951.014272]  [<ffffffff81058609>] ? get_s=
ignal_to_deliver+0x487/0x498
Oct 28 15:29:00 grubby kernel: [  951.014278]  [<ffffffff8100de56>] ? do_si=
gnal+0x39/0x5ed
Oct 28 15:29:00 grubby kernel: [  951.014283]  [<ffffffff8110d563>] ? __d_f=
ree+0x4e/0x53
Oct 28 15:29:00 grubby kernel: [  951.014288]  [<ffffffff8110db15>] ? d_fre=
e+0x3e/0x50
Oct 28 15:29:00 grubby kernel: [  951.014293]  [<ffffffff8110dc4a>] ? dentr=
y_kill+0x123/0x12f
Oct 28 15:29:00 grubby kernel: [  951.014298]  [<ffffffff81113fbd>] ? mntpu=
t_no_expire+0x27/0xd0
Oct 28 15:29:00 grubby kernel: [  951.014303]  [<ffffffff81114087>] ? mntpu=
t+0x21/0x23
Oct 28 15:29:00 grubby kernel: [  951.014308]  [<ffffffff810febf1>] ? fput+=
0x192/0x1a1
Oct 28 15:29:00 grubby kernel: [  951.014313]  [<ffffffff8110c97f>] do_rest=
art_poll+0x34/0x4d
Oct 28 15:29:00 grubby kernel: [  951.014318]  [<ffffffff813531a0>] ? int_s=
ignal+0x12/0x17
Oct 28 15:29:00 grubby kernel: [  951.014323]  [<ffffffff81058715>] sys_res=
tart_syscall+0x1a/0x1c
Oct 28 15:29:00 grubby kernel: [  951.014329]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.014333] gconf-helper    S ffff88022c0=
46b80     0  4966   4947 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.014339]  ffff8802130dba48 00000000000=
00082 ffff88022b9b5650 00ffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.014346]  ffff88022c5ee240 ffff8802130=
dbfd8 ffff8802130dbfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.014353]  ffff88022c4b35d0 ffff88022c5=
ee240 ffff8802130dbba8 ffffffff81042226
Oct 28 15:29:00 grubby kernel: [  951.014360] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.014365]  [<ffffffff81042226>] ? find_=
busiest_group+0x24c/0x7c9
Oct 28 15:29:00 grubby kernel: [  951.014371]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.014377]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.014383]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.014389]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.014394]  [<ffffffff8106262d>] ? add_w=
ait_queue+0x3f/0x44
Oct 28 15:29:00 grubby kernel: [  951.014400]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.014405]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.014410]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.014415]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.014420]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014425]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014429]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014434]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014439]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014444]  [<ffffffff81056500>] ? __deq=
ueue_signal+0x16/0x105
Oct 28 15:29:00 grubby kernel: [  951.014448]  [<ffffffff81056457>] ? recal=
c_sigpending+0x40/0x43
Oct 28 15:29:00 grubby kernel: [  951.014453]  [<ffffffff81056693>] ? deque=
ue_signal+0xa4/0x11d
Oct 28 15:29:00 grubby kernel: [  951.014459]  [<ffffffff81058609>] ? get_s=
ignal_to_deliver+0x487/0x498
Oct 28 15:29:00 grubby kernel: [  951.014464]  [<ffffffff81038d90>] ? set_n=
ext_entity+0x3a/0x5f
Oct 28 15:29:00 grubby kernel: [  951.014469]  [<ffffffff8100d009>] ? read_=
cr0+0x9/0xd
Oct 28 15:29:00 grubby kernel: [  951.014475]  [<ffffffff8100d7c9>] ? __swi=
tch_to+0x20e/0x220
Oct 28 15:29:00 grubby kernel: [  951.014480]  [<ffffffff8103a844>] ? finis=
h_task_switch+0x51/0xb6
Oct 28 15:29:00 grubby kernel: [  951.014485]  [<ffffffff8134c722>] ? __sch=
edule+0x5c5/0x5dc
Oct 28 15:29:00 grubby kernel: [  951.014491]  [<ffffffff8110c97f>] do_rest=
art_poll+0x34/0x4d
Oct 28 15:29:00 grubby kernel: [  951.014496]  [<ffffffff813531a0>] ? int_s=
ignal+0x12/0x17
Oct 28 15:29:00 grubby kernel: [  951.014501]  [<ffffffff81058715>] sys_res=
tart_syscall+0x1a/0x1c
Oct 28 15:29:00 grubby kernel: [  951.014507]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.014511] gconf-helper    S ffff88022dd=
84c00     0  4967   4947 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.014517]  ffff880213057a48 00000000000=
00082 ffff880213057a08 ffffffff810edfef
Oct 28 15:29:00 grubby kernel: [  951.014524]  ffff88022d894af0 ffff8802130=
57fd8 ffff880213057fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.014530]  ffff88022c5949b0 ffff88022d8=
94af0 ffff880213057a28 ffffffff8110d563
Oct 28 15:29:00 grubby kernel: [  951.014537] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.014542]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.014547]  [<ffffffff8110d563>] ? __d_f=
ree+0x4e/0x53
Oct 28 15:29:00 grubby kernel: [  951.014552]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.014558]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.014563]  [<ffffffff81113fbd>] ? mntpu=
t_no_expire+0x27/0xd0
Oct 28 15:29:00 grubby kernel: [  951.014568]  [<ffffffff81114087>] ? mntpu=
t+0x21/0x23
Oct 28 15:29:00 grubby kernel: [  951.014573]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.014580]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.014586]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.014591]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.014596]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.014601]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.014606]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014610]  [<ffffffff81038d90>] ? set_n=
ext_entity+0x3a/0x5f
Oct 28 15:29:00 grubby kernel: [  951.014616]  [<ffffffff8100d009>] ? read_=
cr0+0x9/0xd
Oct 28 15:29:00 grubby kernel: [  951.014621]  [<ffffffff8100d7c9>] ? __swi=
tch_to+0x20e/0x220
Oct 28 15:29:00 grubby kernel: [  951.014626]  [<ffffffff8103a844>] ? finis=
h_task_switch+0x51/0xb6
Oct 28 15:29:00 grubby kernel: [  951.014632]  [<ffffffff8134c722>] ? __sch=
edule+0x5c5/0x5dc
Oct 28 15:29:00 grubby kernel: [  951.014637]  [<ffffffff810d1b91>] ? __do_=
fault+0x356/0x390
Oct 28 15:29:00 grubby kernel: [  951.014642]  [<ffffffff81056500>] ? __deq=
ueue_signal+0x16/0x105
Oct 28 15:29:00 grubby kernel: [  951.014647]  [<ffffffff81056457>] ? recal=
c_sigpending+0x40/0x43
Oct 28 15:29:00 grubby kernel: [  951.014652]  [<ffffffff81056693>] ? deque=
ue_signal+0xa4/0x11d
Oct 28 15:29:00 grubby kernel: [  951.014657]  [<ffffffff81058609>] ? get_s=
ignal_to_deliver+0x487/0x498
Oct 28 15:29:00 grubby kernel: [  951.014663]  [<ffffffff8100de56>] ? do_si=
gnal+0x39/0x5ed
Oct 28 15:29:00 grubby kernel: [  951.014668]  [<ffffffff8110d563>] ? __d_f=
ree+0x4e/0x53
Oct 28 15:29:00 grubby kernel: [  951.014673]  [<ffffffff8110db15>] ? d_fre=
e+0x3e/0x50
Oct 28 15:29:00 grubby kernel: [  951.014678]  [<ffffffff8110dc4a>] ? dentr=
y_kill+0x123/0x12f
Oct 28 15:29:00 grubby kernel: [  951.014683]  [<ffffffff81113fbd>] ? mntpu=
t_no_expire+0x27/0xd0
Oct 28 15:29:00 grubby kernel: [  951.014688]  [<ffffffff81114087>] ? mntpu=
t+0x21/0x23
Oct 28 15:29:00 grubby kernel: [  951.014693]  [<ffffffff810febf1>] ? fput+=
0x192/0x1a1
Oct 28 15:29:00 grubby kernel: [  951.014698]  [<ffffffff8110c97f>] do_rest=
art_poll+0x34/0x4d
Oct 28 15:29:00 grubby kernel: [  951.014704]  [<ffffffff813531a0>] ? int_s=
ignal+0x12/0x17
Oct 28 15:29:00 grubby kernel: [  951.014709]  [<ffffffff81058715>] sys_res=
tart_syscall+0x1a/0x1c
Oct 28 15:29:00 grubby kernel: [  951.014714]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.014719] gdu-notificatio S ffff88022df=
54040     0  4968   4054 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.014725]  ffff88021312da48 00000000000=
00086 0000000000000400 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.014731]  ffff88022c1975d0 ffff8802131=
2dfd8 ffff88021312dfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.014738]  ffff88022c80aa30 ffff88022c1=
975d0 00000000000003c6 0000000100000003
Oct 28 15:29:00 grubby kernel: [  951.014744] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.014750]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.014756]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.014762]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.014768]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.014774]  [<ffffffff8106262d>] ? add_w=
ait_queue+0x3f/0x44
Oct 28 15:29:00 grubby kernel: [  951.014780]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.014785]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.014790]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.014795]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.014800]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014804]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014809]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014814]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014818]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014823]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014827]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014832]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014837]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014842]  [<ffffffff811695fe>] ? secur=
ity_file_permission+0x29/0x2e
Oct 28 15:29:00 grubby kernel: [  951.014848]  [<ffffffff810fd633>] ? rw_ve=
rify_area+0xab/0xc8
Oct 28 15:29:00 grubby kernel: [  951.014853]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.014859]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.014863] update-notifier S 00000000000=
00000     0  4970   4054 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.014869]  ffff880213087a48 00000000000=
00086 0000000000000400 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.014876]  ffff88022dc21890 ffff8802130=
87fd8 ffff880213087fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.014882]  ffff88022ed59610 ffff88022dc=
21890 0000000000000000 0000000100000000
Oct 28 15:29:00 grubby kernel: [  951.014889] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.014895]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.014900]  [<ffffffff8134d3b3>] schedul=
e_hrtimeout_range_clock+0xc5/0x10c
Oct 28 15:29:00 grubby kernel: [  951.014906]  [<ffffffff81064e7d>] ? updat=
e_rmtp+0x65/0x65
Oct 28 15:29:00 grubby kernel: [  951.014912]  [<ffffffff81065703>] ? hrtim=
er_start_range_ns+0xf/0x11
Oct 28 15:29:00 grubby kernel: [  951.014919]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.014924]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.014929]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.014934]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.014938]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014943]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014948]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014952]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014957]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014962]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014966]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014971]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014975]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.014982]  [<ffffffff8104ca29>] ? times=
pec_add_safe+0x32/0x61
Oct 28 15:29:00 grubby kernel: [  951.014987]  [<ffffffff810136d7>] ? read_=
tsc+0x9/0x19
Oct 28 15:29:00 grubby kernel: [  951.014992]  [<ffffffff8110bc92>] ? poll_=
select_set_timeout+0x61/0x75
Oct 28 15:29:00 grubby kernel: [  951.014997]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.015003]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015007] update-notifier S ffff88022d1=
ff080     0  4981   4054 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.015013]  ffff8802130bba48 00000000000=
00086 ffff8802130bb9d8 ffffffff8134dbbb
Oct 28 15:29:00 grubby kernel: [  951.015020]  ffff88022d76e0c0 ffff8802130=
bbfd8 ffff8802130bbfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.015026]  ffff88022bacc380 ffff88022d7=
6e0c0 ffff8802132da280 0000000000000001
Oct 28 15:29:00 grubby kernel: [  951.015033] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.015038]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.015044]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.015050]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.015056]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015062]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015068]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.015074]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.015079]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.015084]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.015089]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.015094]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015098]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015103]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015108]  [<ffffffff8103a844>] ? finis=
h_task_switch+0x51/0xb6
Oct 28 15:29:00 grubby kernel: [  951.015114]  [<ffffffff8134c722>] ? __sch=
edule+0x5c5/0x5dc
Oct 28 15:29:00 grubby kernel: [  951.015119]  [<ffffffff81056500>] ? __deq=
ueue_signal+0x16/0x105
Oct 28 15:29:00 grubby kernel: [  951.015124]  [<ffffffff81056457>] ? recal=
c_sigpending+0x40/0x43
Oct 28 15:29:00 grubby kernel: [  951.015128]  [<ffffffff81056693>] ? deque=
ue_signal+0xa4/0x11d
Oct 28 15:29:00 grubby kernel: [  951.015134]  [<ffffffff81058609>] ? get_s=
ignal_to_deliver+0x487/0x498
Oct 28 15:29:00 grubby kernel: [  951.015140]  [<ffffffff8100de56>] ? do_si=
gnal+0x39/0x5ed
Oct 28 15:29:00 grubby kernel: [  951.015145]  [<ffffffff81169614>] ? secur=
ity_file_alloc+0x11/0x13
Oct 28 15:29:00 grubby kernel: [  951.015151]  [<ffffffff8134db64>] ? _raw_=
spin_lock+0x9/0xb
Oct 28 15:29:00 grubby kernel: [  951.015157]  [<ffffffff81112584>] ? alloc=
_fd+0x6d/0x118
Oct 28 15:29:00 grubby kernel: [  951.015162]  [<ffffffff8110c97f>] do_rest=
art_poll+0x34/0x4d
Oct 28 15:29:00 grubby kernel: [  951.015167]  [<ffffffff813531a0>] ? int_s=
ignal+0x12/0x17
Oct 28 15:29:00 grubby kernel: [  951.015172]  [<ffffffff81058715>] sys_res=
tart_syscall+0x1a/0x1c
Oct 28 15:29:00 grubby kernel: [  951.015178]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015182] gnome-screensav S 00000000000=
00000     0  4983      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.015188]  ffff880215611a48 00000000000=
00082 0000000000000400 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.015195]  ffff88022cbf7510 ffff8802156=
11fd8 ffff880215611fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.015202]  ffff88022ed88f60 ffff88022cb=
f7510 0000000000000000 0000000100000000
Oct 28 15:29:00 grubby kernel: [  951.015208] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.015214]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.015219]  [<ffffffff8134d3b3>] schedul=
e_hrtimeout_range_clock+0xc5/0x10c
Oct 28 15:29:00 grubby kernel: [  951.015226]  [<ffffffff81064e7d>] ? updat=
e_rmtp+0x65/0x65
Oct 28 15:29:00 grubby kernel: [  951.015232]  [<ffffffff81065703>] ? hrtim=
er_start_range_ns+0xf/0x11
Oct 28 15:29:00 grubby kernel: [  951.015238]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.015243]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.015248]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.015253]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.015258]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015262]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015267]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015272]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015276]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015281]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015285]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015290]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015295]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015301]  [<ffffffff8104ca29>] ? times=
pec_add_safe+0x32/0x61
Oct 28 15:29:00 grubby kernel: [  951.015306]  [<ffffffff810136d7>] ? read_=
tsc+0x9/0x19
Oct 28 15:29:00 grubby kernel: [  951.015311]  [<ffffffff8110bc92>] ? poll_=
select_set_timeout+0x61/0x75
Oct 28 15:29:00 grubby kernel: [  951.015316]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.015322]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015326] gvfsd-trash     S ffff88022c7=
190c0     0  5000      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.015332]  ffff8802156aba48 00000000000=
00086 ffff8802156ab9f8 ffffffff00000001
Oct 28 15:29:00 grubby kernel: [  951.015339]  ffff88022d1ceea0 ffff8802156=
abfd8 ffff8802156abfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.015345]  ffff88022d8958d0 ffff88022d1=
ceea0 0000000000000000 0000000100000286
Oct 28 15:29:00 grubby kernel: [  951.015352] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.015357]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.015363]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.015369]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015375]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015381]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.015387]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.015392]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.015397]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.015402]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.015407]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015412]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015416]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015421]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015425]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015430]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015435]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.015441]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015447]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015453]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.015459]  [<ffffffff8104ca29>] ? times=
pec_add_safe+0x32/0x61
Oct 28 15:29:00 grubby kernel: [  951.015464]  [<ffffffff810136d7>] ? read_=
tsc+0x9/0x19
Oct 28 15:29:00 grubby kernel: [  951.015469]  [<ffffffff8110bc92>] ? poll_=
select_set_timeout+0x61/0x75
Oct 28 15:29:00 grubby kernel: [  951.015475]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.015480]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015484] gvfsd-burn      S ffff88022d5=
ab0c0     0  5006      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.015490]  ffff880213363a48 00000000000=
00082 ffff88022d8958d0 ffff88022d895de0
Oct 28 15:29:00 grubby kernel: [  951.015497]  ffff88022c4b35d0 ffff8802133=
63fd8 ffff880213363fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.015504]  ffff8802038a4870 ffff88022c4=
b35d0 ffff880213363a58 ffffffff81040749
Oct 28 15:29:00 grubby kernel: [  951.015511] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.015516]  [<ffffffff81040749>] ? try_t=
o_wake_up+0x195/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.015522]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.015527]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.015532]  [<ffffffff8110bb3f>] ? pollw=
ake+0x4d/0x4f
Oct 28 15:29:00 grubby kernel: [  951.015538]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015544]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.015549]  [<ffffffff8106262d>] ? add_w=
ait_queue+0x3f/0x44
Oct 28 15:29:00 grubby kernel: [  951.015555]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.015560]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.015565]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.015570]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.015575]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015580]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015585]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015589]  [<ffffffff8103a844>] ? finis=
h_task_switch+0x51/0xb6
Oct 28 15:29:00 grubby kernel: [  951.015595]  [<ffffffff8134c722>] ? __sch=
edule+0x5c5/0x5dc
Oct 28 15:29:00 grubby kernel: [  951.015600]  [<ffffffff810d1b91>] ? __do_=
fault+0x356/0x390
Oct 28 15:29:00 grubby kernel: [  951.015606]  [<ffffffff810370ea>] ? shoul=
d_resched+0x9/0x28
Oct 28 15:29:00 grubby kernel: [  951.015611]  [<ffffffff81056500>] ? __deq=
ueue_signal+0x16/0x105
Oct 28 15:29:00 grubby kernel: [  951.015616]  [<ffffffff81056457>] ? recal=
c_sigpending+0x40/0x43
Oct 28 15:29:00 grubby kernel: [  951.015620]  [<ffffffff81056693>] ? deque=
ue_signal+0xa4/0x11d
Oct 28 15:29:00 grubby kernel: [  951.015626]  [<ffffffff81058609>] ? get_s=
ignal_to_deliver+0x487/0x498
Oct 28 15:29:00 grubby kernel: [  951.015632]  [<ffffffff8100de56>] ? do_si=
gnal+0x39/0x5ed
Oct 28 15:29:00 grubby kernel: [  951.015637]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.015643]  [<ffffffff8110c97f>] do_rest=
art_poll+0x34/0x4d
Oct 28 15:29:00 grubby kernel: [  951.015648]  [<ffffffff813531a0>] ? int_s=
ignal+0x12/0x17
Oct 28 15:29:00 grubby kernel: [  951.015653]  [<ffffffff81058715>] sys_res=
tart_syscall+0x1a/0x1c
Oct 28 15:29:00 grubby kernel: [  951.015659]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.015663] kworker/u:12    S ffff88022c2=
aa9c0     0  6095      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.015669]  ffff880225eb3e90 00000000000=
00046 ffff88022d95f000 ffff880200000001
Oct 28 15:29:00 grubby kernel: [  951.015676]  ffff880206055610 ffff880225e=
b3fd8 ffff880225eb3fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.015683]  ffff8802061e07b0 ffff8802060=
55610 ffffffff8105c45d 0000000100000000
Oct 28 15:29:00 grubby kernel: [  951.015689] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.015695]  [<ffffffff8105c45d>] ? need_=
to_create_worker+0xd/0x21
Oct 28 15:29:00 grubby kernel: [  951.015701]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.015706]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.015712]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.015718]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.015724]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.015730]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.015735]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.015739] kworker/u:22    S ffff88022d1=
ffbc0     0  6105      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.015745]  ffff88022d60fe90 00000000000=
00046 ffff88022d60fe20 ffff88022edc87c0
Oct 28 15:29:00 grubby kernel: [  951.015752]  ffff8802061e07b0 ffff88022d6=
0ffd8 ffff88022d60ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.015759]  ffff88022d80b890 ffff8802061=
e07b0 ffff88022d60fe80 0000000181054b5b
Oct 28 15:29:00 grubby kernel: [  951.015765] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.015771]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.015777]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.015783]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.015788]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.015794]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.015800]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.015805]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.015809] kworker/0:4     S 00000000000=
00000     0  7957      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.015815]  ffff88022d365e90 00000000000=
00046 ffff88023bc0de40 ffff88022edc8640
Oct 28 15:29:00 grubby kernel: [  951.015822]  ffff88022ecc6770 ffff88022d3=
65fd8 ffff88022d365fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.015828]  ffff88022daac100 ffff88022ec=
c6770 ffffffff8105c45d 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.015835] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.015840]  [<ffffffff8105c45d>] ? need_=
to_create_worker+0xd/0x21
Oct 28 15:29:00 grubby kernel: [  951.015846]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.015852]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.015858]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.015863]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.015869]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.015875]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.015880]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.015884] udevd           S 00000000000=
00000     0  8992    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.015890]  ffff88022da73a48 00000000000=
00082 ffff88022da739f8 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.015897]  ffff88022c196100 ffff88022da=
73fd8 ffff88022da73fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.015903]  ffff88022ed88f60 ffff88022c1=
96100 ffff88022da73ac8 0000000100000000
Oct 28 15:29:00 grubby kernel: [  951.015910] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.015916]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.015921]  [<ffffffff8134d3b3>] schedul=
e_hrtimeout_range_clock+0xc5/0x10c
Oct 28 15:29:00 grubby kernel: [  951.015928]  [<ffffffff81064e7d>] ? updat=
e_rmtp+0x65/0x65
Oct 28 15:29:00 grubby kernel: [  951.015933]  [<ffffffff81065703>] ? hrtim=
er_start_range_ns+0xf/0x11
Oct 28 15:29:00 grubby kernel: [  951.015940]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.015945]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.015950]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.015955]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.015959]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.015964]  [<ffffffff812f5646>] ? put_c=
red+0xf/0x20
Oct 28 15:29:00 grubby kernel: [  951.015969]  [<ffffffff812f567d>] ? scm_d=
estroy+0x26/0x47
Oct 28 15:29:00 grubby kernel: [  951.015974]  [<ffffffff812f7ae5>] ? unix_=
dgram_sendmsg+0x3eb/0x42c
Oct 28 15:29:00 grubby kernel: [  951.015980]  [<ffffffff812793cb>] ? sock_=
sendmsg+0xe1/0x104
Oct 28 15:29:00 grubby kernel: [  951.015984]  [<ffffffff81056a6c>] ? signa=
l_wake_up+0x35/0x3a
Oct 28 15:29:00 grubby kernel: [  951.015990]  [<ffffffff81056eea>] ? __sen=
d_signal+0x7b/0x2b2
Oct 28 15:29:00 grubby kernel: [  951.015995]  [<ffffffff81057191>] ? send_=
signal+0x70/0x7b
Oct 28 15:29:00 grubby kernel: [  951.016001]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.016006]  [<ffffffff81057a9d>] ? do_se=
nd_sig_info+0x60/0x72
Oct 28 15:29:00 grubby kernel: [  951.016011]  [<ffffffff81057c30>] ? group=
_send_sig_info+0x31/0x3a
Oct 28 15:29:00 grubby kernel: [  951.016016]  [<ffffffff81057d0f>] ? kill_=
pid_info+0x30/0x44
Oct 28 15:29:00 grubby kernel: [  951.016021]  [<ffffffff8104ca29>] ? times=
pec_add_safe+0x32/0x61
Oct 28 15:29:00 grubby kernel: [  951.016026]  [<ffffffff810136d7>] ? read_=
tsc+0x9/0x19
Oct 28 15:29:00 grubby kernel: [  951.016032]  [<ffffffff8110bc92>] ? poll_=
select_set_timeout+0x61/0x75
Oct 28 15:29:00 grubby kernel: [  951.016037]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.016042]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.016046] udevd           S 00000000000=
00000     0  8993    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016052]  ffff88020619fdf8 00000000000=
00082 ffff88020619ff08 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.016059]  ffff88022cfd4fa0 ffff8802061=
9ffd8 ffff88020619ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016066]  ffff88022ed59610 ffff88022cf=
d4fa0 00007f20db2a71f5 0000000100000000
Oct 28 15:29:00 grubby kernel: [  951.016073] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016078]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016084]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.016090]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.016096]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.016102]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.016108]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.016114]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.016120]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.016126]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.016130] migration/1     S ffff88023bc=
8e3b0     0 10727      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016136]  ffff880206017df0 00000000000=
00046 ffff88022d76eea0 ffff88023bd12f40
Oct 28 15:29:00 grubby kernel: [  951.016143]  ffff88022c462240 ffff8802060=
17fd8 ffff880206017fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016150]  ffff88022b9b4870 ffff88022c4=
62240 ffff88022c73a3f8 0000000281038b82
Oct 28 15:29:00 grubby kernel: [  951.016156] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016162]  [<ffffffff8104040e>] ? pull_=
task+0x49/0x49
Oct 28 15:29:00 grubby kernel: [  951.016167]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016172]  [<ffffffff8108ad8c>] cpu_sto=
pper_thread+0x16b/0x187
Oct 28 15:29:00 grubby kernel: [  951.016177]  [<ffffffff8134c722>] ? __sch=
edule+0x5c5/0x5dc
Oct 28 15:29:00 grubby kernel: [  951.016183]  [<ffffffff81040768>] ? defau=
lt_wake_function+0xd/0xf
Oct 28 15:29:00 grubby kernel: [  951.016188]  [<ffffffff8108ac21>] ? cpu_s=
top_signal_done+0x30/0x30
Oct 28 15:29:00 grubby kernel: [  951.016193]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016199]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016205]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016211]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016215] kworker/1:2     S 00000000000=
00000     0 10728      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016221]  ffff880206131e90 00000000000=
00046 ffff880206131e20 ffffffff81194604
Oct 28 15:29:00 grubby kernel: [  951.016228]  ffff88020622e300 ffff8802061=
31fd8 ffff880206131fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016235]  ffff88022b9b4870 ffff8802062=
2e300 ffffffff8105c45d 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.016241] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016247]  [<ffffffff81194604>] ? __blk=
_run_queue+0x16/0x18
Oct 28 15:29:00 grubby kernel: [  951.016253]  [<ffffffff8105c45d>] ? need_=
to_create_worker+0xd/0x21
Oct 28 15:29:00 grubby kernel: [  951.016258]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016264]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.016270]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.016275]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016281]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016287]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016293]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016296] ksoftirqd/1     S 00000000000=
00000     0 10729      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016302]  ffff88022d345e90 00000000000=
00046 0000000000000100 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.016309]  ffff8802061e1590 ffff88022d3=
45fd8 ffff88022d345fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016315]  ffff88022ed160c0 ffff8802061=
e1590 ffff8802061e1590 0000000100000001
Oct 28 15:29:00 grubby kernel: [  951.016322] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016328]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016334]  [<ffffffff8104d8cb>] run_kso=
ftirqd+0x50/0x10f
Oct 28 15:29:00 grubby kernel: [  951.016339]  [<ffffffff8104d87b>] ? __do_=
softirq+0x182/0x182
Oct 28 15:29:00 grubby kernel: [  951.016345]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016351]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016356]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016362]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016365] migration/2     S 00000000000=
00000     0 10730      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016372]  ffff88020613bdf0 00000000000=
00046 ffff88020613bd90 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.016378]  ffff88022ed88180 ffff8802061=
3bfd8 ffff88020613bfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016385]  ffff88022ed59610 ffff88022ed=
88180 ffff88020613bde0 0000000181038b82
Oct 28 15:29:00 grubby kernel: [  951.016392] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016397]  [<ffffffff81040399>] ? __mig=
rate_task+0xec/0xec
Oct 28 15:29:00 grubby kernel: [  951.016403]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016408]  [<ffffffff8108ad8c>] cpu_sto=
pper_thread+0x16b/0x187
Oct 28 15:29:00 grubby kernel: [  951.016413]  [<ffffffff8134c722>] ? __sch=
edule+0x5c5/0x5dc
Oct 28 15:29:00 grubby kernel: [  951.016419]  [<ffffffff8108ac21>] ? cpu_s=
top_signal_done+0x30/0x30
Oct 28 15:29:00 grubby kernel: [  951.016424]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016430]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016436]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016441]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016445] kworker/2:4     S 00000000000=
00000     0 10731      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016451]  ffff8802060ede90 00000000000=
00046 ffff8802060ede20 ffff880213381940
Oct 28 15:29:00 grubby kernel: [  951.016458]  ffff880206054830 ffff8802060=
edfd8 ffff8802060edfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016464]  ffff8802061e07b0 ffff8802060=
54830 ffffffff8105c45d 0000000113381940
Oct 28 15:29:00 grubby kernel: [  951.016471] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016477]  [<ffffffff8105c45d>] ? need_=
to_create_worker+0xd/0x21
Oct 28 15:29:00 grubby kernel: [  951.016482]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016488]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.016494]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.016499]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016505]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016511]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016516]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016520] ksoftirqd/2     S ffff8802060=
31510     0 10732      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016526]  ffff88020407fe90 00000000000=
00046 0000000000000100 0000000000000046
Oct 28 15:29:00 grubby kernel: [  951.016533]  ffff880206031510 ffff8802040=
7ffd8 ffff88020407ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016539]  ffff88022ed59610 ffff8802060=
31510 ffff880206031510 0000000100000002
Oct 28 15:29:00 grubby kernel: [  951.016546] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016552]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016557]  [<ffffffff8104d8cb>] run_kso=
ftirqd+0x50/0x10f
Oct 28 15:29:00 grubby kernel: [  951.016563]  [<ffffffff8104d87b>] ? __do_=
softirq+0x182/0x182
Oct 28 15:29:00 grubby kernel: [  951.016568]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016574]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016580]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016586]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016589] migration/3     S 00000000000=
00000     0 10733      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016595]  ffff8802060efdf0 00000000000=
00046 ffff8802060efd90 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.016602]  ffff88020389f610 ffff8802060=
effd8 ffff8802060effd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016609]  ffff88022ed88f60 ffff8802038=
9f610 ffff8802060efde0 0000000181038b82
Oct 28 15:29:00 grubby kernel: [  951.016615] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016621]  [<ffffffff81040399>] ? __mig=
rate_task+0xec/0xec
Oct 28 15:29:00 grubby kernel: [  951.016626]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016631]  [<ffffffff8108ad8c>] cpu_sto=
pper_thread+0x16b/0x187
Oct 28 15:29:00 grubby kernel: [  951.016637]  [<ffffffff8134c722>] ? __sch=
edule+0x5c5/0x5dc
Oct 28 15:29:00 grubby kernel: [  951.016642]  [<ffffffff8108ac21>] ? cpu_s=
top_signal_done+0x30/0x30
Oct 28 15:29:00 grubby kernel: [  951.016648]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016653]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016659]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016665]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016669] kworker/3:3     S 00000000000=
00000     0 10734      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016675]  ffff880206169e90 00000000000=
00046 ffff880206169e40 ffffffffa0082a28
Oct 28 15:29:00 grubby kernel: [  951.016682]  ffff88022c640970 ffff8802061=
69fd8 ffff880206169fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016688]  ffff88022ed88f60 ffff88022c6=
40970 0000000000000008 0000000100000004
Oct 28 15:29:00 grubby kernel: [  951.016695] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016716]  [<ffffffffa0082a28>] ? ata_s=
csi_hotplug+0x7d/0x85 [libata]
Oct 28 15:29:00 grubby kernel: [  951.016723]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016729]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.016735]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.016740]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016746]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016752]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016758]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016762] ksoftirqd/3     S 00000000000=
00000     0 10735      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016768]  ffff880221807e90 00000000000=
00046 0000000000000100 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.016775]  ffff88022c299060 ffff8802218=
07fd8 ffff880221807fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016781]  ffff88022ed88f60 ffff88022c2=
99060 ffff88022c299060 0000000100000003
Oct 28 15:29:00 grubby kernel: [  951.016788] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016794]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016800]  [<ffffffff8104d8cb>] run_kso=
ftirqd+0x50/0x10f
Oct 28 15:29:00 grubby kernel: [  951.016805]  [<ffffffff8104d87b>] ? __do_=
softirq+0x182/0x182
Oct 28 15:29:00 grubby kernel: [  951.016811]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016817]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016822]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016828]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016832] kworker/1:0     S 00000000000=
00000     0 10749      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016838]  ffff88020409be90 00000000000=
00046 ffff88020409be20 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.016844]  ffff88022b9b4870 ffff8802040=
9bfd8 ffff88020409bfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016851]  ffff88022ed160c0 ffff88022b9=
b4870 ffff88023bc8de48 0000000100000002
Oct 28 15:29:00 grubby kernel: [  951.016858] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016863]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016869]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.016875]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.016880]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016886]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016892]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016897]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016901] kworker/3:0     S 00000000000=
00000     0 10771      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016906]  ffff88020610be90 00000000000=
00046 ffff88020610be20 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.016913]  ffff8802038c36d0 ffff8802061=
0bfd8 ffff88020610bfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016920]  ffff88022ed88f60 ffff8802038=
c36d0 ffff8802038c36d0 0000000115600ec0
Oct 28 15:29:00 grubby kernel: [  951.016926] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.016932]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.016937]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.016943]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.016949]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.016955]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.016960]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.016966]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.016969] kworker/2:1     D ffff8802060=
54830     0 10775      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.016975]  ffff880206067aa0 00000000000=
00046 ffff880206067a50 ffffffff8105476d
Oct 28 15:29:00 grubby kernel: [  951.016982]  ffff88022ed58140 ffff8802060=
67fd8 ffff880206067fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.016989]  ffff880206054830 ffff88022ed=
58140 ffff880200000002 0000000000000286
Oct 28 15:29:00 grubby kernel: [  951.016996] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.017001]  [<ffffffff8105476d>] ? lock_=
timer_base.isra.29+0x26/0x4b
Oct 28 15:29:00 grubby kernel: [  951.017007]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.017013]  [<ffffffff8134cc9f>] schedul=
e_timeout+0xa2/0xd9
Oct 28 15:29:00 grubby kernel: [  951.017018]  [<ffffffff81053ecf>] ? uslee=
p_range+0x3d/0x3d
Oct 28 15:29:00 grubby kernel: [  951.017024]  [<ffffffff8134c832>] wait_fo=
r_common+0x9e/0x115
Oct 28 15:29:00 grubby kernel: [  951.017030]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.017035]  [<ffffffff8134c925>] wait_fo=
r_completion_timeout+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.017043]  [<ffffffff8119c502>] blk_exe=
cute_rq+0xb7/0xf9
Oct 28 15:29:00 grubby kernel: [  951.017049]  [<ffffffff81123ab6>] ? bio_p=
hys_segments+0x15/0x1c
Oct 28 15:29:00 grubby kernel: [  951.017055]  [<ffffffff81199942>] ? blk_r=
q_bio_prep+0x3a/0x6e
Oct 28 15:29:00 grubby kernel: [  951.017072]  [<ffffffffa0043044>] scsi_ex=
ecute+0xf5/0x14d [scsi_mod]
Oct 28 15:29:00 grubby kernel: [  951.017088]  [<ffffffffa004311e>] scsi_ex=
ecute_req+0x82/0xb4 [scsi_mod]
Oct 28 15:29:00 grubby kernel: [  951.017100]  [<ffffffffa00bb2d9>] sr_chec=
k_events+0x92/0x21e [sr_mod]
Oct 28 15:29:00 grubby kernel: [  951.017106]  [<ffffffff81038d90>] ? set_n=
ext_entity+0x3a/0x5f
Oct 28 15:29:00 grubby kernel: [  951.017111]  [<ffffffff8100d009>] ? read_=
cr0+0x9/0xd
Oct 28 15:29:00 grubby kernel: [  951.017123]  [<ffffffffa009d04b>] cdrom_c=
heck_events+0x14/0x29 [cdrom]
Oct 28 15:29:00 grubby kernel: [  951.017136]  [<ffffffffa00bb696>] sr_bloc=
k_check_events+0x14/0x16 [sr_mod]
Oct 28 15:29:00 grubby kernel: [  951.017144]  [<ffffffff8119ea7b>] disk_ev=
ents_workfn+0x3b/0xd7
Oct 28 15:29:00 grubby kernel: [  951.017149]  [<ffffffff8119ea40>] ? __dis=
k_unblock_events+0xb8/0xb8
Oct 28 15:29:00 grubby kernel: [  951.017155]  [<ffffffff8105dcc9>] process=
_one_work+0x165/0x27a
Oct 28 15:29:00 grubby kernel: [  951.017162]  [<ffffffff8105ed4f>] worker_=
thread+0xce/0x152
Oct 28 15:29:00 grubby kernel: [  951.017168]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.017173]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.017179]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.017185]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.017191]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.017195] udevd           S ffff88022cb=
17b80     0 10777    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.017201]  ffff88020626bdf8 00000000000=
00086 ffff88020626bf08 ffffffff8127969c
Oct 28 15:29:00 grubby kernel: [  951.017208]  ffff8802038c28f0 ffff8802062=
6bfd8 ffff88020626bfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.017215]  ffff88022c299750 ffff8802038=
c28f0 ffffffff810d1449 ffff88020626bdd8
Oct 28 15:29:00 grubby kernel: [  951.017222] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.017227]  [<ffffffff8127969c>] ? __sys=
_sendmsg+0x20e/0x2b5
Oct 28 15:29:00 grubby kernel: [  951.017233]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.017238]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.017244]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.017250]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.017256]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017262]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.017268]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.017274]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.017280]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.017286]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.017292]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017296] udevd           S ffff88022c5=
d0480     0 10778    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.017302]  ffff88020401fdf8 00000000000=
00082 ffff88020401ff08 ffffffff8127969c
Oct 28 15:29:00 grubby kernel: [  951.017309]  ffff88022c4bef60 ffff8802040=
1ffd8 ffff88020401ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.017315]  ffff88022c092040 ffff88022c4=
bef60 00007f20db2c695e ffff88020401fdd8
Oct 28 15:29:00 grubby kernel: [  951.017322] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.017327]  [<ffffffff8127969c>] ? __sys=
_sendmsg+0x20e/0x2b5
Oct 28 15:29:00 grubby kernel: [  951.017333]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.017338]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.017344]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.017350]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017356]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.017362]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.017368]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.017374]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.017380]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.017386]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017390] udevd           S ffff88022c5=
d0480     0 10779    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.017396]  ffff8802133c1df8 00000000000=
00086 ffff8802133c1f08 ffffffff8127969c
Oct 28 15:29:00 grubby kernel: [  951.017403]  ffff8802038a4870 ffff8802133=
c1fd8 ffff8802133c1fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.017409]  ffff88022c092040 ffff8802038=
a4870 00007f20db2a780c ffff8802133c1dd8
Oct 28 15:29:00 grubby kernel: [  951.017416] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.017421]  [<ffffffff8127969c>] ? __sys=
_sendmsg+0x20e/0x2b5
Oct 28 15:29:00 grubby kernel: [  951.017427]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.017432]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.017438]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.017444]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017450]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.017456]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.017462]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.017468]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.017473]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.017479]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017484] udevd           S ffff88022c5=
d0480     0 10780    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.017490]  ffff88020601fdf8 00000000000=
00082 ffff88020601ff08 ffffffff8127969c
Oct 28 15:29:00 grubby kernel: [  951.017497]  ffff88022ddc4200 ffff8802060=
1ffd8 ffff88020601ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.017503]  ffff88022c092040 ffff88022dd=
c4200 ffff88020601fe48 ffff88020601fdd8
Oct 28 15:29:00 grubby kernel: [  951.017510] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.017515]  [<ffffffff8127969c>] ? __sys=
_sendmsg+0x20e/0x2b5
Oct 28 15:29:00 grubby kernel: [  951.017521]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.017526]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.017532]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.017538]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017544]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.017550]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.017556]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.017562]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.017568]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.017574]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017578] udevd           S ffff88022c5=
d0480     0 10781    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.017584]  ffff8802063dddf8 00000000000=
00086 ffff8802063ddf08 ffffffff8127969c
Oct 28 15:29:00 grubby kernel: [  951.017591]  ffff88022cbfa080 ffff8802063=
ddfd8 ffff8802063ddfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.017597]  ffff88022c092040 ffff88022cb=
fa080 ffffffff810d1449 ffff8802063dddd8
Oct 28 15:29:00 grubby kernel: [  951.017604] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.017609]  [<ffffffff8127969c>] ? __sys=
_sendmsg+0x20e/0x2b5
Oct 28 15:29:00 grubby kernel: [  951.017614]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.017620]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.017626]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.017631]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.017637]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017643]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.017649]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.017655]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.017661]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.017667]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.017673]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017677] udevd           S ffff88022c4=
40400     0 10782    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.017683]  ffff880215427df8 00000000000=
00082 ffff880215427f08 ffffffff8127969c
Oct 28 15:29:00 grubby kernel: [  951.017690]  ffff88022ddc56d0 ffff8802154=
27fd8 ffff880215427fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.017696]  ffff88020427e930 ffff88022dd=
c56d0 00007f20db2c87de ffff880215427dd8
Oct 28 15:29:00 grubby kernel: [  951.017703] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.017708]  [<ffffffff8127969c>] ? __sys=
_sendmsg+0x20e/0x2b5
Oct 28 15:29:00 grubby kernel: [  951.017714]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.017719]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.017725]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.017731]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017737]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.017743]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.017749]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.017755]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.017761]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.017767]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017771] udevd           S ffff88022c5=
d0480     0 10783    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.017777]  ffff88021ef37df8 00000000000=
00086 ffff88021ef37f08 ffffffff8127969c
Oct 28 15:29:00 grubby kernel: [  951.017784]  ffff8802040ca870 ffff88021ef=
37fd8 ffff88021ef37fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.017790]  ffff88022c092040 ffff8802040=
ca870 ffffffff810d1449 ffff88021ef37dd8
Oct 28 15:29:00 grubby kernel: [  951.017797] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.017802]  [<ffffffff8127969c>] ? __sys=
_sendmsg+0x20e/0x2b5
Oct 28 15:29:00 grubby kernel: [  951.017807]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.017813]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.017818]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.017824]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.017830]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017836]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.017842]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.017848]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.017854]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.017860]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.017866]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017870] udevd           S 00000000000=
00000     0 10784    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.017876]  ffff880203859df8 00000000000=
00086 ffff880203859f08 ffffffff8127969c
Oct 28 15:29:00 grubby kernel: [  951.017883]  ffff8802040ca180 ffff8802038=
59fd8 ffff880203859fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.017889]  ffff88022c5ef020 ffff8802040=
ca180 ffffffff810d1449 ffff880203859dd8
Oct 28 15:29:00 grubby kernel: [  951.017896] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.017901]  [<ffffffff8127969c>] ? __sys=
_sendmsg+0x20e/0x2b5
Oct 28 15:29:00 grubby kernel: [  951.017906]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.017912]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.017917]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.017923]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.017929]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017935]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.017941]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.017947]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.017953]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.017959]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.017965]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.017969] udevd           S ffff88022df=
bf040     0 10785    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.017975]  ffff88022d41fdf8 00000000000=
00086 ffff88022c9f6380 ffff88020631a3c0
Oct 28 15:29:00 grubby kernel: [  951.017982]  ffff88020631a3c0 ffff88022d4=
1ffd8 ffff88022d41ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.017989]  ffff88020409e9f0 ffff8802063=
1a3c0 ffffffff810d1449 ffff8802154b1658
Oct 28 15:29:00 grubby kernel: [  951.017995] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018000]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018006]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018012]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018017]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018023]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018029]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018035]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018041]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018045] udevd           S ffff88022cb=
0b440     0 10786    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018051]  ffff880203903df8 00000000000=
00086 ffff88022cd73580 ffff880213122140
Oct 28 15:29:00 grubby kernel: [  951.018058]  ffff880213122140 ffff8802039=
03fd8 ffff880203903fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018064]  ffff88022c4bef60 ffff8802131=
22140 ffffffff810d1449 ffff88021ec80658
Oct 28 15:29:00 grubby kernel: [  951.018071] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018076]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018081]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018087]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018093]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018099]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018104]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018110]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018116]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018120] udevd           S ffff88022d7=
3a440     0 10787    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018126]  ffff880204283df8 00000000000=
00086 ffff88022d8bee80 ffff8802042fd810
Oct 28 15:29:00 grubby kernel: [  951.018133]  ffff8802042fd810 ffff8802042=
83fd8 ffff880204283fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018140]  ffff880204264fa0 ffff8802042=
fd810 ffffffff810d1449 ffff8802061f5658
Oct 28 15:29:00 grubby kernel: [  951.018146] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018151]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018157]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018163]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018168]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018174]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018180]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018186]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018192]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018196] udevd           S ffff88022c7=
d2800     0 10788    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018202]  ffff880221755df8 00000000000=
00082 ffff88022d874e40 ffff880204264fa0
Oct 28 15:29:00 grubby kernel: [  951.018209]  ffff880204264fa0 ffff8802217=
55fd8 ffff880221755fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018215]  ffff88020631a3c0 ffff8802042=
64fa0 ffffffff810d1449 ffff88020418c658
Oct 28 15:29:00 grubby kernel: [  951.018222] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018227]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018233]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018239]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018244]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018250]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018256]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018262]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018268]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018272] udevd           S ffff88022cf=
61400     0 10789    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018277]  ffff8802038e5df8 00000000000=
00082 ffff88022c46f580 ffff88022d9cb8d0
Oct 28 15:29:00 grubby kernel: [  951.018285]  ffff88022d9cb8d0 ffff8802038=
e5fd8 ffff8802038e5fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018291]  ffff88022ca80300 ffff88022d9=
cb8d0 ffffffff810d1449 ffff880213027658
Oct 28 15:29:00 grubby kernel: [  951.018298] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018303]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018308]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018314]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018320]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018326]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018331]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018337]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018343]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018347] udevd           S ffff88022ec=
fbc00     0 10790    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018353]  ffff880213341df8 00000000000=
00086 ffff88020388c300 ffff88022ca80300
Oct 28 15:29:00 grubby kernel: [  951.018360]  ffff88022ca80300 ffff8802133=
41fd8 ffff880213341fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018367]  ffff880213122140 ffff88022ca=
80300 ffffffff810d1449 ffff880206063658
Oct 28 15:29:00 grubby kernel: [  951.018373] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018379]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018384]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018390]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018395]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018401]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018407]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018413]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018419]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018423] udevd           S ffff88022ba=
6b7c0     0 10791    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018429]  ffff880213333df8 00000000000=
00086 ffff88022c7240c0 ffff88022d80b1a0
Oct 28 15:29:00 grubby kernel: [  951.018436]  ffff88022d80b1a0 ffff8802133=
33fd8 ffff880213333fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018442]  ffff8802040ca180 ffff88022d8=
0b1a0 ffffffff810d1449 ffff880204306658
Oct 28 15:29:00 grubby kernel: [  951.018449] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018454]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018460]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018465]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018471]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018477]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018483]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018488]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018494]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018498] udevd           S ffff88022d5=
23040     0 10799    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018504]  ffff8802133cfdf8 00000000000=
00082 ffff88022d2c6540 ffff88020600b810
Oct 28 15:29:00 grubby kernel: [  951.018512]  ffff88020600b810 ffff8802133=
cffd8 ffff8802133cffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018518]  ffff88022c5521c0 ffff8802060=
0b810 ffffffff810d1449 ffff88022e3b3658
Oct 28 15:29:00 grubby kernel: [  951.018525] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018530]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018535]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018541]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018547]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018553]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018558]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018564]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018570]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018574] udevd           S ffff88022cc=
c5080     0 10800    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018580]  ffff88022d641df8 00000000000=
00082 ffff8802042b6ac0 ffff880206222870
Oct 28 15:29:00 grubby kernel: [  951.018587]  ffff880206222870 ffff88022d6=
41fd8 ffff88022d641fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018594]  ffff880206030730 ffff8802062=
22870 ffffffff810d1449 ffff8802063ee658
Oct 28 15:29:00 grubby kernel: [  951.018600] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018605]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018611]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018617]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018622]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018628]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018634]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018640]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018646]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018650] udevd           S ffff88022c2=
fc0c0     0 10801    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018656]  ffff8802062f7df8 00000000000=
00082 ffff8802042b7300 ffff880206030730
Oct 28 15:29:00 grubby kernel: [  951.018663]  ffff880206030730 ffff8802062=
f7fd8 ffff8802062f7fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018669]  ffff88022d80b1a0 ffff8802060=
30730 ffffffff810d1449 ffff8802156e0658
Oct 28 15:29:00 grubby kernel: [  951.018676] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018681]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018687]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018692]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018698]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018704]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018709]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018715]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018721]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018726] udevd           S ffff88022d3=
a10c0     0 10802    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018731]  ffff8802157cbdf8 00000000000=
00082 ffff88022c5c4e80 ffff880206384100
Oct 28 15:29:00 grubby kernel: [  951.018738]  ffff880206384100 ffff8802157=
cbfd8 ffff8802157cbfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018745]  ffff8802042fd810 ffff8802063=
84100 ffffffff810d1449 ffff880204184658
Oct 28 15:29:00 grubby kernel: [  951.018752] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018757]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018762]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018768]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018773]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018779]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018785]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018791]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018797]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018801] udevd           S ffff88022dd=
f07c0     0 10803    304 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.018807]  ffff88020608bdf8 00000000000=
00082 ffff88022cd0d400 ffff88020409e9f0
Oct 28 15:29:00 grubby kernel: [  951.018814]  ffff88020409e9f0 ffff8802060=
8bfd8 ffff88020608bfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018820]  ffff8802040ca870 ffff8802040=
9e9f0 ffffffff810d1449 ffff88020626c658
Oct 28 15:29:00 grubby kernel: [  951.018827] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018832]  [<ffffffff810d1449>] ? pmd_o=
ffset+0x14/0x3a
Oct 28 15:29:00 grubby kernel: [  951.018838]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018843]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.018849]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.018855]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.018861]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.018866]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018872]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.018877] scsi_id         D 00000000000=
00000     0 11343   8992 0x00000004
Oct 28 15:29:00 grubby kernel: [  951.018882]  ffff880225e6f8d8 00000000000=
00082 00ff880200000000 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.018889]  ffff88022d7ed610 ffff880225e=
6ffd8 ffff880225e6ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.018896]  ffff88022ed59610 ffff88022d7=
ed610 ffff88020439e440 0000000100000002
Oct 28 15:29:00 grubby kernel: [  951.018903] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.018908]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.018913]  [<ffffffff8134cc2c>] schedul=
e_timeout+0x2f/0xd9
Oct 28 15:29:00 grubby kernel: [  951.018919]  [<ffffffff8104302a>] ? __con=
d_resched+0x23/0x2f
Oct 28 15:29:00 grubby kernel: [  951.018925]  [<ffffffff8134c832>] wait_fo=
r_common+0x9e/0x115
Oct 28 15:29:00 grubby kernel: [  951.018930]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.018936]  [<ffffffff8134c93f>] wait_fo=
r_completion+0x18/0x1a
Oct 28 15:29:00 grubby kernel: [  951.018942]  [<ffffffff8105d659>] flush_w=
ork+0x29/0x2f
Oct 28 15:29:00 grubby kernel: [  951.018947]  [<ffffffff8105c8ff>] ? do_wo=
rk_for_cpu+0x24/0x24
Oct 28 15:29:00 grubby kernel: [  951.018953]  [<ffffffff8105d9e5>] flush_d=
elayed_work+0x3a/0x3e
Oct 28 15:29:00 grubby kernel: [  951.018959]  [<ffffffff811a0156>] disk_cl=
ear_events+0x8f/0xf5
Oct 28 15:29:00 grubby kernel: [  951.018970]  [<ffffffff81125280>] check_d=
isk_change+0x29/0x5c
Oct 28 15:29:00 grubby kernel: [  951.018982]  [<ffffffffa009feb1>] cdrom_o=
pen+0x44/0x4b2 [cdrom]
Oct 28 15:29:00 grubby kernel: [  951.018988]  [<ffffffff811aba78>] ? kobje=
ct_get+0x18/0x20
Oct 28 15:29:00 grubby kernel: [  951.018994]  [<ffffffff8124a895>] ? get_d=
evice+0x14/0x1a
Oct 28 15:29:00 grubby kernel: [  951.019005]  [<ffffffffa00bb86b>] sr_bloc=
k_open+0x90/0xb7 [sr_mod]
Oct 28 15:29:00 grubby kernel: [  951.019011]  [<ffffffff8112610b>] __blkde=
v_get+0xe2/0x398
Oct 28 15:29:00 grubby kernel: [  951.019016]  [<ffffffff8112667c>] ? blkde=
v_get+0x2bb/0x2bb
Oct 28 15:29:00 grubby kernel: [  951.019021]  [<ffffffff8112658d>] blkdev_=
get+0x1cc/0x2bb
Oct 28 15:29:00 grubby kernel: [  951.019026]  [<ffffffff8112667c>] ? blkde=
v_get+0x2bb/0x2bb
Oct 28 15:29:00 grubby kernel: [  951.019031]  [<ffffffff811266de>] blkdev_=
open+0x62/0x66
Oct 28 15:29:00 grubby kernel: [  951.019036]  [<ffffffff810fbf12>] __dentr=
y_open+0x182/0x299
Oct 28 15:29:00 grubby kernel: [  951.019042]  [<ffffffff8134db64>] ? _raw_=
spin_lock+0x9/0xb
Oct 28 15:29:00 grubby kernel: [  951.019048]  [<ffffffff810fcde9>] nameida=
ta_to_filp+0x5b/0x62
Oct 28 15:29:00 grubby kernel: [  951.019054]  [<ffffffff81108e4a>] do_last=
+0x454/0x56c
Oct 28 15:29:00 grubby kernel: [  951.019060]  [<ffffffff8110905a>] path_op=
enat+0xca/0x30b
Oct 28 15:29:00 grubby kernel: [  951.019066]  [<ffffffff810d4744>] ? handl=
e_mm_fault+0x1c3/0x1d6
Oct 28 15:29:00 grubby kernel: [  951.019072]  [<ffffffff811092e9>] do_filp=
_open+0x33/0x81
Oct 28 15:29:00 grubby kernel: [  951.019078]  [<ffffffff81112584>] ? alloc=
_fd+0x6d/0x118
Oct 28 15:29:00 grubby kernel: [  951.019084]  [<ffffffff810fce59>] do_sys_=
open+0x69/0xfb
Oct 28 15:29:00 grubby kernel: [  951.019089]  [<ffffffff810fcf06>] sys_ope=
n+0x1b/0x1d
Oct 28 15:29:00 grubby kernel: [  951.019095]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.019099] kworker/2:2     S 00000000000=
00000     0 11344      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.019106]  ffff88021ef57e90 00000000000=
00046 ffff88021ef57e20 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.019112]  ffff88022c462930 ffff88021ef=
57fd8 ffff88021ef57fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.019119]  ffff88022ed59610 ffff88022c4=
62930 ffff88021ef57e60 0000000100000000
Oct 28 15:29:00 grubby kernel: [  951.019126] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.019131]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.019137]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.019143]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.019149]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.019155]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.019160]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.019166]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.019170] hci0            S ffff88022e3=
e7e40     0 12431      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.019176]  ffff880206295e50 00000000000=
00046 ffff88023bc92f40 00000000ffffffec
Oct 28 15:29:00 grubby kernel: [  951.019183]  ffff8802062f0a70 ffff8802062=
95fd8 ffff880206295fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.019190]  ffff88022ed160c0 ffff8802062=
f0a70 ffff880206295e20 ffffffff81038cc9
Oct 28 15:29:00 grubby kernel: [  951.019196] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.019201]  [<ffffffff81038cc9>] ? task_=
rq_unlock+0x16/0x18
Oct 28 15:29:00 grubby kernel: [  951.019207]  [<ffffffff8105de08>] ? proce=
ss_scheduled_works+0x2a/0x2a
Oct 28 15:29:00 grubby kernel: [  951.019212]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.019218]  [<ffffffff8105df70>] rescuer=
_thread+0x168/0x16d
Oct 28 15:29:00 grubby kernel: [  951.019224]  [<ffffffff8105de08>] ? proce=
ss_scheduled_works+0x2a/0x2a
Oct 28 15:29:00 grubby kernel: [  951.019229]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.019235]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.019241]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.019247]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.019250] xterm           S 00000000000=
00000     0 12598      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.019256]  ffff880206377928 00000000000=
00082 ffff88022e3ddc80 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.019263]  ffff880206384ee0 ffff8802063=
77fd8 ffff880206377fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.019270]  ffffffff8160d020 ffff8802063=
84ee0 ffff880206377928 000000018105d5db
Oct 28 15:29:00 grubby kernel: [  951.019277] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.019282]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.019288]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.019294]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.019299]  [<ffffffff81038c28>] ? __wak=
e_up+0x3f/0x48
Oct 28 15:29:00 grubby kernel: [  951.019305]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.019310]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.019315]  [<ffffffff8110c13c>] do_sele=
ct+0x496/0x4da
Oct 28 15:29:00 grubby kernel: [  951.019321]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.019325]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.019330]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.019335]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.019339]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.019345]  [<ffffffff812f6d77>] ? unix_=
stream_recvmsg+0x50f/0x52f
Oct 28 15:29:00 grubby kernel: [  951.019352]  [<ffffffff8127a20e>] ? sock_=
aio_read.part.10+0x136/0x14a
Oct 28 15:29:00 grubby kernel: [  951.019357]  [<ffffffff810370ea>] ? shoul=
d_resched+0x9/0x28
Oct 28 15:29:00 grubby kernel: [  951.019363]  [<ffffffff8134c780>] ? _cond=
_resched+0x9/0x1d
Oct 28 15:29:00 grubby kernel: [  951.019368]  [<ffffffff8110c2de>] core_sy=
s_select+0x15e/0x1fd
Oct 28 15:29:00 grubby kernel: [  951.019373]  [<ffffffff8127a243>] ? sock_=
aio_read+0x21/0x23
Oct 28 15:29:00 grubby kernel: [  951.019379]  [<ffffffff811695fe>] ? secur=
ity_file_permission+0x29/0x2e
Oct 28 15:29:00 grubby kernel: [  951.019385]  [<ffffffff8110c409>] sys_sel=
ect+0x8c/0xb4
Oct 28 15:29:00 grubby kernel: [  951.019389]  [<ffffffff8110c9e4>] ? sys_p=
oll+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.019395]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.019399] bash            S 00000000000=
00000     0 12604  12598 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.019405]  ffff880206337d18 00000000000=
00082 ffff880206337ca8 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.019412]  ffff88022db15650 ffff8802063=
37fd8 ffff880206337fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.019419]  ffffffff8160d020 ffff88022db=
15650 ffffffff8134dba7 000000013bc0de40
Oct 28 15:29:00 grubby kernel: [  951.019425] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.019431]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.019437]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.019442]  [<ffffffff8134cc2c>] schedul=
e_timeout+0x2f/0xd9
Oct 28 15:29:00 grubby kernel: [  951.019448]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.019454]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.019460]  [<ffffffff8122a5f2>] ? tty_f=
lush_to_ldisc+0x10/0x12
Oct 28 15:29:00 grubby kernel: [  951.019465]  [<ffffffff81227c51>] n_tty_r=
ead+0x3e1/0x724
Oct 28 15:29:00 grubby kernel: [  951.019470]  [<ffffffff810625a6>] ? remov=
e_wait_queue+0x4c/0x51
Oct 28 15:29:00 grubby kernel: [  951.019476]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.019482]  [<ffffffff812230dd>] tty_rea=
d+0x8c/0xc7
Oct 28 15:29:00 grubby kernel: [  951.019488]  [<ffffffff810fd99f>] vfs_rea=
d+0xa4/0xeb
Oct 28 15:29:00 grubby kernel: [  951.019493]  [<ffffffff81058768>] ? set_c=
urrent_blocked+0x44/0x49
Oct 28 15:29:00 grubby kernel: [  951.019499]  [<ffffffff810fda2b>] sys_rea=
d+0x45/0x69
Oct 28 15:29:00 grubby kernel: [  951.019504]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.019508] xterm           S 00000000000=
00000     0 13189      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.019514]  ffff8802060a7928 00000000000=
00086 ffff88022e3ddc80 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.019521]  ffff88022c641750 ffff8802060=
a7fd8 ffff8802060a7fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.019528]  ffffffff8160d020 ffff88022c6=
41750 ffff8802060a7928 000000018105d5db
Oct 28 15:29:00 grubby kernel: [  951.019534] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.019540]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.019546]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.019552]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.019557]  [<ffffffff81038c28>] ? __wak=
e_up+0x3f/0x48
Oct 28 15:29:00 grubby kernel: [  951.019563]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.019568]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.019573]  [<ffffffff8110c13c>] do_sele=
ct+0x496/0x4da
Oct 28 15:29:00 grubby kernel: [  951.019578]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.019583]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.019588]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.019592]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.019597]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.019602]  [<ffffffff812f6d77>] ? unix_=
stream_recvmsg+0x50f/0x52f
Oct 28 15:29:00 grubby kernel: [  951.019609]  [<ffffffff81036cf4>] ? __wak=
e_up_common+0x48/0x7e
Oct 28 15:29:00 grubby kernel: [  951.019614]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.019620]  [<ffffffff8127a20e>] ? sock_=
aio_read.part.10+0x136/0x14a
Oct 28 15:29:00 grubby kernel: [  951.019626]  [<ffffffff810370ea>] ? shoul=
d_resched+0x9/0x28
Oct 28 15:29:00 grubby kernel: [  951.019631]  [<ffffffff8134c780>] ? _cond=
_resched+0x9/0x1d
Oct 28 15:29:00 grubby kernel: [  951.019636]  [<ffffffff8110c2de>] core_sy=
s_select+0x15e/0x1fd
Oct 28 15:29:00 grubby kernel: [  951.019642]  [<ffffffff8127a243>] ? sock_=
aio_read+0x21/0x23
Oct 28 15:29:00 grubby kernel: [  951.019648]  [<ffffffff811695fe>] ? secur=
ity_file_permission+0x29/0x2e
Oct 28 15:29:00 grubby kernel: [  951.019653]  [<ffffffff8110c409>] sys_sel=
ect+0x8c/0xb4
Oct 28 15:29:00 grubby kernel: [  951.019657]  [<ffffffff8110c9e4>] ? sys_p=
oll+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.019663]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.019667] bash            S 00000000000=
00000     0 13195  13189 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.019673]  ffff8802157ebe58 00000000000=
00082 ffffffff8161b600 00007fff00000000
Oct 28 15:29:00 grubby kernel: [  951.019680]  ffff88022c4bcfa0 ffff8802157=
ebfd8 ffff8802157ebfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.019686]  ffffffff8160d020 ffff88022c4=
bcfa0 ffff8802157ebe30 00000001810748a7
Oct 28 15:29:00 grubby kernel: [  951.019693] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.019699]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.019704]  [<ffffffff8104aa31>] do_wait=
+0x19c/0x20f
Oct 28 15:29:00 grubby kernel: [  951.019709]  [<ffffffff81047589>] ? do_fo=
rk+0x19b/0x21f
Oct 28 15:29:00 grubby kernel: [  951.019714]  [<ffffffff8104bc14>] sys_wai=
t4+0x99/0xbc
Oct 28 15:29:00 grubby kernel: [  951.019720]  [<ffffffff8105f4ef>] ? find_=
pid_ns+0x27/0x67
Oct 28 15:29:00 grubby kernel: [  951.019726]  [<ffffffff81049c02>] ? task_=
stopped_code+0x3d/0x3d
Oct 28 15:29:00 grubby kernel: [  951.019732]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.019736] inet            S ffff88022cb=
177c0     0 13324  13195 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.019742]  ffff880206001e58 00000000000=
00086 0000000000bf97a4 0000000000000029
Oct 28 15:29:00 grubby kernel: [  951.019749]  ffff8802061e4af0 ffff8802060=
01fd8 ffff880206001fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.019755]  ffff88022c641750 ffff8802061=
e4af0 ffff880206001e30 ffffffff810748a7
Oct 28 15:29:00 grubby kernel: [  951.019762] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.019768]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.019773]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.019778]  [<ffffffff8104aa31>] do_wait=
+0x19c/0x20f
Oct 28 15:29:00 grubby kernel: [  951.019784]  [<ffffffff8134dba7>] ? _raw_=
spin_lock_irq+0x17/0x19
Oct 28 15:29:00 grubby kernel: [  951.019790]  [<ffffffff8104bc14>] sys_wai=
t4+0x99/0xbc
Oct 28 15:29:00 grubby kernel: [  951.019795]  [<ffffffff810370ea>] ? shoul=
d_resched+0x9/0x28
Oct 28 15:29:00 grubby kernel: [  951.019801]  [<ffffffff81049c02>] ? task_=
stopped_code+0x3d/0x3d
Oct 28 15:29:00 grubby kernel: [  951.019806]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.019811] watchdog/0      S 00000000000=
00000     0 13869      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.019817]  ffff88020433fea0 00000000000=
00046 ffff88020433fe30 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.019824]  ffff880206030e20 ffff8802043=
3ffd8 ffff88020433ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.019830]  ffffffff8160d020 ffff8802060=
30e20 0000000000000282 0000000100000282
Oct 28 15:29:00 grubby kernel: [  951.019837] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.019843]  [<ffffffff81093541>] ? watch=
dog_enable+0x196/0x196
Oct 28 15:29:00 grubby kernel: [  951.019848]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.019853]  [<ffffffff810935a9>] watchdo=
g+0x68/0xab
Oct 28 15:29:00 grubby kernel: [  951.019858]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.019864]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.019870]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.019876]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.019880] watchdog/1      S 00000000000=
00000     0 13870      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.019886]  ffff88022144bea0 00000000000=
00046 ffff88022144be30 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.019892]  ffff88022daacee0 ffff8802214=
4bfd8 ffff88022144bfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.019899]  ffff88022ed160c0 ffff88022da=
acee0 0000000000000282 0000000100000282
Oct 28 15:29:00 grubby kernel: [  951.019906] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.019911]  [<ffffffff81093541>] ? watch=
dog_enable+0x196/0x196
Oct 28 15:29:00 grubby kernel: [  951.019917]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.019922]  [<ffffffff810935a9>] watchdo=
g+0x68/0xab
Oct 28 15:29:00 grubby kernel: [  951.019927]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.019933]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.019938]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.019944]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.019948] watchdog/2      S 00000000000=
00000     0 13871      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.019954]  ffff88022c0c5ea0 00000000000=
00046 ffff88022c0c5e30 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.019961]  ffff88022cfd5690 ffff88022c0=
c5fd8 ffff88022c0c5fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.019967]  ffff88022ed59610 ffff88022cf=
d5690 0000000000000282 0000000100000282
Oct 28 15:29:00 grubby kernel: [  951.019974] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.019980]  [<ffffffff81093541>] ? watch=
dog_enable+0x196/0x196
Oct 28 15:29:00 grubby kernel: [  951.019985]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.019990]  [<ffffffff810935a9>] watchdo=
g+0x68/0xab
Oct 28 15:29:00 grubby kernel: [  951.019995]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.020001]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.020007]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.020012]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.020016] watchdog/3      S 00000000000=
00000     0 13872      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.020022]  ffff88022c0c7ea0 00000000000=
00046 ffff88022c0c7e30 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.020029]  ffff880206011850 ffff88022c0=
c7fd8 ffff88022c0c7fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.020035]  ffff88022ed88f60 ffff8802060=
11850 0000000000000282 0000000100000282
Oct 28 15:29:00 grubby kernel: [  951.020042] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.020048]  [<ffffffff81093541>] ? watch=
dog_enable+0x196/0x196
Oct 28 15:29:00 grubby kernel: [  951.020053]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.020058]  [<ffffffff810935a9>] watchdo=
g+0x68/0xab
Oct 28 15:29:00 grubby kernel: [  951.020063]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.020069]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.020075]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.020080]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.020084] dhclient        S 00000000000=
00000     0 14542   2907 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.020090]  ffff880204207928 00000000000=
00086 ffff8802042078d8 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.020097]  ffff88020603c770 ffff8802042=
07fd8 ffff880204207fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.020103]  ffffffff8160d020 ffff8802060=
3c770 0000000000000002 0000000100000000
Oct 28 15:29:00 grubby kernel: [  951.020110] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.020115]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.020121]  [<ffffffff8134d3b3>] schedul=
e_hrtimeout_range_clock+0xc5/0x10c
Oct 28 15:29:00 grubby kernel: [  951.020128]  [<ffffffff81064e7d>] ? updat=
e_rmtp+0x65/0x65
Oct 28 15:29:00 grubby kernel: [  951.020134]  [<ffffffff81065703>] ? hrtim=
er_start_range_ns+0xf/0x11
Oct 28 15:29:00 grubby kernel: [  951.020140]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.020145]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.020150]  [<ffffffff8110c13c>] do_sele=
ct+0x496/0x4da
Oct 28 15:29:00 grubby kernel: [  951.020155]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.020160]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020165]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020171]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.020176]  [<ffffffff81040749>] ? try_t=
o_wake_up+0x195/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.020182]  [<ffffffff81040768>] ? defau=
lt_wake_function+0xd/0xf
Oct 28 15:29:00 grubby kernel: [  951.020188]  [<ffffffff810bbe14>] ? get_p=
ageblock_flags_group+0x40/0x76
Oct 28 15:29:00 grubby kernel: [  951.020194]  [<ffffffff811aa64f>] ? cpuma=
sk_any_but+0x27/0x38
Oct 28 15:29:00 grubby kernel: [  951.020199]  [<ffffffff810321af>] ? flush=
_tlb_page+0x5a/0x78
Oct 28 15:29:00 grubby kernel: [  951.020205]  [<ffffffff8103114f>] ? ptep_=
set_access_flags+0x3e/0x4c
Oct 28 15:29:00 grubby kernel: [  951.020211]  [<ffffffff810d291c>] ? do_wp=
_page+0x259/0x55c
Oct 28 15:29:00 grubby kernel: [  951.020217]  [<ffffffff810370ea>] ? shoul=
d_resched+0x9/0x28
Oct 28 15:29:00 grubby kernel: [  951.020222]  [<ffffffff8134c780>] ? _cond=
_resched+0x9/0x1d
Oct 28 15:29:00 grubby kernel: [  951.020227]  [<ffffffff8110c2de>] core_sy=
s_select+0x15e/0x1fd
Oct 28 15:29:00 grubby kernel: [  951.020233]  [<ffffffff810d4744>] ? handl=
e_mm_fault+0x1c3/0x1d6
Oct 28 15:29:00 grubby kernel: [  951.020239]  [<ffffffff81350cbf>] ? do_pa=
ge_fault+0x328/0x367
Oct 28 15:29:00 grubby kernel: [  951.020244]  [<ffffffff81013655>] ? parav=
irt_read_tsc+0x9/0xd
Oct 28 15:29:00 grubby kernel: [  951.020250]  [<ffffffff8104ca29>] ? times=
pec_add_safe+0x32/0x61
Oct 28 15:29:00 grubby kernel: [  951.020255]  [<ffffffff810136d7>] ? read_=
tsc+0x9/0x19
Oct 28 15:29:00 grubby kernel: [  951.020260]  [<ffffffff8110c409>] sys_sel=
ect+0x8c/0xb4
Oct 28 15:29:00 grubby kernel: [  951.020266]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.020270] ssh             S 00000000000=
00000     0 14606  13324 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.020276]  ffff880203851928 00000000000=
00082 ffff880203851958 ffffffffa00104fa
Oct 28 15:29:00 grubby kernel: [  951.020283]  ffff88022ed58f20 ffff8802038=
51fd8 ffff880203851fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.020289]  ffff88022b9b4870 ffff88022ed=
58f20 ffff880203851928 ffffffff8105d5db
Oct 28 15:29:00 grubby kernel: [  951.020296] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.020314]  [<ffffffffa00104fa>] ? e1000=
_xmit_frame+0x958/0x9ad [e1000e]
Oct 28 15:29:00 grubby kernel: [  951.020321]  [<ffffffff8105d5db>] ? start=
_flush_work+0xfb/0x109
Oct 28 15:29:00 grubby kernel: [  951.020327]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.020333]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.020339]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.020344]  [<ffffffff81038c28>] ? __wak=
e_up+0x3f/0x48
Oct 28 15:29:00 grubby kernel: [  951.020350]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.020355]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.020360]  [<ffffffff8110c13c>] do_sele=
ct+0x496/0x4da
Oct 28 15:29:00 grubby kernel: [  951.020366]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.020371]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020376]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020380]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020386]  [<ffffffff81037e9e>] ? test_=
tsk_need_resched+0xe/0x18
Oct 28 15:29:00 grubby kernel: [  951.020392]  [<ffffffff8103be78>] ? check=
_preempt_curr+0x57/0x66
Oct 28 15:29:00 grubby kernel: [  951.020397]  [<ffffffff8103beda>] ? ttwu_=
do_wakeup+0x53/0xc9
Oct 28 15:29:00 grubby kernel: [  951.020403]  [<ffffffff81037e9e>] ? test_=
tsk_need_resched+0xe/0x18
Oct 28 15:29:00 grubby kernel: [  951.020409]  [<ffffffff8103be78>] ? check=
_preempt_curr+0x57/0x66
Oct 28 15:29:00 grubby kernel: [  951.020414]  [<ffffffff8103beda>] ? ttwu_=
do_wakeup+0x53/0xc9
Oct 28 15:29:00 grubby kernel: [  951.020420]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.020426]  [<ffffffff81040749>] ? try_t=
o_wake_up+0x195/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.020432]  [<ffffffff81040768>] ? defau=
lt_wake_function+0xd/0xf
Oct 28 15:29:00 grubby kernel: [  951.020437]  [<ffffffff81036cf4>] ? __wak=
e_up_common+0x48/0x7e
Oct 28 15:29:00 grubby kernel: [  951.020443]  [<ffffffff810370ea>] ? shoul=
d_resched+0x9/0x28
Oct 28 15:29:00 grubby kernel: [  951.020448]  [<ffffffff8134c780>] ? _cond=
_resched+0x9/0x1d
Oct 28 15:29:00 grubby kernel: [  951.020454]  [<ffffffff8110c2de>] core_sy=
s_select+0x15e/0x1fd
Oct 28 15:29:00 grubby kernel: [  951.020460]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.020466]  [<ffffffff81129ee0>] ? fsnot=
ify+0x20b/0x22e
Oct 28 15:29:00 grubby kernel: [  951.020471]  [<ffffffff8110c409>] sys_sel=
ect+0x8c/0xb4
Oct 28 15:29:00 grubby kernel: [  951.020477]  [<ffffffff810fdaab>] ? sys_w=
rite+0x5c/0x69
Oct 28 15:29:00 grubby kernel: [  951.020483]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.020487] firefox-bin     S 00000000000=
00000     0 14617      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.020493]  ffff880206023a48 00000000000=
00086 0000000000000000 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.020499]  ffff88022ecc7550 ffff8802060=
23fd8 ffff880206023fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.020506]  ffff88022ed88f60 ffff88022ec=
c7550 0000000000000000 000000013bd15da8
Oct 28 15:29:00 grubby kernel: [  951.020513] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.020518]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.020524]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.020530]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.020536]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.020542]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.020548]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.020553]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.020558]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.020563]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.020568]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020572]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020577]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020581]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020586]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020591]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020595]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020600]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020604]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020610]  [<ffffffff811695fe>] ? secur=
ity_file_permission+0x29/0x2e
Oct 28 15:29:00 grubby kernel: [  951.020616]  [<ffffffff810fd633>] ? rw_ve=
rify_area+0xab/0xc8
Oct 28 15:29:00 grubby kernel: [  951.020621]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.020627]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.020631] firefox-bin     S 00000000000=
00000     0 14622      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.020637]  ffff88020430fa48 00000000000=
00086 ffff88020430fa08 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.020644]  ffff88022d597850 ffff8802043=
0ffd8 ffff88020430ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.020650]  ffff88022ed59610 ffff88022d5=
97850 ffff88020430fa28 000000018110d563
Oct 28 15:29:00 grubby kernel: [  951.020657] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.020662]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.020668]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.020674]  [<ffffffff81113fbd>] ? mntpu=
t_no_expire+0x27/0xd0
Oct 28 15:29:00 grubby kernel: [  951.020679]  [<ffffffff81114087>] ? mntpu=
t+0x21/0x23
Oct 28 15:29:00 grubby kernel: [  951.020684]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.020690]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.020696]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.020701]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.020706]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.020711]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.020716]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.020723]  [<ffffffff811ae2e0>] ? radix=
_tree_lookup_slot+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.020728]  [<ffffffff810b6e31>] ? find_=
get_page+0x43/0x65
Oct 28 15:29:00 grubby kernel: [  951.020734]  [<ffffffff810370ea>] ? shoul=
d_resched+0x9/0x28
Oct 28 15:29:00 grubby kernel: [  951.020739]  [<ffffffff8134c780>] ? _cond=
_resched+0x9/0x1d
Oct 28 15:29:00 grubby kernel: [  951.020745]  [<ffffffff810b8dc1>] ? filem=
ap_fault+0x1ea/0x346
Oct 28 15:29:00 grubby kernel: [  951.020750]  [<ffffffff810b6fd1>] ? unloc=
k_page+0x22/0x26
Oct 28 15:29:00 grubby kernel: [  951.020755]  [<ffffffff810d1b91>] ? __do_=
fault+0x356/0x390
Oct 28 15:29:00 grubby kernel: [  951.020761]  [<ffffffff810d3eee>] ? handl=
e_pte_fault+0x2a2/0x799
Oct 28 15:29:00 grubby kernel: [  951.020767]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.020772]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.020777]  [<ffffffff8110d563>] ? __d_f=
ree+0x4e/0x53
Oct 28 15:29:00 grubby kernel: [  951.020782]  [<ffffffff8110db15>] ? d_fre=
e+0x3e/0x50
Oct 28 15:29:00 grubby kernel: [  951.020787]  [<ffffffff8110dc4a>] ? dentr=
y_kill+0x123/0x12f
Oct 28 15:29:00 grubby kernel: [  951.020792]  [<ffffffff81113fbd>] ? mntpu=
t_no_expire+0x27/0xd0
Oct 28 15:29:00 grubby kernel: [  951.020796]  [<ffffffff81114087>] ? mntpu=
t+0x21/0x23
Oct 28 15:29:00 grubby kernel: [  951.020802]  [<ffffffff810febf1>] ? fput+=
0x192/0x1a1
Oct 28 15:29:00 grubby kernel: [  951.020807]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.020812]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.020816] firefox-bin     S ffff88022c8=
5b400     0 14623      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.020823]  ffff88022ecb5df8 00000000000=
00086 0000000000001000 ffff8801f475f800
Oct 28 15:29:00 grubby kernel: [  951.020830]  ffff88020389ef20 ffff88022ec=
b5fd8 ffff88022ecb5fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.020836]  ffff88022ecc7550 ffff8802038=
9ef20 0000001000000000 ffff88022ecb5dd0
Oct 28 15:29:00 grubby kernel: [  951.020843] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.020849]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.020854]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.020861]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.020867]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.020873]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.020879]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.020884]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.020890]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.020896]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.020900] firefox-bin     S 00000000000=
00000     0 14624      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.020906]  ffff88020614dc58 00000000000=
00086 ffff88020614dc38 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.020913]  ffff88020389e140 ffff8802061=
4dfd8 ffff88020614dfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.020920]  ffff88022ed88f60 ffff8802038=
9e140 ffff88023bffbe00 000000010614dc48
Oct 28 15:29:00 grubby kernel: [  951.020926] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.020932]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.020938]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.020943]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.020948]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.020954]  [<ffffffff8107192f>] ? futex=
_wake+0xf9/0x10b
Oct 28 15:29:00 grubby kernel: [  951.020960]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.020966]  [<ffffffff810d1e97>] ? tlb_f=
inish_mmu+0x1f/0x34
Oct 28 15:29:00 grubby kernel: [  951.020972]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.020978]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.020982] firefox-bin     S 00000000000=
00000     0 14625      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.020988]  ffff88020423fc58 00000000000=
00086 ffff88020423fc58 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.020995]  ffff88022bab9810 ffff8802042=
3ffd8 ffff88020423ffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021001]  ffff88022ed59610 ffff88022ba=
b9810 ffff88020423fc68 0000000100000286
Oct 28 15:29:00 grubby kernel: [  951.021008] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.021013]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.021019]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.021024]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.021030]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.021036]  [<ffffffff81064e7d>] ? updat=
e_rmtp+0x65/0x65
Oct 28 15:29:00 grubby kernel: [  951.021042]  [<ffffffff81065703>] ? hrtim=
er_start_range_ns+0xf/0x11
Oct 28 15:29:00 grubby kernel: [  951.021048]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.021053]  [<ffffffff81129ee0>] ? fsnot=
ify+0x20b/0x22e
Oct 28 15:29:00 grubby kernel: [  951.021059]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.021065]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021069] firefox-bin     S 00000000000=
00000     0 14626      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.021075]  ffff8802041f9a48 00000000000=
00086 0000000000000000 0000000000000800
Oct 28 15:29:00 grubby kernel: [  951.021082]  ffff88022bab9120 ffff8802041=
f9fd8 ffff8802041f9fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021089]  ffff88022ecb6040 ffff88022ba=
b9120 ffff8802041f9a28 ffffffff811bea61
Oct 28 15:29:00 grubby kernel: [  951.021095] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.021103]  [<ffffffff811bea61>] ? swiot=
lb_dma_mapping_error+0x15/0x23
Oct 28 15:29:00 grubby kernel: [  951.021109]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.021114]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.021121]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021127]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.021133]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.021138]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.021143]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.021148]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.021152]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.021160]  [<ffffffff812b5710>] ? ip_fi=
nish_output2+0x1bb/0x1f8
Oct 28 15:29:00 grubby kernel: [  951.021166]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021172]  [<ffffffff8134db73>] ? _raw_=
spin_lock_irqsave+0xd/0x2a
Oct 28 15:29:00 grubby kernel: [  951.021178]  [<ffffffff8105476d>] ? lock_=
timer_base.isra.29+0x26/0x4b
Oct 28 15:29:00 grubby kernel: [  951.021184]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.021189]  [<ffffffff81054a40>] ? __mod=
_timer+0x137/0x149
Oct 28 15:29:00 grubby kernel: [  951.021195]  [<ffffffff81054b5b>] ? mod_t=
imer+0x8b/0x92
Oct 28 15:29:00 grubby kernel: [  951.021201]  [<ffffffff812c4455>] ? tcp_i=
nit_cwnd+0x20/0x39
Oct 28 15:29:00 grubby kernel: [  951.021206]  [<ffffffff812c6f42>] ? tcp_c=
wnd_application_limited+0x37/0x8d
Oct 28 15:29:00 grubby kernel: [  951.021212]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.021217]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.021222]  [<ffffffff8110d563>] ? __d_f=
ree+0x4e/0x53
Oct 28 15:29:00 grubby kernel: [  951.021227]  [<ffffffff8110db15>] ? d_fre=
e+0x3e/0x50
Oct 28 15:29:00 grubby kernel: [  951.021232]  [<ffffffff8110dc4a>] ? dentr=
y_kill+0x123/0x12f
Oct 28 15:29:00 grubby kernel: [  951.021237]  [<ffffffff81113fbd>] ? mntpu=
t_no_expire+0x27/0xd0
Oct 28 15:29:00 grubby kernel: [  951.021241]  [<ffffffff81114087>] ? mntpu=
t+0x21/0x23
Oct 28 15:29:00 grubby kernel: [  951.021247]  [<ffffffff810febf1>] ? fput+=
0x192/0x1a1
Oct 28 15:29:00 grubby kernel: [  951.021252]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.021257]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021261] firefox-bin     S 00000000000=
00000     0 14627      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.021268]  ffff8802063ffc58 00000000000=
00086 0000001f00000002 ffff8802063ffc08
Oct 28 15:29:00 grubby kernel: [  951.021274]  ffff88022d756af0 ffff8802063=
fffd8 ffff8802063fffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021281]  ffff88022ed59610 ffff88022d7=
56af0 ffff8802063ffcd8 ffff8802063ffc48
Oct 28 15:29:00 grubby kernel: [  951.021288] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.021293]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.021299]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.021304]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.021310]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.021316]  [<ffffffff81070baf>] ? wake_=
futex+0x3d/0x42
Oct 28 15:29:00 grubby kernel: [  951.021321]  [<ffffffff8107192f>] ? futex=
_wake+0xf9/0x10b
Oct 28 15:29:00 grubby kernel: [  951.021327]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.021333]  [<ffffffff810d371f>] ? zap_p=
age_range+0xab/0xbf
Oct 28 15:29:00 grubby kernel: [  951.021339]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.021345]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021349] firefox-bin     S 00000000000=
00000     0 14628      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.021355]  ffff8802042adc58 00000000000=
00086 ffff8802042adc58 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.021362]  ffff88022d2beee0 ffff8802042=
adfd8 ffff8802042adfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021368]  ffff88022ed88f60 ffff88022d2=
beee0 ffff8802042adc48 0000000100000286
Oct 28 15:29:00 grubby kernel: [  951.021375] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.021381]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.021386]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.021391]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.021397]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.021404]  [<ffffffff81064e7d>] ? updat=
e_rmtp+0x65/0x65
Oct 28 15:29:00 grubby kernel: [  951.021410]  [<ffffffff81065703>] ? hrtim=
er_start_range_ns+0xf/0x11
Oct 28 15:29:00 grubby kernel: [  951.021416]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.021421]  [<ffffffff81038d90>] ? set_n=
ext_entity+0x3a/0x5f
Oct 28 15:29:00 grubby kernel: [  951.021427]  [<ffffffff8100d6fc>] ? __swi=
tch_to+0x141/0x220
Oct 28 15:29:00 grubby kernel: [  951.021432]  [<ffffffff8103a87e>] ? finis=
h_task_switch+0x8b/0xb6
Oct 28 15:29:00 grubby kernel: [  951.021438]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.021444]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021448] firefox-bin     S 00000000000=
00000     0 14629      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.021454]  ffff8802038b5c58 00000000000=
00086 ffff88022bab9120 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.021461]  ffff88022d2be100 ffff8802038=
b5fd8 ffff8802038b5fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021467]  ffff88022ed88f60 ffff88022d2=
be100 ffff8802038b5c68 00000001038b5c48
Oct 28 15:29:00 grubby kernel: [  951.021474] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.021479]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.021485]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.021490]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.021496]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.021503]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.021508]  [<ffffffff81129ee0>] ? fsnot=
ify+0x20b/0x22e
Oct 28 15:29:00 grubby kernel: [  951.021514]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.021519]  [<ffffffff810fd063>] ? fput_=
light+0xd/0xf
Oct 28 15:29:00 grubby kernel: [  951.021525]  [<ffffffff810fdaab>] ? sys_w=
rite+0x5c/0x69
Oct 28 15:29:00 grubby kernel: [  951.021530]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021534] firefox-bin     S 00000000000=
00000     0 14630      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.021540]  ffff88021ef65c58 00000000000=
00086 0000000000000000 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.021547]  ffff88022c4b6830 ffff88021ef=
65fd8 ffff88021ef65fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021553]  ffff88022ed160c0 ffff88022c4=
b6830 0000000000000000 000000011ef65c48
Oct 28 15:29:00 grubby kernel: [  951.021560] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.021565]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.021571]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.021576]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.021582]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.021589]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.021595]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.021600]  [<ffffffff8103a87e>] ? finis=
h_task_switch+0x8b/0xb6
Oct 28 15:29:00 grubby kernel: [  951.021606]  [<ffffffff81043229>] ? sched=
ule_tail+0x22/0x67
Oct 28 15:29:00 grubby kernel: [  951.021612]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021616] firefox-bin     S 00000000000=
00000     0 14631      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.021622]  ffff88022c655c58 00000000000=
00086 ffffffff810f5d81 ffffea0000000000
Oct 28 15:29:00 grubby kernel: [  951.021629]  ffff88022cbfae60 ffff88022c6=
55fd8 ffff88022c655fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021635]  ffffffff8160d020 ffff88022cb=
fae60 ffff88022cbfae60 000000012c655c48
Oct 28 15:29:00 grubby kernel: [  951.021642] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.021648]  [<ffffffff810f5d81>] ? fatal=
_signal_pending+0xd/0x24
Oct 28 15:29:00 grubby kernel: [  951.021654]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.021659]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.021665]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.021670]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.021677]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.021682]  [<ffffffff81129ee0>] ? fsnot=
ify+0x20b/0x22e
Oct 28 15:29:00 grubby kernel: [  951.021688]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.021694]  [<ffffffff810fd063>] ? fput_=
light+0xd/0xf
Oct 28 15:29:00 grubby kernel: [  951.021699]  [<ffffffff810fdaab>] ? sys_w=
rite+0x5c/0x69
Oct 28 15:29:00 grubby kernel: [  951.021704]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021708] firefox-bin     S 00000000000=
00000     0 14633      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.021714]  ffff88022ecc9c58 00000000000=
00086 ffffffff810f5d81 ffffea0000000000
Oct 28 15:29:00 grubby kernel: [  951.021721]  ffff88022d06ce60 ffff88022ec=
c9fd8 ffff88022ecc9fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021728]  ffff88022ed160c0 ffff88022d0=
6ce60 ffff88022ecc9cd8 000000012ecc9c48
Oct 28 15:29:00 grubby kernel: [  951.021734] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.021740]  [<ffffffff810f5d81>] ? fatal=
_signal_pending+0xd/0x24
Oct 28 15:29:00 grubby kernel: [  951.021746]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.021751]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.021757]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.021762]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.021768]  [<ffffffff8107192f>] ? futex=
_wake+0xf9/0x10b
Oct 28 15:29:00 grubby kernel: [  951.021774]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.021779]  [<ffffffff81129ee0>] ? fsnot=
ify+0x20b/0x22e
Oct 28 15:29:00 grubby kernel: [  951.021785]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.021791]  [<ffffffff810fd063>] ? fput_=
light+0xd/0xf
Oct 28 15:29:00 grubby kernel: [  951.021796]  [<ffffffff810fdaab>] ? sys_w=
rite+0x5c/0x69
Oct 28 15:29:00 grubby kernel: [  951.021802]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021806] firefox-bin     S 00000000000=
00000     0 14656      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.021812]  ffff880225edfc58 00000000000=
00086 ffff880225edfbe8 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.021818]  ffff88022c59d6d0 ffff880225e=
dffd8 ffff880225edffd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021825]  ffff88022ed88f60 ffff88022c5=
9d6d0 ffff88023bfba268 ffff880225edfc48
Oct 28 15:29:00 grubby kernel: [  951.021832] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.021837]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.021843]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.021848]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.021854]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.021860]  [<ffffffff8107192f>] ? futex=
_wake+0xf9/0x10b
Oct 28 15:29:00 grubby kernel: [  951.021866]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.021872]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.021877]  [<ffffffff810fd063>] ? fput_=
light+0xd/0xf
Oct 28 15:29:00 grubby kernel: [  951.021882]  [<ffffffff810fda42>] ? sys_r=
ead+0x5c/0x69
Oct 28 15:29:00 grubby kernel: [  951.021888]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021892] firefox-bin     S ffff88022c4=
40b80     0 14659      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.021898]  ffff8802133f1c58 00000000000=
00086 ffffffff810f5d81 ffffea0000000000
Oct 28 15:29:00 grubby kernel: [  951.021905]  ffff88022ca589b0 ffff8802133=
f1fd8 ffff8802133f1fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021912]  ffff88022d76eea0 ffff88022ca=
589b0 ffff8802133f1cd8 ffff8802133f1c48
Oct 28 15:29:00 grubby kernel: [  951.021918] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.021924]  [<ffffffff810f5d81>] ? fatal=
_signal_pending+0xd/0x24
Oct 28 15:29:00 grubby kernel: [  951.021930]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.021936]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.021941]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.021946]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.021953]  [<ffffffff8107192f>] ? futex=
_wake+0xf9/0x10b
Oct 28 15:29:00 grubby kernel: [  951.021959]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.021964]  [<ffffffff8103a87e>] ? finis=
h_task_switch+0x8b/0xb6
Oct 28 15:29:00 grubby kernel: [  951.021970]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.021976]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.021980] firefox-bin     S 00000000000=
00000     0 14660      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.021986]  ffff88022e37bc58 00000000000=
00086 0000000000000000 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.021993]  ffff88022dbac8f0 ffff88022e3=
7bfd8 ffff88022e37bfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.021999]  ffffffff8160d020 ffff88022db=
ac8f0 ffff88022e37bcd8 000000012e37bc48
Oct 28 15:29:00 grubby kernel: [  951.022006] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022012]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.022017]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022022]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.022028]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.022034]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.022040]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.022046]  [<ffffffff811340be>] ? fcntl=
_setlk+0x29d/0x2b2
Oct 28 15:29:00 grubby kernel: [  951.022052]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.022058]  [<ffffffff8110a4aa>] ? sys_f=
cntl+0x4a7/0x4b9
Oct 28 15:29:00 grubby kernel: [  951.022064]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022068] firefox-bin     S 00000000000=
00000     0 14661      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.022073]  ffff88020406dc58 00000000000=
00086 0000000000000001 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.022080]  ffff88022dbac200 ffff8802040=
6dfd8 ffff88020406dfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.022087]  ffff88022ed160c0 ffff88022db=
ac200 0000000000000010 000000010406dc48
Oct 28 15:29:00 grubby kernel: [  951.022093] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022099]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.022105]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022110]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.022115]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.022121]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.022126]  [<ffffffff81132a1c>] ? locks=
_free_lock+0x41/0x45
Oct 28 15:29:00 grubby kernel: [  951.022132]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.022137]  [<ffffffff811340be>] ? fcntl=
_setlk+0x29d/0x2b2
Oct 28 15:29:00 grubby kernel: [  951.022143]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.022149]  [<ffffffff8110a4aa>] ? sys_f=
cntl+0x4a7/0x4b9
Oct 28 15:29:00 grubby kernel: [  951.022155]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022159] firefox-bin     S 00000000000=
00000     0 14662      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.022165]  ffff880204009c58 00000000000=
00086 0000000000000000 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.022172]  ffff88022d76e7b0 ffff8802040=
09fd8 ffff880204009fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.022178]  ffff88022ed160c0 ffff88022d7=
6e7b0 ffffea0006ca26d0 0000000104009c48
Oct 28 15:29:00 grubby kernel: [  951.022185] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022190]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.022196]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022201]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.022207]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.022214]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.022219]  [<ffffffff81129ee0>] ? fsnot=
ify+0x20b/0x22e
Oct 28 15:29:00 grubby kernel: [  951.022225]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.022230]  [<ffffffff810fd063>] ? fput_=
light+0xd/0xf
Oct 28 15:29:00 grubby kernel: [  951.022236]  [<ffffffff810fdaab>] ? sys_w=
rite+0x5c/0x69
Oct 28 15:29:00 grubby kernel: [  951.022241]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022245] firefox-bin     S 00000000000=
00000     0 14663      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.022251]  ffff880221603c58 00000000000=
00086 ffff880221603c58 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.022258]  ffff88022c640280 ffff8802216=
03fd8 ffff880221603fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.022265]  ffff88022ed160c0 ffff88022c6=
40280 ffff880221603c68 0000000100000286
Oct 28 15:29:00 grubby kernel: [  951.022271] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022277]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.022282]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022288]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.022293]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.022300]  [<ffffffff81064e7d>] ? updat=
e_rmtp+0x65/0x65
Oct 28 15:29:00 grubby kernel: [  951.022306]  [<ffffffff81065703>] ? hrtim=
er_start_range_ns+0xf/0x11
Oct 28 15:29:00 grubby kernel: [  951.022312]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.022317]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.022322]  [<ffffffff81129ee0>] ? fsnot=
ify+0x20b/0x22e
Oct 28 15:29:00 grubby kernel: [  951.022328]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.022334]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022338] firefox-bin     S ffff88022c8=
5b400     0 14664      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.022344]  ffff88022d40dc58 00000000000=
00086 0000000000000000 0000000000000276
Oct 28 15:29:00 grubby kernel: [  951.022351]  ffff88022c641060 ffff88022d4=
0dfd8 ffff88022d40dfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.022357]  ffff88022ecc7550 ffff88022c6=
41060 ffffea0006803190 ffff88022d40dc48
Oct 28 15:29:00 grubby kernel: [  951.022364] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022370]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.022375]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022381]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.022386]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.022392]  [<ffffffff8107192f>] ? futex=
_wake+0xf9/0x10b
Oct 28 15:29:00 grubby kernel: [  951.022398]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.022403]  [<ffffffff81129ee0>] ? fsnot=
ify+0x20b/0x22e
Oct 28 15:29:00 grubby kernel: [  951.022409]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.022415]  [<ffffffff810fd063>] ? fput_=
light+0xd/0xf
Oct 28 15:29:00 grubby kernel: [  951.022420]  [<ffffffff810fdaab>] ? sys_w=
rite+0x5c/0x69
Oct 28 15:29:00 grubby kernel: [  951.022426]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022430] firefox-bin     S 00000000000=
00000     0 14665      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.022435]  ffff88020616dc58 00000000000=
00086 ffff88022ecc7550 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.022442]  ffff88022d21f160 ffff8802061=
6dfd8 ffff88020616dfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.022449]  ffffffff8160d020 ffff88022d2=
1f160 ffff88020616dc68 000000010616dc48
Oct 28 15:29:00 grubby kernel: [  951.022456] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022461]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.022467]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022472]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.022477]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.022484]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.022489]  [<ffffffff81129ee0>] ? fsnot=
ify+0x20b/0x22e
Oct 28 15:29:00 grubby kernel: [  951.022495]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.022501]  [<ffffffff810fd063>] ? fput_=
light+0xd/0xf
Oct 28 15:29:00 grubby kernel: [  951.022506]  [<ffffffff810fdaab>] ? sys_w=
rite+0x5c/0x69
Oct 28 15:29:00 grubby kernel: [  951.022512]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022515] firefox-bin     S 00000000000=
00000     0 14668      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.022521]  ffff8802062b9c58 00000000000=
00086 ffffffff810f5d81 ffffea0000000000
Oct 28 15:29:00 grubby kernel: [  951.022528]  ffff88022c59cfe0 ffff8802062=
b9fd8 ffff8802062b9fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.022535]  ffff88022ed160c0 ffff88022c5=
9cfe0 ffff88022c59cfe0 00000001062b9c48
Oct 28 15:29:00 grubby kernel: [  951.022542] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022547]  [<ffffffff810f5d81>] ? fatal=
_signal_pending+0xd/0x24
Oct 28 15:29:00 grubby kernel: [  951.022553]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.022559]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022564]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.022570]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.022575]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.022581]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.022587]  [<ffffffff811340be>] ? fcntl=
_setlk+0x29d/0x2b2
Oct 28 15:29:00 grubby kernel: [  951.022593]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.022598]  [<ffffffff8110a4aa>] ? sys_f=
cntl+0x4a7/0x4b9
Oct 28 15:29:00 grubby kernel: [  951.022604]  [<ffffffff810fda42>] ? sys_r=
ead+0x5c/0x69
Oct 28 15:29:00 grubby kernel: [  951.022609]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022614] firefox-bin     S 00000000000=
00000     0 14674      1 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.022620]  ffff8802063a1c58 00000000000=
00086 ffff8802063a1c58 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.022626]  ffff88022d75f510 ffff8802063=
a1fd8 ffff8802063a1fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.022633]  ffff88022ed88f60 ffff88022d7=
5f510 ffff8802063a1c68 0000000100000286
Oct 28 15:29:00 grubby kernel: [  951.022640] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022645]  [<ffffffff81070996>] ? get_f=
utex_value_locked+0x2f/0x3e
Oct 28 15:29:00 grubby kernel: [  951.022651]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022656]  [<ffffffff81070ae8>] futex_w=
ait_queue_me+0xbf/0xdb
Oct 28 15:29:00 grubby kernel: [  951.022662]  [<ffffffff810716a6>] futex_w=
ait+0x11d/0x270
Oct 28 15:29:00 grubby kernel: [  951.022668]  [<ffffffff81064e7d>] ? updat=
e_rmtp+0x65/0x65
Oct 28 15:29:00 grubby kernel: [  951.022674]  [<ffffffff81065703>] ? hrtim=
er_start_range_ns+0xf/0x11
Oct 28 15:29:00 grubby kernel: [  951.022680]  [<ffffffff81072a5e>] do_fute=
x+0x95/0x861
Oct 28 15:29:00 grubby kernel: [  951.022685]  [<ffffffff810edfef>] ? kmem_=
cache_free+0x30/0x6f
Oct 28 15:29:00 grubby kernel: [  951.022690]  [<ffffffff81129ee0>] ? fsnot=
ify+0x20b/0x22e
Oct 28 15:29:00 grubby kernel: [  951.022696]  [<ffffffff81073359>] sys_fut=
ex+0x12f/0x13e
Oct 28 15:29:00 grubby kernel: [  951.022702]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022706] plugin-containe S ffff88022cb=
177c0     0 14682  14623 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.022713]  ffff880225ea9a48 00000000000=
00082 ffff88022c41f400 ffff880200000000
Oct 28 15:29:00 grubby kernel: [  951.022720]  ffff88022ed167b0 ffff880225e=
a9fd8 ffff880225ea9fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.022726]  ffff88022c641750 ffff88022ed=
167b0 ffff880225ea9a20 0000000126e36e10
Oct 28 15:29:00 grubby kernel: [  951.022733] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022739]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022744]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.022751]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022756]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022762]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.022768]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.022773]  [<ffffffff8110b96a>] poll_sc=
hedule_timeout+0x43/0x5f
Oct 28 15:29:00 grubby kernel: [  951.022778]  [<ffffffff8110c8b9>] do_sys_=
poll+0x2f2/0x384
Oct 28 15:29:00 grubby kernel: [  951.022783]  [<ffffffff8110ba2b>] ? poll_=
freewait+0xa5/0xa5
Oct 28 15:29:00 grubby kernel: [  951.022788]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.022793]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.022797]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.022802]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.022807]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.022811]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.022816]  [<ffffffff8110baf2>] ? __pol=
lwait+0xc7/0xc7
Oct 28 15:29:00 grubby kernel: [  951.022822]  [<ffffffff8127a243>] ? sock_=
aio_read+0x21/0x23
Oct 28 15:29:00 grubby kernel: [  951.022828]  [<ffffffff811695fe>] ? secur=
ity_file_permission+0x29/0x2e
Oct 28 15:29:00 grubby kernel: [  951.022833]  [<ffffffff810fd633>] ? rw_ve=
rify_area+0xab/0xc8
Oct 28 15:29:00 grubby kernel: [  951.022839]  [<ffffffff8110c9e4>] sys_pol=
l+0x4c/0xb6
Oct 28 15:29:00 grubby kernel: [  951.022844]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022848] plugin-containe S ffff88022c8=
5b400     0 14683  14623 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.022854]  ffff880203807df8 00000000000=
00082 ffff880203807f08 ffffffff8127969c
Oct 28 15:29:00 grubby kernel: [  951.022861]  ffff88022c092e20 ffff8802038=
07fd8 ffff880203807fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.022868]  ffff88020389ef20 ffff88022c0=
92e20 ffff880204337140 0000000000000000
Oct 28 15:29:00 grubby kernel: [  951.022875] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022879]  [<ffffffff8127969c>] ? __sys=
_sendmsg+0x20e/0x2b5
Oct 28 15:29:00 grubby kernel: [  951.022885]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022891]  [<ffffffff8134d339>] schedul=
e_hrtimeout_range_clock+0x4b/0x10c
Oct 28 15:29:00 grubby kernel: [  951.022897]  [<ffffffff810748a7>] ? arch_=
local_irq_save+0x15/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022903]  [<ffffffff8134dbbb>] ? _raw_=
spin_unlock_irqrestore+0x12/0x14
Oct 28 15:29:00 grubby kernel: [  951.022909]  [<ffffffff8112dbdf>] ? ep_sc=
an_ready_list+0x14a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.022915]  [<ffffffff8134d408>] schedul=
e_hrtimeout_range+0xe/0x10
Oct 28 15:29:00 grubby kernel: [  951.022921]  [<ffffffff8112e504>] sys_epo=
ll_wait+0x1c4/0x312
Oct 28 15:29:00 grubby kernel: [  951.022927]  [<ffffffff8104075b>] ? try_t=
o_wake_up+0x1a7/0x1a7
Oct 28 15:29:00 grubby kernel: [  951.022933]  [<ffffffff81352ed2>] system_=
call_fastpath+0x16/0x1b
Oct 28 15:29:00 grubby kernel: [  951.022937] kworker/u:0     S 00000000000=
00000     0 14740      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.022943]  ffff8802040c7e90 00000000000=
00046 ffff8802040c7e40 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.022950]  ffff88022c301020 ffff8802040=
c7fd8 ffff8802040c7fd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.022957]  ffff88022ed160c0 ffff88022c3=
01020 ffff8802040c7e60 0000000100000000
Oct 28 15:29:00 grubby kernel: [  951.022963] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.022969]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.022975]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.022981]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.022986]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.022992]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.022998]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.023004]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.023007] kworker/0:1     S 00000000000=
00000     0 14751      2 0x00000000
Oct 28 15:29:00 grubby kernel: [  951.023013]  ffff88021304de90 00000000000=
00046 ffff88021304de40 ffffffff00000000
Oct 28 15:29:00 grubby kernel: [  951.023020]  ffff88022daac100 ffff8802130=
4dfd8 ffff88021304dfd8 0000000000012f40
Oct 28 15:29:00 grubby kernel: [  951.023027]  ffffffff8160d020 ffff88022da=
ac100 ffff88021304de60 0000000100000000
Oct 28 15:29:00 grubby kernel: [  951.023034] Call Trace:
Oct 28 15:29:00 grubby kernel: [  951.023039]  [<ffffffff8134c996>] schedul=
e+0x55/0x57
Oct 28 15:29:00 grubby kernel: [  951.023045]  [<ffffffff8105edce>] worker_=
thread+0x14d/0x152
Oct 28 15:29:00 grubby kernel: [  951.023051]  [<ffffffff8105ec81>] ? manag=
e_workers.isra.23+0x16a/0x16a
Oct 28 15:29:00 grubby kernel: [  951.023056]  [<ffffffff81061f6c>] kthread=
+0x7f/0x87
Oct 28 15:29:00 grubby kernel: [  951.023062]  [<ffffffff81355034>] kernel_=
thread_helper+0x4/0x10
Oct 28 15:29:00 grubby kernel: [  951.023068]  [<ffffffff81061eed>] ? kthre=
ad_worker_fn+0x141/0x141
Oct 28 15:29:00 grubby kernel: [  951.023074]  [<ffffffff81355030>] ? gs_ch=
ange+0x13/0x13
Oct 28 15:29:00 grubby kernel: [  951.023079] Sched Debug Version: v0.10, 3=
=2E1.0 #7
Oct 28 15:29:00 grubby kernel: [  951.023083] ktime                        =
           : 953191.627071
Oct 28 15:29:00 grubby kernel: [  951.023086] sched_clk                    =
           : 951023.077765
Oct 28 15:29:00 grubby kernel: [  951.023090] cpu_clk                      =
           : 951023.077837
Oct 28 15:29:00 grubby kernel: [  951.023093] jiffies                      =
           : 4295130593
Oct 28 15:29:00 grubby kernel: [  951.023096] sched_clock_stable           =
           : 1
Oct 28 15:29:00 grubby kernel: [  951.023098]=20
Oct 28 15:29:00 grubby kernel: [  951.023100] sysctl_sched
Oct 28 15:29:00 grubby kernel: [  951.023103]   .sysctl_sched_latency      =
              : 18.000000
Oct 28 15:29:00 grubby kernel: [  951.023106]   .sysctl_sched_min_granulari=
ty            : 2.250000
Oct 28 15:29:00 grubby kernel: [  951.023110]   .sysctl_sched_wakeup_granul=
arity         : 3.000000
Oct 28 15:29:00 grubby kernel: [  951.023113]   .sysctl_sched_child_runs_fi=
rst           : 0
Oct 28 15:29:00 grubby kernel: [  951.023116]   .sysctl_sched_features     =
              : 15471
Oct 28 15:29:00 grubby kernel: [  951.023119]   .sysctl_sched_tunable_scali=
ng            : 1 (logaritmic)
Oct 28 15:29:00 grubby kernel: [  951.023123]=20
Oct 28 15:29:00 grubby kernel: [  951.023125] cpu#0, 2660.337 MHz
Oct 28 15:29:00 grubby kernel: [  951.023127]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023130]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023133]   .nr_switches               =
    : 1134885
Oct 28 15:29:00 grubby kernel: [  951.023136]   .nr_load_updates           =
    : 45238
Oct 28 15:29:00 grubby kernel: [  951.023139]   .nr_uninterruptible        =
    : -212
Oct 28 15:29:00 grubby kernel: [  951.023142]   .next_balance              =
    : 4295.130548
Oct 28 15:29:00 grubby kernel: [  951.023145]   .curr->pid                 =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023148]   .clock                     =
    : 950963.704300
Oct 28 15:29:00 grubby kernel: [  951.023151]   .cpu_load[0]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023154]   .cpu_load[1]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023156]   .cpu_load[2]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023159]   .cpu_load[3]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023161]   .cpu_load[4]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023165]=20
Oct 28 15:29:00 grubby kernel: [  951.023166] cfs_rq[0]:/
Oct 28 15:29:00 grubby kernel: [  951.023169]   .exec_clock                =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023172]   .MIN_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023175]   .min_vruntime              =
    : 60512.028369
Oct 28 15:29:00 grubby kernel: [  951.023179]   .max_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023182]   .spread                    =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023185]   .spread0                   =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023188]   .nr_spread_over            =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023190]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023193]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023196]   .load_avg                  =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023199]   .load_period               =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023202]   .load_contrib              =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023204]   .load_tg                   =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023207]=20
Oct 28 15:29:00 grubby kernel: [  951.023208] rt_rq[0]:
Oct 28 15:29:00 grubby kernel: [  951.023211]   .rt_nr_running             =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023213]   .rt_throttled              =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023216]   .rt_time                   =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023219]   .rt_runtime                =
    : 950.000000
Oct 28 15:29:00 grubby kernel: [  951.023223]=20
Oct 28 15:29:00 grubby kernel: [  951.023224] runnable tasks:
Oct 28 15:29:00 grubby kernel: [  951.023225]             task   PID       =
  tree-key  switches  prio     exec-runtime         sum-exec        sum-sle=
ep
Oct 28 15:29:00 grubby kernel: [  951.023228] -----------------------------=
---------------------------------------------------------------------------=
--
Oct 28 15:29:00 grubby kernel: [  951.023255]=20
Oct 28 15:29:00 grubby kernel: [  951.023256] cpu#1, 2660.337 MHz
Oct 28 15:29:00 grubby kernel: [  951.023259]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023262]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023265]   .nr_switches               =
    : 476304
Oct 28 15:29:00 grubby kernel: [  951.023268]   .nr_load_updates           =
    : 33772
Oct 28 15:29:00 grubby kernel: [  951.023270]   .nr_uninterruptible        =
    : 105
Oct 28 15:29:00 grubby kernel: [  951.023273]   .next_balance              =
    : 4295.130499
Oct 28 15:29:00 grubby kernel: [  951.023276]   .curr->pid                 =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023280]   .clock                     =
    : 950935.128380
Oct 28 15:29:00 grubby kernel: [  951.023283]   .cpu_load[0]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023285]   .cpu_load[1]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023288]   .cpu_load[2]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023290]   .cpu_load[3]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023293]   .cpu_load[4]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023296]=20
Oct 28 15:29:00 grubby kernel: [  951.023297] cfs_rq[1]:/autogroup-37
Oct 28 15:29:00 grubby kernel: [  951.023300]   .exec_clock                =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023303]   .MIN_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023307]   .min_vruntime              =
    : 10207.915276
Oct 28 15:29:00 grubby kernel: [  951.023310]   .max_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023313]   .spread                    =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023316]   .spread0                   =
    : -50304.113093
Oct 28 15:29:00 grubby kernel: [  951.023319]   .nr_spread_over            =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023322]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023325]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023328]   .load_avg                  =
    : 5119.999488
Oct 28 15:29:00 grubby kernel: [  951.023331]   .load_period               =
    : 5.000867
Oct 28 15:29:00 grubby kernel: [  951.023334]   .load_contrib              =
    : 1023
Oct 28 15:29:00 grubby kernel: [  951.023337]   .load_tg                   =
    : 1023
Oct 28 15:29:00 grubby kernel: [  951.023340]   .se->exec_start            =
    : 950935.126200
Oct 28 15:29:00 grubby kernel: [  951.023344]   .se->vruntime              =
    : 57670.184335
Oct 28 15:29:00 grubby kernel: [  951.023347]   .se->sum_exec_runtime      =
    : 7169.286795
Oct 28 15:29:00 grubby kernel: [  951.023350]   .se->load.weight           =
    : 2
Oct 28 15:29:00 grubby kernel: [  951.023354]=20
Oct 28 15:29:00 grubby kernel: [  951.023355] cfs_rq[1]:/autogroup-51
Oct 28 15:29:00 grubby kernel: [  951.023358]   .exec_clock                =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023361]   .MIN_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023364]   .min_vruntime              =
    : 1144.936523
Oct 28 15:29:00 grubby kernel: [  951.023368]   .max_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023371]   .spread                    =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023374]   .spread0                   =
    : -59367.091846
Oct 28 15:29:00 grubby kernel: [  951.023377]   .nr_spread_over            =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023380]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023382]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023385]   .load_avg                  =
    : 1293.119616
Oct 28 15:29:00 grubby kernel: [  951.023389]   .load_period               =
    : 8.456470
Oct 28 15:29:00 grubby kernel: [  951.023392]   .load_contrib              =
    : 152
Oct 28 15:29:00 grubby kernel: [  951.023394]   .load_tg                   =
    : 152
Oct 28 15:29:00 grubby kernel: [  951.023398]   .se->exec_start            =
    : 950910.922132
Oct 28 15:29:00 grubby kernel: [  951.023401]   .se->vruntime              =
    : 57659.410595
Oct 28 15:29:00 grubby kernel: [  951.023404]   .se->sum_exec_runtime      =
    : 1133.013755
Oct 28 15:29:00 grubby kernel: [  951.023407]   .se->load.weight           =
    : 2
Oct 28 15:29:00 grubby kernel: [  951.023410]=20
Oct 28 15:29:00 grubby kernel: [  951.023411] cfs_rq[1]:/
Oct 28 15:29:00 grubby kernel: [  951.023414]   .exec_clock                =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023417]   .MIN_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023420]   .min_vruntime              =
    : 57670.184335
Oct 28 15:29:00 grubby kernel: [  951.023424]   .max_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023427]   .spread                    =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023430]   .spread0                   =
    : -2841.844034
Oct 28 15:29:00 grubby kernel: [  951.023433]   .nr_spread_over            =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023436]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023438]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023441]   .load_avg                  =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023444]   .load_period               =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023447]   .load_contrib              =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023450]   .load_tg                   =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023452]=20
Oct 28 15:29:00 grubby kernel: [  951.023453] rt_rq[1]:
Oct 28 15:29:00 grubby kernel: [  951.023455]   .rt_nr_running             =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023458]   .rt_throttled              =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023461]   .rt_time                   =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023464]   .rt_runtime                =
    : 950.000000
Oct 28 15:29:00 grubby kernel: [  951.023468]=20
Oct 28 15:29:00 grubby kernel: [  951.023468] runnable tasks:
Oct 28 15:29:00 grubby kernel: [  951.023470]             task   PID       =
  tree-key  switches  prio     exec-runtime         sum-exec        sum-sle=
ep
Oct 28 15:29:00 grubby kernel: [  951.023472] -----------------------------=
---------------------------------------------------------------------------=
--
Oct 28 15:29:00 grubby kernel: [  951.023489]=20
Oct 28 15:29:00 grubby kernel: [  951.023490] cpu#2, 2660.337 MHz
Oct 28 15:29:00 grubby kernel: [  951.023492]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023495]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023498]   .nr_switches               =
    : 182575
Oct 28 15:29:00 grubby kernel: [  951.023501]   .nr_load_updates           =
    : 24548
Oct 28 15:29:00 grubby kernel: [  951.023504]   .nr_uninterruptible        =
    : 25
Oct 28 15:29:00 grubby kernel: [  951.023507]   .next_balance              =
    : 4295.130565
Oct 28 15:29:00 grubby kernel: [  951.023510]   .curr->pid                 =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023513]   .clock                     =
    : 951018.233322
Oct 28 15:29:00 grubby kernel: [  951.023516]   .cpu_load[0]               =
    : 512
Oct 28 15:29:00 grubby kernel: [  951.023519]   .cpu_load[1]               =
    : 256
Oct 28 15:29:00 grubby kernel: [  951.023521]   .cpu_load[2]               =
    : 128
Oct 28 15:29:00 grubby kernel: [  951.023524]   .cpu_load[3]               =
    : 64
Oct 28 15:29:00 grubby kernel: [  951.023526]   .cpu_load[4]               =
    : 32
Oct 28 15:29:00 grubby kernel: [  951.023530]=20
Oct 28 15:29:00 grubby kernel: [  951.023531] cfs_rq[2]:/autogroup-67
Oct 28 15:29:00 grubby kernel: [  951.023534]   .exec_clock                =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023537]   .MIN_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023540]   .min_vruntime              =
    : 2313.215565
Oct 28 15:29:00 grubby kernel: [  951.023543]   .max_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023547]   .spread                    =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023550]   .spread0                   =
    : -58198.812804
Oct 28 15:29:00 grubby kernel: [  951.023553]   .nr_spread_over            =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023556]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023558]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023561]   .load_avg                  =
    : 5119.999488
Oct 28 15:29:00 grubby kernel: [  951.023565]   .load_period               =
    : 5.001016
Oct 28 15:29:00 grubby kernel: [  951.023568]   .load_contrib              =
    : 1023
Oct 28 15:29:00 grubby kernel: [  951.023570]   .load_tg                   =
    : 2046
Oct 28 15:29:00 grubby kernel: [  951.023574]   .se->exec_start            =
    : 951018.231288
Oct 28 15:29:00 grubby kernel: [  951.023577]   .se->vruntime              =
    : 78520.807395
Oct 28 15:29:00 grubby kernel: [  951.023580]   .se->sum_exec_runtime      =
    : 2442.987269
Oct 28 15:29:00 grubby kernel: [  951.023583]   .se->load.weight           =
    : 2
Oct 28 15:29:00 grubby kernel: [  951.023586]=20
Oct 28 15:29:00 grubby kernel: [  951.023587] cfs_rq[2]:/
Oct 28 15:29:00 grubby kernel: [  951.023590]   .exec_clock                =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023593]   .MIN_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023596]   .min_vruntime              =
    : 78529.646280
Oct 28 15:29:00 grubby kernel: [  951.023600]   .max_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023603]   .spread                    =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023606]   .spread0                   =
    : 18017.617911
Oct 28 15:29:00 grubby kernel: [  951.023609]   .nr_spread_over            =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023612]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023614]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023617]   .load_avg                  =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023620]   .load_period               =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023623]   .load_contrib              =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023626]   .load_tg                   =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023628]=20
Oct 28 15:29:00 grubby kernel: [  951.023629] rt_rq[2]:
Oct 28 15:29:00 grubby kernel: [  951.023632]   .rt_nr_running             =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023634]   .rt_throttled              =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023637]   .rt_time                   =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023640]   .rt_runtime                =
    : 950.000000
Oct 28 15:29:00 grubby kernel: [  951.023644]=20
Oct 28 15:29:00 grubby kernel: [  951.023645] runnable tasks:
Oct 28 15:29:00 grubby kernel: [  951.023646]             task   PID       =
  tree-key  switches  prio     exec-runtime         sum-exec        sum-sle=
ep
Oct 28 15:29:00 grubby kernel: [  951.023648] -----------------------------=
---------------------------------------------------------------------------=
--
Oct 28 15:29:00 grubby kernel: [  951.023665]=20
Oct 28 15:29:00 grubby kernel: [  951.023666] cpu#3, 2660.337 MHz
Oct 28 15:29:00 grubby kernel: [  951.023668]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023671]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023674]   .nr_switches               =
    : 179112
Oct 28 15:29:00 grubby kernel: [  951.023677]   .nr_load_updates           =
    : 25478
Oct 28 15:29:00 grubby kernel: [  951.023679]   .nr_uninterruptible        =
    : 84
Oct 28 15:29:00 grubby kernel: [  951.023682]   .next_balance              =
    : 4295.130596
Oct 28 15:29:00 grubby kernel: [  951.023685]   .curr->pid                 =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023688]   .clock                     =
    : 951018.327024
Oct 28 15:29:00 grubby kernel: [  951.023691]   .cpu_load[0]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023694]   .cpu_load[1]               =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023697]   .cpu_load[2]               =
    : 3
Oct 28 15:29:00 grubby kernel: [  951.023699]   .cpu_load[3]               =
    : 16
Oct 28 15:29:00 grubby kernel: [  951.023702]   .cpu_load[4]               =
    : 22
Oct 28 15:29:00 grubby kernel: [  951.023705]=20
Oct 28 15:29:00 grubby kernel: [  951.023706] cfs_rq[3]:/autogroup-67
Oct 28 15:29:00 grubby kernel: [  951.023709]   .exec_clock                =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023712]   .MIN_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023715]   .min_vruntime              =
    : 3797.219039
Oct 28 15:29:00 grubby kernel: [  951.023719]   .max_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023722]   .spread                    =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023725]   .spread0                   =
    : -56714.809330
Oct 28 15:29:00 grubby kernel: [  951.023728]   .nr_spread_over            =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023731]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023733]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023736]   .load_avg                  =
    : 5119.999488
Oct 28 15:29:00 grubby kernel: [  951.023740]   .load_period               =
    : 5.001094
Oct 28 15:29:00 grubby kernel: [  951.023743]   .load_contrib              =
    : 1023
Oct 28 15:29:00 grubby kernel: [  951.023746]   .load_tg                   =
    : 2046
Oct 28 15:29:00 grubby kernel: [  951.023749]   .se->exec_start            =
    : 951018.324834
Oct 28 15:29:00 grubby kernel: [  951.023752]   .se->vruntime              =
    : 29080.185346
Oct 28 15:29:00 grubby kernel: [  951.023756]   .se->sum_exec_runtime      =
    : 3139.405603
Oct 28 15:29:00 grubby kernel: [  951.023759]   .se->load.weight           =
    : 2
Oct 28 15:29:00 grubby kernel: [  951.023762]=20
Oct 28 15:29:00 grubby kernel: [  951.023763] cfs_rq[3]:/
Oct 28 15:29:00 grubby kernel: [  951.023765]   .exec_clock                =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023769]   .MIN_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023772]   .min_vruntime              =
    : 29087.504560
Oct 28 15:29:00 grubby kernel: [  951.023775]   .max_vruntime              =
    : 0.000001
Oct 28 15:29:00 grubby kernel: [  951.023778]   .spread                    =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023781]   .spread0                   =
    : -31424.523809
Oct 28 15:29:00 grubby kernel: [  951.023784]   .nr_spread_over            =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023787]   .nr_running                =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023790]   .load                      =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023793]   .load_avg                  =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023796]   .load_period               =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023798]   .load_contrib              =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023801]   .load_tg                   =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023804]=20
Oct 28 15:29:00 grubby kernel: [  951.023805] rt_rq[3]:
Oct 28 15:29:00 grubby kernel: [  951.023807]   .rt_nr_running             =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023810]   .rt_throttled              =
    : 0
Oct 28 15:29:00 grubby kernel: [  951.023812]   .rt_time                   =
    : 0.000000
Oct 28 15:29:00 grubby kernel: [  951.023815]   .rt_runtime                =
    : 950.000000
Oct 28 15:29:00 grubby kernel: [  951.023819]=20
Oct 28 15:29:00 grubby kernel: [  951.023820] runnable tasks:
Oct 28 15:29:00 grubby kernel: [  951.023821]             task   PID       =
  tree-key  switches  prio     exec-runtime         sum-exec        sum-sle=
ep
Oct 28 15:29:00 grubby kernel: [  951.023824] -----------------------------=
---------------------------------------------------------------------------=
--
Oct 28 15:29:00 grubby kernel: [  951.023839]=20

--ZATCr4BkWovzAAkA--

--GkyPMzQoklWKZOV/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk6qsn8ACgkQz0nQ5oovr7x4zgCeLhV+hkJF12PelhviSJMivHFT
GDkAn07JBdbfIhHTrq3PzP56RAyLwIhn
=ei5E
-----END PGP SIGNATURE-----

--GkyPMzQoklWKZOV/--
