Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753Ab1KWH3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:29:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61320 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab1KWH3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:29:33 -0500
MIME-Version: 1.0
In-Reply-To: <20111123033850.GA11380@redhat.com>
References: <20111123033850.GA11380@redhat.com>
Date: Wed, 23 Nov 2011 15:29:17 +0800
Message-ID: <CAM_iQpUa0heYrn-Bwttz1qnDh6pY7KSV=CYJBTE6qMQUcX_v1w@mail.gmail.com>
Subject: Re: tty related lockdep trace during bootup on 3.2-rc2
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Havard Skinnemoen <hskinnemoen@google.com>
Content-Type: multipart/mixed; boundary=14dae9340dc1adcccb04b261e0a6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9340dc1adcccb04b261e0a6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2011 at 11:38 AM, Dave Jones <davej@redhat.com> wrote:
> From Linus' current tree...
>
> related to 5dc2470c602da8851907ec18942cd876c3b4ecc1 maybe ?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Dave
>
> [ =C2=A0 40.778011] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ =C2=A0 40.780010] [ INFO: possible circular locking dependency detected=
 ]
> [ =C2=A0 40.780010] 3.2.0-rc2+ #8
> [ =C2=A0 40.780010] -----------------------------------------------------=
--
> [ =C2=A0 40.780010] modem-manager/1141 is trying to acquire lock:
> [ =C2=A0 40.780010] =C2=A0(big_tty_mutex){+.+.+.}, at: [<ffffffff81682807=
>] tty_lock+0x17/0x19
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] but task is already holding lock:
> [ =C2=A0 40.780010] =C2=A0(open_mutex){+.+...}, at: [<ffffffffa032b321>] =
acm_tty_close+0x41/0xc0 [cdc_acm]
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] which lock already depends on the new lock.
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] the existing dependency chain (in reverse order) is:
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] -> #1 (open_mutex){+.+...}:
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff810c1d9d>] lock_=
acquire+0x9d/0x210
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8168003e>] __mut=
ex_lock_common+0x5e/0x4f0
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81680604>] mutex=
_lock_nested+0x44/0x50
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffffa032b715>] acm_t=
ty_open+0x35/0x230 [cdc_acm]
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff813c1087>] tty_o=
pen+0x247/0x5d0
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811b5408>] chrde=
v_open+0x258/0x350
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811ad9a4>] __den=
try_open+0x384/0x550
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811af194>] namei=
data_to_filp+0x74/0x80
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811c0b6c>] do_la=
st+0x26c/0x920
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811c1335>] path_=
openat+0xd5/0x3e0
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811c1762>] do_fi=
lp_open+0x42/0xa0
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811af297>] do_sy=
s_open+0xf7/0x1d0
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811af390>] sys_o=
pen+0x20/0x30
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81689f82>] syste=
m_call_fastpath+0x16/0x1b
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] -> #0 (big_tty_mutex){+.+.+.}:
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff810c112e>] __loc=
k_acquire+0x16ce/0x1c40
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff810c1d9d>] lock_=
acquire+0x9d/0x210
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff8168003e>] __mut=
ex_lock_common+0x5e/0x4f0
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81680604>] mutex=
_lock_nested+0x44/0x50
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81682807>] tty_l=
ock+0x17/0x19
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff813c91ad>] tty_p=
ort_close_start+0x17d/0x210
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffffa032b32f>] acm_t=
ty_close+0x4f/0xc0 [cdc_acm]
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff813c09e7>] tty_r=
elease+0x167/0x5c0
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811b252e>] fput+=
0xfe/0x2d0
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811adee9>] filp_=
close+0x69/0x90
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff811ae1d0>] sys_c=
lose+0xc0/0x1a0
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0[<ffffffff81689f82>] syste=
m_call_fastpath+0x16/0x1b
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] other info that might help us debug this:
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] =C2=A0Possible unsafe locking scenario:
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CPU1
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0---- =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0----
> [ =C2=A0 40.780010] =C2=A0 lock(open_mutex);
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lock(big_tty_mut=
ex);
> [ =C2=A0 40.780010] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0lock(open_mutex)=
;
> [ =C2=A0 40.780010] =C2=A0 lock(big_tty_mutex);
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] =C2=A0*** DEADLOCK ***
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] 1 lock held by modem-manager/1141:
> [ =C2=A0 40.780010] =C2=A0#0: =C2=A0(open_mutex){+.+...}, at: [<ffffffffa=
032b321>] acm_tty_close+0x41/0xc0 [cdc_acm]
> [ =C2=A0 40.780010]
> [ =C2=A0 40.780010] stack backtrace:
> [ =C2=A0 40.780010] Pid: 1141, comm: modem-manager Not tainted 3.2.0-rc2+=
 #8
