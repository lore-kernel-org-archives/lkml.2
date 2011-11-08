Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1KHTwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:52:04 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27135 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1KHTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:52:01 -0500
Date: Tue, 8 Nov 2011 20:57:27 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Andrei Warkentin <andreiw@vmware.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
In-Reply-To: <1320779295-17111-1-git-send-email-andreiw@vmware.com>
Message-ID: <alpine.LNX.2.00.1111082056510.5763@swampdragon.chaosbits.net>
References: <1320779295-17111-1-git-send-email-andreiw@vmware.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011, Andrei Warkentin wrote:

> 1 is a power of two, therefore rounddown_pow_of_two(1) should return 1. It does
> in case the argument is a variable but in case it's a constant it behaves
> wrong and returns 0. Probably nobody ever did it so this was never noticed,
> however net/drivers/vmxnet3 with latest GCC does and breaks on unicpu systems.
> 
> Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
> ---
>  include/linux/log2.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index 25b8086..ccda848 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -185,7 +185,7 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
>  #define rounddown_pow_of_two(n)			\
>  (						\
>  	__builtin_constant_p(n) ? (		\
> -		(n == 1) ? 0 :			\
> +		(n == 1) ? 1 :			\
>  		(1UL << ilog2(n))) :		\
>  	__rounddown_pow_of_two(n)		\
>   )
> 

For what it's worth; looks good to me.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

