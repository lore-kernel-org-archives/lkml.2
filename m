Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2BEWoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:44:18 -0500
Received: from 1wt.eu ([62.212.114.60]:61881 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab2BEW0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:21 -0500
Message-Id: <20120205220950.770337257@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:20 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 31/91] x86: Make Dell Latitude E5420 use reboot=pci
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 8 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/arch/x86/kernel/reboot.c
===================================================================
--- longterm-2.6.27.orig/arch/x86/kernel/reboot.c	2012-02-05 22:34:34.087914934 +0100
+++ longterm-2.6.27/arch/x86/kernel/reboot.c	2012-02-05 22:34:39.265915394 +0100
@@ -227,6 +227,14 @@
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
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
 


