Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934648Ab1JEMvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:51:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37939 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934356Ab1JEMvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:51:19 -0400
Subject: Re: [PATCH v2 2/2] virtio-net: Prevent NULL dereference
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
In-Reply-To: <20111003184037.GA22427@redhat.com>
References: <1317220855-9352-1-git-send-email-levinsasha928@gmail.com>
	 <1317220855-9352-2-git-send-email-levinsasha928@gmail.com>
	 <20111003184037.GA22427@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 05 Oct 2011 15:50:14 +0200
Message-ID: <1317822614.3676.0.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 20:40 +0200, Michael S. Tsirkin wrote:
> On Wed, Sep 28, 2011 at 05:40:55PM +0300, Sasha Levin wrote:
> > This patch prevents a NULL dereference when the user has passed a length
> > longer than an actual buffer to virtio-net.
> > 
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > Cc: virtualization@lists.linux-foundation.org
> > Cc: netdev@vger.kernel.org
> > Cc: kvm@vger.kernel.org
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > ---
> >  drivers/net/virtio_net.c |   12 +++++++++++-
> >  1 files changed, 11 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index bde0dec..4a53d2a 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -208,12 +208,22 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >  		return NULL;
> >  	}
> >  
> > -	while (len) {
> > +	while (len && page) {
> >  		set_skb_frag(skb, page, offset, &len);
> >  		page = (struct page *)page->private;
> >  		offset = 0;
> >  	}
> >  
> > +	/*
> > +	 * This is the case where we ran out of pages in our linked list, but
> > +	 * supposedly have more data to read.
> 
> Again, let's clarify that this only happens with broken devices.

I think that the code within the if() makes it clear that it isn't the
regular path.

-- 

Sasha.

