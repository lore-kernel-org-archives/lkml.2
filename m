Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0GEVVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 17:21:05 -0400
Received: from mail.tmr.com ([64.65.253.246]:49037 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0GEVVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 17:21:02 -0400
Message-ID: <4C324C78.5090805@tmr.com>
Date: Mon, 05 Jul 2010 17:19:52 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending()
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com> <20100705085550.GA26775@elte.hu> <20100705164022.GA26995@infradead.org> <20100705171125.GB26202@elte.hu> <20100705171420.GA29697@elte.hu> <20100705182003.GA12332@infradead.org> <4C323177.3070606@kernel.dk>
In-Reply-To: <4C323177.3070606@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On 05/07/10 20.20, Christoph Hellwig wrote:
>> On Mon, Jul 05, 2010 at 07:14:20PM +0200, Ingo Molnar wrote:
>>> Nor does it apply to v2.6.35-rc4:
>> It's indeed missing the two previous patches to the writeback code that
>> I thought Jens sent to Linus aswell [1].  The race was initially found using
>> a distro kernel with the patches backported, and in the meantime we've
>> done a lot of testing with this patch (and the two previous that also
>> were backported).  I'd prefer to get this full stack that's been in
>> -next for a while and got large machine testing, but if Jens prefers it
>> I can aim for a smaller variant.  Jens, what version do you prefer?
> 
> The oops itself looks like a recurrence of the missing RCU grace or
> too early stack wakeup, which should be a 1-2 liner once it's found.
> So I think such a patch would be greatly preferable to doing this
> much churn this late in the cycle.
> 
Absent a small fix, and given that the big fix has a lot more testing than any 
new patch might, in this case the quickie might be undesirable. Particularly 
since posters here seem sure that code will be replaced in the next version 
anyway, and lightly tested patch to obsolete code is actually less conservative.

I can't reproduce the bug, so take that as an opinion based on Christoph's 
comment on the use of a tested full change.

> Christoph, do you have time to look into that? We can always punt to
> the larger version in a few days if unsuccessful, which gets rid of
> the problem by simply deleting the troublesome and complex
> clear/wakeup logic.
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
