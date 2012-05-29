Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2E2QKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:10:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab2E2QKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:10:22 -0400
Date: Tue, 29 May 2012 18:08:55 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/35] AutoNUMA alpha14
Message-ID: <20120529160855.GD21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <4FC112AB.1040605@redhat.com>
 <CA+55aFxpD+LsE+aNvDJtz9sGsGMvdusisgOY3Csbzyx1mEqW-w@mail.gmail.com>
 <alpine.DEB.2.00.1205291033360.6723@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205291033360.6723@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 29, 2012 at 10:53:32AM -0500, Christoph Lameter wrote:
> then does the distribution of the load on its own. NUMA aware applications
> like that do not benefit and do not need either of the mechanisms proposed
> here.

Agreed. Who changes the apps to optimize things to that lowlevel, I
doubt wants to risk to hit on on a migrate on fault (or AutoNUMA async
migration for that matter).

> I think the proof that we need is that a general mix of applications
> actually benefits from an auto migration scheme. I would also like to see

Agreed.

> that it does no harm to existing NUMA aware applications.

As far as AutoNUMA is concerned, it will be a total bypass whenever
the mpol isn't MPOL_DEFAULT. So it shouldn't harm. Shared memory is
also bypassed.

It only alters the beahvior of MPOL_DEFAULT, any other kind of
mempolicy is unaffected, and all CPU bindings are also unaffected.

If an app has only a few vmas that are MPOL_DEFAULT those few will be
handled by AutoNUMA.

If people thinks AutoMigration is a better name I should rename
it. It's up to you. I thought using a "NUMA" suffix  would make it
more intuitive that if your hardware isn't NUMA, this won't do
anything at all. Migration as a feature isn't limited to NUMA (see
compaction etc..). Comments welcome.
