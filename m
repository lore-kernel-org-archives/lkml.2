Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab0K2DIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 22:08:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57991 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0K2DIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 22:08:22 -0500
Message-ID: <4CF318F3.7040600@oracle.com>
Date: Sun, 28 Nov 2010 19:07:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Scott J. Goldman" <scottjg@vmware.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, pv-drivers@vmware.com
Subject: Re: [PATCH] vmxnet3: fix compilation when RSS is disabled
References: <1290890035-32285-1-git-send-email-scottjg@vmware.com> <1290890035-32285-2-git-send-email-scottjg@vmware.com>
In-Reply-To: <1290890035-32285-2-git-send-email-scottjg@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/10 12:33, Scott J. Goldman wrote:
> If RSS is disabled, we can ifdef out some RSS specific code. This fixes
> the compile error found by Randy Dunlap.
> 
> Signed-off-by: Scott J. Goldman <scottjg@vmware.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  drivers/net/vmxnet3/vmxnet3_ethtool.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
> index 9ddaea6..8e17fc8 100644
> --- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
> +++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
> @@ -553,7 +553,7 @@ vmxnet3_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *info,
>  	return -EOPNOTSUPP;
>  }
>  
> -
> +#ifdef VMXNET3_RSS
>  static int
>  vmxnet3_get_rss_indir(struct net_device *netdev,
>  		      struct ethtool_rxfh_indir *p)
> @@ -598,6 +598,7 @@ vmxnet3_set_rss_indir(struct net_device *netdev,
>  	return 0;
>  
>  }
> +#endif
>  
>  static struct ethtool_ops vmxnet3_ethtool_ops = {
>  	.get_settings      = vmxnet3_get_settings,
> @@ -623,8 +624,10 @@ static struct ethtool_ops vmxnet3_ethtool_ops = {
>  	.get_ringparam     = vmxnet3_get_ringparam,
>  	.set_ringparam     = vmxnet3_set_ringparam,
>  	.get_rxnfc         = vmxnet3_get_rxnfc,
> +#ifdef VMXNET3_RSS
>  	.get_rxfh_indir    = vmxnet3_get_rss_indir,
>  	.set_rxfh_indir    = vmxnet3_set_rss_indir,
> +#endif
>  };
>  
>  void vmxnet3_set_ethtool_ops(struct net_device *netdev)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
