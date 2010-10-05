Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0JET2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:28:18 -0400
Received: from mail.atheros.com ([12.19.149.2]:35510 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab0JET2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:28:16 -0400
Date: Tue, 5 Oct 2010 12:28:14 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Subject: Re: RFC: btusb firmware load help
Message-ID: <20101005192814.GB11831@tux>
References: <20100924230730.GB6566@tux>
 <1286266981.17473.33.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286266981.17473.33.camel@aeonflux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 01:23:01AM -0700, Marcel Holtmann wrote:
> Hi Luis,
> 
> > Marcel, I was just poked about this thread:
> > 
> > http://www.spinics.net/lists/linux-bluetooth/msg06087.html
> > 
> > The hack is required because our BT hardware does not accept HCI commands
> > when the device is plugged in. If I understood your position you did not
> > want to accept the patch because our BT USB devices are violating the
> > specification by not acceping HCI commands and yet claiming to be BT
> > devices, is that right?
> 
> you don't have to accept HCI commands when your device has no firmware
> loaded. That is just fine. However at that point you should not claim to
> be a Bluetooth H:2 device with USB Bluetooth descriptors.
> 
> Just having different USB PIDs for without firmware and with firmware
> stages would have been fine. The ancient Broadcom 203x devices even got
> that part right.

Ah I see.

> So what about sticking with the current VID:PID for the device without
> firmware and we blacklist it in btusb driver. And then the firmware
> loading ensures that after reset it uses a different PID for the device
> with valid HCI firmware.

How would firmware be uploaded to the device if no module
is claiming it?

  Luis
