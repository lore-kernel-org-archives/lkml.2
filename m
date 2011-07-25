Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab1GYIH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:07:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab1GYIHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:07:21 -0400
Date: Mon, 25 Jul 2011 11:07:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Shirley Ma <mashirle@us.ibm.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] skbuff: clear tx zero-copy flag
Message-ID: <20110725080743.GC7840@redhat.com>
References: <1310195566.25391.6.camel@localhost.localdomain>
 <20110725004200.GA25794@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725004200.GA25794@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 08:42:00AM +0800, Herbert Xu wrote:
> Shirley Ma <mashirle@us.ibm.com> wrote:
> > 
> > This patch clears tx zero-copy flag as needed.
> > 
> > Sign-off-by: Shirley Ma <xma@us.ibm.com>
> 
> I think we also need to copy and clear this flag on the splice
> read path as that takes a direct page reference.
> 
> I hope there isn't any other path that does this.
> 
> Cheers,

When there's a way for an skb to get into the
host networking stack, (e.g. when tap gains zero copy
support) we'll need to handle that.

However macvtap passes an skb directly to the
lower device, so as long as macvtap is the only user
of that interface, we are fine I think - there's
no way for an skb to get from macvtap to splice
read path I think.

Right?

> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
