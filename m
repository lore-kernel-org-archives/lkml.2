Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1GFSVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:21:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58686 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab1GFSVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:21:23 -0400
Message-ID: <4E14A781.8090004@zytor.com>
Date: Wed, 06 Jul 2011 11:20:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] x86,64: Simplify save_regs()
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>	<1309624184-9790-4-git-send-email-fweisbec@gmail.com>	<4E1185F3020000780004BF21@nat28.tlf.novell.com>	<20110704125742.GB1915@somewhere.redhat.com> <m2sjqj71ot.fsf@firstfloor.org>
In-Reply-To: <m2sjqj71ot.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2011 10:34 AM, Andi Kleen wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
>>
>> I really did not think about code duplication, considering
>> it's better to optimize the irq entry path.
>>
>> What do you guys think? We can still revert the whole patchset.
> 
> FWIW I think it should be a macro, like it was in the original code.
> 
> Optimizing entry*.S for code size doesn't make a lot of sense.
> 

Code size, no.

*Path* size and cache/prefetch friendliness is another matter.
The subroutine is bad on that account, too, so yes, this really seems
like a losing proposition.

I'm not too fond of the gajillion obtuse macros we have, but subroutines
doesn't make it really any better.

	-hpa
