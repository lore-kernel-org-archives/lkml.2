Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1ESH1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 03:27:41 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:41483 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab1ESH1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 03:27:40 -0400
X-ASG-Debug-ID: 1305790059-03d6a50f36b0240001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DD4C667.7030507@fusionio.com>
Date: Thu, 19 May 2011 09:27:35 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: New boot time message: detected capacity change
References: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com> <BANLkTimY+y3vXa0R7Evs6dYLVjJ==KVq1A@mail.gmail.com> <20110519052903.GA2904@mtj.dyndns.org> <20110519060100.GB2904@mtj.dyndns.org>
X-ASG-Orig-Subj: Re: New boot time message: detected capacity change
In-Reply-To: <20110519060100.GB2904@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1305790059
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64169
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-19 08:01, Tejun Heo wrote:
> Hello, again.
> 
> On Thu, May 19, 2011 at 07:29:03AM +0200, Tejun Heo wrote:
>> The commit message is incomplete rather than misleading.  The problem
>> has been there for a long time but hasn't affected cdrom so not many
>> people have noticed it.  The changes to media revalidation exposed the
>> bug for cdrom too, so it became a regression for 2.6.38.  Please refer
>> to the following thread.
>>
>>   https://lkml.org/lkml/2011/3/31/436
>>
>> As the root cause was the same as the 2009 bug, I just referenced that
>> one.  I should have included the link to the newer thread or explained
>> how it affected recent conversion from ->media_changed to
>> ->check_events.  My bad.
> 
> I was a bit confused here, so there were two separate problems.  One
> affected sr, which was fixed by bf2253a6f0 and the other affecting
> partition scan on sd fixed by 02e352287a.  The two were mixed in my
> head, and I explained the wrong one.
> 
> The cdrom problem was a plain kernel regression.  The latter (the one
> being shouted at in this thread) is slightly more complex.  Due to the
> way devices were polled for media change from userland, the problem
> wasn't noticeable.  The kernel misbehaved but userland polling masked
> it.  2.6.38 added in-kernel polling and the userland workaround no
> longer applied and the problem became visible - similar story with the
> cdrom problem but involves userland behavior change too.
> 
> Both were very simliar in the cause too.  cdrom was unnecessarily
> skipping check_disk_change() while the block layer was unnecessarily
> skipping partition check.
> 
> Anyways, I'll go to my office and look into the warning message, but
> please revert 02e352287a if necessary.  We can do that with -stable
> later.

It's too late at this point really, since 2.6.39 is tagged and done. The
capacity message should be purely harmless, even if it does look
somewhat odd. The placement is fairly logical, so should not cause too
many confused users.

-- 
Jens Axboe

