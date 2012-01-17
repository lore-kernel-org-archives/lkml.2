Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2AQMaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:30:06 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:56401 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2AQMWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:08 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 05/50] ACPICA: Add error msg for unsupported I/O requests (not
 8/16/32 bit length)
Date: Tue, 17 Jan 2012 07:20:57 -0500
Message-id: <8519bc9f1e6db43a9b95b70ef0c7b61cb36d58e4.1326802229.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Found during ACPICA debugging.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/hwvalid.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpica/hwvalid.c b/drivers/acpi/acpica/hwvalid.c
index 5f16058..f8fbea9 100644
--- a/drivers/acpi/acpica/hwvalid.c
+++ b/drivers/acpi/acpica/hwvalid.c
@@ -134,6 +134,8 @@ acpi_hw_validate_io_request(acpi_io_address address, u32 bit_width)
 	/* Supported widths are 8/16/32 */
 
 	if ((bit_width != 8) && (bit_width != 16) && (bit_width != 32)) {
+		ACPI_ERROR((AE_INFO,
+			    "Bad BitWidth parameter: %8.8X", bit_width));
 		return AE_BAD_PARAMETER;
 	}
 
-- 
1.7.9.rc1

