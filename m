Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2HOUPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:15:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:36939 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab2HOTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Manoj Iyer <manoj.iyer@canonical.com>, Andy Lutomirski <luto@mit.edu>,
        Matthew Garrett <mjg@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 098/165] thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.
Date: Wed, 15 Aug 2012 15:47:22 -0400
Message-ID: <1345060109-9187-99-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9fbdaeb4f4dd14a0caa9fc35c496d5440c251a3a upstream.

The newer Lenovo ThinkPads have HKEY HID of LEN0068 instead
of IBM0068. Added new HID so that thinkpad_acpi module will
auto load on these newer Lenovo ThinkPads.

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Signed-off-by: Andy Lutomirski <luto@mit.edu>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/platform/x86/thinkpad_acpi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 63290b3..73d6ddc 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -123,7 +123,8 @@ enum {
 };
 
 /* ACPI HIDs */
-#define TPACPI_ACPI_HKEY_HID		"IBM0068"
+#define TPACPI_ACPI_IBM_HKEY_HID	"IBM0068"
+#define TPACPI_ACPI_LENOVO_HKEY_HID	"LEN0068"
 
 /* Input IDs */
 #define TPACPI_HKEY_INPUT_PRODUCT	0x5054 /* "TP" */
@@ -3850,7 +3851,8 @@ errexit:
 }
 
 static const struct acpi_device_id ibm_htk_device_ids[] = {
-	{TPACPI_ACPI_HKEY_HID, 0},
+	{TPACPI_ACPI_IBM_HKEY_HID, 0},
+	{TPACPI_ACPI_LENOVO_HKEY_HID, 0},
 	{"", 0},
 };
 
-- 
1.7.12.rc2

