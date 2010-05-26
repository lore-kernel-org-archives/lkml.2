Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914Ab0EZBw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:52:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52485
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759151Ab0EZBw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:52:26 -0400
Date: Tue, 25 May 2010 18:52:36 -0700 (PDT)
Message-Id: <20100525.185236.193707791.davem@davemloft.net>
To: x0066660@ti.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, tony@atomide.com,
       santosh.shilimkar@ti.com
Subject: Re: NULL Pointer Deference: NFS & Telnet
From: David Miller <davem@davemloft.net>
In-Reply-To: <27F9C60D11D683428E133F85D2BB4A53043E3EDFE6@dlee03.ent.ti.com>
References: <27F9C60D11D683428E133F85D2BB4A53043E33A997@dlee03.ent.ti.com>
	<27F9C60D11D683428E133F85D2BB4A53043E3EDFE6@dlee03.ent.ti.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Arce, Abraham" <x0066660@ti.com>
Date: Tue, 25 May 2010 20:48:02 -0500

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f8abf68..eb81f76 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -334,7 +334,7 @@ static void skb_release_data(struct sk_buff *skb)
>  	if (!skb->cloned ||
>  	    !atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
>  			       &skb_shinfo(skb)->dataref)) {
> -		if (skb_shinfo(skb)->nr_frags) {
> +		if (skb_shinfo(skb)->nr_frags && skb_has_frags(skb)) {
>  			int i;
>  			for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
>  				put_page(skb_shinfo(skb)->frags[i].page);

skb_shinfo(skb)->nr_frags counts the number of entries contained
in the skb_shinfo(skb)->frags[] array.

This has nothing to do with the frag list pointer,
skb_shinfo(skb)->frag_list, which is what skb_has_frags()
tests.

You've got some kind of memory corruption going on and it
appears to have nothing to do with the code paths you're
playing with here.
