Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030691Ab2K3PXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:23:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030658Ab2K3PXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:23:38 -0500
Date: Fri, 30 Nov 2012 16:23:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Turczak <pt@netconsequence.de>
Cc: David Miller <davem@davemloft.net>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc: RFC: Workaround for problems with lan8710 phy auto
 MDI-X
In-Reply-To: <8D7E9026-6276-452B-9E0C-AEB8CF38C9FD@netconsequence.de>
Message-ID: <alpine.LNX.2.00.1211301622110.25639@pobox.suse.cz>
References: <8D7E9026-6276-452B-9E0C-AEB8CF38C9FD@netconsequence.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012, Peter Turczak wrote:

> while debugging network outages on a customers hardware I found, that 
> the MDI-X function of the lan8710 phy seemed to cause trouble. When 
> connecting to almost any kind of 100/1000MBit switch, the link would 
> seem to come up and data where sent out to the network. But all incoming 
> packets got lost somehow. This is quite bad, as the system runs from 
> nfsroot while booting up during development.
> 
> When I disabled the auto MDI-X function of the phy the problem went away.
> 
> Signed-off-by: Peter Turczak <pt@netconsequence.de>
> ---
>  drivers/net/phy/Kconfig |   10 ++++++++++
>  drivers/net/phy/smsc.c  |   15 +++++++++++++++
>  include/linux/smscphy.h |    5 +++++
>  3 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 961f0b2..341f5aa 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -60,6 +60,16 @@ config SMSC_PHY
>  	---help---
>  	  Currently supports the LAN83C185, LAN8187 and LAN8700 PHYs
>  
> +config SMSC_PHY_DISABLE_AUTOX
> +	bool "Disable MDI-X upon start"
> +	depends on SMSC_PHY
> +	---help---
> +	  When you experience problems estabishing a stable connection
> +	  to a network and you have e.g. a LAN8710 ethernet phy
> +	  this option might help you out.
> +
> +	  In doubt, say N
> +

I am not sure whether compile-time option for something like this is 
appropriate. Kernel module parameter, perhaps?

Of course it'd be far better if faulty hardware can be autodetected in 
runtime.

-- 
Jiri Kosina
SUSE Labs
