Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0EAQSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 12:18:15 -0400
Received: from stinky.trash.net ([213.144.137.162]:47408 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0EAQSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 12:18:12 -0400
Message-ID: <4BDC543F.7060500@trash.net>
Date: Sat, 01 May 2010 18:18:07 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
       Wensong Zhang <wensong@linux-vs.org>,
       Julius Volz <julius.volz@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, Hannes Eder <heder@google.com>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [patch v2.2 1/4] [PATCH v2.1 1/4] netfilter: xt_ipvs (netfilter
 matcher for IPVS)
References: <20100501032014.406353538@vergenet.net> <20100501032120.298829234@vergenet.net>
In-Reply-To: <20100501032120.298829234@vergenet.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:

> @@ -0,0 +1,25 @@
> +#ifndef _XT_IPVS_H
> +#define _XT_IPVS_H 1

You don't need to define a value.

> +config NETFILTER_XT_MATCH_IPVS
> +	tristate '"ipvs" match support'
> +	depends on IP_VS
> +	depends on NETFILTER_ADVANCED
> +	help
> +	  This option allows you to match against IPVS properties of a packet.
> +
> +	  If unsure, say N.

You're using conntrack symbols, so this seems to need a dependency
on NF_CONNTRACK.

> +static bool ipvs_mt_check(const struct xt_mtchk_param *par)

We've changed the signature to "int" in nf-next to be able to
return errno codes. Please rebase your patches onto nf-next-2.6.git.

Please also CC netfilter-devel at least for those parts that affect
non-IPVS netfilter.

> +{
> +	if (par->family != NFPROTO_IPV4
> +#ifdef CONFIG_IP_VS_IPV6
> +	    && par->family != NFPROTO_IPV6
> +#endif
> +		) {
> +		pr_info("protocol family %u not supported\n", par->family);
> +		return false;
> +	}
> +
> +	return true;
> +}

