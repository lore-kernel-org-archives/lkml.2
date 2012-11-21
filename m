Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2KURkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:40:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48947 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2KURkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:40:20 -0500
Date: Wed, 21 Nov 2012 18:40:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
Message-ID: <20121121174015.GA29331@gmail.com>
References: <20121119162909.GL8218@suse.de>
 <alpine.DEB.2.00.1211191644340.24618@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1211191703270.24618@chino.kir.corp.google.com>
 <20121120060014.GA14065@gmail.com>
 <alpine.DEB.2.00.1211192213420.5498@chino.kir.corp.google.com>
 <20121120074445.GA14539@gmail.com>
 <alpine.DEB.2.00.1211200001420.16449@chino.kir.corp.google.com>
 <20121120090637.GA14873@gmail.com>
 <CA+55aFyR9FsGYWSKkgsnZB7JhheDMjEQgbzb0gsqawSTpetPvA@mail.gmail.com>
 <20121121171047.GA28875@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121171047.GA28875@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> So because I did not have an old-glibc system like David's, I 
> did not know the actual page fault rate. If it is high enough 
> then nonlinear effects might cause such effects.
> 
> This is an entirely valid line of inquiry IMO.

Btw., when comparing against 'mainline' I routinely use a 
vanilla kernel that has the same optimization applied. (first I 
make sure it's not a regression to vanilla.)

I do that to factor out the linear component of the independent 
speedup: it would not be valid to compare vanilla against 
numa/core+optimization, but the comparison has to be:

       vanilla + optimization
  vs.
     numa/core + optimization

I did that with last night's numbers as well.

So any of this can only address a regression if a non-linear 
factor is in play.

Since I have no direct access to a regressing system I have to 
work with the theories that I can think of: one had a larger 
effect, the other had a smaller effect, the third one had no 
effect on David's system.

How would you have done it instead?

Thanks,

	Ingo
