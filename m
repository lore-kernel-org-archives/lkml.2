Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab2LGAPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:15:54 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63503 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2LGAPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:15:52 -0500
Date: Fri, 7 Dec 2012 00:15:47 +0000
From: Cong Ding <dinggnu@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: fix unused variable sparse warning
Message-ID: <20121207001545.GE2510@gmail.com>
References: <1354838913-20084-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354838913-20084-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 12:06:44AM +0000, Cong Ding wrote:
> the variables zero and unres_qlen_max are only used when CONFIG_SYSCTL is
> defined, otherwise it causes the following sparse warning when we turn on
> CONFIG_SYSCTL.
sorry for disturbing again, the sparse warning is
net/core/neighbour.c:65:12: warning: ‘zero’ defined but not used [-Wunused-variable]
net/core/neighbour.c:66:12: warning: ‘unres_qlen_max’ defined but not used [-Wunused-variable]

it happens if we turn off CONFIG_SYSCTL.

> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  net/core/neighbour.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 36fc692..4a15278 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -62,8 +62,10 @@ static void __neigh_notify(struct neighbour *n, int type, int flags);
>  static void neigh_update_notify(struct neighbour *neigh);
>  static int pneigh_ifdown(struct neigh_table *tbl, struct net_device *dev);
>  
> +#ifdef CONFIG_SYSCTL
>  static int zero;
>  static int unres_qlen_max = INT_MAX / SKB_TRUESIZE(ETH_FRAME_LEN);
> +#endif
>  
>  static struct neigh_table *neigh_tables;
>  #ifdef CONFIG_PROC_FS
> -- 
> 1.7.4.5
> 
