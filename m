Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1JNHXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:23:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37817 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab1JNHXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:23:33 -0400
Date: Fri, 14 Oct 2011 09:21:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision v7
Message-ID: <20111014072151.GA21913@elte.hu>
References: <1318546513-2528-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318546513-2528-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> I got a request to make it easier to determine the microcode update level
> on Intel CPUs. This patch adds a new "microcode" field to /proc/cpuinfo.
> 
> The microcode level is also outputed on fatal machine checks together
> with the other CPUID model information.
> 
> I removed the respective code from the microcode update driver, it
> just reads the field from cpu_data. Also when the microcode is updated
> it fills in the new values too.
> 
> I had to add a memory barrier to native_cpuid to prevent it being
> optimized away when the result is not used.
> 
> This turns out to clean up further code which already got this
> information manually. This is done in followon patches.
> 
> v2:  Lots of updates based on feedback.
> v3:  Rename cpu_update to microcode. Misc changes from feedback.
> v4:  minor updates. rebased.
> v5:  move MSR read to early_intel_init()
> v6:  Use sync_core() instead of CPUID 1. Drop a white space change.
> v7:  Add Acked-bys.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/include/asm/processor.h  |    4 +++-
>  arch/x86/kernel/cpu/intel.c       |    9 +++++++++
>  arch/x86/kernel/cpu/mcheck/mce.c  |    9 +++++++--
>  arch/x86/kernel/cpu/proc.c        |    2 ++
>  arch/x86/kernel/microcode_intel.c |   14 +++++---------
>  5 files changed, 26 insertions(+), 12 deletions(-)

Applied to tip:x86/microcode,

Thanks,

	Ingo
