Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2JRN5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:57:47 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:56853 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754818Ab2JRN5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:57:46 -0400
X-Greylist: delayed 3634 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2012 09:57:46 EDT
Message-ID: <1350565015.23730.4.camel@thor>
Subject: [PATCH 0/1] staging: Add firewire-serial driver
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Date: Thu, 18 Oct 2012 08:56:55 -0400
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider this serial driver for review for submission to staging.
The firewire-serial driver implements TTY over IEEE 1394. In its default
configuration, it creates 4 TTY devices and one loopback device per
firewire card (respectively, named fwtty<n>~fwtty<n+3> and fwloop<n>).

Currently, the TTY devices auto-connect to every cabled peer (the TODO
list includes plans for providing a sysfs interface to control virtual
cabling with whitelist/blacklist support per GUID).

Efforts are still ongoing for a companion console driver, with plans to
eventually add early_printk & kgdb support (via additional drivers).

Some issues did arise with both the TTY and Firewire subsystems which
are noted in the TODO file. Please review these workarounds.

Peter Hurley (1):
  staging: fwserial: Add TTY-over-Firewire serial driver

 drivers/staging/Kconfig             |    2 +
 drivers/staging/Makefile            |    1 +
 drivers/staging/fwserial/Kconfig    |    9 +
 drivers/staging/fwserial/Makefile   |    2 +
 drivers/staging/fwserial/TODO       |   89 ++
 drivers/staging/fwserial/dma_fifo.c |  310 ++++
 drivers/staging/fwserial/dma_fifo.h |  130 ++
 drivers/staging/fwserial/fwserial.c | 2885 +++++++++++++++++++++++++++++++++++
 drivers/staging/fwserial/fwserial.h |  355 +++++
 9 files changed, 3783 insertions(+)
 create mode 100644 drivers/staging/fwserial/Kconfig
 create mode 100644 drivers/staging/fwserial/Makefile
 create mode 100644 drivers/staging/fwserial/TODO
 create mode 100644 drivers/staging/fwserial/dma_fifo.c
 create mode 100644 drivers/staging/fwserial/dma_fifo.h
 create mode 100644 drivers/staging/fwserial/fwserial.c
 create mode 100644 drivers/staging/fwserial/fwserial.h

-- 
1.7.12.3



