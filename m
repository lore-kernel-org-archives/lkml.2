Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1CPOZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:25:53 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:40525 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab1CPOZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:25:47 -0400
Subject: Re: [patch]xprt: remove redundant checks
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: j223yang@asset.uwaterloo.ca
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110316064509.GA1498@asset.uwaterloo.ca>
References: <20110316064509.GA1498@asset.uwaterloo.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 10:25:40 -0400
Message-ID: <1300285540.16266.49.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 5 sum msgs/h 1 total rcpts 1363 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 037F1F956DC80D0C34AAEF887C3E96295C29033B
X-UiO-SPAM-Test: remote_host: 98.250.108.142 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 10 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 02:45 -0400, j223yang@asset.uwaterloo.ca wrote:
> 'req' is already dereferenced in 
> 'struct rpc_xprt *xprt = req->rq_xprt;',
> but check again later in the function.
> The patch removes these redundant checks.
> 
> Signed-off-by: Jinqiu Yang <crindy646@gmail.com>
> ---
>  xprt.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sunrpt/xprt.c b/net/sunrpt/xprt.c
> --- a/net/sunrpc/xprt.c	2011-03-16 00:10:08.764164573 -0400
> +++ b/net/sunrpt/xprt.c	2011-03-16 02:33:38.559164414 -0400
> @@ -202,10 +202,8 @@ int xprt_reserve_xprt(struct rpc_task *t
>  		goto out_sleep;
>  	}
>  	xprt->snd_task = task;
> -	if (req) {
> -		req->rq_bytes_sent = 0;
> -		req->rq_ntrans++;
> -	}
> +	req->rq_bytes_sent = 0;
> +	req->rq_ntrans++;
>  	return 1;
>  
>  out_sleep:
> @@ -213,7 +211,7 @@ out_sleep:
>  			task->tk_pid, xprt);
>  	task->tk_timeout = 0;
>  	task->tk_status = -EAGAIN;
> -	if (req && req->rq_ntrans)
> +	if (req->rq_ntrans)
>  		rpc_sleep_on(&xprt->resend, task, NULL);
>  	else
>  		rpc_sleep_on(&xprt->sending, task, NULL);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

You already sent hunk 1 in a different patch, and I've already applied
that to the nfs-for-2.6.39 branch. Could you therefore please resend
this patch with just the second hunk.

Cheers
  Trond

