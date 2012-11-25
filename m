Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2KYTxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 14:53:15 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:36530 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab2KYTxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 14:53:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, "Svahn, Kai" <kai.svahn@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] platform / ACPI: Attach/detach ACPI PM during probe/remove/shutdown
Date: Sun, 25 Nov 2012 20:57:46 +0100
Message-ID: <41045610.NbbIJWgXLK@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121125184225.GA1423@kroah.com>
References: <1672179.qgDUs0YdYu@vostro.rjw.lan> <6227446.8xPtqi6yHi@vostro.rjw.lan> <20121125184225.GA1423@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 25, 2012 10:42:25 AM Greg Kroah-Hartman wrote:
> On Sun, Nov 25, 2012 at 03:58:14PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Drivers usually expect that the devices they are supposed to handle
> > will be operational when their .probe() routines are called, but that
> > need not be the case on some ACPI-based systems with ACPI-based
> > device enumeration where the BIOSes don't put devices into D0 by
> > default.  To work around this problem it is sufficient to change
> > bus type .probe() routines to ensure that devices will be powered
> > on before the drivers' .probe() routines run (and their .remove()
> > and .shutdown() routines accordingly).
> > 
> > Modify platform_drv_probe() to run acpi_dev_pm_attach() for devices
> > whose ACPI handles are present, so that ACPI power management is used
> > to change their power states and change their power states to D0
> > before driver probing.  Analogously, modify platform_drv_remove() and
> > platform_drv_shutdown() to call acpi_dev_pm_detach() for those
> > devices, so that they are not subject to ACPI PM any more.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
