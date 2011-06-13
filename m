Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab1FMKqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:46:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:32800 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1FMKqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:46:00 -0400
References: <20110610002103.GA7169@xanatos> <20110610031805.GA15774@kroah.com> <20110610194815.GA6646@xanatos> <20110610205035.GC13450@kroah.com>
In-Reply-To: <20110610205035.GC13450@kroah.com>
Mime-Version: 1.0 (iPhone Mail 8G4)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <5330D332-119F-40AD-B06F-CEDBD0D02D8D@suse.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libusb-devel@lists.sourceforge.net" 
	<libusb-devel@lists.sourceforge.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "hector@marcansoft.com" <hector@marcansoft.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>
X-Mailer: iPhone Mail (8G4)
From: Alexander Graf <agraf@suse.de>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Date: Mon, 13 Jun 2011 12:44:57 +0200
To: Greg KH <greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 10.06.2011 um 22:50 schrieb Greg KH <greg@kroah.com>:

> On Fri, Jun 10, 2011 at 12:48:15PM -0700, Sarah Sharp wrote:
>> On Thu, Jun 09, 2011 at 08:18:05PM -0700, Greg KH wrote:
>>> On Thu, Jun 09, 2011 at 05:21:03PM -0700, Sarah Sharp wrote:
>>>> Topic 1
>>>> -------
>>>> 
>>>> The KVM folks suggested that it would be good to get USB and
>>>> virtualization developers together to talk about how to virtualize the
>>>> xHCI host controller.  The xHCI spec architect worked closely with
>>>> VMWare to get some extra goodies in the spec to help virtualization, and
>>>> I'd like to see the other virtualization developers take advantage of
>>>> that.  I'd also like us to hash out any issues they have been finding in
>>>> the USB core or xHCI driver during the virtualization effort.
>>> 
>>> Do people really want to virtualize the whole xHCI controller, or just
>>> specific ports or devices to the guest operating system?
>> 
>> A host OS could chose to virtualize the whole xHCI controller if it
>> wanted to.  That's part of the reason why xHCI does all the bandwidth
>> checking in hardware, not in software.
> 
> And here I thought it did that so it would be "correct" :)
> 
>> 
>>> If just specific ports, would something like usbip be better for virtual
>>> machines, with the USB traffic going over the network connection between
>>> the guest/host?
>> 
>> It could be done that way too.  But that doesn't help if you're trying
>> to run Windows under Linux, right?  Only if all the guest OSes use the
>> same USB IP protocol then it would work.
> 
> usbip works on Windows as well as Linux.

Do you have a reliable, working usbip solution at hand that work on Windows and Linux and doesn't require real network access, which can be a no-go for some scenarios?

> 
> But how could you run Windows with a xHCI controller in a guest, as
> Windows has no xHCI driver?  What would it expect to see?

There are drivers for xhci adapters on Windows. Also, this whole discussion is pretty much future oriented - which most likely means built-in xhci drivers anywhere.

No, in all seriousity, the main reason to go for FV vs PV is that so far, the best tested and working drivers are built for real hardware. I'm still unsatisfied with the PV driver situation for virtio on Windows. It's just incredibly hard to get Windows drivers right - and open source developers sure are not good at it :)

But sure, let's talk about it during LinuxCon as well - there's a good chance you know more there than me :)

> 

Alex

