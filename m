Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab1GSLIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 07:08:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55965 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1GSLIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 07:08:47 -0400
Subject: Re: crash in active_task, 3.0-rc6+
From: Peter Zijlstra <peterz@infradead.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4E1B3A70.40600@candelatech.com>
References: <4E1B3A70.40600@candelatech.com>
Content-Type: multipart/mixed; boundary="=-AwMZfPqqmopJlgmqbI/B"
Date: Tue, 19 Jul 2011 13:08:21 +0200
Message-ID: <1311073701.13765.194.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AwMZfPqqmopJlgmqbI/B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-07-11 at 11:01 -0700, Ben Greear wrote:
> This is from a lightly patched kernel (nfs related patches)
> Same system sees lockdep warnings related to scheduling that
> I've been posting as well...
>=20
> I haven't seen anything similar in older kernels, so this may
> be a regression.  We tested .38 in this setup without seeing it,
> but havn't tested .39.
>=20
> [root@simech2 ~]# BUG: unable to handle kernel NULL pointer dereference a=
t 0000000000000004
> IP: [<ffffffff81231bf8>] do_raw_spin_lock+0x14/0x13c
> PGD 127082067 PUD 127081067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU 2
> Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_soc=
ket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit ip]
>=20
> Pid: 2203, comm: gnuserver Not tainted 3.0.0-rc6+ #20 Supermicro X7DBU/X7=
DBU
> RIP: 0010:[<ffffffff81231bf8>]  [<ffffffff81231bf8>] do_raw_spin_lock+0x1=
4/0x13c
> RSP: 0018:ffff8801104e3628  EFLAGS: 00010096
> RAX: ffff880126b9e7e0 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff8801104e3668 R08: 0000000000000002 R09: 0000000000000001
> R10: 000002bf7b96a212 R11: ffff880107481e30 R12: 0000000000000003
> R13: 0000000000000000 R14: 0000000000000046 R15: 0000000000000002
> FS:  00007f213f07c720(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000004 CR3: 0000000110519000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process gnuserver (pid: 2203, threadinfo ffff8801104e2000, task ffff88012=
6b9e7e0)
> Stack:
>   0000000000000018 0000000000000046 00000000bf3d0800 0000000000000000
>   0000000000000003 0000000000000000 0000000000000046 0000000000000002
>   ffff8801104e3698 ffffffff8147e459 ffffffff810a7f25 ffffffff8103d2f7
> Call Trace:
>   [<ffffffff8147e459>] _raw_spin_lock+0x3e/0x45
>   [<ffffffff810a7f25>] ? __rcu_read_unlock+0xdc/0x24e
>   [<ffffffff8103d2f7>] ? activate_task+0x30/0x30
>   [<ffffffff810a7f25>] __rcu_read_unlock+0xdc/0x24e
>   [<ffffffff8103d34d>] rcu_read_unlock+0x21/0x23
>   [<ffffffff8103efd7>] select_task_rq_fair+0x8cc/0x8e1
>   [<ffffffff81042b59>] ? finish_task_switch+0x78/0xf1
>   [<ffffffff81042b1b>] ? finish_task_switch+0x3a/0xf1
>   [<ffffffff810468d0>] ? try_to_wake_up+0x29/0x1a0
>   [<ffffffff810468d0>] ? try_to_wake_up+0x29/0x1a0
>   [<ffffffff81040c52>] select_task_rq+0x13/0x44
>   [<ffffffff8104697f>] try_to_wake_up+0xd8/0x1a0
>   [<ffffffff8103c783>] ? __wake_up+0x1d/0x48
>   [<ffffffff81046a54>] default_wake_function+0xd/0xf
>   [<ffffffff8106751a>] autoremove_wake_function+0x13/0x38
>   [<ffffffff810395d0>] __wake_up_common+0x49/0x7f
>   [<ffffffff8103c79a>] __wake_up+0x34/0x48
>   [<ffffffff810a74a9>] rcu_report_exp_rnp+0x50/0x89
>   [<ffffffff810a7f25>] ? __rcu_read_unlock+0xdc/0x24e
>   [<ffffffff810a8032>] __rcu_read_unlock+0x1e9/0x24e
>   [<ffffffff813fce40>] rcu_read_unlock+0x21/0x23
>   [<ffffffff813fd52d>] ip_queue_xmit+0x35e/0x3b1
>   [<ffffffff813fd1cf>] ? ip_send_reply+0x247/0x247
>   [<ffffffff8140f5f3>] tcp_transmit_skb+0x785/0x7c3
>   [<ffffffff81411e23>] tcp_write_xmit+0x806/0x8f5
>   [<ffffffff810e646f>] ? might_fault+0x4e/0x9e
>   [<ffffffff81403e25>] ? copy_from_user+0x2a/0x2c
>   [<ffffffff81411f63>] __tcp_push_pending_frames+0x20/0x4d
>   [<ffffffff8140411f>] tcp_push+0x84/0x86
>   [<ffffffff81406577>] tcp_sendmsg+0x674/0x775
>   [<ffffffff81423d68>] inet_sendmsg+0x61/0x6a
>   [<ffffffff813af67a>] __sock_sendmsg_nosec+0x58/0x61
>   [<ffffffff813b0db5>] __sock_sendmsg+0x3d/0x48
>   [<ffffffff813b1631>] sock_sendmsg+0xa3/0xbc
>   [<ffffffff810ea6ae>] ? handle_pte_fault+0x7fc/0x84d
>   [<ffffffff81110b14>] ? mem_cgroup_get_limit+0x45/0x45
>   [<ffffffff8111a4e9>] ? fget_light+0x35/0xac
>   [<ffffffff813b16b2>] ? sockfd_lookup_light+0x1b/0x53
>   [<ffffffff813b1bf5>] sys_sendto+0xfa/0x11f
>   [<ffffffff8147f0d8>] ? retint_restore_args+0x13/0x13
>   [<ffffffff8109f0a1>] ? audit_syscall_entry+0x119/0x145
>   [<ffffffff81484d52>] system_call_fastpath+0x16/0x1b


Fun, that's a recursion we've been poking at for the past few days, but
I haven't seen it do a NULL-ptr deref like this yet.

I'm also not quite sure the below patches will catch this particular
recursion, it might be you need the patch from
lkml.kernel.org/r/20110718151524.GA4236@linux.vnet.ibm.com as well,
since this is RCU recursing on itself without the aid of interrupts.

How reproducable is this? And if so, what's your .config and recipe for
making it go bang?

--=-AwMZfPqqmopJlgmqbI/B
Content-Disposition: attachment; filename*0=peter_zijlstra-re-info__possible_circular_locking_dependency_; filename*1=detected.patch
Content-Type: text/x-patch; name*0=peter_zijlstra-re-info__possible_circular_locking_dependency_dete; name*1=cted.patch; charset="UTF-8"
Content-Transfer-Encoding: base64

U3ViamVjdDogcmN1LCBzb2Z0aXJxOiBBdm9pZCByY3VfcmVhZF91bmxvY2tfc3BlY2lhbCB2cyBz
b2Z0aXJxIHJlY3Vyc2lvbg0KRnJvbTogUGV0ZXIgWmlqbHN0cmEgPGEucC56aWpsc3RyYUBjaGVs
bG8ubmw+DQpEYXRlOiBGcmksIDE1IEp1bCAyMDExIDE3OjA0OjI3ICswMjAwDQoNCiAkdGFzawkJ
CUlSUQkJU29mdElSUQ0KDQogcmN1X3JlYWRfbG9jaygpDQoNCiAvKiBkbyBzdHVmZiAqLw0KDQog
PHByZWVtcHQ+IHw9IFVOTE9DS19CTE9DS0VEDQoNCiByY3VfcmVhZF91bmxvY2soKQ0KICAgLS10
LT5yY3VfcmVhZF9sb2NrX25lc3RpbmcNCg0KCQkJaXJxX2VudGVyKCk7DQoJCQkvKiBkbyBzdHVm
ZiwgZG9uJ3QgdXNlIFJDVSAqLw0KCQkJaXJxX2V4aXQoKTsNCgkJCSAgc3ViX3ByZWVtcHRfY291
bnQoSVJRX0VYSVRfT0ZGU0VUKTsNCgkJCSAgaW52b2tlX3NvZnRpcnEoKQ0KDQoJCQkJCXR0d3Uo
KTsNCgkJCQkJICBzcGluX2xvY2tfaXJxKCZwaS0+bG9jaykNCgkJCQkJICByY3VfcmVhZF9sb2Nr
KCk7DQoJCQkJCSAgLyogZG8gc3R1ZmYgKi8NCgkJCQkJICByY3VfcmVhZF91bmxvY2soKTsNCgkJ
CQkJICAgIHJjdV9yZWFkX3VubG9ja19zcGVjaWFsKCkNCgkJCQkJICAgICAgcmN1X3JlcG9ydF9l
eHBfcm5wKCkNCgkJCQkJICAgICAgICB0dHd1KCkNCgkJCQkJICAgICAgICAgIHNwaW5fbG9ja19p
cnEoJnBpLT5sb2NrKSAvKiBkZWFkbG9jayAqLw0KDQogICByY3VfcmVhZF91bmxvY2tfc3BlY2lh
bCh0KTsNCg0KRWQgY2FuIHNpbXBseSB0cmlnZ2VyIHRoaXMgJ2Vhc3knIGJlY2F1c2UgaW52b2tl
X3NvZnRpcnEoKSBpbW1lZGlhdGVseQ0KZG9lcyBhIHR0d3UoKSBvZiBrc29mdGlycWQvIyBpbnN0
ZWFkIG9mIGRvaW5nIHRoZSBpbi1wbGFjZSBzb2Z0aXJxIHN0dWZmDQpmaXJzdCwgYnV0IGV2ZW4g
d2l0aG91dCB0aGF0IHRoZSBhYm92ZSBjYW4gaGFwcGVuLg0KDQpDdXJlIHRoaXMgYnkgYWxzbyBl
eGNsdWRpbmcgc29mdGlycXMgZnJvbSB0aGUNCnJjdV9yZWFkX3VubG9ja19zcGVjaWFsKCkgaGFu
ZGxlciBhbmQgZW5zdXJpbmcgdGhlIGZvcmNlX2lycXRocmVhZHMNCmtzb2Z0aXJxZC8jIHdha2V1
cCBpcyBkb25lIGZyb20gZnVsbCBzb2Z0aXJxIGNvbnRleHQuDQoNClsgQWx0ZXJuYXRpdmVseSwg
ZGVsYXlpbmcgdGhlIC0+cmN1X3JlYWRfbG9ja19uZXN0aW5nIGRlY3JlbWVudA0KICB1bnRpbCBh
ZnRlciB0aGUgc3BlY2lhbCBoYW5kbGluZyB3b3VsZCBtYWtlIHRoZSB0aGluZyBtb3JlIHJvYnVz
dA0KICBpbiB0aGUgZmFjZSBvZiBpbnRlcnJ1cHRzIGFzIHdlbGwuIF0NCg0KQ2M6IFRob21hcyBH
bGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPg0KQ2M6IFBhdWwgRS4gTWNLZW5uZXkgPHBhdWxt
Y2tAbGludXgudm5ldC5pYm0uY29tPg0KUmVwb3J0ZWQtYW5kLXRlc3RlZC1ieTogRWQgVG9tbGlu
c29uIDxlZHRAYWVpLmNhPg0KU2lnbmVkLW9mZi1ieTogUGV0ZXIgWmlqbHN0cmEgPGEucC56aWps
c3RyYUBjaGVsbG8ubmw+DQpMaW5rOiBodHRwOi8vbGttbC5rZXJuZWwub3JnL3IvMTMxMDc0MjI2
Ny4yNTg2LjM1My5jYW1lbEB0d2lucw0KLS0tDQoga2VybmVsL3JjdXRyZWVfcGx1Z2luLmggfCAg
ICAyICstDQoga2VybmVsL3NvZnRpcnEuYyAgICAgICAgfCAgIDEyICsrKysrKysrKystLQ0KIDIg
ZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2tlcm5lbC9yY3V0cmVlX3BsdWdpbi5oIGIva2VybmVsL3JjdXRyZWVfcGx1Z2luLmgN
CmluZGV4IDE0ZGM3ZGQuLjM3M2M5YzggMTAwNjQ0DQotLS0gYS9rZXJuZWwvcmN1dHJlZV9wbHVn
aW4uaA0KKysrIGIva2VybmVsL3JjdXRyZWVfcGx1Z2luLmgNCkBAIC0zMDksNyArMzA5LDcgQEAg
c3RhdGljIHZvaWQgcmN1X3JlYWRfdW5sb2NrX3NwZWNpYWwoc3RydWN0IHRhc2tfc3RydWN0ICp0
KQ0KIAl9DQogDQogCS8qIEhhcmR3YXJlIElSUSBoYW5kbGVycyBjYW5ub3QgYmxvY2suICovDQot
CWlmIChpbl9pcnEoKSkgew0KKwlpZiAoaW5faXJxKCkgfHwgaW5fc2VydmluZ19zb2Z0aXJxKCkp
IHsNCiAJCWxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsNCiAJCXJldHVybjsNCiAJfQ0KZGlmZiAt
LWdpdCBhL2tlcm5lbC9zb2Z0aXJxLmMgYi9rZXJuZWwvc29mdGlycS5jDQppbmRleCA0MGNmNjNk
Li5mY2E4MmMzIDEwMDY0NA0KLS0tIGEva2VybmVsL3NvZnRpcnEuYw0KKysrIGIva2VybmVsL3Nv
ZnRpcnEuYw0KQEAgLTMxNSwxNiArMzE1LDI0IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBpbnZva2Vf
c29mdGlycSh2b2lkKQ0KIHsNCiAJaWYgKCFmb3JjZV9pcnF0aHJlYWRzKQ0KIAkJX19kb19zb2Z0
aXJxKCk7DQotCWVsc2UNCisJZWxzZSB7DQorCQlfX2xvY2FsX2JoX2Rpc2FibGUoKHVuc2lnbmVk
IGxvbmcpX19idWlsdGluX3JldHVybl9hZGRyZXNzKDApLA0KKwkJCQlTT0ZUSVJRX09GRlNFVCk7
DQogCQl3YWtldXBfc29mdGlycWQoKTsNCisJCV9fbG9jYWxfYmhfZW5hYmxlKFNPRlRJUlFfT0ZG
U0VUKTsNCisJfQ0KIH0NCiAjZWxzZQ0KIHN0YXRpYyBpbmxpbmUgdm9pZCBpbnZva2Vfc29mdGly
cSh2b2lkKQ0KIHsNCiAJaWYgKCFmb3JjZV9pcnF0aHJlYWRzKQ0KIAkJZG9fc29mdGlycSgpOw0K
LQllbHNlDQorCWVsc2Ugew0KKwkJX19sb2NhbF9iaF9kaXNhYmxlKCh1bnNpZ25lZCBsb25nKV9f
YnVpbHRpbl9yZXR1cm5fYWRkcmVzcygwKSwNCisJCQkJU09GVElSUV9PRkZTRVQpOw0KIAkJd2Fr
ZXVwX3NvZnRpcnFkKCk7DQorCQlfX2xvY2FsX2JoX2VuYWJsZShTT0ZUSVJRX09GRlNFVCk7DQor
CX0NCiB9DQogI2VuZGlmDQogDQoNCg==


--=-AwMZfPqqmopJlgmqbI/B
Content-Disposition: attachment; filename="peter_zijlstra-sched-add_irq_enterexit_to_scheduler_ipi.patch"
Content-Type: text/x-patch; name="peter_zijlstra-sched-add_irq_enterexit_to_scheduler_ipi.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

U3ViamVjdDogc2NoZWQ6IEFkZCBpcnFfe2VudGVyLGV4aXR9KCkgdG8gc2NoZWR1bGVyX2lwaSgp
DQpGcm9tOiBQZXRlciBaaWpsc3RyYSA8YS5wLnppamxzdHJhQGNoZWxsby5ubD4NCkRhdGU6IE1v
biwgMTggSnVsIDIwMTEgMTE6Mjk6NDQgKzAyMDANCg0KRW5zdXJlIHNjaGVkdWxlcl9pcGkoKSBj
YWxscyBpcnFfe2VudGVyLGV4aXR9IHdoZW4gaXQgZG9lcyBzb21lIGFjdHVhbA0Kd29yay4gVHJh
ZGl0aW9uYWxseSB3ZSBuZXZlciBkaWQgYW55IGFjdHVhbCB3b3JrIGZyb20gdGhlIHJlc2NoZWQg
SVBJDQphbmQgYWxsIG1hZ2ljIGhhcHBlbmVkIGluIHRoZSByZXR1cm4gZnJvbSBpbnRlcnJ1cHQg
cGF0aC4NCg0KTm93IHRoYXQgd2UgZG8gZG8gc29tZSB3b3JrLCB3ZSBuZWVkIHRvIGVuc3VyZSBp
cnFfe2VudGVyLGV4aXR9IGFyZQ0KY2FsbGVkIHNvIHRoYXQgd2UgZG9uJ3QgY29uZnVzZSB0aGlu
Z3MuDQoNClRoaXMgYWZmZWN0cyB0aGluZ3MgbGlrZSB0aW1la2VlcGluZywgTk9fSFogYW5kIFJD
VSwgYmFzaWNhbGx5DQpldmVyeXRoaW5nIHdpdGggYSBob29rIGluIGlycV9lbnRlci9leGl0Lg0K
DQpFeHBsaWNpdCBleGFtcGxlcyBvZiB0aGluZ3MgZ29pbmcgd3JvbmcgYXJlOg0KDQogIHNjaGVk
X2Nsb2NrX2NwdSgpIC0tIGhhcyBhIGNhbGxiYWNrIHdoZW4gbGVhdmluZyBOT19IWiBzdGF0ZSB0
byB0YWtlDQogICAgICAgICAgICAgICAgICAgIGEgbmV3IHJlYWRpbmcgZnJvbSBHVE9EIGFuZCBU
U0MuIFdpdGhvdXQgdGhpcw0KICAgICAgICAgICAgICAgICAgICBjYWxsYmFjaywgdGltZSBpcyBz
dHVjayBpbiB0aGUgcGFzdC4NCg0KICBSQ1UgLS0gbmVlZHMgaW5faXJxKCkgdG8gd29yayBpbiBv
cmRlciB0byBhdm9pZCBzb21lIG5hc3R5IGRlYWRsb2Nrcw0KDQpBY2tlZC1ieTogUGF1bCBFLiBN
Y0tlbm5leSA8cGF1bG1ja0BsaW51eC52bmV0LmlibS5jb20+DQpTaWduZWQtb2ZmLWJ5OiBQZXRl
ciBaaWpsc3RyYSA8YS5wLnppamxzdHJhQGNoZWxsby5ubD4NCkxpbms6IGh0dHA6Ly9sa21sLmtl
cm5lbC5vcmcvci8xMzEwOTgxMzg0LjEzNzY1LjQwLmNhbWVsQHR3aW5zDQotLS0NCiBrZXJuZWwv
c2NoZWQuYyB8ICAgNDAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLQ0K
IDEgZmlsZXMgY2hhbmdlZCwgMzQgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KZGlm
ZiAtLWdpdCBhL2tlcm5lbC9zY2hlZC5jIGIva2VybmVsL3NjaGVkLmMNCmluZGV4IDhmYjQyNDUu
LmViOWNiZTcgMTAwNjQ0DQotLS0gYS9rZXJuZWwvc2NoZWQuYw0KKysrIGIva2VybmVsL3NjaGVk
LmMNCkBAIC0yNTQ0LDEzICsyNTQ0LDkgQEAgc3RhdGljIGludCB0dHd1X3JlbW90ZShzdHJ1Y3Qg
dGFza19zdHJ1Y3QgKnAsIGludCB3YWtlX2ZsYWdzKQ0KIH0NCiANCiAjaWZkZWYgQ09ORklHX1NN
UA0KLXN0YXRpYyB2b2lkIHNjaGVkX3R0d3VfcGVuZGluZyh2b2lkKQ0KK3N0YXRpYyB2b2lkIHNj
aGVkX3R0d3VfZG9fcGVuZGluZyhzdHJ1Y3QgdGFza19zdHJ1Y3QgKmxpc3QpDQogew0KIAlzdHJ1
Y3QgcnEgKnJxID0gdGhpc19ycSgpOw0KLQlzdHJ1Y3QgdGFza19zdHJ1Y3QgKmxpc3QgPSB4Y2hn
KCZycS0+d2FrZV9saXN0LCBOVUxMKTsNCi0NCi0JaWYgKCFsaXN0KQ0KLQkJcmV0dXJuOw0KIA0K
IAlyYXdfc3Bpbl9sb2NrKCZycS0+bG9jayk7DQogDQpAQCAtMjU2Myw5ICsyNTU5LDQxIEBAIHN0
YXRpYyB2b2lkIHNjaGVkX3R0d3VfcGVuZGluZyh2b2lkKQ0KIAlyYXdfc3Bpbl91bmxvY2soJnJx
LT5sb2NrKTsNCiB9DQogDQorc3RhdGljIHZvaWQgc2NoZWRfdHR3dV9wZW5kaW5nKHZvaWQpDQor
ew0KKwlzdHJ1Y3QgcnEgKnJxID0gdGhpc19ycSgpOw0KKwlzdHJ1Y3QgdGFza19zdHJ1Y3QgKmxp
c3QgPSB4Y2hnKCZycS0+d2FrZV9saXN0LCBOVUxMKTsNCisNCisJaWYgKCFsaXN0KQ0KKwkJcmV0
dXJuOw0KKw0KKwlzY2hlZF90dHd1X2RvX3BlbmRpbmcobGlzdCk7DQorfQ0KKw0KIHZvaWQgc2No
ZWR1bGVyX2lwaSh2b2lkKQ0KIHsNCi0Jc2NoZWRfdHR3dV9wZW5kaW5nKCk7DQorCXN0cnVjdCBy
cSAqcnEgPSB0aGlzX3JxKCk7DQorCXN0cnVjdCB0YXNrX3N0cnVjdCAqbGlzdCA9IHhjaGcoJnJx
LT53YWtlX2xpc3QsIE5VTEwpOw0KKw0KKwlpZiAoIWxpc3QpDQorCQlyZXR1cm47DQorDQorCS8q
DQorCSAqIE5vdCBhbGwgcmVzY2hlZHVsZSBJUEkgaGFuZGxlcnMgY2FsbCBpcnFfZW50ZXIvaXJx
X2V4aXQsIHNpbmNlDQorCSAqIHRyYWRpdGlvbmFsbHkgYWxsIHRoZWlyIHdvcmsgd2FzIGRvbmUg
ZnJvbSB0aGUgaW50ZXJydXB0IHJldHVybg0KKwkgKiBwYXRoLiBOb3cgdGhhdCB3ZSBhY3R1YWxs
eSBkbyBzb21lIHdvcmssIHdlIG5lZWQgdG8gbWFrZSBzdXJlDQorCSAqIHdlIGRvIGNhbGwgdGhl
bS4NCisJICoNCisJICogU29tZSBhcmNocyBhbHJlYWR5IGRvIGNhbGwgdGhlbSwgbHVja2lseSBp
cnFfZW50ZXIvZXhpdCBuZXN0DQorCSAqIHByb3Blcmx5Lg0KKwkgKg0KKwkgKiBBcmd1YWJseSB3
ZSBzaG91bGQgdmlzaXQgYWxsIGFyY2hzIGFuZCB1cGRhdGUgYWxsIGhhbmRsZXJzLA0KKwkgKiBo
b3dldmVyIGEgZmFpciBzaGFyZSBvZiBJUElzIGFyZSBzdGlsbCByZXNjaGVkIG9ubHkgc28gdGhp
cyB3b3VsZA0KKwkgKiBzb21ld2hhdCBwZXNzaW1pemUgdGhlIHNpbXBsZSByZXNjaGVkIGNhc2Uu
DQorCSAqLw0KKwlpcnFfZW50ZXIoKTsNCisJc2NoZWRfdHR3dV9kb19wZW5kaW5nKGxpc3QpOw0K
KwlpcnFfZXhpdCgpOw0KIH0NCiANCiBzdGF0aWMgdm9pZCB0dHd1X3F1ZXVlX3JlbW90ZShzdHJ1
Y3QgdGFza19zdHJ1Y3QgKnAsIGludCBjcHUpDQoNCg==


--=-AwMZfPqqmopJlgmqbI/B--
