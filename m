Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab0EDM1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:27:51 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:57619 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0EDM1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:27:49 -0400
Subject: Re: [patch] sunrpc: add missing return statement
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Johannes Weiner <jw@emlix.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Alexandros Batsakis <batsakis@netapp.com>, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100504115759.266396633@emlix.com>
References: <20100504115759.266396633@emlix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 08:27:22 -0400
Message-ID: <1272976042.7559.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 7 msgs/h 2 sum rcpts/h 8 sum msgs/h 2 total rcpts 167 max rcpts/h 14 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: ABA6A51FB5CEC55925E17B2239404A696FDE5359
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 87 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 13:59 +0200, Johannes Weiner wrote: 
> f300bab "nfsd41: sunrpc: add new xprt class for nfsv4.1 backchannel"
> introduced an error case branch that lacks an actual `return' keyword
> before the return value.  Add it.
> 
> Signed-off-by: Johannes Weiner <jw@emlix.com>
> Cc: Alexandros Batsakis <batsakis@netapp.com>
> ---
>  net/sunrpc/xprtsock.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -2444,7 +2444,7 @@ static struct rpc_xprt *xs_setup_bc_tcp(
>  	struct svc_sock *bc_sock;
>  
>  	if (!args->bc_xprt)
> -		ERR_PTR(-EINVAL);
> +		return ERR_PTR(-EINVAL);
>  
>  	xprt = xs_setup_xprt(args, xprt_tcp_slot_table_entries);
>  	if (IS_ERR(xprt))

No. It should either be a BUG_ON(), or else be removed entirely.
Returning an error value for something that is clearly a programming bug
is not a particularly useful exercise...

Cheers
  Trond


