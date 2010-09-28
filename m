Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab0I1RNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:13:10 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:17656 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab0I1RNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:13:08 -0400
Message-ID: <4CA22223.3030701@caviumnetworks.com>
Date: Tue, 28 Sep 2010 10:13:07 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
CC: kernel-janitors@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] staging: octeon: use free_netdev(netdev) instead
 of kfree()
References: <1285693681-4679-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1285693681-4679-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Sep 2010 17:13:07.0260 (UTC) FILETIME=[6B3FBFC0:01CB5F30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 10:08 AM, Vasiliy Kulikov wrote:
> It is not guaranteed that free_netdev() is macro.
> Freeing netdev without free_netdev() leads to net, tx leaks.
> I might lead to dereferencing freed pointer.
>
>
> Signed-off-by: Vasiliy Kulikov<segooon@gmail.com>

Thanks, you can add:

Acked-by: David Daney <ddaney@caviumnetworks.com>


> ---
>   drivers/staging/octeon/ethernet.c |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
> index fb568a9..a8f780e 100644
> --- a/drivers/staging/octeon/ethernet.c
> +++ b/drivers/staging/octeon/ethernet.c
> @@ -670,7 +670,7 @@ static int __init cvm_oct_init_module(void)
>
>   			if (register_netdev(dev)<  0) {
>   				pr_err("Failed to register ethernet device for POW\n");
> -				kfree(dev);
> +				free_netdev(dev);
>   			} else {
>   				cvm_oct_device[CVMX_PIP_NUM_INPUT_PORTS] = dev;
>   				pr_info("%s: POW send group %d, receive group %d\n",
> @@ -756,12 +756,12 @@ static int __init cvm_oct_init_module(void)
>   			}
>
>   			if (!dev->netdev_ops) {
> -				kfree(dev);
> +				free_netdev(dev);
>   			} else if (register_netdev(dev)<  0) {
>   				pr_err("Failed to register ethernet device "
>   					 "for interface %d, port %d\n",
>   					 interface, priv->port);
> -				kfree(dev);
> +				free_netdev(dev);
>   			} else {
>   				cvm_oct_device[priv->port] = dev;
>   				fau -=
> @@ -815,7 +815,7 @@ static void __exit cvm_oct_cleanup_module(void)
>
>   			cvm_oct_tx_shutdown_dev(dev);
>   			unregister_netdev(dev);
> -			kfree(dev);
> +			free_netdev(dev);
>   			cvm_oct_device[port] = NULL;
>   		}
>   	}

