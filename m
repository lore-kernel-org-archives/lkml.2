Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab0JET67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:58:59 -0400
Received: from senator.holtmann.net ([87.106.208.187]:59185 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0JET65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:58:57 -0400
Subject: Re: RFC: btusb firmware load help
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
In-Reply-To: <20101005192814.GB11831@tux>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux>
	 <20101005192814.GB11831@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 21:58:51 +0200
Message-ID: <1286308731.2588.13.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> > > Marcel, I was just poked about this thread:
> > > 
> > > http://www.spinics.net/lists/linux-bluetooth/msg06087.html
> > > 
> > > The hack is required because our BT hardware does not accept HCI commands
> > > when the device is plugged in. If I understood your position you did not
> > > want to accept the patch because our BT USB devices are violating the
> > > specification by not acceping HCI commands and yet claiming to be BT
> > > devices, is that right?
> > 
> > you don't have to accept HCI commands when your device has no firmware
> > loaded. That is just fine. However at that point you should not claim to
> > be a Bluetooth H:2 device with USB Bluetooth descriptors.
> > 
> > Just having different USB PIDs for without firmware and with firmware
> > stages would have been fine. The ancient Broadcom 203x devices even got
> > that part right.
> 
> Ah I see.
> 
> > So what about sticking with the current VID:PID for the device without
> > firmware and we blacklist it in btusb driver. And then the firmware
> > loading ensures that after reset it uses a different PID for the device
> > with valid HCI firmware.
> 
> How would firmware be uploaded to the device if no module
> is claiming it?

most likely via a separate firmware loading driver. Your ath3k driver is
such a driver. Same as the bcm203x driver. They don't do anything than
claiming that USB device, loading the firmware, and then let it reset.

And after the reset the btusb can claim the one where the firmware has
been loaded and which behaves like a proper USB dongle.

The part that I don't understand is that you have the ath3k driver doing
it exactly how it should be done, why now started to make nasty hacks in
the btusb driver.

Regards

Marcel


