Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2IJFQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:16:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35611 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2IJFQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:16:42 -0400
Message-ID: <504D77D0.70705@gmail.com>
Date: Mon, 10 Sep 2012 07:17:04 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120902 Thunderbird/15.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, linux-mm <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mtd: kernel BUG at arch/x86/mm/pat.c:279!
References: <1340959739.2936.28.camel@lappy> <CA+1xoqdgKV_sEWvUbuxagL9JEc39ZFa6X9-acP7j-M7wvW6qbQ@mail.gmail.com> <CA+55aFzJCLxVP+WYJM-gq=aXx5gmdgwC7=_Gr2Tooj8q+Dz4dw@mail.gmail.com> <1347057778.26695.68.camel@sbsiddha-desk.sc.intel.com> <CA+55aFwW9Q+DM2gZy7r3JQJbrbMNR6sN+jewc2CY0i1wD_X=Tw@mail.gmail.com> <1347062045.26695.82.camel@sbsiddha-desk.sc.intel.com> <CA+55aFzeKcV5hROLJE31dNi3SEs+s6o0LL=96Kh8QGHPx=aZnA@mail.gmail.com> <504CCA31.2000003@zytor.com>
In-Reply-To: <504CCA31.2000003@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 06:56 PM, H. Peter Anvin wrote:
>>
>> Anyway, that means that the BUG_ON() is likely bogus, but so is the
>> whole calling convention.
>>
>> The 4kB range starting at 0xfffffffffffff000 sounds like a *valid*
>> range, but that requires that we fix the calling convention to not
>> have that "end" (exclusive) thing. It should either be "end"
>> (inclusive), or just "len".
>>
> 
> On x86, it is definitely NOT a valid range.  There is no physical addresses
> there, and there will never be any.

This reminds me a similar issue: If you try to mmap /dev/kmem at an offset which
is not kernel owned (such as 0), you'll get all the way to __pa() before getting
a BUG() about addresses not making sense.

How come there's no arch-specific validation of attempts to access
virtual/physical addresses? In the kmem example I'd assume that something very
early on should be yelling at me about doing something like that, but for some
reason I get all the way to __pa() before getting a BUG() (!).


Thanks,
Sasha
