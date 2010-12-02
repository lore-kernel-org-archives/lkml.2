Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab0LBSg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:36:58 -0500
Received: from mail.vyatta.com ([76.74.103.46]:50456 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab0LBSg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:36:56 -0500
Date: Thu, 2 Dec 2010 10:36:50 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
        Neil Horman <nhorman@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>
Subject: Re: [v2 PATCH 1/2] bonding: sync netpoll code with bridge
Message-ID: <20101202103650.06647704@nehalam>
In-Reply-To: <20101202134041.6073.5201.sendpatchset@localhost.localdomain>
References: <20101202134041.6073.5201.sendpatchset@localhost.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010 08:35:42 -0500
Amerigo Wang <amwang@redhat.com> wrote:

>  #ifdef CONFIG_NET_POLL_CONTROLLER
> -	if (unlikely(bond->dev->priv_flags & IFF_IN_NETPOLL)) {
> -		struct netpoll *np = bond->dev->npinfo->netpoll;
> -		slave_dev->npinfo = bond->dev->npinfo;
> +	if (unlikely(netpoll_tx_running(slave_dev))) {
>  		slave_dev->priv_flags |= IFF_IN_NETPOLL;
> -		netpoll_send_skb_on_dev(np, skb, slave_dev);
> +		bond_netpoll_send_skb(bond_get_slave_by_dev(bond, slave_dev), skb);
>  		slave_dev->priv_flags &= ~IFF_IN_NETPOLL;
>  	} else
>  #endif

Couldn't you eliminate #ifdef by putting the following into header file.

#ifdef CONFIG_NET_POLL_CONTROLLER
static inline netpoll_tx_running
...
#else
#define netpoll_tx_running(dev)  (0)
#endif


-- 
