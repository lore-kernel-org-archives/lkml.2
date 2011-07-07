Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1GGTts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:49:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55697 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1GGTtr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:49:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110707.122151.314840355798805828.davem@davemloft.net>
References: <alpine.DEB.2.00.1107071314320.21719@router.home>
	<1310064771.21902.55.camel@jaguar>
	<alpine.DEB.2.00.1107071402490.24248@router.home>
	<20110707.122151.314840355798805828.davem@davemloft.net>
Date: Thu, 7 Jul 2011 22:49:46 +0300
X-Google-Sender-Auth: itpFKBPAyYZeyjwV8B0Toy5vbos
Message-ID: <CAOJsxLFsX3Q84QAeyRt5dZOdRxb3TiABPrP-YrWc91+BmR8ZBg@mail.gmail.com>
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
From: Pekka Enberg <penberg@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: cl@linux.com, marcin.slusarz@gmail.com, mpm@selenic.com,
        linux-kernel@vger.kernel.org, rientjes@google.com, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 10:21 PM, David Miller <davem@davemloft.net> wrote:
> From: Christoph Lameter <cl@linux.com>
> Date: Thu, 7 Jul 2011 14:12:37 -0500 (CDT)
>
>> On Thu, 7 Jul 2011, Pekka Enberg wrote:
>>
>>> On Thu, 7 Jul 2011, Pekka Enberg wrote:
>>> > > Looks good to me. Christoph, David, ?
>>>
>>> On Thu, 2011-07-07 at 13:17 -0500, Christoph Lameter wrote:
>>> > The reason debug code is there is because it is useless overhead typically
>>> > not needed. There is no point in optimizing the code that is not run in
>>> > production environments unless there are gross performance issues that
>>> > make debugging difficult. A performance patch for debugging would have to
>>> > cause significant performance improvements. This patch does not do that
>>> > nor was there such an issue to be addressed in the first place.
>>>
>>> Is there something technically wrong with the patch? Quoting the patch
>>> email:
>>>
>>>   (Compiling some project with different options)
>>>                                  make -j12    make clean
>>>   slub_debug disabled:             1m 27s       1.2 s
>>>   slub_debug enabled:              1m 46s       7.6 s
>>>   slub_debug enabled + this patch: 1m 33s       3.2 s
>>>
>>>   check_bytes still shows up high, but not always at the top.
>>>
>>> That's significant enough speedup for me!
>>
>> Ok. I had a different set of numbers in mind from earlier posts.
>>
>> The benefit here comes from accessing memory in larger (word) chunks
>> instead of byte wise. This is a form of memscan() with inverse matching.
>>
>> Isnt there an asm optimized version that can do this much better (there is
>> one for memscan())? Optimizing this in core code by codeing something as
>> generic as that is not that good since the arch code can deliver better
>> performance and it seems that this is functionality that could be useful
>> elsewhere.
>
> You're being so unreasonable, just let the optimization in, refine it
> with follow-on patches.

I applied the patch. I think a follow up patch that moves the function
to lib/string.c with proper generic name would be in order. Thanks!
