Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1FJHBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:01:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab1FJHBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:01:13 -0400
Message-ID: <4DF1C0DA.2090108@redhat.com>
Date: Fri, 10 Jun 2011 08:59:38 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        libusb-devel@lists.sourceforge.net, Alexander Graf <agraf@suse.de>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <20110610002103.GA7169@xanatos> <20110610031805.GA15774@kroah.com>
In-Reply-To: <20110610031805.GA15774@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hi,

>> The KVM folks suggested that it would be good to get USB and
>> virtualization developers together to talk about how to virtualize the
>> xHCI host controller.  The xHCI spec architect worked closely with
>> VMWare to get some extra goodies in the spec to help virtualization, and
>> I'd like to see the other virtualization developers take advantage of
>> that.  I'd also like us to hash out any issues they have been finding in
>> the USB core or xHCI driver during the virtualization effort.
>
> Do people really want to virtualize the whole xHCI controller, or just
> specific ports or devices to the guest operating system?

SR/IOV support is an optional xHCI feature.  As I understand it you can 
create a VF which looks like a real xHCI controller.  This is partly 
done in hardware and partly by software.  Then you can assign it some 
ressources (specific ports) and pass it to the guest.

> If just specific ports, would something like usbip be better for virtual
> machines, with the USB traffic going over the network connection between
> the guest/host?

There are several ways depending on the use case.  Usually the guest 
sees a (fully software emulated) host adapter with usb devices 
connected, where the usb devices can be (a) emulated too or (b) real usb 
devices passed through to the guest.  The later is done by passing the 
guests requests to the real device via usbfs.

One problem with emulating usb fully in software is the polling design 
of the hardware which makes the emulation quite cpu intensive.  Using a 
xHCI VF should help here alot, but works for the pass through use case 
only of course.

cheers,
   Gerd

