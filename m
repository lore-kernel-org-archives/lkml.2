Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab2HPO3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:29:01 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38691 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2HPO27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:28:59 -0400
MIME-Version: 1.0
In-Reply-To: <1345125384.29668.30.camel@twins>
References: <1345124749.31092.2.camel@localhost.localdomain>
	<1345125384.29668.30.camel@twins>
Date: Thu, 16 Aug 2012 20:28:58 +0600
Message-ID: <CADZ9YHjPjExzuJWjziiezBch03Am0imQzDG4EDfG-NTWfz4V8A@mail.gmail.com>
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
> On Thu, 2012-08-16 at 19:45 +0600, Rakib Mullick wrote:
>> When a CPU is about to go down, it moves all it's sleeping task to an
>> active CPU, then nr_uninterruptible counts are
>> also moved. When moving nr_uninterruptible count, currently it chooses a
>> randomly picked CPU from the active CPU mask
>> to keep the global nr_uninterruptible count intact. But, it would be
>> precise to move nr_uninterruptible counts to the
>> CPU where all the sleeping tasks were moved and it also might have subtle
>> impact over rq's load calculation. So, this
>> patch is prepared to address this issue.
>
> The Changelog is ill-formated. Other than that, the patch doesn't appear
> to actually do what it says. The sleeping tasks can be scattered to any
> number of cpus as decided by select_fallback_rq().
>
I'm not sure which parts are missing from Changelog to patch. And this
patch assumes that, sleeping tasks won't be scattered. From
select_fallback_rq(), sleeping tasks might get scattered due to
various cases like. if CPU is down, task isn't allowed to move a
particular CPU. Other than that, dest cpu supposed to be the same.

> Furthermore there should be absolutely no impact on load calculation
> what so ever. nr_uninterruptible is only ever useful as a sum over all
> cpus, this total sum doesn't change regardless of where you put the
> value.
>
> Worse, there's absolutely no relation to the tasks on the runqueue
> (sleeping or otherwise) and nr_uninterruptible, so coupling these
> actions makes no sense what so ever.
>
nr_uninterruptible is coupled with tasks on the runqueue to calculate
nr_active numbers.
In calc_load_fold_active(), this nr_active numbers are used to
calculate delta. This is how I understand this part and seeing some
impact.

Thanks,
Rakib
