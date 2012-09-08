Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab2IHSHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 14:07:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55619 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2IHSHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 14:07:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120908175354.GH10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
	<1347124383-18723-5-git-send-email-laijs@cn.fujitsu.com>
	<20120908174044.GD10788@dhcp-172-17-108-109.mtv.corp.google.com>
	<CACvQF53dj+fVdYf6uSPREGbtLTBvLcaqX1CJN6XVQOCPx3ttsA@mail.gmail.com>
	<20120908175354.GH10788@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Sun, 9 Sep 2012 02:07:50 +0800
Message-ID: <CACvQF51edrK2LhPbEk6890uxANnLQGp8E2LsTi+dZGgn24y_zw@mail.gmail.com>
Subject: Re: [PATCH 4/7 V6] workqueue: fix idle worker depletion
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 1:53 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Sun, Sep 09, 2012 at 01:50:41AM +0800, Lai Jiangshan wrote:
>> >> +             if (worker_maybe_bind_and_lock(manager))
>> >> +                     worker_clr_flags(manager, WORKER_UNBOUND);
>> >> +     }
>> >> +}
>> >
>> > We can reuse busy_worker_rebind_fn(), right?
>>
>> busy_worker_rebind_fn() releases the gcwq->lock. we can't release
>> the lock here.
>
> Why so?  Can you please elaborate?
>

when we release gcwq->lock and then grab it, we leave a hole that things
can be changed.

I don't want to open a hole. if the hole has bug we have to fix it.
if the hole has no bug, we have to add lot of comments to explain it.

When I write this reply. I am thinking: is the hole  has bug if
I release gcwq->lock here? result: no. But I don't want to add all things
what I have thought as comments to explain there is no bug even when we
open a hole. don't leave reviewers too much burden.

Thanks.
Lai.

>
> --
> tejun
