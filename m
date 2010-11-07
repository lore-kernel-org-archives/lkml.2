Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab0KGGdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 01:33:40 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13686 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab0KGGdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 01:33:40 -0500
Date: Sun, 7 Nov 2010 07:22:26 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8712: remove unneeded local variable in _malloc in
 osdep_service.h header
In-Reply-To: <alpine.LNX.2.00.1011070715330.25327@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1011070721331.25327@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011070715330.25327@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010, Jesper Juhl wrote:

> Hi,
> 
> The local variable 'ret' in 

Arrgh, mixed up two mails I was composing, the above should of course have 
read "The local variable 'pbuf' in"

> drivers/staging/rtl8712/osdep_service.h::_malloc() is completely unneeded, 
> so let's remove it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
>  osdep_service.h |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> index d1674cd..a6e3f19 100644
> --- a/drivers/staging/rtl8712/osdep_service.h
> +++ b/drivers/staging/rtl8712/osdep_service.h
> @@ -196,10 +196,7 @@ static inline void sleep_schedulable(int ms)
>  
>  static inline u8 *_malloc(u32 sz)
>  {
> -	u8 *pbuf;
> -
> -	pbuf =	kmalloc(sz, GFP_ATOMIC);
> -	return pbuf;
> +	return kmalloc(sz, GFP_ATOMIC);
>  }
>  
>  static inline unsigned char _cancel_timer_ex(struct timer_list *ptimer)
> 
> 
> 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

