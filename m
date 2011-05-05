Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab1EEVC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 17:02:28 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55089 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab1EEVC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 17:02:27 -0400
Subject: Re: [PATCH V4 2/8] netdevice.h: Add a new zerocopy device flag
From: Shirley Ma <mashirle@us.ibm.com>
To: Sridhar Samudrala <sri@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, mst@redhat.com,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4DC1DD9D.6070708@us.ibm.com>
References: <1304495717.20660.67.camel@localhost.localdomain>
	 <4DC1DD9D.6070708@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 14:02:17 -0700
Message-ID: <1304629337.7076.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 16:13 -0700, Sridhar Samudrala wrote:
> On Wed, 2011-05-04 at 00:55 -0700, Shirley Ma wrote: 
> > Signed-off-by: Shirley Ma <xma@us.ibm.com>
> > ---
> > 
> >  include/linux/netdevice.h |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 0249fe7..0808f1e 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1067,6 +1067,16 @@ struct net_device {
> >  #define NETIF_F_RXHASH		(1 << 28) /* Receive hashing offload */
> >  #define NETIF_F_RXCSUM		(1 << 29) /* Receive checksumming offload */
> > 
> > +/*
> > + * Bit 31 is for device to map userspace buffers -- zerocopy
> > + * Device can set this flag when it supports HIGHDMA.
> > + * Device can't recycle this kind of skb buffers.
> > + * There are 256 bytes copied, the rest of buffers are mapped.
> > + * The userspace callback should only be called when last reference to this skb
> > + * is gone.
> > + */
> > +#define NETIF_F_ZEROCOPY	(1 << 31)
> > +
> Should we make this TX_ZEROCOPY as we may need a seperate flag for
> RX_ZEROCOPY in future?
> 
> Same with socket flag.

We might be able to use the same flag for both TX and RX. If RX
zero-copy requires only HIGHDMA feature only. If not, then we might need
different feature bit. Same for sock flag.

> Thanks
> Sridhar
> 
> 

