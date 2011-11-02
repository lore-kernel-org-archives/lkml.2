Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab1KCBh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:37:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab1KCBhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:59 2011
Message-Id: <20111102221459.091971994@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Manoj Iyer <manoj.iyer@canonical.com>,
        Andy Lutomirski <luto@mit.edu>, Matthew Garrett <mjg@redhat.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        =?ISO-8859-15?q?Bj=F8rn=20Mork?= <bjorn@mork.no>
Subject: [098/107] thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Manoj Iyer <manoj.iyer@canonical.com>

commit 9fbdaeb4f4dd14a0caa9fc35c496d5440c251a3a upstream.

The newer Lenovo ThinkPads have HKEY HID of LEN0068 instead
of IBM0068. Added new HID so that thinkpad_acpi module will
auto load on these newer Lenovo ThinkPads.

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: stable@vger.kernel.org
Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Signed-off-by: Andy Lutomirski <luto@mit.edu>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -118,7 +118,9 @@ enum {
 };
 
 /* ACPI HIDs */
-#define TPACPI_ACPI_HKEY_HID		"IBM0068"
+#define TPACPI_ACPI_IBM_HKEY_HID	"IBM0068"
+#define TPACPI_ACPI_LENOVO_HKEY_HID	"LEN0068"
+#define TPACPI_ACPI_EC_HID		"PNP0C09"
 
 /* Input IDs */
 #define TPACPI_HKEY_INPUT_PRODUCT	0x5054 /* "TP" */
@@ -3840,7 +3842,8 @@ errexit:
 }
 
 static const struct acpi_device_id ibm_htk_device_ids[] = {
-	{TPACPI_ACPI_HKEY_HID, 0},
+	{TPACPI_ACPI_IBM_HKEY_HID, 0},
+	{TPACPI_ACPI_LENOVO_HKEY_HID, 0},
 	{"", 0},
 };
 


