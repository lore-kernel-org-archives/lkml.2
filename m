Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0HIS5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:57:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53050 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab0HIS5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:57:09 -0400
Message-ID: <4C604F70.1040902@zytor.com>
Date: Mon, 09 Aug 2010 11:56:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Namhyung Kim <namhyung@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
References: <1281303490-390-1-git-send-email-namhyung@gmail.com> <20100809080723.GD24221@elte.hu>
In-Reply-To: <20100809080723.GD24221@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 01:07 AM, Ingo Molnar wrote:
> 
> * Namhyung Kim <namhyung@gmail.com> wrote:
> 
>> remove unnecessary use of RELOC_HIDE(). It only does simple addition of ptr
>> and offset, and in this case, offset 0, does nothing. It does NOT do anything
>> with linker relocation things. I could find no reason to use it.
>>
>> The only user of __phys_reloc_hide() was __pa_symbol() so it can be removed
>> safely here.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> ---
>>  arch/x86/include/asm/page.h          |    5 ++---
>>  arch/x86/include/asm/page_32.h       |    1 -
>>  arch/x86/include/asm/page_64_types.h |    1 -
>>  3 files changed, 2 insertions(+), 5 deletions(-)
> 
> We do this as a general Voodoo barrier against GCC miscompilations.
> 
> You are right that it's largely moot by today (and especially so on x86 - i 
> only remember a single instance of miscompilation that Rusty mentioned few 
> years ago, and that was on powerpc), but the wrapper is simple enough, so 
> unless there's some real tangible improvement in the binary output we might as 
> well keep it.
> 
> Peter, what do you think?
> 

I agree... I suspect it might make some difference for gcc 3 stragglers.

	-hpa

