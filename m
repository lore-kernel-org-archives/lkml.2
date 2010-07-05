Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab0GETYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:24:42 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58949 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab0GETYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:24:40 -0400
Message-ID: <4C323177.3070606@kernel.dk>
Date: Mon, 05 Jul 2010 21:24:39 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending()
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com> <20100705085550.GA26775@elte.hu> <20100705164022.GA26995@infradead.org> <20100705171125.GB26202@elte.hu> <20100705171420.GA29697@elte.hu> <20100705182003.GA12332@infradead.org>
In-Reply-To: <20100705182003.GA12332@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/10 20.20, Christoph Hellwig wrote:
> On Mon, Jul 05, 2010 at 07:14:20PM +0200, Ingo Molnar wrote:
>> Nor does it apply to v2.6.35-rc4:
> 
> It's indeed missing the two previous patches to the writeback code that
> I thought Jens sent to Linus aswell [1].  The race was initially found using
> a distro kernel with the patches backported, and in the meantime we've
> done a lot of testing with this patch (and the two previous that also
> were backported).  I'd prefer to get this full stack that's been in
> -next for a while and got large machine testing, but if Jens prefers it
> I can aim for a smaller variant.  Jens, what version do you prefer?

The oops itself looks like a recurrence of the missing RCU grace or
too early stack wakeup, which should be a 1-2 liner once it's found.
So I think such a patch would be greatly preferable to doing this
much churn this late in the cycle.

Christoph, do you have time to look into that? We can always punt to
the larger version in a few days if unsuccessful, which gets rid of
the problem by simply deleting the troublesome and complex
clear/wakeup logic.

-- 
Jens Axboe

