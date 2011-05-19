Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab1ESSYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:24:05 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52315 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933758Ab1ESSHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:50 -0400
X-Sasl-enc: 4JrIOz3y3T9vL4n6TSAB0paVT+cOCVq2qiIvmDUVYsin 1305828469
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:55 2011
Message-Id: <20110519180555.057280654@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Manoj Iyer <manoj.iyer@canonical.com>, Andy Lutomirski <luto@mit.edu>,
        Matthew Garrett <mjg@redhat.com>
Subject: [08/71] thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Manoj Iyer <manoj.iyer@canonical.com>

commit 9fbdaeb4f4dd14a0caa9fc35c496d5440c251a3a upstream.

The newer Lenovo ThinkPads have HKEY HID of LEN0068 instead
of IBM0068. Added new HID so that thinkpad_acpi module will
auto load on these newer Lenovo ThinkPads.

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Signed-off-by: Andy Lutomirski <luto@mit.edu>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -128,7 +128,8 @@ enum {
 };
 
 /* ACPI HIDs */
-#define TPACPI_ACPI_HKEY_HID		"IBM0068"
+#define TPACPI_ACPI_IBM_HKEY_HID	"IBM0068"
+#define TPACPI_ACPI_LENOVO_HKEY_HID	"LEN0068"
 #define TPACPI_ACPI_EC_HID		"PNP0C09"
 
 /* Input IDs */
@@ -3879,7 +3880,8 @@ errexit:
 }
 
 static const struct acpi_device_id ibm_htk_device_ids[] = {
-	{TPACPI_ACPI_HKEY_HID, 0},
+	{TPACPI_ACPI_IBM_HKEY_HID, 0},
+	{TPACPI_ACPI_LENOVO_HKEY_HID, 0},
 	{"", 0},
 };
 


