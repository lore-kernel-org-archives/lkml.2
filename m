Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab0KWPPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:15:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab0KWPPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:15:06 -0500
Date: Tue, 23 Nov 2010 16:08:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:sched/core] cpu: Remove incorrect BUG_ON
Message-ID: <20101123150813.GA535@redhat.com>
References: <tip-51a96c77815e7f139892a6e9c8275a50e9baebdf@git.kernel.org> <20101123143910.GA31502@redhat.com> <1290524704.2072.412.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290524704.2072.412.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Peter Zijlstra wrote:
>
> Ah,. uhm,. you mean, not do anything at all?
>
> Dunno, really, let me try and read the code there.

Thanks. This is very minor of course, but it would be nice to
undestand the reason. To me it looks unneeded, but I don't trust
myself.  (snippets from my previous email below).



With or without this change, even if we know that rq->idle is running
we can't know if it (say) already started play_dead_common() or not.

We are going to call __cpu_die(), afaics it should do the necessary
synchronization in any case.

For example, native_cpu_die() waits for cpu_state == CPU_DEAD in a
loop. Of course it should work in practice (it also does msleep),
but in theory there is no guarantee.

So. Can't we just remove this wait-loop? We know that rq->idle
will be scheduled "soon", I don't understand why it is necessary
to ensure that context_switch() has already happened.

Oleg.

