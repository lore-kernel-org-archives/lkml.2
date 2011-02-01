Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1BATo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:44:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab1BATo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:44:56 -0500
Date: Tue, 1 Feb 2011 20:36:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 08/10] ptrace: participate in group stop from
	ptrace_stop() iff the task is trapping for group stop
Message-ID: <20110201193636.GA9785@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <1296227324-25295-9-git-send-email-tj@kernel.org> <20110128213009.340C7183C1E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128213009.340C7183C1E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Roland McGrath wrote:
>
> If
> there is a group stop in progress but not yet complete, then PTRACE_CONT
> on a thread in the group should probably just move it from TASK_TRACED
> to TASK_STOPPED without resuming it at all.
>
> Once a group stop is complete, then probably the ideal is that
> PTRACE_CONT would not resume a thread until a real SIGCONT cleared the
> job control stop condition.

Well. I agree. I even tried to mention this before.

Or, if PTRACE_CONT resumes the tracee it should clear SIGNAL_STOP_STOPPED.

> But it's likely that existing ptrace users
> have expectations contrary to that,

Sure ;)




Btw. I just realized that I didn't reply explicitly to this series.
Because I thought we already discussed everything and I have nothing
to add. I think that everything is technically correct. I mean, I
believe the patches do exactly what the changelog says.

Oleg.

