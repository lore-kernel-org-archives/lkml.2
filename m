Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1ASGJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:09:30 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34022 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1ASGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:09:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YBpiJGej5vKARNMpFECkVreGO0fAL6DQ2NXfrxkuSCM3FGAE0J/zWx/fuGsPni+0Pr
         JeSo6Oc69WWcNKDvdKT/qj0AY8y/CSQa5C61eRxXNykvx4WRwb8uM8Iav6QH8AY63sdG
         MJ7IYyQVpo6Bhenm7P/jG7OUNSip5Ti0d6R9o=
MIME-Version: 1.0
In-Reply-To: <1295415657.8017.113.camel@marge.simson.net>
References: <1295275365.12840.13.camel@kolo>
	<1295280032.30950.128.camel@laptop>
	<1295339012.11678.35.camel@kolo>
	<AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	<1295357746.30950.681.camel@laptop>
	<AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	<1295408637.8017.56.camel@marge.simson.net>
	<AANLkTineieNdiKduDHQ-J+Xv6Pq9O0pTZraBJEw=p5e7@mail.gmail.com>
	<1295415657.8017.113.camel@marge.simson.net>
Date: Wed, 19 Jan 2011 14:09:28 +0800
Message-ID: <AANLkTinfGL3=8LKTx3gCg_V9DfXi44E2PxPd-vQVfALU@mail.gmail.com>
Subject: Re: Bug in scheduler when using rt_mutex
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 1:40 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Wed, 2011-01-19 at 12:35 +0800, Yong Zhang wrote:
>
>> cfs_rq->curr != se is always true.
>
> If that were always true, we'd illegally enqueue a running task.

I'm sorry that I'm not express myself correctly.

The conclusion of (cfs_rq->curr != se is always true) is not
self-contained. IOW, it's based on one condition which is
(task_of(se) != rq->curr). So what I want to say is:
task_of(se) != rq->curr    ==>   cfs_rq_of(se)->curr != se
So,
         !running                   ==>   cfs_rq_of(se)->curr != se

Is this more clear?

Thanks,
Yong

-- 
Only stand for myself
