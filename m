Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab1ALIGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:06:23 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50414 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab1ALIGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:06:21 -0500
Date: Wed, 12 Jan 2011 13:36:20 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
Message-ID: <20110112080620.GG2723@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110110091622.GF2772@in.ibm.com>
 <1294655388.8197.22.camel@marge.simson.net>
 <1294657154.2016.459.camel@laptop>
 <1294677746.8345.4.camel@marge.simson.net>
 <20110111171046.GL4772@in.ibm.com>
 <1294771686.8006.15.camel@marge.simson.net>
 <20110112033709.GA2723@in.ibm.com>
 <AANLkTikFGqznUg7bzFckJy_x2mfBqE7PjaK2n83wLk6c@mail.gmail.com>
 <20110112063543.GD2723@in.ibm.com>
 <1294817081.8370.60.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294817081.8370.60.camel@marge.simson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 08:24:41AM +0100, Mike Galbraith wrote:
> On Wed, 2011-01-12 at 12:05 +0530, Bharata B Rao wrote:
> > On Wed, Jan 12, 2011 at 01:40:32PM +0800, Yong Zhang wrote:
> 
> > > IMHO, task->cgroups will not change when autogroup take effect.
> > 
> > Yes and I believe this is cause for some of the weird semantics I see
> > with autogroup and cgroups. I am not sure if this has already been
> > discussed ealier, may be I need to go back and check the archives, but
> > consider this:
> > 
> > I have cpu cgroup mounted at /cgroup and see that all the tasks in the
> > system are listed in /cgroup/tasks file.
> > 
> > Now I start a task like this:
> > 
> > # ./while1 &
> > [1] 2761
> > 
> > and see that this task belongs to root cgroup.
> 
> Yes, cgroups sees cgroup associations, not autogroup associations.
> 
> > # grep 2761 /cgroup/tasks
> > 2671
> > 
> > But we know that this task really belongs to an autogroup and is not
> > sitting directly on root_task_group.
> 
> Yup, cgroups doesn't want it, so autogroup (if enabled) claims it.
> 
> > # cat /proc/2761/autogroup 
> > /autogroup-49 nice 0
> > 
> > So we have a task in an autogroup (which is a sub group of root_task_group)
> > but is being shown as part of root_task_group. Is this by design ?
> 
> Yes, it's supposed to be transparent to cgroups.

If cgroups doesn't want that task and if its transparent to cgroups,
why is it shown as part of /cgroups/tasks ? The task really doesn't
belong in there. Its not on the runqueue of root_task_group.

So basically I feel that a task consumed by autogroup shouldn't ideally be
shown in root cgroup's tasks file.

Regards,
Bharata.
