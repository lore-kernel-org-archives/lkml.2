Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2IFJsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:48:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab2IFJsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:48:37 -0400
Date: Thu, 6 Sep 2012 12:49:56 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
Message-ID: <20120906094956.GB22816@redhat.com>
References: <20120903044133.GA9980@moria.home.lan>
 <87wr0ae26e.fsf@rustcorp.com.au>
 <20120906074113.GA5902@koverstreet-glaptop>
 <20120906084403.GD17656@redhat.com>
 <20120906092512.GB5902@koverstreet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906092512.GB5902@koverstreet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 02:25:12AM -0700, Kent Overstreet wrote:
> On Thu, Sep 06, 2012 at 11:44:03AM +0300, Michael S. Tsirkin wrote:
> > On Thu, Sep 06, 2012 at 12:41:13AM -0700, Kent Overstreet wrote:
> > > On Tue, Sep 04, 2012 at 03:53:53PM +0930, Rusty Russell wrote:
> > > > Kent Overstreet <koverstreet@google.com> writes:
> > > > 
> > > > > CONFIG_VIRTIO isn't exposed, everything else is supposed to select it
> > > > > instead.
> > > > 
> > > > This is a slight mis-understanding.  It's supposed to be selected by
> > > > the particular driver, probably virtio_pci in your case.
> > > 
> > > So are you saying virtio-blk depends on virtio-pci? If so, the kconfig
> > > should have that.
> > > 
> > > As is, VIRTIO_BLK just has:
> > > 	depends on EXPERIMENTAL && VIRTIO
> > > 
> > > which is flat out broken.
> > 
> > I don't think anything is broken.
> > Can you show an example of a broken configuration?
> 
> Do you not understand the difference between depends an selects?
> Or did you not read my original mail?
> Flip off everything in drivers -> virtio
> 
> Now go to drivers -> block and try to turn on virtio-blk.
> 
> It's not listed!

Yes. Because you disabled all virtio backends.
It does not make sense to have any frontends.

> Now go back to drivers -> virtio and turn on (randomly) balloon.
> 
> Go back to drivers -> block, and now you can turn on virtio-blk!
> 
> Do you see what's wrong with this picture?

Yes. You got unlucky with your random guess.
It's a bug in balloon kconfig: it should not
select virtio.
I sent a patch to fix that yesterday.

-- 
MST
