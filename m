Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0KMSpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 13:45:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107Ab0KMSpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 13:45:17 -0500
Date: Sat, 13 Nov 2010 19:38:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC][PATCH v2 5/7] taskstats: Improve cumulative CPU time
	accounting
Message-ID: <20101113183810.GA9021@redhat.com>
References: <20101111170352.732381138@linux.vnet.ibm.com> <20101111170815.404670062@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111170815.404670062@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, let me repeat, I am not going to discuss whether we need
these changes or not, I do not know even if I understand your motivation.

My only concern is correctness, but

On 11/11, Michael Holzheu wrote:
>
> * Add cumulative dead thread CPU times to taskstats
> * Introduce parallel accounting process hierarchy (based on discussions
>   with Oleg Nesterov and Roland McGrath)

Michael, I really think this patch does too many different things.
I forgot the details of our previous discussion, and I got lost
trying to understand the new version.

I already asked you to split these changes, perhaps you can do this?
Say, bacct_add_tsk() looks overcomplicated, the change in copy_process()
shouldn't introduce the new CLONE_THREAD check, not sure I understand
why release_task() was chosen for reparenting, other nits...

But it is not easy to discuss these completely different things
looking at the single patch.

Imho, it would be much better if you make a separate patch which
adds acct_parent/etc and implements the parallel hierarchy. This
also makes sense because it touches the core kernel.

Personally I think that even "struct cdata" + __account_ctime() helper
needs a separate patch, and perhaps this change makes sense by itself
as cleanup. And this way the "trivial" changes (like the changes in
k_getrusage) won't distract from the functional changes.

The final change should introduce cdata_acct and actually implement
the complete cumulative accounting.

At least, please distill parallel accounting process hierarchy.
We do not want bugs in this area ;)

What do you think?

Oleg.

