Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1JLODV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:03:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59898 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1JLODU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:03:20 -0400
Date: Wed, 12 Oct 2011 16:03:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        jbottomley@parallels.com
Subject: Re: [PATCH 05/10] Make total_forks per-cgroup
Message-ID: <20111012140310.GG14968@somewhere>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
 <1317583287-18300-6-git-send-email-glommer@parallels.com>
 <1317805535.6766.6.camel@twins>
 <4E8C4990.1050704@parallels.com>
 <20111011234548.GB14968@somewhere>
 <4E954356.2000409@parallels.com>
 <20111012125857.GE14968@somewhere>
 <4E958F1B.80605@parallels.com>
 <20111012130344.GF14968@somewhere>
 <4E959038.2090801@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E959038.2090801@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 05:03:52PM +0400, Glauber Costa wrote:
> On 10/12/2011 05:03 PM, Frederic Weisbecker wrote:
> >On Wed, Oct 12, 2011 at 04:59:07PM +0400, Glauber Costa wrote:
> >>On 10/12/2011 04:59 PM, Frederic Weisbecker wrote:
> >>>On Wed, Oct 12, 2011 at 11:35:50AM +0400, Glauber Costa wrote:
> >>>>On 10/12/2011 03:45 AM, Frederic Weisbecker wrote:
> >>>Is your counting propagated to the parents in a hierarchy?
> >>>For example if A is parent cgroup of B and C, does A account the
> >>>forks happening in B and C?
> >>
> >>Yes.
> >
> >But only to the first parent or also all ancestors?
> it keeps going until it reaches the root task group.

Using the task counter subsystem for that would involve
a bit more complications like adding a new counter on it
that would need to be incremented in parallel but differently.
You would also need to bind this subsystem anytime you
want this statistic.

I don't think it's worth doing this. You would also get the
overhead in the exit path because the subsystem also uncharge
one of its counters across the whole hierarchy.

OTOH, it's scary to see that new feature will walk
the entire hierarchy on every fork when CONFIG_CGROUP_SCHED=y
And I guess that today this config is easily selected by
distros.

IIUC that walk also happen on every timer interrupt for
the user/system/idle cpu time accounting?

May be this should reside in a seperate config, so that those
that don't care about the per cgroup stats avoid that
overhead?
