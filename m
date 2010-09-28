Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab0I1TXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 15:23:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:45165 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0I1TXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:23:10 -0400
Message-ID: <4CA24095.6090706@kernel.org>
Date: Tue, 28 Sep 2010 23:23:01 +0400
From: Denis Kirjanov <dkirjanov@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] staging: slicoss: use free_netdev(netdev) instead
 of kfree()
References: <1285693688-4763-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1285693688-4763-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 28 Sep 2010 19:22:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 09:08 PM, Vasiliy Kulikov wrote:
> Freeing netdev without free_netdev() leads to net, tx leaks.
> I might lead to dereferencing freed pointer.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> @@
> struct net_device* dev;
> @@
> 
> -kfree(dev)
> +free_netdev(dev)
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  drivers/staging/slicoss/slicoss.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> index 58ff123..18f1103 100644
> --- a/drivers/staging/slicoss/slicoss.c
> +++ b/drivers/staging/slicoss/slicoss.c
> @@ -3233,7 +3233,7 @@ static void __devexit slic_entry_remove(struct pci_dev *pcidev)
>  		slic_global.num_slic_cards--;
>  		slic_card_cleanup(card);
>  	}
> -	kfree(dev);
> +	free_netdev(dev);
>  	pci_release_regions(pcidev);
>  }
>  
Acked-by: Denis Kirjanov <dkirjanov@kernel.org>
