Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab2F2PjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:39:00 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:59312 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2F2Pi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:38:58 -0400
Message-ID: <1340984335.25450.24.camel@gurkel.linbit>
Subject: Re: [RFC] [TCP 1/3] tcp: Add MSG_NEW_PACKET flag to indicate
 preferable packet boundaries
From: Andreas Gruenbacher <agruen@linbit.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 29 Jun 2012 17:38:55 +0200
In-Reply-To: <1340982666.21162.3.camel@edumazet-glaptop>
References: <1340981690.25226.3.camel@gurkel.linbit>
	 <1340982666.21162.3.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 17:11 +0200, Eric Dumazet wrote:
> On Fri, 2012-06-29 at 16:54 +0200, Andreas Gruenbacher wrote:
> > The MSG_NEW_PACKET flag indicates to sendmsg / sendpage that the message or
> > page should be put into a new packet even when there is still room left in the
> > previous packet.
> > 
> > In the tcp protocol, messages which are not sent immediately are queued.  When
> > more data is sent, it will be added to the last segment in that queue until
> > that segment is "full" whenever possible; only then is a new segment added.
> > Right now, there is no way to indicate when tcp should start a new segment.
> > The new flag allows to control that.
> > 
> > Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
> > ---
> 
> I don't understand how maintaining any message boundaries at sender can
> prevent any middlebox or the receiver to coalesce frames to any
> boundaries it prefers ?

The primary use case is fast Gigabit (10 or more) Ethernet connections
with jumbo frames and switches that support them.  There, frames will go
through unchanged and you can zero-copy receive all the time.

Not sure how well the approach scales to other kinds of connections; it
may work often enough to be worth it.  When things get distorted between
the sender and the receiver and tcp_recvbio() fails, the data can still
be copied out of the socket as before.

Andreas

