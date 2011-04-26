Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1DZQHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:07:15 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:44118
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752584Ab1DZQHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:07:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code 
Date: Tue, 26 Apr 2011 09:19:45 -0700
Message-Id: <1303834785-4981-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set addresses some of the bus/driver model cleanup that
Greg sugested over the last couple of days.  In this patch-set we
deal with the following issues:

	1) Cleanup unnecessary state in struct hv_device and 
	   struct hv_driver to be compliant with the Linux
	   Driver model.

	2) Cleanup the vmbus_match() function to conform with the 
	   Linux Driver model.

	3) Cleanup error handling in the vmbus_probe() and 
	   vmbus_child_device_register() functions. Fixed a 
	   bug in the probe failure path as part of this cleanup.

	4) The Windows host cannot handle the vmbus_driver being 
	   unloaded and subsequently loaded. Cleanup the driver with
	   this in mind.

	5) Get rid of struct hv_bus that embedded struct bus_type to 
	   conform with the LDM.

	6) Add probe/remove/shutdown functions to struct hv_driver to
	   conform to LDM.

	7) On some older Hyper-V hosts, the Linux PCI sub-sytem is not able
	   to allocate irq resources to the vmbus driver. I recently learnt
	   that the vmbus driver is an acpi enumerated device on the Hyper-V
	   platform. Added code to retrieve irq information from DSDT.



Regards,

K. Y
