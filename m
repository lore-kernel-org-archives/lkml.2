Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1GTVGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 17:06:51 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:43593 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751957Ab1GTVGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 17:06:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fwUW0Z+L7mYYEdggRXMas29cAWbZa2uitcxqbafWtmKRl8IFM4iqiboWKe1aydky85ieVoJnmpzjfyj58ZHaWIELxU6LhpDZLZQU/9vCmf+/miBVC1u0LoyRnHhylLEY;
Date: Wed, 20 Jul 2011 14:06:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: David Lamparter <equinox@diac24.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-driver@qlogic.com,
        Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: vlan: fix compile breakage from 69ecca8
Message-Id: <20110720140646.b66bd02b.rdunlap@xenotime.net>
In-Reply-To: <1311191033-714631-1-git-send-email-equinox@diac24.net>
References: <0E5EAE44-204C-4F4D-926C-F4D973B0CDB1@qlogic.com>
	<1311191033-714631-1-git-send-email-equinox@diac24.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011 21:43:53 +0200 David Lamparter wrote:

> well, there was too much wood to see the tree and I messed up the
> configuration dependencies. let's make it work with unset
> CONFIG_VLAN_8021Q and remove the second definition of vlan_find_dev.
> 
> Signed-off-by: David Lamparter <equinox@diac24.net>
> Cc: linux-driver@qlogic.com
> Cc: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Randy Dunlap <rdunlap@xenotime.net>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
> sorry for the mess-up... compiled with CONFIG_VLAN_8021Q=n,m and y
> this time; don't have qlcnic hw to test.
> 
>  drivers/net/qlcnic/qlcnic_main.c |    4 +++-
>  include/linux/if_vlan.h          |    5 -----
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/qlcnic/qlcnic_main.c b/drivers/net/qlcnic/qlcnic_main.c
> index 3579229..a2c39e9 100644
> --- a/drivers/net/qlcnic/qlcnic_main.c
> +++ b/drivers/net/qlcnic/qlcnic_main.c
> @@ -4198,13 +4198,15 @@ static void
>  qlcnic_restore_indev_addr(struct net_device *netdev, unsigned long event)
>  {
>  	struct qlcnic_adapter *adapter = netdev_priv(netdev);
> -	struct vlan_group *grp;
> +	struct vlan_group *grp = NULL;
>  	struct net_device *dev;
>  	u16 vid;
>  
>  	qlcnic_config_indev_addr(adapter, netdev, event);
>  
> +#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
>  	grp = rcu_dereference_rtnl(netdev->vlgrp);
> +#endif
>  	if (!grp)
>  		return;
>  
> diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
> index bc03e40..dbe41dc 100644
> --- a/include/linux/if_vlan.h
> +++ b/include/linux/if_vlan.h
> @@ -135,11 +135,6 @@ vlan_gro_frags(struct napi_struct *napi, struct vlan_group *grp,
>  	       unsigned int vlan_tci);
>  
>  #else
> -static inline struct net_device *vlan_find_dev(struct net_device *real_dev,
> -					       u16 vlan_id)
> -{
> -	return NULL;
> -}
>  
>  static inline struct net_device *vlan_dev_real_dev(const struct net_device *dev)
>  {
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
