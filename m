Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0KIREh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:04:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab0KIREe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:04:34 -0500
Date: Tue, 9 Nov 2010 17:58:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && event->owner
Message-ID: <20101109165805.GA6971@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145754.GB3434@redhat.com> <20101108201108.GA6777@nowhere> <20101109155714.GA1903@redhat.com> <1289321804.2191.57.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289321804.2191.57.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Peter Zijlstra wrote:
>
> On Tue, 2010-11-09 at 16:57 +0100, Oleg Nesterov wrote:
> >
> > If the creator of perf_event dies, nobody can use its ->perf_event_list
> > anyway. What is the point to keep the reference to the dead task_struct
> > and preserve this ->perf_event_list?
>
> But when the owner dies it will close all its fds, which means it will
> clear its tsk->perf_event_list, no? (With exception of the case where
> the fd was passed through a unix-socket to another process).

fork(), pthread_create(). Only __fput() calls ->release, when the last
reference to file goes away.

And ptrace(), it doesn't use sys_perf_event_open() to create the event.

Oleg.

