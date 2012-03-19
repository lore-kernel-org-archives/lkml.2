Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab2CTACU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 20:02:20 -0400
Received: from ozlabs.org ([203.10.76.45]:49158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab2CTACS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 20:02:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo\@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: CPU Hotplug rework
In-Reply-To: <4F674649.2000300@linux.vnet.ibm.com>
References: <4F674649.2000300@linux.vnet.ibm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 20 Mar 2012 10:12:10 +1030
Message-ID: <87aa3cqht9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 20:14:25 +0530, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Hi,
> 
> There had been some discussion on CPU Hotplug redesign/rework
> some time ago, but it was buried under a thread with a different
> subject.
> (http://thread.gmane.org/gmane.linux.kernel/1246208/focus=1246404)
> 
> So I am opening a new thread with an appropriate subject to discuss
> what needs to be done and how to go about it, as part of the rework.
> 
> Peter Zijlstra and Paul McKenney had come up with TODO lists for the
> rework, and here are their extracts from the previous discussion:

This is possible, but quite a lot of tricky auditing work.  There's an
underlying assumption that stop_machine is the slow part, since it feels
so heavy.

Unfortunately, this doesn't seem to be the case in my testing.  The time
for hotplug seems to be moving all the threads around.  So how about:

(1) Let's not shutdown per-cpu kthreads, just leave them there to run
    if the CPU comes back.

(2) Do something more efficient with userspace threads than migrating
    them one at a time.

Otherwise, we risk doing a great deal of work and gaining nothing
(cleanups aside, of course).

Thanks,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
