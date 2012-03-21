Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2CUGhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:37:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab2CUGhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:37:40 -0400
Date: Wed, 21 Mar 2012 08:37:46 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] virtio-spec: clarify ro/rw bits and updating rule of
 virtio-net status field
Message-ID: <20120321063746.GA6773@redhat.com>
References: <20120320062020.12815.61342.stgit@jason-ThinkPad-T400>
 <87ty1jpm6p.fsf@rustcorp.com.au>
 <20120320224805.GA4997@redhat.com>
 <87ty1ializ.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ty1ializ.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 10:10:52AM +1030, Rusty Russell wrote:
> On Wed, 21 Mar 2012 00:48:05 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Tue, Mar 20, 2012 at 09:35:18PM +1030, Rusty Russell wrote:
> > > On Tue, 20 Mar 2012 14:20:21 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > > This patch clarifies VIRTIO_NET_S_LINK_UP as a read-only bit and
> > > > VIRTIO_NET_S_ANNOUNCE as a read-writable bit. Also introduce the write 1 to
> > > > clear semantics for all read-writable bits of config status field. This could
> > > > help to reduce the config status field updating race between host and guest and
> > > > also simplify the implementation.
> > > > 
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > 
> > > This approach assumes an active config field, which neither lguest nor
> > > S/390 have.
> > > 
> > > Thanks,
> > > Rusty.
> > 
> > What does 'active' mean in this context?
> 
> It means you are assuming that writes to the config field trap to the
> host.
> 
> Rusty.

Ah. Right, we need to trap for host to clear the bit.
OK, so let's make the bit RO, and add
VIRTIO_NET_CTRL_ANNOUNCED to acknowledge that we've
seen VIRTIO_NET_S_ANNOUNCE using the control VQ?

If there's no ctrl VQ, we won't acknowledge the feature bit ...

> -- 
>   How could I marry someone with more hair than me?  http://baldalex.org
