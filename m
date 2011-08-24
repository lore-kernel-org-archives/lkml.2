Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1HXWDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:03:34 -0400
Received: from claw.goop.org ([74.207.240.146]:53697 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1HXWDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:03:33 -0400
Message-ID: <4E557534.3030408@goop.org>
Date: Wed, 24 Aug 2011 15:03:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 07/12] x86: use cmpxchg_flag() where applicable
References: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com> <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <3d7aea62fac48dd6e2da236d86234113fcd78178.1314221624.git.jeremy.fitzhardinge@citrix.com> <CA+55aFwEH16JAynxQzNTff0ikGnON9jq1mJOx1doDASV2a2fpg@mail.gmail.com> <4E5574C3.6080104@zytor.com>
In-Reply-To: <4E5574C3.6080104@zytor.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 03:01 PM, H. Peter Anvin wrote:
> On 08/24/2011 02:56 PM, Linus Torvalds wrote:
>> Ok, I see nothing horrible in this series.
>>
>> The one reaction I have is that the cmpxchg_flag() thing returns an
>> 8-bit value, but then a lot of the users end up having to extend it to
>> a full "int" purely for calling convention reasons (eg I think
>> 'down_write_trylock()' will have 'sete + movzl' - not a new problem,
>> but since the whole point was to remove extraneous instructions and we
>> no longer have the silly 'testl', it now annoys me more).
>>
>> So it seems a bit sad. But I guess it doesn't really matter.
>>
> I think it is a net lose.  The most common case is probably going to be
> to use it immediately, in which case we have:
>
> cmpxchg -> sete -> compare -> conditional
>
> versus
>
> cmpxchg -> compare -> conditional
>
> For doubleword cmpxchg it's another matter entirely, because doubleword
> comparisons are significantly more expensive that sete + test.
>
> So unless there is actual data showing this is better, I would like to
> see this dropped for now.

Well, we could keep the API (since it is convenient), but just implement
it with a compare.

    J
