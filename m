Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1HAX1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:27:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab1HAX0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:56 2011
Message-Id: <20110801232055.927090096@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [53/70] x86: Make Dell Latitude E5420 use reboot=pci
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel J Blueman <daniel.blueman@gmail.com>

commit b7798d28ec15d20fd34b70fa57eb13f0cf6d1ecd upstream.

Rebooting on the Dell E5420 often hangs with the keyboard or ACPI
methods, but is reliable via the PCI method.

[ hpa: this was deferred because we believed for a long time that the
  recent reshuffling of the boot priorities in commit
  660e34cebf0a11d54f2d5dd8838607452355f321 fixed this platform.
  Unfortunately that turned out to be incorrect. ]

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Link: http://lkml.kernel.org/r/1305248699-2347-1-git-send-email-daniel.blueman@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -411,6 +411,14 @@ static struct dmi_system_id __initdata p
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E5420. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E5420",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
+		},
+	},
 	{ }
 };
 


