Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1HFAK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:10:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221Ab1HFAKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:10:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:13 2011
Message-Id: <20110806000413.150733066@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [16/50] x86: Make Dell Latitude E5420 use reboot=pci
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -469,6 +469,14 @@ static struct dmi_system_id __initdata p
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
 


