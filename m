Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1GYIlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:41:16 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:59767 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1GYIlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:41:09 -0400
Date: Mon, 25 Jul 2011 16:40:57 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Shirley Ma <mashirle@us.ibm.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] skbuff: clear tx zero-copy flag
Message-ID: <20110725084057.GA30311@gondor.apana.org.au>
References: <1310195566.25391.6.camel@localhost.localdomain> <20110725004200.GA25794@gondor.apana.org.au> <20110725080743.GC7840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725080743.GC7840@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 11:07:43AM +0300, Michael S. Tsirkin wrote:
>
> However macvtap passes an skb directly to the
> lower device, so as long as macvtap is the only user
> of that interface, we are fine I think - there's
> no way for an skb to get from macvtap to splice
> read path I think.
> 
> Right?

Yes, as long as you can guarantee that the skb never loops back
then you should be fine.

However, does macvtap really bypass everything, including the
qdisc layer? The qdisc layer is certainly capable of looping
the skb back with the redirect action.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
