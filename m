Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1A1Vap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 16:30:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab1A1Vao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 16:30:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 08/10] ptrace: participate in group stop from ptrace_stop() iff the task is trapping for group stop
In-Reply-To: Tejun Heo's message of  Friday, 28 January 2011 16:08:42 +0100 <1296227324-25295-9-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-9-git-send-email-tj@kernel.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20110128213009.340C7183C1E@magilla.sf.frob.com>
Date: Fri, 28 Jan 2011 13:30:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A visible behavior change is increased likelihood of delayed group
> stop completion if the thread group contains one or more ptraced
> tasks.

I object to that difference in behavior.  As I've said before, I don't
think there should be any option to circumvent a group stop via ptrace.
If you think otherwise, you have a hard road to convince me of it.  

It was always the intent that traced tasks should participate in the
group stop bookkeeping.  I suspect the better line of fixes will be just
to tie up the loose ends of the ptrace interactions so that all ptrace
stops do the correct group_stop_count bookkeeping and notifications.  If
there is a group stop in progress but not yet complete, then PTRACE_CONT
on a thread in the group should probably just move it from TASK_TRACED
to TASK_STOPPED without resuming it at all.  

Once a group stop is complete, then probably the ideal is that
PTRACE_CONT would not resume a thread until a real SIGCONT cleared the
job control stop condition.  But it's likely that existing ptrace users
have expectations contrary to that, so we'll have to see.


Thanks,
Roland
