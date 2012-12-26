Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2LZSDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 13:03:51 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43535 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2LZSDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 13:03:50 -0500
Date: Wed, 26 Dec 2012 13:03:39 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Li Zefan <lizefan@huawei.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] netprio_cgroup: define sk_cgrp_prioidx only if
 NETPRIO_CGROUP is enabled
Message-ID: <20121226180339.GB10793@neilslaptop.think-freely.org>
References: <50DA9DB8.6080506@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50DA9DB8.6080506@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 02:48:24PM +0800, Li Zefan wrote:
> sock->sk_cgrp_prioidx won't be used at all if CONFIG_NETPRIO_CGROUP=n.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
>  include/net/sock.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 93a6745..182ca99 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -367,7 +367,7 @@ struct sock {
>  	unsigned short		sk_ack_backlog;
>  	unsigned short		sk_max_ack_backlog;
>  	__u32			sk_priority;
> -#ifdef CONFIG_CGROUPS
> +#if IS_ENABLED(CONFIG_NETPRIO_CGROUP)
>  	__u32			sk_cgrp_prioidx;
>  #endif
>  	struct pid		*sk_peer_pid;
> -- 
> 1.8.0.2
> 
> 
