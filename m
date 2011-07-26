Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab1GZSRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:17:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52437 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab1GZSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:17:39 -0400
Message-ID: <4E2F0498.8050005@zytor.com>
Date: Tue, 26 Jul 2011 11:16:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
References: <1311340547-7861-1-git-send-email-bp@amd64.org> <4E2F0068.1080001@redhat.com> <20110726181304.GD32536@aftab>
In-Reply-To: <20110726181304.GD32536@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 11:13 AM, Borislav Petkov wrote:
> Hi Avi,
> 
> On Tue, Jul 26, 2011 at 01:59:04PM -0400, Avi Kivity wrote:
>>> This change leaves virtual region address allocation on other families
>>> and/or vendors unaffected.
>>>
>>
>> Is it possible to derive the bit positions (and the need to mask them) 
>> from the cpuid description of the cache topology and sizes?
> 
> As far as I understand your question, there's no need for deriving the
> bit positions because they're not special. You just have to have bits
> [14:12] the same across all processes - we simply opted for clearing
> them in order to keep the patch as simple as possible. But we could just
> as well hashed the library name and generated the bits from it and thus
> keep them same per library (we have that version too, btw. :)).
> 
> FWIW, in both cases, the patch should fix even the virtualization
> scenario with and without KSM.
> 
> Does that answer your question?
> 

I think the question was the width (and position) for the mask... i.e.
your [14:12] above which *is* magic.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

