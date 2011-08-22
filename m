Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1HVXoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:44:12 -0400
Received: from claw.goop.org ([74.207.240.146]:48789 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab1HVXoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:44:03 -0400
Message-ID: <4E52E9BF.3050904@goop.org>
Date: Mon, 22 Aug 2011 16:43:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 07/15] x86: add xadd helper macro
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <41c1484d36a94613f86f33e15219d5fcd14b2343.1314054734.git.jeremy.fitzhardinge@citrix.com> <4E52E64D.5090309@zytor.com>
In-Reply-To: <4E52E64D.5090309@zytor.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 04:29 PM, H. Peter Anvin wrote:
> On 08/22/2011 04:15 PM, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Add a common xadd implementation.
>>
>> This has the side effect of generating a bad instruction if you try to
>> use it on a 64-bit value on a 32-bit system - but don't do that.
>>
> It would be better to barf at that point, so we get the error with a C
> line... also, there needs to be a default clause with
> __compiletime_error() in it.

OK, but the "standard of care" here is the old "calling undefined
function" link error; getting a bad asm instruction is a little more
helpful, in a sense.  But agreed on the default: case.  I'll see if I
can fix up xadd and cmpxchg to fail better as well.

> There are a few additional xadd users which should be converted unless
> I'm mistaken:
>
> rwsem_atomic_update() in asm/rwsem.h.
>
> atomic_add_return() in asm/atomic.h.
>
> atomic64_add_return() in asm/atomic64_64.h.
>
> atom_asr() in asm/uv/uv_bau.h (*VOMIT* - the UV people have created a
> whole different type in private code...)
>

Yeah, I hadn't done a full xadd audit.  I'll take a look.

    J
