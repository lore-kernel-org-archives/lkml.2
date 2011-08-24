Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1HXXFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:05:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54879 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1HXXFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:05:42 -0400
Message-ID: <4E5583B3.8080309@zytor.com>
Date: Wed, 24 Aug 2011 16:05:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 00/18] x86: Ticket lock + cmpxchg cleanup
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <1314209019.6925.53.camel@twins> <CA+55aFwuz14ez9=2wiG-344ua0tAJNL8ZuCC41fm6aFgCp+Txw@mail.gmail.com> <4E555AD0.3020101@goop.org> <CA+55aFwp6EM1rwP9k8RCj_M5bzPCkR1N1d9a-VZmYaZNyCNC=A@mail.gmail.com> <4E558236.9000707@goop.org>
In-Reply-To: <4E558236.9000707@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 03:59 PM, Jeremy Fitzhardinge wrote:
> On 08/24/2011 03:53 PM, Linus Torvalds wrote:
>> On Wed, Aug 24, 2011 at 1:10 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>> Could we just kill SMP support for OOSTORE machines now?  That would be
>>> the cleanest possible fix...
>> No it wouldn't. The asm version would *still* be cleaner than the "C
>> plus random barriers".
>>
>> It's not like the C version is "portable" in any case.
> 
> If there's no need to have a locked instruction, then it could simply be:
> 
>     barrier();
>     lock->head++;
>     barrier();
> 
> with no need for asm at all.
> 

That's not guaranteed in any way to generate a locally atomic instruction.

	-hpa


