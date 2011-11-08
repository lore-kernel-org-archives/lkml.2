Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab1KHF5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 00:57:16 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:54332 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234Ab1KHF5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 00:57:14 -0500
MIME-Version: 1.0
In-Reply-To: <1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
Date: Tue, 8 Nov 2011 11:27:12 +0530
Message-ID: <CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
Subject: Re: [PATCHv6 01/19] usb: otg: Rename otg_transceiver to usb_phy
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heikki,

On Fri, Oct 28, 2011 at 6:05 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> This is the first step in separating USB transceivers from
> USB OTG utilities.
>
> Includes fixes to IMX code from Sascha Hauer.

I tend to defer with your opinion of renaming otg_transceiver to
usb_phy. According to me otg_transceiver should program hardware
mechanisms associated to VBUS, ID lines, etc.. and phy is responsible
for transmitting data over differential data lines (with its own
programming of phy_init, phy_shutdown, setting phy clocks etc..). So
in my opinion otg_transceiver and usb_phy should be two different and
separate entities.

I would have preferred to rename otg_transceiver as usb_otg as the
first step. (this differs from your implementation where you rename
otg_transceiver to usb_phy and create a new structure usb_otg to
separate otg members from usb_phy).

But it should have been first  rename otg_transceiver as usb_otg. Then
create a new structure usb_phy to move all the phy specific
implementation there. This kind of implementation will also help when
we want to have independent phy drivers.

Thanks
Kishon
