Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1DLTAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:00:07 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:16563 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1DLTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:00:05 -0400
X-MDAV-Processed: mail.academy.zt.ua, Tue, 12 Apr 2011 21:50:25 +0300
X-Spam-Processed: mail.academy.zt.ua, Tue, 12 Apr 2011 21:50:23 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: George Kashperko <george@znau.edu.ua>
To: balbi@ti.com
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
In-Reply-To: <20110412133633.GR15130@legolas.emea.dhcp.ti.com>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	 <20110412133633.GR15130@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 12 Apr 2011 21:47:19 +0300
Message-Id: <1302634039.14216.10.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi,
> 
> On Tue, Apr 12, 2011 at 01:57:07AM +0200, Rafał Miłecki wrote:
> > Cc: Michael Büsch <mb@bu3sch.de>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: George Kashperko <george@znau.edu.ua>
> > Cc: Arend van Spriel <arend@broadcom.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: Russell King <rmk@arm.linux.org.uk>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Andy Botting <andy@andybotting.com>
> > Cc: linuxdriverproject <devel@linuxdriverproject.org>
> > Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> > Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> > ---
> > V2: Rename to axi
> >     Use DEFINE_PCI_DEVICE_TABLE in bridge
> >     Make use of pr_fmt and pr_*
> >     Store core class
> >     Rename bridge to not b43 specific
> >     Replace magic 0x1000 with BCMAI_CORE_SIZE
> >     Remove some old "ssb" names and defines
> >     Move BCMAI_ADDR_BASE def
> >     Add drvdata field
> > V3: Fix reloading (kfree issue)
> >     Add 14e4:0x4331
> >     Fix non-initialized struct issue
> >     Drop useless inline functions wrappers for pci core drv
> >     Proper pr_* usage
> > V3.1: Include forgotten changes (pr_* and include related)
> >     Explain why we dare to implement empty release function
> 
> I'm not sure we need this. If you have an IP Core which talks AXI and
> you want to put it on a PCI bus, you will have a PCI Bus wrapper around
> that IP Core, so you should go and let the kernel know about that. See
> [1] for a core IP which talks AXI and [2] for a PCI bus glue layer.
> 
> Besides, if you introduce this bus layer, it'll be more difficult for
> other licensees of the same core to re-use the same driver, since it's
> now talking a PCI emulated on top of AXI. The same can be achieved with
> the platform_bus which is more widely used, specially on ARM SoCs.
> 
> [1] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/core.c
> [2] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/dwc3-haps.c
> 

Already noticed earlier that AXI isnt really good name for
Broadcom-specific axi bus customization. As of tech docs available from
arm, corelink AXI cores use own identification registers which feature
different format and layout comparing to that we use for Broadcom cores.

Maybe there is something "standartized" by the DMP specs? If so I'm
curious if that DMP is obligatory for every axi bus ?

Naming particular Broadcom's implementation just axi limits other
licensees in reusing axi bus name/code or will require hacks/workarounds
from them to fit Broadcom-like core scanning/identificating techniques.
You use bus named AXI to group and manage Broadcom cores, while never
even publish device records for native axi cores Broadcom use to talk to
the interconnect through. Yet again, something like bcmb/bcmai looks
like better name for this bus.

Also can't figure out how is this implementation supposed to manage
multicore devices.

Any plans on embeddables' support ?

Have nice day,
George


