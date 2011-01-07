Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1AGTj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:39:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:41880 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1AGTj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:39:58 -0500
Date: Fri, 7 Jan 2011 14:39:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Sathya Perla <sathyap@serverengines.com>,
        Ajit Khaparde <ajitk@serverengines.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Jin <joe.jin@oracle.com>,
        Subbu Seetharaman <subbus@serverengines.com>,
        Sarveshwar Bandi <sarveshwarb@serverengines.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [064/152] driver/net/benet: fix
 be_cmd_multicast_set() memcpy bug
Message-ID: <20110107193907.GH32717@windriver.com>
References: <20110106002500.GA3172@kroah.com>
 <20110106002302.664621558@clark.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106002302.664621558@clark.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jan 2011 19:39:08.0607 (UTC) FILETIME=[8D23F4F0:01CBAEA2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[stable] [064/152] driver/net/benet: fix be_cmd_multicast_set() memcpy bug] On 05/01/2011 (Wed 16:22) Greg KH wrote:

> 2.6.36-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> 
> From: Joe Jin <joe.jin@oracle.com>
> 
> [ Upstream commit 3fd40d0ceac9c234243730f4d7a6ffdb2fd3023a ]

This one should be 408cc293c29ada769ae772420a39961320da1854.

Figured I'd run reviewbot on the others and check for valid IDs.
There are a couple others that have the same issue:

0066
bridge-fix-IPv6-queries-for-bridge-multicast-snoopin.patch
	should be 76d661586c8131453ba75a2e027c1f21511a893a

0072
l2tp-Fix-modalias-of-l2tp_ip.patch
	should be e8d34a884e4ff118920bb57664def8a73b1b784f

0073
x25-decrement-netdev-reference-counts-on-unload.patch
	should be 171995e5d82dcc92bea37a7d2a2ecc21068a0f19

0076
net-Fix-header-size-check-for-GSO-case-in-recvmsg-af.patch
	should be 1f18b7176e2e41fada24584ce3c80e9abfaca52b

Thanks,
Paul.

> 
> Regarding  benet be_cmd_multicast_set() function, now using
> netdev_for_each_mc_addr() helper for mac address copy, but
> when copying to req->mac[] did not increase of the index.
> 
> Cc: Sathya Perla <sathyap@serverengines.com>
> Cc: Subbu Seetharaman <subbus@serverengines.com>
> Cc: Sarveshwar Bandi <sarveshwarb@serverengines.com>
> Cc: Ajit Khaparde <ajitk@serverengines.com>
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/net/benet/be_cmds.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/net/benet/be_cmds.c
> +++ b/drivers/net/benet/be_cmds.c
> @@ -1179,7 +1179,7 @@ int be_cmd_multicast_set(struct be_adapt
>  
>  		i = 0;
>  		netdev_for_each_mc_addr(ha, netdev)
> -			memcpy(req->mac[i].byte, ha->addr, ETH_ALEN);
> +			memcpy(req->mac[i++].byte, ha->addr, ETH_ALEN);
>  	} else {
>  		req->promiscuous = 1;
>  	}
> 
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
