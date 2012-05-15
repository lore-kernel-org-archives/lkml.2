Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab2EOOLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:11:38 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:45917 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751394Ab2EOOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:11:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigMAKZisk9bdWOb/2dsb2JhbABEhXulVYgogQeCFQEBBSNECwcQCxgCAiYCAlcGiCWoCZMAgTCJbIRogRgEn1WGaIJr
X-IronPort-AV: E=Sophos;i="4.75,595,1330902000"; 
   d="scan'208";a="914135914"
Message-ID: <1337091098.3472.58.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 2/5] Staging: ipack: add proper device model into
 ipack_bus_register.
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 16:11:38 +0200
In-Reply-To: <20120514204654.GA8723@kroah.com>
References: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
	 <1336992089-2733-3-git-send-email-siglesias@igalia.com>
	 <20120514204654.GA8723@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 13:46 -0700, Greg Kroah-Hartman wrote:
> On Mon, May 14, 2012 at 12:41:26PM +0200, Samuel Iglesias Gonsalvez wrote:
> > This patch adds a proper device model to the driver. The carrier boards are
> > managed like other ipack device, the way to recognize them is using the
> > platform data field from struct device.
> 
> Wait, what?  Why would you use the platform data field?  Why is that
> needed at all?  You can specify the "type" of the device, but it seems
> that you really want two different things here, busses and devices,
> right?  So use two different devices and manage them differently, don't
> make them the "same but different" by looking at the platform data
> field.  That's not what the platform data field is for at all, sorry.

I don't use platform_data to tell apart the devices from buses.
Although they don't have auto-discovery, the buses drivers do the
matching. I am not avoiding this step.

The "real" bus devices are already registered in PCI, USB, VME, etc, as
their interface with the rest of the system is through one of these
buses. The problem is to make a relation between a ipack bus device and
its driver, if we want it to be a registered device in ipack, as this
patch does.

Platform_data field is filled with the driver that the device belongs
to, facilitating the task.

There is a similar example in the VME bus with the devices that don't
support auto-discovery, as shown in drivers/staging/vme/vme.c in the
vme_bus_match() function.

Another option is what you say: use two different devices and manage
them differently. It will be needed to add new match/probe functions and
do similar stuff due to the lack of auto-discovery at this case.

A third option is use bus devices like VME bridges in the vme bus
driver, i.e, they are not devices, just an abstraction that provides
some functionality to the mezzanine devices.

I prefer the first option because it reuses the code of the probe/match
functions inside the ipack bus driver and it shows the hierarchy through
sysfs as everything is a registered device.

What do you think?

Sam


