Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab0HVUQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 16:16:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55111 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0HVUQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 16:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QnLepTMrahZ+ALD/hyX7VBLbviy+6KBgK+WLM2Aiwf8aeugSM+7xOejbOXltGpRQLd
         ISpH5hJiIZzORLgkoo3M/gag8/o3Qu14MRFA74IjgEc3mKlmFN7KYRuoOZMcYuwAZp4/
         TnBKPrHrmG6j/JBpiBBKpyt2CVbFnMeML7iac=
MIME-Version: 1.0
In-Reply-To: <20100822193819.GA23299@Krystal>
References: <20100821141750.770348530@efficios.com>
	<20100821142215.023431313@efficios.com>
	<20100822192705.GE1771@one.firstfloor.org>
	<20100822193819.GA23299@Krystal>
Date: Sun, 22 Aug 2010 23:16:42 +0300
Message-ID: <AANLkTingCD78PYQN1f-0jNQYAU1v6W5RXHe73FnpmqDA@mail.gmail.com>
Subject: Re: [PATCH for -tip 1/2] kernel.h: add MAYBE_BUILD_BUG_ON_NOT_POWER_OF_2
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Imre Deak <imre.deak@nokia.com>,
        Jamie Lokier <jamie@shareable.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think about some test at the last bit if it is on, the number is not
a power of 2

On Sun, Aug 22, 2010 at 10:38 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> * Andi Kleen (andi@firstfloor.org) wrote:
>> > +/* Force a compilation error if condition is constant and not a power of 2 */
>> > +#define MAYBE_BUILD_BUG_ON_NOT_POWER_OF_2(n)               \
>> > +   MAYBE_BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
>>
>> Looks super-ugly. IMHO just writing MAYBE_BUILD_BUG_ON(!n || n & (n - 1)) directly
>> would be clear enough. If you really think that's unclear define a generic
>> is_power_of_two() macro.
>
> There is already a is_power_of_two macro in log2.h, but I fear it might
> incorrectly interact with "MAYBE_BUILD_BUG_ON" (for some reason passing the
> constant result of a static inline is not treated as a constant by the macro,
> and thus it always "passes" the test).
>
> So if everyone object to this new macro, I'd be tempted to just go with your
> suggestion. However the fact that we already have BUILD_BUG_ON_NOT_POWER_OF_2(n)
> made me think that some people prefer to have it done as a macro.
>
> Other opinions ?
>
> Thanks,
>
> Mathieu
>
>
> --
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
