Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2HMRPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:15:41 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:51920 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752204Ab2HMRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:15:38 -0400
Message-ID: <1344878131.2733.28.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [patch net-next 15/16] net: remove usage of dev->master
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <faisal.latif@intel.com>, <roland@kernel.org>, <sean.hefty@intel.com>,
        <hal.rosenstock@gmail.com>, <fubar@us.ibm.com>, <andy@greyhouse.net>,
        <divy@chelsio.com>, <jitendra.kalsaria@qlogic.com>,
        <sony.chacko@qlogic.com>, <linux-driver@qlogic.com>, <kaber@trash.net>,
        <ursula.braun@de.ibm.com>, <blaschka@linux.vnet.ibm.com>,
        <linux390@de.ibm.com>, <shemminger@vyatta.com>, <therbert@google.com>,
        <xiyou.wangcong@gmail.com>, <joe@perches.com>,
        <gregory.v.rose@intel.com>, <john.r.fastabend@intel.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        <fbl@redhat.com>
Date: Mon, 13 Aug 2012 18:15:31 +0100
In-Reply-To: <1344871635-1052-16-git-send-email-jiri@resnulli.us>
References: <1344871635-1052-1-git-send-email-jiri@resnulli.us>
	 <1344871635-1052-16-git-send-email-jiri@resnulli.us>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 17:27 +0200, Jiri Pirko wrote:
> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
> ---
>  net/core/dev.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c0f9adb..8977404 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5461,8 +5461,8 @@ static void rollback_registered_many(struct list_head *head)
>  		if (dev->netdev_ops->ndo_uninit)
>  			dev->netdev_ops->ndo_uninit(dev);
>  
> -		/* Notifier chain MUST detach us from master device. */
> -		WARN_ON(dev->master);
> +		/* Notifier chain MUST detach us all upper devices. */
> +		WARN_ON(netdev_has_any_upper_dev(dev));
>  
>  		/* Remove entries from kobject tree */
>  		netdev_unregister_kobject(dev);

I think this should be folded into patch 1, since that already ensures
that any master device is included in the upper device list.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

