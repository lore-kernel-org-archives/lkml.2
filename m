Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768304Ab2KOPd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:33:57 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36088 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767939Ab2KOPdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:33:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hzzhd5__VwR7N+VKpq1C27xHGgi4vj87drbcLghJ+Od5g@mail.gmail.com>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
	<1352925457-15700-8-git-send-email-fweisbec@gmail.com>
	<1352953617.18025.94.camel@gandalf.local.home>
	<CAFTL4hzzhd5__VwR7N+VKpq1C27xHGgi4vj87drbcLghJ+Od5g@mail.gmail.com>
Date: Thu, 15 Nov 2012 16:33:44 +0100
Message-ID: <CAFTL4hzox08W_Uz6BP=7vM4Vq1ezHW0kMYG5br8fYAZ6E08Vig@mail.gmail.com>
Subject: Re: [PATCH 7/7] printk: Wake up klogd using irq_work
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/15 Frederic Weisbecker <fweisbec@gmail.com>:
> ----->
> CPU that offilines                                          CPU offlining
> -----------------
> ---------------------
> cpu_down() {
>     __stop_machine(take_cpu_down)
>
> take_cpu_down() {
>
> __cpu_disable() {
>
>     * disable irqs in hw
>
>     * clear from online mask
>                                                                        }
>
> move all tasks somewhere
>                                                                    }
> while (!idle_cpu(offlining))
>     cpu_relax()
>
> cpu_die();
> <---------

Oh thanks gmail for the mess. Sometimes it mangles contents, sometimes
not. Probably depend if the moon is odd or even.

Here is a pastebin: http://pastebin.com/aACvyu6p
