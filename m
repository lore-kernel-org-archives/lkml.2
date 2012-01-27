Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2A0OLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:11:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35406 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2A0OLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:11:16 -0500
MIME-Version: 1.0
In-Reply-To: <1327652393.2446.126.camel@twins>
References: <1327486224.2614.45.camel@laptop>
	<tip-4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b@git.kernel.org>
	<CADZ9YHi1=aP8j8vCFJvyMANyMWwB_mjT67KwSZZh902oyWy7pA@mail.gmail.com>
	<1327652393.2446.126.camel@twins>
Date: Fri, 27 Jan 2012 20:11:15 +0600
Message-ID: <CADZ9YHiG56TCORVySHYjnhLBSsVi=OaMRmBq-_3yDTQCGnEbYw@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Fix rq->nr_uninterruptible update race
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 2:19 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2012-01-27 at 11:20 +0600, Rakib Mullick wrote:
>> On Fri, Jan 27, 2012 at 2:25 AM, tip-bot for Peter Zijlstra
>> <a.p.zijlstra@chello.nl> wrote:

>> Why would we want to avoid nr_uninterruptible accounting?
>> nr_uninterruptible has impact on load calculation, we might not get
>> the proper load weight if we don't account it. isn't it?
>
> Read again ;-)
>
Wasn't enough! I had to use paper and pen ;-)

> sched_setscheduler() did:
>
>  deactivate_task(); // remove it from the queue
>
>  // change tasks's scheduler paramater
>
>  activate_task(); // queue it in the new place
>
> it is invariant wrt nr_uninterruptible but does include the
> nr_uinterruptile accounting logic.
>
> Now Kosaki-San noticed that if the task manages to change its ->state at
> an inopportune moment (right between the dequeue and enqueue) we'll get
> screwy nr_uninterruptible accounting.

I got your point and yes, we'll get screwy nr_uninterruptible
accounting if we call {activate,deactivate}_task(). We need to avoid
nr_uninterruptible accounting.

Thanks,
Rakib
