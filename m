Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab1KQDkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 22:40:13 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:44031 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab1KQDkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 22:40:11 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: linux-next-20111108 lockdep whinge
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1321501170_2949P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Nov 2011 22:39:30 -0500
Message-ID: <6532.1321501170@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4EC481F5.00E3,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1321501170_2949P
Content-Type: text/plain; charset=us-ascii

Seen in dmesg during early boot.  Not sure if this is a lockdep issue, or a
sched-rt issue, but MAINTAINERS says to ping the same people either way,
so.... :)

Sorry, no known reproducer, have only seen this once in the last week.

[    4.204350] usb 6-1: USB disconnect, device number 2
[    6.660444] usb 6-1: new low-speed USB device number 3 using uhci_hcd
[    6.683460] INFO: trying to register non-static key.
[    6.684344] the code is fine but needs lockdep annotation.
[    6.684417] turning off the locking correctness validator.
[    6.684417] Pid: 74, comm: irq/20-uhci_hcd Not tainted 3.2.0-rc1-next-20111108 #38
[    6.684417] Call Trace:
[    6.684417]  [<ffffffff81069a23>] register_lock_class+0x102/0x2c6
[    6.684417]  [<ffffffff8106993f>] ? register_lock_class+0x1e/0x2c6
[    6.684417]  [<ffffffff8106993f>] ? register_lock_class+0x1e/0x2c6
[    6.684417]  [<ffffffff8106b2d6>] ? validate_chain+0x5a/0x39d
[    6.684417]  [<ffffffff8106b9fb>] __lock_acquire+0xbd/0x3e2
[    6.684417]  [<ffffffff8102f7ab>] ? double_rq_lock+0x70/0x79
[    6.684417]  [<ffffffff8106c256>] lock_acquire+0x103/0x153
[    6.684417]  [<ffffffff8102f7ab>] ? double_rq_lock+0x70/0x79
[    6.684417]  [<ffffffff815b1614>] _raw_spin_lock_nested+0x3a/0x49
[    6.684417]  [<ffffffff8102f7ab>] ? double_rq_lock+0x70/0x79
[    6.684417]  [<ffffffff815b1661>] ? _raw_spin_lock+0x3e/0x45
[    6.684417]  [<ffffffff8102f78c>] ? double_rq_lock+0x51/0x79
[    6.684417]  [<ffffffff8102f7ab>] double_rq_lock+0x70/0x79
[    6.684417]  [<ffffffff8102f803>] double_lock_balance+0x4f/0x5d
[    6.684417]  [<ffffffff8102f86b>] find_lock_lowest_rq+0x5a/0xfe
[    6.684417]  [<ffffffff810353af>] push_rt_task.part.61+0xad/0x149
[    6.684417]  [<ffffffff81035550>] post_schedule_rt+0x1b/0x23
[    6.684417]  [<ffffffff8102d707>] post_schedule.part.21+0x2b/0x45
[    6.684417]  [<ffffffff815af987>] __schedule+0x720/0x766
[    6.684417]  [<ffffffff8109062f>] ? irq_thread_fn+0x37/0x37
[    6.684417]  [<ffffffff815afb83>] schedule+0x55/0x57
[    6.684417]  [<ffffffff810905ba>] irq_thread+0x18b/0x1c9
[    6.684417]  [<ffffffff8109042f>] ? irq_finalize_oneshot+0xc9/0xc9
[    6.684417]  [<ffffffff81058ca6>] kthread+0x7f/0x87
[    6.684417]  [<ffffffff815b96f4>] kernel_thread_helper+0x4/0x10
[    6.684417]  [<ffffffff815b22e1>] ? retint_restore_args+0xe/0xe
[    6.684417]  [<ffffffff81058c27>] ? __init_kthread_worker+0x55/0x55
[    6.684417]  [<ffffffff815b96f0>] ? gs_change+0xb/0xb
[    6.896264] usb 6-1: New USB device found, idVendor=0e8f, idProduct=0020
[    6.897516] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.898848] usb 6-1: Product: PS2toUSB Adapter
[    6.899718] usb 6-1: Manufacturer: GASIA
[    6.917981] input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input13


--==_Exmh_1321501170_2949P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOxIHycC3lWbTT17ARAurTAKDNgWbejVGkTCXtWtTQdzENsch6dQCfWrdx
9ghuhOB83QqchCI1YJDv1tE=
=CB2C
-----END PGP SIGNATURE-----

--==_Exmh_1321501170_2949P--

