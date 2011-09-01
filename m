Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab1IAPlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:41:15 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:19543 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab1IAPlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:41:14 -0400
Subject: Re: [PATCH] dev_ioctl should return -EINVAL for unknown ioctl
 instead of -ENOTTY
From: Ben Hutchings <bhutchings@solarflare.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E5F9C14.1040108@gmail.com>
References: <4E5F9C14.1040108@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 01 Sep 2011 16:41:10 +0100
Message-ID: <1314891670.2733.12.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2011 15:41:13.0507 (UTC) FILETIME=[946B4F30:01CC68BD]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18358.005
X-TM-AS-Result: No--10.704400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 22:52 +0800, Wang Sheng-Hui wrote:
> The patch is against 3.1-rc3.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  net/core/dev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 17d67b5..de6033c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5092,7 +5092,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
>  		/* Take care of Wireless Extensions */
>  		if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST)
>  			return wext_handle_ioctl(net, &ifr, cmd, arg);
> -		return -ENOTTY;
> +		return -EINVAL;
>  	}
>  }
>  

Whereas, Linus Torvalds wrote in
<BANLkTin=PTbTwBR2s+owMLy+GmKigeoYvg@mail.gmail.com>:
[...]
> The correct error code for "I don't understand this ioctl" is ENOTTY.
> The naming may be odd, but you should think of that error value as a
> "unrecognized ioctl number, you're feeding me random numbers that I
> don't understand and I assume for historical reasons that you tried to
> do some tty operation on me".
[...]

(Not that we are consistent about using ENOTTY in networking now.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

