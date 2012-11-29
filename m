Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2K2VUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:20:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:26086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab2K2VUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:20:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,186,1355126400"; 
   d="scan'208";a="249437813"
Message-ID: <50B7D180.9090605@linux.intel.com>
Date: Thu, 29 Nov 2012 13:20:00 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com> <1354132230-21854-9-git-send-email-hpa@linux.intel.com> <20121128204158.GC14635@liondog.tnic> <50B6A8F3.5000407@zytor.com> <20121129091317.GA21084@liondog.tnic> <50B7CE4C.80201@linux.intel.com> <20121129211856.GH30789@liondog.tnic>
In-Reply-To: <20121129211856.GH30789@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 01:18 PM, Borislav Petkov wrote:
> On Thu, Nov 29, 2012 at 01:06:20PM -0800, H. Peter Anvin wrote:
>> It doesn't matter in that context, as the surrounding MSR references
>> have barriers, but what I'm refering to is the "memory" barrier.
> 
> Ok, but the only difference between the two versions is this line:
> 
>         movl    %esi, %ecx      # tmp144, ecx
> 
> coming from the cpuid_eax() function. So the memory barrier is the same
> and in the right place in both cases.
> 

In the case of that one call site, yes, because the MSR references
include the barrier.  Other sites, current or future, may not have the
same property.

	-hpa


