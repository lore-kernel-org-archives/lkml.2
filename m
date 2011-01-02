Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1ABWyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 17:54:20 -0500
Received: from www84.your-server.de ([213.133.104.84]:49458 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1ABWyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 17:54:19 -0500
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, shemminger@vyatta.com,
        jj@chaosbits.net, daniel.baluta@gmail.com, jochen@jochen.org
In-Reply-To: <1294008562.2535.263.camel@edumazet-laptop>
References: <1294007971-18878-1-git-send-email-stefani@seibold.net>
	 <1294008562.2535.263.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 02 Jan 2011 23:55:17 +0100
Message-ID: <1294008917.18963.3.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 02.01.2011, 23:49 +0100 schrieb Eric Dumazet:
> Le dimanche 02 janvier 2011 à 23:39 +0100, stefani@seibold.net a écrit :
> > +
> > +/*
> > + * Create a new destination descriptor for the given IPV4 address and port
> > + */
> > +static struct udpcp_dest *new_dest(struct sock *sk, __be32 addr, __be16 port)
> > +{
> > +	struct udpcp_dest *dest;
> > +	struct udpcp_sock *usk = udpcp_sk(sk);
> > +
> > +	if (usk->connections >= udpcp_max_connections)
> > +		return NULL;
> > +
> > +	dest = kzalloc(sizeof(*dest), sk->sk_allocation);
> > +
> > +	if (dest) {
> > +		usk->connections++;
> > +		skb_queue_head_init(&dest->xmit);
> > +		dest->addr = addr;
> > +		dest->port = port;
> > +		dest->ackmode = UDPCP_ACK;
> > +		list_add_tail(&dest->list, &usk->destlist);
> > +	}
> > +
> > +	return dest;
> > +}
> > +
> 
> Hmm, so 'connections' is increased, never decreased.
> 
> This seems a fatal flaw in this protocol, since a malicious user can
> easily fill the list with garbage, and block regular communications.

You are right, there is now way to detect which connection is no longer
needed. I have not designed this protocol, so i cannot fix it. 

But in our environment this will be used together with an firewall
and/or ipsec. In this case it it safe.


