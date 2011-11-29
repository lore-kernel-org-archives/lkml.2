Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1K2UKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:10:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260Ab1K2UKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:10:03 -0500
From: Paul Moore <pmoore@redhat.com>
To: netdev@vger.kernel.org
Cc: rdunlap@xenotime.net, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlabel: Fix build problems when IPv6 is not enabled
Date: Tue, 29 Nov 2011 15:09:54 -0500
Message-ID: <6332789.nzDA7IAKHR@sifl>
Organization: Red Hat
User-Agent: KMail/4.7.3 (Linux/3.0.9-gentoo; KDE/4.7.3; x86_64; ; )
In-Reply-To: <20111129200818.19875.72359.stgit@sifl>
References: <20111129200818.19875.72359.stgit@sifl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 29, 2011 03:08:18 PM Paul Moore wrote:
> A recent fix to the the NetLabel code caused build problem with
> configurations that did not have IPv6 enabled; see below:
> 
>  netlabel_kapi.c: In function 'netlbl_cfg_unlbl_map_add':
>  netlabel_kapi.c:165:4:
>   error: implicit declaration of function 'netlbl_af6list_add'
> 
> This patch fixes this problem by making the IPv6 specific code conditional
> on the IPv6 configuration flags as we done in the rest of NetLabel and the
> network stack as a whole.  We have to move some variable declarations
> around as a result so things may not be quite as pretty, but at least it
> builds cleanly now.
> 
> Some additional IPv6 conditionals were added to the NetLabel code as well
> for the sake of consistency.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Paul Moore <pmoore@redhat.com>
> ---
>  net/netlabel/netlabel_kapi.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Sorry, please disregard this patch; I sent the wrong version.

> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
> index 3735297..e4bbe94 100644
> --- a/net/netlabel/netlabel_kapi.c
> +++ b/net/netlabel/netlabel_kapi.c
> @@ -148,6 +148,7 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
>  			if (ret_val != 0)
>  				goto cfg_unlbl_map_add_failure;
>  			break;
> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
>  		case AF_INET6:
>  			addr6 = addr;
>  			mask6 = mask;
> @@ -167,6 +168,7 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
>  			if (ret_val != 0)
>  				goto cfg_unlbl_map_add_failure;
>  			break;
> +#endif /* IPv6 */
>  		default:
>  			goto cfg_unlbl_map_add_failure;
>  			break;
> @@ -225,9 +227,11 @@ int netlbl_cfg_unlbl_static_add(struct net *net,
>  	case AF_INET:
>  		addr_len = sizeof(struct in_addr);
>  		break;
> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
>  	case AF_INET6:
>  		addr_len = sizeof(struct in6_addr);
>  		break;
> +#endif /* IPv6 */
>  	default:
>  		return -EPFNOSUPPORT;
>  	}
> @@ -266,9 +270,11 @@ int netlbl_cfg_unlbl_static_del(struct net *net,
>  	case AF_INET:
>  		addr_len = sizeof(struct in_addr);
>  		break;
> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
>  	case AF_INET6:
>  		addr_len = sizeof(struct in6_addr);
>  		break;
> +#endif /* IPv6 */
>  	default:
>  		return -EPFNOSUPPORT;
>  	}
-- 
paul moore
virtualization @ redhat

