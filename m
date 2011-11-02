Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934923Ab1KCBnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:43:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934759Ab1KCBnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:43:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:48 2011
Message-Id: <20111102222748.274746654@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Manoj Iyer <manoj.iyer@canonical.com>,
        Andy Lutomirski <luto@mit.edu>, Matthew Garrett <mjg@redhat.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        =?ISO-8859-15?q?Bj=F8rn=20Mork?= <bjorn@mork.no>
Subject: [093/101] thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -122,7 +122,9 @@ enum {
 };
 
 /* ACPI HIDs */
-#define TPACPI_ACPI_HKEY_HID		"IBM0068"
+#define TPACPI_ACPI_IBM_HKEY_HID	"IBM0068"
+#define TPACPI_ACPI_LENOVO_HKEY_HID	"LEN0068"
+#define TPACPI_ACPI_EC_HID		"PNP0C09"
 
 /* Input IDs */
 #define TPACPI_HKEY_INPUT_PRODUCT	0x5054 /* "TP" */
@@ -3849,7 +3851,8 @@ errexit:
 }
 
 static const struct acpi_device_id ibm_htk_device_ids[] = {
-	{TPACPI_ACPI_HKEY_HID, 0},
+	{TPACPI_ACPI_IBM_HKEY_HID, 0},
+	{TPACPI_ACPI_LENOVO_HKEY_HID, 0},
 	{"", 0},
 };
 


