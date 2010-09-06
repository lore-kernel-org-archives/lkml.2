Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0IFIUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:20:07 -0400
Received: from ozlabs.org ([203.10.76.45]:56704 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0IFIUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:20:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH] no need to align .modinfo strings
Date: Mon, 6 Sep 2010 17:49:55 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: "Michal Marek" <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <4C7FB3A80200007800013F22@vpn.id2.novell.com>
In-Reply-To: <4C7FB3A80200007800013F22@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009061749.56921.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010 09:54:40 pm Jan Beulich wrote:
> Their use is not performance critical, and hence it seems better to
> save some space.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

The real question is: why is gcc aligning these?  Should it be aligning
any string literals at all?  If so, should we look for other such wastes
of space?

Thanks,
Rusty.

> --- linux-2.6.36-rc3/include/linux/moduleparam.h
> +++ 2.6.36-rc3-modinfo-align/include/linux/moduleparam.h
> @@ -21,8 +21,8 @@
>  #define __module_cat(a,b) ___module_cat(a,b)
>  #define __MODULE_INFO(tag, name, info)					  \
>  static const char __module_cat(name,__LINE__)[]				  \
> -  __used								  \
> -  __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
> +  __used __attribute__((section(".modinfo"), unused, aligned(1)))	  \
> +  = __stringify(tag) "=" info
>  #else  /* !MODULE */
>  #define __MODULE_INFO(tag, name, info)
>  #endif
> 
> 
> 
