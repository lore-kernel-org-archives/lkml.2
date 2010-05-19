Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab0ESOYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:24:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36611 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab0ESOYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:24:33 -0400
Message-ID: <4BF3F480.3000902@zytor.com>
Date: Wed, 19 May 2010 07:24:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Ingo Molnar <mingo@elte.hu>, Luca Barbieri <luca@luca-barbieri.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: [GIT PULL] x86/atomic changes for v2.6.35
References: <20100517224531.GA27400@elte.hu> <AANLkTinWbueCQZdQgZFDLQPJYieB13orxDGYJzzRpPni@mail.gmail.com>
In-Reply-To: <AANLkTinWbueCQZdQgZFDLQPJYieB13orxDGYJzzRpPni@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 04:46 AM, Geert Uytterhoeven wrote:
> On Tue, May 18, 2010 at 00:45, Ingo Molnar <mingo@elte.hu> wrote:
>> Please pull the latest x86-atomic-for-linus git tree from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-atomic-for-linus
>>
>>
>> out-of-topic modifications in x86-atomic-for-linus:
>> ---------------------------------------------------
>> lib/Makefile                       # 86a8938: lib: Add self-test for atomic64_t
>> lib/atomic64.c                     # 9757789: lib: Fix atomic64_add_unless retu
>> lib/atomic64_test.c                # a5c9161: x86, atomic64: In selftest, disti
>>                                   # 25a304f: lib: Fix atomic64_inc_not_zero te
>>                                   # 9efbcd5: lib: Fix atomic64_add_unless test
>>                                   # d7f6de1: x86: Implement atomic[64]_dec_if_
>>                                   # 8f4f202: lib: Only test atomic64_dec_if_po
>>                                   # 86a8938: lib: Add self-test for atomic64_t
> 
> Is having atomic64_t mandatory now?
> 
> According to the allmodconfig build logs
> (http://kisskb.ellerman.id.au/kisskb/matrix/),
> several architectures (at least m68k and mips) don't have it.
> Furthermore, the test fails to compile on a few architectures that do have it
> (parisc, s390, sh, ...).
> 
> <boilerplate>
> It's a pity this wasn't raised/resolved between its detection in linux-next and
> before it entered mainline...
> </boilerplate>
> 

Is having atomic64_t mandatory?  Not yet, I don't think, but it probably
will be soon -- which is why there is a generic implementation
available.  All those architectures just need to select
CONFIG_GENERIC_ATOMIC64 and voilà, problem solved.

As far as your boilerplate is concerned, I think Linus made it clear at
the Kernel Summit that is it not the obligation of x86/ARM/PowerPC to
slow down to not break the smaller architectures; it's the
responsibility of those architecture maintainers to keep up.  Sorry.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

