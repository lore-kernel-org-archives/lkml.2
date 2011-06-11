Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1FKHRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 03:17:18 -0400
Received: from trent.utfs.org ([194.246.123.103]:55951 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1FKHRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 03:17:17 -0400
Date: Sat, 11 Jun 2011 00:17:11 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at ../kernel/printk.c:322
Message-ID: <alpine.DEB.2.01.1106110003030.9183@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after installing syslog-ng (v3.1.3 from Debian/stable (powerpc32)) on 
Linux 3.0-git, this is printed once in the logs when syslog-ng is started:


Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG (deprecated).
------------[ cut here ]------------
WARNING: at /usr/local/src/linux-2.6-git/kernel/printk.c:322
Modules linked in: therm_adt746x aes_generic sd_mod firewire_sbp2 scsi_mod 
arc4 b43 mac80211 i2c_powermac cfg80211
NIP: c0034190 LR: c0034190 CTR: 00000000
REGS: eea07c80 TRAP: 0700   Not tainted  (3.0.0-rc2-00251-g7f45e5c-dirty)
MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 22082442  XER: 20000000
TASK = ef2fd1d0[1444] 'syslog-ng' THREAD: eea06000
GPR00: c0034190 eea07d30 ef2fd1d0 0000005e 00000001 c00331d4 00000000 00000002 
GPR08: 00000000 ef2fd1d0 c005b278 00000001 48082428 100653a0 00000000 10016228 
GPR16: ffffffff 10004e68 00000000 00000000 00000000 ffffffe9 00000000 00000000 
GPR24: 107f2144 c0126524 eef543c0 c0126558 00000000 00000000 c057bd78 00000001 
NIP [c0034190] do_syslog+0x11c/0x638
LR [c0034190] do_syslog+0x11c/0x638
Call Trace:
[eea07d30] [c0034190] do_syslog+0x11c/0x638 (unreliable)
[eea07d90] [c0126578] kmsg_open+0x20/0x30
[eea07da0] [c01198c8] proc_reg_open+0xac/0x190
[eea07dd0] [c00c310c] __dentry_open+0x158/0x2bc
[eea07df0] [c00d4520] do_last+0x1d8/0x724
[eea07e30] [c00d5b90] path_openat+0xe4/0x410
[eea07e90] [c00d5fdc] do_filp_open+0x44/0xb0
[eea07f10] [c00c2ea8] do_sys_open+0x104/0x1e8
[eea07f40] [c0012214] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfacd008
    LR = 0xfaccfb8
Instruction dump:
3bc0ffff 4800af39 2f830000 41beff74 3fc0c058 3bdebd78 881e04b8 2f800001 
419eff54 3c60c04b 38638a24 483cccd9 <0fe00000> 38000001 981e04b8 4bffff38 
---[ end trace 5166675c35e74c71 ]---


The warning about the "deprecated CAP_SYS_ADMIN but no CAP_SYSLOG" 
message is known to the syslog-ng folks[0], but the WARNING above is a bit 
worrying. Anyone knows why it will generate this scary WARNING?

Christian.

[0] https://bugzilla.balabit.com/show_bug.cgi?id=108
-- 
BOFH excuse #247:

Due to Federal Budget problems we have been forced to cut back on the number of users able to access the system at one time. (namely none allowed....)
