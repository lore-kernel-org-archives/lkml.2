Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab2IUT0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:26:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48677 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab2IUT0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:26:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120921183515.GI7264@google.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
	<20120921174952.GF7264@google.com>
	<CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
	<20120921183515.GI7264@google.com>
Date: Fri, 21 Sep 2012 20:26:01 +0100
Message-ID: <CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
Subject: Re: Work queue questions
From: Deepawali Verma <dverma249@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

I have put the ftrace markers in my code:

     kworker/u:1-21    [000]   110.964895: task_event: MYTASKJOB2381 XStarted
     kworker/u:1-21    [000]   110.964909: task_event: MYTASKJOB2381 Xstopped
     kworker/u:1-21    [000]   110.965137: task_event: MYTASKJOB2382 XStarted
     kworker/u:1-21    [000]   110.965154: task_event: MYTASKJOB2382 Xstopped
     kworker/u:5-3724  [000]   110.965311: task_event: MYTASKJOB2383 XStarted
     kworker/u:5-3724  [000]   110.965325: task_event: MYTASKJOB2383 Xstopped

I have this one big task to whom I divided into small sub tasks. These
are numbered 2381, 2382 and 2383, what was I expecting that task 2381,
2382, 2383 run in parallel. I have put start and stop markers here so
that I can see how this concurrency managed work queue is distributing
the load.

I found that task no 2381 is started first and exited before starting
task 2382 and so on. What I expected that it should start the three
sub tasks in parallel, not one by one.

Where is concurrency here?

Regards,
Deepa



On Fri, Sep 21, 2012 at 7:35 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Sep 21, 2012 at 07:30:21PM +0100, Deepawali Verma wrote:
>> Actually I want to make parallelization of one task into three tasks.
>> Therefore I created three single threaded work queues means divide the
>> task into three tasks. You are right that I can use one work queue as
>> well. But when I am doing three times schedule on different work
>> queues, I am seeing only one worker thread is processing the three
>> times schedule though I created three different workqueues and I
>> believe from previous kernel versions that there is one worker thread
>> associated with one queue. If one thread does this task then there is
>> no difference between doing the same task in one thread and using
>> three threads.
>>
>> If we create different work queues, why always one worker thread is
>> processing the all tasks instead I want another two threads also work
>> in parallel?
>
> Well, that was the whole point of concurrency managed workqueue.  You
> don't need to worry about the number of workers.  Concurrency is
> automatically managed.  If you queue three work items on, say,
> system_wq and none of them sleeps, a single worker will execute them
> back to back.  If a work item sleeps, another worker will kick in.
> So, in most cases, there's no need to worry about concurrency - just
> use system_wq.
>
> Thanks.
>
> --
> tejun
