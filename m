Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936058Ab2C3V0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:26:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966253Ab2C3VWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:22:49 -0400
Message-Id: <20120330194849.674681933@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andre Przywara <andre.przywara@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 119/175] hwmon: (fam15h_power) Correct sign extension of running_avg_capture
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit fc0900cbda9243957d812cd6b4cc87965f9fe75f upstream.

Wrong bit was used for sign extension which caused wrong end results.
Thanks to Andre for spotting this bug.

Reported-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/fam15h_power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -60,7 +60,7 @@ static ssize_t show_power(struct device
 	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
 				  REG_TDP_RUNNING_AVERAGE, &val);
 	running_avg_capture = (val >> 4) & 0x3fffff;
-	running_avg_capture = sign_extend32(running_avg_capture, 22);
+	running_avg_capture = sign_extend32(running_avg_capture, 21);
 	running_avg_range = val & 0xf;
 
 	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),


