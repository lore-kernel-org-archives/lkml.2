Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0HaIY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:24:57 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:36736 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0HaIYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:24:55 -0400
Date: Tue, 31 Aug 2010 16:24:44 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Bandan Das <bandan.das@stratus.com>, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
	ip_fragment
Message-ID: <20100831082444.GB29281@gondor.apana.org.au>
References: <20100830200917.GA10754@stratus.com> <1283204118.2405.32.camel@edumazet-laptop> <20100830232147.GB10754@stratus.com> <1283232031.2405.38.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1283232031.2405.38.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 07:20:31AM +0200, Eric Dumazet wrote:
> Le lundi 30 août 2010 à 19:21 -0400, Bandan Das a écrit :
> > > 
> > > I wonder if we want this.
> > > 
> > > Maybe setting skb->local_df = 1 in bridge should be enough ?
> > > 
> > > 
> > Thanks Eric for looking at this. Indeed, setting local_df to 1 seems to be enough! I will
> > respin and post a different patch.
> > 
> 
> Reading this stuff again, I wonder if we should not revert commit
> 17762060c25590bfddd  and use a different trick

I don't quite understand the problem.  Does the packet actually
have IP options? If not why is it trying to look at IP options?

If it does have options, then we should parse options in the
bridge driver before passing it to the IP stack (or just drop
the packet).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
