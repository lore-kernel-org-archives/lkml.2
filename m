Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0JAHOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:14:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40531
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755591Ab0JAHOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:14:19 -0400
Date: Fri, 01 Oct 2010 00:14:39 -0700 (PDT)
Message-Id: <20101001.001439.85411154.davem@davemloft.net>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
Subject: Re: [PATCH v12 06/17] Use callback to deal with skb_release_data()
 specially.
From: David Miller <davem@davemloft.net>
In-Reply-To: <f2bf65a8a7676bbd3e8a749ae93d99e88671d35d.1285853725.git.xiaohui.xin@intel.com>
References: <1285855474-12110-1-git-send-email-xiaohui.xin@intel.com>
	<59d8a50047ee01e26658fd676d26c0162b79e5fd.1285853725.git.xiaohui.xin@intel.com>
	<f2bf65a8a7676bbd3e8a749ae93d99e88671d35d.1285853725.git.xiaohui.xin@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiaohui.xin@intel.com
Date: Thu, 30 Sep 2010 22:04:23 +0800

> @@ -197,10 +197,11 @@ struct skb_shared_info {
>  	union skb_shared_tx tx_flags;
>  	struct sk_buff	*frag_list;
>  	struct skb_shared_hwtstamps hwtstamps;
> -	skb_frag_t	frags[MAX_SKB_FRAGS];
>  	/* Intermediate layers must ensure that destructor_arg
>  	 * remains valid until skb destructor */
>  	void *		destructor_arg;
> +
> +	skb_frag_t	frags[MAX_SKB_FRAGS];
>  };
>  
>  /* The structure is for a skb which pages may point to

Why are you moving frags[] to the end like this?
