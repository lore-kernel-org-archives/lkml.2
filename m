Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2BURWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:22:22 -0500
Received: from mail.vyatta.com ([76.74.103.46]:40294 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2BURWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:22:21 -0500
Date: Tue, 21 Feb 2012 09:22:13 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] br_device: unify return value of
 .ndo_set_mac_address if address is invalid
Message-ID: <20120221092213.12015034@nehalam.linuxnetplumber.net>
In-Reply-To: <1329826072-14689-5-git-send-email-danny.kukawka@bisect.de>
References: <1329826072-14689-1-git-send-email-danny.kukawka@bisect.de>
	<1329826072-14689-5-git-send-email-danny.kukawka@bisect.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Feb 2012 13:07:52 +0100
Danny Kukawka <danny.kukawka@bisect.de> wrote:

> Unify return value of .ndo_set_mac_address if the given address
> isn't valid. Return -EADDRNOTAVAIL as eth_mac_addr() already does
> if is_valid_ether_addr() fails.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  net/bridge/br_device.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index a157bf8..ba829de 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -167,7 +167,7 @@ static int br_set_mac_address(struct net_device *dev, void *p)
>  	struct sockaddr *addr = p;
>  
>  	if (!is_valid_ether_addr(addr->sa_data))
> -		return -EINVAL;
> +		return -EADDRNOTAVAIL;
>  
>  	spin_lock_bh(&br->lock);
>  	if (compare_ether_addr(dev->dev_addr, addr->sa_data)) {

Acked-by: Stephen Hemminger <shemminger@vyatta.com>
