Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2HTCz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 22:55:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32844 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2HTCzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 22:55:25 -0400
X-IronPort-AV: E=Sophos;i="4.77,795,1336320000"; 
   d="scan'208";a="5667075"
Message-ID: <5031A764.8090806@cn.fujitsu.com>
Date: Mon, 20 Aug 2012 10:56:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mingo@redhat.com,
        lauro.venancio@openbossa.org, jak@jak-linux.org,
        Jens Axboe <axboe@kernel.dk>, David Airlie <airlied@linux.ie>,
        Jiri Kosina <jkosina@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/6] workqueue: deprecate system_nrt[_freezable]_wq
References: <1344908986-18152-1-git-send-email-tj@kernel.org> <1344908986-18152-6-git-send-email-tj@kernel.org>
In-Reply-To: <1344908986-18152-6-git-send-email-tj@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/20 10:55:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/20 10:55:24,
	Serialize complete at 2012/08/20 10:55:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 09:49 AM, Tejun Heo wrote:
> system_nrt[_freezable]_wq are now spurious.  Mark them deprecated and
> convert all users to system[_freezable]_wq.
> 
> If you're cc'd and wondering what's going on: Now all workqueues are
> non-reentrant, so there's no reason to use system_nrt[_freezable]_wq.
> Please use system[_freezable]_wq instead.
> 
> This patch doesn't make any functional difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  block/blk-throttle.c              |    7 +++----
>  block/genhd.c                     |   10 +++++-----
>  drivers/gpu/drm/drm_crtc_helper.c |    6 +++---
>  drivers/hid/hid-wiimote-ext.c     |    2 +-
>  drivers/mmc/core/host.c           |    4 ++--
>  drivers/net/virtio_net.c          |   12 ++++++------
>  include/linux/workqueue.h         |    4 ++--
>  kernel/srcu.c                     |    4 ++--
>  security/keys/gc.c                |    8 ++++----
>  security/keys/key.c               |    2 +-
>  10 files changed, 29 insertions(+), 30 deletions(-)



> diff --git a/kernel/srcu.c b/kernel/srcu.c
> index 2095be3..97c465e 100644
> --- a/kernel/srcu.c
> +++ b/kernel/srcu.c
> @@ -379,7 +379,7 @@ void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
>  	rcu_batch_queue(&sp->batch_queue, head);
>  	if (!sp->running) {
>  		sp->running = true;
> -		queue_delayed_work(system_nrt_wq, &sp->work, 0);
> +		schedule_delayed_work(&sp->work, 0);
>  	}
>  	spin_unlock_irqrestore(&sp->queue_lock, flags);
>  }
> @@ -631,7 +631,7 @@ static void srcu_reschedule(struct srcu_struct *sp)
>  	}
>  
>  	if (pending)
> -		queue_delayed_work(system_nrt_wq, &sp->work, SRCU_INTERVAL);
> +		schedule_delayed_work(&sp->work, SRCU_INTERVAL);
>  }
>  
>  /*


Acked-By: Lai Jiangshan <laijs@cn.fujitsu.com>


