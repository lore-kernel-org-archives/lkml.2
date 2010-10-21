Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0JUIy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:54:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48948 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0JUIy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VhbLp1o/hsx6whgV2FDae+HgCSFEVi2owIlbqHIMQ8GSTk/a35tAiERVM/obidCGXF
         T9Qy4SOpLf2OyEJE56FyKuAC1CEv1i1uZfqHUee1277m/nSvd3SUD9ZAQ1fNKS3meGrQ
         LjoRdseCWhEMvzUo70M3d4MYlwRVEFITvrIxk=
MIME-Version: 1.0
In-Reply-To: <1287650668.2237.12.camel@myhost>
References: <1287647732.2237.7.camel@myhost>
	<AANLkTim7g+8_rQSyewC6n_5WmC04kU-rj1g9k61=O2Vm@mail.gmail.com>
	<1287649283.2237.8.camel@myhost>
	<AANLkTikzSZNtTGfOcP-87u+pMZyW8WrdxwV52ZV3f=nX@mail.gmail.com>
	<1287650668.2237.12.camel@myhost>
Date: Thu, 21 Oct 2010 16:54:25 +0800
Message-ID: <AANLkTi=D_a_BH-HW9mqwLim+DjxARWzT8mxP_dah5iLY@mail.gmail.com>
Subject: Re: Ftrace: can trace kthread?
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 4:44 PM, Figo.zhang
<zhangtianfei@leadcoretech.com> wrote:
>
>> > i try by set_ftrace_pid, it also can't ftrace the kswapd.
>>
>> Are you sure kswapd got chance to run on your system?
>>
>> BTW, I can successfully trace bdi_writeback_thread,
>> # tracer: function
>> #
>> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>> #              | |       |          |         |
>>        flush-8:0-374   [000] 600743.828496: finish_task_switch <-schedule
>>        flush-8:0-374   [000] 600743.828498: perf_event_task_sched_in
>> <-finish_task_switch
>>        flush-8:0-374   [000] 600743.828498: del_timer_sync <-schedule_timeout
>>        flush-8:0-374   [000] 600743.828499: try_to_del_timer_sync
>> <-del_timer_sync
>>        flush-8:0-374   [000] 600743.828499: lock_timer_base
>> <-try_to_del_timer_sync
>>        flush-8:0-374   [000] 600743.828499: _spin_lock_irqsave <-lock_timer_base
>>        flush-8:0-374   [000] 600743.828500: _spin_unlock_irqrestore
>> <-try_to_del_timer_sync
>>        flush-8:0-374   [000] 600743.828500: kthread_should_stop
>> <-bdi_writeback_task
>
> are you use my scprit to trace the bdi_writeback_thread ?

No.

I just
echo  0 > tracing_enabled
echo function > current_tracer
echo 374(pid of flush) > set_ftrace_pid
echo 1 > tracing_enabled
wait some time
echo 0 > tracing_enabled
cat trace

So I think this answer your question "could kthread be traced?"

Thanks,
Yong
