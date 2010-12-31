Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0LaK2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:28:13 -0500
Received: from www84.your-server.de ([213.133.104.84]:43826 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0LaK2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:28:12 -0500
Subject: Re: [PATCH] UDPCP Communication Protocol
From: Stefani Seibold <stefani@seibold.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <1293790501.2973.33.camel@edumazet-laptop>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
	 <1293790501.2973.33.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 31 Dec 2010 11:29:13 +0100
Message-ID: <1293791353.5193.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 31.12.2010, 11:15 +0100 schrieb Eric Dumazet:
> Le vendredi 31 décembre 2010 à 10:29 +0100, stefani@seibold.net a
> écrit :
> > +				spin_lock_irqsave(&spinlock, flags);
> > +				udpcp_stat.txMsgs++;
> > +				spin_unlock_irqrestore(&spinlock, flags);
> 
> This is really ugly for different reasons :
> 
> 1) Naming a lock, even static "spinlock" is ugly.

Agree...

> 2) Using a lock for stats is not necessary, and
>    disabling hard irqs is not necessary either (spinlock_bh() would be
> more than enough)
>   
>    At a very minimum, you should use atomic_t so that no lock is needed
> 
> 3) Network stack widely use MIB per_cpu counters.
>  As you use UDP, you could take a look at UDP_INC_STATS_BH()/
> UDP_INC_STATS_USER() implementation for an example.
> 

I will have look at this and revamp it.


