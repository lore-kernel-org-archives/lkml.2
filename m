Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461Ab2EQAQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:16:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54091 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964943Ab2EQAQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:16:09 -0400
Date: Wed, 16 May 2012 17:15:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: skip nr_running sanity check in
 worker_enter_idle() if trustee is active
Message-ID: <20120517001511.GA14301@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120506153814.GA25681@linux.vnet.ibm.com>
 <20120507194042.GG19417@google.com>
 <20120507205516.GD21152@linux.vnet.ibm.com>
 <20120507213449.GM19417@google.com>
 <20120514221250.GA8414@google.com>
 <20120514224123.GO2441@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120514224123.GO2441@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051700-2398-0000-0000-000006B4E13A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 03:41:23PM -0700, Paul E. McKenney wrote:
> On Mon, May 14, 2012 at 03:12:50PM -0700, Tejun Heo wrote:
> > >From 544ecf310f0e7f51fa057ac2a295fc1b3b35a9d3 Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj@kernel.org>
> > Date: Mon, 14 May 2012 15:04:50 -0700
> > 
> > worker_enter_idle() has WARN_ON_ONCE() which triggers if nr_running
> > isn't zero when every worker is idle.  This can trigger spuriously
> > while a cpu is going down due to the way trustee sets %WORKER_ROGUE
> > and zaps nr_running.
> > 
> > It first sets %WORKER_ROGUE on all workers without updating
> > nr_running, releases gcwq->lock, schedules, regrabs gcwq->lock and
> > then zaps nr_running.  If the last running worker enters idle
> > inbetween, it would see stale nr_running which hasn't been zapped yet
> > and trigger the WARN_ON_ONCE().
> > 
> > Fix it by performing the sanity check iff the trustee is idle.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > Cc: stable@vger.kernel.org
> > ---
> > Sorry about the delay.  After scratching my head quite a bit, I found
> > where during cpu-offlining such discrepancy may happen.  I'm fairly
> > sure this is it but I might be wrong, so please include this patch in
> > your test setup and let me know how it goes.
> 
> Thank you -- I have applied it, and will let you know how it goes.

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

							Thanx, Paul

