Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab0JEVuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:50:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48781 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab0JEVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:50:16 -0400
Date: Tue, 5 Oct 2010 22:50:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
Subject: Re: RFC: btusb firmware load help
Message-ID: <20101005215008.GA11117@srcf.ucam.org>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux> <20101005192814.GB11831@tux> <1286308731.2588.13.camel@aeonflux> <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 01:28:53PM -0700, Luis R. Rodriguez wrote:

> Right -- so ath3k depends on some atheros USB device IDs, and its a
> stupid driver that just loads firmware. The problem with this new
> device is that it requires two phases. One to load some sort of
> firmware onto it to get it to read as an ath3k device, and then ath3k
> will load the right firmware to it. So the hardware device is already
> claiming a btusb vendor:device ID, we can't change that I believe. Of
> course for future devices we can, and we've addressed this and its
> been fixed.

If the device IDs can be changed when the firmware is loaded, then 
simply provide a driver that binds to the original IDs and uploads the 
firmware. The original IDs can be blacklisted from btusb so it won't 
interfere. The device will then boot the firmware, detach and reattach 
with new IDs - btusb will then bind. Repeat for every cold reset.

If you can't change the IDs from firmware then an alternative would be 
to blacklist it from btusb and provide a userspace application triggered 
by a udev rule. Have it load the firmware and then poke 
/sys/bus/usb/drivers/btusb/new_id .

-- 
Matthew Garrett | mjg59@srcf.ucam.org
