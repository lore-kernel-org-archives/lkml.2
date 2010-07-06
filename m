Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0GFGus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 02:50:48 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55105 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab0GFGur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 02:50:47 -0400
Message-ID: <4C32D243.1050806@kernel.dk>
Date: Tue, 06 Jul 2010 08:50:43 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending()
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com> <20100705085550.GA26775@elte.hu> <20100705164022.GA26995@infradead.org> <20100705171125.GB26202@elte.hu> <20100705171420.GA29697@elte.hu> <20100705182003.GA12332@infradead.org> <4C323177.3070606@kernel.dk> <4C324C78.5090805@tmr.com> <AANLkTinLrbQNv9uKYZCAKS-kFPSdle3fvAMzjI77BCu2@mail.gmail.com> <20100706064733.GA12382@elte.hu>
In-Reply-To: <20100706064733.GA12382@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-06 08:47, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Mon, Jul 5, 2010 at 2:19 PM, Bill Davidsen <davidsen@tmr.com> wrote:
>>>
>>> Absent a small fix, and given that the big fix has a lot more testing than
>>> any new patch might, in this case the quickie might be undesirable.
>>> Particularly since posters here seem sure that code will be replaced in the
>>> next version anyway, and lightly tested patch to obsolete code is actually
>>> less conservative.
>>
>> I have to agree. Especially as the "big patch" just removes the fragile code 
>> that caused the problem in the first place. So in this case I do suspect 
>> that the bigger patch ends up being the safer one.
> 
> Yeah, i agree - especially since the smaller patch is still pretty large (not 
> a oneliner), plus it does not appear that the precise failure mode is fully 
> understood either.

http://lkml.org/lkml/2010/7/5/232

It's about as straight forward as it can be :-)
It definitely fixes _a_ bug, but whether it's only that bug is not certain.
As long as Linus is fine with the larger fix, then I have no issues going
in that direction.

>> But I obviously don't actually see the problem, so it would be good to get 
>> confirmation that Christoph's patch actually fixes things first. Ingo, does 
>> the one in this thread apply for you?
> 
> Yes, the three larger patches survived overnight testing with 300+ iterations 
> and i did some other tests as well, which passed too. These are the patches i 
> applied:
> 
>  a73dd720  writeback: remove writeback_inodes_wbc
>  9f98c0fa  writeback: split writeback_inodes_wb
>  79338d2a  writeback: simplify the write back thread queue

Great, I'll upstream these bits today. Thanks Ingo.

-- 
Jens Axboe

