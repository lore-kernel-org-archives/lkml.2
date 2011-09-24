Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1IXGUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 02:20:33 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:48776 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1IXGUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 02:20:31 -0400
Date: Sat, 24 Sep 2011 00:20:30 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
cc: "Cousson, Benoit" <b-cousson@ti.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Subject: Re: [PATCH 1/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <CAP05o4+DT8hL8A_e6WBpV9ptZ4XYYKgM=UQa8uiRH2ox6ZP-4A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1109232354360.22872@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221213500.10719@utopia.booyaka.com> <4E7B8C68.7020407@ti.com> <alpine.DEB.2.00.1109221524560.10719@utopia.booyaka.com>
 <CAP05o4+DT8hL8A_e6WBpV9ptZ4XYYKgM=UQa8uiRH2ox6ZP-4A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-81626102-1316844238=:22872"
Content-ID: <alpine.DEB.2.00.1109240013070.22872@utopia.booyaka.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-81626102-1316844238=:22872
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1109240013071.22872@utopia.booyaka.com>

Hi

On Fri, 23 Sep 2011, Munegowda, Keshava wrote:

> Paul Walmsley <paul@pwsan.com> wrote:
>
> > So I'd suggest one of two approaches:
> >
> > 1. If the pin muxing can follow the PM runtime status of the UHH IP blo=
ck,
> > =A0 then the pin mux data should be associated with the UHH hwmod.
>=20
> No, the mux is applicable only to ehci and ohci , where as sysconfig is=
=20
> applicable to uhh ( usb_host_hs class).

My point is that, as far as I can tell, I/O pad wakeup (caused by USB=20
remote wakeup) is only going to matter when the entire UHH IP block has=20
its clocks cut.  Otherwise, while the UHH is clocked, the EHCI and/or OHCI=
=20
IP blocks will also be clocked, so no I/O pad wakeup will be needed. Do=20
you agree?

> > 2. If the pin muxing must follow the EHCI/OHCI IP block PM runtime stat=
us,
> > =A0 then drivers/mfd/omap-usb-host.c is what should be handling the
> > =A0 remuxing. =A0omap-usb-host.c can set the dev_pm_ops of the EHCI/OHC=
I
> > =A0 platform_devices to point to functions either in
> > =A0 arch/arm/mach-omap2/usb-host.c, or local functions that call into
> > =A0 mach-omap2/usb-host.c functions to handle pin remuxing. =A0(Those
> > =A0 function pointers should be provided to the MFD driver in some clea=
n way,
> > =A0 like via platform_data.)
>=20
> The dev_pm_ops of ehci should exist in /drivers/usb/host/ehci-omap.c and=
=20
> dev_pm_ops of phci should exist in /drivers/usb/host/ohci-omap3.c. In=20
> the existing design, the omap-usb-host.c host can not access the=20
> platform driver of ehci and ohci. But, through function pointers it is=20
> possible to send the platform data to ehci and ohci drivers to handle=20
> pin remuxing; but we will not able to use tero's patches; and it will=20
> prevent our future design activity for remote wakeup of ehci and ohci.

Could you please explain in more detail why the dynamic remuxing can't=20
be done when the UHH enters or exits idle?


- Paul
--155748971-81626102-1316844238=:22872--
