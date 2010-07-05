Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0GEUSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 16:18:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46412 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab0GEUSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 16:18:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A8yI/HwiPpCNA+U7z4GV0/mN8OADTaumuOjvFrqI8Y5oFZsuja69vZzuqYNa5stanq
         01yIxdk0A6IpwgbmuuOLkzezR20Q2ttHO/8HDimI4T4achOJnX0aQrJnh0v7d7wOoUIO
         M48iI6VamYrM7N0Iyqs61SfBM4EMvQh0hYx6k=
Subject: Re: Fwd: Possible bug in net/ipv4/route.c?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, yoshfuji@linux-ipv6.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20100705200728.GB11096@khazad-dum.debian.net>
References: <20100705120617.GA6267@gondor.apana.org.au>
	 <1278334754.2877.173.camel@edumazet-laptop>
	 <20100705132245.GA6876@gondor.apana.org.au>
	 <1278336898.2877.212.camel@edumazet-laptop>
	 <20100705200728.GB11096@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 22:18:07 +0200
Message-ID: <1278361087.2466.107.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 05 juillet 2010 à 17:07 -0300, Henrique de Moraes Holschuh a
écrit :
> On Mon, 05 Jul 2010, Eric Dumazet wrote:
> > Le lundi 05 juillet 2010 à 21:22 +0800, Herbert Xu a écrit :
> > > On Mon, Jul 05, 2010 at 02:59:14PM +0200, Eric Dumazet wrote:
> > > >
> > > > Why do we clear full 48 bytes skb->cb[] in skb_alloc(), if no protocol
> > > > stack should rely it being zero ?
> > > 
> > > Unless a protocol is allocating the skb itself, then the fact
> > > that skb_alloc clears skb->cb is no guarantee that the skb->cb
> > > will be zero.
> > 
> > I see. We could :
> > 
> > Avoid this memset(skb->cb, 0, sizeof(skb->cb)) in fastpath.
> 
> Any chances of skb->cb being leaked to userspace or the network, due to
> driver bugs or other such oddities?
> 

Not "a priori", but a bug is always possible ;)

cb[] is internal use only, should not be sent to network or user land.



