Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab2FJUUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 16:20:07 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49430 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab2FJUUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 16:20:05 -0400
Date: Sun, 10 Jun 2012 22:19:57 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120610201957.GD2629@local>
References: <4FD22552.6090609@01019freenet.de>
 <20120608164426.GE9705@local>
 <1339175476.26976.102.camel@ul30vt>
 <20120610141759.GB8922@redhat.com>
 <1339344566.26976.272.camel@ul30vt>
 <20120610164429.GB9879@redhat.com>
 <1339349905.26976.306.camel@ul30vt>
 <20120610190036.GD10523@redhat.com>
 <20120610191130.GC2629@local>
 <20120610191654.GE10523@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610191654.GE10523@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 10:16:54PM +0300, Michael S. Tsirkin wrote:
> On Sun, Jun 10, 2012 at 09:11:30PM +0200, Hans J. Koch wrote:
> > On Sun, Jun 10, 2012 at 10:00:36PM +0300, Michael S. Tsirkin wrote:
> > > 
> > > One thing I stand corrected on: assigning a PF that does DMA with VFIO
> > > *might* be secure, and sometimes, maybe often, is.
> > > There's just no way to make sure.
> > > This is unlike uio_pci_generic where it would always be insecure.
> > 
> > You need to be root to access a UIO device, and if you're root, you can
> > compromise a system in many ways. Before UIO, people used /dev/mem for
> > similar purposes, and UIO is certainly a seccurity improvement over that.
> > 
> > But of course, UIO presents security risks. Like many other things below
> > /dev, you need to know what you're doing, and who gets access to /dev/uioX.
> > 
> > Thanks,
> > Hans
> 
> Sorry I might not have explained myself clearly.  uio_pci_generic would
> be insecure if used with a device doing DMA. I am not speaking
> about UIO in general at all.

Oh, I do. There are many more risks than just DMA. I come from the embedded
systems world, and there it is not uncommon that some strange device can
simply turn the power off of some of your chips or even the whole system
if programmed properly. And there are a lot of things that might be fine
from the kernel's point of view, but render the system unusable from a
user's point of view.

UIO is a very thin layer on top of strange hardware. It just fills a gap
for a certain class of devices that don't fit in anywhere else. Although I'm
glad if somebody posts his UIO driver, I'm even more glad if another
subsystem (IIO, VFIO) can be found for the damn chip ;-)

Thanks,
Hans

