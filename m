Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2JHTkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 15:40:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab2JHTkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 15:40:01 -0400
Date: Mon, 8 Oct 2012 22:41:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Lendacky <tahm@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] virtio-net: inline header support
Message-ID: <20121008204145.GA17820@redhat.com>
References: <cover.1348824232.git.mst@redhat.com>
 <87vces2gxq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vces2gxq.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:14:17PM +0930, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > Thinking about Sasha's patches, we can reduce ring usage
> > for virtio net small packets dramatically if we put
> > virtio net header inline with the data.
> > This can be done for free in case guest net stack allocated
> > extra head room for the packet, and I don't see
> > why would this have any downsides.
> 
> I've been wanting to do this for the longest time... but...
> 
> > Even though with my recent patches qemu
> > no longer requires header to be the first s/g element,
> > we need a new feature bit to detect this.
> > A trivial qemu patch will be sent separately.
> 
> There's a reason I haven't done this.  I really, really dislike "my
> implemention isn't broken" feature bits.  We could have an infinite
> number of them, for each bug in each device.
> 
> So my plan was to tie this assumption to the new PCI layout.

I don't object but old qemu has this limitation for s390 as well,
and that's not using PCI, right? So how do we detect
new hypervisor there?

-- 
MST
