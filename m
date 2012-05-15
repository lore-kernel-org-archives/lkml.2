Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965617Ab2EOCYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:24:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:49876 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965564Ab2EOCSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 178/179] x86/PCI: use host bridge _CRS info on MSI MS-7253
Date: Mon, 14 May 2012 22:14:34 -0400
Message-ID: <1337048075-6132-179-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Nieder <jrnieder@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8411371709610c826bf65684f886bfdfb5780ca1 upstream.

In the spirit of commit 29cf7a30f8a0 ("x86/PCI: use host bridge _CRS
info on ASUS M2V-MX SE"), this DMI quirk turns on "pci_use_crs" by
default on a board that needs it.

This fixes boot failures and oopses introduced in 3e3da00c01d0
("x86/pci: AMD one chain system to use pci read out res").  The quirk
is quite targetted (to a specific board and BIOS version) for two
reasons:

 (1) to emphasize that this method of tackling the problem one quirk
     at a time is a little insane

 (2) to give BIOS vendors an opportunity to use simpler tables and
     allow us to return to generic behavior (whatever that happens to
     be) with a later BIOS update

In other words, I am not at all happy with having quirks like this.
But it is even worse for the kernel not to work out of the box on
these machines, so...

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=42619
Reported-by: Svante Signell <svante.signell@telia.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/pci/acpi.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 7743fb1..9b55642 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -43,6 +43,17 @@ static const struct dmi_system_id pci_use_crs_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ALiveSATA2-GLAN"),
                 },
         },
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=42619 */
+	{
+		.callback = set_use_crs,
+		.ident = "MSI MS-7253",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+			DMI_MATCH(DMI_BOARD_NAME, "MS-7253"),
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
+			DMI_MATCH(DMI_BIOS_VERSION, "V1.6"),
+		},
+	},
 	{}
 };
 
-- 
1.7.9.6

