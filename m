Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2G0Pur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:50:47 -0400
Received: from mail.vyatta.com ([76.74.103.46]:49647 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab2G0Pup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:50:45 -0400
Date: Fri, 27 Jul 2012 08:50:21 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Cong Wang <amwang@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] bridge: call NETDEV_RELEASE notifier in br_del_if()
Message-ID: <20120727085021.1d4ef810@nehalam.linuxnetplumber.net>
In-Reply-To: <1343403484-29347-5-git-send-email-amwang@redhat.com>
References: <1343403484-29347-1-git-send-email-amwang@redhat.com>
	<1343403484-29347-5-git-send-email-amwang@redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012 23:38:01 +0800
Cong Wang <amwang@redhat.com> wrote:

> When a bridge interface deletes its underlying ports, it should
> notify netconsole too, like what bonding interface does.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---
>  net/bridge/br_if.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index e1144e1..d243914 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -427,6 +427,7 @@ int br_del_if(struct net_bridge *br, struct net_device *dev)
>  	if (!p || p->br != br)
>  		return -EINVAL;
>  
> +	call_netdevice_notifiers(NETDEV_RELEASE, br->dev);
>  	del_nbp(p);
>  
>  	spin_lock_bh(&br->lock);

Since you can have multiple ports attached to the bridge, this
doesn't seem correct. Don't you want the netconsole to keep going
on the other ports of the bridge?

What exactly is the problem with having netconsole persist?
