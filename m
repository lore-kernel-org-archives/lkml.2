Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2F2RQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:16:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41670 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2F2RQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:16:07 -0400
Subject: Re: [RFC] [TCP 1/3] tcp: Add MSG_NEW_PACKET flag to indicate
 preferable packet boundaries
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andreas Gruenbacher <agruen@linbit.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1340984335.25450.24.camel@gurkel.linbit>
References: <1340981690.25226.3.camel@gurkel.linbit>
	 <1340982666.21162.3.camel@edumazet-glaptop>
	 <1340984335.25450.24.camel@gurkel.linbit>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jun 2012 19:15:57 +0200
Message-ID: <1340990157.21162.5.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 17:38 +0200, Andreas Gruenbacher wrote:

> The primary use case is fast Gigabit (10 or more) Ethernet connections
> with jumbo frames and switches that support them.  There, frames will go
> through unchanged and you can zero-copy receive all the time.
> 
> Not sure how well the approach scales to other kinds of connections; it
> may work often enough to be worth it.  When things get distorted between
> the sender and the receiver and tcp_recvbio() fails, the data can still
> be copied out of the socket as before.

If you have a packet loss, receiver can and will coalesce frames.


