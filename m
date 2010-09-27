Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028Ab0I0SX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:23:58 -0400
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:16298 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759971Ab0I0SX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:23:56 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 14:23:56 EDT
Message-ID: <4CA0DDA6.7040600@caviumnetworks.com>
Date: Mon, 27 Sep 2010 11:08:38 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] staging: octeon: use free_netdev(netdev) instead
 of kfree()
References: <1285495102-22111-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1285495102-22111-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2010 18:08:38.0517 (UTC) FILETIME=[026B7A50:01CB5E6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2010 02:58 AM, Vasiliy Kulikov wrote:
> It is not guaranteed that free_netdev() is macro.
> Freeing netdev without free_netdev() leads to net, tx leaks.
> I might lead to dereferencing freed pointer.
>

There is no Signed-off-by header here.

Please resend the patch with the proper headers.

Other than that, it looks good to me.  You can add:

Acked-by: David Daney <ddaney@caviumnetworks.com>

Thanks.



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

