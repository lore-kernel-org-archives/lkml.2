Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934899Ab0EEQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:27:16 -0400
Received: from kroah.org ([198.145.64.141]:51181 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934813Ab0EEQ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:27:13 -0400
Date: Wed, 5 May 2010 09:18:56 -0700
From: Greg KH <greg@kroah.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, gregkh@suse.de
Subject: Re: [PATCH] Staging: Check kmalloc return value before use the
 buffer in ieee80211_softmac.c
Message-ID: <20100505161856.GA8708@kroah.com>
References: <20100505065652.GB7495@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505065652.GB7495@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 02:56:52PM +0800, wzt.wzt@gmail.com wrote:
> Check kmalloc return value before use the buffer.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
> 
> ---
>  .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
> index 27d9257..8718ac9 100644
> --- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
> +++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
> @@ -1579,6 +1579,8 @@ static inline u16 auth_parse(struct sk_buff *skb, u8** challenge, int *chlen)
>  		if(*(t++) == MFIE_TYPE_CHALLENGE){
>  			*chlen = *(t++);
>  			*challenge = (u8*)kmalloc(*chlen, GFP_ATOMIC);
> +			if (!*challenge)
> +				return -ENOMEM;

Great catch!

thanks for the patch, now queued up.

greg k-h
