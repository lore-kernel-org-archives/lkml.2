Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab1J0GoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 02:44:00 -0400
Received: from mx2.netapp.com ([216.240.18.37]:23700 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab1J0Gn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 02:43:58 -0400
X-IronPort-AV: E=Sophos;i="4.69,412,1315206000"; 
   d="scan'208";a="592690601"
Message-ID: <4EA8FD98.9040500@netapp.com>
Date: Thu, 27 Oct 2011 02:43:36 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org, xemul@parallels.com,
        neilb@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, davem@davemloft.net, devel@openvz.org
Subject: Re: [PATCH v2 1/4] SUNRPC: rpcbind clients internals virtualization
References: <20111025135637.5286.89632.stgit@localhost6.localdomain6> <20111025135749.5286.57091.stgit@localhost6.localdomain6>
In-Reply-To: <20111025135749.5286.57091.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 10:57 AM, Stanislav Kinsbursky wrote:
> This patch moves static rpcbind internals to sunrpc part of network namespace

Rather than saying that this patch moves the static internals, could you say that it creates the new network namespace internals?  The next patch switches things over, so it's not really correct to say that this one moves everything.

Alternatively, could this patch be merged with the next one so that you create and switch over to the new internals all at once?

- Bryan

> context. This will allow to create rcpbind clients per network namespace.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> 
> ---
>  net/sunrpc/netns.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/sunrpc/netns.h b/net/sunrpc/netns.h
> index d013bf2..83eede3 100644
> --- a/net/sunrpc/netns.h
> +++ b/net/sunrpc/netns.h
> @@ -9,6 +9,11 @@ struct cache_detail;
>  struct sunrpc_net {
>  	struct proc_dir_entry *proc_net_rpc;
>  	struct cache_detail *ip_map_cache;
> +
> +	struct rpc_clnt *rpcb_local_clnt;
> +	struct rpc_clnt *rpcb_local_clnt4;
> +	spinlock_t rpcb_clnt_lock;
> +	unsigned int rpcb_users;
>  };
>  
>  extern int sunrpc_net_id;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

