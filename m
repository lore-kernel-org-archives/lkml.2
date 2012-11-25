Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2KYSlH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 13:41:07 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42727 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2KYSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 13:41:04 -0500
Date: Sun, 25 Nov 2012 10:42:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, "Svahn, Kai" <kai.svahn@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] platform / ACPI: Attach/detach ACPI PM during
 probe/remove/shutdown
Message-ID: <20121125184225.GA1423@kroah.com>
References: <1672179.qgDUs0YdYu@vostro.rjw.lan>
 <6227446.8xPtqi6yHi@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6227446.8xPtqi6yHi@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2012 at 03:58:14PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Drivers usually expect that the devices they are supposed to handle
> will be operational when their .probe() routines are called, but that
> need not be the case on some ACPI-based systems with ACPI-based
> device enumeration where the BIOSes don't put devices into D0 by
> default.  To work around this problem it is sufficient to change
> bus type .probe() routines to ensure that devices will be powered
> on before the drivers' .probe() routines run (and their .remove()
> and .shutdown() routines accordingly).
> 
> Modify platform_drv_probe() to run acpi_dev_pm_attach() for devices
> whose ACPI handles are present, so that ACPI power management is used
> to change their power states and change their power states to D0
> before driver probing.  Analogously, modify platform_drv_remove() and
> platform_drv_shutdown() to call acpi_dev_pm_detach() for those
> devices, so that they are not subject to ACPI PM any more.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
