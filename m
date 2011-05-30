Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1E3HlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:41:21 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:57257 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755655Ab1E3HlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:41:18 -0400
Date: Mon, 30 May 2011 09:41:15 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org
Cc: cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        Thomas Renninger <trenn@suse.de>, linux-pm@lists.linux-foundation.org,
        lenb@kernel.org
Subject: Re: [git pull] cpupowerutils
Message-ID: <20110530074115.GA16638@isilmar-3.linta.de>
Mail-Followup-To: torvalds@osdl.org, cpufreq@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	mingo@elte.hu, Thomas Renninger <trenn@suse.de>,
	linux-pm@lists.linux-foundation.org, lenb@kernel.org
References: <20110524092500.GB28923@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524092500.GB28923@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

wouldn't the upcoming 3.0 kernel release be a wonderful reason to merge
a few more kernel-related utilities into your tree? Especially one such
project -- cpupowerutils -- which did ask to be merged one week ago, still
well within the merge window, but tragically got lost amid all the
discussions on how the next release shall be called?

Best,
	Dominik

On Tue, May 24, 2011 at 11:25:00AM +0200, Dominik Brodowski wrote:
> the git tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/brodo/cpupowerutils.git master
> 
> contains a new utility called "cpupowerutils" which is laregely based on
> the well known "cpufrequtils", but extended to provide much more information
> about other power-related features of modern CPUs, such as idle states.
> 
> Users and Developers want to have *one* tool to get an overview what
> their system supports and to monitor and debug CPU power management
> in detail. The tool should compile and work on as many architectures
> as possible.
> 
> To reach these goals, Thomas Renninger suggested -- and implemented most
> of the parts -- to convert the external tool cpufrequtils to a userspace
> tool residing in tools/power/cpupower/ .
> 
> Once this stabilizes, it is intended to replace cpufrequtils and the
> Intel-specific tools in tools/power/x86 .
> 
> A list of patches and the diffstat are appended to this messages.
> 
> Best,
> 	Dominik
> 
> 
> Dominik Brodowski (10):
>       cpupowerutils - cpufrequtils extended with quite some features
>       cpupowerutils: use COPYING, CREDITS from top-level directory
>       cpupowerutils: remove ccdv, use kernel quiet/verbose mechanism
>       cpupowerutils: do not update po files on each and every compile
>       cpupowerutils: bench - ConfigStyle bugfixes
>       cpupowerutils: lib - ConfigStyle bugfixes
>       cpupowerutils: idle_monitor - ConfigStyle bugfixes
>       cpupowerutils: helpers - ConfigStyle bugfixes
>       cpupowerutils: utils - ConfigStyle bugfixes
>       cpupowerutils: use kernel version-derived version string
> 
> Roman Vasiyarov (1):
>       cpupowerutils: increase MAX_LINE_LEN
> 
> Thomas Renninger (2):
>       cpupowerutils: Rename: libcpufreq->libcpupower
>       cpupower: Rename package from cpupowerutils to cpupower
> 
>  CREDITS                                            |   17 +-
>  MAINTAINERS                                        |    6 +
>  tools/power/cpupower/.gitignore                    |   22 +
>  tools/power/cpupower/Makefile                      |  279 ++++++
>  tools/power/cpupower/README                        |   49 +
>  tools/power/cpupower/ToDo                          |   11 +
>  tools/power/cpupower/bench/Makefile                |   29 +
>  tools/power/cpupower/bench/README-BENCH            |  124 +++
>  tools/power/cpupower/bench/benchmark.c             |  194 ++++
>  tools/power/cpupower/bench/benchmark.h             |   29 +
>  tools/power/cpupower/bench/config.h                |   36 +
>  tools/power/cpupower/bench/cpufreq-bench_plot.sh   |  104 +++
>  tools/power/cpupower/bench/cpufreq-bench_script.sh |  101 ++
>  tools/power/cpupower/bench/example.cfg             |   11 +
>  tools/power/cpupower/bench/main.c                  |  202 ++++
>  tools/power/cpupower/bench/parse.c                 |  225 +++++
>  tools/power/cpupower/bench/parse.h                 |   53 ++
>  tools/power/cpupower/bench/system.c                |  191 ++++
>  tools/power/cpupower/bench/system.h                |   29 +
>  tools/power/cpupower/debug/i386/Makefile           |   20 +
>  tools/power/cpupower/debug/i386/centrino-decode.c  |  113 +++
>  tools/power/cpupower/debug/i386/dump_psb.c         |  196 ++++
>  tools/power/cpupower/debug/i386/intel_gsic.c       |   78 ++
>  .../power/cpupower/debug/i386/powernow-k8-decode.c |   96 ++
>  tools/power/cpupower/debug/kernel/Makefile         |   23 +
>  .../power/cpupower/debug/kernel/cpufreq-test_tsc.c |  113 +++
>  tools/power/cpupower/debug/x86_64/Makefile         |   14 +
>  .../power/cpupower/debug/x86_64/centrino-decode.c  |    1 +
>  .../cpupower/debug/x86_64/powernow-k8-decode.c     |    1 +
>  tools/power/cpupower/lib/cpufreq.c                 |  208 +++++
>  tools/power/cpupower/lib/cpufreq.h                 |  223 +++++
>  tools/power/cpupower/lib/sysfs.c                   |  672 ++++++++++++++
>  tools/power/cpupower/lib/sysfs.h                   |   31 +
>  tools/power/cpupower/man/cpupower-frequency-info.1 |   76 ++
>  tools/power/cpupower/man/cpupower-frequency-set.1  |   54 ++
>  tools/power/cpupower/man/cpupower-info.1           |   19 +
>  tools/power/cpupower/man/cpupower-monitor.1        |  179 ++++
>  tools/power/cpupower/man/cpupower-set.1            |  103 +++
>  tools/power/cpupower/man/cpupower.1                |   72 ++
>  tools/power/cpupower/po/cs.po                      |  944 +++++++++++++++++++
>  tools/power/cpupower/po/de.po                      |  961 ++++++++++++++++++++
>  tools/power/cpupower/po/fr.po                      |  947 +++++++++++++++++++
>  tools/power/cpupower/po/it.po                      |  961 ++++++++++++++++++++
>  tools/power/cpupower/po/pt.po                      |  957 +++++++++++++++++++
>  tools/power/cpupower/utils/builtin.h               |   18 +
>  tools/power/cpupower/utils/cpufreq-info.c          |  678 ++++++++++++++
>  tools/power/cpupower/utils/cpufreq-set.c           |  358 ++++++++
>  tools/power/cpupower/utils/cpuidle-info.c          |  244 +++++
>  tools/power/cpupower/utils/cpupower-info.c         |  153 ++++
>  tools/power/cpupower/utils/cpupower-set.c          |  153 ++++
>  tools/power/cpupower/utils/cpupower.c              |  203 ++++
>  tools/power/cpupower/utils/helpers/amd.c           |  137 +++
>  tools/power/cpupower/utils/helpers/bitmask.c       |  292 ++++++
>  tools/power/cpupower/utils/helpers/bitmask.h       |   33 +
>  tools/power/cpupower/utils/helpers/cpuid.c         |  143 +++
>  tools/power/cpupower/utils/helpers/helpers.h       |  180 ++++
>  tools/power/cpupower/utils/helpers/misc.c          |   35 +
>  tools/power/cpupower/utils/helpers/msr.c           |  122 +++
>  tools/power/cpupower/utils/helpers/pci.c           |   44 +
>  tools/power/cpupower/utils/helpers/sysfs.c         |  358 ++++++++
>  tools/power/cpupower/utils/helpers/sysfs.h         |   28 +
>  tools/power/cpupower/utils/helpers/topology.c      |  108 +++
>  .../cpupower/utils/idle_monitor/amd_fam14h_idle.c  |  338 +++++++
>  .../cpupower/utils/idle_monitor/cpuidle_sysfs.c    |  196 ++++
>  .../cpupower/utils/idle_monitor/cpupower-monitor.c |  448 +++++++++
>  .../cpupower/utils/idle_monitor/cpupower-monitor.h |   68 ++
>  .../cpupower/utils/idle_monitor/idle_monitors.def  |    7 +
>  .../cpupower/utils/idle_monitor/idle_monitors.h    |   18 +
>  .../cpupower/utils/idle_monitor/mperf_monitor.c    |  255 ++++++
>  tools/power/cpupower/utils/idle_monitor/nhm_idle.c |  216 +++++
>  tools/power/cpupower/utils/idle_monitor/snb_idle.c |  190 ++++
>  tools/power/cpupower/utils/version-gen.sh          |   35 +
>  72 files changed, 13831 insertions(+), 1 deletions(-)
>  create mode 100644 tools/power/cpupower/.gitignore
>  create mode 100644 tools/power/cpupower/Makefile
>  create mode 100644 tools/power/cpupower/README
>  create mode 100644 tools/power/cpupower/ToDo
>  create mode 100644 tools/power/cpupower/bench/Makefile
>  create mode 100644 tools/power/cpupower/bench/README-BENCH
>  create mode 100644 tools/power/cpupower/bench/benchmark.c
>  create mode 100644 tools/power/cpupower/bench/benchmark.h
>  create mode 100644 tools/power/cpupower/bench/config.h
>  create mode 100644 tools/power/cpupower/bench/cpufreq-bench_plot.sh
>  create mode 100644 tools/power/cpupower/bench/cpufreq-bench_script.sh
>  create mode 100644 tools/power/cpupower/bench/example.cfg
>  create mode 100644 tools/power/cpupower/bench/main.c
>  create mode 100644 tools/power/cpupower/bench/parse.c
>  create mode 100644 tools/power/cpupower/bench/parse.h
>  create mode 100644 tools/power/cpupower/bench/system.c
>  create mode 100644 tools/power/cpupower/bench/system.h
>  create mode 100644 tools/power/cpupower/debug/i386/Makefile
>  create mode 100644 tools/power/cpupower/debug/i386/centrino-decode.c
>  create mode 100644 tools/power/cpupower/debug/i386/dump_psb.c
>  create mode 100644 tools/power/cpupower/debug/i386/intel_gsic.c
>  create mode 100644 tools/power/cpupower/debug/i386/powernow-k8-decode.c
>  create mode 100644 tools/power/cpupower/debug/kernel/Makefile
>  create mode 100644 tools/power/cpupower/debug/kernel/cpufreq-test_tsc.c
>  create mode 100644 tools/power/cpupower/debug/x86_64/Makefile
>  create mode 120000 tools/power/cpupower/debug/x86_64/centrino-decode.c
>  create mode 120000 tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
>  create mode 100644 tools/power/cpupower/lib/cpufreq.c
>  create mode 100644 tools/power/cpupower/lib/cpufreq.h
>  create mode 100644 tools/power/cpupower/lib/sysfs.c
>  create mode 100644 tools/power/cpupower/lib/sysfs.h
>  create mode 100644 tools/power/cpupower/man/cpupower-frequency-info.1
>  create mode 100644 tools/power/cpupower/man/cpupower-frequency-set.1
>  create mode 100644 tools/power/cpupower/man/cpupower-info.1
>  create mode 100644 tools/power/cpupower/man/cpupower-monitor.1
>  create mode 100644 tools/power/cpupower/man/cpupower-set.1
>  create mode 100644 tools/power/cpupower/man/cpupower.1
>  create mode 100644 tools/power/cpupower/po/cs.po
>  create mode 100644 tools/power/cpupower/po/de.po
>  create mode 100644 tools/power/cpupower/po/fr.po
>  create mode 100644 tools/power/cpupower/po/it.po
>  create mode 100644 tools/power/cpupower/po/pt.po
>  create mode 100644 tools/power/cpupower/utils/builtin.h
>  create mode 100644 tools/power/cpupower/utils/cpufreq-info.c
>  create mode 100644 tools/power/cpupower/utils/cpufreq-set.c
>  create mode 100644 tools/power/cpupower/utils/cpuidle-info.c
>  create mode 100644 tools/power/cpupower/utils/cpupower-info.c
>  create mode 100644 tools/power/cpupower/utils/cpupower-set.c
>  create mode 100644 tools/power/cpupower/utils/cpupower.c
>  create mode 100644 tools/power/cpupower/utils/helpers/amd.c
>  create mode 100644 tools/power/cpupower/utils/helpers/bitmask.c
>  create mode 100644 tools/power/cpupower/utils/helpers/bitmask.h
>  create mode 100644 tools/power/cpupower/utils/helpers/cpuid.c
>  create mode 100644 tools/power/cpupower/utils/helpers/helpers.h
>  create mode 100644 tools/power/cpupower/utils/helpers/misc.c
>  create mode 100644 tools/power/cpupower/utils/helpers/msr.c
>  create mode 100644 tools/power/cpupower/utils/helpers/pci.c
>  create mode 100644 tools/power/cpupower/utils/helpers/sysfs.c
>  create mode 100644 tools/power/cpupower/utils/helpers/sysfs.h
>  create mode 100644 tools/power/cpupower/utils/helpers/topology.c
>  create mode 100644 tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c
>  create mode 100644 tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c
>  create mode 100644 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
>  create mode 100644 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h
>  create mode 100644 tools/power/cpupower/utils/idle_monitor/idle_monitors.def
>  create mode 100644 tools/power/cpupower/utils/idle_monitor/idle_monitors.h
>  create mode 100644 tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
>  create mode 100644 tools/power/cpupower/utils/idle_monitor/nhm_idle.c
>  create mode 100644 tools/power/cpupower/utils/idle_monitor/snb_idle.c
>  create mode 100755 tools/power/cpupower/utils/version-gen.sh
