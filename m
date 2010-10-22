Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0JVTCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:02:48 -0400
Received: from kroah.org ([198.145.64.141]:34433 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759508Ab0JVS5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:06 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:35 2010
Message-Id: <20101022185235.321410415@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:52:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Colin Ian King <colin.king@canonical.com>,
        Len Brown <len.brown@intel.com>
Subject: [089/103] ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit 573b638158029898caf9470c8214b7ddd29751e3 upstream.

Section 4.7.3.1.1 (PM1 Status Registers) of version 4.0 of
the ACPI spec concerning PCIEXP_WAKE_STS points out in
in the final note field in table 4-11 that if this bit is
set to 1 and the system is put into a sleeping state then
the system will not automatically wake.

This bit gets set by hardware to indicate that the system
woke up due to a PCI Express wakeup event, so clear it during
acpi_hw_clear_acpi_status() calls to enable subsequent
resumes to work.

BugLink: http://bugs.launchpad.net/bugs/613381

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/acpica/aclocal.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -853,6 +853,7 @@ struct acpi_bit_register_info {
 	ACPI_BITMASK_POWER_BUTTON_STATUS   | \
 	ACPI_BITMASK_SLEEP_BUTTON_STATUS   | \
 	ACPI_BITMASK_RT_CLOCK_STATUS       | \
+	ACPI_BITMASK_PCIEXP_WAKE_DISABLE   | \
 	ACPI_BITMASK_WAKE_STATUS)
 
 #define ACPI_BITMASK_TIMER_ENABLE               0x0001


