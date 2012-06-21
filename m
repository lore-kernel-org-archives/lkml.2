Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588Ab2FUWsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:48:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53689 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760462Ab2FUWsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:48:06 -0400
Message-ID: <4FE3A495.1030008@zytor.com>
Date: Thu, 21 Jun 2012 15:47:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, zheng.z.yan@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Add generic Intel uncore PMU support
References: <1339741902-8449-6-git-send-email-zheng.z.yan@intel.com> <tip-087bfbb032691262f2f7d52b910652450c5554b8@git.kernel.org> <20120621154334.05a74517.akpm@linux-foundation.org>
In-Reply-To: <20120621154334.05a74517.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 03:43 PM, Andrew Morton wrote:
> 
> Regardless of that, we have some head-scratching to do:
> 
> 
> #define UNCORE_PMU_HRTIMER_INTERVAL       (60 * NSEC_PER_SEC)
> 
> and
> 
> #define NSEC_PER_SEC    1000000000L
> 
> and 60 billion doesn't fit in 32 bits.  So do we fix the
> perf_event_intel_uncore.c callsites?  Or do we fix the
> UNCORE_PMU_HRTIMER_INTERVAL definition?  Or do we fix the NSEC_PER_SEC
> definition?
> 
> I'm thinking perhaps the latter.  What *is* the type of a nanosecond in
> Linux?  include/linux/ktime.h is pretty insistent that it is u64.  If
> so, NSEC_PER_SEC should logically have type ULL.  But changing both its
> size and signedness is a pretty big change.

We could change the size only.  The range from 9223372036.854775808 to
18446744073.709551615 seconds (292-584 years) isn't really that significant.

	-hpa
