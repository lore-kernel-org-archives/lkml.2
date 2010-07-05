Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0GENfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 09:35:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38750 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab0GENfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 09:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OchNXdJyRcadIceAfepYDz6X060JpjcPeSzzOwaaCp3ofK5cbekRRmPJydo+I/3lA1
         SMbBpajp/Bo85fSpF29ylkdkwcSOf/tO+CKlyTHZakT2xjkbsCYEh+S00L6luevZmk+R
         NiJfreB6MCHl+QqyugeKxqlDaL8saqpkuR1UY=
Subject: Re: Fwd: Possible bug in net/ipv4/route.c?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <20100705132245.GA6876@gondor.apana.org.au>
References: <20100705120617.GA6267@gondor.apana.org.au>
	 <1278334754.2877.173.camel@edumazet-laptop>
	 <20100705132245.GA6876@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 15:34:58 +0200
Message-ID: <1278336898.2877.212.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 05 juillet 2010 à 21:22 +0800, Herbert Xu a écrit :
> On Mon, Jul 05, 2010 at 02:59:14PM +0200, Eric Dumazet wrote:
> >
> > Why do we clear full 48 bytes skb->cb[] in skb_alloc(), if no protocol
> > stack should rely it being zero ?
> 
> Unless a protocol is allocating the skb itself, then the fact
> that skb_alloc clears skb->cb is no guarantee that the skb->cb
> will be zero.

I see. We could :

Avoid this memset(skb->cb, 0, sizeof(skb->cb)) in fastpath.

or in debug mode, poison it to trigger errors more often.

Thanks


