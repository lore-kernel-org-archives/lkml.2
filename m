Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab0JABQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 21:16:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54973
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706Ab0JABQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:16:55 -0400
Date: Thu, 30 Sep 2010 18:17:16 -0700 (PDT)
Message-Id: <20100930.181716.43034538.davem@davemloft.net>
To: nbowler@elliptictech.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        herbert@gondor.hengli.com.au, eric.dumazet@gmail.com
Subject: Re: Regression (ancient), bisected: TCP hangs with certain ESP6 SA.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100929142213.GA26031@elliptictech.com>
References: <20100929142213.GA26031@elliptictech.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@elliptictech.com>
Date: Wed, 29 Sep 2010 10:22:13 -0400

> b5c15fc004ac83b7ad280acbe0fd4bbed7e2c8d4 is the first bad commit
> commit b5c15fc004ac83b7ad280acbe0fd4bbed7e2c8d4
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Thu Feb 14 23:49:37 2008 -0800
> 
>     [IPV6]: Fix reversed local_df test in ip6_fragment
>     
>     I managed to reverse the local_df test when forward-porting this
>     patch so it actually makes things worse by never fragmenting at
>     all.
>     
>     Thanks to David Stevens for testing and reporting this bug.
>     
>     Bill Fink pointed out that the local_df setting is also the wrong
>     way around.
>     
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

I suspect that Herbert's change is correct, it's just that for some
reason PMTU doesn't work correctly with IPV6 for whatever reason.

That matches with your observed behavior that ping and UDP stuff
works just fine, and it's just TCP with certain ESP6 transport mode
settings.
