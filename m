Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2GTUTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 16:19:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52046 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab2GTUTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 16:19:41 -0400
Message-ID: <5009BD48.80204@zytor.com>
Date: Fri, 20 Jul 2012 13:19:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vladimir Davydov <VDavydov@parallels.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <50099361.6050300@zytor.com> <2764CF11-A5E5-4C8D-A2EE-69491D2864C3@parallels.com>
In-Reply-To: <2764CF11-A5E5-4C8D-A2EE-69491D2864C3@parallels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 11:21 AM, Vladimir Davydov wrote:
>>
>> I am a bit concerned about this patch:
>>
>> 1. it silently changes existing behavior.
>
> Yes, but who needs the current implementation of 'clearcpuid' which,
> in fact, just hides flags in /proc/cpuinfo while userspace apps will
> see and consequently use all CPU features?

Anyone who wants to disable a feature from the kernel, specifically.

> So, I think it logically extends the existing behavior.
>
>> 2. even on enabled hardware, only some of the bits are maskable.
>
> The patch makes only words 0, 1, 4, 6 maskable, but words 3, 7, 8 are Linux-defined, words 2 and 5 are Transmeta-, Centaur-, etc- defined, and word 9 contains some bizarre Intel CPU features. Thus, it is words 0, 1, 4, 6 that contain useful information for most hardware models.

"Bizarre"?  New features, perhaps.

> If you ask about some Intel CPUs that can't mask CPUID function 0x80000001, this function describes AMD-specific features, and I bet those Intel CPUs just don't have them at all and thus have nothing to mask.

Not quite.

	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.



