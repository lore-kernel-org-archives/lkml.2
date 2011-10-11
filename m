Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab1JKXp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 19:45:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50081 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1JKXp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 19:45:56 -0400
Date: Wed, 12 Oct 2011 01:45:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        jbottomley@parallels.com
Subject: Re: [PATCH 05/10] Make total_forks per-cgroup
Message-ID: <20111011234548.GB14968@somewhere>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
 <1317583287-18300-6-git-send-email-glommer@parallels.com>
 <1317805535.6766.6.camel@twins>
 <4E8C4990.1050704@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8C4990.1050704@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 04:12:00PM +0400, Glauber Costa wrote:
> On 10/05/2011 01:05 PM, Peter Zijlstra wrote:
> >On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
> >>This patch counts the total number of forks per-cgroup.
> >>The information is propagated to the parent, so the total
> >>number of forks in the system, is the parent cgroup's one.
> >>
> >>To achieve that, total_forks is made per-cpu. There is no
> >>particular reason to do that, but by doing this, we are
> >>able to bundle it inside the cpustat structure already
> >>present.
> >
> >I think fweisbec is also doing something with forks and cgroups.
> 
> I am all ears...
> 
> Frederic, does it conflict with what you're doing ?

I don't know if that really conflicts but I'm working
on a cgroup subsystem that is able to control the number
of tasks running in a subsystem.

It consists in two new files added:

* tasks.usage
* tasks.limit

The subsystem rejects any new fork or migration into the
cgroup when tasks.usage > tasks.limit

So tasks.usage can inform you about the number of tasks
running into the cgroup. It's not strictly the number
of forks because it also counts the tasks that have been
attached to the cgroup.

But something like a tasks.fork file could be implemented
in that subsystem as well.

It depends on what you need.
