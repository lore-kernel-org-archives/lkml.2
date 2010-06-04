Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0FDG5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:57:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61309 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab0FDG5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:57:13 -0400
Message-ID: <4C08A3C0.3090106@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 14:57:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] tracing: Remove ftrace_preempt_disable/enable
References: <20100604013506.159506222@goodmis.org> <20100604013557.373837407@goodmis.org>
In-Reply-To: <20100604013557.373837407@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>


I think we may need to ensure need_resched() notrace:

-static inline int need_resched(void)
+static __always_inline int need_resched(void)

-static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
+static __always_inline int test_ti_thread_flag(struct thread_info *ti, int flag)

...

I believe compiler will always inline them, It just looks nicer when use __always_inline.

