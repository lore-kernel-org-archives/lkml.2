Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0HJNHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 09:07:36 -0400
Received: from smtp.citrix.com ([66.165.176.89]:49302 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab0HJNHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 09:07:31 -0400
X-IronPort-AV: E=Sophos;i="4.55,348,1278302400"; 
   d="scan'208";a="9712968"
Subject: Re: [09/38] xen: netfront: explicitly generate arp_notify event
 after migration.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
In-Reply-To: <20100806183200.858950407@clark.site>
References: <20100806183200.858950407@clark.site>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 10 Aug 2010 14:07:27 +0100
Message-ID: <1281445647.24292.3897.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Looks like I forgot to request this for 2.6.32 too, could you queue it
up there as well?

It depends on the previous patch in this series (arp_notify: allow
drivers to explicitly request a notification event.).

Thanks,
Ian.

On Fri, 2010-08-06 at 19:30 +0100, Greg KH wrote:
> 2.6.35-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Ian Campbell <Ian.Campbell@citrix.com>
> 
> commit 592970675c9522bde588b945388c7995c8b51328 upstream.
> 
> Use newly introduced netif_notify_peers() method to ensure a gratuitous ARP is
> generated after a migration.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Stephen Hemminger <shemminger@linux-foundation.org>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: xen-devel@lists.xensource.com
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/net/xen-netfront.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -1621,6 +1621,7 @@ static void backend_changed(struct xenbu
>  		if (xennet_connect(netdev) != 0)
>  			break;
>  		xenbus_switch_state(dev, XenbusStateConnected);
> +		netif_notify_peers(netdev);
>  		break;
>  
>  	case XenbusStateClosing:
> 
> 