> [ =C2=A0 40.780010] Call Trace:
> [ =C2=A0 40.780010] =C2=A0[<ffffffff81675378>] print_circular_bug+0x202/0=
x213
> [ =C2=A0 40.780010] =C2=A0[<ffffffff810c112e>] __lock_acquire+0x16ce/0x1c=
40
> [ =C2=A0 40.780010] =C2=A0[<ffffffff81021f62>] ? native_sched_clock+0x22/=
0x70
> [ =C2=A0 40.780010] =C2=A0[<ffffffff810ae2c5>] ? sched_clock_local+0x25/0=
x90
> [ =C2=A0 40.780010] =C2=A0[<ffffffff810c1d9d>] lock_acquire+0x9d/0x210
> [ =C2=A0 40.780010] =C2=A0[<ffffffff81682807>] ? tty_lock+0x17/0x19
> [ =C2=A0 40.780010] =C2=A0[<ffffffff810c180a>] ? lock_release_non_nested+=
0x16a/0x350
> [ =C2=A0 40.780010] =C2=A0[<ffffffff8168003e>] __mutex_lock_common+0x5e/0=
x4f0
> [ =C2=A0 40.780010] =C2=A0[<ffffffff81682807>] ? tty_lock+0x17/0x19
> [ =C2=A0 40.780010] =C2=A0[<ffffffff810c2796>] ? mark_held_locks+0x86/0x1=
50
> [ =C2=A0 40.780010] =C2=A0[<ffffffff816807ae>] ? mutex_unlock+0xe/0x10
> [ =C2=A0 40.780010] =C2=A0[<ffffffff81682807>] ? tty_lock+0x17/0x19
> [ =C2=A0 40.780010] =C2=A0[<ffffffff81680604>] mutex_lock_nested+0x44/0x5=
0
> [ =C2=A0 40.780010] =C2=A0[<ffffffff81682807>] tty_lock+0x17/0x19
> [ =C2=A0 40.780010] =C2=A0[<ffffffff813c91ad>] tty_port_close_start+0x17d=
/0x210
> [ =C2=A0 40.780010] =C2=A0[<ffffffffa032b32f>] acm_tty_close+0x4f/0xc0 [c=
dc_acm]
> [ =C2=A0 40.780010] =C2=A0[<ffffffff813c09e7>] tty_release+0x167/0x5c0
> [ =C2=A0 40.780010] =C2=A0[<ffffffff81021fb9>] ? sched_clock+0x9/0x10
> [ =C2=A0 40.780010] =C2=A0[<ffffffff810ae2c5>] ? sched_clock_local+0x25/0=
x90
> [ =C2=A0 40.780010] =C2=A0[<ffffffff811b252e>] fput+0xfe/0x2d0
> [ =C2=A0 40.780010] =C2=A0[<ffffffff811adee9>] filp_close+0x69/0x90
> [ =C2=A0 40.780010] =C2=A0[<ffffffff811ae1d0>] sys_close+0xc0/0x1a0
> [ =C2=A0 40.780010] =C2=A0[<ffffffff81689f82>] system_call_fastpath+0x16/=
0x1b
>

Will the following untested patch fix this problem?

------->
tty_port_close_start() will acquire big_tty_mutex, so don't
call it with  open_mutex held.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

--14dae9340dc1adcccb04b261e0a6
Content-Type: text/x-patch; charset=US-ASCII; name="tty-fix.patch"
Content-Disposition: attachment; filename="tty-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gvc0ifn00

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NsYXNzL2NkYy1hY20uYyBiL2RyaXZlcnMvdXNiL2Ns
YXNzL2NkYy1hY20uYwppbmRleCBlOGM1NjRhLi4zYTk3ZmVjIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3VzYi9jbGFzcy9jZGMtYWNtLmMKKysrIGIvZHJpdmVycy91c2IvY2xhc3MvY2RjLWFjbS5jCkBA
IC01NzAsOCArNTcwLDggQEAgc3RhdGljIHZvaWQgYWNtX3R0eV9jbG9zZShzdHJ1Y3QgdHR5X3N0
cnVjdCAqdHR5LCBzdHJ1Y3QgZmlsZSAqZmlscCkKIAlpZiAoIWFjbSkKIAkJcmV0dXJuOwogCi0J
bXV0ZXhfbG9jaygmb3Blbl9tdXRleCk7CiAJaWYgKHR0eV9wb3J0X2Nsb3NlX3N0YXJ0KCZhY20t
PnBvcnQsIHR0eSwgZmlscCkgPT0gMCkgeworCQltdXRleF9sb2NrKCZvcGVuX211dGV4KTsKIAkJ
aWYgKCFhY20tPmRldikgewogCQkJdHR5X3BvcnRfdHR5X3NldCgmYWNtLT5wb3J0LCBOVUxMKTsK
IAkJCWFjbV90dHlfdW5yZWdpc3RlcihhY20pOwpAQCAtNTgwLDYgKzU4MCw3IEBAIHN0YXRpYyB2
b2lkIGFjbV90dHlfY2xvc2Uoc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwgc3RydWN0IGZpbGUgKmZp
bHApCiAJCW11dGV4X3VubG9jaygmb3Blbl9tdXRleCk7CiAJCXJldHVybjsKIAl9CisJbXV0ZXhf
bG9jaygmb3Blbl9tdXRleCk7CiAJYWNtX3BvcnRfZG93bihhY20pOwogCXR0eV9wb3J0X2Nsb3Nl
X2VuZCgmYWNtLT5wb3J0LCB0dHkpOwogCXR0eV9wb3J0X3R0eV9zZXQoJmFjbS0+cG9ydCwgTlVM
TCk7Cg==
--14dae9340dc1adcccb04b261e0a6--
