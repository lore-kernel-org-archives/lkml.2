Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab1ALIr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:47:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:55363 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754758Ab1ALIrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:47:24 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+bR9x+wZ6bn7uKNpWC52YxnT0oN2uq8PF94Wn2LV
	4ZkiQyu/dser3f
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: bharata@linux.vnet.ibm.com
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110112080620.GG2723@in.ibm.com>
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
	 <20110112080620.GG2723@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 09:47:19 +0100
Message-ID: <1294822039.8370.97.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 13:36 +0530, Bharata B Rao wrote:
> On Wed, Jan 12, 2011 at 08:24:41AM +0100, Mike Galbraith wrote:

> > Yes, it's supposed to be transparent to cgroups.
> 
> If cgroups doesn't want that task and if its transparent to cgroups,
> why is it shown as part of /cgroups/tasks ? The task really doesn't
> belong in there. Its not on the runqueue of root_task_group.
> 
> So basically I feel that a task consumed by autogroup shouldn't ideally be
> shown in root cgroup's tasks file.

>From cgroups' viewpoint, root is where it's at.  The task isn't consumed
by autogroup either, it's only borrowed until cgroups claims it.

Would you prefer that when you mount /cgroups, you see a nearly empty
root task list because box was booted with autogroup enabled?  Should
tasks appear and disappear on the fly while you're watching?

The goal is peaceful coexistence.  The user can turn either or both both
on/off at his/her whim.

	-Mike

