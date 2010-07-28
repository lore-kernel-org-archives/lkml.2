Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0G1KXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:23:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47350 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab0G1KXf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vGLJnIY2b5u4Vu+uycY+GCxD6N9qnmTCsJ4m4WYB2BiqsHkRUOLtZx43C9iz4EekBF
         xCJFXN3RJdsWWfSQ13zPMUtpbqzFeU2qNFW/iPuQZCOuJsBC+LArr9lgoaHMG122XJ6R
         4XF81E3e4NKtoI2Zuw56dcUNee6cJzFMDu24g=
MIME-Version: 1.0
In-Reply-To: <4C5003CA.50501@cn.fujitsu.com>
References: <AANLkTin1qWT=NykGs6_YMopxdWoLzOKa1Zg_Q9EbtY0b@mail.gmail.com>
	<4C5003CA.50501@cn.fujitsu.com>
Date: Wed, 28 Jul 2010 15:53:33 +0530
Message-ID: <AANLkTin0U=SCL+qkNJVRJtREa9dzGSuY=9hWJ78GjN2c@mail.gmail.com>
Subject: Re: No definition of trace_sched_stat_wait in kernel found!
From: Jack Daniel <wanders.thirst@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 3:47 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Jack Daniel wrote:
>> Greetings,
>>
>> With reference to the function update_stats_wait_end(), there seems to
>> be a call to trace_sched_stat_wait(). But strangely I can find no
>> definition of this function even though the kernel compiles without
>> any errors. There is no reference to this function
>> trace_sched_stat_wait() in the System.map file either, which means
>> this is not getting compiled? Could someone please make sense of this
>> absurdity.
>>
>
> It's generated in include/trace/events/sched.h:
>
> DEFINE_EVENT(sched_stat_template, sched_stat_wait,
>             TP_PROTO(struct task_struct *tsk, u64 delay),
>             TP_ARGS(tsk, delay));
>
>
> And the trace_xxx() function is defined by macros in include/linux/tracepoint.h:
>
> #define __DECLARE_TRACE(name, proto, args, data_proto, data_args)       \
>        extern struct tracepoint __tracepoint_##name;                   \
>        static inline void trace_##name(proto)                          \
>        {                                                               \
>                if (unlikely(__tracepoint_##name.state))                \
>                        __DO_TRACE(&__tracepoint_##name,                \
>                                TP_PROTO(data_proto),                   \
>                                TP_ARGS(data_args));                    \
>        }
>        ...
>

AH! thanks a lot for pointing this out.

Regards,
Jack
