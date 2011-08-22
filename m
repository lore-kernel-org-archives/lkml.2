Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1HVXaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:30:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46398 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab1HVXaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:30:13 -0400
Message-ID: <4E52E64D.5090309@zytor.com>
Date: Mon, 22 Aug 2011 16:29:17 -0700
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
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <41c1484d36a94613f86f33e15219d5fcd14b2343.1314054734.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <41c1484d36a94613f86f33e15219d5fcd14b2343.1314054734.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 04:15 PM, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Add a common xadd implementation.
> 
> This has the side effect of generating a bad instruction if you try to
> use it on a 64-bit value on a 32-bit system - but don't do that.
> 

It would be better to barf at that point, so we get the error with a C
line... also, there needs to be a default clause with
__compiletime_error() in it.

There are a few additional xadd users which should be converted unless
I'm mistaken:

rwsem_atomic_update() in asm/rwsem.h.

atomic_add_return() in asm/atomic.h.

atomic64_add_return() in asm/atomic64_64.h.

atom_asr() in asm/uv/uv_bau.h (*VOMIT* - the UV people have created a
whole different type in private code...)

	-hpa
