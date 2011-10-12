Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1JLNDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:03:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58983 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1JLNDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:03:52 -0400
Date: Wed, 12 Oct 2011 15:03:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        jbottomley@parallels.com
Subject: Re: [PATCH 05/10] Make total_forks per-cgroup
Message-ID: <20111012130344.GF14968@somewhere>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
 <1317583287-18300-6-git-send-email-glommer@parallels.com>
 <1317805535.6766.6.camel@twins>
 <4E8C4990.1050704@parallels.com>
 <20111011234548.GB14968@somewhere>
 <4E954356.2000409@parallels.com>
 <20111012125857.GE14968@somewhere>
 <4E958F1B.80605@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E958F1B.80605@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 04:59:07PM +0400, Glauber Costa wrote:
> On 10/12/2011 04:59 PM, Frederic Weisbecker wrote:
> >On Wed, Oct 12, 2011 at 11:35:50AM +0400, Glauber Costa wrote:
> >>On 10/12/2011 03:45 AM, Frederic Weisbecker wrote:
> >>>On Wed, Oct 05, 2011 at 04:12:00PM +0400, Glauber Costa wrote:
> >>>>On 10/05/2011 01:05 PM, Peter Zijlstra wrote:
> >>>>>On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
> >>>>>>This patch counts the total number of forks per-cgroup.
> >>>>>>The information is propagated to the parent, so the total
> >>>>>>number of forks in the system, is the parent cgroup's one.
> >>>>>>
> >>>>>>To achieve that, total_forks is made per-cpu. There is no
> >>>>>>particular reason to do that, but by doing this, we are
> >>>>>>able to bundle it inside the cpustat structure already
> >>>>>>present.
> >>>>>
> >>>>>I think fweisbec is also doing something with forks and cgroups.
> >>>>
> >>>>I am all ears...
> >>>>
> >>>>Frederic, does it conflict with what you're doing ?
> >>>
> >>>I don't know if that really conflicts but I'm working
> >>>on a cgroup subsystem that is able to control the number
> >>>of tasks running in a subsystem.
> >>>
> >>>It consists in two new files added:
> >>>
> >>>* tasks.usage
> >>>* tasks.limit
> >>>
> >>>The subsystem rejects any new fork or migration into the
> >>>cgroup when tasks.usage>   tasks.limit
> >>>
> >>>So tasks.usage can inform you about the number of tasks
> >>>running into the cgroup. It's not strictly the number
> >>>of forks because it also counts the tasks that have been
> >>>attached to the cgroup.
> >>>
> >>>But something like a tasks.fork file could be implemented
> >>>in that subsystem as well.
> >>>
> >>>It depends on what you need.
> >>
> >>So the specific piece I am working on, is to display /proc/stat
> >>information per-cgroup. One of the many fields it has, is
> >>total_forks.
> >>(it is actually just a small part of the series)
> >>So instead of tracking how many forks the system has in total, I'll
> >>track it per-cpucgroup.
> >>
> >>So I don't think we conflict at all. At the very least, IIUC, you
> >>are planning to account and check *before* a fork happens, right?
> >>This particular stat is incremented after it already succeeded.
> >
> >That doesn't make much difference since the accounting is cancelled
> >in case the fork is finally rejected.
> >
> >But probably having a simple accouting like you do involves less
> >overhead than the whole task counter subsystem.
> >
> >Is your counting propagated to the parents in a hierarchy?
> >For example if A is parent cgroup of B and C, does A account the
> >forks happening in B and C?
> 
> Yes.

But only to the first parent or also all ancestors?
