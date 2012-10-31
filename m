Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935916Ab2JaSSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:18:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48093 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935896Ab2JaSSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:18:00 -0400
Date: Wed, 31 Oct 2012 14:16:18 -0400 (EDT)
Message-Id: <20121031.141618.286962451107179252.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxk@qualcomm.com, edumazet@google.com, krkumar2@in.ibm.com,
        ernesto.martin@viasat.com, haixiao@juniper.net
Subject: Re: [net-next resend v4 5/7] tuntap: multiqueue support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351491351-11477-6-git-send-email-jasowang@redhat.com>
References: <1351491351-11477-1-git-send-email-jasowang@redhat.com>
	<1351491351-11477-6-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 29 Oct 2012 14:15:49 +0800

> @@ -110,6 +110,11 @@ struct tap_filter {
>  	unsigned char	addr[FLT_EXACT_COUNT][ETH_ALEN];
>  };
>  
> +/* 1024 is probably a high enough limit: modern hypervisors seem to support on
> + * the order of 100-200 CPUs so this leaves us some breathing space if we want
> + * to match a queue per guest CPU. */

Please don't format comments like this.  Put that final "*/" on it's
own line.

I'm really perplexed how you can get it right elsewhere in your
patches, and then botch it up only in a few select locations :-/

> +/* We try to identify a flow through its rxhash first. The reason that
> + * we do not check rxq no. is becuase some cards(e.g 82599), chooses
> + * the rxq based on the txq where the last packet of the flow comes. As
> + * the userspace application move between processors, we may get a
> + * different rxq no. here. If we could not get rxhash, then we would
> + * hope the rxq no. may help here.
> + */

For example, this one is done right.
