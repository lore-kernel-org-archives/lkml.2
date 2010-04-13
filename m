Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab0DMPMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:12:54 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:37953 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751449Ab0DMPMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:12:53 -0400
Date: Tue, 13 Apr 2010 23:12:38 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
       qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] tun: orphan an skb on tx
Message-ID: <20100413151238.GA13153@gondor.apana.org.au>
References: <20100413145944.GA7716@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413145944.GA7716@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 05:59:44PM +0300, Michael S. Tsirkin wrote:
> The following situation was observed in the field:
> tap1 sends packets, tap2 does not consume them, as a result
> tap1 can not be closed. This happens because
> tun/tap devices can hang on to skbs undefinitely.
> 
> As noted by Herbert, possible solutions include a timeout followed by a
> copy/change of ownership of the skb, or always copying/changing
> ownership if we're going into a hostile device.
> 
> This patch implements the second approach.
> 
> Note: one issue still remaining is that since skbs
> keep reference to tun socket and tun socket has a
> reference to tun device, we won't flush backlog,
> instead simply waiting for all skbs to get transmitted.
> At least this is not user-triggerable, and
> this was not reported in practice, my assumption is
> other devices besides tap complete an skb
> within finite time after it has been queued.
> 
> A possible solution for the second issue
> would not to have socket reference the device,
> instead, implement dev->destructor for tun, and
> wait for all skbs to complete there, but this
> needs some thought, probably too risky for 2.6.34.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Tested-by: Yan Vugenfirer <yvugenfi@redhat.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
