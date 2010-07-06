Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0GFA2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:28:22 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:59073 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0GFA2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:28:20 -0400
Date: Tue, 6 Jul 2010 08:28:13 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Sol Kavy <skavy@ubicom.com>, linux-kernel@vger.kernel.org, gren@ubicom.com,
       gjin@ubicom.com, msezgin@ubicom.com, silgen@ubicom.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: Possible bug in net/ipv4/route.c?
Message-ID: <20100706002813.GA11194@gondor.apana.org.au>
References: <CB2DD11991B27C4F99935E6229450D3205B28E91@STORK.scenix.com> <20100705120413.GA6219@gondor.apana.org.au> <20100705110328.65702fc1@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705110328.65702fc1@nehalam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 11:03:28AM -0700, Stephen Hemminger wrote:
>
> The problem is that br_dev_xmit is looking at flags in the CB[] that
> are uninitialized.
> 
> if br_dev_xmit cleared the CB at [A] the mrouters_only would always be zero
> at [B].
> 
> Where should the mrouters and igmp_only fields in skb be initialized?

They are initialised in br_multicast_rcv.

Anyway, this isn't the problem here.  The problem is that before
bridge netfilter passes a packet through IPv4 through ARP, it must
ensure that the cb used by IPv4 is cleared.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
