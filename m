Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3AJKAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:00:36 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:33506 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751114Ab3AJKAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:00:35 -0500
Message-ID: <50EE9141.6020805@linux-ipv6.org>
Date: Thu, 10 Jan 2013 19:00:33 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Organization: USAGI Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Romain KUNTZ <r.kuntz@ipflavors.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Andreas Hofmeister <andi@collax.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH 1/1] ipv6: fix the noflags test in addrconf_get_prefix_route
References: <470C14E4-2866-4C55-89A3-D6751E1587C4@ipflavors.com>
In-Reply-To: <470C14E4-2866-4C55-89A3-D6751E1587C4@ipflavors.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Romain KUNTZ wrote:
> From e7ece201c35615c44a3cfdc10ee28ad5a5878f41 Mon Sep 17 00:00:00 2001
> From: Romain Kuntz <r.kuntz@ipflavors.com>
> Date: Wed, 9 Jan 2013 15:02:26 +0100
> Subject: [PATCH 1/1] ipv6: fix the noflags test in addrconf_get_prefix_route
> 
> The tests on the flags in addrconf_get_prefix_route() does no make
> much sense: the 'noflags' parameter contains the set of flags that
> must not match with the route flags, so the test must be done
> against 'noflags', and not against 'flags'.
> 
> Signed-off-by: Romain Kuntz <r.kuntz@ipflavors.com>
> ---
>  net/ipv6/addrconf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 408cac4a..29ba4ff 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -1877,7 +1877,7 @@ static struct rt6_info *addrconf_get_prefix_route(const struct in6_addr *pfx,
>  			continue;
>  		if ((rt->rt6i_flags & flags) != flags)
>  			continue;
> -		if ((noflags != 0) && ((rt->rt6i_flags & flags) != 0))
> +		if ((rt->rt6i_flags & noflags) != 0)
>  			continue;
>  		dst_hold(&rt->dst);
>  		break;
> 

Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

--yoshfuji
