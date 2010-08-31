Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab0HaMgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:36:55 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:48958 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab0HaMgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:36:54 -0400
Date: Tue, 31 Aug 2010 20:36:41 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Bandan Das <bandan.das@stratus.com>, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
	ip_fragment
Message-ID: <20100831123641.GA31017@gondor.apana.org.au>
References: <20100830200917.GA10754@stratus.com> <1283204118.2405.32.camel@edumazet-laptop> <20100830232147.GB10754@stratus.com> <1283232031.2405.38.camel@edumazet-laptop> <20100831082444.GB29281@gondor.apana.org.au> <1283246271.2550.35.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283246271.2550.35.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 11:17:51AM +0200, Eric Dumazet wrote:
>
> Once again, the IP stack -> bridge -> IP stack flow bites us,
> because bridge likes to dirty IPCB.

OK, so we're talking about a locally transmitted packet, with
IP options leaving the IP stack, entering bridging, and then
reentering the IP stack?

In that case the packet should no longer be treated as an IP
packet when it enters the bridge.  So if it did have options
and we want to support that in bridging then we need to parse
IP options there as my comment suggested.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
