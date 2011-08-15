Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1HONoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:44:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40939 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1HONob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <20110814124002.GA1528@liondog.tnic>
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
 <20110812195220.GA29051@elte.hu> <20110814095910.GA18809@liondog.tnic>
 <201108141313.56926.vda.linux@googlemail.com> <20110814124002.GA1528@liondog.tnic>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 15 Aug 2011 15:44:10 +0200
Message-ID: <CAK1hOcO0f7h3RfSrMgL5ph_MKN19bt6ojYTag2x-TtCsnozrOA@mail.gmail.com>
Subject: Re: x86 memcpy performance
To: Borislav Petkov <bp@alien8.de>, Denys Vlasenko <vda.linux@googlemail.com>,
        Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 2:40 PM, Borislav Petkov <bp@alien8.de> wrote:
>> > +   if (__len >= 512)                                       \
>> > +           __ret = __sse_memcpy((dst), (src), __len);      \
>> > +   else                                                    \
>> > +           __ret = __memcpy((dst), (src), __len);          \
>> > +   __ret;                                                  \
>> > +})
>>
>> Please, no. Do not inline every memcpy invocation.
>> This is pure bloat (comsidering how many memcpy calls there are)
>> and it doesn't even win anything in speed, since there will be
>> a fucntion call either way.
>> Put the __len >= 512 check inside your memcpy instead.
>
> In the __len < 512 case, this would actually cause two function calls,
> actually: once the __sse_memcpy and then the __memcpy one.

You didn't notice the "else".

>> You may do the check if you know that __len is constant:
>> if (__builtin_constant_p(__len) && __len >= 512) ...
>> because in this case gcc will evaluate it at compile-time.
>
> That could justify the bloat at least partially.

There will be no bloat in this case.
-- 
vda
