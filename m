Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1LOHWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:22:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab1LOHWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:22:50 -0500
Date: Thu, 15 Dec 2011 08:20:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] sched: mark parent and real_parent as __rcu
Message-ID: <20111215072058.GA23205@elte.hu>
References: <20111214223925.GA27578@www.outflux.net>
 <20111215070857.GD14237@elte.hu>
 <CAGXu5jLEiB4i1_WCkDz3MDM=LBKKWB_cqhOWcpzEYAon0YZp8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jLEiB4i1_WCkDz3MDM=LBKKWB_cqhOWcpzEYAon0YZp8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> On Wed, Dec 14, 2011 at 11:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > * Kees Cook <keescook@chromium.org> wrote:
> >
> >> The parent and real_parent pointers should be considered __rcu, since
> >> they should be held under either tasklist_lock or rcu_read_lock.
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> ---
> >>  include/linux/sched.h |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > Did you get some warning that alerted you to this problem? If
> > yes then please include it in the changelog, so that people
> > hitting the message can easily find it.
> >
> > Same consideration applies the second patch as well.
> 
> No, this was via code inspection related to reviews of the 
> Yama LSM's use of these structures and comparing the RCU and 
> tasklist_lock behavior/requirements seen in the rest of the 
> kernel. Most attempts at using sparse after this change were 
> not very successful due to the high volume of unrelated noise 
> currently seen with "make C=2", but I was able to confirm that 
> the apparmor and tomoyo patches were flagged by sparse, at 
> least. When this __rcu marking is in place, if there is a 
> place that might need rcu_dereference, it would show up as 
> "warning: dereference of noderef expression".

ok - i'll apply the first patch, please send the second one 
against -tip, it does not apply anymore. (scheduler got moved to 
kernel/sched/)

Thanks,

	Ingo
