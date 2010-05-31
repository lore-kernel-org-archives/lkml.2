Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0EaUhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:37:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35412 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0EaUhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=bkyfZke3oLLHnMN9EaZGnvmN04NVDvsE82nZP8SpxFlAq6VCAMiJsgloDB8xVRvLOg
         yvGm1HJ5cQtw1EsRO1wUzRDkWlxmjUR8xA9vsviKZsaB8gqAksGIM9H36guwAOwvYZRw
         0GJXUaBMiOXxfKe/DvRptNFLpTWh6YLP5FOQ8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Regression] [2.6.35-rc1][suspend to ram] BUG: using smp_processor_id() in preemptible [00000000] code: cat/3634
Date: Mon, 31 May 2010 22:37:01 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005312237.01725.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 2.6.34
Failing kernel: 2.6.35-rc1

More info:
After resume from suspend to ram I saw this message in dmesg:
[  484.658275] BUG: using smp_processor_id() in preemptible [00000000] code: 
cat/3634
[  484.658285] caller is nr_iowait_cpu+0xe/0x1e
[  484.658288] Pid: 3634, comm: cat Not tainted 2.6.35-rc1 #1
[  484.658291] Call Trace:
[  484.658298]  [<c0369776>] ? printk+0xf/0x11
[  484.658304]  [<c0215eb1>] debug_smp_processor_id+0xa5/0xbc
[  484.658308]  [<c011ff7b>] nr_iowait_cpu+0xe/0x1e
[  484.658314]  [<c01464aa>] update_ts_time_stats+0x32/0x8d
[  484.658317]  [<c0142179>] ? ktime_get+0x5f/0xce
[  484.658321]  [<c0146653>] get_cpu_idle_time_us+0x36/0x62
[  484.658326]  [<c02f5970>] cpufreq_governor_dbs+0xc3/0x3df
[  484.658332]  [<c01cd2fc>] ? ext3_mark_iloc_dirty+0x2a6/0x306
[  484.658337]  [<c025bc75>] ? acpi_processor_ppc_notifier+0x90/0x95
[  484.658341]  [<c013ecda>] ? notifier_call_chain+0x26/0x50
[  484.658346]  [<c02f339d>] __cpufreq_governor+0x97/0xcb
[  484.658349]  [<c02f3dd2>] ? lock_policy_rwsem_write+0x33/0x59
[  484.658353]  [<c02f4170>] __cpufreq_set_policy+0x104/0x13c
[  484.658357]  [<c02f451c>] store_scaling_governor+0x154/0x178
[  484.658362]  [<c02f4a43>] ? handle_update+0x0/0xd
[  484.658366]  [<c02f3dd2>] ? lock_policy_rwsem_write+0x33/0x59
[  484.658370]  [<c02f43c8>] ? store_scaling_governor+0x0/0x178
[  484.658374]  [<c02f4053>] store+0x42/0x5b
[  484.658378]  [<c01c79b2>] sysfs_write_file+0xbc/0xe7
[  484.658383]  [<c018c27c>] vfs_write+0x8a/0x112
[  484.658386]  [<c01c78f6>] ? sysfs_write_file+0x0/0xe7
[  484.658390]  [<c018c39b>] sys_write+0x3b/0x60
[  484.658394]  [<c01026ec>] sysenter_do_call+0x12/0x22

After this system works.

Suspend to disk seems be OK.

Config:
http://unixy.pl/maciek/download/kernel/2.6.35-rc1/zlom/config-2.6.35-rc1

Dmesg:
http://unixy.pl/maciek/download/kernel/2.6.35-rc1/zlom/dmesg-2.6.35-rc1.txt

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
