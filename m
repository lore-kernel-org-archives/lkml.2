Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2JQMhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:37:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab2JQMhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:37:24 -0400
Date: Wed, 17 Oct 2012 14:37:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove untouched code in kfifo_in
In-Reply-To: <1350463837-30244-1-git-send-email-weiyang@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1210171434360.17129@pobox.suse.cz>
References: <1350463837-30244-1-git-send-email-weiyang@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Wei Yang wrote:

> In kfifo_in marco, one piece of code is arounded by if(0).
> 
> This patch just remove this code.
> ---
>  include/linux/kfifo.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> index 10308c6..e7015bb 100644
> --- a/include/linux/kfifo.h
> +++ b/include/linux/kfifo.h
> @@ -512,10 +512,6 @@ __kfifo_uint_must_check_helper( \
>  	unsigned long __n = (n); \
>  	const size_t __recsize = sizeof(*__tmp->rectype); \
>  	struct __kfifo *__kfifo = &__tmp->kfifo; \
> -	if (0) { \
> -		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
> -		__dummy = (typeof(__buf))NULL; \
> -	} \
>  	(__recsize) ?\
>  	__kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
>  	__kfifo_in(__kfifo, __buf, __n); \

Frankly, I'd first like to understand what was the rationale for adding it 
at the first place. Adding Stefani and lkml to CC.

-- 
Jiri Kosina
SUSE Labs
