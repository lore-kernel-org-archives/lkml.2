Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1FNPsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:48:22 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:30150 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1FNPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:48:18 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next 1/2] net: Remove casts of void *
Date: Tue, 14 Jun 2011 11:48:13 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r5; KDE/4.6.4; x86_64; ; )
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>, Sage Weil <sage@newdream.net>,
        Samuel Ortiz <samuel@sortiz.org>,
        Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
        linux-sctp@vger.kernel.org
References: <cover.1308017857.git.joe@perches.com> <d010144f11f9165670ac0c9e3559bf5e3191ff28.1308017857.git.joe@perches.com>
In-Reply-To: <d010144f11f9165670ac0c9e3559bf5e3191ff28.1308017857.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106141148.13867.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 13, 2011 10:21:26 PM Joe Perches wrote:
> Unnecessary casts of void * clutter the code.
> 
> These are the remainder casts after several specific
> patches to remove netdev_priv and dev_priv.
> 
> Done via coccinelle script:
> 
> $ cat cast_void_pointer.cocci
> @@
> type T;
> T *pt;
> void *pv;
> @@
> 
> - pt = (T *)pv;
> + pt = pv;
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I can't speak for everyone else, but I have no objections to the NetLabel 
changes.

Acked-by: Paul Moore <paul.moore@hp.com>

> diff --git a/net/netlabel/netlabel_unlabeled.c
> b/net/netlabel/netlabel_unlabeled.c index 9c38658..8efd061 100644
> --- a/net/netlabel/netlabel_unlabeled.c
> +++ b/net/netlabel/netlabel_unlabeled.c
> @@ -426,10 +426,9 @@ int netlbl_unlhsh_add(struct net *net,
>  					      audit_info);
>  	switch (addr_len) {
>  	case sizeof(struct in_addr): {
> -		struct in_addr *addr4, *mask4;
> +		const struct in_addr *addr4 = addr;
> +		const struct in_addr *mask4 = mask;
> 
> -		addr4 = (struct in_addr *)addr;
> -		mask4 = (struct in_addr *)mask;
>  		ret_val = netlbl_unlhsh_add_addr4(iface, addr4, mask4, secid);
>  		if (audit_buf != NULL)
>  			netlbl_af4list_audit_addr(audit_buf, 1,
> @@ -440,10 +439,9 @@ int netlbl_unlhsh_add(struct net *net,
>  	}
>  #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
>  	case sizeof(struct in6_addr): {
> -		struct in6_addr *addr6, *mask6;
> +		const struct in6_addr *addr6 = addr;
> +		const struct in6_addr *mask6 = mask;
> 
> -		addr6 = (struct in6_addr *)addr;
> -		mask6 = (struct in6_addr *)mask;
>  		ret_val = netlbl_unlhsh_add_addr6(iface, addr6, mask6, secid);
>  		if (audit_buf != NULL)
>  			netlbl_af6list_audit_addr(audit_buf, 1,

--
paul moore
linux @ hp
