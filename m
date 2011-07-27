Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1G0EPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:15:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab1G0EPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:15:05 -0400
Message-ID: <4E2F90A2.4030409@redhat.com>
Date: Wed, 27 Jul 2011 07:14:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andre Przywara <andre.przywara@amd.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
References: <1311340547-7861-1-git-send-email-bp@amd64.org> <4E2F0068.1080001@redhat.com> <20110726181304.GD32536@aftab> <4E2F0498.8050005@zytor.com> <20110726183721.GF32536@aftab> <4E2F09BB.9060605@zytor.com> <4E2F1889.8030708@amd.com>
In-Reply-To: <4E2F1889.8030708@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 10:42 PM, Andre Przywara wrote:
>
> There is no need to determine it by calculating, because it caused by 
> the special design of the BD L1 cache and thus fixed.
> And a calculation would be even more confusing:
>
> The L1I is virtually indexed, but physically tagged.
> 64KB L1I cache, 64 Bytes per Cacheline = 1024 cache lines
> 1024 lines / 2 way associative = 512 indexes
> 64 Bytes per Cacheline (6 bits) + 512 indexes (9 bits) = bits [14:0]
> virtual and physical addresses are the same for bits [11:0], which 
> leaves the remaining 14:12 susceptible for aliasing.
>
> So bit 12 comes from PAGESIZE and yes, the 14 could be derived from 
> the CPUID cache info, but I don't see much value in breaking this down 
> this way.
> But I agree that there should be some comment in the patch which at 
> least notes that bits [14:12] are due to the L1I design, maybe we can 
> copy a nicer version of the above math in the commit message for 
> reference.
>

If among the 12,432.8 cpuid leaves exposed by the cpu we had a bit that 
said L1I was shared, and another that said it was virtually indexed, and 
others describing the cache size, cache line size, and number of ways, 
then we could perform the arithmetic at runtime, yes?

That means that if the caches grow or increase their associativity, then 
we don't need to patch the kernel again.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

