Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0C2JLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:11:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:49156 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0C2JLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:11:34 -0400
Subject: Re: [PATCH 2/2] perf: Use hot regs with software sched
 switch/migrate events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>
In-Reply-To: <1269753066-17246-3-git-send-regression-fweisbec@gmail.com>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
	 <1269753066-17246-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 10:49:59 +0200
Message-ID: <1269852599.12097.159.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-28 at 07:11 +0200, Frederic Weisbecker wrote:
> Scheduler's task migration events don't work because they always
> pass NULL regs perf_sw_event(). The event hence gets filtered
> in perf_swevent_add().
> 
> Scheduler's context switches events use task_pt_regs() to get
> the context when the event occured which is a wrong thing to
> do as this won't give us the place in the kernel where we went
> to sleep but the place where we left userspace. The result is
> even more wrong if we switch from a kernel thread.
> 
> Use the hot regs snapshot for both events as they belong to the
> non-interrupt/exception based events family. Unlike page faults
> or so that provide the regs matching the exact origin of the event,
> we need to save the current context.
> 
> This makes the task migration event working and fix the context
> switch callchains and origin ip.


But after this its no longer possible to profile userspace on context
switches is it?

