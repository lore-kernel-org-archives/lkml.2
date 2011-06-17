Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab1FQJY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:24:59 -0400
Received: from science.horizon.com ([71.41.210.146]:61964 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752712Ab1FQJY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:24:57 -0400
Date: 17 Jun 2011 05:24:54 -0400
Message-ID: <20110617092454.497.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: 3.0-rc3 stuck process in munmap()
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a followup to my report of firefox getting stuck in 3.0-rc1, here's the
problem repeated on -rc3.  top(1) can produce the process status, but
"ps axf" hangs before printing anything.

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
 2821 username  20   0 1453m 964m  18m D    0 47.8   1434:51 firefox-bin        

Core 2 duo, 2 GB RAM, NO_HZ=y, MZ=300, PREEMPT_VOLUNTARY=y.
It's been stuck for about half an hour so far.

I wasn't using Firefox when I noticed that it wasn't refreshing its
window when I changed to that screen.

I'm not going to reboot in case someone wants information gathered
this time.

INFO: task firefox-bin:9560 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
firefox-bin     D f4b2df58     0  9560   2793 0x00000000
 f54c2cb0 00000082 00000002 f4b2df58 00000000 00000000 00000000 00000000
 c14f22c0 f54c2e24 c14f22c0 00000000 00000000 b162f6a0 00000000 00000002
 00000001 f59ce208 000007fb f59c7268 acb9e000 acb9e000 00000000 c10735b3
Call Trace:
 [<c10735b3>] ? sys_madvise+0x42b/0x46c
 [<c1304a2d>] ? rwsem_down_failed_common+0xa1/0xc9
 [<c1304ab2>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c1304529>] ? down_write+0x1c/0x1e
 [<c107833a>] ? sys_munmap+0x18/0x35
 [<c1305410>] ? sysenter_do_call+0x12/0x26
 [<c1300000>] ? set_intr_gate+0xe/0x2d
INFO: task firefox-bin:9560 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
firefox-bin     D f4b2df58     0  9560   2793 0x00000000
 f54c2cb0 00000082 00000002 f4b2df58 00000000 00000000 00000000 00000000
 c14f22c0 f54c2e24 c14f22c0 00000000 00000000 b162f6a0 00000000 00000002
 00000001 f59ce208 000007fb f59c7268 acb9e000 acb9e000 00000000 c10735b3
Call Trace:
 [<c10735b3>] ? sys_madvise+0x42b/0x46c
 [<c1304a2d>] ? rwsem_down_failed_common+0xa1/0xc9
 [<c1304ab2>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c1304529>] ? down_write+0x1c/0x1e
 [<c107833a>] ? sys_munmap+0x18/0x35
 [<c1305410>] ? sysenter_do_call+0x12/0x26
 [<c1300000>] ? set_intr_gate+0xe/0x2d
INFO: task firefox-bin:9560 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
firefox-bin     D f4b2df58     0  9560   2793 0x00000000
 f54c2cb0 00000082 00000002 f4b2df58 00000000 00000000 00000000 00000000
 c14f22c0 f54c2e24 c14f22c0 00000000 00000000 b162f6a0 00000000 00000002
 00000001 f59ce208 000007fb f59c7268 acb9e000 acb9e000 00000000 c10735b3
Call Trace:
 [<c10735b3>] ? sys_madvise+0x42b/0x46c
 [<c1304a2d>] ? rwsem_down_failed_common+0xa1/0xc9
 [<c1304ab2>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c1304529>] ? down_write+0x1c/0x1e
 [<c107833a>] ? sys_munmap+0x18/0x35
 [<c1305410>] ? sysenter_do_call+0x12/0x26
 [<c1300000>] ? set_intr_gate+0xe/0x2d
INFO: task firefox-bin:9560 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
firefox-bin     D f4b2df58     0  9560   2793 0x00000000
 f54c2cb0 00000082 00000002 f4b2df58 00000000 00000000 00000000 00000000
 c14f22c0 f54c2e24 c14f22c0 00000000 00000000 b162f6a0 00000000 00000002
 00000001 f59ce208 000007fb f59c7268 acb9e000 acb9e000 00000000 c10735b3
Call Trace:
 [<c10735b3>] ? sys_madvise+0x42b/0x46c
 [<c1304a2d>] ? rwsem_down_failed_common+0xa1/0xc9
 [<c1304ab2>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c1304529>] ? down_write+0x1c/0x1e
 [<c107833a>] ? sys_munmap+0x18/0x35
 [<c1305410>] ? sysenter_do_call+0x12/0x26
 [<c1300000>] ? set_intr_gate+0xe/0x2d
INFO: task firefox-bin:9560 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
firefox-bin     D f4b2df58     0  9560   2793 0x00000000
 f54c2cb0 00000082 00000002 f4b2df58 00000000 00000000 00000000 00000000
 c14f22c0 f54c2e24 c14f22c0 00000000 00000000 b162f6a0 00000000 00000002
 00000001 f59ce208 000007fb f59c7268 acb9e000 acb9e000 00000000 c10735b3
Call Trace:
 [<c10735b3>] ? sys_madvise+0x42b/0x46c
 [<c1304a2d>] ? rwsem_down_failed_common+0xa1/0xc9
 [<c1304ab2>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c1304529>] ? down_write+0x1c/0x1e
 [<c107833a>] ? sys_munmap+0x18/0x35
 [<c1305410>] ? sysenter_do_call+0x12/0x26
 [<c1300000>] ? set_intr_gate+0xe/0x2d
INFO: task firefox-bin:9560 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
firefox-bin     D f4b2df58     0  9560   2793 0x00000000
 f54c2cb0 00000082 00000002 f4b2df58 00000000 00000000 00000000 00000000
 c14f22c0 f54c2e24 c14f22c0 00000000 00000000 b162f6a0 00000000 00000002
 00000001 f59ce208 000007fb f59c7268 acb9e000 acb9e000 00000000 c10735b3
Call Trace:
 [<c10735b3>] ? sys_madvise+0x42b/0x46c
 [<c1304a2d>] ? rwsem_down_failed_common+0xa1/0xc9
 [<c1304ab2>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c1304529>] ? down_write+0x1c/0x1e
 [<c107833a>] ? sys_munmap+0x18/0x35
 [<c1305410>] ? sysenter_do_call+0x12/0x26
 [<c1300000>] ? set_intr_gate+0xe/0x2d
INFO: task firefox-bin:9560 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
firefox-bin     D f4b2df58     0  9560   2793 0x00000000
 f54c2cb0 00000082 00000002 f4b2df58 00000000 00000000 00000000 00000000
 c14f22c0 f54c2e24 c14f22c0 00000000 00000000 b162f6a0 00000000 00000002
 00000001 f59ce208 000007fb f59c7268 acb9e000 acb9e000 00000000 c10735b3
Call Trace:
 [<c10735b3>] ? sys_madvise+0x42b/0x46c
 [<c1304a2d>] ? rwsem_down_failed_common+0xa1/0xc9
 [<c1304ab2>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c1304529>] ? down_write+0x1c/0x1e
 [<c107833a>] ? sys_munmap+0x18/0x35
 [<c1305410>] ? sysenter_do_call+0x12/0x26
 [<c1300000>] ? set_intr_gate+0xe/0x2d
INFO: task firefox-bin:9560 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
firefox-bin     D f4b2df58     0  9560   2793 0x00000000
 f54c2cb0 00000082 00000002 f4b2df58 00000000 00000000 00000000 00000000
 c14f22c0 f54c2e24 c14f22c0 00000000 00000000 b162f6a0 00000000 00000002
 00000001 f59ce208 000007fb f59c7268 acb9e000 acb9e000 00000000 c10735b3
Call Trace:
 [<c10735b3>] ? sys_madvise+0x42b/0x46c
 [<c1304a2d>] ? rwsem_down_failed_common+0xa1/0xc9
 [<c1304ab2>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c1304529>] ? down_write+0x1c/0x1e
 [<c107833a>] ? sys_munmap+0x18/0x35
 [<c1305410>] ? sysenter_do_call+0x12/0x26
 [<c1300000>] ? set_intr_gate+0xe/0x2d
INFO: task firefox-bin:9560 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
firefox-bin     D f4b2df58     0  9560   2793 0x00000000
 f54c2cb0 00000082 00000002 f4b2df58 00000000 00000000 00000000 00000000
 c14f22c0 f54c2e24 c14f22c0 00000000 00000000 b162f6a0 00000000 00000002
 00000001 f59ce208 000007fb f59c7268 acb9e000 acb9e000 00000000 c10735b3
Call Trace:
 [<c10735b3>] ? sys_madvise+0x42b/0x46c
 [<c1304a2d>] ? rwsem_down_failed_common+0xa1/0xc9
 [<c1304ab2>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c1304529>] ? down_write+0x1c/0x1e
 [<c107833a>] ? sys_munmap+0x18/0x35
 [<c1305410>] ? sysenter_do_call+0x12/0x26
 [<c1300000>] ? set_intr_gate+0xe/0x2d
INFO: task firefox-bin:9560 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
firefox-bin     D f4b2df58     0  9560   2793 0x00000000
 f54c2cb0 00000082 00000002 f4b2df58 00000000 00000000 00000000 00000000
 c14f22c0 f54c2e24 c14f22c0 00000000 00000000 b162f6a0 00000000 00000002
 00000001 f59ce208 000007fb f59c7268 acb9e000 acb9e000 00000000 c10735b3
Call Trace:
 [<c10735b3>] ? sys_madvise+0x42b/0x46c
 [<c1304a2d>] ? rwsem_down_failed_common+0xa1/0xc9
 [<c1304ab2>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c1304529>] ? down_write+0x1c/0x1e
 [<c107833a>] ? sys_munmap+0x18/0x35
 [<c1305410>] ? sysenter_do_call+0x12/0x26
 [<c1300000>] ? set_intr_gate+0xe/0x2d
