Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab2GBLA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:00:59 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:55949 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2GBLA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:00:58 -0400
Message-ID: <1341226856.29646.8.camel@gurkel.linbit>
Subject: Re: [RFC] [TCP 1/3] tcp: Add MSG_NEW_PACKET flag to indicate
 preferable packet boundaries
From: Andreas Gruenbacher <agruen@linbit.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 02 Jul 2012 13:00:56 +0200
In-Reply-To: <1340990157.21162.5.camel@edumazet-glaptop>
References: <1340981690.25226.3.camel@gurkel.linbit>
	 <1340982666.21162.3.camel@edumazet-glaptop>
	 <1340984335.25450.24.camel@gurkel.linbit>
	 <1340990157.21162.5.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 19:15 +0200, Eric Dumazet wrote:
> On Fri, 2012-06-29 at 17:38 +0200, Andreas Gruenbacher wrote:
> 
> > The primary use case is fast Gigabit (10 or more) Ethernet connections
> > with jumbo frames and switches that support them.  There, frames will go
> > through unchanged and you can zero-copy receive all the time.
> > 
> > Not sure how well the approach scales to other kinds of connections; it
> > may work often enough to be worth it.  When things get distorted between
> > the sender and the receiver and tcp_recvbio() fails, the data can still
> > be copied out of the socket as before.
> 
> If you have a packet loss, receiver can and will coalesce frames.

That's alright as long as we'll get "back to normal" eventually; the
only effect will be that we'll copy data out of the socket receive
buffers for a while.  There will be extremely little packet loss on the
kinds of networks that we want to use this on.

Thanks,
Andreas

