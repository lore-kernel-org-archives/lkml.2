Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0IAXbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:31:06 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:58192 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0IAXbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:31:05 -0400
Date: Thu, 2 Sep 2010 07:30:56 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, bandan.das@stratus.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
	ip_fragment
Message-ID: <20100901233056.GA15177@gondor.apana.org.au>
References: <1283204118.2405.32.camel@edumazet-laptop> <20100830232147.GB10754@stratus.com> <1283232031.2405.38.camel@edumazet-laptop> <20100901.144658.135972233.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901.144658.135972233.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 02:46:58PM -0700, David Miller wrote:
.
> Therefore I'm inclined to agree with Herbert that we need to parse the
> options explicitly before invoke ip_fragment().  We must call it with
> an SKB in the state it expects, and that means with options parsing
> already performed.

FWIW the packet probably doesn't even have IP options.  What is
happening here is that we've found yet another entry point from
the bridge driver into the IP stack so we need to duplicate my
original patch here.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
