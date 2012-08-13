Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2HMUWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:22:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2HMUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:22:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Feng Tang <feng.tang@intel.com>, Thomas Renninger <trenn@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>
Subject: [ 38/82] ACPI processor: Fix tick_broadcast_mask online/offline regression
Date: Mon, 13 Aug 2012 13:19:14 -0700
Message-Id: <20120813201749.764341331@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit b7db60f45d74497c723dc7ae1370cf0b37dfb0d8 upstream.

In commit 99b725084 "ACPI processor hotplug: Delay acpi_processor_start()
call for hotplugged cores", acpi_processor_hotplug(pr) was wrongly replaced
by acpi_processor_cst_has_changed() inside the acpi_cpu_soft_notify(). This
patch will restore it back, fixing the tick_broadcast_mask regression:
	https://lkml.org/lkml/2012/7/30/169

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/processor_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -442,7 +442,7 @@ static int acpi_cpu_soft_notify(struct n
 		/* Normal CPU soft online event */
 		} else {
 			acpi_processor_ppc_has_changed(pr, 0);
-			acpi_processor_cst_has_changed(pr);
+			acpi_processor_hotplug(pr);
 			acpi_processor_reevaluate_tstate(pr, action);
 			acpi_processor_tstate_has_changed(pr);
 		}


