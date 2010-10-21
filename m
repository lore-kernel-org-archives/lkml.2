Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0JUIjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:39:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52148 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0JUIjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=agD74CQ4ATJyz5vNpC2ln2Zy/c+HTMnjDYbazzvXX6V4bp9cjYhqi54D7o7uJJk54U
         SMK6utycCC8zFlV8qaghbt68yOaI7QaSuVmEI8ErVTC1nMhipuxcfqh5bwAleTMQS1mJ
         mwGLcISVOSBvQ5d3W3nLR2o82hEZAycYyAbqE=
MIME-Version: 1.0
In-Reply-To: <1287649283.2237.8.camel@myhost>
References: <1287647732.2237.7.camel@myhost>
	<AANLkTim7g+8_rQSyewC6n_5WmC04kU-rj1g9k61=O2Vm@mail.gmail.com>
	<1287649283.2237.8.camel@myhost>
Date: Thu, 21 Oct 2010 16:39:12 +0800
Message-ID: <AANLkTikzSZNtTGfOcP-87u+pMZyW8WrdxwV52ZV3f=nX@mail.gmail.com>
Subject: Re: Ftrace: can trace kthread?
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 4:21 PM, Figo.zhang
<zhangtianfei@leadcoretech.com> wrote:
> On Thu, 2010-10-21 at 16:10 +0800, Yong Zhang wrote:
>> On Thu, Oct 21, 2010 at 3:55 PM, Figo.zhang
>> <zhangtianfei@leadcoretech.com> wrote:
>> > hi,
>> >
>> > is it ftrace in 2.6.36-rc8 can trace the kthread?
>>
>> How about the set_ftrace_pid interface?
>>
>
> i try by set_ftrace_pid, it also can't ftrace the kswapd.

Are you sure kswapd got chance to run on your system?

BTW, I can successfully trace bdi_writeback_thread,
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
       flush-8:0-374   [000] 600743.828496: finish_task_switch <-schedule
       flush-8:0-374   [000] 600743.828498: perf_event_task_sched_in
<-finish_task_switch
       flush-8:0-374   [000] 600743.828498: del_timer_sync <-schedule_timeout
       flush-8:0-374   [000] 600743.828499: try_to_del_timer_sync
<-del_timer_sync
       flush-8:0-374   [000] 600743.828499: lock_timer_base
<-try_to_del_timer_sync
       flush-8:0-374   [000] 600743.828499: _spin_lock_irqsave <-lock_timer_base
       flush-8:0-374   [000] 600743.828500: _spin_unlock_irqrestore
<-try_to_del_timer_sync
       flush-8:0-374   [000] 600743.828500: kthread_should_stop
<-bdi_writeback_task

Thanks,
Yong
