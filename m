Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab0JAJ21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:28:27 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:48194 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0JAJ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:28:26 -0400
Date: Fri, 1 Oct 2010 18:28:14 +0900
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: nbowler@elliptictech.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: Regression (ancient), bisected: TCP hangs with certain ESP6 SA.
Message-ID: <20101001092814.GA26722@gondor.apana.org.au>
References: <20100929142213.GA26031@elliptictech.com> <20100930.181716.43034538.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930.181716.43034538.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 06:17:16PM -0700, David Miller wrote:
> From: Nick Bowler <nbowler@elliptictech.com>
> Date: Wed, 29 Sep 2010 10:22:13 -0400
> 
> > b5c15fc004ac83b7ad280acbe0fd4bbed7e2c8d4 is the first bad commit
> > commit b5c15fc004ac83b7ad280acbe0fd4bbed7e2c8d4
> > Author: Herbert Xu <herbert@gondor.apana.org.au>
> > Date:   Thu Feb 14 23:49:37 2008 -0800
> > 
> >     [IPV6]: Fix reversed local_df test in ip6_fragment
> >     
> >     I managed to reverse the local_df test when forward-porting this
> >     patch so it actually makes things worse by never fragmenting at
> >     all.
> >     
> >     Thanks to David Stevens for testing and reporting this bug.
> >     
> >     Bill Fink pointed out that the local_df setting is also the wrong
> >     way around.
> >     
> >     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> I suspect that Herbert's change is correct, it's just that for some
> reason PMTU doesn't work correctly with IPV6 for whatever reason.
> 
> That matches with your observed behavior that ping and UDP stuff
> works just fine, and it's just TCP with certain ESP6 transport mode
> settings.

Yeah I suspect if you go back even further (before the patch with
the reversed logic referred to above) that you'll find it to be
broken again.

I'll try to reproduce this but I may not be able to get to it until
November.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
