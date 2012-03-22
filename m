Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030573Ab2CVJxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 05:53:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:37695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab2CVJxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 05:53:32 -0400
Message-ID: <1332409996.18960.511.camel@twins>
Subject: Re: [PATCH] perf: Fix RCU dereference check in perf_event_comm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ari Savolainen <ari.m.savolainen@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Mar 2012 10:53:16 +0100
In-Reply-To: <CAEbykaXUy7HEyW7mBaTNmB94NwyjuJBbA1R-H49Jjk5M-iL_fw@mail.gmail.com>
References: <CAEbykaXUy7HEyW7mBaTNmB94NwyjuJBbA1R-H49Jjk5M-iL_fw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 01:43 +0200, Ari Savolainen wrote:
> The warning below is printed when executing a command like
> sudo perf record su - user -c "echo hello"
> 
> It's fixed by moving the call of perf_event_comm to be protected
> by the task lock.

That seems like a rather poor solution since it increases the lock hold
time for no explained reason.

> include/linux/cgroup.h:567 suspicious rcu_dereference_check() usage!

>  [<ffffffff8109be55>] lockdep_rcu_suspicious+0xe5/0x100
>  [<ffffffff811131fa>] perf_event_comm+0x37a/0x4d0

So where exactly is this, perf_event_comm_event() takes rcu_read_lock()
so I presume its before that.
