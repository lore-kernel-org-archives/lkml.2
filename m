Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1ASS3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:29:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab1ASS3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:29:44 -0500
Date: Wed, 19 Jan 2011 19:21:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Was: Q: sys_perf_event_open() && PF_EXITING
Message-ID: <20110119182141.GA12183@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145725.GA3434@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108145725.GA3434@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Oleg Nesterov wrote:
>
> I am puzzled by PF_EXITING check in find_lively_task_by_vpid().
>
> How can it help? The task can call do_exit() right after the check.
>
> And why do we need it? The comment only says "Can't attach events to
> a dying task". Maybe it tries protect sys_perf_event_open() against
> perf_event_exit_task_context(), but it can't.

Yes.

Please see 1/2. Well, I can't say I really like the idea to reuse
task->perf_event_mutex, but I do not see a better fix.

Also, I have no idea how can I actually test the changes in the code
I can hardly understand, please review.

Also. I believe there are more problems in perf_install_event(), but
I need to recheck.

> Hmm. jump_label_inc/dec looks obviously racy too. Say, free_event() races
> with perf_event_alloc(). There is a window between atomic_xxx() and
> jump_label_update(), afaics it is possible to call jump_label_disable()
> when perf_task_events/perf_swevent_enabled != 0.

Another issue...

Oleg.

