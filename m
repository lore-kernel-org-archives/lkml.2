Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2AVX6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 18:58:34 -0500
Received: from ozlabs.org ([203.10.76.45]:38295 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab2AVX6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 18:58:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio: correct the memory barrier in virtqueue_kick_prepare()
In-Reply-To: <20120122114757.GD27222@redhat.com>
References: <20120120081658.50747.10625.stgit@amd-6168-8-1.englab.nay.redhat.com> <20120120081708.50747.60241.stgit@amd-6168-8-1.englab.nay.redhat.com> <20120122114757.GD27222@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 23 Jan 2012 10:04:17 +1030
Message-ID: <87y5szfh1i.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jan 2012 13:47:57 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Fri, Jan 20, 2012 at 04:17:08PM +0800, Jason Wang wrote:
> > Use virtio_mb() to make sure the available index to be exposed before
> > checking the the avail event. Otherwise we may get stale value of
> > avail event in guest and never kick the host after.
> > 
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Good catch.
> Note: this fixes a bug introduced by ee7cd8981e15bcb365fc762afe3fc47b8242f630.

Indeed, great catch.  It replaces the missing barrier, and after some
careful thought I've convinced myself that it is necessary for both the
avail index and flag cases.

> >  	START_USE(vq);
> > -	/* Descriptors and available array need to be set before we expose the
> > -	 * new available array entries. */
> > -	virtio_wmb(vq);
> > +	/* We need expose available array entries before checking avail
> 
> Nit:
> We need expose -> Need to expose
> 
> > +	 * event. */
> > +	virtio_mb(vq);

Fixed typo and applied.

Thanks,
Rusty.
