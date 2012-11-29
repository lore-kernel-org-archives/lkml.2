Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2K2VY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:24:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:49811 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab2K2VY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:24:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,186,1355126400"; 
   d="scan'208";a="256830427"
Message-ID: <50B7D28A.4000401@linux.intel.com>
Date: Thu, 29 Nov 2012 13:24:26 -0800
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
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com> <1354132230-21854-9-git-send-email-hpa@linux.intel.com> <20121128204158.GC14635@liondog.tnic>
In-Reply-To: <20121128204158.GC14635@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 12:41 PM, Borislav Petkov wrote:
> 
> While at it, you could correct this comment to adhere to kernel coding
> style:
> 
> 	/*
> 	 * cpuid is a barrier...
> 	 * ...
> 	 */
> 
>> +	asm volatile("cpuid" : "=a" (tmp) : "0" (1)
>> +		     : "ebx", "ecx", "edx", "memory");
> 
> ... and then write this in its shorter form:
> 
> 	tmp = cpuid_eax(1);
> 
> to have it a bit easier on the eyes.
> 

Thinking about it some more, there is another reason to not do this,
which is that we don't want this particular CPUID to be paravirtualized;
we're after the synchronizing side effect, not the CPUID return value
itself.

So let's leave it as a primitive; it gets too confusing otherwise.

	-hpa


