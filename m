Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1HWEmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 00:42:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58260 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1HWElz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 00:41:55 -0400
Message-ID: <4E532F65.7010609@zytor.com>
Date: Mon, 22 Aug 2011 21:41:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 07/15] x86: add xadd helper macro
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <41c1484d36a94613f86f33e15219d5fcd14b2343.1314054734.git.jeremy.fitzhardinge@citrix.com> <4E52E64D.5090309@zytor.com> <4E52E9BF.3050904@goop.org>
In-Reply-To: <4E52E9BF.3050904@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 04:43 PM, Jeremy Fitzhardinge wrote:
> On 08/22/2011 04:29 PM, H. Peter Anvin wrote:
>> On 08/22/2011 04:15 PM, Jeremy Fitzhardinge wrote:
>>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>
>>> Add a common xadd implementation.
>>>
>>> This has the side effect of generating a bad instruction if you try to
>>> use it on a 64-bit value on a 32-bit system - but don't do that.
>>>
>> It would be better to barf at that point, so we get the error with a C
>> line... also, there needs to be a default clause with
>> __compiletime_error() in it.
> 
> OK, but the "standard of care" here is the old "calling undefined
> function" link error; getting a bad asm instruction is a little more
> helpful, in a sense.  But agreed on the default: case.  I'll see if I
> can fix up xadd and cmpxchg to fail better as well.
> 

__compiletime_error() is better than either, obviously...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

