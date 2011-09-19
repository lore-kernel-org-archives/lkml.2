Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab1ISXVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:21:23 -0400
Received: from ozlabs.org ([203.10.76.45]:39845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab1ISXVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:21:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-net: Read MAC only after initializing MSI-X
In-Reply-To: <20110919060150.GB1569@redhat.com>
References: <1313225461-24458-1-git-send-email-levinsasha928@gmail.com> <20110819152335.GA19489@redhat.com> <1313771587.12243.16.camel@lappy> <20110820200043.GB5276@redhat.com> <871uvdryq2.fsf@rustcorp.com.au> <20110919060150.GB1569@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 19 Sep 2011 17:19:49 +0930
Message-ID: <874o09x97m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011 09:01:50 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Sep 19, 2011 at 01:05:17PM +0930, Rusty Russell wrote:
> > On Sat, 20 Aug 2011 23:00:44 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Fri, Aug 19, 2011 at 07:33:07PM +0300, Sasha Levin wrote:
> > > > Maybe this is better solved by copying the way it was done in PCI itself
> > > > with capability linked list?
> > > 
> > > There are any number of ways to lay out the structure.  I went for what
> > > seemed a simplest one.  For MSI-X the train has left the station.  We
> > > can probably still tweak where the high 32 bit features
> > > for 64 bit features are.  No idea if it's worth it.
> > 
> > Sorry, this has been in the back of my mind.  I think it's a good idea;
> > can we use the capability linked list for pre-device specific stuff from
> > now on?
> > 
> > Thanks,
> > Rusty.
> 
> Do we even want capability bits then?
> We can give each capability an ack flag ...

We could have, and if I'd known PCI when I designed virtio I might have.

But it's not easy now to map structure offsets to that scheme, and we
can't really force such a change on the non-PCI users.  So I'd say we
should only do it for the non-device-specific options.  ie. we'll still
have the MSI-X case move the device-specific config, but we'll use a
linked list from now on, eg. for the next 32 features bits...

Thoughts?
Rusty.
