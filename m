Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab2KTO3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:29:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19210 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2KTO3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:29:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 20 Nov 2012 06:28:49 -0800
From: Ramalingam C <ramalingamc@nvidia.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>,
        "fabien.andre@gmail.com" <fabien.andre@gmail.com>,
        "scott.liu@emc.com.tw" <scott.liu@emc.com.tw>,
        Jean Delvare <khali@linux-fr.org>, JJ Ding <jj_ding@emc.com.tw>,
        Jiri Slaby <jslaby@suse.cz>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 20 Nov 2012 19:58:44 +0530
Subject: RE: [PATCH v3] i2c-hid: introduce HID over i2c specification
 implementation
Thread-Topic: [PATCH v3] i2c-hid: introduce HID over i2c specification
 implementation
Thread-Index: Ac3ECoRi2DKt1tG4S0y3Gc2hTx3aeQDH2qXw
Message-ID: <EC245B9844DE6242B3F3C3BED1ECD10F6D5A21CAC0@BGMAIL02.nvidia.com>
References: <1352731379-24683-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1211151450140.15877@pobox.suse.cz>
	<CAN+gG=FeNBzdbBcH6uSWB_rUOS6PjyjpVSuY3b--g1mXo17fXA@mail.gmail.com>
 <CAN+gG=Gm2JXur1HsL=-EEpahGZjqG5BQqoR6hpO8Dvsah0XyVg@mail.gmail.com>
In-Reply-To: <CAN+gG=Gm2JXur1HsL=-EEpahGZjqG5BQqoR6hpO8Dvsah0XyVg@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Benjamin Tissoires [mailto:benjamin.tissoires@gmail.com]
> Sent: Friday, November 16, 2012 8:26 PM
> To: Jiri Kosina; Ramalingam C
> Cc: Dmitry Torokhov; Stephane Chatty; fabien.andre@gmail.com;
> scott.liu@emc.com.tw; Jean Delvare; JJ Ding; Jiri Slaby; Shubhrajyoti Datta;
> linux-i2c@vger.kernel.org; linux-input@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v3] i2c-hid: introduce HID over i2c specification
> implementation
> 
> On Thu, Nov 15, 2012 at 3:04 PM, Benjamin Tissoires
> <benjamin.tissoires@gmail.com> wrote:
> > On Thu, Nov 15, 2012 at 2:51 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> >> On Mon, 12 Nov 2012, Benjamin Tissoires wrote:
> >>
> >>> Microsoft published the protocol specification of HID over i2c:
> >>> http://msdn.microsoft.com/en-
> us/library/windows/hardware/hh852380.as
> >>> px
> >>>
> >>> This patch introduces an implementation of this protocol.
> >>>
> >>> This implementation does not includes the ACPI part of the specification.
> >>> This will come when ACPI 5.0 devices enumeration will be available.
> >>>
> >>> Once the ACPI part is done, OEM will not have to declare HID over
> >>> I2C devices in their platform specific driver.
> >>>
> >>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> >>
> >> Out of curiosity -- has this been tested on a real device (is there
> >> any such device available anyway?), or is that just the
> >> implementation of the defined protocol?
> >
> > It has been tested on an ELAN microelectronics device (a prototype),
> > on an odroid-x board. That's how we figure out the bug in the
> > set_report command.
> > I think we manage to test all main features of the protocol
> > (get_report, irqs, hid descriptor, report descriptors, set_report).
> >
> > I'm currently waiting for a Synaptics touchpad to check if it's also
> > working with their devices.
> >
> > The thing is that HID over i2c for x86 platform will presumably
> > require the Haswell platform from Intel (we need ACPI 5 for
> > enumeration), but it would be very nice to get this in the kernel just
> > before hardware arrive on the market :) However, I won't be surprise
> > if android OEMs also start using this specification because it won't
> > force them to write kernel drivers...
> 
> And as a complement, Ramalingam tested it for Nvidia on an early NVIDIA's
> Tegra reference board for PISMO which is registered at
> http://www.arm.linux.org.uk/developer/machines/list.php?id=4439 , with a
> HID over i2c keyboard.
> He is up to test also his Synaptics touchpad.

I have tested with Synaptics trackpad. It is working fine. Thank you Benjamin.

Thanks and Regards,
Ramalingam C

> 
> Cheers,
> Benjamin
> 
> >
> > Cheers,
> > Benjamin
> >
> >>
> >> Thanks,
> >>
> >> --
> >> Jiri Kosina
> >> SUSE Labs
