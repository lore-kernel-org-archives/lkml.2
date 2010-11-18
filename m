Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab0KRRRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:17:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab0KRRRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:17:33 -0500
Date: Thu, 18 Nov 2010 18:10:01 +0100
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
Message-ID: <20101118171001.GB3249@redhat.com>
References: <20101111170352.732381138@linux.vnet.ibm.com> <20101111170815.404670062@linux.vnet.ibm.com> <20101113183810.GA9021@redhat.com> <1289926635.1940.100.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289926635.1940.100.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay.

On 11/16, Michael Holzheu wrote:
>
> On Sat, 2010-11-13 at 19:38 +0100, Oleg Nesterov wrote:
> > First of all, let me repeat, I am not going to discuss whether we need
> > these changes or not, I do not know even if I understand your motivation.
>
> Sorry, if I was not clear enough with my descriptions. Let me try to
> describe my motivation again:

Yes, more or less I see what this patch does (I hope ;).

> 2. Because of reparent to init, there are situations where it is
>    not clear to which tasks the CPU time of dead tasks between
>    two snapshots has been accounted. This is a problem for example 2.

Yes, I see.

But I must admit, _personally_ I am not sure this problem worth the
trouble. And, I already mentioned daemonize() case, IOW I am not sure
it is _always_ right to choose exiting_parent->parent for accounting.
To me, this can be equally confusing. A user sees the running deamon
with ppid = 1, then this daemon exits and top reports the "unrelated"
process as cpu consumer.


But once again. I am _not_ against this patch. I never know when it
comes to new features. Certainly you know better if this suits top.

What I actually meant is: dear CC list, please look at this change
and comment ;)

Oleg.

