Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1DATiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:38:55 -0400
Received: from lo.gmane.org ([80.91.229.12]:42587 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab1DATiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:38:54 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] page: get_order() optimization
Date: Fri, 1 Apr 2011 21:40:16 +0200
Message-ID: <in59jj$ue6$1@dough.gmane.org>
References: <1301685493-2567-1-git-send-email-mcsim.planeta@gmail.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: aorleans-552-1-47-30.w90-20.abo.wanadoo.fr
X-MSMail-Priority: Normal
X-Newsreader: Microsoft Outlook Express 6.00.2800.2001
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.2001
X-Antivirus: avast! (VPS 110401-1, 01/04/2011), Outbound message
X-Antivirus-Status: Clean
Cc: kernel-janitors@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

why not have something like :
> + order = 0;
> + if (size != 0)
> + order = (__builtin_clzl(size) ^ (BITS_PER_LONG - 1));

we avoid the "complex" computation when not necessary.
No ?

Best regards,
Christophe JAILLET

"Maksym Planeta" <mcsim.planeta@gmail.com> a écrit dans le message de
news:1301685493-2567-1-git-send-email-mcsim.planeta@gmail.com...
> Loop was repalaced with __builtin_clz(). This still allows to precompute
> constants, but on some architectures it uses special instruction to
> calculate order.
>
> Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>
> ---
>  include/asm-generic/getorder.h |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/include/asm-generic/getorder.h
b/include/asm-generic/getorder.h
> index 67e7245..fe8020c 100644
> --- a/include/asm-generic/getorder.h
> +++ b/include/asm-generic/getorder.h
> @@ -11,11 +11,9 @@ static inline __attribute_const__ int
get_order(unsigned long size)
>   int order;
>
>   size = (size - 1) >> (PAGE_SHIFT - 1);
> - order = -1;
> - do {
> - size >>= 1;
> - order++;
> - } while (size);
> + order = (__builtin_clzl(size) ^ (BITS_PER_LONG - 1));
> + if (size == 0)
> + order = 0;
>   return order;
>  }
>
> -- 
> 1.7.2.3
>



