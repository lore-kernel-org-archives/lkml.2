Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0HIS4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:56:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53037 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab0HIS4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:56:48 -0400
Message-ID: <4C604F54.2080506@zytor.com>
Date: Mon, 09 Aug 2010 11:56:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Namhyung Kim <namhyung@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
References: <1281303490-390-1-git-send-email-namhyung@gmail.com> <87k4o08fv9.fsf@basil.nowhere.org> <1281336031.976.11.camel@leonhard> <20100809064441.GC29524@basil.fritz.box> <1281337485.976.24.camel@leonhard> <20100809072226.GD29524@basil.fritz.box>
In-Reply-To: <20100809072226.GD29524@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 12:22 AM, Andi Kleen wrote:
> On Mon, Aug 09, 2010 at 04:04:45PM +0900, Namhyung Kim wrote:
>>> It hides the value conversion from the compiler through asm()
>>>
>>> -Andi
>>>
>>
>> Yes, indeed. But for what? __pa_symbol() is just used to get the address
>> of some linker symbols in forms of unsigned long which has same bit
>> representation as pointer in x86 (and all supported archs). So do we
>> still need it or am I missing something?
> 
> The original reason was that the C standard allows the compiler
> to make some assumptions on the pointer arithmetic that is done 
> on symbol addresses (e.g. no wrapping). This is exploited
> by the optimizer in the compiler to generate better code.
> 
> This lead to a miscompilation on PowerPC a couple of years back at 
> least with the va->pa conversion.
> 
> After that RELOC_HIDE was introduced after funelling the
> symbol address through an empty asm statement was recommended 
> as the official way to do this by the gcc developers.
> 
> I think x86-64 does not normally wrap here, but it's 
> still safer to do it this way.
> 

We pass -fno-strict-overflow to the kernel now, which takes care of the
underlying problem, at least for current versions of gcc.  Unfortunately
we still have people who want to use very old gcc versions to compile
the kernel, so it's probably better to leave it in at least until we
formally kill off support for gcc 3.

	-hpa
