Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2FMVug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:50:36 -0400
Received: from h1749472.stratoserver.net ([85.214.139.110]:36909 "EHLO
	h1749472.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2FMVuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:50:35 -0400
X-Greylist: delayed 1890 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2012 17:50:35 EDT
Message-ID: <4FD903BC.3040200@xorn.org>
Date: Wed, 13 Jun 2012 23:18:52 +0200
From: Dennis Gnad <dennis@xorn.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 78.42.27.74
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: dennis@xorn.org
Subject: USB issues on Fujitsu T2020 since a424948dde8421089826e2f782d0efe9e565707e
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on h1749472.stratoserver.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit a424948dde8421089826e2f782d0efe9e565707e (see below), and
still in Kernel 3.4.2, USB will not work at all when the power controls
of the according PCI device and in the usb subdirectory are set to "auto".
For example:
echo auto > /sys/devices/pci0000:00/0000:00:1a.7/power/control
echo auto > /sys/devices/pci0000:00/0000:00:1a.7/usb1/power/control

It only stops working when *both* are set to "auto". This is also
triggered by the tunables of the powertop program.

Tested on a Fujitsu Lifebook T2020.

If this behavior is not specific to this notebook, the commit should
maybe get reverted?

Thanks for any comment!
 -Dennis


a424948dde8421089826e2f782d0efe9e565707e is the first bad commit
commit a424948dde8421089826e2f782d0efe9e565707e
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Nov 6 22:21:46 2011 +0100

    PCI/ACPI/PM: Avoid resuming devices that don't signal PME

    Modify pci_acpi_wake_dev() to avoid resuming PME-capable devices
    whose PME Status bits are not set, which may happen currently if
    several devices are associated with the same wakeup GPE and all
    of them are notified whenever at least one of them signals PME.

    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

:040000 040000 bd5d78ae9ff2b75713725ed6e16d997b0017937d
f801b576ab380baa48b8c19523323aa6cca0b8cb M      drivers
