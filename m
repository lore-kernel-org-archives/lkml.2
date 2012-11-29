Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab2K2APZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:15:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42206 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428Ab2K2APY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:15:24 -0500
Message-ID: <50B6A8F3.5000407@zytor.com>
Date: Wed, 28 Nov 2012 16:14:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com> <1354132230-21854-9-git-send-email-hpa@linux.intel.com> <20121128204158.GC14635@liondog.tnic>
In-Reply-To: <20121128204158.GC14635@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

Wrong barrier semantics.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

