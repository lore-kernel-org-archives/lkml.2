Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2APRuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:50:04 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:59816 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755690Ab2APRuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:50:02 -0500
Message-ID: <4F1470F5.7090803@xenotime.net>
Date: Mon, 16 Jan 2012 10:48:21 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] move sock_update_memcg outside of CONFIG_INET
References: <1326701079-10331-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1326701079-10331-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 12:04 AM, Glauber Costa wrote:
> Although only used currently for tcp sockets, this function
> is now used in common sock code (for sock_clone())
> 
> Commit 475f1b52645a29936b9df1d8fcd45f7e56bd4a9f moved the
> declaration of sock_update_clone() to inside sock.c, but
> this only fixes the problem when CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> is also not defined.
> 
> This patch here is verified to fix both problems, although
> reverting the previous one is not necessary.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Stephen Rothwell <sfr@canb.auug.org.au>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 602207b..3dbff4d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -373,7 +373,6 @@ static void mem_cgroup_put(struct mem_cgroup *memcg);
>  
>  /* Writing them here to avoid exposing memcg's inner layout */
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> -#ifdef CONFIG_INET
>  #include <net/sock.h>
>  #include <net/ip.h>
>  
> @@ -420,6 +419,7 @@ void sock_release_memcg(struct sock *sk)
>  	}
>  }
>  
> +#ifdef CONFIG_INET
>  struct cg_proto *tcp_proto_cgroup(struct mem_cgroup *memcg)
>  {
>  	if (!memcg || mem_cgroup_is_root(memcg))


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
