Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0DLKjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 06:39:08 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50940 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab0DLKjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 06:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NoKe6GHqn/AUBsBag/nhyoKCLGAQ86KSnbqFpJeKFYRwe55IFeN0L+9Pa6WOFG/N+T
         X6Zrde1MDbmuYMn7nQErwTcvueDuDkHUpZp3YOw+VtGj9+oTvSwzoCqNR/DxeFkH7y+J
         xLzXGHd781JlU+vSWdeI3wXpm1yoUvjGSStdc=
Subject: Re: [v3 Patch 2/3] bridge: make bridge support netpoll
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, Andy Gospodarek <gospo@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Jeff Moyer <jmoyer@redhat.com>,
       Matt Mackall <mpm@selenic.com>, bonding-devel@lists.sourceforge.net,
       Jay Vosburgh <fubar@us.ibm.com>, David Miller <davem@davemloft.net>
In-Reply-To: <4BC2F7E2.7020309@redhat.com>
References: <20100408062234.4499.17042.sendpatchset@localhost.localdomain>
	 <20100408062246.4499.5670.sendpatchset@localhost.localdomain>
	 <20100408083710.2b61ee44@nehalam>  <4BC2F7E2.7020309@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 12:38:57 +0200
Message-ID: <1271068737.16881.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 avril 2010 à 18:37 +0800, Cong Wang a écrit :
> Stephen Hemminger wrote:
> > There is no protection on dev->priv_flags for SMP access.
> > It would better bit value in dev->state if you are using it as control flag.
> > 
> > Then you could use 
> > 			if (unlikely(test_and_clear_bit(__IN_NETPOLL, &skb->dev->state)))
> > 				netpoll_send_skb(...)
> > 
> > 
> 
> Hmm, I think we can't use ->state here, it is not for this kind of purpose,
> according to its comments.
> 
> Also, I find other usages of IFF_XXX flags of ->priv_flags are also using
> &, | to set or clear the flags. So there must be some other things preventing
> the race...

Yes, its RTNL that protects priv_flags changes, hopefully...


