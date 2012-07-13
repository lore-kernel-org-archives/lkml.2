Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161567Ab2GMPia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:38:30 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:43161 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab2GMPi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:38:28 -0400
Date: Fri, 13 Jul 2012 09:38:27 -0600
From: Khalid Aziz <khalid.aziz@hp.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, mikew@google.com, mjg@redhat.com,
        keescook@chromium.org, gong.chen@linux.intel.com
Subject: [PATCH] Add missing attributes to EFI variable attribute print out
 from sysfs
Message-ID: <20120713153827.GA8007@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the EFI variable attributes are missing from print out from
/sys/firmware/efi/vars/*/attributes. This patch adds those in.

Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
Cc: stable@vger.kernel.org
---
 drivers/firmware/efivars.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 47408e8..1e1ac75 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -441,6 +441,16 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
 		str += sprintf(str, "EFI_VARIABLE_BOOTSERVICE_ACCESS\n");
 	if (var->Attributes & 0x4)
 		str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");
+	if (var->Attributes & 0x8)
+		str += sprintf(str, "EFI_VARIABLE_HARDWARE_ERROR_RECORD\n");
+	if (var->Attributes & 0x10)
+		str += sprintf(str,
+			"EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS\n");
+	if (var->Attributes & 0x20)
+		str += sprintf(str,
+			"EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS\n");
+	if (var->Attributes & 0x40)
+		str += sprintf(str, "EFI_VARIABLE_APPEND_WRITE\n");
 	return str - buf;
 }
 
-- 
1.7.9.5

==================
Khalid Aziz
khalid.aziz@hp.com
