Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0EaQvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:51:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57762 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab0EaQvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y8FA8CEEerFjPs9Cqmj0IbvxKilJ0he7CO9+1zyeCWZ5trZIBNt2ucWlq31noA9eRn
         wXaym6wglRytHRdnI3PE0dQmXfBA0mpPJU+e41J9jY+uFuCcBUgoECTmR5RCNvZS/rec
         aSAbkJLoskhYDLtk6X7GfOtuexvk1V52D0XWs=
Date: Mon, 31 May 2010 18:51:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: Add task activate/deactivate tracepoints
Message-ID: <20100531165135.GD5157@nowhere>
References: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com> <1275059710.27810.9624.camel@twins> <20100531080049.GA435@elte.hu> <1275293544.27810.21478.camel@twins> <1275296099.27810.21622.camel@twins> <20100531143622.GA5157@nowhere> <1275317013.27810.23019.camel@twins> <20100531144820.GB5157@nowhere> <1275322715.27810.23323.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275322715.27810.23323.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 06:18:35PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-31 at 16:48 +0200, Frederic Weisbecker wrote:
> > > Should we maybe cure this and rely on sched_switch() to detect sleeps?
> > > It seems natural since only the current task can go to sleep, its just
> > > that the whole preempt state gets a bit iffy.
> 
> How about something like the below?
> 
> Steve, is that proper usage of CREATE_TRACE_POINT?
> 
> ---
> Subject: sched, trace: Fix sched_switch() prev_state argument
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon May 31 18:13:25 CEST 2010
> 
> For CONFIG_PREEMPT=y kernels the sched_switch(.prev_state) argument
> isn't useful because we can get preempted with current->state !=
> TASK_RUNNING without actually getting removed from the runqueue.
> 
> Cure this by treating all preempted tasks as runnable from the
> tracer's point of view.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---



Other than Steve's said, the thing looks good.

