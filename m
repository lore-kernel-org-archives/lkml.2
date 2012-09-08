Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2IHSeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 14:34:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59296 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2IHSeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 14:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120908181107.GJ10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
	<1347124383-18723-5-git-send-email-laijs@cn.fujitsu.com>
	<20120908174044.GD10788@dhcp-172-17-108-109.mtv.corp.google.com>
	<CACvQF53dj+fVdYf6uSPREGbtLTBvLcaqX1CJN6XVQOCPx3ttsA@mail.gmail.com>
	<20120908175354.GH10788@dhcp-172-17-108-109.mtv.corp.google.com>
	<CACvQF51edrK2LhPbEk6890uxANnLQGp8E2LsTi+dZGgn24y_zw@mail.gmail.com>
	<20120908181107.GJ10788@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Sun, 9 Sep 2012 02:34:02 +0800
Message-ID: <CACvQF51PY95Eg+DLhZ4ZRRNK0x9q+pOzrPfZbhTnPvk35j8PNg@mail.gmail.com>
Subject: Re: [PATCH 4/7 V6] workqueue: fix idle worker depletion
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 2:11 AM, Tejun Heo <tj@kernel.org> wrote:
> On Sun, Sep 09, 2012 at 02:07:50AM +0800, Lai Jiangshan wrote:
>> when we release gcwq->lock and then grab it, we leave a hole that things
>> can be changed.
>>
>> I don't want to open a hole. if the hole has bug we have to fix it.
>> if the hole has no bug, we have to add lot of comments to explain it.
>>
>> When I write this reply. I am thinking: is the hole  has bug if
>> I release gcwq->lock here? result: no. But I don't want to add all things
>> what I have thought as comments to explain there is no bug even when we
>> open a hole. don't leave reviewers too much burden.
>
> We're already releasing gcwq->lock in maybe_create_worker().  That's
> the reason why @ret is set to true.  In addition, we already released
> the lock to grab manager_mutex.  So, you're not adding any burden.
> Please reuse the busy rebinding mechanism.
>

in 3.6 busy_worker_rebind() handle WORKER_REBIND bit,
not WORKER_UNBOUND bit.

busy_worker_rebind() takes struct work_struct *work argument, we have to
add new patch to add a helper and restruct it at first.

worker_maybe_bind_and_lock() 's mean is very clear here. busy_worker_rebind()
seems for busy workers, manager is not busy workers.

>
> --
> tejun
