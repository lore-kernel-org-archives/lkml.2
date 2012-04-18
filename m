Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2DRSsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:48:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab2DRSsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:48:37 -0400
Date: Wed, 18 Apr 2012 21:48:38 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private
 pointer in struct virtqueue
Message-ID: <20120418184836.GB14635@redhat.com>
References: <1334756013-11752-1-git-send-email-pbonzini@redhat.com>
 <20120418142146.GB11801@redhat.com>
 <4F8ED0E4.6000702@redhat.com>
 <20120418161028.GB12815@redhat.com>
 <4F8F0A08.8010900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8F0A08.8010900@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 08:38:00PM +0200, Paolo Bonzini wrote:
> >>>>   * @priv: a pointer for the virtqueue implementation to use.
> >>>>   */
> >>>>  struct virtqueue {
> >>>> @@ -21,6 +22,7 @@ struct virtqueue {
> >>>>  	void (*callback)(struct virtqueue *vq);
> >>>>  	const char *name;
> >>>>  	struct virtio_device *vdev;
> >>>> +	void *vdev_priv;
> >>>>  	void *priv;
> >>>
> >>> The name is confusing: it seems to imply it's a device pointer.
> >>
> >> ... it's private to the driver that owns vdev, hence the name.
> > 
> > I own a car but I'm not called Michael Car :)
> > driver_priv might be ok too. unfortunately virtio-pci
> > is also a driver so it can be misunderstood.
> 
> Yes.  Is fixing the comment and keeping the vdev_priv name ok with you?

This puts it lower on the scale of bad interfaces but
I think we still need a better name.

> > devices should dominate. ring is an implementation detail.
> 
> Ring came first, ring gets the nice name. :)
> 
> Paolo
