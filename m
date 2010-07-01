Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab0GAVK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:10:57 -0400
Received: from kroah.org ([198.145.64.141]:47676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932751Ab0GAUuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:44 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:34 2010
Message-Id: <20100701173434.797714007@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gabor Gombas <gombasg@digikabel.hu>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [patch 095/164] x86, setup: Phoenix BIOS fixup is needed on Dell Inspiron Mini 1012
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Gombas <gombasg@digikabel.hu>

commit 3d6e77a3ddb8e4156b89f4273ff8c7d37abaf781 upstream.

The low-memory corruption checker triggers during suspend/resume, so we
need to reserve the low 64k.  Don't be fooled that the BIOS identifies
itself as "Dell Inc.", it's still Phoenix BIOS.

[ hpa: I think we blacklist almost every BIOS in existence.  We should
either change this to a whitelist or just make it unconditional. ]

Signed-off-by: Gabor Gombas <gombasg@digikabel.hu>
LKML-Reference: <201005241913.o4OJDIMM010877@imap1.linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -663,6 +663,17 @@ static struct dmi_system_id __initdata b
 			DMI_MATCH(DMI_BOARD_NAME, "DG45FC"),
 		},
 	},
+	/*
+	 * The Dell Inspiron Mini 1012 has DMI_BIOS_VENDOR = "Dell Inc.", so
+	 * match on the product name.
+	 */
+	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "Phoenix BIOS",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1012"),
+		},
+	},
 #endif
 	{}
 };


