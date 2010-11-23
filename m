Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab0KWHSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:18:37 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36541 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0KWHQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:16:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert oom rewrite series
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
References: <20101115113238.BF06.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
Message-Id: <20101123151731.7B7B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:16:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay.

> On Mon, 15 Nov 2010, KOSAKI Motohiro wrote:
> 
> > Of cource, I denied. He seems to think number of email is meaningful than
> > how talk about. but it's incorrect and makes no sense. Why not? Also, He
> > have to talk about logically. "Hey, I think it's not bug" makes no sense.
> > Such claim don't solve anything. userland is still unhappy. Why not?
> > I want to quickly action.
> 
> If there are pending complaints or bugs that I haven't addressed, please 
> bring them to my attention.  To date, I know of no issues that have been 
> raised that I have not addressed; you're always free to disagree with my 
> position, but in the end you may find that when the kernel moves in a 
> different direction that you should begin to accept it.

I can't understand. Why do I need to ignore userland folks? WHY?
I have no reason userland complain. I tend to prefer to avoid userland 
folks painful than kernel developers.


> 
> > That said, If anyone want to change userland ABI, Be carefully. They have
> > to investigate userland usecase carefully and avoid to break them carefully 
> > again. If someone think "hey, It's no big matter. userland rewritten can solve
> > an issue", I strongly disagree. they don't understand why all of userland 
> > applications rewritten is harmful.
>
> You may remember that the initial version of my rewrite replaced oom_adj 
> entirely with the new oom_score_adj semantics.  Others suggested that it 
> be seperated into a new tunable and the old tunable deprecated for a 
> lengthy period of time.  I accepted that criticism and understood the 
> drawbacks of replacing the tunable immediately and followed those 
> suggestions.  I disagree with you that the deprecation of oom_adj for a 
> period of two years is as dramatic as you imply and I disagree that users 
> are experiencing problems with the linear scale that it now operates on 
> versus the old exponential scale.

Yes and No. People wanted to separate AND don't break old one.


> 
> > 1) About two month ago, Dave hansen observed strange OOM issue because he
> >    has a big machine and ALL process are not so big. thus, eventually all 
> >    process got oom-score=0 and oom-killer didn't work.
> > 
> >    https://kerneltrap.org/mailarchive/linux-driver-devel/2010/9/9/6886383
> > 
> >    DavidR changed oom-score to +1 in such situation. 
> > 
> >    http://kerneltrap.org/mailarchive/linux-kernel/2010/9/9/4617455
> > 
> >    But it is completely bognus. If all process have score=1, oom-killer fall
> >    back to purely random killer. I expected and explained his patch has
> >    its problem at half years ago. but he didn't fix yet.
> > 
> 
> The resolution with which the oom killer considers memory is at 0.1% of 
> system RAM at its highest (smaller when you have a memory controller, 
> cpuset, or mempolicy constrained oom).  It considers a task within 0.1% of 
> memory of another task to have equal "badness" to kill, we don't break 
> ties in between that resolution -- it all depends on which one shows up in 
> the tasklist first.  If you disagree with that resolution, which I support 
> as being high enough, then you may certainly propose a patch to make it 
> even finer at 0.01%, 0.001%, etc.  It would only change oom_badness() to 
> range between [0,10000], [0,100000], etc.

No.
Think Moore's Law. rational value will be not able to work in future anyway.
10 years ago, I used 20M bytes memory desktop machine and I'm now using 2GB.
memory amount is growing and growing. and bash size doesn't grwoing so fast.


> 
> > 2) Also half years ago, I did explained oom_adj is used from multiple 
> >    applications. And we can't break them. But DavidR didn't fix.
> > 
> 
> And we didn't.  oom_adj is still there and maps linearly to oom_score_adj; 
> you just can't show a single application where that mapping breaks because 
> it was based on an actual calculation.
> 
> If you would like to cite these "multiple" applications that need to be 
> converted to use oom_score_adj (I know of udev), please let me know and 
> if they're open-source applications then I will commit to submitting 
> patches for them myself.  I believe the two year window is sufficient for 
> everyone else, though.

If you want, you have to change userland at first and by yourself. Don't
claim anyoneelse should working for you.


> > 3) Also about four month ago, I and kamezawa-san pointed out his patch
> >    don't work on memcg. It also haven't been fixed.
> 
> I don't know what you're referring to here, sorry.

You should have read my patch. Even though you haven't use memcg, We do.



>    As kamezawa-san pointed out, This break cgroup and lxr environment.
>    He said,
> 	> Assume 2 proceses A, B which has oom_score_adj of 300 and 0
> 	> And A uses 200M, B uses 1G of memory under 4G system
> 	>
> 	> Under the system.
> 	> 	A's socre = (200M *1000)/4G + 300 = 350
> 	> 	B's score = (1G * 1000)/4G = 250.
> 	>
> 	> In the cpuset, it has 2G of memory.
> 	> 	A's score = (200M * 1000)/2G + 300 = 400
> 	> 	B's socre = (1G * 1000)/2G = 500
> 	>
> 	> This priority-inversion don't happen in current system.



> 
> > In the other hand, You can't explain what worth OOM-rewritten patch has. 
> > Because there is nothing. It is only "powerful"(TM) for Google. but 
> > instead It has zero worth for every other people. Here is just technical 
> > issue. Bah.
> > 
> 
> Please see my reply to Figo.zhang where I enumerate the four reasons why 
> the new userspace tunable is more powerful than oom_adj.

I'm NOT interesting *powerful* crap. Please DON'T talk which is powerful.
I can only said, It's useful only for you.



> At this point, I can only speculate that your distaste for the new oom 
> killer is one of disposition; it seems like everytime you reply to an 
> email (or, more regularly, just repost your revert) that you come into it 
> with the attitude that my response cannot possibly be correct and that the 
> way you see things is exactly as they should be.  If you were to consider 
> other people's opinions, however, you may find some common ground that can 
> be met.  I certainly did that when I introduced oom_score_adj instead of 
> replacing oom_adj immediatley.  I also did it when I removed the forkbomb 
> detector from the rewrite.  I also did it when considering swap in the 
> heuristic when it initially was only rss.  Andrew is in the position where 
> he has to make a judgment call on what should be included and what 
> shouldn't and it should be pretty darn clear after you post your revert 
> the first time, then the second time, then the third time, then the fourth 
> time, and now the fifth time.



