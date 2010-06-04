Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0FDCYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:24:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54916 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab0FDCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:24:14 -0400
Message-ID: <4C0863BD.6000307@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 10:23:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Theodore Tso <tedtso@gmail.com>
Subject: Re: [PATCH] tracing: reduce latency and remove percpu trace_seq
References: <4C078350.7090106@cn.fujitsu.com> <1275572170.15884.30.camel@gandalf.stny.rr.com>
In-Reply-To: <1275572170.15884.30.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:

> 
> The "print" in the trace_seq_printf() is the TP_printk() field of the
> TRACE_EVENT. I believe that there were some events (ext4?) that did
> things that required preemption disabled.
> 

It seems that ext4 has no such events.
I find jbd2_dev_to_name() in the TP_printk() field of ext4's tracepoints.
And it seems that jbd2_dev_to_name() requires preemption enabled and sleepable.

Maybe there were some events did things that required preemption disabled.
But No document ensure TP_printk() preemption disabled, such events should
be fixed, I think.
