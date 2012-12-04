Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2LDRab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 12:30:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:44972 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2LDRaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 12:30:30 -0500
Date: Tue, 4 Dec 2012 18:30:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mel Gorman <mgorman@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/10] Latest numa/core release, v18
In-Reply-To: <20121203134110.GL8218@suse.de>
Message-ID: <alpine.LFD.2.02.1212041825140.2701@ionos>
References: <1354305521-11583-1-git-send-email-mingo@kernel.org> <CA+55aFwjxm7OYuucHeE2WFr4p+jwr63t=kSdHndta_QkyFbyBQ@mail.gmail.com> <20121203134110.GL8218@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012, Mel Gorman wrote:
> On Fri, Nov 30, 2012 at 12:37:49PM -0800, Linus Torvalds wrote:
> > So if this is a migration-specific scalability issue, then it might be
> > possible to solve by making the mutex be a rwsem instead, and have
> > migration only take it for reading.
> > 
> > Of course, I'm quite possibly wrong, and the code depends on full
> > mutual exclusion.
> > 
> > Just a thought, in case it makes somebody go "Hmm.."
> > 
> 
> Offhand, I cannot think of a reason why a rwsem would not work. This
> thing originally became a mutex because the RT people (Peter in
> particular) cared about being able to preempt faster. It'd be nice if
> they confirmed that rwsem is not be a problem for them.

rwsems are preemptable as well. So I don't think this was Peter's main
concern. If it works with an rwsem, then go ahead.

rwsems degrade on RT because we cannot do multiple reader boosting, so
they allow only a single reader which can take it recursive. But
that's an RT specific issue and nothing you should worry about.

Thanks,

	tglx
