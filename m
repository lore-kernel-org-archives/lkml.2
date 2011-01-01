Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1AAV1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 16:27:45 -0500
Received: from www84.your-server.de ([213.133.104.84]:51403 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1AAV1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 16:27:44 -0500
Subject: Re: [PATCH] UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <1293796805.2973.62.camel@edumazet-laptop>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
	 <1293794758.2973.49.camel@edumazet-laptop>
	 <1293796805.2973.62.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 01 Jan 2011 22:28:45 +0100
Message-ID: <1293917325.28510.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 31.12.2010, 13:00 +0100 schrieb Eric Dumazet:
> Le vendredi 31 décembre 2010 à 12:25 +0100, Eric Dumazet a écrit :
> > Le vendredi 31 décembre 2010 à 10:29 +0100, stefani@seibold.net a
> > écrit :
> > > +		if (!list_empty(&usk->destlist)) {
> > > +			state->sk = (struct sock *)usk;
> > > +			state->dest = list_first_entry(&usk->destlist,
> > > +					struct udpcp_dest, list);
> > > +			sock_hold(state->sk);
> > > +
> > > +			if (atomic_read(&state->sk->sk_refcnt) != 1) {
> > > +				spin_unlock_irqrestore(&spinlock, flags);
> > > +				return state;
> > > +			}
> > > +			atomic_dec(&state->sk->sk_refcnt);
> > > +		}
> > > +
> > 
> > I am trying to understand what you are doing here.
> > 
> > It seems racy to me.
> > 
> > Apparently, what you want is to take a reference only if actual
> > sk_refcnt is not zero.
> > 
> > I suggest using atomic_inc_notzero(&state->sk->sk_refcnt) to avoid the
> > race in atomic_dec().
> > 
> > 
> 
> Before you ask why its racy, this is because UDP sockets are RCU
> protected, and RCU lookups depend on sk_refcnt being zero or not.
> 
> Doing an sk_refcnt increment/decrement opens a race window for the
> concurrent lookups.
> 

I still revamped the whole /proc/net/udpcp thing and hope it is now race
free.


