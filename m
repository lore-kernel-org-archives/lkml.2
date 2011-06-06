Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab1FFW7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:59:48 -0400
Received: from mail.lang.hm ([64.81.33.126]:42554 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab1FFW7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:59:46 -0400
Date: Mon, 6 Jun 2011 15:57:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: pageexec@freemail.hu
cc: Ingo Molnar <mingo@elte.hu>, Andrew Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
In-Reply-To: <4DED5985.542.14A05486@pageexec.freemail.hu>
Message-ID: <alpine.DEB.2.02.1106061553010.25491@asgard.lang.hm>
References: <cover.1307292171.git.luto@mit.edu>, <4DECFE18.23229.133B32ED@pageexec.freemail.hu>, <20110606164700.GA2391@elte.hu> <4DED5985.542.14A05486@pageexec.freemail.hu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, pageexec@freemail.hu wrote:

> On 6 Jun 2011 at 18:47, Ingo Molnar wrote:
>
>> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
>>
>>>>> sorry, but stating that the pf handler is a fast path doesn't
>>>>> make it so ;).
>>
>> and 5-6 mails down the line you are still unwilling to admit it. Why?
>
> why are you cutting out in all those mails of yours what i already told
> you many times? the original statement from Andy was about the int cc path
> vs. the pf path: he said that the latter would not tolerate a few well
> predicted branches (if they were put there at all, that is) because the
> pf handler is such a critical fast path code. it is *not*. it can't be
> by almost definition given how much processing it has to do (it is by
> far one of the most complex of cpu exceptions to process).

it seems to me that such a complicated piece of code that is executed so 
frequently  is especially sensitive to anything that makes it take longer

>> A fastpath is defined by optimization considerations applied to a
>> codepath (the priority it gets compared to other codepaths), *not* by
>> its absolute performance.
>
> we're not talking about random arbitrarily defined paths here but the
> impact of putting well predicted branches into the pf handler vs. int xx
> (are you perhaps confused by 'fast path' vs. 'fastpath'?).

as someone watching, I know that I don't see what difference adding or 
removing a space makes.

the fast path or fastpath refers to the path that is the most performance 
critical (no matter how long the processing takes)

> that impact only matters if it's measurable. you have yet to show that it
> is. and all this sillyness is for a hypothetical situation since those
> conditional branches don't even need to be in the general page fault
> processing paths.

he has shown examples of other 'minor' changes in this code that have been 
considered very significant. given that so much processing already takes 
place here, there is unlikly to be extra processor cycles that can be used 
without making any impact.

>> You seem to be confused on several levels here.
>
> you're talking about something else, probably because it's you who's
> very confused about this whole fast path business. kinda surprising
> given how much time you supposedly spent on this topic in the past.

please educate the rest of us on what you think 'fast path' and 'fastpath' 
mean (and why you think they are so different)

David Lang
