Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab2GMRmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:42:20 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:41915 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab2GMRmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:42:18 -0400
Date: Fri, 13 Jul 2012 11:42:16 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, mikew@google.com, mjg@redhat.com,
        keescook@chromium.org, gong.chen@linux.intel.com
Subject: [PATCH v2] Add missing attributes to EFI variable attribute print
 out from sysfs
Message-ID: <20120713174216.GA10445@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the EFI variable attributes are missing from print out from
/sys/firmware/efi/vars/*/attributes. This patch adds those in. It also
updates code to use pre-defined constants for masking current value
of attributes.

Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
Cc: stable@vger.kernel.org
---
 drivers/firmware/efivars.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 47408e8..d10c987 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -435,12 +435,23 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
 	if (status != EFI_SUCCESS)
 		return -EIO;
 
-	if (var->Attributes & 0x1)
+	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
 		str += sprintf(str, "EFI_VARIABLE_NON_VOLATILE\n");
-	if (var->Attributes & 0x2)
+	if (var->Attributes & EFI_VARIABLE_BOOTSERVICE_ACCESS)
 		str += sprintf(str, "EFI_VARIABLE_BOOTSERVICE_ACCESS\n");
-	if (var->Attributes & 0x4)
+	if (var->Attributes & EFI_VARIABLE_RUNTIME_ACCESS)
 		str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");
+	if (var->Attributes & EFI_VARIABLE_HARDWARE_ERROR_RECORD)
+		str += sprintf(str, "EFI_VARIABLE_HARDWARE_ERROR_RECORD\n");
+	if (var->Attributes & EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS)
+		str += sprintf(str,
+			"EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS\n");
+	if (var->Attributes &
+			EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS)
+		str += sprintf(str,
+			"EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS\n");
+	if (var->Attributes & EFI_VARIABLE_APPEND_WRITE)
+		str += sprintf(str, "EFI_VARIABLE_APPEND_WRITE\n");
 	return str - buf;
 }
 
-- 
1.7.9.5

-- 
Khalid Aziz
khalid.aziz@hp.com
