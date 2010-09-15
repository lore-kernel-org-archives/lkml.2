Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0IOSA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:00:57 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2633 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab0IOSA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:00:56 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: [RFC PATCH] drivers/net/tg3.c: Raise Jumbo Frame MTU to
 9216?
From: "Michael Chan" <mchan@broadcom.com>
To: "Joe Perches" <joe@perches.com>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
        "Benjamin Li" <benli@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1284572516.10223.12.camel@Joe-Laptop>
References: <1284572516.10223.12.camel@Joe-Laptop>
Date: Wed, 15 Sep 2010 10:57:34 -0700
Message-ID: <1284573454.8929.221.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 608FD6403ES14549676-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2010-09-15 at 10:41 -0700, Joe Perches wrote:
> The TG3 apparently supports 9K frame sizes.
> 
> http://www.broadcom.com/collateral/pb/5704C-PB05-R.pdf
> 
> Is exactly 9000 a hardware limit?
> 
> Should the jumbo frame MTU be raised to 9216 or 9216
> less the size of MAC, VLAN, IP and TCP headers?

9000 has been the de facto standard, has it been changed recently?

Anyway, we've never done any testing on 9216.  As it uses up to 2 more
internal mbufs per packet, there may not be sufficient buffers inside
the chip for optimal operations.  At best, some water marks will need to
be tweaked.  The hardware statistics counters (ethtool -S) also may not
work for packets bigger than 9022 bytes.

> 
> diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
> index 9f6ffff..3727070 100644
> --- a/drivers/net/tg3.c
> +++ b/drivers/net/tg3.c
> @@ -95,7 +95,7 @@
>  /* hardware minimum and maximum for a single frame's data payload */
>  #define TG3_MIN_MTU			60
>  #define TG3_MAX_MTU(tp)	\
> -	((tp->tg3_flags & TG3_FLAG_JUMBO_CAPABLE) ? 9000 : 1500)
> +	((tp->tg3_flags & TG3_FLAG_JUMBO_CAPABLE) ? 9216 : 1500)
>  
>  /* These numbers seem to be hard coded in the NIC firmware somehow.
>   * You can't change the ring sizes, but you can change where you place
> 
> 
> 


