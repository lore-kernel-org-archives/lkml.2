Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1IMFXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 01:23:13 -0400
Received: from ozlabs.org ([203.10.76.45]:47083 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab1IMFXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 01:23:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anthony Liguori <aliguori@us.ibm.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S.Tsirkin" <mst@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [RFC 1/2] virtio: Add AMBA bus driver for virtio device
In-Reply-To: <1315845956.3297.7.camel@hornet.cambridge.arm.com>
References: <1314966257-7503-1-git-send-email-pawel.moll@arm.com> <1314966257-7503-2-git-send-email-pawel.moll@arm.com> <877h5e5yxp.fsf@rustcorp.com.au> <1315845956.3297.7.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 13 Sep 2011 12:28:26 +0930
Message-ID: <87hb4h408d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011 17:45:56 +0100, Pawel Moll <pawel.moll@arm.com> wrote:
> On Mon, 2011-09-12 at 11:01 +0930, Rusty Russell wrote:
> > You need to make these at least 64 bits.  Lguest makes them variable
> > width, in fact.
> 
> No problem, I've reserved 128 bits in the modified registers layout (see
> RFC v2), I can even change it into "offset/value" interface, which would
> give you variable width. One thing I don't get is how to access feature
> bits > 31? The get_features() seems
> to be limited to 32:
> 
> struct virtio_config_ops {
> <...>
> 	u32 (*get_features)(struct virtio_device *vdev);
> <...>
> }

There's a patch for that already :)

> > > + *  0x008   32  QueuePFN      PFN for the currently selected queue
> > > + *  0x00c   32  QueueNum      Queue size for the currently selected queue
> > 
> > You should, I believe, seriously consider allowing the guest to set the
> > queue size, rather than the host (perhaps the host could suggest one,
> > but the guest should be able to override it).
> 
> I guess the QueueNum could be simply a read/write register - guest can
> read suggestion and override it writing it back. The same question
> though - how can guest change it? (I mean some API?)

We can sort that out later... the Guest may try some ambitious large
allocation and fall back if it fails.

> > Anthony or Michael might suggest other changes, since they are most
> > familiar with virtio_pci limitations...
> 
> I've added them on the RFC v2 Cc as well - all feedback more then
> welcome!

Excellent...  of course, the virtualization list is down at the moment,
making this a bit more awkward.

Cheers,
Rusty.
