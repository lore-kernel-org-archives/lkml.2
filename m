Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1BYMQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 07:16:37 -0500
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:56362 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158Ab1BYMQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 07:16:36 -0500
X-Greylist: delayed 1396 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Feb 2011 07:16:36 EST
To: linux-kernel@vger.kernel.org
Subject: modelling power supply / charging logic for ebook reader
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
Cc: Anton Vorontsov <cbou@mail.ru>
Date: Fri, 25 Feb 2011 12:53:08 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251253.10612.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Warning newbie questions :-)


I'm trying to implement charging logic for a device. As these are my first 
steps into the kernel I'd like to solicit opinions in which way to proceed.


Hardware: Qisda ebook-reader family - essentially every machine with an epaper 
display from Sipix - build around a s3c2416. Charger IC is a Texas Instruments 
bq24075 connected via gpios. The manufacturers used a fork of 2.6.21.5 and we 
try to make a current kernel usable on the devices.

Somewhere on lkml I read that reimplementing basic charger logic in yet 
another driver is not desired, so I'm looking at using the pda-power driver in 
combination with a simple bq2407x regulator driver based on Philipp Zabels 
driver for the bq24022.

The usb gadget driver has not OTG functionality and vbus detection is done via 
a special gpio. So it seems the gpio-vbus driver seems to be the driver to use 
for this.


Problems:

It's possible to connect the devices usb port to either a normal usb host or a 
dedicated charger with higher current. The charger type is read from 
some usb registers. So my question would be on how to model this with pda-
power.
The ac-part is propably not usable for this as it seems to require a different 
gpio-source. Is implementing some sort of "is_usb_aca"-hook a possible way


The charger also reports its charging status via a gpio. What's the best way 
to implement this with pda-power?
My current idea is to add an is_charging or supply_status hook to pda-power 
and if defined output this value via the get_property method and 
POWER_SUPPLY_STATUS_*.


Or as a complete alternative is it more reasonable to implement a new power-
supply for this and not add more switches to pda-power?
For example the pcf56033-charger driver has exactly this functionality but 
only for a specific device.

As many of the "gadget"-devices only have an usb port but different charging 
sources for it, is it reasonable to build some sort of generic "gadget-power" 
driver analogous to pda-power or does something of this sort exist?


Thanks for any input :-)
Heiko
