Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1JCKVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:21:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab1JCKVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:21:25 -0400
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <htejun@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 03 Oct 2011 12:20:38 +0200
In-Reply-To: <20111003011506.GE31799@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
	 <20110930034815.GF10425@mtj.dyndns.org>
	 <1317355529.4588.45.camel@gandalf.stny.rr.com>
	 <20110930041424.GH10425@mtj.dyndns.org> <1317371699.19415.6.camel@twins>
	 <20110930085510.GA23868@mtj.dyndns.org> <1317373473.19415.10.camel@twins>
	 <20111003011506.GE31799@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317637238.20367.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-02 at 18:15 -0700, Tejun Heo wrote:
> Anyways, I don't think I'm gonna take this one.  There are some
> attractions to the approach - ie. making the users determine whether
> they need strict affinity or not and mandating those users to shut
> down properly from cpu down callbacks and if we're doing this from the
> scratch, this probably would be a sane choice.  But we already have
> tons of users and relatively well tested code.  I don't see compelling
> reasons to perturb that at this point.
> 
So wtf am I going to do with people who want PF_THREAD_BOUND to actually
do what it means? Put a warning in the scheduler code to flag all
violations and let you sort out the workqueue fallout?

I didn't write this change for fun, I actually need to get
PF_THREAD_BOUND back to sanity, this change alone isn't enough, but it
gets rid of the worst abuse. This isn't frivolous perturbation.

> Also, on a quick glance, the change is breaking non-reentrance
> guarantee.
> 
How so? Afaict it does exactly what the trustee thread used to do, or is
it is related to the NON_AFFINE moving the worklets around?
