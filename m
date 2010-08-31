Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0HaJR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:17:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59006 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0HaJR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BNeOvw8bPQcVFmQGfZ/yCiW86KYYpB1clL8o4NQpgMgts3r5Fev5El/LnmGAS7pmMc
         +OicYpA3315KVD0zmJ8NgVnk+G/d6pyJ9ffu/eUul9kLgRno+r7+E8E9OBjNzylVUb73
         jEIp/tupM5sNWcnuDZD5Z2/aeHx74BBOVIIyI=
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
 ip_fragment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Bandan Das <bandan.das@stratus.com>, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <20100831082444.GB29281@gondor.apana.org.au>
References: <20100830200917.GA10754@stratus.com>
	 <1283204118.2405.32.camel@edumazet-laptop>
	 <20100830232147.GB10754@stratus.com>
	 <1283232031.2405.38.camel@edumazet-laptop>
	 <20100831082444.GB29281@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 11:17:51 +0200
Message-ID: <1283246271.2550.35.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 31 août 2010 à 16:24 +0800, Herbert Xu a écrit :
> On Tue, Aug 31, 2010 at 07:20:31AM +0200, Eric Dumazet wrote:
> > Le lundi 30 août 2010 à 19:21 -0400, Bandan Das a écrit :
> > > > 
> > > > I wonder if we want this.
> > > > 
> > > > Maybe setting skb->local_df = 1 in bridge should be enough ?
> > > > 
> > > > 
> > > Thanks Eric for looking at this. Indeed, setting local_df to 1 seems to be enough! I will
> > > respin and post a different patch.
> > > 
> > 
> > Reading this stuff again, I wonder if we should not revert commit
> > 17762060c25590bfddd  and use a different trick
> 
> I don't quite understand the problem.  Does the packet actually
> have IP options? If not why is it trying to look at IP options?
> 
> If it does have options, then we should parse options in the
> bridge driver before passing it to the IP stack (or just drop
> the packet).

Once again, the IP stack -> bridge -> IP stack flow bites us,
because bridge likes to dirty IPCB.

We can correct every bug we find once in a while (you did in commit
17762060c255 for a particular bug), or just make bridge not touch IPCB.



