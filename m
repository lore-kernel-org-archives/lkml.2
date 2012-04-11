Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370Ab2DKXXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:23:48 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51108 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965357Ab2DKXXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:23:43 -0400
Message-Id: <20120411231043.275205804@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Svante Signell <svante.signell@telia.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 46/59] x86/PCI: use host bridge _CRS info on MSI MS-7253
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Nieder <jrnieder@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/pci/acpi.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -54,6 +54,17 @@ static const struct dmi_system_id pci_us
 			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
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
 


