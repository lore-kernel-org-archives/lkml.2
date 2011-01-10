Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1AJMuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:50:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab1AJMut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:50:49 -0500
Date: Mon, 10 Jan 2011 14:50:11 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Milton Miller <miltonm@bga.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: remove virtio-pci root device
Message-ID: <20110110125011.GI2202@redhat.com>
References: <20110105191711.GA27489@redhat.com>
 <virtio-pci-whynotsimplify@mdm.bga.com>
 <virtio-pci-noroot@mdm.bga.com>
 <20110109151821.GA9063@redhat.com>
 <20110110111859.GC2202@redhat.com>
 <20110110112205.GC12065@redhat.com>
 <20110110112739.GD2202@redhat.com>
 <20110110114219.GE2202@redhat.com>
 <20110110120808.GA15554@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110120808.GA15554@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 02:08:08PM +0200, Michael S. Tsirkin wrote:
> On Mon, Jan 10, 2011 at 01:42:19PM +0200, Gleb Natapov wrote:
> > On Mon, Jan 10, 2011 at 01:27:39PM +0200, Gleb Natapov wrote:
> > > On Mon, Jan 10, 2011 at 01:22:05PM +0200, Michael S. Tsirkin wrote:
> > > > On Mon, Jan 10, 2011 at 01:18:59PM +0200, Gleb Natapov wrote:
> > > > > On Sun, Jan 09, 2011 at 05:18:21PM +0200, Michael S. Tsirkin wrote:
> > > > > > On Fri, Jan 07, 2011 at 02:55:06AM -0600, Milton Miller wrote:
> > > > > > > We sometimes need to map between the virtio device and
> > > > > > > the given pci device. One such use is OS installer that
> > > > > > > gets the boot pci device from BIOS and needs to
> > > > > > > find the relevant block device. Since it can't,
> > > > > > > installation fails.
> > > > > > > 
> > > > > > > Instead of creating a top-level devices/virtio-pci
> > > > > > > directory, create each device under the corresponding
> > > > > > > pci device node.  Symlinks to all virtio-pci
> > > > > > > devices can be found under the pci driver link in
> > > > > > > bus/pci/drivers/virtio-pci/devices, and all virtio
> > > > > > > devices under drivers/bus/virtio/devices.
> > > > > > > 
> > > > > > > Signed-off-by: Milton Miller <miltonm@bga.com>
> > > > > > 
> > > > > > OK, this works fine for me.  I played with options to add compat
> > > > > > softlinks under devices/virtio-pci but we still don't get exactly the
> > > > > > same layout and since I don't think anyone actually uses them, it's
> > > > > > probably ok to just to the simple thing.
> > > > > > 
> > > > > > Tested/Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > > > > > 
> > > > > > Rusty, since this help fix at least one user, any chance this can be put
> > > > > > in 2.6.38? OK to backport to -stable?
> > > > > > 
> > > > > > Gleb, could you try this out too?
> > > > > > 
> > > > > With this patch if I have 3 virtio disks for a VM I get:
> > > > > /sys/devices/pci0000:00/0000:00:04.0/virtio0/block/vda
> > > > > /sys/devices/pci0000:00/0000:00:05.0/virtio1/block/vdb
> > > > > /sys/devices/pci0000:00/0000:00:06.0/virtio2/block/vdc
> > > > > 
> > > > > Number after virtio has no much sense. It either should be dropped at all
> > > > > or be always zero in case we will support more then one virtio controller
> > > > > per pci card. In that case each virtio controller will have directories
> > > > > virtio0/virtio1/virtio2... under same pci device directory.
> > > > 
> > > > Yes. But this is the bus name.  It must be unique - all devices
> > > > also appear under /sys/bus/virtio/devices.
> > > > 
> > > It is very strange king of bus that is spread over several PCI devices :)
> > > It doesn't make much sense IMHO, but I can leave with it.
> > > 
> > I can't "leave" with it, but I can "live" with it.
> 
> The virtio bus is an attempt to make as many applications as
> possible work transparently on any virtio system,
> be it lguest, s390 or pci. Arbitrary IDs is just a hint to the
> applications 'don't rely on the name at all'.
> 
Shouldn't sysfs directory reflect real device topology? There are other
buses AFAIK that connected differently on different HW. How virtio is
special? What applications this allow to work transparently?

--
			Gleb.
