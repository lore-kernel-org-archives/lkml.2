Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab0KLTOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:14:39 -0500
Received: from fieldses.org ([174.143.236.118]:57600 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab0KLTOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:14:37 -0500
Date: Fri, 12 Nov 2010 14:14:33 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org, Trond Myklebust <trond@netapp.com>
Subject: Re: [PATCH] NET: sunrpc, remove unneeded NULL tests
Message-ID: <20101112191433.GC32745@fieldses.org>
References: <1288180325-20009-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288180325-20009-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the slow response, this one's for Trond if it hasn't already
been handled.

--b.

On Wed, Oct 27, 2010 at 01:52:05PM +0200, Jiri Slaby wrote:
> Stanse found that req in xprt_reserve_xprt is dereferenced prior its
> test to NULL. If that's the case, the checks are unnecessary, so
> remove them.
> 
> The alternative is not to dereference it before the test. The patch
> is to point out the problem, you have to decide.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> Cc: Neil Brown <neilb@suse.de>
> Cc: linux-nfs@vger.kernel.org
> ---
>  net/sunrpc/xprt.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
> index 4c8f18a..5355c71 100644
> --- a/net/sunrpc/xprt.c
> +++ b/net/sunrpc/xprt.c
> @@ -202,10 +202,8 @@ int xprt_reserve_xprt(struct rpc_task *task)
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
> 1.7.3.1
> 
> 
