Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1DKWLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:11:19 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48583 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1DKWLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:11:18 -0400
Subject: Re: [RFC][PATCH] virtio balloon: kill tell-host-first logic
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
In-Reply-To: <20110411110131.GA23123@redhat.com>
References: <20110407174325.ED21C82B@kernel>
	 <20110411110131.GA23123@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 11 Apr 2011 15:11:11 -0700
Message-ID: <1302559871.7286.16749.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 14:01 +0300, Michael S. Tsirkin wrote:
> On Thu, Apr 07, 2011 at 10:43:25AM -0700, Dave Hansen wrote:
> > The virtio balloon driver has a VIRTIO_BALLOON_F_MUST_TELL_HOST
> > feature bit.  Whenever the bit is set, we must always tell the
> > host before we free pages back to the allocator.  Without this
> > we might free a page (and have another user touch it) while the
> > hypervisor is unprepared for it.
> > 
> > But, if the bit is _not_ set, we are under no obligation to
> > reverse the order.  Furthermore, all modern qemus set this bit.
> 
> Which qemus do this, specifically?  Amit Shah just pointed out to me
> that upstream qemu.git and qemu-kvm.git don't seem to do this.

I had a conversation with Anthony about it, and I think I managed to
confuse myself somewhere.  Just to be clear, all that I see in the
qemu-kvm git tree right now (df85c051d780bca0ee2462cfeb8ef6d9552a19b0)
is this:

hw/virtio-balloon.h:#define VIRTIO_BALLOON_F_MUST_TELL_HOST 0 /* Tell before reclaiming pages */

> Which qemu did you test this with? 

Probably a week or two old qemu-kvm.

My changelog could probably use some work, but the patch still stands.
The only requirement we have is that when
VIRTIO_BALLOON_F_MUST_TELL_HOST is set we *MUST* tell the host, first.
But, when it's not set, we can do whatever we want.

So, we might as well always have the ...F_MUST_TELL_HOST behavior all
the time.  

-- Dave

