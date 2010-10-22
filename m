Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab0JVS5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:57:11 -0400
Received: from kroah.org ([198.145.64.141]:34396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759422Ab0JVS5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:34 2010
Message-Id: <20101022185234.886620835@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <len.brown@intel.com>
Subject: [084/103] ACPI: Handle ACPI0007 Device in acpi_early_set_pdc
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit c1e0ddbf0a97e1704d7f13b4934f9acca002402d upstream.

After
| commit d8191fa4a33fdc817277da4f2b7f771ff605a41c
| Author: Alex Chiang <achiang@hp.com>
| Date:   Mon Feb 22 12:11:39 2010 -0700
|
|    ACPI: processor: driver doesn't need to evaluate _PDC
|
|    Now that the early _PDC evaluation path knows how to correctly
|    evaluate _PDC on only physically present processors, there's no
|    need for the processor driver to evaluate it later when it loads.
|
|    To cover the hotplug case, push _PDC evaluation down into the
|    hotplug paths.

only cpu with Processor Statement get processed with _PDC

If bios is using Device object instead of Processor statement.
SSDTs for Pstate/Cstate/Tstate can not be loaded dynamically.

Need to try to scan ACPI0007 in addition to Processor.

That commit is between 2.6.34-rc1 and 2.6.34-rc2, so stable tree for 2.6.34+
need this patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -352,4 +352,5 @@ void __init acpi_early_processor_set_pdc
 	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    early_init_pdc, NULL, NULL, NULL);
+	acpi_get_devices("ACPI0007", early_init_pdc, NULL, NULL);
 }


