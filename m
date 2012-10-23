Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2JWBov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 21:44:51 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56417 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab2JWBot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 21:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <20121020225738.GB11442@htj.dyndns.org>
References: <1350750607-2051-1-git-send-email-js1304@gmail.com>
	<1350750607-2051-4-git-send-email-js1304@gmail.com>
	<20121020225738.GB11442@htj.dyndns.org>
Date: Tue, 23 Oct 2012 10:44:49 +0900
Message-ID: <CAAmzW4OsXsDuMew7OvKOxktSxXe7C4_DuPQfvDLUCp7D0DSDoQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] workqueue: remove unused argument of wq_worker_waking_up()
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/21 Tejun Heo <tj@kernel.org>:
> On Sun, Oct 21, 2012 at 01:30:07AM +0900, Joonsoo Kim wrote:
>> Commit 63d95a91 ('workqueue: use @pool instead of @gcwq or @cpu where
>> applicable') changes an approach to access nr_running.
>> Thus, wq_worker_waking_up() doesn't use @cpu anymore.
>> Remove it and remove comment related to it.
>>
>> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>
> I'm not sure whether I wanna remove or add WARN_ON_ONCE() on it.  That
> part has gone through some changes and seen some bugs.  Can we please
> do the following instead at least for now?
>
>         if (!(worker->flags & WORKER_NOT_RUNNING)) {
>                 WARN_ON_ONCE(worker->pool->gcwq->cpu != cpu);
>                 atomic_inc(get_pool_nr_running(worker->pool));
>         }
>

I have no objection to do this for now.
Thanks.
