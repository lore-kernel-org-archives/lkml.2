Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0DIGEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0DIGEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:04:48 -0400
Message-ID: <4BBEC082.10106@redhat.com>
Date: Fri, 09 Apr 2010 01:52:02 -0400
From: john cooper <john.cooper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Darren Hart <dvhltc@us.ibm.com>
CC: john cooper <john.cooper@third-harmonic.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       Chris Wright <chrisw@sous-sol.org>, john.cooper@redhat.com
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com> <4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop> <20100406145128.6324ac9a@lxorguk.ukuu.org.uk> <4BBB531A.4070500@us.ibm.com> <4BBB5C0D.8050602@redhat.com> <alpine.LFD.2.00.1004061809080.32352@localhost.localdomain> <4BBB5F52.4000403@redhat.com> <4BBC23C2.4080100@third-harmonic.com> <4BBD4E9C.2040500@us.ibm.com>
In-Reply-To: <4BBD4E9C.2040500@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> john cooper wrote:
>> But here we're otherwise completely
>> open to indiscriminate scheduling preemption even though
>> we may be holding a userland lock.
> 
> That's true with any userland lock.

Agreed.  However from your earlier mail it seemed
addressing this scenario was within the scope of
consideration.

There are two ways to deal with this condition, either
reactive in the sense we do so after the lock holder
has been preempted and subsequently find we're spinning
in sibling thread context attempting to acquire the
lock.  Or proactively where we provide a time bounded
deferral of lock holder preemption with the assumption
the lock hold path overhead has negligible effect upon
deferring a potentially coincident scheduling operation.

It is fairly straightforward to demonstrate the impact
to performance with a focused micro benchmark, less so
for a more "typical" application with the effect being
diluted among other app activity.
 
The two approaches are complimentary with differing
system wide tradeoffs.  Both require some insight into
the scheduling disposition of the lock holder, the
preemption deferral mechanism more so.  If a scheme to
expose scheduler state transitions to (or cooperate
with) userland locking primitives is being considered,
it seems opportune to consider support as well for
this scenario.

-john

-- 
john.cooper@redhat.com
