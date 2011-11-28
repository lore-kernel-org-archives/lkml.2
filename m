Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1K1Pnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:43:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63099 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1K1Pni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:43:38 -0500
MIME-Version: 1.0
In-Reply-To: <20111128150054.GM1775@moon>
References: <20111128120813.GK1775@moon>
	<CANaxB-wrRd94OJifpYJ=kibx_48oJ=GE51f9GWjZ3np2nCQYsA@mail.gmail.com>
	<20111128133828.GL1775@moon>
	<20111128140356.GA27395@dhcp-10-30-18-117.sw.ru>
	<20111128150054.GM1775@moon>
Date: Mon, 28 Nov 2011 18:43:37 +0300
Message-ID: <CANaxB-ykQpeaAhb7zgV1fcME8fGs0To05uU8Aa+M79e7yk46TQ@mail.gmail.com>
Subject: Re: [RFC] cgroups: freezer -- Allow to attach a task to a frozen cgroup
From: Andrew Wagin <avagin@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> > >
>> > > It's strange. A rollback can't fail. We have three situations:
>> > >
>> > > frozen -> frozen
>> > > thawed -> frozen
>> > > frozen -> thawed
>> > >
>> > > In first and second cases cancel_request can't fail.
>> > > In the third we have a problem, which may be solved if we will call
>> > > thaw_process(task) from attach_task(), we can do that, because
>> > > thaw_process() can't fail. It solves a problem, because
>> > > freezer_cancel_attach will be executed for the first and second cases
>> > > only.
>> > >
>> > > If my suggestion is correct, we can replace pr_warning on BUG_ON
>> > >
>> >
>> > Yes, the case which can fail is
>> >
>> >    frozen->(can_attach_task)->thawed
>> >      (cgroup_task_migrate failure)
>> >    thawed->(cancel_attach)->frozen
>> >
>> > and we should never fail here since otherwise we would not have
>> > a "frozen" state before. But I think placing BUG_ON is too severe
>> > here, maybe WARN_ON_ONCE(1) would fit better?
>>
>> It's true, if a task is not being executed between thaw_process() and
>> freeze_task().
>
> Hmm... But what the problem it might be if a task get executed between
> those stages even for some time?

It may become unfreezable...

>
