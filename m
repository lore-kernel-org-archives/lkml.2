Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0JQFvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 01:51:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57743 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab0JQFvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 01:51:21 -0400
Date: Sun, 17 Oct 2010 07:51:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile updates for v2.6.37
Message-ID: <20101017055112.GA9072@elte.hu>
References: <20101015134710.GF5969@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015134710.GF5969@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull for tip/perf/core:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> The main part here is the generalization of the perf event backend
> (currently arm and sh archs). Patches are for v2.6.37.
> 
> I did already a merge with tip/perf/core, so it should merge without
> conflicts.
> 
> There are still my oprofile x86 updates pending (mainly AMD IBS) that
> require my APIC patches to be applied to tip. As soon as they are in
> tip I will update the oprofile tree and send a further pull request.
> 
> Thanks,
> 
> -Robert
> 
> The following changes since commit 0fdf13606b67f830559abdaad15980c7f4f05ec4:
> 
> Anand Gadiyar (2):
>       oprofile: include platform_device.h to fix build break
>       oprofile: fix linker errors
> 
> Jiri Olsa (2):
>       oprofile, x86: Using struct stack_frame for 64bit processes dump
>       oprofile, x86: Adding backtrace dump for 32bit process in compat mode
> 
> Matt Fleming (7):
>       perf: Add helper function to return number of counters
>       perf: New helper function for pmu name
>       oprofile: Make op_name_from_perf_id() global
>       ARM: oprofile: Rename op_arm to oprofile_perf
>       ARM: oprofile: Move non-ARM code into separate init/exit
>       oprofile: Abstract the perf-events backend
>       sh: oprofile: Use perf-events oprofile backend
> 
> Robert Richter (17):
>       oprofile, arm: initialize perf_event pointers with NULL
>       Merge branch 'oprofile/urgent' into oprofile/core
>       oprofile, x86: Simplify init/exit functions
>       oprofile, ARM: Use oprofile_arch_exit() to cleanup on failure
>       oprofile, ARM: Rework op_create_counter()
>       oprofile, ARM: Remove some goto statements
>       oprofile: Remove duplicate code around __oprofilefs_create_file()
>       Merge branch 'oprofile/urgent' (early part) into oprofile/perf
>       oprofile, ARM: Release resources on failure
>       Merge branch 'oprofile/core' (early part) into oprofile/perf
>       oprofile, ARM: Remove some goto statements
>       oprofile, ARM: Rework op_create_counter()
>       oprofile, ARM: Use oprofile_arch_exit() to cleanup on failure
>       Merge branch 'oprofile/perf' into oprofile/core
>       oprofile: disable write access to oprofilefs while profiler is running
>       Merge remote branch 'tip/perf/core' into oprofile/core
>       oprofile: make !CONFIG_PM function stubs static inline
> 
> Will Deacon (2):
>       oprofile: don't call arch exit code from init code on failure
>       ARM: oprofile: fix and simplify init/exit functions
> 
>  arch/arm/kernel/perf_event.c      |    6 +
>  arch/arm/oprofile/Makefile        |    4 +
>  arch/arm/oprofile/common.c        |  311 +----------------------------------
>  arch/sh/Kconfig                   |   13 ++
>  arch/sh/kernel/perf_event.c       |   18 ++
>  arch/sh/oprofile/Makefile         |    4 +
>  arch/sh/oprofile/common.c         |  115 +++-----------
>  arch/sh/oprofile/op_impl.h        |   33 ----
>  arch/x86/oprofile/backtrace.c     |   70 +++++++--
>  arch/x86/oprofile/nmi_int.c       |    9 +-
>  drivers/oprofile/oprof.c          |   32 +---
>  drivers/oprofile/oprof.h          |    2 +-
>  drivers/oprofile/oprofile_files.c |    7 +-
>  drivers/oprofile/oprofile_perf.c  |  328 +++++++++++++++++++++++++++++++++++++
>  drivers/oprofile/oprofilefs.c     |   54 +++----
>  include/linux/oprofile.h          |    7 +
>  include/linux/perf_event.h        |    2 +
>  kernel/perf_event.c               |    5 +
>  18 files changed, 510 insertions(+), 510 deletions(-)
>  delete mode 100644 arch/sh/oprofile/op_impl.h
>  create mode 100644 drivers/oprofile/oprofile_perf.c

Pulled, thanks a lot Robert!

	Ingo
