Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab1HUR4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 13:56:31 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:42280 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1HUR42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 13:56:28 -0400
X-ASG-Debug-ID: 1313949381-01de284617058f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E5146C1.508@fusionio.com>
Date: Sun, 21 Aug 2011 19:56:17 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block bits for 3.1-rc
References: <4E4E6238.3080808@fusionio.com> <20110820174137.GA27243@infradead.org>
X-ASG-Orig-Subj: Re: [GIT PULL] block bits for 3.1-rc
In-Reply-To: <20110820174137.GA27243@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313949381
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC5_SA210e
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.72424
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC5_SA210e         Custom Rule SA210e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-20 19:41, Christoph Hellwig wrote:
> On Fri, Aug 19, 2011 at 03:16:40PM +0200, Jens Axboe wrote:
>> - Revert of the CFQ meta data special treatment patch, it's been shown
>>   to regress a kernel build workload by about 10%. More investigation
>>   is needed, for 3.1 lets just back it out.
> 
> Sorry, but you can't simply do that without any coordination.  We have
> added that marker to xfs now that the stupid special casing stopped,
> and turning it back on will cause us massive slowdows.  Next time
> please better coordinate this with its users.  In fact I have never
> seen this patch or a discussion on any mailinglist.

The discussion was on lkml, as Mike points out. But yes, short time to
react. Since I can't easily cater to both cases right now, how about we
add a temporary second meta flag that is only used for tracing?

        REQ_META        = (__REQ_META | __REQ_META_TRACE),
        RET_META_TRACE  = __REQ_META_TRACE,

You get the idea. Not super pretty, but it should solve the immediate
issue.

-- 
Jens Axboe

