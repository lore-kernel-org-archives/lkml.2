Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2BGQ2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:28:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:39694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2BGQ2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:28:21 -0500
Message-ID: <4F315113.5010804@kernel.dk>
Date: Tue, 07 Feb 2012 17:28:03 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in put_io_context()
References: <1328514611.21268.66.camel@sli10-conroe> <20120206151219.GC30752@redhat.com> <4F2FFB21.9000202@kernel.dk> <20120206163721.GF30752@redhat.com> <20120206164428.GA21292@google.com> <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com> <20120206172706.GB21292@google.com> <4F303506.9000201@kernel.dk> <20120206215451.GD21292@google.com> <4F30C96F.1000905@kernel.dk> <20120207162253.GG21292@google.com>
In-Reply-To: <20120207162253.GG21292@google.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-07 17:22, Tejun Heo wrote:
> Hello, Jens.
> 
> On Tue, Feb 07, 2012 at 07:49:19AM +0100, Jens Axboe wrote:
>>> I couldn't find any statiscally meaningful advantage of the
>>> optimization with tight fork/exit tests w/ forced ioc creation on
>>> fork, which gotta be the most pathological test case for the code
>>> path.  So, let's remove the ugly optimization.  If I missed sth, we
>>> can resurrect the simpler optimization later.  Jens, this is on top of
>>> linus#master without Shaohua's patch.
>>
>> OK, then I'm fine with cleaning it up. Applied, thanks Tejun.
> 
> Hmmm... how about merging Shaohua's smaller fix first until we figure
> out what's going on with the performance regression he's seeing?

That was already merged in my tree. I don't see how it makes much
difference in tracking the regression. You said that removing it made no
difference for the find test case, so I'd be more comfortable getting
rid of the nasty optimization.

I'll send it when I have pending tomorrow, so there's still a full day
to change things. We can just shuffle patches before then, not a
problem.

-- 
Jens Axboe

