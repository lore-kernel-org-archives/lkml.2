Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2ADQbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:31:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab2ADQbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:31:09 -0500
Date: Wed, 4 Jan 2012 11:30:52 -0500
From: Dave Jones <davej@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Add Thinkpad SL510 to pci=nocrs blacklist
Message-ID: <20120104163052.GA31667@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling CRS by default breaks suspend on the Thinkpad SL510.
Details in https://bugzilla.redhat.com/show_bug.cgi?id=769657

Reported-by: Stefan Kirrmann <stefan.kirrmann@gmail.com>
Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-3.1.noarch/arch/x86/pci/acpi.c~	2011-12-30 14:42:43.495717907 -0500
+++ linux-3.1.noarch/arch/x86/pci/acpi.c	2011-12-30 14:45:09.296198024 -0500
@@ -72,6 +72,16 @@ static const struct dmi_system_id pci_us
 			DMI_MATCH(DMI_BOARD_NAME, "0M273C"),
 		},
 	},
+	/* https://bugzilla.redhat.com/show_bug.cgi?id=769657 */
+	{
+		.callback = set_nouse_crs,
+		.ident = "Thinkpad SL510",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_BOARD_NAME, "2847DFG"),
+			DMI_MATCH(DMI_BIOS_VERSION, "6JET85WW (1.43 )"),
+		},
+	},
 	{}
 };
 

