Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab0EaGns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 02:43:48 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37973 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab0EaGnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 02:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=x0o+DUySuUZTLZMjlriHvR3Pl/XQVLyTxYaMrkdSNhObtUdHnfd11ZaV+6JnqqnGpi
         hzZggu3LiTQOPfhry9FCBM2AODFgphJkkUkBiIJXg/OPzli2mDukKn6PKWdBkcBFtNwL
         xd+vYtUNuW/5MRMGdlfODOEELbyenrUBELdcE=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTilTnAAZIizKinYsxFkNTkrmPqk6XJJuUjjhJ7EP@mail.gmail.com>
References: <AANLkTilTnAAZIizKinYsxFkNTkrmPqk6XJJuUjjhJ7EP@mail.gmail.com>
Date: Mon, 31 May 2010 08:43:43 +0200
Message-ID: <AANLkTimj_kruEyL3Ac7xJZt0tunTua6JDBcuAU7XbWoP@mail.gmail.com>
Subject: Re: 2.6.35-rc1: Call trace: BUG: using smp_processor_id() in 
	preemptible [00000000] code: cpufreq-set/2344 (cpufreq-releated?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       markgross <mgross@linux.intel.com>, dmonakhov@openvz.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn!
Sorry, I have found the following fix at cpufreq ML from Dmitry Monakhov [1].

I will try it and report.

- Sedat -

[1] "[PATCH] cpufreq: call nr_iowait_cpu with disabled preemption"
http://www.spinics.net/lists/cpufreq/msg01631.html

On Mon, May 31, 2010 at 8:27 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> with 2.6.35-rc1 I get a cpufreq-related Call trace on startup on a
> 32-bit Debian/sid system.
>
> Below I added (see investigations at the end):
>
> 1. the version of cpufrequtils I am using
> 2. an output of cpufreq-related loaded kernel-modules
> 3. an output of cpufreq-related setting in kernel-config
>
> Furthermore, I have attched the full dmesg output and kernel-config file.
>
> Here is the Call trace:
>
> [   31.647049] BUG: using smp_processor_id() in preemptible [00000000]
> code: cpufreq-set/2344
> [   31.647299] caller is nr_iowait_cpu+0xb/0x1a
> [   31.647303] Pid: 2344, comm: cpufreq-set Not tainted
> 2.6.35-rc1-iniza-686-kms #1
> [   31.647306] Call Trace:
> [   31.647314]  [<c111fdd9>] ? debug_smp_processor_id+0xa5/0xb8
> [   31.647319]  [<c1022f93>] ? nr_iowait_cpu+0xb/0x1a
> [   31.647325]  [<c104a93c>] ? update_ts_time_stats+0x36/0x92
> [   31.647329]  [<c1045fcb>] ? ktime_get+0x5b/0xd9
> [   31.647333]  [<c104aae9>] ? get_cpu_idle_time_us+0x36/0x62
> [   31.647340]  [<f94e433d>] ? get_cpu_idle_time+0x12/0x127 [cpufreq_ondemand]
> [   31.647345]  [<c10dea11>] ? sysfs_add_file_mode+0x48/0x66
> [   31.647350]  [<c10e0827>] ? internal_create_group+0xcf/0x134
> [   31.647355]  [<f94e4a3b>] ? cpufreq_governor_dbs+0xaa/0x2a3
> [cpufreq_ondemand]
> [   31.647361]  [<c119d94a>] ? __cpufreq_governor+0x2c/0x63
> [   31.647365]  [<c119e80a>] ? __cpufreq_set_policy+0xea/0x11d
> [   31.647370]  [<c119ea74>] ? store_scaling_governor+0x58/0x7c
> [   31.647375]  [<c119ee09>] ? handle_update+0x0/0x8
> [   31.647381]  [<c1225d70>] ? _raw_spin_unlock_irqrestore+0x22/0x2c
> [   31.647385]  [<c119ea1c>] ? store_scaling_governor+0x0/0x7c
> [   31.647389]  [<c119e708>] ? store+0x3c/0x54
> [   31.647393]  [<c10de76d>] ? sysfs_write_file+0xb8/0xe5
> [   31.647397]  [<c10de6b5>] ? sysfs_write_file+0x0/0xe5
> [   31.647403]  [<c109f7c6>] ? vfs_write+0x7f/0xda
> [   31.647408]  [<c101dad8>] ? do_page_fault+0x1fb/0x25f
> [   31.647412]  [<c109f8b4>] ? sys_write+0x3c/0x60
> [   31.647417]  [<c1002e18>] ? sysenter_do_call+0x12/0x28
>
> Hope this helps fixing the problem.
>
> Kind Regards,
> - Sedat -
>
> P.S.:
> Recently I watched a video with a speeh of Greg K-H [1] and extracted
> the maintainers/contributors via:
>
> $ ./scripts/get_maintainer.pl -f drivers/cpuidle/governors/menu.c <---
> nr_iowait_cpu()
> $ ./scripts/get_maintainer.pl -f drivers/cpufreq/cpufreq_ondemand.c
> <--- [cpufreq_ondemand]
>
> [1] Write and Submit your first Linux kernel Patch:
> http://fosdem.org/2010/schedule/events/linuxkernelpatch
>
> ------ INVESTIGATIONS -----
>
> $ env COLUMNS=120 dpkg -l | grep -i cpufreq
> ii  cpufrequtils             007-1                    utilities to
> deal with the cpufreq Linux kernel feature
> ii  libcpufreq0              007-1                    shared library
> to deal with the cpufreq Linux kernel feature
>
> $ sudo lsmod | grep freq | sort
> acpi_cpufreq            4343  1
> cpufreq_conservative     6260  0
> cpufreq_ondemand        5810  2
> cpufreq_performance      590  0
> cpufreq_powersave        582  0
> cpufreq_stats           1969  0
> freq_table              1647  3 acpi_cpufreq,cpufreq_ondemand,cpufreq_stats
> mperf                    899  1 acpi_cpufreq
> processor              22099  3 acpi_cpufreq
>
> $ grep -i freq /boot/config-2.6.35-rc1-iniza-686-kms | grep -i cpu
> # CPU Frequency scaling
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=m
> # CONFIG_CPU_FREQ_DEBUG is not set
> CONFIG_CPU_FREQ_STAT=m
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=m
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
> # CPUFreq processor drivers
> # CONFIG_X86_PCC_CPUFREQ is not set
> CONFIG_X86_ACPI_CPUFREQ=m
> CONFIG_X86_CPUFREQ_NFORCE2=m
>
