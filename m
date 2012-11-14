Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992435Ab2KNW1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:27:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57306 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab2KNW1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:27:30 -0500
MIME-Version: 1.0
In-Reply-To: <20121114221544.GA3083@elliptictech.com>
References: <1351796580-20600-1-git-send-email-nbowler@elliptictech.com>
	<20121114130500.250dd5b8.akpm@linux-foundation.org>
	<20121114221544.GA3083@elliptictech.com>
Date: Wed, 14 Nov 2012 23:27:29 +0100
Message-ID: <CAFLxGvyXwbwWYnrRA1qza2+CEO_pL=rC82=CkfGOSHNVyA5x+g@mail.gmail.com>
Subject: Re: [PATCH] scatterlist: don't BUG when we can trivially return a
 proper error.
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 11:15 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 2012-11-14 13:05 -0800, Andrew Morton wrote:
>> On Thu,  1 Nov 2012 15:03:00 -0400
>> Nick Bowler <nbowler@elliptictech.com> wrote:
>>
>> > There is absolutely no reason to crash the kernel when we have a
>> > perfectly good return value already available to use for conveying
>> > failure status.
>>
>> Yes, I suppose that's true.  I don't see a case for BUGging the kernel
>> here.
> [...]
>> > -   BUG_ON(nents > max_ents);
>> > +   if (WARN_ON_ONCE(nents > max_ents))
>> > +           return -E2BIG;
>> >  #endif
>>
>> OK, pet peeve: if this E2BIG gets returned to userspace, our poor user
>> will look it up and see "Argument list too long; used when the
>> arguments passed to a new program being executed with one of the exec
>> functions occupy too much memory space".  He then gets to spend half a
>> day reviewing his code's exec() callsites!
>>
>> See?  Although the error's name sounds like a nice match to the
>> internal state, it isn't really a match at all and our use of it is
>> misleading.
>>
>> Unfortunately there is no EKERNELSCREWEDUP,
>
> Well, maybe we should add it! :P
>
>> so we usually use EINVAL.
>
> Fair enough.  I will prepare v2.  But perhaps EOPNOTSUPP would be a
> better fit?

IMHO this would be even more confusing...

-- 
Thanks,
//richard
