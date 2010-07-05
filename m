Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0GEUHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 16:07:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58960 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061Ab0GEUHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 16:07:31 -0400
X-Sasl-enc: UhSR593pHa1siCgrMnzBoE2aL79MuNJfiMh9QieTKPoH 1278360450
Date: Mon, 5 Jul 2010 17:07:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, yoshfuji@linux-ipv6.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Fwd: Possible bug in net/ipv4/route.c?
Message-ID: <20100705200728.GB11096@khazad-dum.debian.net>
References: <20100705120617.GA6267@gondor.apana.org.au> <1278334754.2877.173.camel@edumazet-laptop> <20100705132245.GA6876@gondor.apana.org.au> <1278336898.2877.212.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1278336898.2877.212.camel@edumazet-laptop>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jul 2010, Eric Dumazet wrote:
> Le lundi 05 juillet 2010 à 21:22 +0800, Herbert Xu a écrit :
> > On Mon, Jul 05, 2010 at 02:59:14PM +0200, Eric Dumazet wrote:
> > >
> > > Why do we clear full 48 bytes skb->cb[] in skb_alloc(), if no protocol
> > > stack should rely it being zero ?
> > 
> > Unless a protocol is allocating the skb itself, then the fact
> > that skb_alloc clears skb->cb is no guarantee that the skb->cb
> > will be zero.
> 
> I see. We could :
> 
> Avoid this memset(skb->cb, 0, sizeof(skb->cb)) in fastpath.

Any chances of skb->cb being leaked to userspace or the network, due to
driver bugs or other such oddities?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
