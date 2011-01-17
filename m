Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1AQP4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 10:56:17 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59162 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab1AQP4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 10:56:15 -0500
Date: Mon, 17 Jan 2011 21:23:16 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com
Subject: Re: [RFC -v5 PATCH 2/4] sched: Add yield_to(task, preempt)
 functionality.
Message-ID: <20110117155315.GA20416@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20110114030209.53765a0a@annuminas.surriel.com>
 <20110114030357.03c3060a@annuminas.surriel.com>
 <20110114174741.GB28632@linux.vnet.ibm.com>
 <4D309620.60507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D309620.60507@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 01:29:52PM -0500, Rik van Riel wrote:
> >I am not sure whether we are meeting that objective via this patch, as
> >lock-spinning vcpu would simply yield after setting next buddy to preferred
> >vcpu on target pcpu, thereby leaking some amount of bandwidth on the pcpu
> >where it is spinning.
> 
> Have you read the patch?

Sorry had mis-read the patch!

On reviewing it further, I am wondering if we can optimize yield_to() further
for case when target and current are on same pcpu, by swapping vruntimes of two
tasks (to let target run in current's place - as we do in task_fork_fair()).

- vatsa
