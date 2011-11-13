Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1KMHzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 02:55:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65111 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1KMHzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 02:55:02 -0500
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: intel_idle causing 3.0.8 system reboot (was: if nolapic not used then system reboots after loading first module (possibly first irq using module))
Date: Sun, 13 Nov 2011 08:54:55 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-rc1-00252-g8f042aa-dirty; KDE/4.7.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
References: <201110272327.14891.a.miskiewicz@gmail.com> <201110281954.39191.a.miskiewicz@gmail.com> <CAJvTdKmCgbebEOY7Ly=cE1ZV2GVG7hL5fE8LmK9nz7r8+BNPJQ@mail.gmail.com>
In-Reply-To: <CAJvTdKmCgbebEOY7Ly=cE1ZV2GVG7hL5fE8LmK9nz7r8+BNPJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111130854.56201.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 of November 2011, Len Brown wrote:
> > intel_idle.max_cstate=2 also makes the problem go away.
> 
> Is the system running with BIOS SETUP defaults?

Tried also with "safe defaults (F8)" but that didn't help.

> Are there any BIOS SETUP options related to CPU idle states?

Yes, there are

"C state package limit setting" with values possible: Auto, C1, C3, C6, C7 
(set to "Auto" here)
"Intel EIST technology" -> Enabled
"C1E support" -> Enabled
"Intel C-STATE tech" -> Enabled
"C1 Auto Demotion" -> Enabled
"C3 Auto Demotion" -> Enabled

> please boot with intel_idle.max_cstate=0
> and send the output of these two commands:
> 
> dmesg |grep idle
> grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*

[root@berta ~]# dmesg |grep idle
[    0.000000] Command line: auto BOOT_IMAGE=pld3.0.8test ro root=812 
console=tty0 console=ttyS2,38400n81 panic=60 selinux=0 intel_idle.max_cstate=0
[    0.000000] Kernel command line: auto BOOT_IMAGE=pld3.0.8test ro root=812 
console=tty0 console=ttyS2,38400n81 panic=60 selinux=0 intel_idle.max_cstate=0
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.278494] using mwait in idle threads.
[    4.330321] intel_idle: disabled
[    5.794456] cpuidle: using governor ladder
[    5.806755] cpuidle: using governor menu
[root@berta ~]# LC_ALL=C grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*
grep: /sys/devices/system/cpu/cpu0/cpuidle/*/*: No such file or directory

There are only:
[root@berta ~]# LC_ALL=C grep . /sys/devices/system/cpu/cpuidle/*
/sys/devices/system/cpu/cpuidle/current_driver:none
/sys/devices/system/cpu/cpuidle/current_governor_ro:menu

> 
> thanks,
> Len Brown, Intel Open Source Technology Center
> 
> >> # cat /proc/cpuinfo
> >> processor       : 0
> >> vendor_id       : GenuineIntel
> >> cpu family      : 6
> >> model           : 30
> >> model name      : Intel(R) Xeon(R) CPU           X3430  @ 2.40GHz
> >> stepping        : 5


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
