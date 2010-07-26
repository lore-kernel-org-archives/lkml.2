Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0GZQEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:04:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab0GZQEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:04:49 -0400
Date: Mon, 26 Jul 2010 12:04:40 -0400
From: David Teigland <teigland@redhat.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dlm: use genl_register_family_with_ops()
Message-ID: <20100726160440.GA18604@redhat.com>
References: <1280135959-17485-1-git-send-email-xiaosuo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280135959-17485-1-git-send-email-xiaosuo@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 05:19:19PM +0800, Changli Gao wrote:
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  fs/dlm/netlink.c |   15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
> index 2c6ad51..ef17e01 100644
> --- a/fs/dlm/netlink.c
> +++ b/fs/dlm/netlink.c
> @@ -81,24 +81,11 @@ static struct genl_ops dlm_nl_ops = {
>  
>  int __init dlm_netlink_init(void)
>  {
> -	int rv;
> -
> -	rv = genl_register_family(&family);
> -	if (rv)
> -		return rv;
> -
> -	rv = genl_register_ops(&family, &dlm_nl_ops);
> -	if (rv < 0)
> -		goto err;
> -	return 0;
> - err:
> -	genl_unregister_family(&family);
> -	return rv;
> +	return genl_register_family_with_ops(&family, &dlm_nl_ops, 1);
>  }
>  
>  void dlm_netlink_exit(void)
>  {
> -	genl_unregister_ops(&family, &dlm_nl_ops);
>  	genl_unregister_family(&family);
>  }

Looks fine, ack.
Dave

