Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161815Ab2GLXee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:34:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58753 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161761Ab2GLWkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>,
        x86@kernel.org
Subject: [ 081/187] ACPI, x86: fix Dell M6600 ACPI reboot regression via DMI
Date: Thu, 12 Jul 2012 15:33:57 -0700
Message-Id: <20120712191529.930920177@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 76eb9a30db4bc8fd172f9155247264b5f2686d7b upstream.

Dell Precision M6600 is known to require PCI reboot, so add it to
the reboot blacklist in pci_reboot_dmi_table[].

https://bugzilla.kernel.org/show_bug.cgi?id=42749

cc: x86@kernel.org
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -471,6 +471,14 @@ static struct dmi_system_id __initdata p
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Precision M6600. */
+		.callback = set_pci_reboot,
+		.ident = "Dell OptiPlex 990",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
+		},
+	},
 	{ }
 };
 


