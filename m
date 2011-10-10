Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1JJLC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:02:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60683 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab1JJLCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:02:25 -0400
Subject: Re: [PATCH 2/3][RFC] tracing: Add optional percpu buffers for
 trace_printk()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20111008171259.462646120@goodmis.org>
References: <20111008170227.792806635@goodmis.org>
	 <20111008171259.462646120@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 13:08:33 +0200
Message-ID: <1318244913.14400.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-08 at 13:02 -0400, Steven Rostedt wrote:
> 
> Ideally, using percpu buffers would be useful, but since trace_printk()
> is only used in development, having per cpu buffers for something
> never used is a waste of space. We could make this a compile option
> but trace_printk() may also be used for developing modules, on a
> distro kernels or for debugging at customer sites.
> 
> The approach taken here is to dynamically allocate percpu buffers
> with a new tracing/options switch "trace_printk_percpu". It can
> be allocated and freed at runtime, or "trace_printk_percpu" may also
> be specified on the command line and it will be allocated at boot up.
> 
> This allows a developer to create percpu buffers for trace_printk()
> on a running system, and also free them when not in used. 

Kill the old code, make tracing/events/trace_printk default to 0 and use
enabling of that to allocate your per-cpu buffers.



