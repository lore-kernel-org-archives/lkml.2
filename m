Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574Ab1ESTnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:43:13 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60397 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934482Ab1ESTnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:43:10 -0400
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in
 netdevice
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1305738028.32080.66.camel@localhost.localdomain>
References: <1305671318.10756.49.camel@localhost.localdomain>
	 <20110518103819.GL7589@redhat.com>
	 <BANLkTimc1RbC3uQsra1HUvS_Trg63iMWGA@mail.gmail.com>
	 <20110518111734.GO7589@redhat.com>
	 <BANLkTi=g_PFfS5653K8ZoQ2Jhp8DhCV1hg@mail.gmail.com>
	 <1305729507.32080.6.camel@localhost.localdomain>
	 <20110518154746.GA21378@redhat.com>
	 <1305734857.32080.53.camel@localhost.localdomain>
	 <20110518163633.GB22001@redhat.com>
	 <1305737140.32080.59.camel@localhost.localdomain>
	 <20110518165138.GD22001@redhat.com>
	 <1305738028.32080.66.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 12:42:49 -0700
Message-ID: <1305834169.32080.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 10:00 -0700, Shirley Ma wrote:
> On Wed, 2011-05-18 at 19:51 +0300, Michael S. Tsirkin wrote:
> > > > Yes, I agree.  I think for tcpdump, we really need to copy the
> > data
> > > > anyway, to avoid guest changing it in between.  So we do that
> and
> > then
> > > > use the copy everywhere, release the old one. Hmm? 
> > > 
> > > Yes. Old one use zerocopy, new one use copy data.
> > > 
> > > Thanks
> > > Shirley
> > 
> > No, that's wrong, as they might become different with a
> > malicious guest. As long as we copied already, lets realease
> > the data and have everyone use the copy. 
> 
> Ok, I will patch pskb_expand_head to test it out. 

I am patching skb_copy, skb_clone, pskb_copy, pskb_expand_head to
convert a zero-copy skb to a copy skb to avoid this kind of issue.

This overhead won't impact macvtap/vhost TX zero-copy normally.

Shirley

