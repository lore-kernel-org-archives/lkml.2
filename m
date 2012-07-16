Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2GPV6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:58:36 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49919 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab2GPV6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:58:32 -0400
Date: Mon, 16 Jul 2012 23:58:23 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Andreas Schallenberg <embedded@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Subject: Re: UIO: missing resource mapping
Message-ID: <20120716215823.GA7879@local>
References: <4FFE7C1F.7080702@gmx.net>
 <20120712194432.GA2592@local>
 <20120712231632.GC9317@redhat.com>
 <1342166955.6607.5.camel@blech>
 <20120713132223.GA10959@redhat.com>
 <1342190571.6607.36.camel@blech>
 <20120713181953.GA11527@redhat.com>
 <1342462572.17531.18.camel@blech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342462572.17531.18.camel@blech>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 08:16:12PM +0200, Dominic Eschweiler wrote:
> Am Freitag, den 13.07.2012, 21:19 +0300 schrieb Michael S. Tsirkin:
> > 
> > UIO has the same property, doesn't it? Multiple users can
> > access device memory through sysfs. 
> 
> 
> Indeed, that's a similar problem. I haven't tried it (yet), but this
> particular problem can maybe circumvented by using mmap with the
> MAP_PRIVATE flag. Doing so is the responsibility of the driver
> programmer (like Hans already said). Even if that mmap trick does not
> work, it is pretty much sure that a BAR is already used by another
> program, if a related kernel driver is loaded. In that case the kernel
> has a chance to avoid such BAR race conditions by not giving the
> possibility to map them to the userspace.

Don't make it more complicated than it is. I see no general problem in
mapping BARs in uio_pci_generic like in any other UIO PCI driver.

> 
> Nevertheless, I'm pretty sure that the possibility via sysfs to access
> BARs, which are already managed by a kernel driver, opens the door for
> denial of service attacks.

There are also a few other possible attack scenarios, depending on the
hardware.
That's a general problem of all userspace drivers (e.g. X graphics drivers).
You have to make sure access rights are correct. Making a UIO device node
available to all normal users is foolishly dangerous.

> 
> On the other hand, I'm quite a newbie on this topic and maybe I don't
> see the big picture here. Therefore it is up to you guys to make the
> right decision (if needed).

Try to hack up a patch to add generic BAR mapping to uio_pci_generic.c
and post it for review.

Thanks,
Hans
