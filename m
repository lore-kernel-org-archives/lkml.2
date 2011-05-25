Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1EYTxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:53:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49497 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab1EYTxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:53:07 -0400
Date: Wed, 25 May 2011 21:52:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision v2
Message-ID: <20110525195251.GA31268@elte.hu>
References: <1306351948-23382-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306351948-23382-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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
> on Intel CPUs. This patch adds a new "cpu update" field to /proc/cpuinfo,
> which I added at the end to minimize impact on parsers.
> 
> The update level is also outputed on fatal machine checks together
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
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/processor.h  |    5 ++++-
>  arch/x86/kernel/cpu/intel.c       |   14 ++++++++++++++
>  arch/x86/kernel/cpu/mcheck/mce.c  |    5 +++--
>  arch/x86/kernel/cpu/proc.c        |    3 ++-
>  arch/x86/kernel/microcode_intel.c |   14 +++++---------
>  5 files changed, 28 insertions(+), 13 deletions(-)

You ignored the majority of the review suggestions i gave you in the 
previous thread, and you know that i won't apply your patches without 
you addressing all feedback.

So why did you send this incomplete series?

Thanks,

	Ingo
