Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2KUPsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:48:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57566 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab2KUPsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:48:06 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Device tree node to major/minor?
To: Simon Glass <sjg@chromium.org>
Cc: lk <linux-kernel@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Che-liang Chiou <clchiou@chromium.org>
In-Reply-To: <CAPnjgZ3jF7bdwqDCNzJXvSrwoP0PZVjcFO+nGOiLACLDX07Z7A@mail.gmail.com>
References: <CAPnjgZ0+8MbjmW7XKsSW0O0n2ob7XcUZokLd8b=1LkSUJ+tQEA@mail.gmail.com> <CACxGe6t-ROJe+KXZh-nah50M2buM4yjncs=7musv39=C+73_FQ@mail.gmail.com> <CAPnjgZ3jF7bdwqDCNzJXvSrwoP0PZVjcFO+nGOiLACLDX07Z7A@mail.gmail.com>
Date: Wed, 21 Nov 2012 15:47:58 +0000
Message-Id: <20121121154758.93CE43E0AE2@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 15:48:24 -0800, Simon Glass <sjg@chromium.org> wrote:
> Hi Grant,
> 
> On Tue, Nov 20, 2012 at 2:32 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Tue, Nov 20, 2012 at 10:23 PM, Simon Glass <sjg@chromium.org> wrote:
> >> Hi,
> >>
> >> I hope this is a stupid question with an easy answer, but I cannot find it.
> >>
> >> I have a device tree node for an mmc block device and I want to use
> >> that block device from another driver. I have a phandle which lets me
> >> get the node of the mmc device, but I am not sure how to convert that
> >> into a block_device. In order to do so, I think I need a major/minor
> >> number. Of course the phandle might in fact point to a SCSI driver and
> >> I want that to work correctly also.
> >>
> >> I imagine I might be able to search through the wonders of sysfs in
> >> user space, but is there a better way?
> >
> > Do you /want/ to do it from userspace? What is your use case? Mounting
> > the rootfs?
> 
> The use case is storing some raw data on a block device from within a
> driver in the kernel. It is used to keep track of the verified boot
> state.
> 
> >
> > Regardless, userspace can monitor the uevents when devices are added
> > (that's what udev does) and watch for the full path of the node you
> > want in the uevent attribute. Then you can look for the child device
> > with the block major/minor numbers in it.
> 
> So is there a way to do this entirely in the kernel ex post? It might
> need to happen during kernel boot, before user space.

Yes, it is certainly doable within the kernel. First, you'll need to use
a notifier to get called back whenever a new device is created. Then
you'll need to look at the dev->of_node(->full_name) to see if it is the
node you actually want. You might need/want to resolve it from an alias
or something, but I presume you already have a way to find the
device_node before seaching for a struct device.

g.
