Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1GGKxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 06:53:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46265 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab1GGKxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:53:36 -0400
Date: Thu, 7 Jul 2011 12:53:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision v3
Message-ID: <20110707105315.GA3412@elte.hu>
References: <1309996623-23108-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309996623-23108-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
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
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/processor.h  |    4 +++-
>  arch/x86/kernel/cpu/intel.c       |   13 +++++++++++++
>  arch/x86/kernel/cpu/mcheck/mce.c  |    9 +++++++--
>  arch/x86/kernel/cpu/proc.c        |    3 ++-
>  arch/x86/kernel/microcode_intel.c |   14 +++++---------
>  5 files changed, 30 insertions(+), 13 deletions(-)

You have *still* ignored some of the review suggestions i gave you in 
the previous thread, and you know that i won't apply your patches 
without you addressing all feedback.

So why did you send this incomplete series?

Thanks,

	Ingo
