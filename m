Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0EaTI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:08:29 -0400
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:40020 "EHLO
	homiemail-a15.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756586Ab0EaTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=sysclose.org; h=date:from:to:cc
	:subject:message-id:references:mime-version:content-type:
	in-reply-to; q=dns; s=sysclose.org; b=WCPZul0R4kax22PHD4MN0jJiad
	tMreaOYCOYEA+k2Jh78Wn3nF4AqYroE3afIShJ6J/xsiGUtPR+6OUQLlOFeeg5r2
	CJFd/V9ayZF/qiJcmhuQT8Z59NnuAcCvj28QIBmmzvMU1Zhc0JWdTjUf6sX2JBHe
	b1v4/nn1A5cB7QuyY=
Date: Mon, 31 May 2010 16:08:20 -0300
From: Flavio Leitner <fbl@sysclose.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
       Andy Gospodarek <gospo@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [v5 Patch 1/3] netpoll: add generic support for bridge and
 bonding devices
Message-ID: <20100531190820.GA24569@sysclose.org>
References: <20100505081514.5157.83783.sendpatchset@localhost.localdomain>
 <20100527180545.GA2345@sysclose.org>
 <4BFF2EA5.9090008@redhat.com>
 <20100528194041.GC2345@sysclose.org>
 <4C034FA4.5000401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C034FA4.5000401@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 01:56:52PM +0800, Cong Wang wrote:
> Hi, Flavio,
> 
> Please use the attached patch instead, try to see if it solves
> all your problems.

I tried and it hangs. No backtraces this time.
The bond_change_active_slave() prints before NETDEV_BONDING_FAILOVER
notification, so I think it won't work. 

Please, correct if I'm wrong, but when a failover happens with your 
patch applied, the netconsole would be disabled forever even with
another healthy slave, right?

fbl


> 
> Thanks a lot!
> 

> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index ca142c4..2d1d594 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -666,7 +666,8 @@ static int netconsole_netdev_event(struct notifier_block *this,
>  	struct net_device *dev = ptr;
>  
>  	if (!(event == NETDEV_CHANGENAME || event == NETDEV_UNREGISTER ||
> -	      event == NETDEV_BONDING_DESLAVE || event == NETDEV_GOING_DOWN))
> +	      event == NETDEV_BONDING_DESLAVE || event == NETDEV_GOING_DOWN ||
> +	      event == NETDEV_BONDING_FAILOVER))
>  		goto done;
>  
>  	spin_lock_irqsave(&target_list_lock, flags);
> @@ -682,6 +683,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
>  				/* Fall through */
>  			case NETDEV_GOING_DOWN:
>  			case NETDEV_BONDING_DESLAVE:
> +			case NETDEV_BONDING_FAILOVER:
>  				nt->enabled = 0;
>  				break;
>  			}


-- 
Flavio
