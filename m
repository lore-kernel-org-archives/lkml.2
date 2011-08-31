Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1HaNmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:42:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42790 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab1HaNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:42:30 -0400
Date: Wed, 31 Aug 2011 15:42:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] cgroup: kill subsys->can_attach_task(), pre_attach()
 and attach_task()
Message-ID: <20110831134220.GB20598@somewhere>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
 <1314312192-26885-7-git-send-email-tj@kernel.org>
 <20110830201030.GC15953@somewhere.redhat.com>
 <20110831070313.GA29179@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831070313.GA29179@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 09:03:13AM +0200, Tejun Heo wrote:
> Hello, Frederic.
> 
> On Tue, Aug 30, 2011 at 10:10:32PM +0200, Frederic Weisbecker wrote:
> > In order to keep the fix queued in -mm (https://lkml.org/lkml/2011/8/26/262)
> > the tasks that have failed to migrate should be removed from the iterator
> > so that they are not included in the batch in ->attach().
> 
> I don't think that's a good approach.  It breaks the symmetry when
> calling different callbacks.  What if ->can_attach() allocates
> per-task resources and the task exits in the middle?  I think we
> better lock down fork/exit/exec.  I'll send patches but I'm currently
> moving / traveling w/ limited access to my toys so it might take some
> time.

My task counter subsystem patchset brings a cancel_attach_task() callback
that cancels can_attach_task() effects.

I thought that rebased on top of your patch it's going to be merged inside
cancel_attach() but OTOH we can't cancel the effect of failed migration
on a thread that way.

May be we need to keep a cancel_attach_task() just for that purpose?
