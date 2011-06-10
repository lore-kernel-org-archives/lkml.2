Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab1FJAVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 20:21:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:13805 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419Ab1FJAVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 20:21:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,344,1304319600"; 
   d="scan'208";a="11672495"
Date: Thu, 9 Jun 2011 17:21:03 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net
Cc: Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: USB mini-summit at LinuxCon Vancouver
Message-ID: <20110610002103.GA7169@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to announce a USB mini-summit at LinuxCon Vancouver.

What:	USB mini-summit
When:	Tuesday, August 16th, all day
Where:	At the conference venue, room TBD pending confirmation from
	Angela Brown.

Proposed topics include USB virtualization, and improved bandwidth APIs
between the USB core and drivers (especially webcam drivers).  See the
detailed topic list below.  Anyone is also welcome to propose or show up
with a USB related topic.  MUSB?  USB 3.0 gadget drivers?  USB-IP?

The USB mini-summit does overlap with the virtualization mini-summit by
a day, but I'm hoping we can schedule talks so some of the
virtualization folks can make it to the USB mini-summit.  The other
option was on Friday during the conference which was not ideal.

Proposed topics:

Topic 1
-------

The KVM folks suggested that it would be good to get USB and
virtualization developers together to talk about how to virtualize the
xHCI host controller.  The xHCI spec architect worked closely with
VMWare to get some extra goodies in the spec to help virtualization, and
I'd like to see the other virtualization developers take advantage of
that.  I'd also like us to hash out any issues they have been finding in
the USB core or xHCI driver during the virtualization effort.


Topic 2
-------

I'd also like to get the V4L and audio developers who work with USB
devices together with the core USB folks to talk about bandwidth
management under xHCI.

One of the issues is that since the xHCI hardware does bandwidth
management, not the xHCI driver, a schedule that will take too much
bandwidth will get rejected much sooner than any USB driver currently
expects (during a call to usb_set_interface).  This poses issues, since
most USB video drivers negotiate the video size and frame rate after
they call usb_set_interface, so they don't know whether they can fall
back to a less bandwidth-intensive setting.  Currently, they just submit
URBs with less and less bandwidth until one interval setting gets
accepted that won't work under xHCI.

A second issue is that that some drivers need less bandwidth than the
device advertises, and the xHCI driver currently uses whatever periodic
interval the device advertises in its descriptors.  This is not what the
video/audio driver wants, especially in the case of buggy high speed
devices that advertise the interval in frames, not microframes.  There
needs to be some way for the drivers to communicate their bandwidth
needs to the USB core.  We've known about this issue for a while, and I
think it's time to get everyone in the same room and hash out an API.

(I will send out an API proposal later this month.)

Hope to see you there!

Sarah Sharp
