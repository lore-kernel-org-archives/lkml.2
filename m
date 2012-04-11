Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074Ab2DKXkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:40:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965359Ab2DKXXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:23:46 -0400
Message-Id: <20120411231043.454242935@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Carlos Luna <caralu74@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 47/59] x86/PCI: do not tie MSI MS-7253 use_crs quirk to BIOS version
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Nieder <jrnieder@gmail.com>

commit a97f4f5e524bcd09a85ef0b8821a14d35e69335f upstream.

Carlos was getting

	WARNING: at drivers/pci/pci.c:118 pci_ioremap_bar+0x24/0x52()

when probing his sound card, and sound did not work.  After adding
pci=use_crs to the kernel command line, no more trouble.

Ok, we can add a quirk.  dmidecode output reveals that this is an MSI
MS-7253, for which we already have a quirk, but the short-sighted
author tied the quirk to a single BIOS version, making it not kick in
on Carlos's machine with BIOS V1.2.  If a later BIOS update makes it
no longer necessary to look at the _CRS info it will still be
harmless, so let's stop trying to guess which versions have and don't
have accurate _CRS tables.

Addresses https://bugtrack.alsa-project.org/alsa-bug/view.php?id=5533
Also see <https://bugzilla.kernel.org/show_bug.cgi?id=42619>.

Reported-by: Carlos Luna <caralu74@gmail.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/pci/acpi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -62,7 +62,6 @@ static const struct dmi_system_id pci_us
 			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
 			DMI_MATCH(DMI_BOARD_NAME, "MS-7253"),
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
-			DMI_MATCH(DMI_BIOS_VERSION, "V1.6"),
 		},
 	},
 	{}


