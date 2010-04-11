Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab0DKMEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 08:04:13 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:40797 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751031Ab0DKMEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 08:04:12 -0400
Date: Sun, 11 Apr 2010 20:04:03 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: davem@davemloft.net, yinghai@kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: ssh server etc doesn't work anymore with net-2.6
Message-ID: <20100411120403.GA20565@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100411100902.GA20141@gondor.apana.org.au>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> After looking at the actual net-2.6 tree I see that it is actually
> CHECKSUM_PARTIAL that caused this breakage.
> 
> The fact that when this was first implemented we didn't use hw
> checksums on dataless packets might not have been an oversight
> after all.

Looks like I was too quick to blame the hardware, the synack
code can't handle CHECKSUM_PARTIAL so this is probably the real
cause.

I will send patches to fix this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
