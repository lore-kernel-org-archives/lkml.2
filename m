Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1DSODF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:03:05 -0400
Received: from kroah.org ([198.145.64.141]:57401 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1DSODC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:03:02 -0400
Date: Tue, 19 Apr 2011 07:02:57 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, George Kashperko <george@znau.edu.ua>,
        Hauke Mehrtens <hauke@hauke-m.de>, Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
Message-ID: <20110419140257.GA20456@kroah.com>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
 <1302892585.30441.12.camel@dev.znau.edu.ua>
 <BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com>
 <201104171938.12834.arnd@arndb.de>
 <op.vt6ufu1n3ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vt6ufu1n3ri7v4@arend-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 03:58:32PM +0200, Arend van Spriel wrote:
> On Sun, 17 Apr 2011 19:38:12 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> Hi Rafał,
> 
> As you probably expected I tried to integrate and use your bcmai/bcmaxi/?
> driver with our brcm80211 driver (making progress). In the mean time
> I tried to follow the discussions going on, but I am still catching
> up.
> 
> >Compare this to the PCI bus type, which essentially deals with devices
> >that have a PCI configuration space that contains generic (irq, memory,
> >vendor/device ID, ...) registers along with device specific registers.
> 
> How much alike is the (BCM)AXI bus type? My assumption was that each
> registered PCI device is handled by a single driver module. In the
> current(?) bcmai implementation each device driver is called with the
> appropriate device structure reference, but it will also have the bus
> structure reference and through that can also access other cores on the
> (bcm)axi bus. This seems to me a potential issue when there are no
> synchronization mechanisms in place (whether in a SoC configuration or
> PCI-hosted). Does the PCI bus type allow driver for device A access
> device B?
> 
> >A new bus_type really only makes sense if you expect a lot of devices
> >to use this and you want to have the probing in the bus. If you only
> >want to have a way to enumerate devices that get created by the
> >parent driver, you can also use platform devices.
> 
> The main assumption of the (bcm)axi driver seems to be that each core can
> be considered as a device. Correct me if I am wrong, but I consider a
> device to be an entity providing a particular system function. So an
> ethernet device provides ethernet connectivity function, a mixer device
> provides sound mixing function, and so on. The cores within a chip are not
> always self-contained like this. To clarify let's say a system function is
> realized by programming core A, core B, and finally trigger core A to set
> the function in motion. This implies the need of coordination between the
> programming steps on those cores.
> 
> Is my view on what is a device wrong? Does a platform device differ in
> this respect from a regular device?

Please don't use a platform device, unless there is no other way for
your device to work.  For this device, you are connected to the PCI bus,
so a platform device does not make sense at all.

thanks,

greg k-h
