Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab1EQW2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:28:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34305 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab1EQW2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:28:48 -0400
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
In-Reply-To: <BANLkTimvOK3tyo6+L5AD=so5DjiDPV-AAA@mail.gmail.com>
References: <1305574128.3456.23.camel@localhost.localdomain>
	 <1305574518.2885.25.camel@bwh-desktop>
	 <1305574680.3456.33.camel@localhost.localdomain>
	 <1305575253.2885.28.camel@bwh-desktop> <20110516211459.GE18148@redhat.com>
	 <1305588738.3456.65.camel@localhost.localdomain>
	 <BANLkTimvOK3tyo6+L5AD=so5DjiDPV-AAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 15:28:38 -0700
Message-ID: <1305671318.10756.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 23:48 +0200, Michał Mirosław wrote:
> 2011/5/17 Shirley Ma <mashirle@us.ibm.com>:
> > Hello Michael,
> >
> > Looks like to use a new flag requires more time/work. I am thinking
> > whether we can just use HIGHDMA flag to enable zero-copy in macvtap
> to
> > avoid the new flag for now since mavctap uses real NICs as lower
> device?
> 
> Is there any other restriction besides requiring driver to not recycle
> the skb? Are there any drivers that recycle TX skbs? 

Not more other restrictions, skb clone is OK. pskb_expand_head() looks
OK to me from code review.

Currently there is no drivers recycle TX skbs.

Thanks
Shirley

