Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab0JFHJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:09:33 -0400
Received: from senator.holtmann.net ([87.106.208.187]:50894 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab0JFHJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:09:31 -0400
Subject: Re: RFC: btusb firmware load help
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
In-Reply-To: <20101005215008.GA11117@srcf.ucam.org>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux>
	 <20101005192814.GB11831@tux> <1286308731.2588.13.camel@aeonflux>
	 <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com>
	 <20101005215008.GA11117@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 09:09:25 +0200
Message-ID: <1286348965.6145.1.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

> > Right -- so ath3k depends on some atheros USB device IDs, and its a
> > stupid driver that just loads firmware. The problem with this new
> > device is that it requires two phases. One to load some sort of
> > firmware onto it to get it to read as an ath3k device, and then ath3k
> > will load the right firmware to it. So the hardware device is already
> > claiming a btusb vendor:device ID, we can't change that I believe. Of
> > course for future devices we can, and we've addressed this and its
> > been fixed.
> 
> If the device IDs can be changed when the firmware is loaded, then 
> simply provide a driver that binds to the original IDs and uploads the 
> firmware. The original IDs can be blacklisted from btusb so it won't 
> interfere. The device will then boot the firmware, detach and reattach 
> with new IDs - btusb will then bind. Repeat for every cold reset.
> 
> If you can't change the IDs from firmware then an alternative would be 
> to blacklist it from btusb and provide a userspace application triggered 
> by a udev rule. Have it load the firmware and then poke 
> /sys/bus/usb/drivers/btusb/new_id .

exactly, we just blacklist the original USB IDs in the btusb driver. It
already has a blacklist table and you just use BTUSB_IGNORE in there.

Regards

Marcel


