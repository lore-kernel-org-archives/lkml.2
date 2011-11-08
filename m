Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1KHMGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:06:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:27893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1KHMGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:06:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,476,1315206000"; 
   d="scan'208";a="82393713"
Date: Tue, 8 Nov 2011 14:06:35 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCHv6 01/19] usb: otg: Rename otg_transceiver to usb_phy
Message-ID: <20111108120635.GA2531@xps8300>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
 <CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 08, 2011 at 11:27:12AM +0530, ABRAHAM, KISHON VIJAY wrote:
> Hi Heikki,
> 
> I tend to defer with your opinion of renaming otg_transceiver to
> usb_phy. According to me otg_transceiver should program hardware
> mechanisms associated to VBUS, ID lines, etc.. and phy is responsible
> for transmitting data over differential data lines (with its own
> programming of phy_init, phy_shutdown, setting phy clocks etc..). So
> in my opinion otg_transceiver and usb_phy should be two different and
> separate entities.

Maybe I'm misunderstanding you, but sounds like you are still marrying
OTG with transceivers. The struct usb_phy is independent of OTG.

Things like the otg_transceiver are dropped. The idea is to have the
OTG utility independent of any hardware. OTG does not need to be tied
to a transceiver or to a controller.

On most platforms the controller is perfectly capable of handling any
OTG related function without any need for the software to program the
PHY, so functions like "drive VBUS" will in practice be implemented by
the controller driver. There may not be PHY driver at all but OTG is
still supported.

If on your platform the PHY needs to be programmed in order to drive
VBUS, or handle some other OTG function, then your PHY driver will
fill the hooks in your struct usb_otg. The utility does not need to
care which driver implements these hooks.

> I would have preferred to rename otg_transceiver as usb_otg as the
> first step. (this differs from your implementation where you rename
> otg_transceiver to usb_phy and create a new structure usb_otg to
> separate otg members from usb_phy).
> 
> But it should have been first  rename otg_transceiver as usb_otg. Then
> create a new structure usb_phy to move all the phy specific
> implementation there. This kind of implementation will also help when
> we want to have independent phy drivers.

This would not have changed the outcome.

Oh, and keep in mind that this really is only the first step in this
rework. After this the idea is to provide support for multiple
transceivers and move USB PHY structures and functions into separate
files from OTG. The final step, and my ultimate goal, is implementing
a generic OTG state machine for the OTG utility.

Br,

-- 
heikki
