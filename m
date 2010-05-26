Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0EZNQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:16:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42853 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0EZNQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:16:00 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Subject: [cpufreq] Removing module 'cpufreq_stats' fails
Date: Wed, 26 May 2010 15:15:56 +0200
User-Agent: KMail/1.9.9
Cc: cpufreq@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005261515.57195.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

currently I'm trying to get some statistics about a Freescale i.MX25 CPU
frequency scaling driver. But when I'm loading the 'cpufreq_stats' driver no
'/sys/devices/system/cpu/cpu0/cpufreq/stats' directory occurs. Instead when I
try to unload the driver I get:

$ rmmod cpufreq_stats
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x54/0x114()
sysfs group bf000810 not found for kobject 'cpufreq'
Modules linked in: cpufreq_stats(-)
Backtrace:
[<c0029dbc>] (dump_backtrace+0x0/0x10c) from [<c02ab8cc>] (dump_stack+0x18/0x1c)
 r7:c39e1ed8 r6:c00e7828 r5:c0332243 r4:0000008a
[<c02ab8b4>] (dump_stack+0x0/0x1c) from [<c003e2d4>] (warn_slowpath_common+0x50/0x80)
[<c003e284>] (warn_slowpath_common+0x0/0x80) from [<c003e350>] (warn_slowpath_fmt+0x30/0x38)
 r7:00000880 r6:bf000810 r5:c38a3390 r4:00000000
[<c003e320>] (warn_slowpath_fmt+0x0/0x38) from [<c00e7828>] (sysfs_remove_group+0x54/0x114)
 r3:bf000810 r2:c0332254
[<c00e77d4>] (sysfs_remove_group+0x0/0x114) from [<bf00069c>] (cpufreq_stats_exit+0x54/0x9c [cpufreq_stats])
 r7:00000880 r6:c39e1f3c r5:c38a3340 r4:00000000
[<bf000648>] (cpufreq_stats_exit+0x0/0x9c [cpufreq_stats]) from [<c006c6fc>] (sys_delete_module+0x1e0/0x25c)
 r5:bf00086c r4:00000000
[<c006c51c>] (sys_delete_module+0x0/0x25c) from [<c0025fa0>] (ret_fast_syscall+0x0/0x28)
 r7:00000081 r6:00000000 r5:00000880 r4:be898c78
---[ end trace 1f4382bf2ce1570f ]---

I tried a bit with the module: When I load the 'cpufreq_stats' module its
cpufreq_stat_notifier_policy() is called three times: Two times with
'val != CPUFREQ_NOTIFY', and the third call the routine terminates due to
the call to 'cpufreq_frequency_get_table()' returns NULL. So, the sysfs
directory entries are never created, but the module still tries to remove them
when unloading.

jbe
