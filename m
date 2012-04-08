Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab2DHXuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:50:06 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:60030 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756347Ab2DHXuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:50:05 -0400
Date: Mon, 9 Apr 2012 07:49:51 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jason Wang <jasowang@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Jiri Pirko <jpirko@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] net: orphan queued skbs if device tx can stall
Message-ID: <20120408234951.GA15993@gondor.apana.org.au>
References: <20120408171323.GA16012@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120408171323.GA16012@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2012 at 08:13:25PM +0300, Michael S. Tsirkin wrote:
> commit 0110d6f22f392f976e84ab49da1b42f85b64a3c5
> tun: orphan an skb on tx
> Fixed a configuration where skbs get queued
> at the tun device forever, blocking senders.
> 
> However this fix isn't waterproof:
> userspace can control whether the interface
> is stopped, and if it is, packets
> get queued in the qdisc, again potentially forever.
> 
> Complete the fix by setting a private flag and orphaning
> at the qdisc level.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

1) Doesn't this break local UDP push-back?
2) Isn't the stall a bug in the backend and isn't this just
papering over that?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
