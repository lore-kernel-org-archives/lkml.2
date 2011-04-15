Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab1DODOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 23:14:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48755 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1DODOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 23:14:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH] make sparse happy with gfp.h
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110414234216.9E31DBD9@kernel>
References: <20110414234216.9E31DBD9@kernel>
Message-Id: <20110415121424.F7A6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 15 Apr 2011 12:14:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> diff -puN include/linux/gfp.h~make-sparse-happy-with-gfp_h include/linux/gfp.h
> --- linux-2.6.git/include/linux/gfp.h~make-sparse-happy-with-gfp_h	2011-04-14 14:47:02.629275904 -0700
> +++ linux-2.6.git-dave/include/linux/gfp.h	2011-04-14 14:47:38.813272674 -0700
> @@ -249,14 +249,9 @@ static inline enum zone_type gfp_zone(gf
>  
>  	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
>  					 ((1 << ZONES_SHIFT) - 1);
> -
> -	if (__builtin_constant_p(bit))
> -		BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> -	else {
>  #ifdef CONFIG_DEBUG_VM
> -		BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> +	BUG_ON((GFP_ZONE_BAD >> bit) & 1);
>  #endif
> -	}
>  	return z;

Why don't you use VM_BUG_ON?


