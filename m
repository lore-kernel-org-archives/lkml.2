Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab1CCUbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:31:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758196Ab1CCUbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:31:19 -0500
Date: Thu, 3 Mar 2011 21:22:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110303202246.GB32152@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org> <20110303173422.GA27960@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303173422.GA27960@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03, Oleg Nesterov wrote:
>
> I'll ask the questions later.

Right now I do not see any holes (but I'll try more ;)

One question, to ensure I really understand you. To simplify,
consider this particular example.

Tracee:

	int main(void)
	{
		kill(SIGSTOP, getpid());

		printf("I am running\n");

		for (;;)
			;
	}

To simplify again, suppose that the debugger attaches when it is
already stopped, then it does PTRACE_CONT(0).

In this case the tracee remains SIGNAL_STOP_STOPPED but prints
"I am running" and enters the endless loop.

(the new debugger can do PTRACE_SEIZE after that and "return"
 it to the stopped state without affecting jctl state).

Now, if SIGCONT comes (from anywhere) it clears SIGNAL_STOP_STOPPED,
the tracee traps and reports this event to debugger.

Correct?


And, once again. In the mt case, I assume that SIGCONT makes
every traced thread to report this event individually, right?

(I am talking about the case when the group-stop was finished,
 iow "every" probably means the threads which participated and
 reported CLD_STOPPED to the debugger).


In both cases, later then this SIGCONT will be reported again
as any "normal" signal when some thread dequeues it.


Is my understanding correct?

Thanks,

Oleg.

