Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0G0DlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 23:41:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54907 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab0G0DlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 23:41:09 -0400
Message-ID: <4C4E5560.9060905@cn.fujitsu.com>
Date: Tue, 27 Jul 2010 11:41:20 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Tejun Heo <tj@kernel.org>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: set task state with schedule_timeout_uninterruptible()
References: <1280132864-8266-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1280132864-8266-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010 12:27:43 +0400, Kulikov Vasiliy wrote:
> worker_loop() uses schedule_timeout() without setting state to
> STATE_(UN)INTERRUPTIBLE. As it is called in cycle without checking of
> pending signals, use schedule_timeout_uninterruptible().
> 
> Signed-off-by: Kulikov Vasiliy<segooon@gmail.com>
> ---
>   fs/btrfs/async-thread.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index 7ec1409..54eb070 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -362,7 +362,7 @@ again:
>   				 * worker->working is still 1, so nobody
>   				 * is going to try and wake us up
>   				 */
> -				schedule_timeout(1);
> +				schedule_timeout_uninterruptible(1);

I found there is the same problem in the other place of the btrfs,
could you fix them?

Thanks!
Miao

>   				smp_mb();
>   				if (!list_empty(&worker->pending) ||
>   				    !list_empty(&worker->prio_pending))

