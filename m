Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1EPTf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:35:26 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:49218 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1EPTfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:35:22 -0400
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in
 netdevice
From: Ben Hutchings <bhutchings@solarflare.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1305574128.3456.23.camel@localhost.localdomain>
References: <1305574128.3456.23.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 16 May 2011 20:35:18 +0100
Message-ID: <1305574518.2885.25.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2011 19:35:21.0922 (UTC) FILETIME=[65505220:01CC1400]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18138.005
X-TM-AS-Result: No--12.856500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 12:28 -0700, Shirley Ma wrote:
> Signed-off-by: Shirley Ma <xma@us.ibm.com>
> ---
> 
>  include/linux/netdevice.h |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index a134d80..2646251 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1066,6 +1066,16 @@ struct net_device {
>  #define NETIF_F_NOCACHE_COPY	(1 << 30) /* Use no-cache copyfromuser */
>  #define NETIF_F_LOOPBACK	(1 << 31) /* Enable loopback */
>  
> +/*
> + * Bit 31 is for device to map userspace buffers -- zerocopy
> + * Device can set this flag when it supports HIGHDMA.
> + * Device can't recycle this kind of skb buffers.
> + * There are 256 bytes copied, the rest of buffers are mapped.
> + * The userspace callback should only be called when last reference to this skb
> + * is gone.
> + */
> +#define NETIF_F_ZEROCOPY	(1 << 31)

Sorry, bit 31 is taken.  You get the job of turning features into a
wider bitmap.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

