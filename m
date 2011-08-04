Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1HDGo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:44:56 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:53436 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1HDGot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:44:49 -0400
Date: Thu, 4 Aug 2011 14:44:36 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mathias Krause <minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation
	for x86-64
Message-ID: <20110804064436.GA16247@gondor.apana.org.au>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com> <1311529994-7924-3-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311529994-7924-3-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 07:53:14PM +0200, Mathias Krause wrote:
>
> With this algorithm I was able to increase the throughput of a single
> IPsec link from 344 Mbit/s to 464 Mbit/s on a Core 2 Quad CPU using
> the SSSE3 variant -- a speedup of +34.8%.

Were you testing this on the transmit side or the receive side?

As the IPsec receive code path usually runs in a softirq context,
does this code have any effect there at all?

This is pretty similar to the situation with the Intel AES code.
Over there they solved it by using the asynchronous interface and
deferring the processing to a work queue.

This also avoids the situation where you have an FPU/SSE using
process that also tries to transmit over IPsec thrashing the
FPU state.

Now I'm still happy to take this because hashing is very different
from ciphers in that some users tend to hash small amounts of data
all the time.  Those users will typically use the shash interface
that you provide here.

So I'm interested to know how much of an improvement this is for
those users (< 64 bytes).  If you run the tcrypt speed tests that
should provide some useful info.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
