Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2BARHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:07:22 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57048 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2BARHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:07:20 -0500
MIME-Version: 1.0
In-Reply-To: <1328104527.2662.4.camel@laptop>
References: <1327854877.8504.3.camel@localhost.localdomain>
	<20120131084830.GA22077@linux.vnet.ibm.com>
	<1328104527.2662.4.camel@laptop>
Date: Wed, 1 Feb 2012 23:07:20 +0600
Message-ID: <CADZ9YHjQXdeFkCbn9A81+Eo+udZoG8vF_1=N7hM4iZo_3uD3nA@mail.gmail.com>
Subject: Re: [PATCH] sched: At sched_fork use __set_task_cpu().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 7:55 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-01-31 at 14:18 +0530, Kamalesh Babulal wrote:
>> * Rakib Mullick <rakib.mullick@gmail.com> [2012-01-29 22:34:37]:
>>
>> >  We don't use select_task_rq() from sched_fork() anymore and no chance of task gets migrated at
>> > this point. Therefore, we can avoid task migration related checking/accounting, so use
>> > __set_task_cpu() instead of set_task_cpu().
>> >
>> > Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>>   Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>
> Since we call sched_fork() with preemption enabled _long_ after the
> child is copied from the parent who is to say we (parent) didn't migrate
> away and are now setting a different cpu?
>
If parent gets migrated that should be accounted as parents migration
count not for child offcourse. And if we're counting child's
nr_migration count for parent's getting migrated, we're simply
screwing childs migration count. Isn't it?

> One could argue that that might not be a real migration from the child's
> POV, maybe, but nobody seems to be making that argument.
>
But I'm not seeing it from child's or parent's POV. I'm simply
addressing the point of a task's migration counter
(p->se.nr_migrations), simply this task wasn't moved.

> I really don't see the point of this..
>
I'm hoping, you'll rethink...

Thanks,
Rakib
