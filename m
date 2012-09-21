Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab2IUTfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:35:16 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44092 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab2IUTfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:35:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120921192720.GJ7264@google.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
	<20120921174952.GF7264@google.com>
	<CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
	<20120921183515.GI7264@google.com>
	<CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
	<20120921192720.GJ7264@google.com>
Date: Fri, 21 Sep 2012 20:35:13 +0100
Message-ID: <CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
Subject: Re: Work queue questions
From: Deepawali Verma <dverma249@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tajun,

These three tasks are writing the three chunks of data in parallel. I
am not getting improvement here otherwise what is difference between
writing these chunks one by one in single thread instead of trying to
write the data by scheduling the work on three different workqueues
means 3 worker threads?

Regards,
Deepa

On Fri, Sep 21, 2012 at 8:27 PM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Sep 21, 2012 at 08:26:01PM +0100, Deepawali Verma wrote:
>>      kworker/u:1-21    [000]   110.964895: task_event: MYTASKJOB2381 XStarted
>>      kworker/u:1-21    [000]   110.964909: task_event: MYTASKJOB2381 Xstopped
>>      kworker/u:1-21    [000]   110.965137: task_event: MYTASKJOB2382 XStarted
>>      kworker/u:1-21    [000]   110.965154: task_event: MYTASKJOB2382 Xstopped
>>      kworker/u:5-3724  [000]   110.965311: task_event: MYTASKJOB2383 XStarted
>>      kworker/u:5-3724  [000]   110.965325: task_event: MYTASKJOB2383 Xstopped
>>
>> I have this one big task to whom I divided into small sub tasks. These
>> are numbered 2381, 2382 and 2383, what was I expecting that task 2381,
>> 2382, 2383 run in parallel. I have put start and stop markers here so
>> that I can see how this concurrency managed work queue is distributing
>> the load.
>>
>> I found that task no 2381 is started first and exited before starting
>> task 2382 and so on. What I expected that it should start the three
>> sub tasks in parallel, not one by one.
>>
>> Where is concurrency here?
>
> If none of them blocks, there isn't much point in throwing more
> threads at them.  What are those thread doing?
>
> Thanks.
>
> --
> tejun
