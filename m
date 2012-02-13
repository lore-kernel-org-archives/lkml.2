Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2BMJDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:03:32 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60581 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2BMJDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:03:30 -0500
Message-ID: <1329123803.2336.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: ixgbe truesize underestimation fix missing?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christian Brunner <chb@muc.de>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 13 Feb 2012 10:03:23 +0100
In-Reply-To: <CAJafhzQV821ij62y_TQr9M3jHyyDdovi0P30kidv7H8fsoqKPw@mail.gmail.com>
References: <CAJafhzQV821ij62y_TQr9M3jHyyDdovi0P30kidv7H8fsoqKPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 13 février 2012 à 09:45 +0100, Christian Brunner a écrit :
> Back in Oktober, there was a patch by Eric Dumazet for the ixgbe
> driver to fix the skb truesize underestimation (commit
> 98130646770db42cd14c44ba0d7f2d0eb8078820). It changed only one line in
> ixgbe_main.c:
> 
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -1326,7 +1326,7 @@ static bool ixgbe_clean_rx_irq(struct
> ixgbe_q_vector *q_vector,
>                         skb->len += upper_len;
>                         skb->data_len += upper_len;
> -                       skb->truesize += upper_len;
> +                       skb->truesize += PAGE_SIZE / 2;
>                 }                 i++;
> 
> 
> But when I look at the current code (3.2.5 or 3.3rc), skb->truesize is
> still increased by the same value as skb->data_len.
> 
> 1228         skb->data_len += frag_list_size;
> 1229         skb->truesize += frag_list_size;
> 
> Is it posible that there was a merge conflict, or am I missing something here?

Maybe a problem in your local tree ?

I can see proper fix in current tree.



