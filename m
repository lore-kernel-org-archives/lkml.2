Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab2E0BIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:08:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762Ab2E0BII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:08:08 -0400
Message-Id: <20120527010427.857363446@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:52 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 29/94] libata: forbid port runtime pm by default, fixing regression
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ming <ming.m.lin@intel.com>

commit 0c8d32c27f5cf6e14ca14b4758d1e994eebd50fd upstream.

Forbid port runtime pm by default because it has known hotplug issue.
User can allow it by, for example

echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata2/power/control

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-transport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -294,6 +294,7 @@ int ata_tport_add(struct device *parent,
 	device_enable_async_suspend(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
+	pm_runtime_forbid(dev);
 
 	transport_add_device(dev);
 	transport_configure_device(dev);


