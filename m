Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750797Ab1ITNFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:05:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35374 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1ITNFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:05:51 -0400
Subject: Re: [PATCH 6/9] Include idle and iowait fields in cpuacct
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Tue, 20 Sep 2011 15:05:28 +0200
In-Reply-To: <4E788E08.2020707@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	   <1316030695-19826-7-git-send-email-glommer@parallels.com>
	  <1316510490.11841.15.camel@twins> <4E7888B8.3080809@parallels.com>
	 <1316523502.13664.5.camel@twins> <4E788E08.2020707@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316523928.13664.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 09:58 -0300, Glauber Costa wrote:
> On 09/20/2011 09:58 AM, Peter Zijlstra wrote:
> > On Tue, 2011-09-20 at 09:36 -0300, Glauber Costa wrote:
> >> On 09/20/2011 06:21 AM, Peter Zijlstra wrote:
> >>> On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
> >>>> These are slightly different from the others though:
> >>>> (note to reviewers: might be better to put those in a separate
> >>>> array?)
> >>>>
> >>>> Since idle/iowait are a property of the system - by definition,
> >>>> no process from any cgroup is running when the system is idle,
> >>>> they are system wide. So what these fields really mean, are baselines
> >>>> for when the cgroup was created. It allows the cgroup to start
> >>>> counting idle/iowait from 0.
> >>>
> >>> Alternatively you can make iowait based on nr_uninterruptible per cgroup
> >>> and count all ticks _this_ cgroup was idle.
> >> You think?
> >>
> >> Humm,humm... maybe...
> >> iowait can indeed be seen as a process group characteristic. I was
> >> mainly concerned about overhead here, specially for the idle case:
> >
> > The overhead of accounting per cgroup nr_uninterruptible is the worst I
> > think, that's in the sleep/wakeup paths.
> >
> >> If we are idle, there is no task context we can draw from, since the
> >> task in the cpu is the idle task. So we end up having to touch all
> >> cgroups... Or am I missing something?
> >>
> >> Sounds expensive.
> >
> > Count the total number of ticks on the cpu (I think we already have
> > that) and subtract the number of ticks in this cgroup (I think we also
> > already have that), which should yield: number of ticks not in this
> > cgroup, aka number of ticks this cgroup was idle.
> No , no... remember steal time.

Of course I don't.. that's virt stuff, I repress that with all my might.
But add or subtract steal ticks someplace and it doesn't come out right?
