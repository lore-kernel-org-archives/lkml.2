Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab1ANRQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:16:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:60601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab1ANRQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:16:00 -0500
Subject: Re: [RFC -v5 PATCH 2/4] sched: Add yield_to(task, preempt)
 functionality.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com
In-Reply-To: <20110114030357.03c3060a@annuminas.surriel.com>
References: <20110114030209.53765a0a@annuminas.surriel.com>
	 <20110114030357.03c3060a@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 14 Jan 2011 18:15:43 +0100
Message-ID: <1295025343.2274.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 03:03 -0500, Rik van Riel wrote:
> From: Mike Galbraith <efault@gmx.de>
> 
> Currently only implemented for fair class tasks.
> 
> Add a yield_to_task method() to the fair scheduling class. allowing the
> caller of yield_to() to accelerate another thread in it's thread group,
> task group.
> 
> Implemented via a scheduler hint, using cfs_rq->next to encourage the
> target being selected.  We can rely on pick_next_entity to keep things
> fair, so noone can accelerate a thread that has already used its fair
> share of CPU time.
> 
> This also means callers should only call yield_to when they really
> mean it.  Calling it too often can result in the scheduler just
> ignoring the hint.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Mike Galbraith <efault@gmx.de> 

Looks good to me, do you want me to merge this or will you merge it
through the kvm tree with all other patches?

