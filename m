Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2FFDXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 23:23:46 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47286 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2FFDXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 23:23:44 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: next-20120604 WARNING: at block/blk-cgroup.c:867
From: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1338953019_2145P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jun 2012 23:23:40 -0400
Message-ID: <3785.1338953020@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.161.180 mail-gg0-f180.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4FCECD3F.0010,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1338953019_2145P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <3773.1338953010.1@turing-police.cc.vt.edu>

Seen in my dmesg at boot:

[    0.682289] cryptomgr_test (30) used greatest stack depth: 6344 bytes left
[    0.683288] io scheduler noop registered
[    0.683292] io scheduler deadline registered
[    0.683294] ------------[ cut here ]------------
[    0.683300] WARNING: at block/blk-cgroup.c:867 blkcg_policy_register+0x41/0x10a()
[    0.683302] Hardware name: Latitude E6500
[    0.683305] Modules linked in:
[    0.683308] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc1-next-20120604 #25
[    0.683310] Call Trace:
[    0.683316]  [<ffffffff8102c7ce>] warn_slowpath_common+0x7e/0x96
[    0.683320]  [<ffffffff8102c7fb>] warn_slowpath_null+0x15/0x17
[    0.683324]  [<ffffffff8123d8a2>] blkcg_policy_register+0x41/0x10a
[    0.683329]  [<ffffffff81d4caca>] ? deadline_init+0x12/0x12
[    0.683332]  [<ffffffff81d4cb0c>] cfq_init+0x42/0x9f
[    0.683337]  [<ffffffff810001fa>] do_one_initcall+0x7a/0x130
[    0.683341]  [<ffffffff81d2fbdc>] do_initcalls+0xa7/0xc9
[    0.683344]  [<ffffffff81d2f5ed>] ? do_early_param+0x87/0x87
[    0.683348]  [<ffffffff81d2fcd4>] kernel_init+0xd6/0x147
[    0.683352]  [<ffffffff81603bb4>] kernel_thread_helper+0x4/0x10
[    0.683356]  [<ffffffff81055f99>] ? finish_task_switch+0x38/0x103
[    0.683360]  [<ffffffff815fc61d>] ? retint_restore_args+0xe/0xe
[    0.683364]  [<ffffffff81d2fbfe>] ? do_initcalls+0xc9/0xc9
[    0.683367]  [<ffffffff81603bb0>] ? gs_change+0xb/0xb
[    0.683376] ---[ end trace e93713a9d40cd06c ]---
[    0.683378] start plist test
[    0.687084] end plist test

Probably relevant...

% zgrep CGR /proc/config.gz
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
# CONFIG_CGROUP_MEM_RES_CTLR_KMEM is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NETPRIO_CGROUP=m


--==_Exmh_1338953019_2145P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT87NOwdmEQWDXROgAQI7Rw/+MVdxcOPiS30UAXOsS1CPNGDy8NnyoUzJ
Kom2Yh7p1qJtdqJjxOkVq/mjibyyGM3d/fl7SjLVL40H1bYHob5J8cysCDPFph3L
J9G1S7alYy0PBbKF7P/SduMErJd4U6Ya0rbd1cNEYccdrDz+0e+IozGO40jAPAOE
WmeJHLIstnbWFUviRa8M1zlEyu2BFfsIU8R1ZlP+f4U729p+pPUoqg6KSmxjiahV
+ZDSFEXCjWG5qIo9NkNoMW7DFHrpQ+cC0o6WgobdLaof1o+bUwsV+t/9oVSFoLjL
6fgDFdWgYOgPiCvl/e6kXVwmgBkYVJolF2waPMjnQYr80sdeBUP9NfRneY/xrolY
MBfZTa0DysMiLf2yV4XV4SSFrPSaUaqMXQyRf22D9xakxyqgza1g/FYO6kRDOKF8
EOIL8oRfkEXW8jj1oUsDbAwcRYfrrJ0tOYlgXqLXjKAElW0aOqx2nX6qYm7NlIWc
gkgZoy++CMV3uoFIg8OKfTgo2+qDBESAVUtxO7rmJqppT6XhOCpkaN/zrNS1sO7S
qn48Pq9ME6PoalT/i6hUSZaaJt6ro6W1ckZBnGpMD9h3MesQV+vtpMe/VV2j6sb7
5/lOWANGTnFguf2HY1GLbjXafYLH9nURIL7sa0T5rH5l9G66TAN0hsKqZlsCb6/8
zZMRX4DHTkk=
=MylC
-----END PGP SIGNATURE-----

--==_Exmh_1338953019_2145P--

