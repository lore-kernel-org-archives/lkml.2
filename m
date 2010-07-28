Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab0G1KNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:13:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56084 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab0G1KM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:12:58 -0400
Message-ID: <4C5003CA.50501@cn.fujitsu.com>
Date: Wed, 28 Jul 2010 18:17:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jack Daniel <wanders.thirst@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: No definition of trace_sched_stat_wait in kernel found!
References: <AANLkTin1qWT=NykGs6_YMopxdWoLzOKa1Zg_Q9EbtY0b@mail.gmail.com>
In-Reply-To: <AANLkTin1qWT=NykGs6_YMopxdWoLzOKa1Zg_Q9EbtY0b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Daniel wrote:
> Greetings,
> 
> With reference to the function update_stats_wait_end(), there seems to
> be a call to trace_sched_stat_wait(). But strangely I can find no
> definition of this function even though the kernel compiles without
> any errors. There is no reference to this function
> trace_sched_stat_wait() in the System.map file either, which means
> this is not getting compiled? Could someone please make sense of this
> absurdity.
> 

It's generated in include/trace/events/sched.h:

DEFINE_EVENT(sched_stat_template, sched_stat_wait,
             TP_PROTO(struct task_struct *tsk, u64 delay),
             TP_ARGS(tsk, delay));


And the trace_xxx() function is defined by macros in include/linux/tracepoint.h:

#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)       \
        extern struct tracepoint __tracepoint_##name;                   \
        static inline void trace_##name(proto)                          \
        {                                                               \
                if (unlikely(__tracepoint_##name.state))                \
                        __DO_TRACE(&__tracepoint_##name,                \
                                TP_PROTO(data_proto),                   \
                                TP_ARGS(data_args));                    \
        }
	...
