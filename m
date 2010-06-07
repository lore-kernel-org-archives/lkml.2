Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0FGHEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 03:04:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51283 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0FGHEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 03:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=P7AF49IQmtvbVsyaYZmcvzoPDtt1Nk+iScy7u8XBFJSCznk9dk+8tjORbPEM2HYEnk
         vUyOQ32LsqUfg45sUzrfcuOSRHoxXyxLENvyGcogh6PCOHEDTm+mssKnTC2uV550Fke7
         D38JWFq8XJ/HjOWv5eyy+YJ+D3bfz3OQOrrqY=
Date: Mon, 7 Jun 2010 00:04:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Spew in dmesg (BUG: using smp_processor_id() in preemptible code)
Message-ID: <20100607070438.GA2755@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Go tthe following trying to boot the today's pull from Linus:

BUG: using smp_processor_id() in preemptible [00000000] code:
S13cpuspeed/884
caller is nr_iowait_cpu+0x15/0x30
Pid: 884, comm: S13cpuspeed Tainted: P           2.6.35-rc0 #286
Call Trace:
 [<ffffffff81246484>] debug_smp_processor_id+0xd4/0xf0
 [<ffffffff81031635>] nr_iowait_cpu+0x15/0x30
 [<ffffffff8107acea>] update_ts_time_stats+0x6a/0x90
 [<ffffffff8107531b>] ? ktime_get+0x5b/0xe0
 [<ffffffff8107ae9f>] get_cpu_idle_time_us+0x4f/0x70
 [<ffffffff813a8bcc>] cpufreq_governor_dbs+0x20c/0x490
 [<ffffffff813a6ccd>] __cpufreq_governor+0xdd/0x1a0
 [<ffffffff813a58ed>] ? lock_policy_rwsem_write+0x4d/0x90
 [<ffffffff813a6f5f>] __cpufreq_set_policy+0x1cf/0x250
 [<ffffffff813a72e7>] store_scaling_governor+0xa7/0xd0
 [<ffffffff813a7580>] ? handle_update+0x0/0x40
 [<ffffffff8148d87d>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
 [<ffffffff813a6a52>] store+0x62/0x90
 [<ffffffff81189a9e>] sysfs_write_file+0x9e/0xf0
 [<ffffffff81122df8>] vfs_write+0xb8/0x1a0
 [<ffffffff810ac6f2>] ? audit_syscall_entry+0x282/0x2b0
 [<ffffffff8112381c>] sys_write+0x4c/0x80
 [<ffffffff81002f6b>] system_call_fastpath+0x16/0x1b

The tainit is coming from nvidia module.

Thanks.

-- 
Dmitry
