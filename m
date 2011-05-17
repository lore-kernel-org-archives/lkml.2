Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab1EQXok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:44:40 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41978 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab1EQXoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:44:39 -0400
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in
 netdevice
From: Shirley Ma <mashirle@us.ibm.com>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTik6aqP5BVrQNFKrnU3v=KA9ip1RoA@mail.gmail.com>
References: <1305574128.3456.23.camel@localhost.localdomain>
	 <1305574518.2885.25.camel@bwh-desktop>
	 <1305574680.3456.33.camel@localhost.localdomain>
	 <1305575253.2885.28.camel@bwh-desktop> <20110516211459.GE18148@redhat.com>
	 <1305588738.3456.65.camel@localhost.localdomain>
	 <BANLkTimvOK3tyo6+L5AD=so5DjiDPV-AAA@mail.gmail.com>
	 <1305671318.10756.49.camel@localhost.localdomain>
	 <BANLkTik6aqP5BVrQNFKrnU3v=KA9ip1RoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 16:44:25 -0700
Message-ID: <1305675865.10756.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 00:58 +0200, Michał Mirosław wrote:
> W dniu 18 maja 2011 00:28 użytkownik Shirley Ma <mashirle@us.ibm.com>
> napisał:
> > On Tue, 2011-05-17 at 23:48 +0200, Michał Mirosław wrote:
> >> 2011/5/17 Shirley Ma <mashirle@us.ibm.com>:
> >> > Looks like to use a new flag requires more time/work. I am
> thinking
> >> > whether we can just use HIGHDMA flag to enable zero-copy in
> macvtap
> >> to
> >> > avoid the new flag for now since mavctap uses real NICs as lower
> >> device?
> >>
> >> Is there any other restriction besides requiring driver to not
> recycle
> >> the skb? Are there any drivers that recycle TX skbs?
> > Not more other restrictions, skb clone is OK. pskb_expand_head()
> looks
> > OK to me from code review.
> 
> > Currently there is no drivers recycle TX skbs.
> 
> So why do you require the target device to have some flags at all?

We could use macvtap to check lower device HIGHDMA to enable zero-copy,
but I am not sure whether it is sufficient. If it's sufficient then we
don't need to use a new flag here. To be safe, it's better to use a new
flag to enable each device who can pass zero-copy test.

> Do I understand correctly, that this zero-copy feature is about
> packets received from VMs?

Yes, packets sent from VMs, and received in local host for TX zero-copy
here.

Thanks
Shirley



