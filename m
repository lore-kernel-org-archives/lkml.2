Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1ABH1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:27:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:37222 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab1ABH0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:26:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Colin Ian King <colin.king@canonical.com>,
        Len Brown <len.brown@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 209/260] ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume
Date: Sun,  2 Jan 2011 02:18:25 -0500
Message-Id: <1293952756-15010-210-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:59.0057 (UTC) FILETIME=[05BC0410:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/acpi/acpica/aclocal.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 24b8faa..3a739ba 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -848,6 +848,7 @@ struct acpi_bit_register_info {
 	ACPI_BITMASK_POWER_BUTTON_STATUS   | \
 	ACPI_BITMASK_SLEEP_BUTTON_STATUS   | \
 	ACPI_BITMASK_RT_CLOCK_STATUS       | \
+	ACPI_BITMASK_PCIEXP_WAKE_DISABLE   | \
 	ACPI_BITMASK_WAKE_STATUS)
 
 #define ACPI_BITMASK_TIMER_ENABLE               0x0001
-- 
1.7.3.3

