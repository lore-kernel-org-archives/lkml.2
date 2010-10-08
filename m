Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab0JHRnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:43:53 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2548 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433Ab0JHRnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:43:52 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Date: Fri, 8 Oct 2010 10:43:12 -0700
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Nicolas Kaiser" <nikai@nikai.net>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
        "Michael Chan" <mchan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/tg3: simplify conditional
Message-ID: <20101008174312.GA3562@mcarlson.broadcom.com>
References: <20101008112927.0ca949cf@absol.kitzblitz>
MIME-Version: 1.0
In-Reply-To: <20101008112927.0ca949cf@absol.kitzblitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 60B187C647819641534-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 02:29:27AM -0700, Nicolas Kaiser wrote:
> Simplify: ((a && !b) || (!a && b)) => (a != b)
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  drivers/net/tg3.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
> index 16e1a95..714f0fb 100644
> --- a/drivers/net/tg3.c
> +++ b/drivers/net/tg3.c
> @@ -9967,8 +9967,7 @@ static int tg3_set_pauseparam(struct net_device *dev, struct ethtool_pauseparam
>  
>  		if (!(phydev->supported & SUPPORTED_Pause) ||
>  		    (!(phydev->supported & SUPPORTED_Asym_Pause) &&
> -		     ((epause->rx_pause && !epause->tx_pause) ||
> -		      (!epause->rx_pause && epause->tx_pause))))
> +		     (epause->rx_pause != epause->tx_pause)))
>  			return -EINVAL;
>  
>  		tp->link_config.flowctrl = 0;

Looks good to me.

