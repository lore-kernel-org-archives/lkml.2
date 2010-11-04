Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0KDP6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:58:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49489 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0KDP6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NuvJ3Q54GWS8l+m7g45Zuzo0zVm0AYnPv31LH/weenR0bGZwM1btbXuXDN2s1QGCfO
         jFFbWL9DAPVbDBWxhW3ZmfcjnnyCU61OENmWLMSg5+JsZvAHnpZnzqYW79dFhNW1N2XL
         fMFobUKCyXdAqjDbNaFFBC1h/cLYsD5unvR84=
Date: Thu, 4 Nov 2010 17:58:26 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: task blocked for more than 120 seconds
Message-ID: <20101104155826.GC13818@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,
Got the following traces:

[42001.449295] INFO: task openbox:17761 blocked for more than 120 seconds.
[42001.449303] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[42001.449311] openbox       D 0000000000000003     0 17761   3723 0x00000000
[42001.449321]  ffff88004ce8dc38 0000000000000046 0000000000000000 ffff88004ce8c000
[42001.449333]  ffff88004ce8dfd8 0000000000012040 ffff880133010000 ffff88004ce8dfd8
[42001.449343]  0000000000012040 0000000000012040 ffff88004ce8dfd8 0000000000012040
[42001.449354] Call Trace:
[42001.449369]  [<ffffffff814212ff>] schedule_timeout+0x38/0x220
[42001.449381]  [<ffffffff81066f21>] ? mark_held_locks+0x50/0x72
[42001.449389]  [<ffffffff81423dae>] ? _raw_spin_unlock_irq+0x2b/0x59
[42001.449398]  [<ffffffff81036070>] ? get_parent_ip+0x11/0x41
[42001.449406]  [<ffffffff81036132>] ? sub_preempt_count+0x92/0xa5
[42001.449413]  [<ffffffff8142057e>] wait_for_common+0xca/0x144
[42001.449421]  [<ffffffff81038b13>] ? default_wake_function+0x0/0xf
[42001.449429]  [<ffffffff81423e4b>] ? _raw_spin_unlock_irqrestore+0x6f/0x74
[42001.449436]  [<ffffffff81420692>] wait_for_completion+0x18/0x1a
[42001.449445]  [<ffffffff81084808>] stop_one_cpu+0x8c/0xba
[42001.449453]  [<ffffffff810355cb>] ? migration_cpu_stop+0x0/0x3d
[42001.449461]  [<ffffffff81035aef>] sched_exec+0xc3/0xdc
[42001.449470]  [<ffffffff810e7dad>] do_execve+0xaa/0x267
[42001.449479]  [<ffffffff8100a58b>] sys_execve+0x3e/0x55
[42001.449488]  [<ffffffff8100265c>] stub_execve+0x6c/0xc0
[42001.449494] 1 lock held by openbox/17761:
[42001.449498]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff810e7b1d>] prepare_bprm_creds+0x28/0x64

[47761.448699] INFO: task make:29123 blocked for more than 120 seconds.
[47761.448704] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[47761.448710] make          D 0000000000000001     0 29123  24208 0x00000004
[47761.448719]  ffff880115dadcf0 0000000000000046 ffff880100000000 ffff880115dac000
[47761.448731]  ffff880115dadfd8 0000000000012040 ffff880133290000 ffff880115dadfd8
[47761.448741]  0000000000012040 0000000000012040 ffff880115dadfd8 0000000000012040
[47761.448752] Call Trace:
[47761.448766]  [<ffffffff814212ff>] schedule_timeout+0x38/0x220
[47761.448774]  [<ffffffff814204da>] ? wait_for_common+0x26/0x144
[47761.448784]  [<ffffffff81207b53>] ? do_raw_spin_lock+0x6b/0x122
[47761.448792]  [<ffffffff81423dae>] ? _raw_spin_unlock_irq+0x2b/0x59
[47761.448801]  [<ffffffff81036070>] ? get_parent_ip+0x11/0x41
[47761.448808]  [<ffffffff81036132>] ? sub_preempt_count+0x92/0xa5
[47761.448816]  [<ffffffff8142057e>] wait_for_common+0xca/0x144
[47761.448823]  [<ffffffff81038b13>] ? default_wake_function+0x0/0xf
[47761.448831]  [<ffffffff81036132>] ? sub_preempt_count+0x92/0xa5
[47761.448838]  [<ffffffff81420692>] wait_for_completion+0x18/0x1a
[47761.448845]  [<ffffffff8103cec0>] do_fork+0x2b0/0x32e
[47761.448856]  [<ffffffff810021ba>] ? sysret_check+0x2e/0x69
[47761.448864]  [<ffffffff8100a526>] sys_vfork+0x20/0x22
[47761.448871]  [<ffffffff81002563>] stub_vfork+0x13/0x20
[47761.448878]  [<ffffffff81002182>] ? system_call_fastpath+0x16/0x1b
[47761.448884] no locks held by make/29123.
[47761.448891] INFO: task make:31380 blocked for more than 120 seconds.
[47761.448895] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[47761.448899] make          D 0000000000000000     0 31380  29123 0x00000000
[47761.448908]  ffff880157f01c38 0000000000000046 0000000000000000 ffff880157f00000
[47761.448918]  ffff880157f01fd8 0000000000012040 ffff8800773abea0 ffff880157f01fd8
[47761.448929]  0000000000012040 0000000000012040 ffff880157f01fd8 0000000000012040
[47761.448939] Call Trace:
[47761.448947]  [<ffffffff814212ff>] schedule_timeout+0x38/0x220
[47761.448957]  [<ffffffff81066f21>] ? mark_held_locks+0x50/0x72
[47761.448965]  [<ffffffff81423dae>] ? _raw_spin_unlock_irq+0x2b/0x59
[47761.448972]  [<ffffffff81036070>] ? get_parent_ip+0x11/0x41
[47761.448979]  [<ffffffff81036132>] ? sub_preempt_count+0x92/0xa5
[47761.448986]  [<ffffffff8142057e>] wait_for_common+0xca/0x144
[47761.448994]  [<ffffffff81038b13>] ? default_wake_function+0x0/0xf
[47761.449001]  [<ffffffff81423e4b>] ? _raw_spin_unlock_irqrestore+0x6f/0x74
[47761.449008]  [<ffffffff81420692>] wait_for_completion+0x18/0x1a
[47761.449017]  [<ffffffff81084808>] stop_one_cpu+0x8c/0xba
[47761.449025]  [<ffffffff810355cb>] ? migration_cpu_stop+0x0/0x3d
[47761.449033]  [<ffffffff81035aef>] sched_exec+0xc3/0xdc
[47761.449041]  [<ffffffff810e7dad>] do_execve+0xaa/0x267
[47761.449049]  [<ffffffff8100a58b>] sys_execve+0x3e/0x55
[47761.449056]  [<ffffffff8100265c>] stub_execve+0x6c/0xc0
[47761.449062] 1 lock held by make/31380:
[47761.449065]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff810e7b1d>] prepare_bprm_creds+0x28/0x64



	Sergey

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzS2CIACgkQfKHnntdSXjRMOgP+Pg+//4+l3W8CjeklYrUsUOve
G1Hi4bYi4ouxQrPwoXyHMoPUykMQeQbryJgBQl/cPZn7fkxb7LNFsJ8mpj4uYqYn
xr0V+XDSvz34cBRpS4lhGpsXg31hrXu4qJ2aCHyKjZB7S87g2KyHFp8j95EnoPfe
wkJj3JzwPKno9Qla9NM=
=MEld
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--
