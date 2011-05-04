Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab1EDOiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:38:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47134 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab1EDOip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:38:45 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
Date: Wed, 4 May 2011 20:08:30 +0530
Subject: RE: [PATCH v4 01/11] mfd: add pruss mfd driver.
Thread-Topic: [PATCH v4 01/11] mfd: add pruss mfd driver.
Thread-Index: AcwKK4ORaZk0u0+jREuxYQ1zPeubfQANNz2A
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024CD0B8CC@dbde02.ent.ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <201104271605.09537.arnd@arndb.de>
 <CF1FC9DE1796407FB4D636189646927F@subhasishg>
 <201104280935.38787.arnd@arndb.de>
 <2543A75FDDB244D2A148C14BCAA5FD88@subhasishg>
In-Reply-To: <2543A75FDDB244D2A148C14BCAA5FD88@subhasishg>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Subhasish,

On Wed, May 04, 2011 at 12:48:43, Subhasish Ghosh wrote:
> Hi Arnd,
> 
> How about just doing something like:
> 
> #> echo da8xx_pruss_uart >> firmware.bin
> 
> i.e  just append the device name (from the board file) into the firmware
> file.
> 
> In the driver probe, we can parse from the bottom, when it reaches
> "da8xx_pruss", the rest of the upper data is the firmware and from
> the full name, we can determine if it's a CAN, UART or any other
> peripheral.
> 
> So, based on the platform_data, which the MFD driver received,
> it can find out which device to initialize.

If you are defining a firmware header, it may be
worthwhile making sure you include information
on features of the device being supported (I
assume there will be differences in CAN features if
the firmware uses both PRUs to support CAN versus
UART on one PRU and CAN on another PRU).

The MFD driver can parse this information and
pass this on to the UART or CAN drivers.

Thanks,
Sekhar

> 
> Also, does the line wrapping look any better ?
> 
> 
> > On Thursday 28 April 2011 09:17:21 Subhasish Ghosh wrote:
> >> >
> >> > You can easily do that by adding a small header to the firmware
> >> > format and interpret that header by the MFD driver. When the name
> >> > of the subdevice is part of that header, the MFD driver does not
> >> > need to understand the difference, it can simply pass that on
> >> > when creating its child devices.
> >>
> >> I don't understand why loading the firmware should be done at the MFD
> >> driver.
> >> The user already specifies the device he/she wants to start on the PRU
> >> via
> >> modprobe.
> >> A driver can be inserted, which can download a printer firmware on one
> >> PRU
> >> and a
> >> scanner firmware on the other. This way both cores can be used for
> >> separate
> >> purposes.
> >> I mean, say in a real MFD controller, that will also have two separate
> >> cores
> >> running on it,
> >> just that, the firmware on it would not be downloaded runtime but fused
> >> in
> >> some non volatile memory.
> >
> > Then I must be misreading what your code currently does, because it does
> > not
> > match your explanations. What I see in the platform code is that you
> > create
> > MFD cells for specific devices that get automatically created by the MFD
> > driver. This will cause udev to load the drivers for these devices, which
> > then load the firmware they need.
> >
> > Also, I cannot see how the method you describe would make it possible to
> > the same driver into both units, e.g. when you want to have two serial
> > ports. The reason is that you currently hardcode the PRU number in the
> > driver and that you cannot load a single driver twice.
> >
> > Finally, I'm trying to make sure that whatever solution you come up with
> > will still work when we migrate the code to using a flattened device tree.
> > In that case, you would ideally put the device firmware into the device
> > tree as a property that matches whatever you have connected on the
> > specific
> > board (at least as an option, you can still fall back to
> > request_firmware).
> > You definitely want automatic module loading in that case.
> >
> > Note that using module loading with specific parameters in order to
> > match the hardware is not a recommended procedure any more. The code
> > really needs to work the same way when all drivers are built into the
> > kernel. It should not be hard to use the firmware loading mechanism
> > in the MFD driver to both load the firmware and configure the devices
> > appropriately so we always use the right driver for the currently
> > active devices.
> >
> > Arnd
> >
> > BTW, something is wrong with your email client line wrapping. I've fixed
> > this up manually before when replying, but please find a way to get this
> > right in the future. 
> 
> 

