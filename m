Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1A0QAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:00:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1A0QAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:00:07 -0500
Date: Thu, 27 Jan 2011 16:52:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110127155202.GA25060@redhat.com>
References: <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com> <20110126184957.GA32578@redhat.com> <1296068731.15234.6.camel@laptop> <1296070383.15234.10.camel@laptop> <20110126211931.GA6778@redhat.com> <20110126213317.GA7403@redhat.com> <1296124337.15234.71.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296124337.15234.71.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Peter Zijlstra wrote:
>
> On Wed, 2011-01-26 at 22:33 +0100, Oleg Nesterov wrote:
> >
> > This is what I had in mind initially but I didn't dare to add the
> > new member into rq, it is only needed for perf.
>
> Right, but its a weakness in the task_oncpu_function_call()
> implementation, wouldn't any user run into this problem eventually?

I think that other users are fine, they do not try to change ctx.

OTOH, probably your change in task_oncpu_function_call() makes sense
anyway, this way func() can never have some other subtle problems
witht context_switch in progress.

Oleg.

