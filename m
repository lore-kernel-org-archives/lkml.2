Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2HPPcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:32:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47869 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2HPPcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <1345128138.29668.42.camel@twins>
References: <1345124749.31092.2.camel@localhost.localdomain>
	<1345125384.29668.30.camel@twins>
	<CADZ9YHjPjExzuJWjziiezBch03Am0imQzDG4EDfG-NTWfz4V8A@mail.gmail.com>
	<1345128138.29668.42.camel@twins>
Date: Thu, 16 Aug 2012 21:32:45 +0600
Message-ID: <CADZ9YHjzNVz6nSqbnTgVYfwi2hz0KYuXC89GHw6UjL2GyGZ64A@mail.gmail.com>
Subject: Re: Add rq->nr_uninterruptible count to dest cpu's rq while CPU goes down.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/12, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-08-16 at 20:28 +0600, Rakib Mullick wrote:
>
>> nr_uninterruptible is coupled with tasks on the runqueue to calculate
>> nr_active numbers.
>
> It is not.. nr_uninterruptible is incremented on the cpu the task goes
> to sleep and decremented on the cpu doing the wakeup.
>
If nr_uninterruptible's life cycle is this simple then,  while CPU
goes down, nr_uninterruptible count will be decremented when all the
tasks are moved to other CPUs and should be fine.

> This means that nr_uninterruptible is a complete mess and any per-cpu
> value isn't meaningful at all.
>
Well, if nr_uninterruptible is a mess, then this patch has no meaning.
And also I think migrate_nr_uninterruptible() is meaning less too.

> It is quite possible to always have the inc on cpu0 and the decrement on
> cpu1, yielding results like:
>
> {1000, -1000} for an effective nr_uninterruptible = 0. Taking either cpu
> down will then migrate whatever delta it has to another cpu, but there
> might only be a single task, yet the delta is +-1000.
>
>> In calc_load_fold_active(), this nr_active numbers are used to
>> calculate delta. This is how I understand this part and seeing some
>> impact.
>
> You understand wrong, please re-read the comment added in commit
> 5167e8d5.
>
Yes, reading.

Thanks,
Rakib.
