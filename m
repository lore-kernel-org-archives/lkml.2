Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab2C2SnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:43:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44013 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2C2Sm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:42:57 -0400
MIME-Version: 1.0
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 29 Mar 2012 20:42:36 +0200
Message-ID: <CA+1xoqcziQ5th3Ui40qA4M82Ra5y==Wj5G9oi-0wBmJfYPvXzQ@mail.gmail.com>
Subject: vfs: hung task at path_openat
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I seem to be getting the spew at the bottom with latest linux-next.

Seems like all processes block within path_openat.

[ 3361.521323] INFO: task trinity:3095 blocked for more than 120 seconds.
[ 3361.522042] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3361.522746] trinity         D ffff880075280000  3248  3095      1 0x00000000
[ 3361.523458]  ffff880073debb88 0000000000000082 ffff880073debb18
ffff880075280000
[ 3361.524244]  ffff880073debfd8 00000000001d4580 ffff880073dea010
00000000001d4580
[ 3361.525068]  00000000001d4580 00000000001d4580 ffff880073debfd8
00000000001d4580
[ 3361.525813] Call Trace:
[ 3361.526084]  [<ffffffff82706114>] schedule+0x24/0x70
[ 3361.526488]  [<ffffffff827064e3>] schedule_preempt_disabled+0x13/0x20
[ 3361.527616]  [<ffffffff82704683>] __mutex_lock_common+0x1e3/0x5c0
[ 3361.528614]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.529437]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.530304]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.531140]  [<ffffffff82704b90>] mutex_lock_nested+0x40/0x50
[ 3361.531971]  [<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.532806]  [<ffffffff817c9a17>] ? security_inode_permission+0x17/0x20
[ 3361.533782]  [<ffffffff811f2579>] link_path_walk+0x119/0x3b0
[ 3361.534638]  [<ffffffff811eefd0>] ? generic_readlink+0xb0/0xb0
[ 3361.535501]  [<ffffffff81897568>] ? __raw_spin_lock_init+0x38/0x70
[ 3361.536412]  [<ffffffff811f2e2a>] path_openat+0xba/0x500
[ 3361.537185]  [<ffffffff810ed8a0>] ? sched_clock_cpu+0xd0/0x120
[ 3361.538035]  [<ffffffff811f3384>] do_filp_open+0x44/0xa0
[ 3361.538813]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.539642]  [<ffffffff82707ab0>] ? _raw_spin_unlock+0x30/0x60
[ 3361.540496]  [<ffffffff81202925>] ? alloc_fd+0x145/0x260
[ 3361.541290]  [<ffffffff811e23a3>] do_sys_open+0x103/0x1e0
[ 3361.542096]  [<ffffffff811e24bc>] sys_open+0x1c/0x20
[ 3361.542795]  [<ffffffff82708a39>] system_call_fastpath+0x16/0x1b
[ 3361.543678] 1 lock held by trinity/3095:
[ 3361.544260]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at:
[<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.545648] INFO: task trinity:3097 blocked for more than 120 seconds.
[ 3361.546594] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3361.547715] trinity         D ffff880073e23000  3648  3097      1 0x00000000
[ 3361.548784]  ffff880073e31b88 0000000000000082 ffff880073e31b18
ffff880073e23000
[ 3361.549937]  ffff880073e31fd8 00000000001d4580 ffff880073e30010
00000000001d4580
[ 3361.551123]  00000000001d4580 00000000001d4580 ffff880073e31fd8
00000000001d4580
[ 3361.552199] Call Trace:
[ 3361.552406]  [<ffffffff82706114>] schedule+0x24/0x70
[ 3361.552810]  [<ffffffff827064e3>] schedule_preempt_disabled+0x13/0x20
[ 3361.553390]  [<ffffffff82704683>] __mutex_lock_common+0x1e3/0x5c0
[ 3361.554126]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.554898]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.555756]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.556546]  [<ffffffff82704b90>] mutex_lock_nested+0x40/0x50
[ 3361.557393]  [<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.558193]  [<ffffffff817c9a17>] ? security_inode_permission+0x17/0x20
[ 3361.559157]  [<ffffffff811f2579>] link_path_walk+0x119/0x3b0
[ 3361.559970]  [<ffffffff811eefd0>] ? generic_readlink+0xb0/0xb0
[ 3361.560841]  [<ffffffff81897568>] ? __raw_spin_lock_init+0x38/0x70
[ 3361.561767]  [<ffffffff811f2e2a>] path_openat+0xba/0x500
[ 3361.562570]  [<ffffffff810ed8a0>] ? sched_clock_cpu+0xd0/0x120
[ 3361.563458]  [<ffffffff811f3384>] do_filp_open+0x44/0xa0
[ 3361.564318]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.565155]  [<ffffffff82707ab0>] ? _raw_spin_unlock+0x30/0x60
[ 3361.566055]  [<ffffffff81202925>] ? alloc_fd+0x145/0x260
[ 3361.566836]  [<ffffffff811e23a3>] do_sys_open+0x103/0x1e0
[ 3361.567650]  [<ffffffff811e24bc>] sys_open+0x1c/0x20
[ 3361.568376]  [<ffffffff82708a39>] system_call_fastpath+0x16/0x1b
[ 3361.569335] 1 lock held by trinity/3097:
[ 3361.569919]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at:
[<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.571328] INFO: task trinity:3099 blocked for more than 120 seconds.
[ 3361.572270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3361.573403] trinity         D ffff880073e3b000  3992  3099      1 0x00000000
[ 3361.574478]  ffff880073e85b88 0000000000000082 ffff880073e85b18
ffff880073e3b000
[ 3361.575708]  ffff880073e85fd8 00000000001d4580 ffff880073e84010
00000000001d4580
[ 3361.576932]  00000000001d4580 00000000001d4580 ffff880073e85fd8
00000000001d4580
[ 3361.578211] Call Trace:33175 99%
[ 3361.578582]  [<ffffffff82706114>] schedule+0x24/0x70
[ 3361.579393]  [<ffffffff827064e3>] schedule_preempt_disabled+0x13/0x20
[ 3361.580410]  [<ffffffff82704683>] __mutex_lock_common+0x1e3/0x5c0
[ 3361.581382]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.582270]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.583161]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.583962]  [<ffffffff82704b90>] mutex_lock_nested+0x40/0x50
[ 3361.584887]  [<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.585737]  [<ffffffff817c9a17>] ? security_inode_permission+0x17/0x20
[ 3361.586448]  [<ffffffff811f2579>] link_path_walk+0x119/0x3b0
[ 3361.587180]  [<ffffffff811eefd0>] ? generic_readlink+0xb0/0xb0
[ 3361.587994]  [<ffffffff81897568>] ? __raw_spin_lock_init+0x38/0x70
[ 3361.588542]  [<ffffffff811f2e2a>] path_openat+0xba/0x500
[ 3361.589308]  [<ffffffff810ed8a0>] ? sched_clock_cpu+0xd0/0x120
[ 3361.590180]  [<ffffffff811f3384>] do_filp_open+0x44/0xa0
[ 3361.590952]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.591782]  [<ffffffff82707ab0>] ? _raw_spin_unlock+0x30/0x60
[ 3361.592663]  [<ffffffff81202925>] ? alloc_fd+0x145/0x260
[ 3361.593459]  [<ffffffff811e23a3>] do_sys_open+0x103/0x1e0
[ 3361.594277]  [<ffffffff811e24bc>] sys_open+0x1c/0x20
[ 3361.595056]  [<ffffffff82708a39>] system_call_fastpath+0x16/0x1b
[ 3361.595951] 1 lock held by trinity/3099:
[ 3361.596567]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at:
[<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.597983] INFO: task trinity:3101 blocked for more than 120 seconds.
[ 3361.598977] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3361.600134] trinity         D ffff880073e38000  3552  3101      1 0x00000000
[ 3361.601188]  ffff880073df1b88 0000000000000082 ffff880073df1b18
ffff880073e38000
[ 3361.602386]  ffff880073df1fd8 00000000001d4580 ffff880073df0010
00000000001d4580
[ 3361.603566]  00000000001d4580 00000000001d4580 ffff880073df1fd8
00000000001d4580
[ 3361.604539] Call Trace:33175 99%
[ 3361.604756]  [<ffffffff82706114>] schedule+0x24/0x70
[ 3361.605209]  [<ffffffff827064e3>] schedule_preempt_disabled+0x13/0x20
[ 3361.605860]  [<ffffffff82704683>] __mutex_lock_common+0x1e3/0x5c0
[ 3361.606772]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.607558]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.608380]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.609181]  [<ffffffff82704b90>] mutex_lock_nested+0x40/0x50
[ 3361.610055]  [<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.610819]  [<ffffffff817c9a17>] ? security_inode_permission+0x17/0x20
[ 3361.611787]  [<ffffffff811f2579>] link_path_walk+0x119/0x3b0
[ 3361.612624]  [<ffffffff811eefd0>] ? generic_readlink+0xb0/0xb0
[ 3361.613477]  [<ffffffff81897568>] ? __raw_spin_lock_init+0x38/0x70
[ 3361.614387]  [<ffffffff811f2e2a>] path_openat+0xba/0x500
[ 3361.615154]  [<ffffffff810ed8a0>] ? sched_clock_cpu+0xd0/0x120
[ 3361.615988]  [<ffffffff811f3384>] do_filp_open+0x44/0xa0
[ 3361.616463]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.617190]  [<ffffffff82707ab0>] ? _raw_spin_unlock+0x30/0x60
[ 3361.618071]  [<ffffffff81202925>] ? alloc_fd+0x145/0x260
[ 3361.618858]  [<ffffffff811e23a3>] do_sys_open+0x103/0x1e0
[ 3361.619677]  [<ffffffff811e24bc>] sys_open+0x1c/0x20
[ 3361.620473]  [<ffffffff82708a39>] system_call_fastpath+0x16/0x1b
[ 3361.621376] 1 lock held by trinity/3101:
[ 3361.621957]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at:
[<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.623184] INFO: task trinity:3103 blocked for more than 120 seconds.
[ 3361.623799] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3361.624492] trinity         D ffff880073ea3000  3560  3103      1 0x00000000
[ 3361.625313]  ffff880073e93b88 0000000000000082 ffff880073e93b18
ffff880073ea3000
[ 3361.626272]  ffff880073e93fd8 00000000001d4580 ffff880073e92010
00000000001d4580
[ 3361.627326]  00000000001d4580 00000000001d4580 ffff880073e93fd8
00000000001d4580
[ 3361.628472] Call Trace:33175 99%
[ 3361.628838]  [<ffffffff82706114>] schedule+0x24/0x70
[ 3361.629582]  [<ffffffff827064e3>] schedule_preempt_disabled+0x13/0x20
[ 3361.630541]  [<ffffffff82704683>] __mutex_lock_common+0x1e3/0x5c0
[ 3361.631450]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.632263]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.633112]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.633912]  [<ffffffff82704b90>] mutex_lock_nested+0x40/0x50
[ 3361.634797]  [<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.635281]  [<ffffffff817c9a17>] ? security_inode_permission+0x17/0x20
[ 3361.636006]  [<ffffffff811f2579>] link_path_walk+0x119/0x3b0
[ 3361.636527]  [<ffffffff811eefd0>] ? generic_readlink+0xb0/0xb0
[ 3361.637050]  [<ffffffff81897568>] ? __raw_spin_lock_init+0x38/0x70
[ 3361.637556]  [<ffffffff811f2e2a>] path_openat+0xba/0x500
[ 3361.638317]  [<ffffffff810ed8a0>] ? sched_clock_cpu+0xd0/0x120
[ 3361.639177]  [<ffffffff811f3384>] do_filp_open+0x44/0xa0
[ 3361.639962]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.640792]  [<ffffffff82707ab0>] ? _raw_spin_unlock+0x30/0x60
[ 3361.641657]  [<ffffffff81202925>] ? alloc_fd+0x145/0x260
[ 3361.642542]  [<ffffffff811e23a3>] do_sys_open+0x103/0x1e0
[ 3361.643340]  [<ffffffff811e24bc>] sys_open+0x1c/0x20
[ 3361.644100]  [<ffffffff82708a39>] system_call_fastpath+0x16/0x1b
[ 3361.644981] 1 lock held by trinity/3103:
[ 3361.645595]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at:
[<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.647046] INFO: task trinity:3105 blocked for more than 120 seconds.
[ 3361.647966] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3361.649152] trinity         D ffff880073ea0000  3816  3105      1 0x00000000
[ 3361.650237]  ffff880073ec9b88 0000000000000082 ffff880073ec9b18
ffff880073ea0000
[ 3361.651385]  ffff880073ec9fd8 00000000001d4580 ffff880073ec8010
00000000001d4580
[ 3361.652581]  00000000001d4580 00000000001d4580 ffff880073ec9fd8
00000000001d4580
[ 3361.653467] Call Trace:33175 99%
[ 3361.653720]  [<ffffffff82706114>] schedule+0x24/0x70
[ 3361.654234]  [<ffffffff827064e3>] schedule_preempt_disabled+0x13/0x20
[ 3361.654798]  [<ffffffff82704683>] __mutex_lock_common+0x1e3/0x5c0
[ 3361.655774]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.656284]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.656736]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.657236]  [<ffffffff82704b90>] mutex_lock_nested+0x40/0x50
[ 3361.657734]  [<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.658209]  [<ffffffff817c9a17>] ? security_inode_permission+0x17/0x20
[ 3361.658741]  [<ffffffff811f2579>] link_path_walk+0x119/0x3b0
[ 3361.659264]  [<ffffffff811eefd0>] ? generic_readlink+0xb0/0xb0
[ 3361.659751]  [<ffffffff81897568>] ? __raw_spin_lock_init+0x38/0x70
[ 3361.660299]  [<ffffffff811f2e2a>] path_openat+0xba/0x500
[ 3361.660733]  [<ffffffff810ed8a0>] ? sched_clock_cpu+0xd0/0x120
[ 3361.661304]  [<ffffffff811f3384>] do_filp_open+0x44/0xa0
[ 3361.661750]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.662682]  [<ffffffff82707ab0>] ? _raw_spin_unlock+0x30/0x60
[ 3361.663560]  [<ffffffff81202925>] ? alloc_fd+0x145/0x260
[ 3361.664356]  [<ffffffff811e23a3>] do_sys_open+0x103/0x1e0
[ 3361.665171]  [<ffffffff811e24bc>] sys_open+0x1c/0x20
[ 3361.665918]  [<ffffffff82708a39>] system_call_fastpath+0x16/0x1b
[ 3361.666834] 1 lock held by trinity/3105:
[ 3361.667437]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at:
[<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.668848] INFO: task kworker/u:2:16016 blocked for more than 120 seconds.
[ 3361.669982] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 3361.671108] kworker/u:2     D ffff88006b2b3000  5416 16016  12176 0x00000000
[ 3361.672230]  ffff8800063c19c0 0000000000000082 ffff8800063c1950
ffff88006b2b3000
[ 3361.673378]  ffff8800063c1fd8 00000000001d4580 ffff8800063c0010
00000000001d4580
[ 3361.674560]  00000000001d4580 00000000001d4580 ffff8800063c1fd8
00000000001d4580
[ 3361.675738] Call Trace:33175 99%
[ 3361.676108]  [<ffffffff82706114>] schedule+0x24/0x70
[ 3361.676803]  [<ffffffff827064e3>] schedule_preempt_disabled+0x13/0x20
[ 3361.677782]  [<ffffffff82704683>] __mutex_lock_common+0x1e3/0x5c0
[ 3361.678670]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.679455]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.680264]  [<ffffffff811f1480>] ? do_lookup+0x260/0x3b0
[ 3361.681109]  [<ffffffff82704b90>] mutex_lock_nested+0x40/0x50
[ 3361.681957]  [<ffffffff811f1480>] do_lookup+0x260/0x3b0
[ 3361.682838]  [<ffffffff817c9a17>] ? security_inode_permission+0x17/0x20
[ 3361.683862]  [<ffffffff811f2579>] link_path_walk+0x119/0x3b0
[ 3361.684709]  [<ffffffff811eefd0>] ? generic_readlink+0xb0/0xb0
[ 3361.685561]  [<ffffffff81897568>] ? __raw_spin_lock_init+0x38/0x70
[ 3361.686483]  [<ffffffff811f2e2a>] path_openat+0xba/0x500
[ 3361.687278]  [<ffffffff81057263>] ? sched_clock+0x13/0x20
[ 3361.687722]  [<ffffffff810ed765>] ? sched_clock_local+0x25/0x90
[ 3361.688582]  [<ffffffff810ed8a0>] ? sched_clock_cpu+0xd0/0x120
[ 3361.689456]  [<ffffffff811f3384>] do_filp_open+0x44/0xa0
[ 3361.690222]  [<ffffffff81119abd>] ? __lock_release+0x8d/0x1d0
[ 3361.691097]  [<ffffffff810e3531>] ? get_parent_ip+0x11/0x50
[ 3361.691906]  [<ffffffff810e38fd>] ? sub_preempt_count+0x9d/0xd0
[ 3361.692857]  [<ffffffff82707ab0>] ? _raw_spin_unlock+0x30/0x60
[ 3361.693733]  [<ffffffff811eb0fd>] open_exec+0x2d/0xf0
[ 3361.694465]  [<ffffffff811ec238>] do_execve_common+0x128/0x320
[ 3361.695313]  [<ffffffff811ec4b5>] do_execve+0x35/0x40
[ 3361.696083]  [<ffffffff810589f5>] sys_execve+0x45/0x70
[ 3361.696842]  [<ffffffff82709ee8>] kernel_execve+0x68/0xd0
[ 3361.697663]  [<ffffffff810cd5e6>] ? ____call_usermodehelper+0xf6/0x130
[ 3361.698641]  [<ffffffff810cd639>] call_helper+0x19/0x20
[ 3361.699419]  [<ffffffff82709e74>] kernel_thread_helper+0x4/0x10
[ 3361.700206]  [<ffffffff810e3ee0>] ? finish_task_switch+0x80/0x110
[ 3361.700782]  [<ffffffff82708174>] ? retint_restore_args+0x13/0x13
[ 3361.701676]  [<ffffffff810cd620>] ? ____call_usermodehelper+0x130/0x130
[ 3361.702473]  [<ffffffff82709e70>] ? gs_change+0x13/0x13
[ 3361.703258] 2 locks held by kworker/u:2/16016:
[ 3361.703895]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at:
[<ffffffff811e9872>] prepare_bprm_creds+0x32/0x80
[ 3361.705376]  #1:  (&type->i_mutex_dir_key){+.+.+.}, at:
[<ffffffff811f1480>] do_lookup+0x260/0x3b0
