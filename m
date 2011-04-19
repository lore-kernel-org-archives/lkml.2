Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1DSN6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:58:50 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4111 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab1DSN6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:58:48 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>
cc: "George Kashperko" <george@znau.edu.ua>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Jonas Gorski" <jonas.gorski@gmail.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "Greg KH" <greg@kroah.com>, "Andy Botting" <andy@andybotting.com>,
        "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom
 bus?
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
 <1302892585.30441.12.camel@dev.znau.edu.ua>
 <BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com>
 <201104171938.12834.arnd@arndb.de>
Date: Tue, 19 Apr 2011 15:58:32 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vt6ufu1n3ri7v4@arend-laptop>
In-Reply-To: <201104171938.12834.arnd@arndb.de>
User-Agent: Opera Mail/11.10 (Linux)
X-WSS-ID: 61B34A4E3I813626422-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Apr 2011 19:38:12 +0200, Arnd Bergmann <arnd@arndb.de> wrote:

Hi Rafał,

As you probably expected I tried to integrate and use your bcmai/bcmaxi/?
driver with our brcm80211 driver (making progress). In the mean time I  
tried to follow the discussions going on, but I am still catching up.

> Compare this to the PCI bus type, which essentially deals with devices
> that have a PCI configuration space that contains generic (irq, memory,
> vendor/device ID, ...) registers along with device specific registers.

How much alike is the (BCM)AXI bus type? My assumption was that each
registered PCI device is handled by a single driver module. In the
current(?) bcmai implementation each device driver is called with the
appropriate device structure reference, but it will also have the bus
structure reference and through that can also access other cores on the
(bcm)axi bus. This seems to me a potential issue when there are no
synchronization mechanisms in place (whether in a SoC configuration or
PCI-hosted). Does the PCI bus type allow driver for device A access
device B?

> A new bus_type really only makes sense if you expect a lot of devices
> to use this and you want to have the probing in the bus. If you only
> want to have a way to enumerate devices that get created by the
> parent driver, you can also use platform devices.

The main assumption of the (bcm)axi driver seems to be that each core can
be considered as a device. Correct me if I am wrong, but I consider a
device to be an entity providing a particular system function. So an
ethernet device provides ethernet connectivity function, a mixer device
provides sound mixing function, and so on. The cores within a chip are not
always self-contained like this. To clarify let's say a system function is
realized by programming core A, core B, and finally trigger core A to set
the function in motion. This implies the need of coordination between the
programming steps on those cores.

Is my view on what is a device wrong? Does a platform device differ in
this respect from a regular device?

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

