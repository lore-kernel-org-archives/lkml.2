Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab1KUCBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 21:01:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43426 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab1KUCBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 21:01:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 21 Nov 2011 10:59:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Balbir Singh <bsingharora@gmail.com>, Paul Turner <pjt@google.com>,
        <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <a.p.zijlstra@chello.nl>, <jbottomley@parallels.com>,
        <fweisbec@gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
Message-Id: <20111121105957.9c85db16.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4EC52F32.2040708@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-15-git-send-email-glommer@parallels.com>
	<4EBD94A0.9070703@google.com>
	<4EBE4A80.6090607@parallels.com>
	<CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
	<CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>
	<20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>
	<4EC47632.2000904@parallels.com>
	<CAKTCnznzpqUbMJEMwaewwjvMW1fG0J3=a8JxqKiHKNuffO7azg@mail.gmail.com>
	<4EC52F32.2040708@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 13:58:42 -0200
Glauber Costa <glommer@parallels.com> wrote:

> On 11/17/2011 12:58 AM, Balbir Singh wrote:
> > On Thu, Nov 17, 2011 at 8:19 AM, Glauber Costa<glommer@parallels.com>  wrote:
> >> On 11/16/2011 09:52 PM, KAMEZAWA Hiroyuki wrote:
> >>>
> >>> On Wed, 16 Nov 2011 15:51:27 +0530
> >>> Balbir Singh<bsingharora@gmail.com>    wrote:
> >>>
> >>>>>
> >>>>> On the other hand, I don't think much discussion remains for cpuacct,
> >>>>> everyone's pretty unanimous in that they'd like to see it deprecated.
> >>>>> By splitting this up we can close out that quickly while we figure out
> >>>>> the
> >>>>> best way to resolve the above.
> >>>>>
> >>>>
> >>>> I'd give it a thumbs up, if we can create sched groups and provide
> >>>> accounting without control - like we can for the memory cgroup today.
> >>>>
> >>>
> >>> Isn't it possible ?
> >>>
> >>> Thanks,
> >>> -Kame
> >>>
> >> I must say I don't really understand what exactly you propose, and how it is
> >> different from what we have today.
> >>
> >> My take is that you are talking about a single cgroup in which you can have
> >> the functionality of both cpuacct and cpu, but surrounded by knobs that
> >> allows you to turn them off individually.
> >>
> >> Am I right?
> >>
> >
> > No here is what I am asking for
> >
> > I don't want CPU control, just accounting, so I create the following groups
> >
> >                            a
> >                         /    \
> >                        V    V
> >                        b     c
> >
> > Today, with the cpu controller, the moment I create a, b and c, they
> > get default shares and if I put tasks, their b/w is decided by the
> > shares, what if I don't want control, but I want to account for their
> > time only?
> >
> > Balbir
> 
> I think that if this really a requirement, cpuacct should stay. I was 
> working under the assumption that it was not really an important case - 
> so thanks for the clarification. Peter and Paul can chime in here, but I 
> think that this requirement poses constraints to the cpu cgroup and 
> consequently the scheduler - both in its current incarnation and in what 
> come in the future - that may not be acceptable. What I am concerned 
> about is that it might mandate the scheduler to always test whether or 
> not the grouping has a scheduling effect or not - and then walk the 
> group if it is not, etc. In a summary, if we can or cannot bundle 
> processes together for scheduling purposes, we'll likely need separate 
> data structures anyway.
> 
> A lot of the code I wrote can be reused to at least make it faster in 
> the case in which only the root is mounted - for cpuacct.stat at least.
> 
> However, the big question remains: The most expensive operation for 
> cpuacct also seem to be the most important, cpuusage, which was a big 
> part of the motivation to bundle them all together. Maybe then Paul's 
> co-mounting idea starts to make sense, but it will still be quite slow 
> for your usage, in which the groups are clearly different.
> 
> I think the best I can come up with right now, is to base my work on 
> cpuacct - I am fine with that, and it was actually how my first version 
> looked like - and then think about a way to make cpuusage faster later...
> 

Could you share your analysis why cpuacct cgroup is slow ?

Thanks,
-Kame


