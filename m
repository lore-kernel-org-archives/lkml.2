Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1J1NUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 09:20:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50482 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1J1NUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 09:20:07 -0400
Message-ID: <4EAAABF6.50803@gmail.com>
Date: Fri, 28 Oct 2011 08:19:50 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] dt: add empty of_alias_get_id() for non-dt builds
References: <1319706448-1664-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1319706448-1664-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 04:07 AM, Nicolas Ferre wrote:
> Add function of_alias_get_id() reporting -ENOSYS
> for non-dt builds, so that drivers migrating to dt
> can save some '#ifdef CONFIG_OF'.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
> Hi Grant,
> 
> Another empty function for non-dt builds. Can we consider
> queuing it for 3.1?
> 
> Best regards,
> 
>  include/linux/of.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 92c40a1..34d8338 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -302,6 +302,11 @@ static inline struct device_node *of_parse_phandle(struct device_node *np,
>  	return NULL;
>  }
>  
> +static inline int of_alias_get_id(struct device_node *np, const char *stem)
> +{
> +	return -ENOSYS;
> +}
> +
>  #define of_match_ptr(_ptr)	NULL
>  #define of_match_node(_matches, _node)	NULL
>  #endif /* CONFIG_OF */

