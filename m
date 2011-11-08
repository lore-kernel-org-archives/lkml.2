Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab1KHO6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:58:21 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:37972 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932665Ab1KHO6S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:58:18 -0500
MIME-Version: 1.0
In-Reply-To: <20111108120635.GA2531@xps8300>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
	<CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
	<20111108120635.GA2531@xps8300>
Date: Tue, 8 Nov 2011 20:28:15 +0530
Message-ID: <CAAe_U6KVvpJBe2nHzpyMN7iT6Q+1JJd5zfGUu99hq=agEjz1jQ@mail.gmail.com>
Subject: Re: [PATCHv6 01/19] usb: otg: Rename otg_transceiver to usb_phy
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 5:36 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> Hi,
>
> On Tue, Nov 08, 2011 at 11:27:12AM +0530, ABRAHAM, KISHON VIJAY wrote:
>> Hi Heikki,
>>
>> I tend to defer with your opinion of renaming otg_transceiver to
>> usb_phy. According to me otg_transceiver should program hardware
>> mechanisms associated to VBUS, ID lines, etc.. and phy is responsible
>> for transmitting data over differential data lines (with its own
>> programming of phy_init, phy_shutdown, setting phy clocks etc..). So
>> in my opinion otg_transceiver and usb_phy should be two different and
>> separate entities.
>
> Maybe I'm misunderstanding you, but sounds like you are still marrying
> OTG with transceivers.
I'm against the idea of usb_phy married with the transceiver (i.e
transceiver = twl6030 for instance)
>
> Things like the otg_transceiver are dropped. The idea is to have the
> OTG utility independent of any hardware. OTG does not need to be tied
> to a transceiver or to a controller.
But currently most of OTG function pointers operates on the
transceiver. Pls see my comment for [PATCHv6 12/19] usb: otg: twl6030:
Start using struct usb_otg for a little more explanation.
>
> On most platforms the controller is perfectly capable of handling any
> OTG related function without any need for the software to program the
> PHY, so functions like "drive VBUS" will in practice be implemented by
> the controller driver. There may not be PHY driver at all but OTG is
> still supported.
>
> If on your platform the PHY needs to be programmed in order to drive
> VBUS, or handle some other OTG function, then your PHY driver will
> fill the hooks in your struct usb_otg.
The PHY driver shouldn't do any OTG function. According to me, the PHY
driver should take care of only phy_int, phy_shutdown, phy_suspend.

The utility does not need to
> care which driver implements these hooks.
>
>> I would have preferred to rename otg_transceiver as usb_otg as the
>> first step. (this differs from your implementation where you rename
>> otg_transceiver to usb_phy and create a new structure usb_otg to
>> separate otg members from usb_phy).
>>
>> But it should have been first  rename otg_transceiver as usb_otg. Then
>> create a new structure usb_phy to move all the phy specific
>> implementation there. This kind of implementation will also help when
>> we want to have independent phy drivers.
>
> This would not have changed the outcome.

It would have :-) I could have directly taken your patch and
implemented independent PHY drivers (thats not tied to any
transceivers).

Thanks
Kishon
>
> Oh, and keep in mind that this really is only the first step in this
> rework. After this the idea is to provide support for multiple
> transceivers and move USB PHY structures and functions into separate
> files from OTG. The final step, and my ultimate goal, is implementing
> a generic OTG state machine for the OTG utility.
>
> Br,
>
> --
> heikki
>
