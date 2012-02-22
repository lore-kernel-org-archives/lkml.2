Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2BVXoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 18:44:01 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65281 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2BVXoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 18:44:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kjwinchester@gmail.com designates 10.205.124.15 as permitted sender) smtp.mail=kjwinchester@gmail.com; dkim=pass header.i=kjwinchester@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329953551-17074-1-git-send-email-kjwinchester@gmail.com>
References: <20120222092745.GA30339@elte.hu>
	<1329953551-17074-1-git-send-email-kjwinchester@gmail.com>
Date: Wed, 22 Feb 2012 19:43:58 -0400
Message-ID: <CAELBVzC8P2kqSJ2XMUQ7cAogL28Ep2ZBY2zFrCqKSFbL=3yD5A@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] x86: Cleanup and simplify cpu-specific data
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2012 19:32, Kevin Winchester <kjwinchester@gmail.com> wrote:
> Kevin Winchester (5):
>  x86: Move per cpu cpu_llc_shared_map to a field in struct cpuinfo_x86
>  x86: Move per cpu cpu_llc_id to a field in struct cpuinfo_x86
>  x86: Move per cpu cpu_sibling_map to a field in struct cpuinfo_x86
>  x86: Move per cpu cpu_core_map to a field in struct cpuinfo_x86
>  x86: Remove #ifdef CONFIG_SMP sections by moving smp_num_siblings
>    into common.c
>
>  arch/x86/include/asm/perf_event_p4.h  |   14 +----
>  arch/x86/include/asm/processor.h      |   10 ++++
>  arch/x86/include/asm/smp.h            |   26 +---------
>  arch/x86/include/asm/topology.h       |   10 ++--
>  arch/x86/kernel/apic/apic_numachip.c  |    2 +-
>  arch/x86/kernel/cpu/amd.c             |   18 ++-----
>  arch/x86/kernel/cpu/common.c          |    7 ++-
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   19 ++-----
>  arch/x86/kernel/cpu/mcheck/mce_amd.c  |    9 ++--
>  arch/x86/kernel/cpu/perf_event_p4.c   |    4 +-
>  arch/x86/kernel/cpu/proc.c            |    8 +--
>  arch/x86/kernel/cpu/topology.c        |    2 -
>  arch/x86/kernel/process.c             |    3 +-
>  arch/x86/kernel/smpboot.c             |   95 +++++++++++++--------------------
>  arch/x86/oprofile/nmi_int.c           |    6 --
>  arch/x86/oprofile/op_model_p4.c       |   11 +----
>  arch/x86/xen/smp.c                    |    6 --
>  drivers/cpufreq/acpi-cpufreq.c        |    2 +-
>  drivers/cpufreq/p4-clockmod.c         |    4 +-
>  drivers/cpufreq/powernow-k8.c         |   13 +----
>  drivers/cpufreq/speedstep-ich.c       |    6 +-
>  drivers/hwmon/coretemp.c              |    6 +--
>  22 files changed, 91 insertions(+), 190 deletions(-)
>

Please ignore this posting, I rushed it and did not build all
combinations.  It looks like a new user of cpu_core_mask appeared in
tip since my last rebase.

I'll send the series out again once I have confirmed that everything is correct.

-- 
Kevin Winchester
